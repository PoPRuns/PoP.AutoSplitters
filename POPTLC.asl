state("TheLostCrown") { }

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Prince of Persia: The Lost Crown";
    vars.Helper.LoadSceneManager = true;
    // vars.Helper.Settings.CreateFromXml("Components/TEMPLATE.Settings.xml");

    vars.Watch = (Action<IDictionary<string, object>, IDictionary<string, object>, string>)((oldLookup, currentLookup, key) => 
    {
        var oldValue = oldLookup[key];
        var currentValue = currentLookup[key];
        if (!oldValue.Equals(currentValue))
            vars.Log(key + ": " + oldValue + " -> " + currentValue);
    });

    vars.CompletedSplits = new HashSet<string>();
    
    // vars.Helper.AlertLoadless();
}

init
{
    vars.states = null;

    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        // hardcoding some offsets which we can't get dynamically
        var LINKED_LIST_COUNT_OFFSET = 0x18;
        var LINKED_LIST_HEAD_OFFSET = 0x10;
        var LINKED_LIST_NODE_NEXT_OFFSET = 0x18;
        var LINKED_LIST_NODE_VALUE_OFFSET = 0x28;
        
        // not sure if the names are accurate but this is based on what I saw in memory
        var CLASS_OFFSET = 0x0;
        var CLASS_NAME_OFFSET = 0x10;

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
                // this is an ascii string so can't use the asl-help func
                var p = new DeepPointer(
                    curr + LINKED_LIST_NODE_VALUE_OFFSET,
                    CLASS_OFFSET,
                    CLASS_NAME_OFFSET,
                    0x0
                );
                var value = p.DerefString(game, ReadStringType.ASCII, 128);
                states.Add(value);

                curr = vars.Helper.Read<IntPtr>(curr + LINKED_LIST_NODE_NEXT_OFFSET);
                
                // this is a double ended linked list or whatever, so if we go back to the start then we're at the end
                if (curr == head) break;
            }

            return states;
        });

        var PC = mono["Alkawa.Gameplay", "PlayerComponent"];
        var PHSC = mono["Alkawa.Gameplay", "PlayerHealthSubComponent"];
        var PHSI = mono["Alkawa.Gameplay", "PlayerHealthStateInfo", 1];
        
        vars.Helper["health"] = PM.Make<int>(
            "m_PlayerComponent",
            PC["PlayerHealth"] + PAD,
            PHSC["m_playerHealthStateInfo"] + PAD,
            PHSI["m_internalCurrentHP"] + PAD
        );

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


        #region testing

        // access to static fields was 0 :(
        // var QM = mono["Alkawa.Gameplay", "QuestManager", 1];
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
    // Assets/_Game/Scenes    
    current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
    current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;

    vars.Watch(old, current, "activeScene");
    // vars.Watch(old, current, "loadingScene");
    vars.Watch(old, current, "level");
    vars.Watch(old, current, "shortLevel");
    vars.Watch(old, current, "inputMode");

    if (vars.states == null || vars.states.Count != current.activeStatesCount) {
        vars.states = vars.GetStates();
        vars.Log("[" + vars.states.Count + "] State set changed.");
        foreach (var state in vars.states) {
            vars.Log("  " + state);
        }
    }
}

onStart
{
    // refresh all splits when we start the run, none are yet completed
    vars.CompletedSplits.Clear();

    vars.Log(current.isPaused);
    vars.Log(current.health);
    vars.Log(current.level);
    vars.Log(current.inputMode);
    vars.Log(current.activeStatesHead.ToString("X"));
    
    #region testing
    // tests
    // vars.Log(current.a.ToString("X"));
    // vars.GetStates();

    vars.Log("active: " + vars.Helper.Scenes.Active.Address.ToString("X"));
    vars.Log(vars.Helper.Scenes.Active.Name);
    vars.Log(vars.Helper.Scenes.Active.Path);

    vars.Log("Loaded: " + vars.Helper.Scenes.Loaded.Count);

    // foreach (var scene in vars.Helper.Scenes.Loaded) {
    //     vars.Log(scene.Address.ToString("X"));
    //     vars.Log(scene.Name);
    //     vars.Log(scene.Path);
    // }
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
    return vars.states.Contains("GameFlowStateChangingLevel");
}