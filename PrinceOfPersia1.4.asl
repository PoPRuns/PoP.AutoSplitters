// Game:           Prince of Persia v1.4
// Emulator:       DOSBox 0.74-3
// Original by:    ThePedMeister
// Updated by:     Karlgamer
// Overhaul by:    WinterThunder
// Tweaks by:      Smathlax, GMP
// Level restarts: eien86
// Updated:        2021-02-23
// IGT timing:     YES
//
// Base memory path is everything before final offset
// e.g. in ["DOSBox.exe", 0x193C370, 0x1D0F4] base path is the ["DOSBox.exe", 0x193C370].
//
// Base memory paths for versions:
// DOSBox 0.74:   0x193A1A0
// DOSBox 0.47-2: 0x0074F6D0
// DOSBox 0.47-3: "DOSBox.exe", 0x193C370
// 
// Note: DOSBox autosplitter breaks (doesn't find correct memory address) if you alter the dosbox.conf in a specific way.
// Known ways to break the autosplitter:
// 1. Alter the PATH system variable -> don't invoke SET PATH=xyz
// 2. Set gus=true (make sure gus is set to false)

state("DOSBOX")
{
    byte Level          : "DOSBox.exe", 0x193C370, 0x1D0F4;          // shows level 1-14 changes as door is entered
    byte Scene          : "DOSBox.exe", 0x193C370, 0x1A4BA;          // shows level 1-14 changes as scenes end
    byte EndGame        : "DOSBox.exe", 0x193C370, 0x1D74A;          // 0 before endgame, 255 at endgame cutscene
    byte Start          : "DOSBox.exe", 0x193C370, 0x1D694;          // the level you start the game at
    byte GameRunning    : "DOSBox.exe", 0x19175EA;                   // 0 if game isn't running
    byte MinutesLeft    : "DOSBox.exe", 0x193C370, 0x1E350;          // Minutes
    int  Count          : "DOSBox.exe", 0x193C370, 0x1E354;          // Frames
    short FrameSeconds  : "DOSBox.exe", 0x193C370, 0x1E356;          // Frames in second part of time (720-0)
    byte Sound          : "DOSBox.exe", 0x193C370, 0x2F233;          // 0 if sound is on, 1 if sound is off
    byte Room           : "DOSBox.exe", 0x193C370, 0x1D107;          // shows current room ID
    byte IsRestartLevel : "DOSBox.exe", 0x193C370, 0x1E16A;          // the is_restart_level (Ctrl+A) flag
    byte LevelTextTime  : "DOSBox.exe", 0x193C370, 0x1F35E;          // frames left for showing the "Level N" text
    byte Level3CP       : "DOSBox.exe", 0x193C370, 0x1E050;          // Level 3 checkpoint flag (changes from 0-1)
    
    int RestartFlag0    : "DOSBox.exe", 0x193C370, 0x1D0E2;           // eien86's flag for restart detection
    int RestartFlag1    : "DOSBox.exe", 0x193C370, 0x1D0E6;           // eien86's flag for restart detection
    short RestartFlag2  : "DOSBox.exe", 0x193C370, 0x1D0EA;           // eien86's flag for restart detection
}

startup
{
    refreshRate = 30; // Prince of Persia runs at 12 fps, let's update 2.5x as often to be sure
    
    settings.Add("sound_settings", true, "Checking sound");
        settings.Add("sound", false, "Sound On At Start?", "sound_settings");
    
    settings.Add("split_settings", true, "Split configuration");
        settings.Add("disable_levelskip_detection", false, "Disable 'Level Skip' category detection (keep splits for levels 1-3)", "split_settings");
        settings.Add("merge_level_12", false, "Don't split between levels 12 and 13 (treat tower Level and Jaffar level as one segment)", "split_settings");
    
    settings.Add("single_level_mode", false, "Individual level mode");

    settings.Add("il_timer_layout", false, "Calculate IL time during full runs (Adds 2 more rows in the layout)");
    
     vars.isLevelSkipMode = (Func<bool>) (() => {
        string categoryName = timer.Run.GetExtendedCategoryName().ToLower();
        //print("POPASL.isLevelSkipEnabled(): categoryName = " + categoryName);
        bool isLevelSkip = categoryName.Contains("level skip") || categoryName.Contains("levelskip");
        return isLevelSkip;
    });
    
    vars.levelRestartSafetyBuffer = 30;  // resets are suppressed for 2.5s after CTRL+A
    vars.levelRestartTimestamp = 60*720;
    vars.levelRestartILTimestamp = 60*720;
    vars.levelChanged = false;
    vars.levelRestarted = false;
    vars.levelSkipActivated = false;
    vars.previousILTime = TimeSpan.FromSeconds(0);
    vars.currentILTime = TimeSpan.FromSeconds(0);
    vars.CompletedIL = 0;
    
    vars.SetTextComponent = (Action<string, string>)((id, text) => {
        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
        if (textSetting == null)
        {
        var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
        var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
        timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));

        textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
        textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
        }

        if (textSetting != null)
        textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
    });

    vars.RemoveTextComponent = (Action<string>)((id) => {
        int indexToRemove = -1;
        foreach (dynamic component in timer.Layout.Components) {
            if (component.GetType().Name == "TextComponent" && System.Text.RegularExpressions.Regex.IsMatch(component.Settings.Text1, id)) {
                indexToRemove = timer.Layout.Components.ToList().IndexOf(component);
                break;
            }
        }
        if (indexToRemove != -1) {
            timer.Layout.LayoutComponents.RemoveAt(indexToRemove);
        }
    });
}

start
{
    // start if sound check passes AND start variable = 1 AND if level = 1 AND if Minutes = 60 AND count is >= 47120384
    bool startGame = ((current.Sound == 0 && settings["sound"] == true) || (settings["sound"] == false)) &&
                     (current.Start == 0x1) && 
                     (current.Level == 0x1) && 
                     (current.MinutesLeft == 0x3C) && 
                     (current.Count >= 0x2CE0000);

    bool singleLevelModeRestart = (settings["single_level_mode"] && vars.levelRestarted);
    
    if (startGame) {
        vars.levelRestartTimestamp = 60*720;
        vars.levelRestartILTimestamp = 60*720;
        vars.levelRestarted = false;
        vars.levelChanged = false;
        vars.levelSkipActivated = false;
    } else if (singleLevelModeRestart) {
        vars.levelRestarted = false;
    }

    return (startGame || singleLevelModeRestart);
}

reset
{
    
    // reset if starting level isn't 1 OR game has quit
    bool notPlaying = (current.Start == 0x0) || (current.GameRunning == 0x0);
    
    bool levelRestartInProgress = (current.RestartFlag0 == -1) &&
                                  (current.RestartFlag1 == -1) &&
                                  (current.RestartFlag2 == -1);
    
    bool levelTimeJustAppeared = (current.LevelTextTime == 24);
    
    //print("POPASL.flags: " + current.RestartFlag0 + " " + current.RestartFlag1 + " " + current.RestartFlag2);
    
    bool singleLevelModeRestart = (settings["single_level_mode"] && levelRestartInProgress && levelTimeJustAppeared);
    bool singleLevelModeChangedLevel = (settings["single_level_mode"] && vars.levelChanged);

    if (notPlaying) {
        vars.levelRestartTimestamp = 60*720;
        vars.levelRestarted = false;
        vars.levelSkipActivated = false;
    } else if (singleLevelModeRestart || singleLevelModeChangedLevel) {
        if ((vars.levelChanged ||
            (current.Level == 1 && vars.adjustedFramesLeft <= vars.levelRestartTimestamp - vars.levelRestartSafetyBuffer) ||
            (current.Level != 1 && vars.adjustedFramesLeft <= vars.levelRestartTimestamp) ||
            (vars.adjustedFramesLeft > vars.levelRestartTimestamp)) && 
            !(current.Level == 3 && current.Level3CP == 1)) {
                vars.levelRestartTimestamp = vars.adjustedFramesLeft;
                vars.levelRestarted = true;
                vars.levelChanged = false;
                singleLevelModeRestart = true;
        } else {
                singleLevelModeRestart = false;
        }
    }
    
    if (levelTimeJustAppeared && !(current.Level == 3 && current.Level3CP == 1) && current.Level != 1) {
        vars.levelRestartILTimestamp = vars.adjustedFramesLeft;
    }
    
    return (notPlaying || singleLevelModeRestart);
}

onReset
{
    vars.RemoveTextComponent("Previous IL");
    vars.RemoveTextComponent("Current IL Time");
}

gameTime
{
    vars.minutesLeft = current.MinutesLeft - 1;
    vars.totalFramesLeft = (vars.minutesLeft * 720) + current.FrameSeconds;
    vars.adjustedFramesLeft = (vars.minutesLeft < 0) ? 0 : vars.totalFramesLeft; //time has expired
    
    //Level skip category detection
    if (!(old.MinutesLeft == 15 && (old.FrameSeconds == 718 || old.FrameSeconds == 719)) && 
       (current.MinutesLeft == 15 && current.FrameSeconds == 718) &&
       !settings["single_level_mode"] &&
       !vars.levelSkipActivated) {
        vars.levelSkipActivated = true;
    }
    
    int baseFramesRemaining = settings["single_level_mode"] ? vars.levelRestartTimestamp : ((vars.levelSkipActivated ? (15) : (60)) * 720);
    int elapsedFrames = baseFramesRemaining - vars.adjustedFramesLeft;
    double secondsElapsed = elapsedFrames / 12.0;
    
    if (vars.isLevelSkipMode() && !vars.levelSkipActivated) {
        secondsElapsed = 0.000;
    }
    if(old.Level == 13 && current.Level == 14 && !settings["single_level_mode"]) {
        secondsElapsed -= 0.002;   // hack for splits.io issue - if last split is empty, gametime won't be available
    }

    if (current.Level == 1) {
        vars.currentILTime = TimeSpan.FromSeconds(secondsElapsed);
    }
    else {
        vars.currentILTime = TimeSpan.FromSeconds((vars.levelRestartILTimestamp - vars.adjustedFramesLeft)/12.0);
    }
    
    //print("POPASL[gameTime]: secondsElapsed = " + secondsElapsed);
    return TimeSpan.FromSeconds(secondsElapsed);
}

split
{
    if (!settings["single_level_mode"] && settings["il_timer_layout"]) {
        if (vars.CompletedIL > 0) {
            string previousILTimeString = "Level " + vars.CompletedIL.ToString() + " in " + vars.previousILTime.ToString("mm\\:ss\\.fff");
            vars.SetTextComponent("Previous IL", previousILTimeString);
        } else {
            vars.SetTextComponent("Previous IL", "-");
        }

        if (current.Level <= 14) {
            string currentILTimeString = vars.currentILTime.ToString("mm\\:ss\\.fff");
            vars.SetTextComponent("Current IL Time", currentILTimeString);
        }
    }
    
    bool suppressFirstLevels = (!settings["disable_levelskip_detection"] && vars.isLevelSkipMode() && old.Level <= 3) ;
    bool suppressJaffarLevel = (settings["merge_level_12"] && old.Level == 12);
    
    bool skipSplit = (suppressFirstLevels || suppressJaffarLevel);
    
    bool doSplit = ((old.Level != current.Level) && !skipSplit) ||       // if level changes
                   (current.Level == 14 && current.EndGame == 0xFF);     // if currently on level 14 and EndGame changes to 255 (FF in hexadecimal)

    if (doSplit && settings["single_level_mode"]) {
        vars.levelChanged = true;
    }
    
    if (doSplit) {
        vars.previousILTime = vars.currentILTime;
        vars.CompletedIL = old.Level;
    }
    
    return doSplit;
}

isLoading
{
    return true;
}
