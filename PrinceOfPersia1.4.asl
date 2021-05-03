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
    byte Level3CP	: "DOSBox.exe", 0x193C370, 0x1E050;	     // Level 3 checkpoint flag (changes from 0-1)
    
    int RestartFlag0    : "DOSBox.exe", 0x193C370, 0x1D0E2;           // eien86's flag for restart detection
    int RestartFlag1    : "DOSBox.exe", 0x193C370, 0x1D0E6;           // eien86's flag for restart detection
    short RestartFlag2  : "DOSBox.exe", 0x193C370, 0x1D0EA;           // eien86's flag for restart detection
}

startup
{
    refreshRate = 30; // Prince of Persia runs at 12 fps, let's update 2.5x as often to be sure
    
    settings.Add("sound_settings", true, "Checking sound");
        settings.Add("sound", false, "Sound On At Start?", "sound_settings");
        
    settings.Add("split_settings", true, "Additional split configuration");
        settings.Add("disable_levelskip_detection", false, "Disable 'Level Skip' category detection (keep splits for levels 1-3)", "split_settings");
        settings.Add("merge_level_12", false, "Don't split between levels 12 and 13 (treat tower Level and Jaffar level as one segment)", "split_settings");
    
    settings.Add("single_level_mode", false, "Single level mode");
    
    vars.isLevelSkipMode = (Func<bool>) (() => {
        string categoryName = timer.Run.GetExtendedCategoryName().ToLower();
        //print("POPASL.isLevelSkipEnabled(): categoryName = " + categoryName);
        bool isLevelSkip = categoryName.Contains("level skip") || categoryName.Contains("levelskip");
        return isLevelSkip;
    });
    
    vars.getBaseFramesRemaining = (Func<int>) (() => {
        return (vars.isLevelSkipMode() ? (15) : (60)) * 720; 
    });
    
    vars.levelRestartSafetyBuffer = 30;  // resets are suppressed for 2.5s after CTRL+A
    vars.levelRestartTimestamp = 60*720;
    vars.levelChanged = false;
    vars.levelRestarted = false;
}

start
{
    // start (sound) && if starting level = 1 AND if level = 1 AND if Minutes = 60 AND count is = 47120384
    bool startGame = ((current.Sound == 0 && settings["sound"] == true) || (settings["sound"] == false)) &&
                     (current.Start == 0x1) && 
                     (current.Level == 0x1) && 
                     (current.MinutesLeft == 0x3C) && 
                     (current.Count >= 0x2CE0000);

    bool singleLevelModeRestart = (settings["single_level_mode"] == true && vars.levelRestarted == true);
    
    if (startGame) {
        vars.levelRestartTimestamp = 60*720;
        vars.levelRestarted = false;
        vars.levelChanged = false;
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
    
    bool singleLevelModeRestart = (settings["single_level_mode"] == true && levelRestartInProgress == true && levelTimeJustAppeared == true);
    bool singleLevelModeChangedLevel = (settings["single_level_mode"] == true && vars.levelChanged == true);

    if (notPlaying) {
        vars.levelRestartTimestamp = 60*720;
        vars.levelRestarted = false;
    } else if (singleLevelModeRestart || singleLevelModeChangedLevel) {
        int minutesLeft = current.MinutesLeft - 1;
        int totalFramesLeft = (minutesLeft * 720) + current.FrameSeconds;
        int adjustedFramesLeft = (minutesLeft < 0) ? 0 : totalFramesLeft; //time has expired
        
        if ((vars.levelChanged || adjustedFramesLeft <= (vars.levelRestartTimestamp - vars.levelRestartSafetyBuffer) || (adjustedFramesLeft > vars.levelRestartTimestamp))&&(!(current.Level == 3 && current.Level3CP == 1))) {
            vars.levelRestartTimestamp = adjustedFramesLeft;
            vars.levelRestarted = true;
            vars.levelChanged = false;
            singleLevelModeRestart = true;
        } else {
            singleLevelModeRestart = false;
        }
    }

    return (notPlaying || singleLevelModeRestart);
}

gameTime
{
    int minutesLeft = current.MinutesLeft - 1;
    int totalFramesLeft = (minutesLeft * 720) + current.FrameSeconds;
    int adjustedFramesLeft = (minutesLeft < 0) ? 0 : totalFramesLeft; //time has expired
    
    int baseFramesRemaining = vars.getBaseFramesRemaining();
    if (settings["single_level_mode"] == true) {
        baseFramesRemaining = vars.levelRestartTimestamp; //single level mode (use the time of restart as base time)
    }
    
    int elapsedFrames = (baseFramesRemaining) - adjustedFramesLeft;    
    double secondsElapsed = elapsedFrames / 12.0;
    if (old.Level == 13 && current.Level == 14) {
        secondsElapsed = secondsElapsed - 0.002;   // hack for splits.io issue - if last split is empty, gametime won't be available
    }
    //print("POPASL[gameTime]: secondsElapsed = " + secondsElapsed);
    return TimeSpan.FromSeconds(secondsElapsed);
}

split
{
    bool suppressFirstLevels = (settings["disable_levelskip_detection"] == false && vars.isLevelSkipMode() == true);
    bool suppressJaffarLevel = (settings["merge_level_12"] == true);
    
    bool skipFirstLevelsSplit  = suppressFirstLevels && (old.Level <= 3);
    bool skipJaffarLevelsSplit = suppressJaffarLevel && (old.Level == 12);
    
    bool skipSplit = (skipFirstLevelsSplit || skipJaffarLevelsSplit);
    
    bool doSplit = ((old.Level != current.Level) && !skipSplit) ||       // if level changes
                   (current.Level == 0xE && current.EndGame == 0xFF);    // if currently on level 14 and EndGame changes to 255

    if (doSplit && settings["single_level_mode"] == true) {
        vars.levelChanged = true;
    }
    
    return doSplit;
}

isLoading
{
    return true;
}
