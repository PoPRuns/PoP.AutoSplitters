// Game:           Prince of Persia v1.4
// Emulator:       DOSBox 0.74-3
// Original by:    ThePedMeister
// Updated by:     Karlgamer
// Overhaul by:    WinterThunder
// Tweaks by:      Smathlax, GMP
// Level restarts: eien86
// Updated:        2023-08-21
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
    byte Level          : "DOSBox.exe", 0x193C370, 0x1D0F4;          // shows level 1-14 changes as door is entered ('next_level' variable)
    byte Scene          : "DOSBox.exe", 0x193C370, 0x1A4BA;          // shows level 1-14 changes as cutscenes end   ('curr_level' variable)
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

    int RestartFlag0    : "DOSBox.exe", 0x193C370, 0x1D0E2;          // eien86's flag for restart detection
    int RestartFlag1    : "DOSBox.exe", 0x193C370, 0x1D0E6;          // eien86's flag for restart detection
    short RestartFlag2  : "DOSBox.exe", 0x193C370, 0x1D0EA;          // eien86's flag for restart detection
}

startup
{
    refreshRate = 30; // Prince of Persia runs at 12 fps, let's update 2.5x as often to be sure

    settings.Add("sound", false, "Check if sound is enabled at game start");
    settings.SetToolTip("sound", "Prevent starting the timer if sound is OFF (useful in No Major Glitches, where sound on is required)");

    settings.Add("split_settings", false, "Split configuration");
        settings.Add("merge_level_12", false, "Don't split between levels 12 and 13", "split_settings");
        settings.SetToolTip("merge_level_12", "Treat tower Level (level 12) and Jaffar level (level 12a) as one segment)");
        settings.Add("split_on_next_level", false, "Split on 'next_level' instead of 'current_level'", "split_settings");
        settings.SetToolTip("split_on_next_level", "Enable legacy splitting point - right after the Prince enters the stairs, when the music starts playing");

    settings.Add("level_skip", true, "Level Skip mode config");
        settings.Add("level_skip_detection_category_name", true, "Detect category name (keep time at 0:00.00 until SHIFT+L)", "level_skip");
        settings.SetToolTip("level_skip_detection_category_name", "Detect \"Level Skip\" or \"levelskip\" in category name to enable the mode");
        settings.Add("level_skip_detection_shift_l", true, "Treat every SHIFT+L as Level Skip mode (even if category detection is disabled)", "level_skip");
        settings.Add("level_skip_split_initial_levels", false, "Keep splitting between levels 1-3 even if Level Skip mode detected", "level_skip");

    settings.Add("single_level_mode", false, "Individual level mode");
        settings.Add("single_level_timerbug_fix", true, "Timer bug fix", "single_level_mode");
        settings.SetToolTip("single_level_timerbug_fix", "Ensure that the number of timerbug frames is equal to expected number in a full run");

    vars.functionsInitialized = false;

    vars.FRAMES_PER_MINUTE = 720;
    vars.NORMAL_MODE_BASE_FRAMES_REMAINING = 60 * vars.FRAMES_PER_MINUTE;
    vars.LEVEL_SKIP_BASE_FRAMES_REMAINING = 15 * vars.FRAMES_PER_MINUTE;

    vars.levelRestartTimestamp = vars.NORMAL_MODE_BASE_FRAMES_REMAINING;
    vars.leveTimerbugFrames = 0;
    vars.levelChanged = false;
    vars.levelRestarted = false;
    vars.levelSkipModeDetected = false;
    vars.levelSkipActivated = false;

    vars.DEBUG = false;
    vars.print = (Action<string>) (message => print("[POPASL] " + message));
}

update
{
    //we have to do that here instead of 'startup' to access actual Settings and not SettingsBuilder
    if (vars.functionsInitialized == false) {
        vars.functionsInitialized = true;
        vars.print("loading functions...");

        /**
        * Routine for checking if game has been started
        */
        vars.gameStarted = (Func<bool>) (() => {
            // start if sound check passes AND start variable = 1 AND if level = 1 AND if Minutes = 60 AND count is >= 47120384
            return ((current.Sound == 0 && settings["sound"] == true) || (settings["sound"] == false)) &&
                    (current.Start == 0x1) &&
                    (current.Level == 0x1) &&
                    (current.MinutesLeft == 0x3C) &&
                    (current.Count >= 0x2CE0000);
        });

        /**
        * Routine for checking if "level skip" is present in category name.
        *
        * Optimized to only be called on start.
        */
        vars.checkLevelSkipCategory = (Func<bool>) (() => {
            bool isLevelSkipCategory = false;
            if (settings["level_skip_detection_category_name"] == true) {
                string categoryName = timer.Run.GetExtendedCategoryName().ToLower();
                vars.print("checkLevelSkipCategory() categoryName = " + categoryName);
                isLevelSkipCategory = categoryName.Contains("level skip") || categoryName.Contains("levelskip");
            }
            return isLevelSkipCategory;
        });

        /**
        * Routine for checking if the autosplitter is currently in level skip mode.
        */
        vars.levelSkipMode = (Func<bool>) (() => !settings["single_level_mode"] && (vars.levelSkipModeDetected || vars.levelSkipActivated) );

        /**
        * Routine for checking whether SHIFT+L was just pressed.
        */
        vars.shiftLPressed = (Func<bool>) (() => {
            bool pressed = false;
            if (!(old.MinutesLeft == 15 && (old.FrameSeconds == 718 || old.FrameSeconds == 719)) &&
            (current.MinutesLeft == 15 && current.FrameSeconds == 718)) {
                pressed = true;
            }
            return pressed;
        });

        /**
        * Routines for calculating game times for various categories.
        */
        vars.gameTime = new ExpandoObject();
        vars.gameTime.normal = (Func<int>) (() => vars.NORMAL_MODE_BASE_FRAMES_REMAINING - vars.adjustedFramesLeft );
        vars.gameTime.individualLevel = (Func<int>) (() => {
            int frames = vars.levelRestartTimestamp - vars.adjustedFramesLeft;

            if (settings["single_level_timerbug_fix"] == false) return frames;

            int expectedTimerbugFrames = (int) Math.Floor(Math.Max(0.0, frames - 1) / vars.FRAMES_PER_MINUTE);
            int trueFrames = frames - vars.leveTimerbugFrames;
            int correctedFrames = trueFrames + expectedTimerbugFrames;

            // vars.print("FRAMES: elapsed: " + frames + ", timerbugs: " + vars.leveTimerbugFrames + ", expected: " + expectedTimerbugFrames);
            // vars.print("TIME: elapsed: " + ((double)frames / 12) + ", corrected: " + ((double)correctedFrames / 12));

            return correctedFrames;
        });
        vars.gameTime.levelSkip = (Func<int>) (() => {
            if (vars.levelSkipActivated) {
                return vars.LEVEL_SKIP_BASE_FRAMES_REMAINING - vars.adjustedFramesLeft;
            } else {
                return 0;
            }
        });

        /**
        * Routines for calculating reset condition for various categories.
        */
        vars.reset = new ExpandoObject();
        vars.reset.normal = (Func<bool>) (() => {
            // reset if starting level isn't 1 OR game has quit
            bool notPlaying = (current.Start == 0x0) || (current.GameRunning == 0x0);
            return notPlaying;
        });
        vars.reset.individualLevel = (Func<bool, bool>) ((levelJustRestarted) => {
            bool levelTimeJustAppeared = (current.LevelTextTime == 24);
            bool singleLevelModeRestart = (settings["single_level_mode"] && levelJustRestarted && levelTimeJustAppeared);
            bool singleLevelModeChangedLevel = (settings["single_level_mode"] && vars.levelChanged);

            if (singleLevelModeRestart || singleLevelModeChangedLevel) {
                if ((vars.levelChanged ||
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
            return singleLevelModeRestart;
        });

        vars.print("functions loaded");
    }

    vars.levelSkipActivated = vars.levelSkipActivated || vars.shiftLPressed() && (vars.levelSkipModeDetected || settings["level_skip_detection_shift_l"] == true);
    if (old.MinutesLeft - current.MinutesLeft == 1) {
        vars.leveTimerbugFrames++;
        vars.print("timerbug frame detected in current run, total: " + vars.leveTimerbugFrames);
    }
}

start
{
    bool startGame = vars.gameStarted();
    bool singleLevelModeRestart = (settings["single_level_mode"] && vars.levelRestarted);

    if (startGame) {
        vars.levelRestartTimestamp = 60*720;
        vars.levelRestarted = false;
        vars.levelChanged = false;
        vars.levelSkipActivated = false;
    } else if (singleLevelModeRestart) {
        vars.levelRestarted = false;
    }

    return (startGame || singleLevelModeRestart);
}

onStart {
    vars.levelSkipActivated = false;
    vars.levelSkipModeDetected = vars.checkLevelSkipCategory();
    vars.leveTimerbugFrames = 0;
}

reset
{
    bool wasLevelRestartInProgress = (old.RestartFlag0 == -1) && (old.RestartFlag1 == -1) && (old.RestartFlag2 == -1);
    bool isLevelRestartInProgress = (current.RestartFlag0 == -1) && (current.RestartFlag1 == -1) && (current.RestartFlag2 == -1);
    bool levelJustRestarted = isLevelRestartInProgress && !wasLevelRestartInProgress;

    bool normalReset = vars.reset.normal();
    bool individualLevelReset = vars.reset.individualLevel(levelJustRestarted);

    if (normalReset) {
        vars.levelRestartTimestamp = vars.NORMAL_MODE_BASE_FRAMES_REMAINING;
        vars.levelRestarted = false;
    }

    return (normalReset || individualLevelReset);
}

gameTime
{
    vars.minutesLeft = current.MinutesLeft - 1;
    vars.totalFramesLeft = (vars.minutesLeft * vars.FRAMES_PER_MINUTE) + current.FrameSeconds;
    vars.adjustedFramesLeft = (vars.minutesLeft < 0) ? 0 : vars.totalFramesLeft; //time has expired

    double secondsElapsed = 0.00;
    int framesElapsed = 0;
    if (settings["single_level_mode"] == true) {
        framesElapsed = vars.gameTime.individualLevel();
    } else if (vars.levelSkipMode()) {
        framesElapsed = vars.gameTime.levelSkip();
    } else {
        framesElapsed = vars.gameTime.normal();
    }

    secondsElapsed = framesElapsed / 12.0;

    if(old.Level == 13 && current.Level == 14 && !settings["single_level_mode"]) {
        secondsElapsed -= 0.002;   // hack for splits.io issue - if last split is empty, gametime won't be available
    }

    // vars.print("secondsElapsed = " + secondsElapsed);
    return TimeSpan.FromSeconds(secondsElapsed);
}

split
{
    byte oldLevel = settings["split_on_next_level"] ? old.Level : old.Scene;
    byte currentLevel = settings["split_on_next_level"] ? current.Level : current.Scene;

    bool suppressFirstLevels = (!settings["level_skip_split_initial_levels"] && vars.levelSkipMode() && currentLevel <= 4) ;
    bool suppressJaffarLevel = (settings["merge_level_12"] && old.Level == 12);

    bool skipSplit = (suppressFirstLevels || suppressJaffarLevel);

    bool levelChanged = (oldLevel != currentLevel);                       // if level changes
    bool gameFinished = (current.Level == 14 && current.EndGame == 0xFF); // if currently on level 14 and EndGame changes to 255 (FF in hexadecimal)

    bool doSplit = (levelChanged && !skipSplit) || gameFinished;

    if (doSplit && settings["single_level_mode"]) {
        vars.levelChanged = true;
    }

    return doSplit;
}

isLoading
{
    return true;
}
