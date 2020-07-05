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
    // setting refresh rate of the memory check cycle
    refreshRate = 60;
	bool finalBoss = false;
	bool loadType = false;
	
	int levelType = 0;	//0:full_game; 1:standard_IL; 2:kidnap_IL; 3:worldEnd_IL; 4:lastLevel_IL
	
}

init {
    if(vars.hasCrashed) {
        // unpause the timer
		/*
        vars.timerModel.Pause();
		*/
        vars.hasCrashed = false;
        vars.hasStarted = true;
    }
    else {
        // resetting time if there was no crash
        vars.framesPassed = 0;
    }
}

exit {
    if(vars.timerModel.CurrentState.CurrentPhase == TimerPhase.Running) {
        // timer is still running but the game closed down. Probably crashed?
        vars.hasCrashed = true;
        vars.hasStarted = false;

        // pausing the timer
		/*
        vars.timerModel.Pause();
		*/
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
		vars.refreshRate = 60;
		vars.finalBoss = false;
		vars.loadType = false;
		
		return true;
	}
}

update {
    if(vars.hasStarted) {
        if(old.frameCount != null && current.frameCount != null) {
            vars.framesPassed += (current.frameCount - old.frameCount);
        }
    }
    else {
        // check if the user started the run
        if(vars.timerModel.CurrentState.CurrentPhase == TimerPhase.Running) {
            vars.framesPassed = 0;
			vars.hasStarted = true;
        }
    }
}

isLoading {
    return true;
}

gameTime {
    if(vars.framesPassed > 0) {
        return TimeSpan.FromMilliseconds((1000*vars.framesPassed)/60);
    }
}

split {
	//standard_IL
	if(
	timer.Run.GetExtendedCategoryName() == "1-1: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "1-2: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "1-3: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "1-4: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "1-5: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "2-1: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "2-2: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "2-3: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "2-4: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "2-6: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "2-7: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "2-8: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "2-9: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "3-1: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "3-2: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "3-3: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "3-4: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "3-6: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "3-7: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "3-8: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "3-9: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "4-1: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "4-2: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "4-3: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "4-4: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "4-6: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "4-7: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "4-8: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "5-1 I: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "5-2 I: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "5-3: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "5-4: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "5-5: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "5-1 II: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "5-2 II: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "5-6: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "5-7: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "6-1: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "6-2: Any% (Emulator)"
	) {
		vars.levelType = 1;
	}
	
	//kidnap_IL
	else if(
	timer.Run.GetExtendedCategoryName() == "2-5: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "3-5: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "4-5: Any% (Emulator)"
	) {
		vars.levelType = 2;
	}
	
	//worldEnd_IL
	else if(
	timer.Run.GetExtendedCategoryName() == "1-6: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "2-10: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "3-10: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "4-9: Any% (Emulator)" ||
	timer.Run.GetExtendedCategoryName() == "5-8: Any% (Emulator)"
	) {
		vars.levelType = 3;
	}
	
	//lastLevel_IL
	else if(
	timer.Run.GetExtendedCategoryName() == "6-3: Any% (Emulator)"
	) {
		vars.levelType = 4;
	}
	
	//full_game
	else {
		vars.levelType = 0;
	}


	// setting up loadType to be alternate between true and false every time there's a loading screen
	if(!(old.load1 == 0 && old.load2 == 0 && old.load3 == 0 && old.load4 == 1 && old.frameCount > 0)
	&& (current.load1 == 0 && current.load2 == 0 && current.load3 == 0 && current.load4 == 1 && current.frameCount > 0)) {
		if(vars.loadType == false){
			vars.loadType = true;
		}
		else {
			vars.loadType = false;
		}
	}
	
	// if the load game screen is entered, loadType is reset (to prevent the alternation from being shifted)
	if(old.load2 == 35521560 && current.load2 != 35521560) {
		vars.loadType = false;
	}
	
	
	// split when exiting a level:
		
	// end of a standard or kidnap IL
	if(vars.levelType == 1 || (vars.levelType == 2 && timer.CurrentSplitIndex == 2)) {
		if(!(old.load1 == 0 && old.load2 == 0 && old.load3 == 0 && old.load4 == 1 && old.frameCount > 0)
		&& (current.load1 == 0 && current.load2 == 0 && current.load3 == 0 && current.load4 == 1 && current.frameCount > 0)) {
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
	
	// full game or middle of kidnap IL
	if(vars.levelType == 0 && timer.CurrentSplitIndex < 53 || (vars.levelType == 2 && timer.CurrentSplitIndex < 2)) {	//the first mention of timer.CurrentSplitIndex here should correspond to [number of splits]-1
		if((old.load1 == 0 && old.load2 == 0 && old.load3 == 0 && old.load4 == 1 && old.frameCount > 0)
		&& !(current.load1 == 0 && current.load2 == 0 && current.load3 == 0 && current.load4 == 1 && current.frameCount > 0)
		&& vars.loadType == true) {
			return true;
		}
	}
	
	// world end IL
	if(vars.levelType == 3) {
		if(!(old.load1 == 1 && old.load2 == 0 && old.load3 == 1)
		&& (current.load1 == 1 && current.load2 == 0 && current.load3 == 1)) {
			return true;
		}
	}
	
	// split when final boss dies in full game or IL
	if(vars.levelType == 0 && timer.CurrentSplitIndex == 53 || vars.levelType == 4) {
		if(current.bosshp == 24) {
			vars.finalBoss = true;
		}
		if(vars.finalBoss == true && current.bosshp == 0) {
			return true;
		}
	}
	
}
