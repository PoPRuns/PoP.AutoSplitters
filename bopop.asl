state("DeSmuME_0.9.9_x64") {
    int frameCount : 0x51D04A8;
    byte mainMenu3 : 0x54D2403; // 1 at main menu main screen, 0 as soon as the full game run starts, unstable otherwise
    byte skirmishMenu1 : 0x531A490; // 1 just before a game starts and just after a game ends, 0 during a game, unstable otherwise
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

start {
    bool fullGameStartCondition = old.mainMenu3 == 1 && current.mainMenu3 == 0;
    bool levelStartCondition = old.skirmishMenu1 == 1 && current.skirmishMenu1 == 0;
    bool startCondition = fullGameStartCondition || levelStartCondition;
    if (!startCondition)
        return false;

    vars.hasCrashed = false;
    vars.hasStarted = false;
    vars.framesPassed = 0;
    vars.timerModel = new TimerModel { CurrentState = timer };
    return true;
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