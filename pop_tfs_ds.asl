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

    byte boss3_1 : 0x55533D9;
    byte boss3_2 : 0x555AB6C;
    byte boss3_3 : 0x555B3BC;
    byte boss3_4 : 0x555B424;

    byte boss4_1 : 0x51DAB58;
    byte boss4_2 : 0x51DAB59;
    byte boss4_3 : 0x51DAC68;
    byte boss4_4 : 0x542F6EB;
}

startup {
    vars.framesPassed = 0;
    refreshRate = 120;
    vars.PlatformFrameRate = 59.82609828808082;

    vars.oldInMainMenu = false;
    vars.currentInMainMenu = false;

    vars.oldInGame = false;
    vars.currentInGame = false;
}

update {
    vars.oldInMainMenu = vars.currentInMainMenu;
    vars.oldInGame = vars.currentInGame;

    vars.currentInMainMenu =
        current.frameCount > 300 &&
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
        current.mainMenu11 == 1;

    Func<bool> isInStandardLevel = () =>
        current.mainMenu4 == 0 &&
        current.mainMenu11 == 0;
    
    Func<bool> isInHorseLevel = () =>
        current.mainMenu3 == 0 &&
        current.mainMenu4 == 1 &&
        current.mainMenu9 == 0 &&
        current.mainMenu10 == 0 &&
        current.mainMenu11 == 0;
    
    Func<bool> isInBoss1Level = () =>
        current.boss1_1 == 1 &&
        current.boss1_2 == 1 &&
        current.boss1_3 == 1 &&
        current.boss1_4 == 1;

    Func<bool> isInBoss2Level = () =>
        current.boss2_2 == 1 &&
        current.boss2_4 == 1 &&
        current.boss2_8 == 1 &&
        current.boss2_10 == 1 &&
        current.boss2_12 == 1;

    Func<bool> isInBoss3Level = () =>
        current.boss3_1 == 1 &&
        current.boss3_2 == 1 &&
        current.boss3_3 == 1 &&
        current.boss3_4 == 1;

    Func<bool> isInBoss4Level = () =>
        current.boss4_1 == 1 &&
        current.boss4_2 == 1 &&
        current.boss4_3 == 1 &&
        current.boss4_4 == 1;
    
    vars.currentInGame =
        current.frameCount > 300 && (
        isInStandardLevel() ||
        isInHorseLevel() ||
        isInBoss1Level() ||
        isInBoss2Level() ||
        isInBoss3Level() ||
        isInBoss4Level());
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