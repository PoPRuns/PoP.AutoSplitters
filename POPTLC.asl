state("TheLostCrown") { }
state("TheLostCrown_plus") { }

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "POPTLC";
    vars.Helper.LoadSceneManager = true;
    
    // The ubisoft+ version of this game is weird and requires overriding some config in asl-help
    vars.Helper.Il2CppModules.Add("GameAssembly_plus.dll");
    vars.Helper.DataDirectory = "TheLostCrown_Data";

    vars.Helper.Settings.CreateFromXml("Components/POPTLC.Settings.xml");
    vars.Helper.StartFileLogger("POPTLC Autosplitter.log");

    vars.Watch = (Action<IDictionary<string, object>, IDictionary<string, object>, string>)((oldLookup, currentLookup, key) => 
    {
        var oldValue = oldLookup[key];
        var currentValue = currentLookup[key];

        if (oldValue != null && currentValue != null && !oldValue.Equals(currentValue))
            vars.Log(key + ": " + oldValue + " -> " + currentValue);
    });

    vars.CompletedSplits = new HashSet<string>();
    // All the quests that have been in progress during this run
    vars.SeenQuests = new HashSet<string>();
    // the last checked list of active quests
    vars.ActiveQuests = new List<string>();
    vars.IGTValue = 0;
    vars.IGTOffset = 0;

    vars.Helper.AlertLoadless();
}

init
{
    vars.states = null;
    current.isChangingLevel = false;
    vars.NORMAL_START_SCENE = "KIN_BAT_02";
    vars.DLC_START_SCENE = "RAD_INT_01_BATTLEFIELD";

    // hardcoding some offsets which we can't get dynamically
    var LINKED_LIST_COUNT_OFFSET = 0x18;
    var LINKED_LIST_HEAD_OFFSET = 0x10;
    var LINKED_LIST_NODE_NEXT_OFFSET = 0x18;
    var LINKED_LIST_NODE_VALUE_OFFSET = 0x28;
    var ARRAY_ELEMENTS_OFFSET = 0x20;

    // not sure if the names are accurate but this is based on what I saw in memory
    var CLASS_OFFSET = 0x0;
    var CLASS_NAME_OFFSET = 0x10;
    
    vars.GetClassNameOfInstance = (Func<IntPtr, bool, string>)((instance, isDereffed) =>
    {
        DeepPointer p;

        if (isDereffed)
        {
            p = new DeepPointer(
                instance + CLASS_OFFSET,
                CLASS_NAME_OFFSET,
                0x0
            );
        } else {
            p = new DeepPointer(
                instance,
                CLASS_OFFSET,
                CLASS_NAME_OFFSET,
                0x0
            );
        }
        
        // this is an ascii string so can't use the asl-help func
        return p.DerefString(game, ReadStringType.ASCII, 128);
    });

    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        // asl-help has this issue where sometimes offsets resolve to 0x10 less than what they are meant to be
        // this is a fix to that...
        var PAD = 0x10;

        var PM = mono["Alkawa.Gameplay", "PauseManager"];
        vars.Helper["isPaused"] = PM.Make<bool>("m_paused");

        var GF = mono["Alkawa.Engine", "GameFlow"];
        // a linked list of the states the game is in
        vars.Helper["activeStatesHead"] = GF.Make<long>("m_activeStates", LINKED_LIST_HEAD_OFFSET);
        vars.Helper["activeStatesCount"] = GF.Make<int>("m_activeStates", LINKED_LIST_COUNT_OFFSET);

        // Traverse the active states linked list to get all the active... states...
        // We have to figure out the active states from the names of the classes of the instances in this linked list,
        //    there is no property on the instances themselves which describe this
        // 
        // Possible states (all prefixed by GameFlowState):
        //   Default, FirstMandatoryUIScreens, FirstLoading, MainMenu, Loading, Game, CutScene, CutsceneVideo, GameOver,
        //   Respawn, Menu, DiegeticMenu, FTUE, ChallengePause, NewGame, StartGameSelectSlot, ChangingLevel,
        //   OptionMenu, UbiConnectNewsMenu, UbiConnectConnection, EndingCredits, Unused, NoInputDevice,
        //   DemoDisclaimer, TitleScreen, FastTravel
        vars.GetStates = (Func<HashSet<string>>)(() =>
        {
            var states = new HashSet<string>();

            // probably susceptible to TOCTOU bugs
            IntPtr head = (IntPtr) vars.Helper["activeStatesHead"].Current;
            var count = vars.Helper["activeStatesCount"].Current;

            IntPtr curr = head;
            for (var i = 0; i < count; i++) {
                var value = vars.GetClassNameOfInstance(curr + LINKED_LIST_NODE_VALUE_OFFSET, false);
                states.Add(value);

                curr = vars.Helper.Read<IntPtr>(curr + LINKED_LIST_NODE_NEXT_OFFSET);
                
                // this is a double ended linked list or whatever, so if we go back to the start then we're at the end
                if (curr == head) break;
            }

            return states;
        });

        var PC = mono["Alkawa.Gameplay", "PlayerComponent"];
        var PISC = mono["Alkawa.Gameplay", "PlayerInputSubComponent"];
        var PISI = mono["Alkawa.Gameplay", "PlayerInputStateInfo", 1];
        
        // enum EPlayerInputMode: Gameplay=0, Menu=1, Conversation=2, CutScene=3, Popup=4, NoInput=5, Unknown=-1
        vars.Helper["inputMode"] = PM.Make<int>(
            "m_PlayerComponent",
            PC["PlayerInput"] + PAD,
            PISC["m_inputStateInfo"] + PAD,
            PISI["m_inputMode"] + PAD
        ); 

        var PASC = mono["Alkawa.Gameplay", "PlayerAbilitiesSubComponent"];
        var PASI = mono["Alkawa.Gameplay", "PlayerAbilitiesStateInfo"];
        var ABILITY = mono["Alkawa.Gameplay", "Ability"];
       
        vars.Helper["playerAction"] = PM.Make<int>(
            "m_PlayerComponent",
            PC["PlayerAbilities"] + PAD,
            PASC["m_stateInfo"] + PAD,
            PASI["m_ability"] + PAD,
            ABILITY["m_currentPlayerActionInternal"] + PAD
        );

        vars.Helper["unlockableAbilities"] = PM.MakeList<IntPtr>(
            "m_PlayerComponent",
            PC["PlayerAbilities"] + PAD,
            PASC["m_stateInfo"] + PAD,
            PASI["m_unlockableAbilities"] + PAD
        );

        vars.CheckIfAbilityUnlocked = (Func<IntPtr, bool>)(ability =>
        {
            bool unlocked = vars.Helper.Read<bool>(ability + ABILITY["m_enabled"] + PAD);
            return unlocked;
        });

        vars.Helper["isClairvoyanceUnlocked"] = PM.Make<bool>(
            "m_PlayerComponent",
            PC["PlayerAbilities"] + PAD,
            PASC["m_stateInfo"] + PAD,
            PASI["m_isClairvoyanceEnabled"] + PAD
        );
        
        var LM = mono["Alkawa.Gameplay", "LootManager", 1];
        var LI = mono["Alkawa.Engine", "LevelInstance"];
        var LD = mono["Alkawa.Engine", "LevelData", 1];

        vars.Helper["level"] = LM.MakeString(
            "m_instance",
            LM["m_currentLevelInstance"] + PAD,
            LI["m_levelData"] + PAD,
            LD["m_prettyName"] + PAD
        );

        vars.Helper["shortLevel"] = LM.MakeString(
            "m_instance",
            LM["m_currentLevelInstance"] + PAD,
            LI["m_levelData"] + PAD,
            LD["m_shortPrettyName"] + PAD
        );


        var UIM = mono["Alkawa.Gameplay", "UIManager", 1];
        var QME = mono["Alkawa.Gameplay", "QuestMenu"];
        var QMA = mono["Alkawa.Gameplay", "QuestManager"];
        var QC = mono["Alkawa.Gameplay", "QuestsContainer"];
        var QB = mono["Alkawa.Gameplay", "QuestBase"];

        // List<QuestBase>
        vars.Helper["quests"] = UIM.MakeList<IntPtr>(
            "m_instance",
            UIM["m_menus"] + PAD,
            // QuestMenu is probably always at index 8 in this array
            // if quest splitting breaks this is where I'd put my money
            ARRAY_ELEMENTS_OFFSET + 0x8 * 8,
            QME["m_QuestManager"] + PAD,
            QMA["m_questsContainer"] + PAD,
            QC["m_Quests"] + PAD
        );

        vars.ReadQuest = (Func<IntPtr, dynamic>)(quest =>
        {
            dynamic ret = new ExpandoObject();
            ret.Name = vars.Helper.ReadString(quest + QB["Name"] + PAD);
            ret.GUID = vars.Helper.ReadString(quest + QB["m_GUID"] + PAD);
            return ret;
        });

        // Boss
        var UI_HP = mono["Alkawa.Gameplay", "UI_HP", 1];
        var HSI = mono["Alkawa.Gameplay", "HealthStateInfo"];
        var ED = mono["Alkawa.Gameplay", "EntityDescriptor"];
        var UISLI = mono["Alkawa.Gameplay", "UISmartLocId"];

        vars.Helper["boss1LocId"] = UIM.Make<int>(
            "m_instance",
            UIM["m_BossHealthBar"] + PAD,
            UI_HP["m_entityDescriptor"] + PAD,
            ED["Name"] + PAD,
            UISLI["m_locId"] + PAD
        );

        vars.Helper["boss1Health"] = UIM.Make<int>(
            "m_instance",
            UIM["m_BossHealthBar"] + PAD,
            UI_HP["m_healthStateInfo"] + PAD,
            HSI["m_internalCurrentHP"] + PAD
        );
        vars.Helper["boss1Health"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;

        vars.Helper["boss2Health"] = UIM.Make<int>(
            "m_instance",
            UIM["m_SecondBossHealthBar"] + PAD,
            UI_HP["m_healthStateInfo"] + PAD,
            HSI["m_internalCurrentHP"] + PAD
        );
        vars.Helper["boss2Health"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;

        var SM = mono["Alkawa.Gameplay", "SpeedrunManager", 1];
        var SI = mono["Alkawa.Gameplay", "SpeedrunInstance"];

        vars.Helper["speedrunTimer"] = SM.Make<double>(
            "m_instance",
            SM["m_mainGameSpeedrunInstance"] + PAD,
            SI["m_currentTimer"] + PAD
        );

        return true;
    });

    // this function is a helper for checking splits that may or may not exist in settings,
    // and if we want to do them only once
    vars.CheckSplit = (Func<string, bool>)(key => {
        // make sure splits are enabled and timer is running
        if (!settings.SplitEnabled || timer.CurrentPhase != TimerPhase.Running) {
            return false;
        }

        // if the split doesn't exist, or it's off, or we've done it already
        if (!settings.ContainsKey(key)
          || !settings[key]
          || !vars.CompletedSplits.Add(key)
        ) {
            return false;
        }

        vars.Log("Completed: " + key);
        return true;
    });
}

update
{
	current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
    vars.Watch(old, current, "activeScene");
    vars.Watch(old, current, "level");
    vars.Watch(old, current, "shortLevel");
    vars.Watch(old, current, "inputMode");
    vars.Watch(old, current, "boss1LocId");
    // vars.Watch(old, current, "boss1Health");
    // vars.Watch(old, current, "boss2Health");
    // vars.Watch(old, current, "playerAction");

    if (vars.states == null || vars.states.Count != current.activeStatesCount) {
        vars.states = vars.GetStates();

        current.isChangingLevel = vars.states.Contains("GameFlowStateChangingLevel");
        current.isGSCutscene = vars.states.Contains("GameFlowStateCutScene");

        vars.Log("[" + vars.states.Count + "] State set changed: " + string.Join(", ", vars.states));
    }

    if (old.shortLevel != current.shortLevel) {
        current.isChangingLevel = false;
    }

    if ((vars.ActiveQuests.Count != current.quests.Count && current.quests.Count != 0)
     || (vars.ActiveQuests.Count > vars.SeenQuests.Count)
    ) {
        // vars.Log("QUEST LIST CHANGED " + vars.ActiveQuests.Count + " -> " + current.quests.Count + " (SQ: " + vars.SeenQuests.Count + ")");
        vars.ActiveQuests = new List<string>();

        foreach (var questPtr in current.quests) {
            var quest = vars.ReadQuest(questPtr);

            // vars.Log("  " + quest.Name + " [" + quest.GUID + "]");

            vars.ActiveQuests.Add(quest.GUID);
            
            if (vars.SeenQuests.Add(quest.GUID)) {
                vars.Log("Quest started! " + quest.Name + " [" + quest.GUID + "]");
                if (vars.CheckSplit("quest_start_" + quest.GUID))
                {
                    vars.Helper.Timer.Split();
                }
            }
        }

        // vars.Log("SEEN QUESTS (" + vars.SeenQuests.Count + "): ");

        foreach (var seenQuest in vars.SeenQuests) {
            vars.Log("  " + seenQuest);

            if (!vars.ActiveQuests.Contains(seenQuest)
             && vars.CheckSplit("quest_end_" + seenQuest)
            ) {
                vars.Helper.Timer.Split();
            }
        }

    }
}

onStart
{
	timer.IsGameTimePaused = true;
    
    // refresh all splits when we start the run, none are yet completed
    vars.CompletedSplits.Clear();
    vars.SeenQuests.Clear();

    vars.Log(vars.ActiveQuests.Count);
    vars.Log(settings.SplitEnabled);
    vars.Log(current.isGSCutscene);
    vars.Log(current.isPaused);
    vars.Log(current.level);
    vars.Log(current.inputMode);
    vars.Log(current.playerAction);
    vars.Log(current.activeStatesHead.ToString("X"));
    vars.Log(current.activeStatesCount);

    vars.Log(current.boss1LocId);
    vars.Log(current.boss1Health);
    vars.Log(current.boss2Health);
}

onReset
{
    vars.IGTValue = 0;
    vars.IGTOffset = 0;
}

start
{
    // Start in either base game or DLC starting scene when speedrun mode is active
    if ((current.activeScene == vars.NORMAL_START_SCENE && current.inputMode == 3) || (current.activeScene == vars.DLC_START_SCENE && old.activeScene != vars.DLC_START_SCENE && current.isGSCutscene == false)) {
        // For the DLC, set offset for the timer accordingly
        if (current.activeScene == vars.DLC_START_SCENE) {
            vars.IGTOffset = -current.speedrunTimer;
        }
        return true;
    };
}

isLoading
{
    return true;
}

gameTime
{
    if (current.speedrunTimer > 0) {
        if (vars.IGTValue > current.speedrunTimer) {
            vars.IGTOffset += (vars.IGTValue - current.speedrunTimer);
        }
        vars.IGTValue = current.speedrunTimer;
    }
    return TimeSpan.FromSeconds(vars.IGTValue + vars.IGTOffset);
}

split
{
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

    if (settings["quest"] && old.shortLevel != current.shortLevel && vars.CheckSplit("inlevel_" + current.shortLevel))
    {
        return true;
    }

    if (settings["boss"])
    {
        var bothDead = current.boss1Health <= 0 && current.boss2Health <= 0;
        var oneWasAlive = (old.boss1Health > 0 || old.boss2Health > 0);
        var playerAlive = !vars.states.Contains("GameFlowStateGameOver");
        var key = "boss__" + current.boss1LocId + "__" + current.level;
        
        if (bothDead && oneWasAlive && playerAlive && vars.CheckSplit(key))
        {
            return true;
        }

        if (old.playerAction != current.playerAction && vars.CheckSplit("player_action__" + old.playerAction)) {
            return true;
        }
    }
}
