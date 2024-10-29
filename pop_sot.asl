state("POP")
{
    // Some memory value that reliably changes when 'New Game' is pressed.
    int startValue      : 0x6BC980;

    // Prince's position
    float xPos          : 0x00699474, 0xC, 0x30;
    float yPos          : 0x00699474, 0xC, 0x34;
    float zPos          : 0x00699474, 0xC, 0x38;

    // The Vizier's health where 0 is unharmed and 4 is dead.
    int vizierHealth    : 0x0040E518, 0x6C, 0x18, 0x4, 0x44, 0x0;

    int resetValue      : 0x0040E388, 0x4, 0x398;
}

startup
{
    // Key - Setting ID, Value - Tuple of (Default setting, Description, Tooltip and Trigger condition).
    vars.splitsData = new Dictionary<string, Tuple<bool, string, string, Func<bool>>> {
        {"GasStation", Tuple.Create(true, "Enter Treasure Vaults", "Split just before the first save prompt", new Func<bool>(() => vars.GasStation()))},
        {"SandsUnleashed", Tuple.Create(true, "Sands Unleashed", "Split on starting the first fight after the CGI cutscene", new Func<bool>(() => vars.SandsUnleashed()))},
        {"FirstGuestRoom", Tuple.Create(false, "First Guest Room", "Split on entering the first guest room", new Func<bool>(() => vars.FirstGuestRoom()))},
        {"SultanChamberZipless", Tuple.Create(false, "Sultan's Chamber", "Split on entering the Sultan's chamber at the cutscene", new Func<bool>(() => vars.SultanChamberZipless()))},
        {"SultanChamber", Tuple.Create(false, "The Sultan's Chamber (death)", "Split at the death abuse in Sultan's chamber", new Func<bool>(() => vars.SultanChamber()))},
        {"PalaceDefence", Tuple.Create(false, "The Palace's Defence System", "Split on exiting the palace defense system", new Func<bool>(() => vars.PalaceDefence()))},
        {"DadStart", Tuple.Create(false, "Dad Fight (Start)", "Split on starting the fight with the Sand King", new Func<bool>(() => vars.DadStart()))},
        {"DadDead", Tuple.Create(true, "Dad Fight (End)", "Split at the end of the fight on loading the next area", new Func<bool>(() => vars.DadDead()))},
        {"TheWarehouse", Tuple.Create(false, "The Warehouse", "Split on hitting the button to let Farah enter Warehouse", new Func<bool>(() => vars.TheWarehouse()))},
        {"TheZoo", Tuple.Create(false, "The Sultan's Zoo", "Split on entering the zoo", new Func<bool>(() => vars.TheZoo()))},
        {"BirdCage", Tuple.Create(false, "Atop a Bird Cage", "Split at the 'Atop a bird cage' save vortex", new Func<bool>(() => vars.BirdCage()))},
        {"CliffWaterfalls", Tuple.Create(false, "Cliffs and Waterfall", "Split at the start of cliffs and waterfall", new Func<bool>(() => vars.CliffWaterfalls()))},
        {"TheBathsZipless", Tuple.Create(false, "The Baths", "Split at the end of cliffs and Waterfall", new Func<bool>(() => vars.TheBathsZipless()))},
        {"TheBaths", Tuple.Create(false, "The Baths (death)", "Split on death abuse at the start of baths", new Func<bool>(() => vars.TheBaths()))},
        {"SecondSword", Tuple.Create(false, "Second Sword", "Split on obtaining the second sword at baths", new Func<bool>(() => vars.SecondSword()))},
        {"TheDaybreak", Tuple.Create(false, "Daybreak", "Split at the start of daybreak", new Func<bool>(() => vars.TheDaybreak()))},
        {"TheMesshall", Tuple.Create(false, "Soldiers' Mess Hall (death)", "Split on death abuse in the mess hall", new Func<bool>(() => vars.TheMesshall()))},
        {"DrawbridgeTower", Tuple.Create(false, "Drawbridge Tower", "Split near the first lever at Drawbridge Tower", new Func<bool>(() => vars.DrawbridgeTower()))},
        {"BrokenBridge", Tuple.Create(false, "A Broken Bridge", "Split at the end of the collapsing bridge", new Func<bool>(() => vars.BrokenBridge()))},
        {"TheCavesZipless", Tuple.Create(false, "The Caves", "Split on entering the caves after the door", new Func<bool>(() => vars.TheCavesZipless()))},
        {"TheCaves", Tuple.Create(false, "The Caves (alternate)", "Split on the beam at the start of Waterfall", new Func<bool>(() => vars.TheCaves()))},
        {"TheWaterfall", Tuple.Create(false, "The Waterfall", "Split at the end of the descent in Waterfall", new Func<bool>(() => vars.TheWaterfall()))},
        {"TheUGReservoirZipless", Tuple.Create(false, "An Underground Reservoir", "Split on entering the underground reservoir", new Func<bool>(() => vars.TheUGReservoirZipless()))},
        {"TheUGReservoir", Tuple.Create(false, "An Underground Reservoir", "Split on exiting the underground reservoir", new Func<bool>(() => vars.TheUGReservoir()))},
        {"HallofLearning", Tuple.Create(false, "The Hall of Learning", "Split on entering the hall of learning", new Func<bool>(() => vars.HallofLearning()))},
        {"TheObservatory", Tuple.Create(false, "Observatory (death)", "Split on death abuse at the end of observatory", new Func<bool>(() => vars.TheObservatory()))},
        {"ObservatoryExit", Tuple.Create(false, "Exit Observatory", "Split on exiting the observatory", new Func<bool>(() => vars.ObservatoryExit()))},
        {"HoLCourtyardsExit", Tuple.Create(false, "Exit Hall of Learning Courtyards", "Split on exiting hall of learning courtyards", new Func<bool>(() => vars.HoLCourtyardsExit()))},
        {"TheAzadPrison", Tuple.Create(false, "The Azad Prison", "Split on entering the prison", new Func<bool>(() => vars.TheAzadPrison()))},
        {"TortureChamberZipless", Tuple.Create(false, "Torture Chamber", "Split on entering the torture chamber", new Func<bool>(() => vars.TortureChamberZipless()))},
        {"TortureChamber", Tuple.Create(false, "Torture Chamber (death)", "Split on death abuse at the start of torture chamber", new Func<bool>(() => vars.TortureChamber()))},
        {"TheElevator", Tuple.Create(false, "The Elevator", "Split on entering the elevator", new Func<bool>(() => vars.TheElevator()))},
        {"TheDreamZipless", Tuple.Create(false, "A Magic Cavern", "Split at the start of the long unskippable cutscene", new Func<bool>(() => vars.TheDreamZipless()))},
        {"TheDream", Tuple.Create(false, "A Magic Cavern (alternate)", "Split at the start of the 'infinite' stairs", new Func<bool>(() => vars.TheDream()))},
        {"TheTomb", Tuple.Create(false, "The Tomb", "Split at the start of the tomb", new Func<bool>(() => vars.TheTomb()))},
        {"TowerofDawn", Tuple.Create(false, "Tower of Dawn", "Split at the start of the ascent back up the Tower of Dawn", new Func<bool>(() => vars.TowerofDawn()))},
        {"SettingSun", Tuple.Create(false, "Setting Sun", "Split on the Ladder near the setting sun save", new Func<bool>(() => vars.SettingSun()))},
        {"HonorGlory", Tuple.Create(true, "Honor and Glory", "Split on starting the last fight with enemies", new Func<bool>(() => vars.HonorGlory()))},
        {"GrandRewind", Tuple.Create(true, "Grand Rewind", "Split on starting the Vizier fight", new Func<bool>(() => vars.GrandRewind()))},
        {"SoTEnd", Tuple.Create(true, "The End", "Split on defeating the Vizier or hitting the credits trigger", new Func<bool>(() => vars.SoTEnd()))},
        {"SoTLU", Tuple.Create(false, "Life Upgrades", "Split on obtaining each life upgrade", new Func<bool>(() => vars.SoTLU()))},
    };

    foreach (var data in vars.splitsData) {
        settings.Add(data.Key, data.Value.Item1, data.Value.Item2);
        settings.SetToolTip(data.Key, data.Value.Item3);
    }
}

init
{
    vars.inXRange = (Func<float, float, bool>)((xMin, xMax) => { return current.xPos >= xMin && current.xPos <= xMax; });
    vars.inYRange = (Func<float, float, bool>)((yMin, yMax) => { return current.yPos >= yMin && current.yPos <= yMax; });
    vars.inZRange = (Func<float, float, bool>)((zMin, zMax) => { return current.zPos >= zMin && current.zPos <= zMax; });
    vars.splitByXYZ = (Func<float, float, float, float, float, float, bool>)((xMin, xMax, yMin, yMax, zMin, zMax) => {
        return
            vars.inXRange(xMin, xMax) &&
            vars.inYRange(yMin, yMax) &&
            vars.inZRange(zMin, zMax);
    });

    // List of SoT Splits across categories
    vars.GasStation = (Func <bool>)(() => { return vars.splitByXYZ(252f, 258f, 130.647f, 134f, 22.999f, 23.001f); });
    vars.SandsUnleashed = (Func <bool>)(() => { return vars.splitByXYZ(-6.177f, -6.175f, 62.905f, 62.907f, 7.604f, 7.606f); });
    vars.FirstGuestRoom = (Func <bool>)(() => { return vars.splitByXYZ(30.297f, 30.299f, 42.126f, 42.128f, 12.998f, 13f); });
    vars.SultanChamberZipless = (Func <bool>)(() => { return vars.splitByXYZ(98.445f, 98.447f, 39.567f, 39.57f, -8.96f, -8.958f); });
    vars.SultanChamber = (Func <bool>)(() => { return vars.splitByXYZ(134.137f, 134.139f, 54.990f, 54.992f, -32.791f, -32.789f); });
    vars.PalaceDefence = (Func <bool>)(() => { return vars.splitByXYZ(4.547f, 8.851f, 40.494f, 47.519f, -39.001f, -38.999f); });
    vars.DadStart = (Func <bool>)(() => { return vars.splitByXYZ(6.714f, 6.716f, 57.698f, 57.7f, 21.005f, 21.007f); });
    vars.DadDead = (Func <bool>)(() => { return vars.splitByXYZ(-6.001f, -5.999f, -18.6f, -18.4f, 1.998f, 2.001f); });
    vars.TheWarehouse = (Func <bool>)(() => { return vars.splitByXYZ(-73.352f, -71.233f, -28.5f, -26.868f, -1.001f, -0.818f); });
    vars.TheZoo = (Func <bool>)(() => { return vars.splitByXYZ(-141.299f, -139.797f, -47.21f, -42.801f, -31.1f, -30.9f); });
    vars.BirdCage = (Func <bool>)(() => { return vars.splitByXYZ(-211f, -208f, -23f, -21f, -9f, -8.8f); });
    vars.CliffWaterfalls = (Func <bool>)(() => { return vars.splitByXYZ(-233.6f, -231.4f, 33.7f, 35f, -42.6f, -42.4f); });
    vars.TheBathsZipless = (Func <bool>)(() => { return vars.splitByXYZ(-215.85f, -214.089f, 54.261f, 58.699f, -43.501f, -43.499f); });
    vars.TheBaths = (Func <bool>)(() => { return vars.splitByXYZ(-211.427f, -211.425f, 56.602f, 56.604f, -43.501f, -43.499f); });
    vars.SecondSword = (Func <bool>)(() => { return vars.splitByXYZ(-106.819f, -106.817f, 81.097f, 81.099f, -27.269f, -27.267f); });
    vars.TheDaybreak = (Func <bool>)(() => { return vars.splitByXYZ(-76f, -70f, 192.4f, 197.6f, -56.6f, -54f); });
    vars.TheMesshall = (Func <bool>)(() => { return vars.splitByXYZ(-183.267f, -183.265f, 234.685f, 234.687f, -37.528f, -37.526f); });
    vars.DrawbridgeTower = (Func <bool>)(() => { return vars.splitByXYZ(-267f, -262f, 232f, 267f, -35.6f, -35.5f); });
    vars.BrokenBridge = (Func <bool>)(() => { return vars.splitByXYZ(-265f, -257f, 159f, 167f, -13.6f, -13.4f); });
    vars.TheCavesZipless = (Func <bool>)(() => { return vars.splitByXYZ(-303f, -297.5f, 112f, 113.5f, -56.1f, -55.9f); });
    vars.TheCaves = (Func <bool>)(() => { return vars.splitByXYZ(-246.839f, -241.677f, 78.019f, 87.936f, -71.731f, -70.7f); });
    vars.TheWaterfall = (Func <bool>)(() => { return vars.splitByXYZ(-242f, -240.5f, 79.5f, 83f, -121f, -118f); });
    vars.TheUGReservoirZipless = (Func <bool>)(() => { return vars.splitByXYZ(-121f, -110f, -9f, -7f, -154.1f, -153.9f); });
    vars.TheUGReservoir = (Func <bool>)(() => { return vars.splitByXYZ(-51.477f, -48.475f, 72.155f, 73.657f, -24.802f, -24.799f); });
    vars.HallofLearning = (Func <bool>)(() => { return vars.splitByXYZ(73f, 79f, 161f, 163f, -24.1f, -23.9f); });
    vars.TheObservatory = (Func <bool>)(() => { return vars.splitByXYZ(139.231f, 139.233f, 162.556f, 162.558f, -29.502f, -29.5f); });
    vars.ObservatoryExit = (Func <bool>)(() => { return vars.splitByXYZ(137f, 141f, 164f, 164.67f, -29.5f, -29.2f); });
    vars.HoLCourtyardsExit = (Func <bool>)(() => { return vars.splitByXYZ(72f, 77f, 90f, 95.7f, -27.1f, -26.9f); });
    vars.TheAzadPrison = (Func <bool>)(() => { return vars.splitByXYZ(190f, 195f, -21f, -19f, -17.6f, -17.3f); });
    vars.TortureChamberZipless = (Func <bool>)(() => { return vars.splitByXYZ(187.5f, 192.5f, -39f, -37.5f, -119.1f, -118.9f); });
    vars.TortureChamber = (Func <bool>)(() => { return vars.splitByXYZ(189.999f, 190.001f, -43.278f, -43.276f, -119.001f, -118.999f); });
    vars.TheElevator = (Func <bool>)(() => { return vars.splitByXYZ(74f, 75f, -46.751f, -43.252f, -34f, -33f); });
    vars.TheDreamZipless = (Func <bool>)(() => { return vars.splitByXYZ(99f, 101f, -11f, -10f, -56f, -54f); });
    vars.TheDream = (Func <bool>)(() => { return vars.splitByXYZ(95.8f, 96f, -25.1f, -24.9f, -74.9f, -74.7f); });
    vars.TheTomb = (Func <bool>)(() => { return vars.splitByXYZ(100.643f, 100.645f, -11.543f, -11.541f, -67.588f, -67.586f); });
    vars.TowerofDawn = (Func <bool>)(() => { return vars.splitByXYZ(35.5f, 35.7f, -50f, -39f, -32f, -30f); });
    vars.SettingSun = (Func <bool>)(() => { return vars.splitByXYZ(60f, 61f, -58f, -57f, 30f, 32f); });
    vars.HonorGlory = (Func <bool>)(() => { return vars.splitByXYZ(81f, 82f, -60.3f, -59.7f, 89f, 90f); });
    vars.GrandRewind = (Func <bool>)(() => { return vars.splitByXYZ(660.376f, 660.378f, 190.980f, 190.983f, 0.432f, 0.434f); });
    vars.SoTEnd = (Func <bool>)(() => { return (vars.splitByXYZ(658.26f, 661.46f, 210.92f, 213.72f, 9.8f, 12.5f) && vars.CompletedSplits.Contains("AboveCredits")) || current.vizierHealth == 4f; });
    vars.SoTLU = (Func <bool>)(() => { return vars.splitByXYZ(-492.608f, -492.606f, -248.833f, -248.831f, 0.219f, 0.221f); });

    // Deprecated or Unused Splits
    vars.TheCavesDeath = (Func <bool>)(() => { return vars.splitByXYZ(-171.193f, -171.191f, -52.07f, -52.068f, -119.863f, -119.861f); });

    vars.CompletedSplits = new HashSet<string>();

    vars.CheckSplit = (Func<string, bool>)(key => {
        return (vars.CompletedSplits.Add(key) && settings[key]);
    });
}

start
{
    // Detecting if the game has started on the balcony.
    return (current.xPos >= -103.264 && current.yPos >= -4.8 && current.zPos >= 1.341 && current.xPos <= -103.262 && current.yPos <= -4.798 && current.zPos <= 1.343 && current.startValue == 1);
}

onStart
{
    // Refresh all splits when we start the run, none are yet completed
    vars.CompletedSplits.Clear();
}

reset
{
    if (old.resetValue == 1 && current.resetValue == 2) {
        if (current.xPos >= -103.264 && current.yPos >= -4.8 && current.zPos >= 1.341 && current.xPos <= -103.262 && current.yPos <= -4.798 && current.zPos <= 1.343)
            return true;
    }
}

split
{
    if (vars.splitByXYZ(-477.88f, -477f, -298f, -297.1f, -0.5f, -0.4f)) vars.CompletedSplits.Remove("SoTLU");
    if (vars.splitByXYZ(658.26f, 661.46f, 210.92f, 213.72f, 12.5f, 30f)) vars.CompletedSplits.Add("AboveCredits");
    
    foreach (var data in vars.splitsData) {
        if (data.Value.Item4() && vars.CheckSplit(data.Key)) {
            print(data.Key);
            return true;
        }
    }
}
