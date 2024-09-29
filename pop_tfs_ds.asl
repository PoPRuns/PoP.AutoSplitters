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
    byte boss1Hp : 0x550D16C;
    byte boss2Hp : 0x55169B4;
    byte boss3Hp : 0x552538C;
    byte boss4Hp : 0x54FD1CC;
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
    
    bool oldInStandardLevel =
        old.mainMenu4 == 0 &&
        old.mainMenu11 == 0;
    
    bool currentInStandardLevel =
        current.mainMenu4 == 0 &&
        current.mainMenu11 == 0;
    
    bool oldInHorseLevel =
        old.mainMenu4 == 1 &&
        old.mainMenu9 == 0 &&
        old.mainMenu10 == 0 &&
        old.mainMenu11 == 0;

    bool currentInHorseLevel =
        current.mainMenu4 == 1 &&
        current.mainMenu9 == 0 &&
        current.mainMenu10 == 0 &&
        current.mainMenu11 == 0;

    bool oldBoss1Proxy =
        old.boss2Hp == 0 &&
        old.boss3Hp == 0 &&
        old.boss4Hp == 18;

    bool oldBoss2Proxy =
        old.boss1Hp == 4 &&
        old.boss3Hp == 0 &&
        old.boss4Hp == 189;

    bool oldBoss3Proxy =
        old.boss1Hp == 0 &&
        old.boss2Hp == 65 &&
        old.boss4Hp == 0;

    bool oldBoss4Proxy =
        old.boss1Hp == 0 &&
        old.boss2Hp == 0 &&
        old.boss3Hp == 157;

    bool oldInBoss1Level =
        (old.boss1Hp == 100 && oldBoss1Proxy) ||
        (old.mainMenu11 == 22 && old.boss1Hp != 0 && oldBoss1Proxy);

    bool oldInBoss2Level =
        (old.boss2Hp == 100 && oldBoss2Proxy) ||
        (old.mainMenu11 == 22 && old.boss2Hp != 0 && oldBoss2Proxy);

    bool oldInBoss3Level =
        (old.boss3Hp == 100 && oldBoss3Proxy) ||
        (old.mainMenu11 == 22 && old.boss3Hp != 0 && oldBoss3Proxy);

    bool oldInBoss4Level =
        (old.boss4Hp == 100 && oldBoss4Proxy) ||
        (old.mainMenu11 == 22 && old.boss4Hp != 0 && oldBoss4Proxy);

    bool oldInBossLevel =
        oldInBoss1Level ||
        oldInBoss2Level ||
        oldInBoss3Level ||
        oldInBoss4Level;
    
    bool currentBoss1Proxy =
        current.boss2Hp == 0 &&
        current.boss3Hp == 0 &&
        current.boss4Hp == 18;
    
    bool currentBoss2Proxy =
        current.boss1Hp == 4 &&
        current.boss3Hp == 0 &&
        current.boss4Hp == 189;

    bool currentBoss3Proxy =
        current.boss1Hp == 0 &&
        current.boss2Hp == 65 &&
        current.boss4Hp == 0;

    bool currentBoss4Proxy =
        current.boss1Hp == 0 &&
        current.boss2Hp == 0 &&
        current.boss3Hp == 157;
    
    bool currentInBoss1Level =
        (current.boss1Hp == 100 && currentBoss1Proxy) ||
        (current.mainMenu11 == 22 && current.boss1Hp != 0 && currentBoss1Proxy);
    
    bool currentInBoss2Level =
        (current.boss2Hp == 100 && currentBoss2Proxy) ||
        (current.mainMenu11 == 22 && current.boss2Hp != 0 && currentBoss2Proxy);

    bool currentInBoss3Level =
        (current.boss3Hp == 100 && currentBoss3Proxy) ||
        (current.mainMenu11 == 22 && current.boss3Hp != 0 && currentBoss3Proxy);

    bool currentInBoss4Level =
        (current.boss4Hp == 100 && currentBoss4Proxy) ||
        (current.mainMenu11 == 22 && current.boss4Hp != 0 && currentBoss4Proxy);

    bool currentInBossLevel =
        currentInBoss1Level ||
        currentInBoss2Level ||
        currentInBoss3Level ||
        currentInBoss4Level;

    vars.oldInGame =
        (oldInStandardLevel ||
        oldInHorseLevel ||
        oldInBossLevel) &&
        old.frameCount > 200;
    
    vars.currentInGame =
        (currentInStandardLevel ||
        currentInHorseLevel ||
        currentInBossLevel) &&
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