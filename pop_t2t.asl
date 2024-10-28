state("POP3")
{
    // The Prince's coords
    float xPos  : 0x00A2A498, 0xC, 0x30;
    float yPos  : 0x00A2A498, 0xC, 0x34;
    float zPos  : 0x00A2A498, 0xC, 0x38;

    float xCam  : 0x928548;
    float yCam  : 0x928554;

    int princeAction   : 0x005EBD78, 0x30, 0x18, 0x4, 0x48, 0x7F0;
}

startup
{
    // Key - Setting ID, Value - Tuple of (Default setting, Description, Tooltip and Trigger condition).
    vars.splitsData = new Dictionary<string, Tuple<bool, string, string, Func<bool>>> {
        {"TheRamparts", Tuple.Create(true, "The Ramparts", "Split after the harbor district save fountain", new Func<bool>(() => vars.TheRamparts()))},
        {"HarborDistrict", Tuple.Create(true, "The Harbor District", "Split after first palace save fountain", new Func<bool>(() => vars.HarborDistrict()))},
        {"ThePalace", Tuple.Create(true, "The Palace", "Split at the end of throne room", new Func<bool>(() => vars.ThePalace()))},
        {"TrappedHallway", Tuple.Create(false, "The Trapped Hallway", "Split at end of trapped hallway at the cutscene", new Func<bool>(() => vars.TrappedHallway()))},
        {"TheSewers", Tuple.Create(false, "The Sewers", "Split on finishing the sewers dark prince section", new Func<bool>(() => vars.TheSewers()))},
        {"TheSewerz", Tuple.Create(false, "The Sewers (v2)", "Split just before the tunnels save fountain", new Func<bool>(() => vars.TheSewerz()))},
        {"TheFortress", Tuple.Create(false, "The Fortress", "Split just before entering the first Chariot", new Func<bool>(() => vars.TheFortress()))},
        {"Chariot1", Tuple.Create(false, "Chariot 1", "Split on finishing the first chariot", new Func<bool>(() => vars.Chariot1()))},
        {"LowerCity", Tuple.Create(false, "The Lower City", "Split after the lower city dark prince section", new Func<bool>(() => vars.LowerCity()))},
        {"LowerCityRooftops", Tuple.Create(false, "The Lower City Rooftops", "Split after killing Klompa", new Func<bool>(() => vars.LowerCityRooftops()))},
        {"ArenaDeload", Tuple.Create(false, "Arena Deload", "Split at the black crushers in the arena dark prince section", new Func<bool>(() => vars.ArenaDeload()))},
        {"TheBalconies", Tuple.Create(false, "The Balconies", "Split on exiting the room with the slomo gate", new Func<bool>(() => vars.TheBalconies()))},
        {"DarkAlley", Tuple.Create(false, "The Dark Alley", "Split on entering the cutscene at start of temple rooftops", new Func<bool>(() => vars.DarkAlley()))},
        {"TheTempleRooftops", Tuple.Create(true, "The Temple Rooftops", "Split on entering the door into temple", new Func<bool>(() => vars.TheTempleRooftops()))},
        {"TheTemple", Tuple.Create(false, "The Temple", "Split on finishing the temple dark prince section", new Func<bool>(() => vars.TheTemple()))},
        {"TheMarketplace", Tuple.Create(true, "The Marketplace", "Split at save fountain before cutscene drop", new Func<bool>(() => vars.TheMarketplace()))},
        {"MarketDistrict", Tuple.Create(false, "The Market District", "Split at the save fountain after the long cutscene", new Func<bool>(() => vars.MarketDistrict()))},
        {"TheBrothel", Tuple.Create(false, "The Brothel", "Split on finishing the brothel dark prince section", new Func<bool>(() => vars.TheBrothel()))},
        {"ThePlaza", Tuple.Create(true, "The Plaza", "Split at the door after Mahasti fight", new Func<bool>(() => vars.ThePlaza()))},
        {"TheUpperCity", Tuple.Create(false, "The Upper City", "Split just before the skippable Farah cutscene", new Func<bool>(() => vars.TheUpperCity()))},
        {"CityGarderns", Tuple.Create(false, "The City Garderns", "Split just before the Stone Guardian encounter", new Func<bool>(() => vars.CityGarderns()))},
        {"ThePromenade", Tuple.Create(false, "The Promenade", "Split on entering the royal workshop", new Func<bool>(() => vars.ThePromenade()))},
        {"RoyalWorkshop", Tuple.Create(true, "Royal Workshop", "Split on entering the king's road", new Func<bool>(() => vars.RoyalWorkshop()))},
        {"KingsRoad", Tuple.Create(false, "The King's Road", "Split on defeating the twins", new Func<bool>(() => vars.KingsRoad()))},
        {"KingzRoad", Tuple.Create(false, "The King's Road (v2)", "Split on the transition to palace entrance after twins fight", new Func<bool>(() => vars.KingzRoad()))},
        {"PalaceEntrance", Tuple.Create(false, "The Palace Entrance", "Split on entering the elevator cutscene", new Func<bool>(() => vars.PalaceEntrance()))},
        {"HangingGardens", Tuple.Create(false, "The Hanging Gardens", "Split at the swing pole before the last sand gate", new Func<bool>(() => vars.HangingGardens()))},
        {"HangingGardenz", Tuple.Create(false, "The Hanging Gardens (v2)", "Split at the structure's mind save fountain", new Func<bool>(() => vars.HangingGardenz()))},
        {"StructuresMind", Tuple.Create(false, "The Structure's Mind", "Split at the cutscene after the puzzle", new Func<bool>(() => vars.StructuresMind()))},
        {"StructurezMind", Tuple.Create(false, "The Structure's Mind (v2)", "Split after the transition to Well of Ancestors", new Func<bool>(() => vars.StructurezMind()))},
        {"BottomofWell", Tuple.Create(false, "Bottom of the Well", "Split after the death abuse at the bottom of the well", new Func<bool>(() => vars.BottomofWell()))},
        {"WellofAncestors", Tuple.Create(false, "The Well of Ancestors", "Split on finishing the well dark prince section", new Func<bool>(() => vars.WellofAncestors()))},
        {"TheLabyrinth", Tuple.Create(false, "The Labyrinth", "Split on entering the underground cave after breakable wall", new Func<bool>(() => vars.TheLabyrinth()))},
        {"CaveDeath", Tuple.Create(false, "Underground Cave Death", "Split on the death abuse at the end of underground cave (for zipping categories)", new Func<bool>(() => vars.CaveDeath()))},
        {"UndergroundCave", Tuple.Create(false, "The Underground Cave", "Split on entering the kitchen", new Func<bool>(() => vars.UndergroundCave()))},
        {"LowerTower", Tuple.Create(false, "The Lower Tower", "Split on entering the trap corridor after lower tower", new Func<bool>(() => vars.LowerTower()))},
        {"MiddleTower", Tuple.Create(false, "The Middle Tower", "Split on entering the trap corridor after middle tower", new Func<bool>(() => vars.MiddleTower()))},
        {"UpperTower", Tuple.Create(true, "The Upper Tower", "Split at the upper tower save fountain", new Func<bool>(() => vars.UpperTower()))},
        {"TheTerrace", Tuple.Create(true, "The Terrace", "Split on entering the mental realm", new Func<bool>(() => vars.TheTerrace()))},
        {"MentalRealm", Tuple.Create(true, "The Mental Realm", "Split on finishing the game", new Func<bool>(() => vars.MentalRealm()))},

        {"T2TLU1", Tuple.Create(false, "Life Upgrade 1", "Split after obtaining the first life upgrade in Tunnels", new Func<bool>(() => vars.T2TLU1()))},
        {"T2TLU2", Tuple.Create(false, "Life Upgrade 2", "Split after obtaining the second life upgrade in Lower City Rooftops", new Func<bool>(() => vars.T2TLU2()))},
        {"T2TLU3", Tuple.Create(false, "Life Upgrade 3", "Split after obtaining the third life upgrade in Temple", new Func<bool>(() => vars.T2TLU3()))},
        {"T2TLU4", Tuple.Create(false, "Life Upgrade 4", "Split after obtaining the fourth life upgrade in Tunnels", new Func<bool>(() => vars.T2TLU4()))},
        {"T2TLU5", Tuple.Create(false, "Life Upgrade 5", "Split after obtaining the fifth life upgrade in Canal", new Func<bool>(() => vars.T2TLU5()))},
        {"T2TLU6", Tuple.Create(false, "Life Upgrade 6", "Split after obtaining the sixth life upgrade in Middle Tower", new Func<bool>(() => vars.T2TLU6()))},
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
            vars.inZRange(zMin, zMax); });

    // List of T2T Splits across categories
    vars.TheRamparts = (Func <bool>)(() => { return vars.splitByXYZ(-271f, -265f, 187f, 188f, 74f, 75f); });
    vars.HarborDistrict = (Func <bool>)(() => { return vars.splitByXYZ(-93f, -88f, 236.2f, 238f, 83f, 88f); });
    vars.ThePalace = (Func <bool>)(() => { return vars.splitByXYZ(-35.5f, -35.4f, 232.3f, 232.4f, 146.9f, 147f); });
    vars.TrappedHallway = (Func <bool>)(() => { return vars.splitByXYZ(-52.1f, -52.0f, 135.8f, 135.9f, 75.8f, 76f); });
    vars.TheSewerz = (Func <bool>)(() => { return vars.splitByXYZ(-100f, -96f, -83f, -79f, 19.9f, 20f); });
    vars.TheSewers = (Func <bool>)(() => { return vars.splitByXYZ(-89.0f, -88.0f, -15.2f, -14.7f, 4.9f, 5.1f); });
    vars.TheFortress = (Func <bool>)(() => { return vars.splitByXYZ(-71.4f, -71.3f, 9.6f, 9.7f, 44f, 44.1f); });
    vars.Chariot1 = (Func <bool>)(() => { return vars.splitByXYZ(-443.37f, -443.36f, 355.80f, 355.81f, 57.71f, 57.72f); });
    vars.LowerCity = (Func <bool>)(() => { return vars.splitByXYZ(-319f, -316.5f, 317f, 332.6f, 95.1f, 98f); });
    vars.LowerCityRooftops = (Func <bool>)(() => { return vars.splitByXYZ(-261.5f, -261f, 318f, 319.5f, 46f, 48f); });
    vars.ArenaDeload = (Func <bool>)(() => { return vars.splitByXYZ(-256.1f, -251.9f, 358f, 361.5f, 53.9f, 63.3f); });
    vars.TheBalconies = (Func <bool>)(() => { return vars.splitByXYZ(-194f, -190f, 328f, 329.7f, 32.6f, 33.6f); });
    vars.DarkAlley = (Func <bool>)(() => { return vars.splitByXYZ(-114f, -110f, 328f, 338f, 55f, 59f); });
    vars.TheTempleRooftops = (Func <bool>)(() => { return vars.splitByXYZ(-122.6f, -117.7f, 421.6f, 423f, 107f, 108.1f); });
    vars.TheTemple = (Func <bool>)(() => { return vars.splitByXYZ(-212.2f, -211.9f, 419.0f, 419.8f, 81f, 82f); });
    vars.TheMarketplace= (Func <bool>)(() => { return vars.splitByXYZ(-213f, -207f, 484f, 490f, 101f, 103f); });
    vars.MarketDistrict = (Func <bool>)(() => { return vars.splitByXYZ(-185.5f, -175.5f, 524f, 530f, 90f, 92f); });
    vars.TheBrothel = (Func <bool>)(() => { return vars.splitByXYZ(-152.3f, -152.0f, 549.8f, 549.9f, 91.8f, 92f); });
    vars.ThePlaza = (Func <bool>)(() => { return vars.splitByXYZ(-104f, -100f, 548f, 553f, 105.5f, 106.1f); });
    vars.TheUpperCity = (Func <bool>)(() => { return vars.splitByXYZ(-124.5f, -122.5f, 500f, 505f, 97f, 99f); });
    vars.CityGarderns = (Func <bool>)(() => { return vars.splitByXYZ(-63.5f, -63.4f, 389.7f, 389.8f, 85.2f, 85.3f); });
    vars.ThePromenade = (Func <bool>)(() => { return vars.splitByXYZ(-3f, -1f, 515f, 519f, 72f, 75f); });
    vars.RoyalWorkshop = (Func <bool>)(() => { return vars.splitByXYZ(58f, 62f, 470f, 480f, 79f, 81f); });
    vars.KingsRoad = (Func <bool>)(() => { return vars.splitByXYZ(91.9289f, 91.9290f, 230.0479f, 230.0480f, 70.9877f, 70.9879f); });
    vars.KingzRoad = (Func <bool>)(() => { return vars.splitByXYZ(53f, 70f, 240f, 250f, 70f, 73f); });
    vars.PalaceEntrance = (Func <bool>)(() => { return vars.splitByXYZ(30.8f, 30.9f, 271.2f, 271.3f, 126f, 126.1f); });
    vars.HangingGardens = (Func <bool>)(() => { return vars.splitByXYZ(26f, 28f, 211f, 213f, 191f, 193f); });
    vars.HangingGardenz = (Func <bool>)(() => { return vars.splitByXYZ(5.2f, 5.4f, 213.5f, 215.6f, 194.9f, 196.2f); });
    vars.StructuresMind = (Func <bool>)(() => { return vars.splitByXYZ(-34f, -27f, 240f, 250f, 178f, 180f); });
    vars.StructurezMind = (Func <bool>)(() => { return vars.splitByXYZ(5f, 12f, 243f, 265f, 104f, 104.1f); });
    vars.BottomofWell = (Func <bool>)(() => { return vars.splitByXYZ(-21.35f, -21.34f, 252.67f, 252.68f, 20.95f, 20.96f); });
    vars.WellofAncestors = (Func <bool>)(() => { return vars.splitByXYZ(-12.6f, -12.5f, 241.2f, 241.3f, 0.9f, 1f); });
    vars.CaveDeath = (Func <bool>)(() => { return vars.splitByXYZ(5.99f, 6.00f, 306.96f, 306.97f, 42f, 42.01f); });
    vars.TheLabyrinth = (Func <bool>)(() => { return vars.splitByXYZ(-25.5f, -23f, 325f, 338f, 35.9f, 37.5f); });
    vars.UndergroundCave = (Func <bool>)(() => { return vars.splitByXYZ(-11f, -9f, 327f, 334f, 73f, 74f); });
    vars.LowerTower = (Func <bool>)(() => { return vars.splitByXYZ(-5f, -3f, 316f, 317.5f, 139.9f, 140.1f); });
    vars.MiddleTower = (Func <bool>)(() => { return vars.splitByXYZ(-18f, -12f, 303f, 305f, 184.8f, 185.1f); });
    vars.UpperTower = (Func <bool>)(() => { return vars.splitByXYZ(-8f, -7f, 296f, 298f, 226.9f, 227f); });
    vars.TheTerrace = (Func <bool>)(() => { return vars.splitByXYZ(-7.2f, -6.9f, 245.6f, 245.9f, 677f, 679f); });
    vars.MentalRealm = (Func <bool>)(() => { return vars.splitByXYZ(189f, 194f, 318f, 330f, 540f, 560f) && current.princeAction == 17; });
    vars.T2TLU1 = (Func <bool>)(() => { return vars.splitByXYZ(-14.9972f, -14.9970f, -112.8152f, -112.8150f, 20.0732f, 20.0734f); });
    vars.T2TLU2 = (Func <bool>)(() => { return vars.splitByXYZ(-302.0919f, -302.0917f, 370.8710f, 370.8712f, 52.858f, 52.8582f); });
    vars.T2TLU3 = (Func <bool>)(() => { return vars.splitByXYZ(-187.3369f, -187.3367f, -455.9863f, 455.9865f, 78.0330f, 78.0332f); });
    vars.T2TLU4 = (Func <bool>)(() => { return vars.splitByXYZ(-55.0147f, -55.0145f, 395.7608f, 395.761f, 72.0774f, 72.0776f); });
    vars.T2TLU5 = (Func <bool>)(() => { return vars.splitByXYZ(-30.1223f, -30.1221f, 281.8893f, 281.8895f, 104.0796f, 104.0798f); });
    vars.T2TLU6 = (Func <bool>)(() => { return vars.splitByXYZ(-23.9663f, -23.9661f, 253.9438f, 253.944f, 183.0634f, 183.0636f); });

    // Deprecated or Unused Splits
    vars.LCRooftopZips = (Func <bool>)(() => { return vars.splitByXYZ(-246f, -241.5f, 373.5f, 383.6f, 66f, 69f); });
    vars.WellofZipless = (Func <bool>)(() => { return vars.splitByXYZ(-28f, -26.5f, 250f, 255f, 20.9f, 30f); });
    vars.UndergroundCaveZipnt = (Func <bool>)(() => { return vars.splitByXYZ(27f, 29f, 316.5f, 318f, 99.9f, 100.1f); });

    vars.CompletedSplits = new HashSet<string>();

    vars.CheckSplit = (Func<string, bool>)(key => {
        return (vars.CompletedSplits.Add(key) && settings[key]);
    });
}

start
{
    // Detecting if the game has started on the ramparts.
    if (current.xPos >= -404.9 && current.xPos <= -404.8 && current.yCam <= 0.1082 && current.yCam >= 0.1080 && current.xCam <= 0.832 && current.xCam >= 0.8318)
        return true;
}

onStart
{
    // Refresh all splits when we start the run, none are yet completed
    vars.CompletedSplits.Clear();
}

reset
{
    // Detecting if the game has started on the ramparts.
    if (current.xPos >= -443 && current.xPos <= -442.9 && current.yCam == 0)
        return true;
}

split
{
    foreach (var data in vars.splitsData) {
        if (data.Value.Item4() && vars.CheckSplit(data.Key)) {
            print(data.Key);
            return true;
        }
    }
}
