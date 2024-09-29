state("DeSmuME_0.9.9_x64") {
    uint frameCount : 0x51D04A8;
    byte mainMenu1 : 0x51DA974; // 1 in main menu, unstable otherwise
    byte mainMenu2 : 0x51DA9A8; // 0 when entering standard level (before load), 1 in main menu, unstable otherwise
    byte mainMenu3 : 0x51DA9B8; // 1 in main menu, unstable otherwise
    byte mainMenu4 : 0x5334F1C; // 0 when entering standard level (before load), 1 in main menu, unstable otherwise
    byte mainMenu5 : 0x5342E00; // 1 in main menu, unstable otherwise
    byte mainMenu6 : 0x5365C46; // 1 in main menu, unstable otherwise
    byte mainMenu7 : 0x54351A3; // 1 in main menu, unstable otherwise
    byte mainMenu8 : 0x555483B; // 1 in main menu, unstable otherwise
    byte mainMenu9 : 0x55954FF; // 1 in main menu, unstable otherwise
    byte mainMenu10 : 0x55AF9AF; // 1 in main menu, unstable otherwise
    byte mainMenu11 : 0x7268F6C; // 0 when in a level or in the shop menu, 1 otherwise
}

startup {
    vars.framesPassed = 0;
    refreshRate = 120;
    vars.PlatformFrameRate = 59.82609828808082;
}

update {
    vars.oldInMainMenu =
        old.mainMenu1 == 1 &&
        old.mainMenu2 == 1 &&
        old.mainMenu3 == 1 &&
        old.mainMenu4 == 1 &&
        old.mainMenu5 == 1 &&
        old.mainMenu6 == 1 &&
        old.mainMenu7 == 1 &&
        old.mainMenu8 == 1 &&
        old.mainMenu9 == 1 &&
        old.mainMenu10 == 1 &&
        old.mainMenu11 == 1 &&
        old.frameCount > 200;
    
    vars.currentInMainMenu =
        current.mainMenu1 == 1 &&
        current.mainMenu2 == 1 &&
        current.mainMenu3 == 1 &&
        current.mainMenu4 == 1 &&
        current.mainMenu5 == 1 &&
        current.mainMenu6 == 1 &&
        current.mainMenu7 == 1 &&
        current.mainMenu8 == 1 &&
        current.mainMenu9 == 1 &&
        current.mainMenu10 == 1 &&
        current.mainMenu11 == 1 &&
        current.frameCount > 200;
    
    vars.oldInGame =
        old.mainMenu4 == 0 &&
        old.mainMenu11 == 0 &&
        old.frameCount > 200;
    
    vars.currentInGame =
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
    bool levelExitSplitCondition = vars.oldInGame && !vars.currentInGame;
    bool mainMenuExitSplitCondition = vars.oldInMainMenu && !vars.currentInMainMenu;
    bool splitCondition = levelExitSplitCondition || mainMenuExitSplitCondition;
    return splitCondition;
}