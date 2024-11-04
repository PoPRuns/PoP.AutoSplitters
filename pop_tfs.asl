state("prince of persia")
{
    float xPos      : 0xDA4D20;
    float yPos      : 0xDA4D24;
    float zPos      : 0xDA4D28;
    int gameState   : 0x00DA52EC, 0x18, 0xF8, 0x150;
    int cpIcon      : 0x007186D4, 0x0, 0x0, 0x24, 0x1C, 0x1C, 0x870;
    int isMenu      : 0xDA2F70;
    bool isLoading  : "", 0x00DA5724, 0x50;
    /*
    Alternate cpIcon pointers if above fails for someone
    ----------------------------------------------------
    Base Addresses - 0x007186D4, 0x0071C810, 0x0071F7F0,
    -------
    Offsets
    0x0, 0x0, 0x24, 0x1C, 0x1C, 0x870;
    0x0, 0x38, 0x24, 0x1C, 0x1C, 0x870;
    0x0, 0x0, 0x24, 0x18, 0x54, 0x870;
    0x0, 0x38, 0x24, 0x18, 0x54, 0x870;
    -----------------------------------
    All 12 combinations are possible
    -----------------------------------
    */
}

startup
{
    // Key - Setting ID, Value - Tuple of (Description, Tooltip and Trigger condition).
    vars.splitsData = new Dictionary<string, Tuple<string, string, Func<bool>>> {
        {"Malik", Tuple.Create(
            "Malik",
            "Split on the checkpoint where you meet Malik",
            new Func<bool>(() => vars.SplitTFScp(-37, 231, -148, 10))
        )},
        {"PowerOfTime", Tuple.Create(
            "The Power of Time",
            "Split on obtaining the Rewind power",
            new Func<bool>(() => vars.SplitTFScp(597, -217, -2, 10))
        )},
        {"Works", Tuple.Create(
            "The Works",
            "Split on reaching the room with the rising lever platform",
            new Func<bool>(() => vars.SplitTFScp(-513, -408, -167, 10))
        )},
        {"Courtyard", Tuple.Create(
            "The Courtyard",
            "Split on reaching the top of the fortress courtyard",
            new Func<bool>(() => vars.SplitTFScp(-434, -533, -127, 10))
        )},
        {"PowerOfWater", Tuple.Create(
            "The Power of Water",
            "Split on obtaining the Freeze power",
            new Func<bool>(() => vars.CompletedSplits.Contains("PowerOfTime") && vars.SplitTFScp(519, -227, 6, 10))
        )},
        {"Sewers", Tuple.Create(
            "The Sewers",
            "Split on the checkpoint where Summoners are introduced",
            new Func<bool>(() => vars.SplitTFScp(-228, 245, 20, 10))
        )},
        {"Ratash", Tuple.Create(
            "Ratash",
            "Split on finishing the Ratash chase sequence",
            new Func<bool>(() => vars.SplitTFScp(-406, 403, 64, 10))
        )},
        {"Observatory", Tuple.Create(
            "The Observatory",
            "Split on exiting the Observatory",
            new Func<bool>(() => vars.SplitTFScp(-510, 460, 104, 10))
        )},
        {"PowerOfLight", Tuple.Create(
            "The Power of Light",
            "Split on obtaining the Dash power",
            new Func<bool>(() => vars.CompletedSplits.Contains("PowerOfWater") && vars.SplitTFScp(540, -219, 6, 10))
        )},
        {"Gardens", Tuple.Create(
            "The Gardens",
            "Split on the checkpoint where Wizards are introduced",
            new Func<bool>(() => vars.SplitTFScp(240, -227, -114, 10))
        )},
        {"Possession", Tuple.Create(
            "Possession",
            "Split on completing the big fight before the second Ratash encounter",
            new Func<bool>(() => vars.SplitTFScp(89, -477, -83, 1))
        )},
        {"PowerOfKnowledge", Tuple.Create(
            "The Power of Knowledge",
            "Split on obtaining the Memory power",
            new Func<bool>(() => vars.CompletedSplits.Contains("PowerOfLight") && vars.SplitTFScp(548, -217, 4, 10))
        )},
        {"Reservoir", Tuple.Create(
            "The Reservoir",
            "Split at the beginning of the Rekem reservoir",
            new Func<bool>(() => vars.SplitTFScp(644, 385, -63, 10))
        )},
        {"PowerOfRazia", Tuple.Create(
            "The Power of Razia",
            "Split when Razia becomes one with the sword",
            new Func<bool>(() => vars.CompletedSplits.Contains("PowerOfKnowledge") && vars.SplitTFScp(430, 268, -99, 10))
        )},
        {"Climb", Tuple.Create(
            "The Climb",
            "Split on starting the final climb",
            new Func<bool>(() => vars.SplitTFScp(912, 256, -56, 10))
        )},
        {"Storm", Tuple.Create(
            "The Storm",
            "Split on starting the journey through the storm",
            new Func<bool>(() => vars.SplitTFScp(948, -284, 86, 10))
        )},
        {"End", Tuple.Create(
            "The End",
            "Split on finishing the game",
            new Func<bool>(() => vars.SplitTFSpos(821, -257, -51, 10))
        )},
    };

    foreach (var data in vars.splitsData) {
        settings.Add(data.Key, true, data.Value.Item1);
        settings.SetToolTip(data.Key, data.Value.Item2);
    }

    vars.CompletedSplits = new HashSet<string>();

    if (timer.CurrentTimingMethod != TimingMethod.GameTime) {
        DialogResult mbox = MessageBox.Show(timer.Form,
        "Removing load/crash times requires switching to Game Time.\nWould you like to do so?",
        "LiveSplit | Prince of Persia: The Forgotten Sands",
        MessageBoxButtons.YesNo);

        if (mbox == DialogResult.Yes) {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

init
{
    vars.gameRunning = true;
    game.Exited += (s, e) => vars.gameRunning = false;

    // This is a split which triggers when the prince is within a certain range of coords
    vars.SplitTFSpos = (Func <int, int, int, int, bool>)((xTarg, yTarg, zTarg, range) => {
        return
            current.xPos <= (xTarg + range) && current.xPos >= (xTarg - range) &&
            current.yPos <= (yTarg + range) && current.yPos >= (yTarg - range) &&
            current.zPos <= (zTarg + range) && current.zPos >= (zTarg - range);
    });

    // This is a standard type of split which triggers when the prince is within a certain range of coords and a checkpoint is just acquired
    vars.SplitTFScp = (Func <int, int, int, int, bool>)((xTarg, yTarg, zTarg, range) => {
        return vars.SplitTFSpos(xTarg, yTarg, zTarg, range) && vars.cpGet;
    });

    // This function will check if settings are enabled for a triggered split and adds it to completed splits
    vars.CheckSplit = (Func<string, bool>)(key => {
        return (vars.CompletedSplits.Add(key) && settings[key]);
    });
}

isLoading
{
    return (current.isMenu == 0 || current.isLoading || !vars.gameRunning);
}

reset
{
    // When the Prince's x coordinate is set after loading into the first cutscene, reset.
    if (current.xPos <= 268.93 && current.xPos >= 268.929 && current.gameState == 1)
        return true;
}

start
{
    // When the Prince is in the starting position and a cutscene has just been skipped, start.
    if (current.xPos <= 268.93 && current.xPos >= 268.929 && current.gameState == 4)
        return true;
}

onStart
{
    // Refresh all splits when we start the run, none are yet completed
    vars.CompletedSplits.Clear();
}

split
{
    vars.cpGet = (old.cpIcon < 1 && current.cpIcon >= 1);

    foreach (var data in vars.splitsData) {
        if (data.Value.Item3() && vars.CheckSplit(data.Key)) {
            print(data.Key);
            return true;
        }
    }
}
