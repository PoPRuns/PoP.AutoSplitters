state("DeSmuME_0.9.9_x64") {
    uint frameCount : 0x51D04A8;

    byte mainMenu1 : 0x51DA974;
    byte mainMenu2 : 0x51DA9A8;
    byte mainMenu3 : 0x51DA9B8;
    byte mainMenu4 : 0x5334F1C;
    byte mainMenu5 : 0x5342E00;
    byte mainMenu6 : 0x5365C46;
    byte mainMenu7 : 0x54351A3;
    byte mainMenu8 : 0x555483B;
    byte mainMenu9 : 0x55954FF;
    byte mainMenu10 : 0x55AF9AF;
    byte mainMenu11 : 0x7268F6C;

    byte boss1_1 : 0x552F8E1;
    byte boss1_2 : 0x55303A4;
    byte boss1_3 : 0x553049C;
    byte boss1_4 : 0x5536485;

    byte boss2_2 : 0x553754D;
    byte boss2_4 : 0x5552054;
    byte boss2_8 : 0x5552244;
    byte boss2_10 : 0x555233C;
    byte boss2_12 : 0x5552434;
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
        old.frameCount > 300;
    
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
        current.frameCount > 300;
    
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

    bool oldInBoss1Level =
        old.boss1_1 == 1 &&
        old.boss1_2 == 1 &&
        old.boss1_3 == 1 &&
        old.boss1_4 == 1;

    bool oldInBoss2Level =
        old.boss2_2 == 1 &&
        old.boss2_4 == 1 &&
        old.boss2_8 == 1 &&
        old.boss2_10 == 1 &&
        old.boss2_12 == 1;

    bool oldInBoss3Level = false;
    bool oldInBoss4Level = false;

    bool oldInBossLevel =
        oldInBoss1Level ||
        oldInBoss2Level ||
        oldInBoss3Level ||
        oldInBoss4Level;
    
    bool currentInBoss1Level =
        current.boss1_1 == 1 &&
        current.boss1_2 == 1 &&
        current.boss1_3 == 1 &&
        current.boss1_4 == 1;

    bool currentInBoss2Level =
        current.boss2_2 == 1 &&
        current.boss2_4 == 1 &&
        current.boss2_8 == 1 &&
        current.boss2_10 == 1 &&
        current.boss2_12 == 1;

    bool currentInBoss3Level = false;
    bool currentInBoss4Level = false;

    bool currentInBossLevel =
        currentInBoss1Level ||
        currentInBoss2Level ||
        currentInBoss3Level ||
        currentInBoss4Level;

    vars.oldInGame =
        (oldInStandardLevel ||
        oldInHorseLevel ||
        oldInBossLevel) &&
        old.frameCount > 300;
    
    vars.currentInGame =
        (currentInStandardLevel ||
        currentInHorseLevel ||
        currentInBossLevel) &&
        current.frameCount > 300;
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