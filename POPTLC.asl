state("TheLostCrown") { }

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Prince of Persia: The Lost Crown";
    vars.Helper.Settings.CreateFromXml("Components/POPTLC.Settings.xml");

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

    // vars.Helper.AlertLoadless();
}

init
{
    vars.states = null;

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

        if (isDereffed) {
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

        #region testing

        vars.Helper["uimanager"] = UIM.Make<IntPtr>("m_instance");
        vars.Helper["menus"] = UIM.MakeArray<IntPtr>("m_instance", UIM["m_menus"] + PAD);

                // menu + 0x80,
                // 0x68, // m_questsContainer
                // // 0x18 // m_QuestsEnded
                // 0x10 // m_Quests
        // vars.Log("RVM: " + (UIM["m_RiddleVisionMenu"] + PAD).ToString("X"));
        // vars.Helper["a"] = UIM.Make<long>(
        //     "m_instance",
        //     UIM["m_RiddleVisionMenu"] + PAD
        //     // RVM["m_QuestMenu"] + PAD,
        //     // QME["m_QuestManager"] + PAD
        // );
        // vars.Helper["quests"] = QM.MakeList<long>(
        //     "m_instance",
        //     QM["m_mainQuests"] + PAD
        // );

        // var SC = mono["Alkawa.Engine", "SceenController"];
        // vars.Helper["ilpc"] = SC.Make


        // var WSM = mono["Alkawa.Engine", "WorldStreamingManager", 1];
        // var WM = mono["Alkawa.Engine", "WorldManager"];
        // var WI = mono["Alkawa.Engine", "WorldInstance"];
        // var WD = mono["Alkawa.Engine", "WorldData", 1];


        // vars.Helper["a"] = WSM.Make<long>(
        //     "m_instance",
        //     WSM["WorldManager"] + PAD,
        //     WM["m_currentWorld"] + PAD,
        //     WI["m_worldData"] + PAD
        // );

        // vars.Helper["world"] = WSM.MakeString(
        //     "m_instance",
        //     WSM["WorldManager"] + PAD,
        //     WM["m_currentWorld"] + PAD,
        //     WI["m_worldData"] + PAD,
        //     WD["m_GUID"] + PAD
        // );


        // var GSM = mono["Alkawa.Gameplay", "GameStatsManager"];
        // var WI = mono["Alkawa.Engine", "WorldInstance"];
        // var WD = mono["Alkawa.Engine", "WorldData", 1];

        // vars.Helper["a"] = GSM.Make<long>("s_currentWorld");
        // vars.Helper["b"] = GSM.Make<long>("s_currentWorld", WI["m_worldData"]);
        // vars.Helper["c"] = GSM.MakeString("s_currentWorld", WI["m_worldData"] + 0x10, WD["m_labelName"] + 0x10);
        #endregion testing

        return true;
    });

    // this function is a helper for checking splits that may or may not exist in settings,
    // and if we want to do them only once
    vars.CheckSplit = (Func<string, bool>)(key => {
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
    vars.Watch(old, current, "level");
    vars.Watch(old, current, "shortLevel");
    // vars.Watch(old, current, "inputMode");

    if (vars.states == null || vars.states.Count != current.activeStatesCount) {
        vars.states = vars.GetStates();
        // vars.Log("[" + vars.states.Count + "] State set changed.");
        // foreach (var state in vars.states) {
        //     vars.Log("  " + state);
        // }
    }

    if (vars.ActiveQuests.Count != current.quests.Count && current.quests.Count != 0) {
        // vars.Log("QUEST LIST CHANGED " + vars.ActiveQuests.Count + " -> " + current.quests.Count);
        vars.ActiveQuests = new List<string>();

        // TODO make this a TryLoad func
        foreach (var quest in current.quests) {
            var questName = vars.Helper.ReadString(
                quest + 0x10 // Name 
            );

            vars.ActiveQuests.Add(questName);
            
            if (vars.SeenQuests.Add(questName)) {
                vars.Log("Quest started! " + questName);
            }
        }

        foreach (var seenQuest in vars.SeenQuests) {
            // if (!vars.ActiveQuests.Contains(seenQuest)) { vars.Log("Quest maybe completed " + seenQuest); }
            if (!vars.ActiveQuests.Contains(seenQuest)
             && timer.CurrentPhase == TimerPhase.Running
             && vars.CheckSplit("quest_" + seenQuest)
            ) {
                vars.Helper.Timer.Split();
            }
        }

    }
}

onStart
{
    // refresh all splits when we start the run, none are yet completed
    vars.CompletedSplits.Clear();
    vars.SeenQuests.Clear();

    vars.Log(current.isPaused);
    vars.Log(current.level);
    vars.Log(current.inputMode);
    vars.Log(current.activeStatesHead.ToString("X"));
    vars.Log(current.activeStatesCount);
    vars.Log(current.uimanager.ToString("X"));
    
    #region testing
    // tests
    // vars.Log(current.a.ToString("X"));
    // vars.GetStates();

    vars.Log("quests: " + current.quests.Count);

    var i = 0;
    foreach (var menu in current.menus)
    {
        var menuName = vars.GetClassNameOfInstance(menu, true);
        // vars.Log("[" + i + "] FOUND MENU: " + menuName + " at 0x" + menu.ToString("X"));

        if (menuName == "QuestMenu") {
            var quests = vars.Helper.ReadList<IntPtr>(
                menu + 0x80,
                0x68, // m_questsContainer
                // 0x18 // m_QuestsEnded
                0x10 // m_Quests
            );
            // var quests = vars.Helper.ReadList<IntPtr>(
            //     menu + 0x80,
            //     0x100 // m_mainQuests
            // );

            // var quests = vars.Helper.ReadList<IntPtr>(
            //     menu + 0xB0 // m_mainQuests
            // );

            var currentQuestIndex = vars.Helper.Read<int>(
                menu + 0xE8 // m_newMainQuestsCount
                // 0x68, // m_questsContainer
                // 0x2C
            );

            vars.Log("  QUEST COUNT: " + quests.Count + ", ACTIVE: " + currentQuestIndex);

            foreach (var quest in quests) {
                // var questName = "";
                var questName = vars.Helper.ReadString(
                    quest + 0x10 // Name
                    // quest + 0x10, // m_questGraph
                    // 0xF0, // m_creationInfos
                    // 0x28, // m_buildingQuest
                    // 0x10 // Name
                );

                
                var isMain = vars.Helper.Read<bool>(
                    quest + 0x98 // m_isMainQuest
                );

                var GUID = vars.Helper.ReadString(
                    quest + 0x60 // m_GUID
                );

                vars.Log("  QUEST: " + questName + " [" + GUID + "] (Main? " + isMain + ") at 0x" + quest.ToString("X"));
            }

            // foreach (var quest in quests) {
            //     // var questName = "";
            //     var questName = vars.Helper.ReadString(
            //         quest + 0x10, // m_questBase
            //         0x10 // Name
            //     );
            //     var logState = vars.Helper.Read<int>(quest + 0x18);

            //     vars.Log("  QUEST: " + questName + " [" + logState + "] at 0x" + quest.ToString("X"));

            //     var logInfos = vars.Helper.ReadList<IntPtr>(
            //         quest + 0x20
            //     );

            //     foreach (var logInfo in logInfos) {
            //         var logInfoState = vars.Helper.Read<int>(logInfo + 0x48);
            //         vars.Log("  Log: " + logInfoState);
            //     }
            // }
        }

        i++;
    }

    #endregion testing
}

start
{
    // cutscene -> gameplay while in the very first level
    return current.shortLevel == "BAT_02"
        && old.inputMode == 3 && current.inputMode == 0;
}

isLoading
{
    // moving between screens
    return vars.states.Contains("GameFlowStateChangingLevel")
        // not sure when this one happens
        || vars.states.Contains("GameFlowStateLoading");
}

split
{
}