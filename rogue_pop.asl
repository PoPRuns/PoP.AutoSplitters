state("The Rogue Prince of Persia") {}

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
        "Components/RoguePoP.Settings.xml",
        "settings/RoguePoP.Settings.xml",
        "RoguePoP.Settings.xml"
    };

    string xmlFile = searchPaths.FirstOrDefault(p => File.Exists(p));
    if (xmlFile != null) {
        var doc = System.Xml.Linq.XDocument.Load(xmlFile);
        if (doc.Root != null) {
            loadSettingsRecursive(doc.Root.Elements("Setting"), null);
        }
    } else {
        throw new FileNotFoundException("RoguePoP.Settings.xml not found in Components/, settings/, or current folder.");
    }

    // Logging helper
    vars.Log = (Action<object>)(msg => {
        print("[RoguePoP] " + (msg != null ? msg.ToString() : "null"));
    });

    // Constants
    vars.FRESH_FILE_START_SCENE = "TutoScene";
    vars.OASIS_SCENE = "HUBScene";
    vars.FINALBOSS_SCENE = "Nogai";

    vars.initialScenes = new HashSet<string> { "", "Bootstrap", "BootLoader", "GCManagerService", "Start", "HUBScene", "Boot" };
    vars.checkNotInitialScenes = (Func<string, bool>)(scene => 
        !string.IsNullOrEmpty(scene) && !vars.initialScenes.Contains(scene)
    );

    // State
    vars.IGTTicks = 0L;
    vars.is_fresh_file_mode = false;
    vars.just_created_file = false;
    vars.just_exited_oasis = false;
    vars.ready = false;
    vars.gaBase = IntPtr.Zero;
    vars.upBase = IntPtr.Zero;

    if (timer.CurrentTimingMethod != TimingMethod.GameTime) {
        DialogResult mbox = MessageBox.Show(timer.Form,
            "This game uses an in-game timer as the primary timing method.\nWould you like to switch to Game Time?",
            "LiveSplit | The Rogue Prince of Persia",
            MessageBoxButtons.YesNo);

        if (mbox == DialogResult.Yes) {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

init
{
    vars.ready = false;
    vars.gaBase = IntPtr.Zero;
    vars.upBase = IntPtr.Zero;
    vars.smRva = 0;
    vars.rslRva = 0;
    vars.vlsRva = 0;
    vars.gameVersion = "";

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

    vars.ReadFloat = (Func<IntPtr, float>)(addr => {
        if (addr == IntPtr.Zero || game == null) return 0f;
        try {
            float val;
            return game.ReadValue<float>(addr, out val) ? val : 0f;
        } catch { return 0f; }
    });

    vars.ReadDouble = (Func<IntPtr, double>)(addr => {
        if (addr == IntPtr.Zero || game == null) return 0.0;
        try {
            double val;
            return game.ReadValue<double>(addr, out val) ? val : 0.0;
        } catch { return 0.0; }
    });

    vars.ReadBool = (Func<IntPtr, bool>)(addr => {
        if (addr == IntPtr.Zero || game == null) return false;
        try {
            bool val;
            return game.ReadValue<bool>(addr, out val) ? val : false;
        } catch { return false; }
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

    vars.ReadScenePath = (Func<IntPtr, string>)(addr => {
        if (addr == IntPtr.Zero || game == null) return null;
        try {
            // Check if stored inline: first 7 bytes == "Assets/"
            var bytes = game.ReadBytes(addr, 7);
            if (bytes != null && bytes.Length == 7 &&
                bytes[0] == 'A' && bytes[1] == 's' && bytes[2] == 's' &&
                bytes[3] == 'e' && bytes[4] == 't' && bytes[5] == 's' && bytes[6] == '/')
            {
                var full = game.ReadBytes(addr, 128);
                if (full == null) return null;
                int len = 0;
                while (len < full.Length && full[len] != 0) len++;
                return len > 0 ? System.Text.Encoding.UTF8.GetString(full, 0, len) : null;
            }

            // Otherwise check if addr is a pointer to a heap-allocated path starting with "Assets/"
            IntPtr ptr;
            if (game.ReadPointer(addr, out ptr) && ptr != IntPtr.Zero) {
                var ptrBytes = game.ReadBytes(ptr, 7);
                if (ptrBytes != null && ptrBytes.Length == 7 &&
                    ptrBytes[0] == 'A' && ptrBytes[1] == 's' && ptrBytes[2] == 's' &&
                    ptrBytes[3] == 'e' && ptrBytes[4] == 't' && ptrBytes[5] == 's' && ptrBytes[6] == '/')
                {
                    var full = game.ReadBytes(ptr, 256);
                    if (full == null) return null;
                    int len = 0;
                    while (len < full.Length && full[len] != 0) len++;
                    return len > 0 ? System.Text.Encoding.UTF8.GetString(full, 0, len) : null;
                }
            }
            return null;
        } catch { return null; }
    });

    vars.GetSceneName = (Func<string, string>)(path => {
        if (string.IsNullOrEmpty(path)) return null;
        int slash = Math.Max(path.LastIndexOf('/'), path.LastIndexOf('\\'));
        string name = slash >= 0 ? path.Substring(slash + 1) : path;
        int dot = name.LastIndexOf('.');
        return dot >= 0 ? name.Substring(0, dot) : name;
    });

    vars.ReadIL2CppString = (Func<IntPtr, string>)(addr => {
        if (addr == IntPtr.Zero || game == null) return null;
        try {
            int len = vars.ReadInt(addr + 0x10);
            if (len <= 0 || len > 256) return null;
            byte[] bytes = game.ReadBytes(addr + 0x14, len * 2);
            return bytes != null ? System.Text.Encoding.Unicode.GetString(bytes) : null;
        } catch { return null; }
    });

    vars.GetMD5 = (Func<string, string>)(path => {
        try {
            using (var md5 = System.Security.Cryptography.MD5.Create())
            using (var s = File.OpenRead(path)) {
                return BitConverter.ToString(md5.ComputeHash(s)).Replace("-", "").ToLowerInvariant();
            }
        } catch { return ""; }
    });

    current.activeScene = "";
    current.runPlaytime = 0f;
    current.totalRunsPlaytime = 0f;
    current.nogaiKilled = false;
    current.finalBossKilled = false;
    current.appSeed = 0;

    vars.nogaiFlagIndex = 51;
    vars.finalBossFlagIndex = 52;
    vars.indicesResolved = false;
}

exit
{
    vars.ready = false;
    vars.gaBase = IntPtr.Zero;
    vars.upBase = IntPtr.Zero;
    vars.smRva = 0;
    vars.rslRva = 0;
    vars.vlsRva = 0;
    vars.gameVersion = "";
    vars.indicesResolved = false;
}

shutdown
{
    vars.ready = false;
    vars.gaBase = IntPtr.Zero;
    vars.upBase = IntPtr.Zero;
    vars.smRva = 0;
    vars.rslRva = 0;
    vars.vlsRva = 0;
    vars.gameVersion = "";
    vars.indicesResolved = false;
    vars.lastLevelScene = "";
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
        // and IL2CPP static class tables / Unity scene manager are initialized.
        if (!vars.ready) {
            game.Refresh();

            ProcessModule mainModule = null;
            ProcessModule gaModule = null;
            ProcessModule upModule = null;

            foreach (ProcessModule m in game.Modules) {
                if (mainModule == null && m.ModuleName.Equals("The Rogue Prince of Persia.exe", StringComparison.OrdinalIgnoreCase)) {
                    mainModule = m;
                }
                if (gaModule == null && m.ModuleName.Equals("GameAssembly.dll", StringComparison.OrdinalIgnoreCase)) {
                    gaModule = m;
                }
                if (upModule == null && m.ModuleName.Equals("UnityPlayer.dll", StringComparison.OrdinalIgnoreCase)) {
                    upModule = m;
                }
                if (mainModule != null && gaModule != null && upModule != null) break;
            }

            if (gaModule == null || upModule == null) return false;
            if (gaModule.BaseAddress == IntPtr.Zero || upModule.BaseAddress == IntPtr.Zero) return false;

            IntPtr gaBase = gaModule.BaseAddress;
            IntPtr upBase = upModule.BaseAddress;

            string exePath = (mainModule != null && !string.IsNullOrEmpty(mainModule.FileName))
                ? mainModule.FileName
                : (game.MainModule != null ? game.MainModule.FileName : "");

            string exeMd5 = !string.IsNullOrEmpty(exePath) ? vars.GetMD5(exePath) : "";

            // Version detection:
            // 1.1.0: MD5 ca60d55448eceb43b01aca825185a619
            // 1.0.4: MD5 cac15c68fb5a0fd4cbdc08def295afac
            switch (exeMd5.ToLowerInvariant()) {
                case "ca60d55448eceb43b01aca825185a619":
                    vars.gameVersion = "1.1.0";
                    vars.smRva = 0x1F42158;
                    vars.rslRva = 0x6721FC0;
                    vars.vlsRva = 0x677A008;
                    vars.nogaiFlagIndex = 52;
                    vars.finalBossFlagIndex = 53;
                    break;
                case "cac15c68fb5a0fd4cbdc08def295afac":
                default:
                    vars.gameVersion = "1.0.4";
                    vars.smRva = 0x1D1C188;
                    vars.rslRva = 0x5669DF0;
                    vars.vlsRva = 0x566DB28;
                    vars.nogaiFlagIndex = 51;
                    vars.finalBossFlagIndex = 52;
                    break;
            }
            version = vars.gameVersion;

            // RuntimeServiceLocator TypeInfo
            IntPtr rslTypeInfo = vars.ReadPtr(gaBase + vars.rslRva);
            if (rslTypeInfo == IntPtr.Zero) return false;
            IntPtr rslStatic = vars.ReadPtr(rslTypeInfo + 0xB8);
            if (rslStatic == IntPtr.Zero) return false;
            IntPtr rslInstance = vars.ReadPtr(rslStatic + 0x0);
            if (rslInstance == IntPtr.Zero) return false;

            // VariableListSaver TypeInfo
            IntPtr vlsTypeInfo = vars.ReadPtr(gaBase + vars.vlsRva);
            if (vlsTypeInfo == IntPtr.Zero) return false;
            IntPtr vlsStatic = vars.ReadPtr(vlsTypeInfo + 0xB8);
            if (vlsStatic == IntPtr.Zero) return false;
            IntPtr vlsInstance = vars.ReadPtr(vlsStatic + 0x0);
            if (vlsInstance == IntPtr.Zero) return false;

            // SceneManager
            IntPtr sceneMgr = vars.ReadPtr(upBase + vars.smRva);
            if (sceneMgr == IntPtr.Zero) return false;

            vars.gaBase = gaBase;
            vars.upBase = upBase;
            vars.ready = true;
            vars.Log("Successfully hooked [" + vars.gameVersion + "] (MD5=" + exeMd5 + "): GameAssembly=0x" + gaBase.ToString("X") + ", UnityPlayer=0x" + upBase.ToString("X"));
        }

        if (!vars.ready) return false;

        IntPtr gaBaseActive = vars.gaBase;
        IntPtr upBaseActive = vars.upBase;

        // Active Scene Name
        if (upBaseActive != IntPtr.Zero) {
            IntPtr sceneMgr = vars.ReadPtr(upBaseActive + vars.smRva);
            if (sceneMgr != IntPtr.Zero) {
                IntPtr activeSceneObj = vars.ReadPtr(sceneMgr + 0x48);
                if (activeSceneObj != IntPtr.Zero) {
                    string path = vars.ReadScenePath(activeSceneObj + 0x10);
                    string name = vars.GetSceneName(path);
                    if (!string.IsNullOrEmpty(name) && name != "Boot") {
                        current.activeScene = name;
                    } else if (old.activeScene != null) {
                        current.activeScene = old.activeScene;
                    }
                }
            }
        }
        if (string.IsNullOrEmpty(current.activeScene) && old.activeScene != null) {
            current.activeScene = old.activeScene;
        }

        // PlaytimeService:
        // RuntimeServiceLocator.Instance (+0x18 variables -> +0x10 items -> [23] PlaytimeService var -> +0x28 PlaytimeService instance)
        // runPlaytime (float): +0x28 (pauses on pause)
        // totalRunsPlaytime (float): +0x30 (pauses on pause)
        IntPtr rslTypeInfoObj = vars.ReadPtr(gaBaseActive + vars.rslRva);
        IntPtr rslStaticObj = rslTypeInfoObj != IntPtr.Zero ? vars.ReadPtr(rslTypeInfoObj + 0xB8) : IntPtr.Zero;
        IntPtr rslInst = rslStaticObj != IntPtr.Zero ? vars.ReadPtr(rslStaticObj + 0x0) : IntPtr.Zero;
        if (rslInst != IntPtr.Zero) {
            IntPtr rslVars = vars.ReadPtr(rslInst + 0x18);
            if (rslVars != IntPtr.Zero) {
                IntPtr rslItems = vars.ReadPtr(rslVars + 0x10);
                if (rslItems != IntPtr.Zero) {
                    IntPtr elemPlaytime = vars.ReadPtr(rslItems + 0x20 + 23 * 8);
                    if (elemPlaytime != IntPtr.Zero) {
                        IntPtr ps = vars.ReadPtr(elemPlaytime + 0x28);
                        if (ps != IntPtr.Zero) {
                            current.runPlaytime = vars.ReadFloat(ps + 0x28);
                            current.totalRunsPlaytime = vars.ReadFloat(ps + 0x30);
                        }
                    }
                }
            }
        }

        // VariableListSaver:
        // VariableListSaver.Instance -> +0x20 listToSave -> +0x10 items (groups)
        // Group 0: appSeed (var 0 at +0x24)
        // Group 1: nogaiKilled, finalBossKilled
        // Group 2: Boss_Visit_* flags (Berude, Baatar, Kaali, Altan, Nogai)
        IntPtr vlsTypeInfoObj = vars.ReadPtr(gaBaseActive + vars.vlsRva);
        IntPtr vlsStaticObj = vlsTypeInfoObj != IntPtr.Zero ? vars.ReadPtr(vlsTypeInfoObj + 0xB8) : IntPtr.Zero;
        IntPtr vlsInst = vlsStaticObj != IntPtr.Zero ? vars.ReadPtr(vlsStaticObj + 0x0) : IntPtr.Zero;
        if (vlsInst != IntPtr.Zero) {
            IntPtr listToSave = vars.ReadPtr(vlsInst + 0x20);
            if (listToSave != IntPtr.Zero) {
                int groupCount = vars.ReadInt(listToSave + 0x18);
                IntPtr groups = vars.ReadPtr(listToSave + 0x10);
                if (groups != IntPtr.Zero) {
                    // Group 0: appSeed
                    if (groupCount > 0) {
                        IntPtr grp0 = vars.ReadPtr(groups + 0x20 + 0 * 8);
                        if (grp0 != IntPtr.Zero) {
                            IntPtr g0Vars = vars.ReadPtr(grp0 + 0x18);
                            if (g0Vars != IntPtr.Zero) {
                                IntPtr g0Items = vars.ReadPtr(g0Vars + 0x10);
                                if (g0Items != IntPtr.Zero) {
                                    IntPtr varSeed = vars.ReadPtr(g0Items + 0x20 + 0 * 8);
                                    if (varSeed != IntPtr.Zero) {
                                        current.appSeed = vars.ReadInt(varSeed + 0x24);
                                    }
                                }
                            }
                        }
                    }

                    // Dynamic index resolution (runs once as soon as Group 1 is populated)
                    if (!vars.indicesResolved && groupCount > 1) {
                        IntPtr grp1 = vars.ReadPtr(groups + 0x20 + 1 * 8);
                        if (grp1 != IntPtr.Zero) {
                            IntPtr g1Vars = vars.ReadPtr(grp1 + 0x18);
                            if (g1Vars != IntPtr.Zero) {
                                int g1Count = vars.ReadInt(g1Vars + 0x18);
                                IntPtr g1Items = vars.ReadPtr(g1Vars + 0x10);
                                if (g1Items != IntPtr.Zero && g1Count > 0) {
                                    for (int i = 0; i < g1Count; i++) {
                                        IntPtr v = vars.ReadPtr(g1Items + 0x20 + i * 8);
                                        if (v == IntPtr.Zero) continue;
                                        string vName = vars.ReadIL2CppString(vars.ReadPtr(v + 0x18));
                                        if (vName == "Boss_RunDefeated_Nogai") vars.nogaiFlagIndex = i;
                                        else if (vName == "Boss_RunDefeated_CorruptedNogai") vars.finalBossFlagIndex = i;
                                    }
                                }
                            }
                        }

                        vars.indicesResolved = true;
                        vars.Log("Resolved VLS indices: Nogai=" + vars.nogaiFlagIndex + ", Final=" + vars.finalBossFlagIndex);
                    }

                    // Group 1: nogaiKilled, finalBossKilled
                    if (groupCount > 1) {
                        IntPtr grp1 = vars.ReadPtr(groups + 0x20 + 1 * 8);
                        if (grp1 != IntPtr.Zero) {
                            IntPtr g1Vars = vars.ReadPtr(grp1 + 0x18);
                            if (g1Vars != IntPtr.Zero) {
                                IntPtr g1Items = vars.ReadPtr(g1Vars + 0x10);
                                if (g1Items != IntPtr.Zero) {
                                    if (vars.nogaiFlagIndex >= 0) {
                                        IntPtr varNogai = vars.ReadPtr(g1Items + 0x20 + vars.nogaiFlagIndex * 8);
                                        if (varNogai != IntPtr.Zero) {
                                            current.nogaiKilled = vars.ReadBool(varNogai + 0x20) || vars.ReadBool(varNogai + 0x21);
                                        }
                                    }
                                    if (vars.finalBossFlagIndex >= 0) {
                                        IntPtr varFinal = vars.ReadPtr(g1Items + 0x20 + vars.finalBossFlagIndex * 8);
                                        if (varFinal != IntPtr.Zero) {
                                            current.finalBossKilled = vars.ReadBool(varFinal + 0x20) || vars.ReadBool(varFinal + 0x21);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // LiveSplit custom metadata variable
        timer.Run.Metadata.SetCustomVariable("seed", current.appSeed.ToString());

        if (current.activeScene != old.activeScene) {
            vars.Log("Scene: " + (old.activeScene ?? "null") + " -> " + (current.activeScene ?? "null"));
        }
    } catch (Exception ex) {
        vars.Log("Exception in update: " + ex);
        return false;
    }
}

onReset
{
    vars.IGTTicks = 0L;
    vars.is_fresh_file_mode = false;
    vars.just_created_file = false;
    vars.just_exited_oasis = false;
}

start
{
    vars.just_created_file |=
        old.activeScene != vars.FRESH_FILE_START_SCENE &&
        current.activeScene == vars.FRESH_FILE_START_SCENE;

    vars.just_exited_oasis |=
        old.activeScene == vars.OASIS_SCENE &&
        current.activeScene != vars.OASIS_SCENE &&
        current.activeScene != "Start";

    vars.is_fresh_file_mode =
        settings["fresh_file_start"] &&
        vars.just_created_file &&
        current.totalRunsPlaytime > 0;

    bool oasis_start =
        settings["oasis_start"] &&
        vars.just_exited_oasis &&
        current.runPlaytime < old.runPlaytime;

    return vars.is_fresh_file_mode || oasis_start;
}

reset
{
    if (vars.is_fresh_file_mode) {
        return false;
    } else {
        return
            settings["oasis_reset"] &&
            old.activeScene != vars.OASIS_SCENE &&
            current.activeScene == vars.OASIS_SCENE;
    }
}

onStart
{
    vars.just_exited_oasis = false;
    vars.just_created_file = false;

    double startSeconds = vars.is_fresh_file_mode ? current.totalRunsPlaytime : current.runPlaytime;
    vars.IGTTicks = (long)Math.Round(startSeconds * 10000000.0);
}

isLoading
{
    return true;
}

gameTime
{
    if (!vars.ready) {
        return TimeSpan.FromTicks(vars.IGTTicks);
    }

    double old_seconds, current_seconds;

    if (vars.is_fresh_file_mode) {
        old_seconds = old.totalRunsPlaytime;
        current_seconds = current.totalRunsPlaytime;
    } else {
        old_seconds = old.runPlaytime;
        current_seconds = current.runPlaytime;
    }

    long currentTicks = (long)Math.Round(current_seconds * 10000000.0);
    long oldTicks = (long)Math.Round(old_seconds * 10000000.0);
    long tickDelta = currentTicks - oldTicks;

    if (tickDelta > 0 && (oldTicks > 0 || vars.IGTTicks == 0L)) {
        vars.IGTTicks += tickDelta;
    }

    return TimeSpan.FromTicks(vars.IGTTicks);
}

split
{
    if (settings["biome_split"]) {
        // Regular biome and boss arena scene transitions
        if (vars.checkNotInitialScenes(current.activeScene) &&
            vars.checkNotInitialScenes(old.activeScene) &&
            current.activeScene != old.activeScene)
        {
            return true;
        }

        // Fresh File Mode (Story Journey): Split when exiting Oasis into a successive run
        if (vars.is_fresh_file_mode &&
            vars.checkNotInitialScenes(current.activeScene) &&
            old.activeScene == vars.OASIS_SCENE)
        {
            return true;
        }
    }
    
    // Nogai phase 1
    if (settings["nogai_one"] &&
        vars.checkNotInitialScenes(current.activeScene) &&
        !old.nogaiKilled && current.nogaiKilled)
    {
        return true;
    }
    
    // Nogai final boss
    if (settings["final_split"] &&
        vars.checkNotInitialScenes(current.activeScene) &&
        !old.finalBossKilled && current.finalBossKilled)
    {
        return true;
    }
}
