state("DeSmuME_0.9.9_x64") {
    int frameCount : 0x51D04A8;
}

startup {
    vars.hasCrashed = false;
    vars.hasStarted = false;
    vars.framesPassed = 0;

    vars.timerModel = new TimerModel { CurrentState = timer };

    refreshRate = 120;
    vars.PlatformFrameRate = 59.82609828808082;
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

onStart {
    vars.hasCrashed = false;
    vars.hasStarted = false;
    vars.framesPassed = 0;
    vars.timerModel = new TimerModel { CurrentState = timer };
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