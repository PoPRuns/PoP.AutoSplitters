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
    vars.OASIS_SCENE = "HUBScene";
    vars.FINALBOSS_SCENE = "Nogai";
    vars.PLAYTIMESERVICE_INDEX = 23;
    vars.FINALBOSS_FLAG_INDEX = new int[]{1, 52};

    vars.initialScenes = new HashSet<string> { "Bootstrap", "GCManagerService", "Start", "HUBScene" };
    vars.checkNotInitialScenes = (Func<string, bool>)(scene => 
        !vars.initialScenes.Contains(scene)
    );

    // State
    vars.is_fresh_file_mode = false;
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

        vars.getVarName = (Func<IntPtr, string>)(ptr => {
            string varName = vars.Helper.ReadString(ptr + VPPTS["name"]);
            return varName;
        });

        vars.Helper["runPlaytime"] = RSL.Make<float>(
            "_instance",
            RSL["variables"],
            itemsOffset,
            arrayStartOffset + vars.PLAYTIMESERVICE_INDEX*ptrSize,
            VPPTS["_value"],
            PS["runPlaytime"]
        );

        vars.Helper["totalRunsPlaytime"] = RSL.Make<float>(
            "_instance",
            RSL["variables"],
            itemsOffset,
            arrayStartOffset + vars.PLAYTIMESERVICE_INDEX*ptrSize,
            VPPTS["_value"],
            PS["totalRunsPlaytime"]
        );

        vars.Helper["finalBossKilled"] = VLS.Make<bool>(
            "_instance",
            VLS["listToSave"],
            itemsOffset,
            arrayStartOffset + vars.FINALBOSS_FLAG_INDEX[0]*ptrSize,
            GVL["variables"],
            itemsOffset,
            arrayStartOffset + vars.FINALBOSS_FLAG_INDEX[1]*ptrSize,
            VB["_value"]
        );

        return true;
    });

    old.activeScene = "";
    current.activeScene = "";
}

update
{
    current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
}

start
{
    vars.is_fresh_file_mode =
        settings["fresh_file_start"] &&
        old.activeScene != vars.FRESH_FILE_START_SCENE &&
        current.activeScene == vars.FRESH_FILE_START_SCENE;
    
    vars.just_exited_oasis = vars.just_exited_oasis || (
        old.activeScene == vars.OASIS_SCENE &&
        current.activeScene != vars.OASIS_SCENE &&
        vars.checkNotInitialScenes(current.activeScene)
    );

    bool oasis_start =
        settings["oasis_start"] &&
        vars.just_exited_oasis &&
        current.runPlaytime < old.runPlaytime &&
        vars.checkNotInitialScenes(current.activeScene);

    return vars.is_fresh_file_mode || oasis_start;
}

onStart
{
    vars.just_exited_oasis = false;
}

isLoading
{
    return true;
}

gameTime
{
    float seconds = vars.is_fresh_file_mode ? current.totalRunsPlaytime : current.runPlaytime;
    return TimeSpan.FromSeconds(seconds);
}

split
{
    bool biome_split = 
        settings["biome_split"] &&
        vars.checkNotInitialScenes(current.activeScene) &&
        current.activeScene != old.activeScene;

    bool final_split = 
        settings["final_split"] &&
        current.activeScene == vars.FINALBOSS_SCENE &&
        !old.finalBossKilled && current.finalBossKilled;

    return biome_split || final_split;
}
