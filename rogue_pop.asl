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
    vars.PLAYTIMESERVICE_INDEX = 23;

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
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        var RSL = mono["Assembly-CSharp", "RuntimeServiceLocator"];
        var VPPTS = mono["Assembly-CSharp", "VarPlayPlaytimeService"];
        var PS = mono["Assembly-CSharp", "PlaytimeService"];

        vars.Helper["rslVarList"] = RSL.MakeList<IntPtr>(
            "_instance",
            RSL["variables"]
        );

        vars.getVarName = (Func<IntPtr, string>)(ptr => {
            string varName = vars.Helper.ReadString(ptr + VPPTS["name"]);
            return varName;
        });

        vars.getVarPtr = (Func<IntPtr, IntPtr>)(ptr => {
            IntPtr varPtr = vars.Helper.Read<IntPtr>(ptr + VPPTS["_value"]);
            return varPtr;
        });

        vars.getPSFloatField = (Func<IntPtr, string, float>)((ptr, field) => {
            float runPlaytime = vars.Helper.Read<float>(ptr + PS[field]);
            return runPlaytime;
        });

        return true;
    });

    old.activeScene = "";
    current.activeScene = "";
}

update
{
    current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
    IntPtr psPtr = vars.getVarPtr(current.rslVarList[vars.PLAYTIMESERVICE_INDEX]);
    current.runPlaytime = vars.getPSFloatField(psPtr, "runPlaytime");
    current.totalRunsPlaytime = vars.getPSFloatField(psPtr, "totalRunsPlaytime");
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
    bool oasis_split = 
        settings["oasis_split"] &&
        !vars.is_fresh_file_mode &&
        vars.checkNotInitialScenes(current.activeScene) &&
        current.activeScene != old.activeScene;

    return oasis_split;
}
