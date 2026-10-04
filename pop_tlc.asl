state("TheLostCrown") {}
state("TheLostCrown_plus") {}

startup
{
    // Load Settings from XML
    Action<IEnumerable<System.Xml.Linq.XElement>, string> loadSettingsRecursive = null;
    loadSettingsRecursive = (elements, defaultParent) => {
        foreach (var el in elements) {
            var idAttr = el.Attribute("Id");
            var labelAttr = el.Attribute("Label");
            var stateAttr = el.Attribute("State");
            var parentAttr = el.Attribute("Parent");
            var tipAttr = el.Attribute("ToolTip");

            string id = idAttr != null ? idAttr.Value : (labelAttr != null ? labelAttr.Value : null);
            if (string.IsNullOrEmpty(id)) continue;

            string label = labelAttr != null ? labelAttr.Value : id;
            bool state = true;
            if (stateAttr != null) {
                bool parsed;
                if (bool.TryParse(stateAttr.Value, out parsed)) state = parsed;
            }

            string parent = parentAttr != null ? parentAttr.Value : defaultParent;
            settings.Add(id, state, label, parent);

            if (tipAttr != null && !string.IsNullOrEmpty(tipAttr.Value)) {
                settings.SetToolTip(id, tipAttr.Value);
            }

            var children = el.Elements("Setting");
            if (children != null && children.Any()) {
                loadSettingsRecursive(children, id);
            }
        }
    };

    string[] searchPaths = new string[] {
        "Components/POPTLC.Settings.xml",
        "settings/POPTLC.Settings.xml",
        "POPTLC.Settings.xml"
    };

    string xmlFile = searchPaths.FirstOrDefault(p => File.Exists(p));
    if (xmlFile != null) {
        var doc = System.Xml.Linq.XDocument.Load(xmlFile);
        if (doc.Root != null) {
            loadSettingsRecursive(doc.Root.Elements("Setting"), null);
        }
    } else {
        throw new FileNotFoundException("POPTLC.Settings.xml not found in Components/, settings/, or current folder.");
    }

    // Logging and helper actions
    vars.Log = (Action<object>)(msg => {
        print("[TLC] " + (msg != null ? msg.ToString() : "null"));
    });

    vars.Watch = (Action<IDictionary<string, object>, IDictionary<string, object>, string>)((oldLookup, currentLookup, key) => {
        var oldValue = oldLookup.ContainsKey(key) ? oldLookup[key] : null;
        var currentValue = currentLookup.ContainsKey(key) ? currentLookup[key] : null;

        if (oldValue != null && currentValue != null && !oldValue.Equals(currentValue))
            vars.Log(key + ": " + oldValue + " -> " + currentValue);
    });

    vars.CompletedSplits = new HashSet<string>();
    vars.IGTTicks = 0L;
    vars.mode = 0; // 0: Not running, 1: Full game, 2: DLC, 3: Divine Trials IL
    vars.ready = false;
    vars.gaBase = IntPtr.Zero;
    vars.upBase = IntPtr.Zero;
    vars.lastInvLogTime = Stopwatch.StartNew();

    if (timer.CurrentTimingMethod != TimingMethod.GameTime) {
        DialogResult mbox = MessageBox.Show(timer.Form,
            "This game uses an in-game timer as the primary timing method.\nWould you like to switch to Game Time?",
            "LiveSplit | Prince of Persia: The Lost Crown",
            MessageBoxButtons.YesNo);

        if (mbox == DialogResult.Yes) {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

init
{
    vars.NORMAL_START_SCENE = "KIN_BAT_02";
    vars.DLC_START_SCENE = "RAD_INT_01_BATTLEFIELD";
    vars.MAIN_MENU_SCENE = "GameManager";
    vars.ready = false;
    vars.gaBase = IntPtr.Zero;
    vars.upBase = IntPtr.Zero;

    // Memory reading helpers (safe against Win32Exception during game launch/exit)
    vars.ReadPtr = (Func<IntPtr, IntPtr>)(addr => {
        if (addr == IntPtr.Zero || game == null) return IntPtr.Zero;
        try {
            IntPtr val;
            return game.ReadPointer(addr, out val) ? val : IntPtr.Zero;
        } catch { return IntPtr.Zero; }
    });

    vars.ReadInt = (Func<IntPtr, int>)(addr => {
        if (addr == IntPtr.Zero || game == null) return 0;
        try {
            int val;
            return game.ReadValue<int>(addr, out val) ? val : 0;
        } catch { return 0; }
    });

    vars.ReadBool = (Func<IntPtr, bool>)(addr => {
        if (addr == IntPtr.Zero || game == null) return false;
        try {
            bool val;
            return game.ReadValue<bool>(addr, out val) ? val : false;
        } catch { return false; }
    });

    vars.ReadDouble = (Func<IntPtr, double>)(addr => {
        if (addr == IntPtr.Zero || game == null) return 0.0;
        try {
            double val;
            return game.ReadValue<double>(addr, out val) ? val : 0.0;
        } catch { return 0.0; }
    });

    vars.ReadUtf8 = (Func<IntPtr, int, string>)((addr, maxLen) => {
        if (addr == IntPtr.Zero || game == null) return null;
        try {
            var bytes = game.ReadBytes(addr, maxLen);
            if (bytes == null || bytes.Length == 0) return null;
            int len = 0;
            while (len < bytes.Length && bytes[len] != 0) len++;
            return len > 0 ? System.Text.Encoding.UTF8.GetString(bytes, 0, len) : null;
        } catch { return null; }
    });

    vars.ReadIL2CppString = (Func<IntPtr, string>)(ptr => {
        if (ptr == IntPtr.Zero || game == null) return null;
        try {
            int len;
            if (!game.ReadValue<int>(ptr + 0x10, out len) || len <= 0 || len > 512) return null;
            var bytes = game.ReadBytes(ptr + 0x14, len * 2);
            if (bytes == null) return null;
            return System.Text.Encoding.Unicode.GetString(bytes);
        } catch { return null; }
    });

    // Helper to dereference IL2CPP Singleton<T>
    // Pattern: [TypeInfo] -> klass -> [+0x58] parent -> [+0xB8] statics -> [+0x0] m_instance
    vars.GetSingleton = (Func<int, IntPtr>)(typeInfoRva => {
        if (vars.gaBase == IntPtr.Zero) return IntPtr.Zero;
        IntPtr klass = vars.ReadPtr(vars.gaBase + typeInfoRva);
        if (klass == IntPtr.Zero) return IntPtr.Zero;
        IntPtr parent = vars.ReadPtr(klass + 0x58);
        if (parent == IntPtr.Zero) return IntPtr.Zero;
        IntPtr statics = vars.ReadPtr(parent + 0xB8);
        if (statics == IntPtr.Zero) return IntPtr.Zero;
        return vars.ReadPtr(statics);
    });

    // Ability checker
    vars.CheckIfAbilityUnlocked = (Func<IntPtr, bool>)(ability => {
        if (ability == IntPtr.Zero) return false;
        return vars.ReadBool(ability + 0x20); // Ability.m_enabled
    });

    // Split handler helper
    vars.CheckSplit = (Func<string, bool>)(key => {
        if (!settings.SplitEnabled || timer.CurrentPhase != TimerPhase.Running) {
            return false;
        }

        if (!settings.ContainsKey(key)
          || !settings[key]
          || !vars.CompletedSplits.Add(key)
        ) {
            return false;
        }

        vars.Log("Completed: " + key);
        return true;
    });

    current.activeScene = "";
    current.level = "";
    current.shortLevel = "";
    current.inputMode = 0;
    current.playerAction = 0;
    current.isPaused = false;
    current.isClairvoyanceUnlocked = false;
    current.amuletCapacity = 0;
    current.speedrunTimer = 0.0;
    current.challengeType = 0;
    current.challengeState = 0;
    current.boss1LocId = 0;
    current.boss1Health = 0;
    current.boss2Health = 0;
    current.lootCount = 0;
    current.lootTypes = new List<int>();
    current.unlockableAbilities = new List<IntPtr>();
    current.availableAmulets = new List<int>();
    current.inventory = new Dictionary<int, int>();
    current.itemLootCount = new Dictionary<int, int>();
}

exit
{
    vars.ready = false;
    vars.gaBase = IntPtr.Zero;
    vars.upBase = IntPtr.Zero;
}

shutdown
{
    vars.ready = false;
    vars.gaBase = IntPtr.Zero;
    vars.upBase = IntPtr.Zero;
    vars.mode = 0;
    vars.IGTTicks = 0L;
}

update
{
    if (game == null) return false;
    try {
        if (game.HasExited) return false;
    } catch {
        return false;
    }

    try {
        // Deferred initialization:
        // Wait until both GameAssembly.dll and UnityPlayer.dll are loaded
        // and IL2CPP static class tables / Unity scene managers are initialized.
        if (!vars.ready) {
            game.Refresh();

            ProcessModule gaModule = null;
            ProcessModule upModule = null;

            foreach (ProcessModule m in game.Modules) {
                if (gaModule == null && (
                    m.ModuleName.Equals("GameAssembly.dll", StringComparison.OrdinalIgnoreCase) ||
                    m.ModuleName.Equals("GameAssembly_plus.dll", StringComparison.OrdinalIgnoreCase))) {
                    gaModule = m;
                }
                if (upModule == null && m.ModuleName.Equals("UnityPlayer.dll", StringComparison.OrdinalIgnoreCase)) {
                    upModule = m;
                }
                if (gaModule != null && upModule != null) break;
            }

            if (gaModule == null || upModule == null) return false;
            if (gaModule.BaseAddress == IntPtr.Zero || upModule.BaseAddress == IntPtr.Zero) return false;

            IntPtr gaBase = gaModule.BaseAddress;
            IntPtr upBase = upModule.BaseAddress;

            // Verify IL2CPP runtime and UnityPlayer are ready to read
            // PauseManager TypeInfo: gaBase + 0x359B678
            IntPtr pmClass = IntPtr.Zero;
            if (!game.ReadPointer(gaBase + 0x359B678, out pmClass) || pmClass == IntPtr.Zero) {
                return false;
            }

            // Statics pointer in PauseManager class (+0xB8)
            IntPtr pmStatics = IntPtr.Zero;
            if (!game.ReadPointer(pmClass + 0xB8, out pmStatics) || pmStatics == IntPtr.Zero) {
                return false;
            }

            // g_runtimeSceneManager: upBase + 0x1B1FEB0
            IntPtr sceneMgr = IntPtr.Zero;
            if (!game.ReadPointer(upBase + 0x1B1FEB0, out sceneMgr) || sceneMgr == IntPtr.Zero) {
                return false;
            }

            // ActiveScene pointer at +0x48
            IntPtr activeScene = IntPtr.Zero;
            if (!game.ReadPointer(sceneMgr + 0x48, out activeScene) || activeScene == IntPtr.Zero) {
                return false;
            }

            vars.gaBase = gaBase;
            vars.upBase = upBase;
            vars.ready = true;
            vars.Log("Successfully hooked: GameAssembly=0x" + gaBase.ToString("X") + ", UnityPlayer=0x" + upBase.ToString("X"));
        }

        if (!vars.ready) return false;

        IntPtr gaBaseActive = vars.gaBase;
        IntPtr upBaseActive = vars.upBase;

        // Active Scene Name
        // g_runtimeSceneManager: UnityPlayer.dll + 0x1B1FEB0
        // ActiveScene at +0x48 -> AssetPath string ptr at +0x10 -> Path.GetFileNameWithoutExtension
        if (upBaseActive != IntPtr.Zero) {
            IntPtr sceneMgr = vars.ReadPtr(upBaseActive + 0x1B1FEB0);
            if (sceneMgr != IntPtr.Zero) {
                IntPtr activeSceneObj = vars.ReadPtr(sceneMgr + 0x48);
                if (activeSceneObj != IntPtr.Zero) {
                    IntPtr assetPathPtr = vars.ReadPtr(activeSceneObj + 0x10);
                    string path = vars.ReadUtf8(assetPathPtr, 256);
                    if (!string.IsNullOrEmpty(path)) {
                        current.activeScene = System.IO.Path.GetFileNameWithoutExtension(path);
                    }
                }
            }
        }
        if (string.IsNullOrEmpty(current.activeScene) && old.activeScene != null) {
            current.activeScene = old.activeScene;
        }

        // PauseManager TypeInfo: GameAssembly.dll + 0x359B678
        IntPtr pmClassObj = vars.ReadPtr(gaBaseActive + 0x359B678);
        IntPtr pmStaticsObj = pmClassObj != IntPtr.Zero ? vars.ReadPtr(pmClassObj + 0xB8) : IntPtr.Zero;

        if (pmStaticsObj != IntPtr.Zero) {
            current.isPaused = vars.ReadBool(pmStaticsObj + 0x10);

            IntPtr pc = vars.ReadPtr(pmStaticsObj + 0x28); // m_PlayerComponent
            if (pc != IntPtr.Zero) {
                // PlayerInput -> m_inputStateInfo (+0x48) -> m_inputMode (+0x68)
                IntPtr pInput = vars.ReadPtr(pc + 0x310);
                if (pInput != IntPtr.Zero) {
                    IntPtr inputInfo = vars.ReadPtr(pInput + 0x48);
                    current.inputMode = vars.ReadInt(inputInfo + 0x68);
                }

                // PlayerAbilities -> m_stateInfo (+0xA8)
                IntPtr pAbil = vars.ReadPtr(pc + 0x328);
                if (pAbil != IntPtr.Zero) {
                    IntPtr abilInfo = vars.ReadPtr(pAbil + 0xA8);
                    if (abilInfo != IntPtr.Zero) {
                        // m_isClairvoyanceEnabled (+0xC8)
                        current.isClairvoyanceUnlocked = vars.ReadBool(abilInfo + 0xC8);

                        // m_ability (+0x1B0) -> m_currentPlayerActionInternal (+0x84)
                        IntPtr actAbil = vars.ReadPtr(abilInfo + 0x1B0);
                        current.playerAction = vars.ReadInt(actAbil + 0x84);

                        // m_unlockableAbilities (List<Ability>) (+0x280)
                        IntPtr listPtr = vars.ReadPtr(abilInfo + 0x280);
                        current.unlockableAbilities = new List<IntPtr>();
                        if (listPtr != IntPtr.Zero) {
                            IntPtr itemsArr = vars.ReadPtr(listPtr + 0x10);
                            int listSize = vars.ReadInt(listPtr + 0x18);
                            if (itemsArr != IntPtr.Zero && listSize > 0 && listSize < 100) {
                                for (int i = 0; i < listSize; i++) {
                                    current.unlockableAbilities.Add(vars.ReadPtr(itemsArr + 0x20 + (i * 8)));
                                }
                            }
                        }
                    }
                }

                // PlayerStoneOfKnowledge (+0x378) -> StateInfo (+0x40) -> m_maxStonePoints (+0x24) & m_availableStones (+0x38)
                IntPtr psok = vars.ReadPtr(pc + 0x378);
                current.availableAmulets = new List<int>();
                if (psok != IntPtr.Zero) {
                    IntPtr sokInfo = vars.ReadPtr(psok + 0x40);
                    if (sokInfo != IntPtr.Zero) {
                        int cap = vars.ReadInt(sokInfo + 0x24);
                        if (cap > 0) current.amuletCapacity = cap;

                        IntPtr stonesList = vars.ReadPtr(sokInfo + 0x38);
                        if (stonesList != IntPtr.Zero) {
                            IntPtr itemsArr = vars.ReadPtr(stonesList + 0x10);
                            int count = vars.ReadInt(stonesList + 0x18);
                            if (itemsArr != IntPtr.Zero && count > 0 && count < 100) {
                                byte[] raw = game.ReadBytes(itemsArr + 0x20, count * 4);
                                if (raw != null) {
                                    for (int i = 0; i < count; i++) {
                                        current.availableAmulets.Add(BitConverter.ToInt32(raw, i * 4));
                                    }
                                }
                            }
                        }
                    }
                }

                // PlayerInventory (+0x370) -> StateInfo (+0x40)
                IntPtr pInv = vars.ReadPtr(pc + 0x370);
                current.inventory = new Dictionary<int, int>();
                current.itemLootCount = new Dictionary<int, int>();
                if (pInv != IntPtr.Zero) {
                    IntPtr invInfo = vars.ReadPtr(pInv + 0x40);
                    if (invInfo != IntPtr.Zero) {
                        // m_inventory (+0x10): Dictionary<EItemType, InventoryItem>
                        IntPtr invDict = vars.ReadPtr(invInfo + 0x10);
                        if (invDict != IntPtr.Zero) {
                            IntPtr entries = vars.ReadPtr(invDict + 0x18);
                            int count = vars.ReadInt(invDict + 0x20);
                            if (entries != IntPtr.Zero && count > 0 && count < 200) {
                                byte[] raw = game.ReadBytes(entries + 0x20, count * 24);
                                if (raw != null) {
                                    for (int i = 0; i < count; i++) {
                                        int hash = BitConverter.ToInt32(raw, i * 24);
                                        if (hash >= 0) {
                                            int key = BitConverter.ToInt32(raw, i * 24 + 8);
                                            IntPtr itemObj = (IntPtr)BitConverter.ToInt64(raw, i * 24 + 16);
                                            int amount = (itemObj != IntPtr.Zero) ? vars.ReadInt(itemObj + 0x14) : 0;
                                            current.inventory[key] = amount;
                                        }
                                    }
                                }
                            }
                        }

                        // m_itemLootCount (+0x80): Dictionary<EItemType, int>
                        IntPtr dictPtr = vars.ReadPtr(invInfo + 0x80);
                        if (dictPtr != IntPtr.Zero) {
                            IntPtr entries = vars.ReadPtr(dictPtr + 0x18);
                            int count = vars.ReadInt(dictPtr + 0x20);
                            if (entries != IntPtr.Zero && count > 0 && count < 200) {
                                byte[] raw = game.ReadBytes(entries + 0x20, count * 16);
                                if (raw != null) {
                                    for (int i = 0; i < count; i++) {
                                        int hash = BitConverter.ToInt32(raw, i * 16);
                                        if (hash >= 0) {
                                            int key = BitConverter.ToInt32(raw, i * 16 + 8);
                                            int val = BitConverter.ToInt32(raw, i * 16 + 12);
                                            current.itemLootCount[key] = val;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // LootManager TypeInfo: GameAssembly.dll + 0x35AA360
        IntPtr lmInst = vars.GetSingleton(0x35AA360);
        current.lootTypes = new List<int>();
        current.lootCount = 0;
        if (lmInst != IntPtr.Zero) {
            // m_saveData (LootSaveData) at +0x88 -> m_data (List<LootSaveData.EntryData>) at +0x10
            IntPtr saveData = vars.ReadPtr(lmInst + 0x88);
            if (saveData != IntPtr.Zero) {
                IntPtr dataList = vars.ReadPtr(saveData + 0x10);
                if (dataList != IntPtr.Zero) {
                    IntPtr itemsArr = vars.ReadPtr(dataList + 0x10);
                    int size = vars.ReadInt(dataList + 0x18);
                    if (itemsArr != IntPtr.Zero && size > 0 && size < 500) {
                        current.lootCount = size;
                        for (int i = 0; i < size; i++) {
                            IntPtr entry = vars.ReadPtr(itemsArr + 0x20 + (i * 8));
                            if (entry != IntPtr.Zero) {
                                // EntryData: m_type is at +0x2C
                                current.lootTypes.Add(vars.ReadInt(entry + 0x2C));
                            }
                        }
                    }
                }
            }

            IntPtr curLvlInst = vars.ReadPtr(lmInst + 0x90);
            if (curLvlInst != IntPtr.Zero) {
                IntPtr lvlData = vars.ReadPtr(curLvlInst + 0x10);
                if (lvlData != IntPtr.Zero) {
                    current.level = vars.ReadIL2CppString(vars.ReadPtr(lvlData + 0x28)) ?? "";
                    current.shortLevel = vars.ReadIL2CppString(vars.ReadPtr(lvlData + 0x38)) ?? "";
                }
            }
        }

        // SpeedrunManager TypeInfo: GameAssembly.dll + 0x35A7F00
        IntPtr smInst = vars.GetSingleton(0x35A7F00);
        if (smInst != IntPtr.Zero) {
            IntPtr smMain = vars.ReadPtr(smInst + 0x88);
            if (smMain != IntPtr.Zero) {
                current.speedrunTimer = vars.ReadDouble(smMain + 0x20);
            }
        }

        // ChallengeManager TypeInfo: GameAssembly.dll + 0x359BAA0
        IntPtr cmInst = vars.GetSingleton(0x359BAA0);
        if (cmInst != IntPtr.Zero) {
            current.challengeType = vars.ReadInt(cmInst + 0x90);
            IntPtr handler = vars.ReadPtr(cmInst + 0x88);
            if (handler != IntPtr.Zero) {
                current.challengeState = vars.ReadInt(handler + 0x40);
            }
        }

        // UIManager (Boss Health Bars)
        // typeInfoDefinitionTable: [GameAssembly.dll + 0x37486D8] -> entry 4449 (offset 4449 * 8 = 0x8AF8)
        current.boss1Health = 0;
        current.boss2Health = 0;
        current.boss1LocId = 0;

        IntPtr table = vars.ReadPtr(gaBaseActive + 0x37486D8);
        if (table != IntPtr.Zero) {
            IntPtr uimClass = vars.ReadPtr(table + (4449 * 8));
            if (uimClass != IntPtr.Zero) {
                IntPtr uimParent = vars.ReadPtr(uimClass + 0x58);
                if (uimParent != IntPtr.Zero) {
                    IntPtr uimStatics = vars.ReadPtr(uimParent + 0xB8);
                    if (uimStatics != IntPtr.Zero) {
                        IntPtr uimInst = vars.ReadPtr(uimStatics);
                        if (uimInst != IntPtr.Zero) {
                            IntPtr bossBar1 = vars.ReadPtr(uimInst + 0x3E8);
                            IntPtr bossBar2 = vars.ReadPtr(uimInst + 0x3F0);

                            if (bossBar1 != IntPtr.Zero) {
                                IntPtr hsi1 = vars.ReadPtr(bossBar1 + 0x48);
                                if (hsi1 != IntPtr.Zero) current.boss1Health = vars.ReadInt(hsi1 + 0x28);

                                IntPtr ed1 = vars.ReadPtr(bossBar1 + 0x58);
                                if (ed1 != IntPtr.Zero) {
                                    IntPtr uisli1 = vars.ReadPtr(ed1 + 0x18);
                                    if (uisli1 != IntPtr.Zero) current.boss1LocId = vars.ReadInt(uisli1 + 0x10);
                                }
                            }

                            if (bossBar2 != IntPtr.Zero) {
                                IntPtr hsi2 = vars.ReadPtr(bossBar2 + 0x48);
                                if (hsi2 != IntPtr.Zero) current.boss2Health = vars.ReadInt(hsi2 + 0x28);
                            }
                        }
                    }
                }
            }
        }

        vars.Watch(old, current, "activeScene");
        vars.Watch(old, current, "level");
        vars.Watch(old, current, "shortLevel");
        vars.Watch(old, current, "inputMode");
        vars.Watch(old, current, "boss1LocId");
        vars.Watch(old, current, "lootCount");
        vars.Watch(old, current, "amuletCapacity");

        if (old.lootCount != null && current.lootCount > old.lootCount) {
            for (int i = old.lootCount; i < current.lootCount; i++) {
                vars.Log("New Loot Added: index=" + i + ", type=" + current.lootTypes[i]);
            }
        }
    } catch {
        return false;
    }
}

onStart
{
    timer.IsGameTimePaused = true;

    // Refresh all splits when we start the run, none are yet completed
    vars.CompletedSplits.Clear();

    vars.Log(settings.SplitEnabled);
    vars.Log(current.isPaused);
    vars.Log(current.level);
    vars.Log(current.inputMode);
    vars.Log(current.playerAction);

    vars.Log(current.boss1LocId);
    vars.Log(current.boss1Health);
    vars.Log(current.boss2Health);
}

onReset
{
    vars.IGTTicks = 0L;
    vars.mode = 0;
}

start
{
    if (old.activeScene == "UIManager") return false;

    if (current.activeScene == vars.NORMAL_START_SCENE && old.activeScene == vars.NORMAL_START_SCENE) {
        vars.mode = 1;
    }
    else if (current.activeScene == vars.DLC_START_SCENE && old.activeScene != vars.DLC_START_SCENE) {
        vars.mode = 2;
    }
    else if (current.challengeType == 6 && old.challengeState == 2 && current.challengeState == 4 && current.speedrunTimer > 0) {
        vars.mode = 3;
    }

    if (vars.mode > 0) {
        vars.IGTTicks = 0L;
        return true;
    }
}

reset
{
    // Auto-reset only for Divine Trials
    return (vars.mode == 3 && current.challengeState != 4 && current.challengeState != 8);
}

isLoading
{
    return true;
}

gameTime
{
    long currentTicks = (long)Math.Round(current.speedrunTimer * 10000000.0);
    long oldTicks = (long)Math.Round(old.speedrunTimer * 10000000.0);
    long tickDelta = currentTicks - oldTicks;

    if (oldTicks > 0 && tickDelta > 0) {
        vars.IGTTicks += tickDelta;
    }

    // IGT doesn't start until cutscene is playing in the opening scene of the respective categories
    if ((current.activeScene == vars.NORMAL_START_SCENE || (current.activeScene == vars.DLC_START_SCENE && vars.mode == 2)) && current.inputMode == 3) {
        vars.IGTTicks = 0L;
    }

    return TimeSpan.FromTicks(vars.IGTTicks);
}

split
{
    if (current.activeScene == vars.MAIN_MENU_SCENE) return false;

    if (vars.mode != 3) {
        if (settings["abilites"]) {
            for (int index = 0; index < current.unlockableAbilities.Count; index++) {
                if (vars.CheckIfAbilityUnlocked(current.unlockableAbilities[index]) && vars.CheckSplit("ability__" + index)) {
                    return true;
                }
            }
            if (current.isClairvoyanceUnlocked && vars.CheckSplit("clairvoyance")) {
                return true;
            }
        }

        if (settings["collectibles"]) {
            for (int i = 0; i < current.lootTypes.Count; i++) {
                int itemType = current.lootTypes[i];
                if (vars.CheckSplit("loot__" + itemType)) {
                    return true;
                }
            }

            if (settings["amulet_holder"]) {
                if (current.amuletCapacity > old.amuletCapacity && old.amuletCapacity >= 3) {
                    if (vars.CompletedSplits.Add("amulet_holder__" + current.amuletCapacity)) {
                        vars.Log("Completed: amulet_holder (" + current.amuletCapacity + ")");
                        return true;
                    }
                }
            }

            if (settings["amulets"]) {
                for (int i = 0; i < current.availableAmulets.Count; i++) {
                    int stoneId = current.availableAmulets[i];
                    if (vars.CheckSplit("amulet__" + stoneId)) {
                        return true;
                    }
                }
            }

            if (settings["divine_trials"]) {
                if (old.challengeState != 8 && current.challengeState == 8) {
                    return true;
                }
            }

            if (current.inventory != null) {
                foreach (var kvp in current.inventory) {
                    int itemKey = kvp.Key;
                    int curAmount = kvp.Value;
                    int oldAmount = 0;
                    if (old.inventory != null && old.inventory.ContainsKey(itemKey)) {
                        oldAmount = old.inventory[itemKey];
                    }

                    if (curAmount > oldAmount) {
                        string keyStr = itemKey.ToString();
                        if (settings.ContainsKey(keyStr) && settings[keyStr]) {
                            vars.Log("Item gained: " + keyStr + " (" + oldAmount + " -> " + curAmount + ")");
                            return true;
                        }
                    }
                }
            }
        }

        if (settings["quest"]) {
            if (old.shortLevel != current.shortLevel && vars.CheckSplit("inlevel_" + current.shortLevel)) return true;

            if (current.level == old.level && vars.CheckSplit("level_action__" + current.level + "__" + current.playerAction)) return true;
        }

        if (settings["boss"]) {
            bool bothDead = current.boss1Health <= 0 && current.boss2Health <= 0;
            bool oneWasAlive = (old.boss1Health > 0 || old.boss2Health > 0);
            bool playerAlive = current.playerAction != 65 && !old.isPaused;
            string key = "boss__" + current.boss1LocId + "__" + current.level;

            if (bothDead && oneWasAlive && playerAlive && vars.CheckSplit(key)) return true;

            if (old.playerAction != current.playerAction && vars.CheckSplit("player_action__" + old.playerAction)) return true;
        }
    }

    // Divine Trials (IL mode)
    if (vars.mode == 3 && current.challengeState == 8) {
        vars.mode = 0;
        return true;
    }
}
