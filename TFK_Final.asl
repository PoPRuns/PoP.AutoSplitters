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
}

init {
    if(vars.hasCrashed) {
        // unpause the timer
        vars.timerModel.Pause();
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
        vars.timerModel.Pause();
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
	
	// split when exiting a level
	if(timer.CurrentSplitIndex < 53) {		// the number here must be [number of splits]-1
		if((old.load1 == 0 && old.load2 == 0 && old.load3 == 0 && old.load4 == 1 && old.frameCount > 0)
		&& !(current.load1 == 0 && current.load2 == 0 && current.load3 == 0 && current.load4 == 1 && current.frameCount > 0)
		&& vars.loadType == true) {
			return true;
		}
	}
	
	// split when final boss dies
	else {
		if(current.bosshp == 24) {
			vars.finalBoss = true;
		}
		if(vars.finalBoss == true && current.bosshp == 0) {
			return true;
		}
	}
	
}
