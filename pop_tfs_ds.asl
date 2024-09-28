state("DeSmuME_0.9.9_x64") {
    int frameCount : 0x51D04A8;
    byte mainMenu1 : 0x51DA974; // 0 when entering level (before load), unstable otherwise
    byte mainMenu2 : 0x51DA9A8; // as above
    byte mainMenu4 : 0x5334F1C; // as above
    byte mainMenu11 : 0x7268F6C; // 0 when in a level or in the shop menu, 1 otherwise
}

startup {
    vars.framesPassed = 0;
    refreshRate = 120;
    vars.PlatformFrameRate = 59.82609828808082;
}

update {
    vars.oldInGame =
        old.mainMenu1 == 0 &&
        old.mainMenu2 == 0 &&
        old.mainMenu4 == 0 &&
        old.mainMenu11 == 0 &&
        old.frameCount > 200;
    
    vars.currentInGame =
        current.mainMenu1 == 0 &&
        current.mainMenu2 == 0 &&
        current.mainMenu4 == 0 &&
        current.mainMenu11 == 0 &&
        current.frameCount > 200;
}

start {
    bool startCondition = !vars.oldInGame && vars.currentInGame;
    if (!startCondition)
        return false;
    
    vars.framesPassed = 0;
    return true;
}

isLoading {
    return true;
}

gameTime {
    if (current.frameCount > old.frameCount) {
        vars.framesPassed += (current.frameCount - old.frameCount);
    }
    return TimeSpan.FromMilliseconds((1000 * vars.framesPassed) / vars.PlatformFrameRate);
}

split {
    bool splitCondition = vars.oldInGame && !vars.currentInGame;
    return splitCondition;
}