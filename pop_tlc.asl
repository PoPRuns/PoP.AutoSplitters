state("TheLostCrown") {}
state("TheLostCrown_plus") {}

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

    vars.Watch = (Action<IDictionary<string, object>, IDictionary<string, object>, string>)((oldLookup, currentLookup, key) => {
        var oldValue = oldLookup[key];
        var currentValue = currentLookup[key];

        if (oldValue != null && currentValue != null && !oldValue.Equals(currentValue))
            vars.Log(key + ": " + oldValue + " -> " + currentValue);
    });

    vars.CompletedSplits = new HashSet<string>();
    vars.IGTValue = 0;
    vars.IGTOffset = 0;
    vars.isDivineTrialsMode = false;

    vars.Helper.AlertLoadless();
}

init
{
    vars.NORMAL_START_SCENE = "KIN_BAT_02";
    vars.DLC_START_SCENE = "RAD_INT_01_BATTLEFIELD";

    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        // Asl-help has this issue where sometimes offsets resolve to 0x10 less than what they are meant to be, this is a fix to that...
        var PAD = 0x10;
        var CBH_STATE_OFFSET = 0x40;

        var PM = mono["Alkawa.Gameplay", "PauseManager"];
        vars.Helper["isPaused"] = PM.Make<bool>("m_paused");

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

        vars.CheckIfAbilityUnlocked = (Func<IntPtr, bool>)(ability => {
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


        // Boss
        var UIM = mono["Alkawa.Gameplay", "UIManager", 1];
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

        // Divine Trials
        var CM = mono["Alkawa.Gameplay", "ChallengeManager", 1];

        vars.Helper["challengeType"] = CM.Make<int>(
            "m_instance",
            CM["m_currentChallengeType"] + PAD
        );

        vars.Helper["challengeState"] = CM.Make<int>(
            "m_instance",
            CM["m_currentHandler"] + PAD,
            CBH_STATE_OFFSET
        );

        return true;
    });

    // This function is a helper for checking splits that may or may not exist in settings and if we want to do them only once
    vars.CheckSplit = (Func<string, bool>)(key => {
        // Make sure splits are enabled and timer is running
        if (!settings.SplitEnabled || timer.CurrentPhase != TimerPhase.Running) {
            return false;
        }

        // If the split doesn't exist, or it's off, or we've done it already
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
    vars.IGTValue = 0;
    vars.IGTOffset = 0;
}

start
{
    if (old.activeScene == "UIManager") return false;
    // Start in either base game or DLC starting scene
    if ((current.activeScene == vars.NORMAL_START_SCENE && old.activeScene == vars.NORMAL_START_SCENE) ||
        (current.activeScene == vars.DLC_START_SCENE && old.activeScene != vars.DLC_START_SCENE)) {
        vars.IGTOffset = -current.speedrunTimer;
        return true;
    };

    if (current.challengeType == 6 && old.challengeState == 2 && current.challengeState == 4 && current.speedrunTimer > 0) {
        vars.IGTOffset = -current.speedrunTimer;
        vars.isDivineTrialsMode = true;
        return true;
    }
}

reset {
    if (vars.isDivineTrialsMode && current.challengeState != 4 && current.challengeState != 8) {
        vars.isDivineTrialsMode = false;
        return true;
    }
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
        if ((current.activeScene == vars.NORMAL_START_SCENE || current.activeScene == vars.DLC_START_SCENE) && current.inputMode == 3) {
            vars.IGTOffset = -current.speedrunTimer;
        }
        vars.IGTValue = current.speedrunTimer;
    }
    return TimeSpan.FromSeconds(vars.IGTValue + vars.IGTOffset);
}

split
{
    if (!vars.isDivineTrialsMode) {
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

        if (settings["quest"]) {
            if (old.shortLevel != current.shortLevel && vars.CheckSplit("inlevel_" + current.shortLevel)) return true;

            if (vars.CheckSplit("level_action__" + current.level + "__" + current.playerAction)) return true;
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

    if (vars.isDivineTrialsMode && current.challengeState == 8) {
        vars.isDivineTrialsMode = false;
        return true;
    }
}
