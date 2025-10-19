state("The Rogue Prince of Persia") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "RoguePoP";
    vars.Helper.LoadSceneManager = true;
    vars.Helper.DataDirectory = "The Rogue Prince of Persia_Data";
    vars.Helper.Settings.CreateFromXml("Components/RoguePoP.Settings.xml");

    // Constants
    vars.FRESH_FILE_START_SCENE = "TutoScene";
    vars.SAVES_SCENE = "Start";
    vars.OASIS_SCENE = "HUBScene";
    vars.FINALBOSS_SCENE = "Nogai";
    vars.PLAYTIMESERVICE_INDEX = 23;
    vars.NOGAI_FLAG_INDEX = new int[]{1, 51};
    vars.FINALBOSS_FLAG_INDEX = new int[]{1, 52};
    vars.APPSEED_INDEX = new int[]{0, 0};

    vars.initialScenes = new HashSet<string> { "", "Bootstrap", "BootLoader", "GCManagerService", "Start", "HUBScene" };
    vars.checkNotInitialScenes = (Func<string, bool>)(scene => 
        !vars.initialScenes.Contains(scene)
    );

    // State
    vars.IGTValue = null;
    vars.is_fresh_file_mode = false;
    vars.just_created_file = false;
    vars.just_exited_oasis = false;

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
    int ptrSize = 0x8;
    int itemsOffset = 2 * ptrSize;
    int arrayStartOffset = 4 * ptrSize;

    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        var RSL = mono["Assembly-CSharp", "RuntimeServiceLocator"];
        var VPPTS = mono["Assembly-CSharp", "VarPlayPlaytimeService"];
        var PS = mono["Assembly-CSharp", "PlaytimeService"];
        var VLS = mono["Assembly-CSharp", "VariableListSaver"];
        var GVL = mono["Assembly-CSharp", "GameVariableList"];
        var VB = mono["MotherBase.ToolKit", "VarBool"];
        var VI = mono["MotherBase.ToolKit", "VarInt"];

        vars.getVarName = (Func<IntPtr, string>)(ptr => {
            string varName = vars.Helper.ReadString(ptr + VPPTS["name"]);
            return varName;
        });

        var getPSFloatField = (Func<string, dynamic>)(field => {
            return RSL.Make<float>(
                "_instance",
                RSL["variables"],
                itemsOffset,
                arrayStartOffset + vars.PLAYTIMESERVICE_INDEX*ptrSize,
                VPPTS["_value"],
                PS[field]
            );
        });

        var getVLSBoolField = (Func<int[], dynamic>)(variableIndex => {
            return VLS.Make<bool>(
                "_instance",
                VLS["listToSave"],
                itemsOffset,
                arrayStartOffset + variableIndex[0] * ptrSize,
                GVL["variables"],
                itemsOffset,
                arrayStartOffset + variableIndex[1] * ptrSize,
                VB["_value"]
            );
        });

        var getVLSIntField = (Func<int[], dynamic>)(variableIndex => {
            return VLS.Make<int>(
                "_instance",
                VLS["listToSave"],
                itemsOffset,
                arrayStartOffset + variableIndex[0] * ptrSize,
                GVL["variables"],
                itemsOffset,
                arrayStartOffset + variableIndex[1] * ptrSize,
                VI["_value"]
            );
        });

        vars.Helper["runPlaytime"] = getPSFloatField("runPlaytime");
        vars.Helper["totalRunsPlaytime"] = getPSFloatField("totalRunsPlaytime");

        vars.Helper["nogaiKilled"] = getVLSBoolField(vars.NOGAI_FLAG_INDEX);
        vars.Helper["finalBossKilled"] = getVLSBoolField(vars.FINALBOSS_FLAG_INDEX);
        vars.Helper["appSeed"] = getVLSIntField(vars.APPSEED_INDEX);

        return true;
    });

    old.activeScene = "";
    current.activeScene = "";
}

update
{
    current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
    timer.Run.Metadata.SetCustomVariable("seed", current.appSeed.ToString());
}

onReset
{
    vars.IGTValue = null;
}

start
{
    vars.just_created_file |=
        old.activeScene != vars.FRESH_FILE_START_SCENE &&
        current.activeScene == vars.FRESH_FILE_START_SCENE;

    vars.just_exited_oasis |=
        old.activeScene == vars.OASIS_SCENE &&
        current.activeScene != vars.OASIS_SCENE &&
        vars.checkNotInitialScenes(current.activeScene);

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
}

isLoading
{
    return true;
}

gameTime
{
    float old_seconds, current_seconds;

    if (vars.is_fresh_file_mode) {
        old_seconds = old.totalRunsPlaytime;
        current_seconds = current.totalRunsPlaytime;
    } else {
        old_seconds = old.runPlaytime;
        current_seconds = current.runPlaytime;
    }

    vars.IGTValue = vars.IGTValue ?? old_seconds;

    if (old_seconds > 0 && current_seconds > old_seconds) {
        vars.IGTValue += current_seconds - old_seconds;
    }
    
    return TimeSpan.FromSeconds(vars.IGTValue);
}

split
{
    if (settings["biome_split"] &&
        vars.checkNotInitialScenes(current.activeScene) &&
        old.activeScene != vars.SAVES_SCENE &&
        current.activeScene != old.activeScene
    ) return true;
    
    if (settings["nogai_one"] &&
        current.activeScene == vars.FINALBOSS_SCENE &&
        !old.nogaiKilled && current.nogaiKilled
    ) return true;
    
    if (settings["final_split"] &&
        current.activeScene == vars.FINALBOSS_SCENE &&
        !old.finalBossKilled && current.finalBossKilled
    ) return true;
}
