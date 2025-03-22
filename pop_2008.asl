state("PrinceOfPersia_Launcher", "Digital")
{
    int seedCount       : 0x00B37F64, 0xDC;
    float xPos          : 0x00B30D08, 0x40;
    float yPos          : 0x00B30D08, 0x44;
    float zPos          : 0x00B30D08, 0x48;
    int combat          : 0x00B37F6C, 0xE0, 0x1C, 0xC, 0x7CC;
    int enemyHP         : 0x00B38130, 0x4E4, 0x444, 0x60, 0x8, 0x250;
    byte deathStorage   : 0x00B30D08, 0x74, 0x104, 0x48, 0x1C, 0x50, 0xC, 0x1768;
}

state("Prince of Persia", "DRM Free")
{
    int seedCount       : 0x00B37F64, 0xDC;
    float xPos          : 0x00B30D08, 0x40;
    float yPos          : 0x00B30D08, 0x44;
    float zPos          : 0x00B30D08, 0x48;
    int combat          : 0x00B37F6C, 0xE0, 0x1C, 0xC, 0x7CC;
    int enemyHP         : 0x00B38130, 0x4E4, 0x444, 0x60, 0x8, 0x250;
    byte deathStorage   : 0x00B30D08, 0x74, 0x104, 0x48, 0x1C, 0x50, 0xC, 0x1768;
}

state("Prince of Persia", "Unknown") {}

startup
{
    vars.splitTypes = new Dictionary<string, Tuple<string, bool>> {
        {"specialEvents", Tuple.Create("Split on scripted game events", true)},
        {"combatEvents", Tuple.Create("Split on defeating bosses in specific levels", true)},
        {"anyStandard", Tuple.Create("Splits specific to the Any% (Standard) route", true)},
        {"anyLegacy", Tuple.Create("Legacy splits specific to the Any% (NDJE) route", false)},
    };

    // Key - Setting ID, Value - Tuple of (Description, Split type, Tooltip and Trigger condition).
    vars.splitsData = new Dictionary<string, Tuple<string, string, string, Func<bool>>> {
        {"CollapsingBridge", Tuple.Create(
            "Collapsing Bridge",
            "specialEvents",
            "",
            new Func<bool>(() => vars.inPosWithRange(-310.25f, -241f, -30f, 2))
        )},
        {"PreDad1", Tuple.Create(
            "Tree of Life",
            "specialEvents",
            "Reach the tree of life inside the temple for the first time",
            new Func<bool>(() => vars.inPosWithRange(4f, -388.6f, -40f, 2))
        )},
        {"ThiccCutscene", Tuple.Create(
            "Thicc Cutscene",
            "specialEvents",
            "",
            new Func<bool>(() => vars.CompletedSplits.Contains("PreDad1") && vars.oldYPos < -238f && vars.inPosWithRange(6f, -233.5f, -33f, 2))
        )},
        {"RedPlate", Tuple.Create(
            "Step of Ormazd",
            "specialEvents",
            "Splits on entering the Red plate realm",
            new Func<bool>(() => vars.inPosWithRange(-55f, -447f, -180f, 2))
        )},
        {"BluePlate", Tuple.Create(
            "Hand of Ormazd",
            "specialEvents",
            "Splits on entering the Blue plate realm",
            new Func<bool>(() => vars.inPosWithRange(45f, -456f, -180f, 2))
        )},
        {"YellowPlate", Tuple.Create(
            "Wings of Ormazd",
            "specialEvents",
            "Splits on entering the Yellow plate realm",
            new Func<bool>(() => vars.inPosWithRange(-156f, -413f, -180f, 2))
        )},
        {"GreenPlate", Tuple.Create(
            "Breath of Ormazd",
            "specialEvents",
            "Splits on entering the Green plate realm",
            new Func<bool>(() => vars.inPosWithRange(150f, -444f, -182f, 2))
        )},
        {"TheGod", Tuple.Create(
            "Defeat Ahriman",
            "specialEvents",
            "Splits on defeating Ahriman in the Temple",
            new Func<bool>(() => vars.inXRange(7.129f, 7.131f) && vars.inYRange(-401.502f, -401.5f) && vars.currentZPos() >= -31.4)
        )},
        {"Resurrection", Tuple.Create(
            "Resurrection",
            "specialEvents",
            "Splits on finishing the game",
            new Func<bool>(() => vars.inXRange(5.562f, 5.566f) && vars.inYRange(-222.745f, -222.517f) && vars.currentZPos() >= -33.1)
        )},
        {"Dad2", Tuple.Create(
            "Dad Fight 2",
            "combatEvents",
            "Splits on finishing the Dad 2 fight",
            new Func<bool>(() => vars.splitDad(6f, -187f, -48f))
        )},
        {"KingsGateH", Tuple.Create(
            "King's Gate",
            "combatEvents",
            "Splits on defeating Hunter in King's Gate",
            new Func<bool>(() => vars.splitBoss(-413.5f, -66.5f, 25f))
        )},
        {"SunTempleH", Tuple.Create(
            "The Sun Temple",
            "combatEvents",
            "Splits on defeating Hunter in The Sun Temple",
            new Func<bool>(() => vars.splitBoss(-566.5f, -44f, 34f))
        )},
        {"MarshallingGroundH", Tuple.Create(
            "Marshalling Ground",
            "combatEvents",
            "Splits on defeating Hunter in Marshalling Ground",
            new Func<bool>(() => vars.splitBoss(-761.5f, -17.5f, 19f))
        )},
        {"MartyrsTowerH", Tuple.Create(
            "Martyrs' Tower",
            "combatEvents",
            "Splits on defeating Hunter in Martyrs' Tower",
            new Func<bool>(() => vars.splitBoss(-559.5f, 193.5f, 35f))
        )},
        {"WindmillsH", Tuple.Create(
            "The Windmills",
            "combatEvents",
            "Splits on defeating Hunter in The Windmills",
            new Func<bool>(() => vars.splitBoss(-761f, 150f, 45f))
        )},
        {"Hunter", Tuple.Create(
            "Hunter's Lair",
            "combatEvents",
            "Splits on defeating Hunter in his Lair",
            new Func<bool>(() => vars.splitBoss(-929.415f, 320.888f, -90.3f))
        )},
        {"CauldronH", Tuple.Create(
            "The Cauldron",
            "combatEvents",
            "Splits on defeating Alchemist in The Cauldron",
            new Func<bool>(() => vars.splitBoss(-168f, 225f, 20f))
        )},
        {"ConstructionYardH", Tuple.Create(
            "Construction Yard",
            "combatEvents",
            "Splits on defeating Alchemist in Construction Yard",
            new Func<bool>(() => vars.splitBoss(-251.5f, 456.5f, 31f))
        )},
        {"MachineryGroundH", Tuple.Create(
            "Machinery Ground",
            "combatEvents",
            "Splits on defeating Alchemist in Machinery Ground",
            new Func<bool>(() => vars.splitBoss(-400f, 457f, 18f))
        )},
        {"ReservoirH", Tuple.Create(
            "Reservoir",
            "combatEvents",
            "Splits on defeating Alchemist in Reservoir",
            new Func<bool>(() => vars.splitBoss(-156.5f, 571.5f, 8f))
        )},
        {"HeavensStairH", Tuple.Create(
            "Heaven's Stair",
            "combatEvents",
            "Splits on defeating Alchemist in Heaven's Stair",
            new Func<bool>(() => vars.splitBoss(-291f, 651.5f, 99.2f))
        )},
        {"Alchemist", Tuple.Create(
            "The Observatory",
            "combatEvents",
            "Splits on defeating Alchemist in The Observatory",
            new Func<bool>(() => vars.splitBoss(-296.593f, 697.233f, 296.199f))
        )},
        {"CavernH", Tuple.Create(
            "The Cavern",
            "combatEvents",
            "Splits on defeating Concubine in The Cavern",
            new Func<bool>(() => vars.splitBoss(155f, 180.5f, -22.5f))
        )},
        {"RoyalGardensH", Tuple.Create(
            "Royal Gardens",
            "combatEvents",
            "Splits on defeating Concubine in Royal Gardens",
            new Func<bool>(() => vars.splitBoss(265f, 381.5f, 35.5f))
        )},
        {"SpireOfDreamsH", Tuple.Create(
            "Spire of Dreams",
            "combatEvents",
            "Splits on defeating Concubine in Spire of Dreams",
            new Func<bool>(() => vars.splitBoss(187.5f, 550f, 141.5f))
        )},
        {"RoyalSpireH", Tuple.Create(
            "Royal Spire",
            "combatEvents",
            "Splits on defeating Concubine in Royal Spire",
            new Func<bool>(() => vars.splitBoss(468.5f, 426f, 141.5f))
        )},
        {"CoronationHallH", Tuple.Create(
            "Coronation Hall",
            "combatEvents",
            "Splits on defeating Concubine in Coronation Hall",
            new Func<bool>(() => vars.splitBoss(340f, 582.5f, 32.5f))
        )},
        {"Concubine", Tuple.Create(
            "The Palace Rooms",
            "combatEvents",
            "Splits on defeating Concubine in The Palace Rooms",
            new Func<bool>(() => vars.splitBoss(352.792f, 801.051f, 150.260f))
        )},
        {"CityGateH", Tuple.Create(
            "City Gate",
            "combatEvents",
            "Splits on defeating Warrior in City Gate",
            new Func<bool>(() => vars.splitBoss(421.5f, -87.5f, -24f))
        )},
        {"TowerOfAhrimanH", Tuple.Create(
            "Tower of Ahriman",
            "combatEvents",
            "Splits on defeating Warrior in Tower of Ahriman",
            new Func<bool>(() => vars.splitBoss(598.5f, 13.5f, 86f))
        )},
        {"TowerOfOrmazdH", Tuple.Create(
            "Tower of Ormazd",
            "combatEvents",
            "Splits on defeating Warrior in Tower of Ormazd",
            new Func<bool>(() => vars.splitBoss(654f, 208f, -7f))
        )},
        {"QueensTowerH", Tuple.Create(
            "Queen's Tower",
            "combatEvents",
            "Splits on defeating Warrior in Queen's Tower",
            new Func<bool>(() => vars.splitBoss(787f, -32.5f, 98.5f))
        )},
        {"CityOfLightH", Tuple.Create(
            "City of Light",
            "combatEvents",
            "Splits on defeating Warrior in City of Light",
            new Func<bool>(() => vars.splitBoss(804f, 113f, -42.5f))
        )},
        {"Warrior", Tuple.Create(
            "Warrior's Fortress",
            "combatEvents",
            "Splits on defeating Warrior in his Fortress",
            new Func<bool>(() => vars.splitBoss(1070.478f, 279.147f, -29.571f))
        )},
        {"King", Tuple.Create(
            "The King",
            "combatEvents",
            "Splits on defeating the Mourning King before Ahriman encounter",
            new Func<bool>(() => vars.CompletedSplits.Contains("Warrior") && vars.splitBoss(5f, -365f, -32f))
        )},
        {"ThirdFight", Tuple.Create(
            "Third Fight",
            "anyStandard",
            "Splits at the start of third fight cutscene",
            new Func<bool>(() => vars.inPosWithRange(-193f, -143.6f, -32f, 2))
        )},
        {"BarrierSkip", Tuple.Create(
            "Barrier Skip",
            "anyStandard",
            "Splits after barrier skip",
            new Func<bool>(() => vars.inXRange(-208f, -200f) && vars.inYRange(-38f, -27.5f) && vars.currentZPos() >= -511)
        )},
        {"KingsGate", Tuple.Create(
            "Kings Gate",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(-538.834f, -67.159f, 12.732f))
        )},
        {"SunTemple08", Tuple.Create(
            "Sun Temple",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(-664f, -58f, 12f))
        )},
        {"MarshGrounds", Tuple.Create(
            "Marshalling Grounds",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(-806.671f, 112.803f, 21.645f))
        )},
        {"Windmills", Tuple.Create(
            "Windmills",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(-597.945f, 209.241f, 23.339f))
        )},
        {"MartyrsTower", Tuple.Create(
            "Martyrs Tower",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(-548f, 230f, 26f))
        )},
        {"MachineryGround", Tuple.Create(
            "Machinery Ground",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(-370f, 468f, 17f))
        )},
        {"HeavensStair", Tuple.Create(
            "Heavens Stair",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(-85.968f, 573.338f, 30.558f))
        )},
        {"SpireOfDreams", Tuple.Create(
            "Spire of Dreams",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(266f, 602f, 36f))
        )},
        {"CoronationHall", Tuple.Create(
            "Coronation Hall",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(399f, 535f, 39f))
        )},
        {"RoyalSpire1", Tuple.Create(
            "Royal Spire 1",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(-88.5f, 538.5f, 44.5f))
        )},
        {"Reservoir08", Tuple.Create(
            "Reservoir",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(-150.082f, 406.606f, 34.673f))
        )},
        {"ConstructionYard", Tuple.Create(
            "Construction Yard",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(-166f, 293f, 20.5f))
        )},
        {"Cauldron", Tuple.Create(
            "Cauldron",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(-12f, 135f, -15f))
        )},
        {"Cavern", Tuple.Create(
            "Cavern",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(251.741f, 65.773f, -13.616f))
        )},
        {"CityGate", Tuple.Create(
            "City Gate",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(547.488f, 45.41f, -27.107f))
        )},
        {"TowerOfAhriman", Tuple.Create(
            "Tower of Ahriman",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(667f, -14f, -30f))
        )},
        {"QueensTower", Tuple.Create(
            "Queen's Tower",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(842f, -16f, -40f))
        )},
        {"CityOfLight", Tuple.Create(
            "City of Light",
            "anyStandard",
            "Splits on defeating Warrior in City of Light",
            new Func<bool>(() => vars.splitSeed(735f, 166f, -35f))
        )},
        {"TowerOfOrmazd", Tuple.Create(
            "Tower of Ormazd",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(655f, 227f, -37f))
        )},
        {"RoyalSpire2", Tuple.Create(
            "Royal Spire 2",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(407f, 399f, 34f))
        )},
        {"RoyalGardens", Tuple.Create(
            "Royal Gardens",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(152f, 244f, 9f))
        )},
        {"Cavern2", Tuple.Create(
            "Cavern 2",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(80f, 182f, -8f))
        )},
        {"DoubleJump", Tuple.Create(
            "Double Jump",
            "anyStandard",
            "Splits on dying after getting double jump",
            new Func<bool>(() => vars.CompletedSplits.Contains("PreDad1") && vars.inXRange(0f, 10f) && vars.inYRange(-253f, -243f) && vars.currentZPos() < -43)
        )},
        {"MartyrsTowerNDJE", Tuple.Create(
            "Martyrs Tower",
            "anyLegacy",
            "",
            new Func<bool>(() => vars.splitSeed(-564.202f, 207.312f, 22f))
        )},
        {"MTtoMG", Tuple.Create(
            "MT -> MG",
            "anyLegacy",
            "",
            new Func<bool>(() => vars.splitSeed(-454.824f, 398.571f, 27.028f))
        )},
        {"MachineryGroundNDJE", Tuple.Create(
            "Machinery Ground",
            "anyLegacy",
            "",
            new Func<bool>(() => vars.splitSeed(-361.121f, 480.114f, 12.928f))
        )},
        {"TowerOfOrmazdNDJE", Tuple.Create(
            "Tower of Ormazd",
            "anyLegacy",
            "",
            new Func<bool>(() => vars.splitSeed(609.907f, 61.905f, -35.001f))
        )},
        {"QueensTowerNDJE", Tuple.Create(
            "Queen's Tower",
            "anyLegacy",
            "",
            new Func<bool>(() => vars.splitSeed(637.262f, 27.224f, -28.603f))
        )},
        {"CoronationHallNDJE", Tuple.Create(
            "Coronation Hall",
            "anyLegacy",
            "",
            new Func<bool>(() => vars.splitSeed(340f, 590f, 19f))
        )},
        {"Seed540", Tuple.Create(
            "540 Seeds",
            "anyLegacy",
            "Splits on getting the final seed at Heaven's Stair",
            new Func<bool>(() => vars.splitSeed(-280f, 696f, 87f))
        )},
    };

    foreach (var splitType in vars.splitTypes) {
        settings.Add(splitType.Key, splitType.Value.Item2, splitType.Value.Item1);
    }

    foreach (var data in vars.splitsData) {
        settings.Add(data.Key, true, data.Value.Item1, data.Value.Item2);
        settings.SetToolTip(data.Key, data.Value.Item3);
    }

    vars.CompletedSplits = new HashSet<string>();

    if (timer.CurrentTimingMethod != TimingMethod.RealTime) {
        DialogResult mbox = MessageBox.Show(timer.Form,
        "This game uses only real time as the timing method.\nWould you like to switch to Real Time?",
        "LiveSplit | Prince of Persia (2008)",
        MessageBoxButtons.YesNo);

        if (mbox == DialogResult.Yes) {
            timer.CurrentTimingMethod = TimingMethod.RealTime;
        }
    }
}


init
{
    refreshRate = 120;
    if (game.ProcessName == "PrinceOfPersia_Launcher") {
        version = "Digital";
    } else {
        string MD5Hash;
        using (var md5 = System.Security.Cryptography.MD5.Create())
            using (var s = File.Open(modules.First().FileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
                MD5Hash = md5.ComputeHash(s).Select(x => x.ToString("X2")).Aggregate((a, b) => a + b);

        switch (MD5Hash) {
            case "445CC13490EC170E1C281E9357FF3E52": version = "DRM Free"; break;
            default: version = "Unknown"; break;
        }
    }

    vars.oldYPos = 0;
    vars.currentZPos = (Func<float>)(() => current.zPos);

    vars.inXRange = (Func<float, float, bool>)((xMin, xMax) => { return current.xPos >= xMin && current.xPos <= xMax; });
    vars.inYRange = (Func<float, float, bool>)((yMin, yMax) => { return current.yPos >= yMin && current.yPos <= yMax; });
    vars.inZRange = (Func<float, float, bool>)((zMin, zMax) => { return current.zPos >= zMin && current.zPos <= zMax; });
    vars.inPosWithRange = (Func<float, float, float, int, bool>)((xTarg, yTarg, zTarg, range) => {
        return
            vars.inXRange(xTarg - range, xTarg + range) &&
            vars.inYRange(yTarg - range, yTarg + range) &&
            vars.inZRange(zTarg - range, zTarg + range) ? true : false;
    });

    // Checks if x,y,z co-ordinates are in a certain range and if a seed has just been picked
    vars.splitSeed = (Func<float, float, float, bool>)((xTarg, yTarg, zTarg) => {
        return
            vars.inPosWithRange(xTarg, yTarg, zTarg, 3) &&
            vars.seedGet ? true : false;
    });

    // Checks if x,y,z co-ordinates are in a certain range and if a combat has just ended
    vars.splitBoss = (Func<float, float, float, bool>)((xTarg, yTarg, zTarg) => {
        return
            vars.inPosWithRange(xTarg, yTarg, zTarg, 30) &&
            vars.kill ? true : false;
    });

    // Having this check because desert dad fight doesn't have combat value set for some reason
    vars.splitDad = (Func<float, float, float, bool>)((xTarg, yTarg, zTarg) => {
        return
            vars.inPosWithRange(xTarg, yTarg, zTarg, 30) &&
            vars.dadKill ? true : false;
    });

    // This function will check if settings are enabled for a triggered split and adds it to completed splits
    vars.CheckSplit = (Func<string, bool>)(key => {
        return (vars.CompletedSplits.Add(key) && settings[key]);
    });
}


reset
{
    // When the Prince's x coordinate is set after loading into the Canyon, reset.
    return old.xPos != -465 && current.xPos == -465 && old.deathStorage == 0 && current.deathStorage == 1;
}


start
{
    // When the Prince's y coordinate is set after loading into the Canyon, start.
    return old.xPos == -465 && old.yPos == -351 && (current.xPos != -465 || current.yPos != -351);
}


onStart
{
    // Refresh all splits when we start the run, none are yet completed
    vars.CompletedSplits.Clear();
}


split
{
    vars.kill = (old.combat == 2 && current.combat == 0);
    vars.dadKill = (old.enemyHP > 0 && current.enemyHP == 0);
    vars.seedGet = (current.seedCount == old.seedCount + 1);

    foreach (var data in vars.splitsData) {
        if (data.Value.Item4() && vars.CheckSplit(data.Key)) {
            print(data.Key);
            return true;
        }
    }

    vars.oldYPos = old.yPos;
}
