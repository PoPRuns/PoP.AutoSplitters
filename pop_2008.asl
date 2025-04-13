state("PrinceOfPersia_Launcher", "Digital")
{
    int seedCount       : 0x00B37F64, 0xDC;
    float xPos          : 0x00B30D08, 0x40;
    float yPos          : 0x00B30D08, 0x44;
    float zPos          : 0x00B30D08, 0x48;
    int combat          : 0x00B37F6C, 0xE0, 0x1C, 0xC, 0x7CC;
    int enemyHP         : 0x00B38130, 0x4E4, 0x444, 0x60, 0x8, 0x250;
}

state("Prince of Persia", "DRM Free")
{
    int seedCount       : 0x00B37F64, 0xDC;
    float xPos          : 0x00B30D08, 0x40;
    float yPos          : 0x00B30D08, 0x44;
    float zPos          : 0x00B30D08, 0x48;
    int combat          : 0x00B37F6C, 0xE0, 0x1C, 0xC, 0x7CC;
    int enemyHP         : 0x00B38130, 0x4E4, 0x444, 0x60, 0x8, 0x250;
}

state("Prince of Persia", "Unknown") {}

startup
{
    vars.splitTypes = new Dictionary<string, Tuple<string, bool>> {
        {"specialEvents", Tuple.Create("Split on scripted game events", true)},
        {"combatEvents", Tuple.Create("Split on defeating bosses in specific levels", true)},
        {"anyStandard", Tuple.Create("Splits specific to the Any% (Standard) route", true)},
        {"anyLegacy", Tuple.Create("Legacy splits that are outdated for Any%", false)},
    };

    // Key - Setting ID, Value - Tuple of (Description, Split type, Tooltip and Trigger condition).
    vars.splitsData = new Dictionary<string, Tuple<string, string, string, Func<bool>>> {
        {"CollapsingBridge", Tuple.Create(
            "Collapsing Bridge",
            "specialEvents",
            "",
            new Func<bool>(() => vars.inPosWithRangeCurrent(-310.25f, -241.0f, -30.2f, 0.2f))
        )},
        {"PreDad1", Tuple.Create(
            "Tree of Life",
            "specialEvents",
            "Reach the tree of life inside the temple for the first time",
            new Func<bool>(() => vars.inPosWithRangeCurrent(4f, -388.6f, -40f, 2))
        )},
        {"ThiccCutscene", Tuple.Create(
            "Thicc Cutscene",
            "specialEvents",
            "",
            new Func<bool>(() => vars.CompletedSplits.Contains("PreDad1") && vars.oldYPos < -238f && vars.inPosWithRangeCurrent(6f, -233.5f, -33f, 2))
        )},
        {"RedPlate", Tuple.Create(
            "Step of Ormazd",
            "specialEvents",
            "Splits on entering the Red plate realm",
            new Func<bool>(() => vars.inPosWithRangeCurrent(-55f, -447f, -180f, 2))
        )},
        {"BluePlate", Tuple.Create(
            "Hand of Ormazd",
            "specialEvents",
            "Splits on entering the Blue plate realm",
            new Func<bool>(() => vars.inPosWithRangeCurrent(45f, -456f, -180f, 2))
        )},
        {"YellowPlate", Tuple.Create(
            "Wings of Ormazd",
            "specialEvents",
            "Splits on entering the Yellow plate realm",
            new Func<bool>(() => vars.inPosWithRangeCurrent(-156f, -413f, -180f, 2))
        )},
        {"GreenPlate", Tuple.Create(
            "Breath of Ormazd",
            "specialEvents",
            "Splits on entering the Green plate realm",
            new Func<bool>(() => vars.inPosWithRangeCurrent(150f, -444f, -182f, 2))
        )},
        {"TheGod", Tuple.Create(
            "Defeat Ahriman",
            "specialEvents",
            "Splits on defeating Ahriman in the Temple",
            new Func<bool>(() => vars.inXRangeCurrent(7.129f, 7.131f) && vars.inYRangeCurrent(-401.502f, -401.5f) && vars.currentZPos() >= -31.4)
        )},
        {"Resurrection", Tuple.Create(
            "Resurrection",
            "specialEvents",
            "Splits on finishing the game",
            new Func<bool>(() => vars.inXRangeCurrent(5.562f, 5.566f) && vars.inYRangeCurrent(-222.745f, -222.517f) && vars.currentZPos() >= -33.1)
        )},
        {"Dad1", Tuple.Create(
            "Dad Fight 1",
            "combatEvents",
            "Splits on finishing the Dad 1 fight",
            new Func<bool>(() => vars.oldXPos < 5.7f && vars.inPosWithRangeCurrent(11.3f, -392.9f, -40f, 1))
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
            "Dad Fight 4",
            "combatEvents",
            "Splits on defeating the Mourning King before Ahriman encounter",
            new Func<bool>(() => vars.CompletedSplits.Contains("Warrior") && vars.splitBoss(5f, -365f, -32f))
        )},
        {"NeoBarrierSkip", Tuple.Create(
            "Barrier Skip",
            "anyStandard",
            "Splits right after getting out of elika-walk at King's Gate",
            new Func<bool>(() => vars.inPosWithRangeCurrent(-331.5f, -4.5f, -9.9f, 1))
        )},
        {"KingsGate", Tuple.Create(
            "Kings Gate",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(-538.834f, -67.159f, 12.732f))
        )},
        {"SunTemple", Tuple.Create(
            "Sun Temple",
            "anyStandard",
            "",
            new Func<bool>(() => vars.inPosWithRangeCurrent(-673.8f, -53.9f, 16.3f, 1))
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
            new Func<bool>(() => vars.splitSeed(399f, 535f, 39.5f))
        )},
        {"RoyalSpire1", Tuple.Create(
            "Royal Spire 1",
            "anyStandard",
            "",
            new Func<bool>(() => vars.splitSeed(-88.5f, 538.5f, 44.5f))
        )},
        {"Reservoir", Tuple.Create(
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
            new Func<bool>(() => vars.CompletedSplits.Contains("PreDad1") && vars.inXRangeCurrent(0f, 10f) && vars.inYRangeCurrent(-253f, -243f) && vars.currentZPos() < -43)
        )},
        {"ThirdFight", Tuple.Create(
            "Third Fight",
            "anyLegacy",
            "Splits at the start of third fight cutscene",
            new Func<bool>(() => vars.inPosWithRangeCurrent(-193f, -143.6f, -32f, 2))
        )},
        {"BarrierSkip", Tuple.Create(
            "Barrier Skip",
            "anyLegacy",
            "Splits after barrier skip",
            new Func<bool>(() => vars.inXRangeCurrent(-208f, -200f) && vars.inYRangeCurrent(-38f, -27.5f) && vars.currentZPos() >= -511)
        )},
        {"SunTempleNDJE", Tuple.Create(
            "Sun Temple",
            "anyLegacy",
            "",
            new Func<bool>(() => vars.splitSeed(-664f, -58f, 12f))
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

// fetching the old value from this block simply yields the current value due to a bug with ASL
// this is why any time we use the old value in this block, we pass it on directly from another block
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

    vars.oldXPos = 0;
    vars.oldYPos = 0;
    vars.currentZPos = (Func<float>)(() => current.zPos);

    vars.inXRange = (Func<float, float, float?, bool>)((xMin, xMax, xPos) => { return xPos != null && xPos >= xMin && xPos <= xMax; });
    vars.inYRange = (Func<float, float, float?, bool>)((yMin, yMax, yPos) => { return yPos != null && yPos >= yMin && yPos <= yMax; });
    vars.inZRange = (Func<float, float, float?, bool>)((zMin, zMax, zPos) => { return zPos != null && zPos >= zMin && zPos <= zMax; });
    vars.inPosWithRange = (Func<float, float, float, float, float?, float?, float?, bool>)((xTarg, yTarg, zTarg, range, xPos, yPos, zPos) => {
        return
            vars.inXRange(xTarg - range, xTarg + range, xPos) &&
            vars.inYRange(yTarg - range, yTarg + range, yPos) &&
            vars.inZRange(zTarg - range, zTarg + range, zPos);
    });

    vars.inXRangeCurrent = (Func<float, float, bool>)((xMin, xMax) => { return vars.inXRange(xMin, xMax, current.xPos); });
    vars.inYRangeCurrent = (Func<float, float, bool>)((yMin, yMax) => { return vars.inYRange(yMin, yMax, current.yPos); });
    vars.inZRangeCurrent = (Func<float, float, bool>)((zMin, zMax) => { return vars.inZRange(zMin, zMax, current.zPos); });
    vars.inPosWithRangeCurrent = (Func<float, float, float, float, bool>)((xTarg, yTarg, zTarg, range) => {
        return vars.inPosWithRange(xTarg, yTarg, zTarg, range, current.xPos, current.yPos, current.zPos);
    });

    vars.inXRangeOld = (Func<float, float, IDictionary<string, object>, bool>)((xMin, xMax, _old) => { return vars.inXRange(xMin, xMax, (float?)_old["xPos"]); });
    vars.inYRangeOld = (Func<float, float, IDictionary<string, object>, bool>)((yMin, yMax, _old) => { return vars.inYRange(yMin, yMax, (float?)_old["yPos"]); });
    vars.inZRangeOld = (Func<float, float, IDictionary<string, object>, bool>)((zMin, zMax, _old) => { return vars.inZRange(zMin, zMax, (float?)_old["zPos"]); });
    vars.inPosWithRangeOld = (Func<float, float, float, float, IDictionary<string, object>, bool>)((xTarg, yTarg, zTarg, range, _old) => {
        return vars.inPosWithRange(xTarg, yTarg, zTarg, range, (float?)_old["xPos"], (float?)_old["yPos"], (float?)_old["zPos"]);
    });

    // Checks if x,y,z co-ordinates are in a certain range and if a seed has just been picked
    vars.splitSeed = (Func<float, float, float, bool>)((xTarg, yTarg, zTarg) => {
        return
            vars.inPosWithRangeCurrent(xTarg, yTarg, zTarg, 5) &&
            vars.seedGet;
    });

    // Checks if x,y,z co-ordinates are in a certain range and if a combat has just ended
    vars.splitBoss = (Func<float, float, float, bool>)((xTarg, yTarg, zTarg) => {
        return
            vars.inPosWithRangeCurrent(xTarg, yTarg, zTarg, 30) &&
            vars.kill;
    });

    // Having this check because desert dad fight doesn't have combat value set for some reason
    vars.splitDad = (Func<float, float, float, bool>)((xTarg, yTarg, zTarg) => {
        return
            vars.inPosWithRangeCurrent(xTarg, yTarg, zTarg, 30) &&
            vars.dadKill;
    });

    // This function will check if settings are enabled for a triggered split and adds it to completed splits
    vars.CheckSplit = (Func<string, bool>)(key => {
        return (vars.CompletedSplits.Add(key) && settings[key]);
    });

    // Checks if spawned in Canyon after loading and then moved from that position
    vars.startLoad = (Func<IDictionary<string, object>, bool>)((_old) => {
        return (float?)_old["xPos"] == -465f && (float?)_old["yPos"] == -351f && (current.xPos != -465f || current.yPos != -351f);
    });

    // Checks if spawned in Canyon after loading
    vars.resetLoad = (Func<IDictionary<string, object>, bool>)((_old) => {
        return ((float?)_old["xPos"] != -465f || (float?)_old["yPos"] != -351f) && current.xPos == -465f && current.yPos == -351f;
    });

    {
        Tuple<float, float, float, float> args = Tuple.Create(-462.302f, -348.223f, -23.956f, 0.003f);

        // Checks if spawned in Canyon after new game and then moved from that position
        vars.startNew = (Func<IDictionary<string, object>, bool>)((_old) => {
            return
                vars.inPosWithRangeOld(args.Item1, args.Item2, args.Item3, args.Item4, _old) &&
                !vars.inPosWithRangeCurrent(args.Item1, args.Item2, args.Item3, args.Item4);
        });

        // Checks if spawned in Canyon after new game
        vars.resetNew = (Func<IDictionary<string, object>, bool>)((_old) => {
            return
                !vars.inPosWithRangeOld(args.Item1, args.Item2, args.Item3, args.Item4, _old) &&
                vars.inPosWithRangeCurrent(args.Item1, args.Item2, args.Item3, args.Item4);
        });
    }
}


reset
{
    return vars.resetLoad(old) || vars.resetNew(old);
}


start
{
    return vars.startLoad(old) || vars.startNew(old);
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

    vars.oldXPos = old.xPos;
    vars.oldYPos = old.yPos;
}
