state("DeSmuME_0.9.9_x64")
{
    uint frameCount     : 0x51D04A8;
    byte mainMenu3      : 0x54D2403; // 1 at main menu main screen, 0 as soon as the full game run starts, unstable otherwise
    byte skirmishMenu1  : 0x531A490; // 1 just before a game starts and just after a game ends, 0 during a game, unstable otherwise
}

startup
{
    vars.framesPassed = 0;
    refreshRate = 120;
    vars.PlatformFrameRate = 59.82609828808082;

    if (timer.CurrentTimingMethod != TimingMethod.GameTime) {
        DialogResult mbox = MessageBox.Show(timer.Form,
        "This game uses an in-game timer as the primary timing method.\nWould you like to switch to Game Time?",
        "LiveSplit | Battles of Prince of Persia",
        MessageBoxButtons.YesNo);

        if (mbox == DialogResult.Yes) {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

start
{
    bool fullGameStartCondition = old.mainMenu3 == 1 && current.mainMenu3 == 0;
    bool levelStartCondition = old.skirmishMenu1 == 1 && current.skirmishMenu1 == 0;
    bool startCondition = current.frameCount > 0 && (fullGameStartCondition || levelStartCondition);
    if (!startCondition)
        return false;

    vars.framesPassed = 0;
    return true;
}

isLoading
{
    return true;
}

gameTime
{
    if (current.frameCount > old.frameCount) {
        vars.framesPassed += (current.frameCount - old.frameCount);
    }
    return TimeSpan.FromMilliseconds((1000 * vars.framesPassed) / vars.PlatformFrameRate);
}

split
{
    // This covers all three types of split:
    // 1. finishing campaign level
    // 2. finishing skirmish level
    // 3. opening the game
    bool splitCondition = old.skirmishMenu1 == 0 && current.skirmishMenu1 == 1;
    return splitCondition;
}
