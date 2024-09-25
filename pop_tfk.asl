state("DeSmuME_0.9.9_x64") {
    int frameCount : 0x51D04A8;
    int load1 : 0x5304E34;	//0 at loads and 1 at all other screens
    int load2 : 0x55BB464;	//Weird at ubi screen/profile screen, 0 at lang screen/erase screen/loads, 1 at gameplay (including dialouge)
    int load3 : 0x82365C4;	//0 at world dialouge/quit screen/loads, 1 at gameplay
    int load4 : 0x55BB040;	//1 at loads and 0 in other situations
    int bosshp : 0x55AB0D4;		//Boss health
}

startup {
    vars.hasCrashed = false;
    vars.hasStarted = false;
    vars.framesPassed = 0;

    vars.timerModel = new TimerModel { CurrentState = timer };
    
    // Setting refresh rate of the memory check cycle
    refreshRate = 120;

    // Global Constants
    vars.PlatformFrameRate = 59.82609828808082;
    vars.LastSplitIndex = 53;

    // Mapping the number of levels in each world
    Dictionary<int, int> numberOfLevels = new Dictionary<int, int>
    {
        {1, 6},
        {2, 10},
        {3, 10},
        {4, 9},
        {5, 8},
        {6, 3},
    };
    
    // Levels where Zal gets kidnapped
    vars.kidnapILs = new List<string> {"2-5", "3-5", "4-5"};
    
    vars.standardILs = new List<string>();
    vars.WorldEndILs = new List<string>();
    foreach (var mapping in numberOfLevels)
    {
        // All levels except last level in each world and kidnap levels
        for (int i = 1; i < mapping.Value; i++) {
            string levelName = mapping.Key.ToString() + "-" + i.ToString();
            if (!vars.kidnapILs.Contains(levelName)) {
                vars.standardILs.Add(levelName);
            }
        }
        // Last level in each world except the last world
        if (mapping.Key != 6) {
            string levelName = mapping.Key.ToString() + "-" + mapping.Value.ToString();
            vars.WorldEndILs.Add(levelName);
        }
    }
    // Last level in the game
    vars.lastLevelIL = "6-3";
    
    /* This variable will be use to determine the logic:
        0 - Full Game
        1 - Standard IL
        2 - Kidnap IL
        3 - World End IL
        4 - Last Level
    */
    vars.levelType = 0;
}

init {
    if (vars.hasCrashed) {
        // unpause the timer
        vars.hasCrashed = false;
        vars.hasStarted = true;
    }
    else {
        // resetting time if there was no crash
        vars.framesPassed = 0;
    }
}

exit {
    if (vars.timerModel.CurrentState.CurrentPhase == TimerPhase.Running) {
        // Assumption - timer is still running but the game closed down. Probably crashed.
        // pausing the timer
        vars.hasCrashed = true;
        vars.hasStarted = false;
    }
}

start {
    //Detecting first load screen over
    if(old.load2 == 0 && current.load2 == 1 && old.load3 == 0) {
    
        // Repeating startup to reset the run
        vars.hasCrashed = false;
        vars.hasStarted = false;
        vars.framesPassed = 0;
        vars.timerModel = new TimerModel { CurrentState = timer };
        vars.finalBoss = false;
        vars.loadType = false;
        
        return true;
    }
}

update {
    if(vars.hasStarted) {
        if (old.frameCount != null && current.frameCount != null) {
            vars.framesPassed += (current.frameCount - old.frameCount);
        }
    }
    else {
        // check if the user started the run
        if (vars.timerModel.CurrentState.CurrentPhase == TimerPhase.Running) {
            vars.framesPassed = 0;
            vars.hasStarted = true;
        }
    }
}

isLoading {
    return true;
}

gameTime {
    if (vars.framesPassed > 0) {
        return TimeSpan.FromMilliseconds( (1000 * vars.framesPassed) / vars.PlatformFrameRate );
    }
}

split {
    // Get the category name and (try to) split by ":" to see if it's an IL
    string[] categoryParts = timer.Run.GetExtendedCategoryName().Split(':');
    
    // Setting level type if its IL
    if (categoryParts.Length > 1) {
        // Get the relevant part of the string and remove "I" to handle 5-1 and 5-2
        string ILName = categoryParts[0].Replace("I", "").Trim();
        
        if (vars.standardILs.Contains(ILName)) {
            vars.levelType = 1;
        }
        else if (vars.kidnapILs.Contains(ILName)) {
            vars.levelType = 2;
        }
        else if (vars.WorldEndILs.Contains(ILName)) {
            vars.levelType = 3;
        }
        else if (vars.lastLevelIL == ILName) {
            vars.levelType = 4;
        }
    }

    bool oldCycleLoad = (old.load1 == 0 && old.load2 == 0 && old.load3 == 0 && old.load4 == 1 && old.frameCount > 0);
    bool currentCycleLoad = (current.load1 == 0 && current.load2 == 0 && current.load3 == 0 && current.load4 == 1 && current.frameCount > 0);

    // Setting up loadType to be alternate between true and false every time there's a loading screen
    if (!oldCycleLoad && currentCycleLoad) {
        vars.loadType = !vars.loadType;
    }
    
    // If the load game screen is entered, loadType is reset (to prevent the alternation from being shifted)
    if(old.load2 == 35521560 && current.load2 != 35521560) {
        vars.loadType = false;
    }
    
    
    // Split when exiting a level:
        
    // End of a standard or kidnap IL
    if(vars.levelType == 1 || (vars.levelType == 2 && timer.CurrentSplitIndex == 2)) {
        if(!oldCycleLoad && currentCycleLoad) {
            if(vars.levelType == 1) {
                return true;
            }
            else {
                if(vars.loadType == true) {
                    return true;
                }
            }
        }
    }
    
    // Full game or middle of kidnap IL
    if(vars.levelType == 0 && timer.CurrentSplitIndex < vars.LastSplitIndex || (vars.levelType == 2 && timer.CurrentSplitIndex < 2)) {
        if(oldCycleLoad && !currentCycleLoad && vars.loadType == true) {
            return true;
        }
    }
    
    // World end IL
    if(vars.levelType == 3) {
        if(!(old.load1 == 1 && old.load2 == 0 && old.load3 == 1)
        && (current.load1 == 1 && current.load2 == 0 && current.load3 == 1)) {
            return true;
        }
    }
    
    // Split when final boss dies in full game or IL
    if(vars.levelType == 0 && timer.CurrentSplitIndex == vars.LastSplitIndex || vars.levelType == 4) {
        if(current.bosshp == 24) {
            vars.finalBoss = true;
        }
        if(vars.finalBoss == true && current.bosshp == 0) {
            return true;
        }
    }
}
