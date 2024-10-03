state("DeSmuME_0.9.9_x64") {
    uint frameCount : 0x51D04A8;

    byte mainMenu3 : 0x51DA9B8;
    byte mainMenu4 : 0x5334F1C;
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

    byte boss2Alt1 : 0x553757D;
    byte boss2Alt2 : 0x5552084;
    byte boss2Alt3 : 0x5552114;
    byte boss2Alt4 : 0x555217C;

    byte boss3_1 : 0x55533D9;
    byte boss3_2 : 0x555AB6C;
    byte boss3_3 : 0x555B3BC;
    byte boss3_4 : 0x555B424;

    byte boss3Alt1 : 0x55533AC;
    byte boss3Alt2 : 0x5553441;
    byte boss3Alt3 : 0x555463C;
    byte boss3Alt4 : 0x55546CC;

    byte boss4_1 : 0x51DAB58;
    byte boss4_2 : 0x51DAB59;
    byte boss4_3 : 0x51DAC68;
    byte boss4_4 : 0x542F6EB;
}

startup {
    vars.framesPassed = 0;
    refreshRate = 120;
    vars.PlatformFrameRate = 59.82609828808082;

    vars.oldInGame = false;
    vars.currentInGame = false;
}

init {
    vars.isInStandardLevel = (Func<bool>)(() => { return
        current.mainMenu4 == 0 &&
        current.mainMenu11 == 0;
    });
    
    vars.isInHorseLevel = (Func<bool>)(() => { return
        current.mainMenu3 == 0 &&
        current.mainMenu4 == 1 &&
        current.mainMenu9 == 0 &&
        current.mainMenu10 == 0 &&
        current.mainMenu11 == 0;
    });
    
    vars.isInBoss1Level = (Func<bool>)(() => { return
        current.boss1_1 == 1 &&
        current.boss1_2 == 1 &&
        current.boss1_3 == 1 &&
        current.boss1_4 == 1;
    });

    vars.isInBoss2Level = (Func<bool>)(() => { return
        (
            current.boss2_2 == 1 &&
            current.boss2_4 == 1 &&
            current.boss2_8 == 1 &&
            current.boss2_10 == 1 &&
            current.boss2_12 == 1
        ) ||
        (
            current.boss2Alt1 == 1 &&
            current.boss2Alt2 == 1 &&
            current.boss2Alt3 == 1 &&
            current.boss2Alt4 == 1
        );
    });

    vars.isInBoss3Level = (Func<bool>)(() => { return
        (
            current.boss3_1 == 1 &&
            current.boss3_2 == 1 &&
            current.boss3_3 == 1 &&
            current.boss3_4 == 1
        ) ||
        (
            current.boss3Alt1 == 1 &&
            current.boss3Alt2 == 1 &&
            current.boss3Alt3 == 1 &&
            current.boss3Alt4 == 1
        );
    });

    vars.isInBoss4Level = (Func<bool>)(() => { return
        current.boss4_1 == 1 &&
        current.boss4_2 == 1 &&
        current.boss4_3 == 1 &&
        current.boss4_4 == 1;
    });
}

update {
    vars.oldInGame = vars.currentInGame;
    
    vars.currentInGame =
        vars.isInStandardLevel() ||
        vars.isInHorseLevel() ||
        vars.isInBoss1Level() ||
        vars.isInBoss2Level() ||
        vars.isInBoss3Level() ||
        vars.isInBoss4Level();
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