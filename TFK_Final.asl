state("DeSmuME_0.9.9_x64") {
    int frameCount : 0x51D04A8;
}

startup {
    vars.hasCrashed = false;
    vars.hasStarted = false;
    vars.framesPassed = 0;

    vars.timerModel = new TimerModel { CurrentState = timer };
    // setting refresh rate of the memory check cycle
    refreshRate = 60;
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