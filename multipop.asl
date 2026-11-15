state("POP")
{
    // Some memory value that reliably changes when 'New Game' is pressed.
    int startValue      : 0x6BC980;

    // Prince's position
    float xPos          : 0x00699474, 0xC, 0x30;
    float yPos          : 0x00699474, 0xC, 0x34;
    float zPos          : 0x00699474, 0xC, 0x38;

    float xCam          : 0x006DA1B0, 0xC, 0x30;

    // The Vizier's health where 0 is unharmed and 4 is dead.
    int vizierHealth    : 0x0040E518, 0x6C, 0x18, 0x4, 0x44, 0x0;
}

state("POP2")
{
    // This variable is 0 during gameplay, 1 in cutscenes, 2 when a cutscene ends
    int cutscene        : 0x9665D0, 0x18, 0x4, 0x48, 0xE0;

    // Story counter/gate/value
    int storyValue      : 0x523578;

    // A value that changes reliably depending on which weapon you pick up
    int secondaryWeapon : 0x53F8F0, 0x4, 0x164, 0xC, 0x364;

    // The address used for most bosses' health
    int bossHealth      : 0x90C418, 0x18, 0x4, 0x48, 0x198;

    // The Prince's coords
    float xPos          : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x30;
    float yPos          : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x34;
    float zPos          : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x38;

    // Currently loaded area id (changes with every load trigger)
    int map             : 0x523594;

    // State of the prince (11 is drinking)
    int state           : 0x90C414, 0x18, 0x4, 0x48, 0x3F8;

    // Unscaled ticks, but goes back with rewind
    long physicsTicks   : 0x5409A0;

    // Slows down during slomo, but runs perfectly while rewinding
    long scaledTicks    : 0x540990;

    // Multiplier used by the game to convert ticks to seconds
    float tickMul       : 0x4BDF1C;
}

state("POP3")
{
    // The Prince's coords
    float xPos          : 0x00A2A498, 0xC, 0x30;
    float yPos          : 0x00A2A498, 0xC, 0x34;
    float zPos          : 0x00A2A498, 0xC, 0x38;

    float xCam          : 0x928548;
    float yCam          : 0x928554;

    // A value that reliably changes with prince's actions (17 during cutscenes)
    int princeAction    : 0x005EBD78, 0x30, 0x18, 0x4, 0x48, 0x7F0;
}

// Data structures:
// Setting: bool Default, string Slug, List<string> EventSlugs, string Description, string? ToolTip, string? ParentSlug
// Event:   int EventType, string Slug, List<string> SettingSlugs, ((float, float, float, float, float, float)?, int[]?) HashParams, Func<bool> Condition

// Data structures as tuples:
// Setting: Tuple<bool, string, List<string>, string, string, string>
// Event:   Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>

// any temporary object that is not needed after startup should be marked with a "GC" comment and set to null before startup finishes
startup
{
    // ==========================================================================================================================
    // ================================================== FUNCTION DEFINITIONS ==================================================
    // ==========================================================================================================================

    // ================================================== coordinate checks ==================================================

    Func<float, float, float, bool> InBounds = (min, max, pos) => pos >= min && pos <= max;
    Func<float, float, bool> InXBoundsOld = (min, max) => old.xPos >= min && old.xPos <= max;
    Func<float, float, bool> InYBoundsOld = (min, max) => old.yPos >= min && old.yPos <= max;
    Func<float, float, bool> InZBoundsOld = (min, max) => old.zPos >= min && old.zPos <= max;
    Func<float, float, bool> InXBoundsCurrent = (min, max) => current.xPos >= min && current.xPos <= max;
    Func<float, float, bool> InYBoundsCurrent = (min, max) => current.yPos >= min && current.yPos <= max;
    Func<float, float, bool> InZBoundsCurrent = (min, max) => current.zPos >= min && current.zPos <= max;

    Func<float, float, float, float, float, float, float, float, float, bool> InPosWithBounds = (xMin, xMax, yMin, yMax, zMin, zMax, xPos, yPos, zPos)
    =>
        xPos >= xMin && xPos <= xMax &&
        yPos >= yMin && yPos <= yMax &&
        zPos >= zMin && zPos <= zMax;

    Func<float, float, float, float, float, float, bool> InPosWithBoundsOld = (xMin, xMax, yMin, yMax, zMin, zMax)
    =>
        old.xPos >= xMin && old.xPos <= xMax &&
        old.yPos >= yMin && old.yPos <= yMax &&
        old.zPos >= zMin && old.zPos <= zMax;

    Func<float, float, float, float, float, float, bool> InPosWithBoundsCurrent = (xMin, xMax, yMin, yMax, zMin, zMax)
    =>
        current.xPos >= xMin && current.xPos <= xMax &&
        current.yPos >= yMin && current.yPos <= yMax &&
        current.zPos >= zMin && current.zPos <= zMax;

    Func<float, float, float, bool> InRange = (targ, range, pos) => pos >= targ - range && pos <= targ + range;
    Func<float, float, bool> InXRangeOld = (targ, range) => old.xPos >= targ - range && old.xPos <= targ + range;
    Func<float, float, bool> InYRangeOld = (targ, range) => old.yPos >= targ - range && old.yPos <= targ + range;
    Func<float, float, bool> InZRangeOld = (targ, range) => old.zPos >= targ - range && old.zPos <= targ + range;
    Func<float, float, bool> InXRangeCurrent = (targ, range) => current.xPos >= targ - range && current.xPos <= targ + range;
    Func<float, float, bool> InYRangeCurrent = (targ, range) => current.yPos >= targ - range && current.yPos <= targ + range;
    Func<float, float, bool> InZRangeCurrent = (targ, range) => current.zPos >= targ - range && current.zPos <= targ + range;

    Func<float, float, float, bool> InXyRangeOld = (xTarg, yTarg, range)
    =>
        old.xPos >= xTarg - range && old.xPos <= xTarg + range &&
        old.yPos >= yTarg - range && old.yPos <= yTarg + range;
    
    Func<float, float, float, bool> InXyRangeCurrent = (xTarg, yTarg, range)
    =>
        current.xPos >= xTarg - range && current.xPos <= xTarg + range &&
        current.yPos >= yTarg - range && current.yPos <= yTarg + range;

    Func<float, float, float, float, float, float, float, bool> InPosWithRange = (xTarg, yTarg, zTarg, range, xPos, yPos, zPos)
    =>
        xPos >= xTarg - range && xPos <= xTarg + range &&
        yPos >= yTarg - range && yPos <= yTarg + range &&
        zPos >= zTarg - range && zPos <= zTarg + range;

    Func<float, float, float, float, bool> InPosWithRangeOld = (xTarg, yTarg, zTarg, range)
    =>
        old.xPos >= xTarg - range && old.xPos <= xTarg + range &&
        old.yPos >= yTarg - range && old.yPos <= yTarg + range &&
        old.zPos >= zTarg - range && old.zPos <= zTarg + range;

    Func<float, float, float, float, bool> InPosWithRangeCurrent = (xTarg, yTarg, zTarg, range)
    =>
        current.xPos >= xTarg - range && current.xPos <= xTarg + range &&
        current.yPos >= yTarg - range && current.yPos <= yTarg + range &&
        current.zPos >= zTarg - range && current.zPos <= zTarg + range;

    Func<float, float, float, float, float, float, float, float, bool> InPosWithRangeXyZ = (xTarg, yTarg, zTarg, xyRange, zRange, xPos, yPos, zPos)
    =>
        xPos >= xTarg - xyRange && xPos <= xTarg + xyRange &&
        yPos >= yTarg - xyRange && yPos <= yTarg + xyRange &&
        zPos >= zTarg - zRange && zPos <= zTarg + zRange;
    
    Func<float, float, float, float, float, bool> InPosWithRangeXyZOld = (xTarg, yTarg, zTarg, xyRange, zRange)
    =>
        old.xPos >= xTarg - xyRange && old.xPos <= xTarg + xyRange &&
        old.yPos >= yTarg - xyRange && old.yPos <= yTarg + xyRange &&
        old.zPos >= zTarg - zRange && old.zPos <= zTarg + zRange;
    
    Func<float, float, float, float, float, bool> InPosWithRangeXyZCurrent = (xTarg, yTarg, zTarg, xyRange, zRange)
    =>
        current.xPos >= xTarg - xyRange && current.xPos <= xTarg + xyRange &&
        current.yPos >= yTarg - xyRange && current.yPos <= yTarg + xyRange &&
        current.zPos >= zTarg - zRange && current.zPos <= zTarg + zRange;

    Func<float, float, float, float, float, float, bool> InPosExact = (xTarg, yTarg, zTarg, xPos, yPos, zPos)
    =>
        xTarg == xPos &&
        yTarg == yPos &&
        zTarg == zPos;

    Func<float, float, float, bool> InPosExactOld = (xTarg, yTarg, zTarg)
    =>
        xTarg == old.xPos &&
        yTarg == old.yPos &&
        zTarg == old.zPos;
        
    Func<float, float, float, bool> InPosExactCurrent = (xTarg, yTarg, zTarg)
    =>
        xTarg == current.xPos &&
        yTarg == current.yPos &&
        zTarg == current.zPos;

    Func<ValueTuple<float, float, float, float, float, float>?, int[], ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>> HashParams = (bounds, maps)
        => ValueTuple.Create(bounds, maps);

    Func<ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>> HashNull = () => HashParams(null, null);

    Func<float, float, float, float, float, float, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>> Bounds = (x1, x2, y1, y2, z1, z2)
        => HashParams(ValueTuple.Create(x1, x2, y1, y2, z1, z2), null);

    Func<float, float, float, float, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>> BoundsRange = (x, y, z, range)
        => HashParams(ValueTuple.Create(x - range, x + range, y - range, y + range, z - range, z + range), null);
    
    Func<float, float, float, float, float, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>> BoundsRangeXyZ = (x, y, z, xyRange, zRange)
        => HashParams(ValueTuple.Create(x - xyRange, x + xyRange, y - xyRange, y + xyRange, z - zRange, z + zRange), null);
    
    Func<float, float, float, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>> BoundsExact = (x, y, z)
        => HashParams(ValueTuple.Create(x, x, y, y, z, z), null);
    
    Func<int[], ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>> Maps = maps => HashParams(null, maps);

    // ================================================== runtime hash code computations ==================================================

    const float BucketSize = 20f;

    Func<float, int> GetCoordHashCode = coord => (int)Math.Floor(coord / BucketSize);

    const uint FnvPrime = 0x01000193;
    Func<int, int, int, int> CombineCoordHashCodes = (xHash, yHash, zHash) =>
    {
        uint hash = 0;
        hash = hash * FnvPrime + (uint)xHash;
        hash = hash * FnvPrime + (uint)yHash;
        hash = hash * FnvPrime + (uint)zHash;
        return (int)hash;
    };

    Func<int> GetXyzHashCodeCurrent = () =>
    {
        uint hash = 0;
        hash = hash * FnvPrime + (uint)(int)Math.Floor(current.xPos / BucketSize);
        hash = hash * FnvPrime + (uint)(int)Math.Floor(current.yPos / BucketSize);
        hash = hash * FnvPrime + (uint)(int)Math.Floor(current.zPos / BucketSize);
        return (int)hash;
    };

    // ================================================== one-time hash code computations ==================================================

    Func<float, float, float, float, float, float, int[]> GetHashCodesForBounds = (xMin, xMax, yMin, yMax, zMin, zMax) =>
    {
        int minXBucket = GetCoordHashCode(xMin);
        int maxXBucket = GetCoordHashCode(xMax);
        int xBucketCount = maxXBucket - minXBucket + 1;
        int minYBucket = GetCoordHashCode(yMin);
        int maxYBucket = GetCoordHashCode(yMax);
        int yBucketCount = maxYBucket - minYBucket + 1;
        int minZBucket = GetCoordHashCode(zMin);
        int maxZBucket = GetCoordHashCode(zMax);
        int zBucketCount = maxZBucket - minZBucket + 1;
        int bucketCount = xBucketCount * yBucketCount * zBucketCount;
        int[] hashCodes = new int[bucketCount];
        int index = 0;
        for (int x = 0; x < xBucketCount; x++)
        {
            for (int y = 0; y < yBucketCount; y++)
            {
                for (int z = 0; z < zBucketCount; z++)
                {
                    int xHashCode = minXBucket + x;
                    int yHashCode = minYBucket + y;
                    int zHashCode = minZBucket + z;
                    int hashCode = CombineCoordHashCodes(xHashCode, yHashCode, zHashCode);
                    hashCodes[index] = hashCode;
                    index++;
                }
            }
        }
        return hashCodes;
    };

    // ================================================== startup functions and helper variables ==================================================

    // we use the name mySettings to prevent conflict with the LiveSplit variable "settings"
    // Key: SettingSlug; Value: Setting
    var mySettings = new Dictionary<string, Tuple<bool, string, List<string>, string, string, string>>(); // GC
    Action<bool, string, List<string>, string, string, string> AddSetting = (@default, slug, eventSlugs, description, toolTip, parentSlug) =>
    {
        if (mySettings.ContainsKey(slug))
            throw new Exception("Internal exception (ASL): setting " + slug + " has already been added.");
        mySettings.Add(slug, Tuple.Create(@default, slug, eventSlugs, description, toolTip, parentSlug));
        settings.Add(slug, @default, description, parentSlug);
        settings.SetToolTip(slug, toolTip);
    };

    // Key: EventSlug; Value: Event
    const int StartEvent = 0;
    const int ResetEvent = 1;
    const int SplitEvent = 2;
    const int MiscEvent = 3;
    var events = new Dictionary<string, Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>>(); // GC
    Action<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>> AddEvent = (eventType, slug, settingSlugs, hashParams, condition) =>
    {
        if (events.ContainsKey(slug))
            throw new Exception("Internal exception (ASL): event " + slug + " has already been added.");
        events.Add(slug, Tuple.Create(eventType, slug, settingSlugs, hashParams, condition));
    };

    Func<int, string> GetEventString = eventType =>
    {
        switch (eventType)
        {
        case StartEvent: return "StartEvent";
        case ResetEvent: return "ResetEvent";
        case SplitEvent: return "SplitEvent";
        case MiscEvent:  return "MiscEvent";
        default:         return "UnknownEvent";
        }
    };

    // ================================================== runtime functions and helper variables ==================================================

    // Key: Hash; Value: EventList
    var XyzEventHashMap = new Dictionary<int, List<Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>>>();
    var MapEventHashMap = new Dictionary<int, List<Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>>>();

    // List<Event>
    var OtherEvents = new List<Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>>();

    HashSet<string> CompletedEvents = null;
    Action<string, string> SetCustomVariable = (name, value) => timer.Run.Metadata.SetCustomVariable(name, value);
    bool initCustomVariables = true;

    // update block sets this to an event that is not in CompletedEvents and has been triggered on this cycle
    Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>> TriggeredEvent = null;

    Func<int, bool> CheckEvent = eventType =>
    {
        if (TriggeredEvent == null)
            return false;
        if (TriggeredEvent.Item1 != eventType)
            return false;
        bool eventSetting = false;
        if (TriggeredEvent.Item3.Count == 0)
            eventSetting = true;
        else foreach (string settingSlug in TriggeredEvent.Item3)
        {
            if (settings[settingSlug])
            {
                eventSetting = true;
                break;
            }
        }
        CompletedEvents.Add(TriggeredEvent.Item2);
        print(GetEventString(eventType) + " " + TriggeredEvent.Item2 + " " + eventSetting);
        return eventSetting;
    };

    // ================================================== game-specific functions and helper variables ==================================================

    var CompletedGames = new HashSet<int>();
    vars.CompletedGames = CompletedGames;
    vars.noGameRunning = false;
    vars.game = 0;
    vars.IGTValue = 0L;

    // WW helpers
    Func<int[], bool> MapOneOfCurrent = maps => Array.Exists(maps, map => map == current.map);
    Func<int, bool> CutsceneHitWW = map => old.cutscene == 0 && current.cutscene == 1 && current.map == map;
    Func<int, bool> BossDieWW = map => old.cutscene == 0 && current.cutscene == 1 && current.map == map && current.bossHealth == 0;
    Func<int, bool> StoryGateAdvWW = storyId => old.storyValue != storyId && current.storyValue == storyId;
    Func<int, int, bool> MapChangeWW = (oldMapId, currentMapId) => old.map == oldMapId && current.map == currentMapId;

    // T2T helpers
    Func<float, float, float, float, bool> CutsceneHitT2T = (xTarg, yTarg, zTarg, range)
    =>
        old.princeAction != 17 && current.princeAction == 17 &&
        InPosWithRangeCurrent(xTarg, yTarg, zTarg, range);
    // ===================================================================================================================
    // ================================================== CONFIGURATION ==================================================
    // ===================================================================================================================

    refreshRate = 120;

    // ================================================== settings ==================================================

    //Default:bool    Slug:string                EventSlugs:List<string>            Description:string                           ToolTip:string?                                                                                        ParentSlug:string?
    // Multi-PoP Setup setting:
    AddSetting(true,  "setupSplits",            new List<string> {"setupSplits_SoT", "setupSplits_WW", "setupSplits_T2T"}, "Split on Game Setup",                           "Split at the start of each game to record setup time",                                                null);

    // Parent Categories:
    AddSetting(true,  "pop_sot.asl",            new List<string> {},                     "Sands of Time splits",                          null,                                                                                                 null);
    AddSetting(true,  "pop_ww.asl",             new List<string> {},                     "Warrior Within splits",                         null,                                                                                                 null);
    AddSetting(true,  "pop_t2t.asl",            new List<string> {},                     "The Two Thrones splits",                        null,                                                                                                 null);

    // Warrior Within Sub-Categories:
    AddSetting(false, "AnyGlitched",            new List<string> {},                     "Any% (Standard) and Any% (Zipless) splits",     null,                                                                                                 "pop_ww.asl");
    AddSetting(false, "AnyNMG",                 new List<string> {},                     "Any% (No Major Glitches) splits",               null,                                                                                                 "pop_ww.asl");
    AddSetting(false, "TEStandard",             new List<string> {},                     "True Ending (Standard) splits",                 null,                                                                                                 "pop_ww.asl");
    AddSetting(false, "TEZipless",              new List<string> {},                     "True Ending (Zipless) splits",                  null,                                                                                                 "pop_ww.asl");
    AddSetting(false, "TENMG",                  new List<string> {},                     "True Ending (No Major Glitches) splits",        null,                                                                                                 "pop_ww.asl");

    // Sands of Time splits:
    AddSetting(true,  "GasStation",              new List<string> {"GasStation"},    "Enter Treasure Vaults",                      "Split just before the first save prompt",                                                      "pop_sot.asl");
    AddSetting(true,  "SandsUnleashed",          new List<string> {"SandsUnleashed"}, "Sands Unleashed",                            "Split on starting the first fight after the CGI cutscene",                                     "pop_sot.asl");
    AddSetting(false, "FirstGuestRoom",          new List<string> {"FirstGuestRoom"}, "First Guest Room",                           "Split on entering the first guest room",                                                       "pop_sot.asl");
    AddSetting(false, "SultanChamberZipless",    new List<string> {"SultanChamberZipless"}, "The Sultan's Chamber",                       "Split on entering the Sultan's chamber at the cutscene",                                       "pop_sot.asl");
    AddSetting(false, "SultanChamber",           new List<string> {"SultanChamber"}, "The Sultan's Chamber (death)",               "Split at the death abuse in Sultan's chamber",                                                 "pop_sot.asl");
    AddSetting(false, "PalaceDefence",           new List<string> {"PalaceDefence"}, "The Palace's Defence System",                "Split on exiting the palace defense system",                                                   "pop_sot.asl");
    AddSetting(false, "DadStart",                new List<string> {"DadStart"},      "The Sand King",                              "Split on starting the fight with the Sand King",                                               "pop_sot.asl");
    AddSetting(true,  "DadDead",                 new List<string> {"DadDead"},       "Death of the Sand King",                     "Split at the end of the fight on loading the next area",                                       "pop_sot.asl");
    AddSetting(false, "TheWarehouse",            new List<string> {"TheWarehouse"},  "The Warehouse",                              "Split on hitting the button to let Farah enter Warehouse",                                     "pop_sot.asl");
    AddSetting(false, "TheZoo",                  new List<string> {"TheZoo"},        "The Sultan's Zoo",                           "Split on entering the zoo",                                                                    "pop_sot.asl");
    AddSetting(false, "BirdCage",                new List<string> {"BirdCage"},      "Atop a Bird Cage",                           "Split at the 'Atop a bird cage' save vortex",                                                  "pop_sot.asl");
    AddSetting(false, "CliffWaterfalls",         new List<string> {"CliffWaterfalls"}, "Cliffs and Waterfall",                       "Split at the start of cliffs and waterfall",                                                   "pop_sot.asl");
    AddSetting(false, "TheBathsZipless",         new List<string> {"TheBathsZipless"}, "The Baths",                                  "Split at the end of cliffs and Waterfall",                                                     "pop_sot.asl");
    AddSetting(false, "TheBaths",                new List<string> {"TheBaths"},      "The Baths (death)",                          "Split on death abuse at the start of baths",                                                   "pop_sot.asl");
    AddSetting(false, "SecondSword",             new List<string> {"SecondSword"},   "Second Sword",                               "Split on obtaining the second sword at baths",                                                 "pop_sot.asl");
    AddSetting(false, "TheDaybreak",             new List<string> {"TheDaybreak"},   "Daybreak",                                   "Split at the start of daybreak",                                                               "pop_sot.asl");
    AddSetting(false, "TheMesshall",             new List<string> {"TheMesshall"},   "Soldiers' Mess Hall (death)",                "Split on death abuse in the mess hall",                                                        "pop_sot.asl");
    AddSetting(false, "DrawbridgeTower",         new List<string> {"DrawbridgeTower"}, "Drawbridge Tower",                           "Split near the first lever at Drawbridge Tower",                                               "pop_sot.asl");
    AddSetting(false, "BrokenBridge",            new List<string> {"BrokenBridge"},  "A Broken Bridge",                            "Split at the end of the collapsing bridge",                                                    "pop_sot.asl");
    AddSetting(false, "TheCavesZipless",         new List<string> {"TheCavesZipless"}, "The Caves",                                  "Split on entering the caves after the door",                                                   "pop_sot.asl");
    AddSetting(false, "TheCaves",                new List<string> {"TheCaves"},      "The Caves (alternate)",                      "Split on the beam at the start of Waterfall",                                                  "pop_sot.asl");
    AddSetting(false, "TheWaterfall",            new List<string> {"TheWaterfall"},  "The Waterfall",                              "Split at the end of the descent in Waterfall",                                                 "pop_sot.asl");
    AddSetting(false, "TheUGReservoirZipless",   new List<string> {"TheUGReservoirZipless"}, "Enter Underground Reservoir",                "Split on entering the underground reservoir",                                                  "pop_sot.asl");
    AddSetting(false, "TheUGReservoir",          new List<string> {"TheUGReservoir"}, "Exit Underground Reservoir",                 "Split on exiting the underground reservoir",                                                   "pop_sot.asl");
    AddSetting(false, "HallofLearning",          new List<string> {"HallofLearning"}, "The Hall of Learning",                       "Split on entering the hall of learning",                                                       "pop_sot.asl");
    AddSetting(false, "TheObservatory",          new List<string> {"TheObservatory"}, "Observatory (death)",                        "Split on death abuse at the end of observatory",                                               "pop_sot.asl");
    AddSetting(false, "ObservatoryExit",         new List<string> {"ObservatoryExit"}, "Exit Observatory",                           "Split on exiting the observatory",                                                             "pop_sot.asl");
    AddSetting(false, "HoLCourtyardsExit",       new List<string> {"HoLCourtyardsExit"}, "Exit Hall of Learning Courtyards",           "Split on exiting hall of learning courtyards",                                                 "pop_sot.asl");
    AddSetting(false, "TheAzadPrison",           new List<string> {"TheAzadPrison"}, "The Azad Prison",                            "Split on entering the prison",                                                                 "pop_sot.asl");
    AddSetting(false, "TortureChamberZipless",   new List<string> {"TortureChamberZipless"}, "Torture Chamber",                            "Split on entering the torture chamber",                                                        "pop_sot.asl");
    AddSetting(false, "TortureChamber",          new List<string> {"TortureChamber"}, "Torture Chamber (death)",                    "Split on death abuse at the start of torture chamber",                                         "pop_sot.asl");
    AddSetting(false, "TheElevator",             new List<string> {"TheElevator"},   "The Elevator",                               "Split on entering the elevator",                                                               "pop_sot.asl");
    AddSetting(false, "TheDreamZipless",         new List<string> {"TheDreamZipless"}, "A Magic Cavern",                             "Split at the start of the long unskippable cutscene",                                          "pop_sot.asl");
    AddSetting(false, "TheDream",                new List<string> {"TheDream"},      "A Magic Cavern (alternate)",                 "Split at the start of the 'infinite' stairs",                                                  "pop_sot.asl");
    AddSetting(false, "TheTomb",                 new List<string> {"TheTomb"},       "The Tomb",                                   "Split at the start of the tomb",                                                               "pop_sot.asl");
    AddSetting(false, "TowerofDawn",             new List<string> {"TowerofDawn"},   "Tower of Dawn",                              "Split at the start of the ascent back up the Tower of Dawn",                                   "pop_sot.asl");
    AddSetting(false, "SettingSun",              new List<string> {"SettingSun"},    "Setting Sun",                                "Split on the Ladder near the setting sun save",                                                "pop_sot.asl");
    AddSetting(true,  "HonorGlory",              new List<string> {"HonorGlory"},    "Honor and Glory",                            "Split on starting the last fight with enemies",                                                "pop_sot.asl");
    AddSetting(true,  "GrandRewind",             new List<string> {"GrandRewind"},   "Grand Rewind",                               "Split on starting the Vizier fight",                                                           "pop_sot.asl");
    AddSetting(true,  "SoTEnd",                  new List<string> {"SoTEnd"},        "The End",                                    "Split on defeating the Vizier or hitting the credits trigger",                                 "pop_sot.asl");
    AddSetting(false, "SoTLU",                   new List<string> {"SoTLU"},         "Life Upgrades",                              "Split on obtaining each life upgrade",                                                         "pop_sot.asl");
    // Warrior Within splits:
    AddSetting(true,  "Any0",                    new List<string> {"boat"},          "Boat",                                       "Split when the boat ending cutscene starts playing",                                           "AnyGlitched");
    AddSetting(true,  "Any1",                    new List<string> {"ravenMan"},      "Raven man",                                  "Split on the cutscene where you're introduced to a raven master",                              "AnyGlitched");
    AddSetting(true,  "Any2",                    new List<string> {"firstPortal"},   "Time portal",                                "Split when you go through the first time portal",                                              "AnyGlitched");
    AddSetting(true,  "Any3",                    new List<string> {"foundryFountain"}, "Foundy fountain",                            "Split when you drink from the foundry fountain while having 58/59 storygate",                  "AnyGlitched");
    AddSetting(true,  "Any4",                    new List<string> {"scorpionSword"}, "Scorpion sword",                             "Split when you get the scorpion sword",                                                        "AnyGlitched");
    AddSetting(false, "Any5",                    new List<string> {"banana"},        "Light sword",                                "Split when you pick up the light sword in mystic caves",                                       "AnyGlitched");
    AddSetting(true,  "Any6",                    new List<string> {"rng63"},         "Mechanical tower (63)",                      "Split when you acquire storygate 63",                                                          "AnyGlitched");
    AddSetting(true,  "Any7",                    new List<string> {"lastPortal"},    "Second portal",                              "Split when you go through the time portal in the throne room",                                 "AnyGlitched");
    AddSetting(true,  "Any8",                    new List<string> {"kaileena"},      "Kaileena",                                   "Split when you kill Kaileena in sacred caves",                                                 "AnyGlitched");
    AddSetting(true,  "TeStandard0",             new List<string> {"boat"},          "Boat",                                       "Split when the boat ending cutscene starts playing",                                           "TEStandard");
    AddSetting(true,  "TeStandard1",             new List<string> {"ravenMan"},      "Raven man",                                  "Split on the cutscene where you're introduced to a raven master",                              "TEStandard");
    AddSetting(true,  "TeStandard2",             new List<string> {"firstPortal"},   "Time portal",                                "Split when you go through the first time portal",                                              "TEStandard");
    AddSetting(true,  "TeStandard3",             new List<string> {"LUFortress"},    "(1) fortress entrance LU",                   "Split when you acquire the life upgrade in fortress entrance",                                 "TEStandard");
    AddSetting(true,  "TeStandard4",             new List<string> {"LUPrison"},      "(2) Prison LU",                              "Split when you acquire the life upgrade in prison",                                            "TEStandard");
    AddSetting(true,  "TeStandard5",             new List<string> {"LULibrary"},     "(3) Library LU",                             "Split when you acquire the life upgrade in library",                                           "TEStandard");
    AddSetting(true,  "TeStandard6",             new List<string> {"LUMechTower"},   "(4) Mechanical tower LU",                    "Split when you acquire the life upgrade in mechanical tower",                                  "TEStandard");
    AddSetting(true,  "TeStandard7",             new List<string> {"LUGarden"},      "(5) Garden LU",                              "Split when you acquire the life upgrade in garden",                                            "TEStandard");
    AddSetting(true,  "TeStandard8",             new List<string> {"LUWaterworks"},  "(6) Waterworks LU",                          "Split when you acquire the life upgrade in waterworks",                                        "TEStandard");
    AddSetting(true,  "TeStandard9",             new List<string> {"LUShahdee"},     "(7) Sacrificial altar LU",                   "Split when you acquire the life upgrade in sacrificial altar",                                 "TEStandard");
    AddSetting(true,  "TeStandard10",            new List<string> {"LU019"},         "(8) Southern passage LU",                    "Split when you acquire the life upgrade in southern passage",                                  "TEStandard");
    AddSetting(true,  "TeStandard11",            new List<string> {"LUCentralHall"}, "(9) Central hall LU",                        "Split when you acquire the life upgrade in central hall",                                      "TEStandard");
    AddSetting(true,  "TeStandard12",            new List<string> {"WaterSword"},    "Water sword",                                "Split when you get the water sword",                                                           "TEStandard");
    AddSetting(true,  "TeStandard13",            new List<string> {"Dahaka"},        "Dahaka",                                     "Split when you defeat Dahaka",                                                                 "TEStandard");
    AddSetting(true,  "TeZipless0",              new List<string> {"boat"},          "Boat",                                       "Split when the boat ending cutscene starts playing",                                           "TEZipless");
    AddSetting(true,  "TeZipless1",              new List<string> {"ravenMan"},      "Raven man",                                  "Split on the cutscene where you're introduced to a raven master",                              "TEZipless");
    AddSetting(false, "TeZipless2",              new List<string> {"firstPortal"},   "Time portal",                                "Split when you go through the first time portal",                                              "TEZipless");
    AddSetting(true,  "TeZipless3",              new List<string> {"LUCentralHall"}, "(1) Central hall LU",                        "Split when you acquire the life upgrade in central hall",                                      "TEZipless");
    AddSetting(true,  "TeZipless4",              new List<string> {"LUWaterworks"},  "(2) Waterworks LU",                          "Split when you acquire the life upgrade in waterworks",                                        "TEZipless");
    AddSetting(true,  "TeZipless5",              new List<string> {"LUGarden"},      "(3) Garden LU",                              "Split when you acquire the life upgrade in garden",                                            "TEZipless");
    AddSetting(true,  "TeZipless6",              new List<string> {"LUFortress"},    "(4) Fortress entrance LU",                   "Split when you acquire the life upgrade in fortress entrance",                                 "TEZipless");
    AddSetting(true,  "TeZipless7",              new List<string> {"rng59"},         "Foundry (59)",                               "Split when you acquire storygate 59",                                                          "TEZipless");
    AddSetting(true,  "TeZipless8",              new List<string> {"LUPrison"},      "(5) Prison LU",                              "Split when you acquire the life upgrade in prison",                                            "TEZipless");
    AddSetting(true,  "TeZipless9",              new List<string> {"LULibrary"},     "(6) Library LU",                             "Split when you acquire the life upgrade in library",                                           "TEZipless");
    AddSetting(false, "TeZipless10",             new List<string> {"banana"},        "Light sword",                                "Split when you pick up the light sword in mystic caves",                                       "TEZipless");
    AddSetting(true,  "TeZipless11",             new List<string> {"rng63"},         "Mechanical tower (63)",                      "Split when you acquire storygate 63",                                                          "TEZipless");
    AddSetting(true,  "TeZipless12",             new List<string> {"LUMechTower"},   "(7) Mechanical tower LU",                    "Split when you acquire the life upgrade in mechanical tower",                                  "TEZipless");
    AddSetting(true,  "TeZipless13",             new List<string> {"LU019"},         "(8) Southern passage LU",                    "Split when you acquire the life upgrade in southern passage",                                  "TEZipless");
    AddSetting(true,  "TeZipless14",             new List<string> {"LUShahdee"},     "(9) Sacrificial altar LU",                   "Split when you acquire the life upgrade in sacrificial altar",                                 "TEZipless");
    AddSetting(true,  "TeZipless15",             new List<string> {"WaterSword"},    "Water sword",                                "Split when you get the water sword",                                                           "TEZipless");
    AddSetting(true,  "TeZipless16",             new List<string> {"Dahaka"},        "Dahaka",                                     "Split when you defeat Dahaka",                                                                 "TEZipless");
    AddSetting(true,  "AnyNmg0",                 new List<string> {"boat"},          "Boat",                                       "Split when the boat ending cutscene starts playing",                                           "AnyNMG");
    AddSetting(true,  "AnyNmg1",                 new List<string> {"spiderSword"},   "Spider sword",                               "Split on the cutscene where you get the spider sword",                                         "AnyNMG");
    AddSetting(false, "AnyNmg2",                 new List<string> {"ravenMan"},      "Raven man",                                  "Split on the cutscene where you're introduced to a raven master",                              "AnyNMG");
    AddSetting(false, "AnyNmg3",                 new List<string> {"firstPortal"},   "Time portal",                                "Split when you go through the first time portal",                                              "AnyNMG");
    AddSetting(true,  "AnyNmg4",                 new List<string> {"chasingShahdee"}, "Soutern passage (chasing Shahdee)",          "Split when you come to southern passage past",                                                 "AnyNMG");
    AddSetting(true,  "AnyNmg5",                 new List<string> {"shahdee"},       "Shahdee (a damsel in distress)",             "Split when you kill Shahdee",                                                                  "AnyNMG");
    AddSetting(false, "AnyNmg_spPortalEnter",    new List<string> {"spPortalEnter"}, "Enter Southern Passage Portal",              "Split when you enter the portal in Southern Passage",                                          "AnyNMG");
    AddSetting(false, "AnyNmg_spPortalExit",     new List<string> {"spPortalExit"},  "Exit Southern Passage Portal",               "Split when you exit the portal in Southern Passage",                                           "AnyNMG");
    AddSetting(true,  "AnyNmg6",                 new List<string> {"princeStare"},   "The Dahaka",                                 "Split on the cutscene before the first Dahaka chase (southern passage present)",               "AnyNMG");
    AddSetting(true,  "AnyNmg7",                 new List<string> {"serpentSword"},  "Serpent sword",                              "Split on the cutscene where you get the serpent sword (hourglass chamber)",                    "AnyNMG");
    AddSetting(true,  "AnyNmg8",                 new List<string> {"gardenHall"},    "Garden hall",                                "Split when you come to garden hall",                                                           "AnyNMG");
    AddSetting(true,  "AnyNmg9",                 new List<string> {"waterworks"},    "Waterworks",                                 "Split when you come to garden waterworks",                                                     "AnyNMG");
    AddSetting(true,  "AnyNmg10",                new List<string> {"lionSword"},     "Lion sword",                                 "Split on the cutscene where you get the lion sword (central hall)",                            "AnyNMG");
    AddSetting(true,  "AnyNmg11",                new List<string> {"mechTower"},     "Mechanical tower",                           "Split when you clilmb up into the mechanical tower",                                           "AnyNMG");
    AddSetting(false, "AnyNmg12",                new List<string> {"mechElevator"},  "Mechanical tower v2 (elevator cutscene)",    "Split on the cutscene where you jump down on the elevator at the start of mech tower",         "AnyNMG");
    AddSetting(false, "AnyNmg_mpPortalEnter",    new List<string> {"mpPortalEnter"}, "Enter Mechanical Pit Portal",                "Split when you enter the portal in Mechanical Pit",                                            "AnyNMG");
    AddSetting(true,  "AnyNmg13",                new List<string> {"mechPortal"},    "Mechanical Pit Portal",                      "Split when you go through the time portal in mechanical pit",                                  "AnyNMG");
    AddSetting(false, "AnyNmg_mpPortalExit",     new List<string> {"mpPortalExit"},  "Exit Mechanical Pit Portal",                 "Split when you exit the portal in Mechanical Pit",                                             "AnyNMG");
    AddSetting(true,  "AnyNmg14",                new List<string> {"activationRuin"}, "Activation room in ruin",                    "Split when you come to the mech tower activation room in the present",                         "AnyNMG");
    AddSetting(false, "AnyNmg_arPortalEnter",    new List<string> {"arPortalEnter"}, "Enter Activation room Portal",               "Split when you enter the portal in Activation room",                                           "AnyNMG");
    AddSetting(false, "AnyNmg_arPortalExit",     new List<string> {"arPortalExit"},  "Exit Activation room Portal",                "Split when you exit the portal in Activation room",                                            "AnyNMG");
    AddSetting(true,  "AnyNmg15",                new List<string> {"activationRestore"}, "Activation room restored",                   "Split when you come to the mech tower activation room in the past",                            "AnyNMG");
    AddSetting(true,  "AnyNmg16",                new List<string> {"sandWraithDeathV1"}, "The death of a sand wraith (central hall)",  "Split in centrall hall next to the fountain after you've activated both towers",               "AnyNMG");
    AddSetting(false, "AnyNmg17",                new List<string> {"sandWraithDeathV2"}, "The death of a sand wraith v2 (central hall)", "Alternate split deeper into the corridor so you can't hit it early when jumping down",         "AnyNMG");
    AddSetting(true,  "AnyNmg18",                new List<string> {"kaileenaFirst"}, "Death of the empress",                       "Split when you kill Kaileena in the throne room (34->38)",                                     "AnyNMG");
    AddSetting(true,  "AnyNmg19",                new List<string> {"exitTomb"},      "Exit the tomb",                              "Split when you leave the tomb",                                                                "AnyNMG");
    AddSetting(false, "AnyNmg_prPortalEnter",    new List<string> {"prPortalEnter"}, "Enter Prison Portal",                        "Split when you enter the portal in Prison",                                                    "AnyNMG");
    AddSetting(false, "AnyNmg_prPortalExit",     new List<string> {"prPortalExit"},  "Exit Prison Portal",                         "Split when you exit the portal in Prison",                                                     "AnyNMG");
    AddSetting(true,  "AnyNmg20",                new List<string> {"scorpionSword"}, "Scorpion sword",                             "Split when you get the scorpion sword",                                                        "AnyNMG");
    AddSetting(false, "AnyNmg21",                new List<string> {"libraryV1"},     "Library",                                    "Split on the library opening cutscene",                                                        "AnyNMG");
    AddSetting(true,  "AnyNmg22",                new List<string> {"libraryV2"},     "Library v2",                                 "Split when you move into the library (after the opening cutscene)",                            "AnyNMG");
    AddSetting(true,  "AnyNmg23",                new List<string> {"hourglassRevisit"}, "Hourglass revisited",                        "Split when you come back to the hourglass chamber after you've killed Kaileena",               "AnyNMG");
    AddSetting(false, "AnyNmg_trPortalEnter",    new List<string> {"trPortalEnter"}, "Enter Throne Room Portal",                   "Split when you enter the cutscene after breaking Throne Room wall",                            "AnyNMG");
    AddSetting(false, "AnyNmg_trPortalExit",     new List<string> {"trPortalExit"},  "Exit Throne Room Portal",                    "Split when you exit the portal in Throne Room",                                                "AnyNMG");
    AddSetting(true,  "AnyNmg24",                new List<string> {"maskOn"},        "The mask of the wraith",                     "Split when you get to the mask",                                                               "AnyNMG");
    AddSetting(false, "AnyNmg_scPortalEnter",    new List<string> {"scPortalEnter"}, "Enter Sacred Caves Portal",                  "Split when you enter the portal in Sacred Caves",                                              "AnyNMG");
    AddSetting(false, "AnyNmg_scPortalExit",     new List<string> {"scPortalExit"},  "Exit Sacred Caves Portal",                   "Split when you exit the portal in Sacred Caves",                                               "AnyNMG");
    AddSetting(true,  "AnyNmg25",                new List<string> {"griffinV1"},     "Sand griffin",                               "Split when you kill the griffin",                                                              "AnyNMG");
    AddSetting(false, "AnyNmg26",                new List<string> {"griffinV2"},     "Sand griffin v2",                            "Split when you jump to the platform after you've killed the griffin",                          "AnyNMG");
    AddSetting(false, "AnyNmg_ugPortalEnter",    new List<string> {"ugPortalEnter"}, "Enter Upper Garden Portal",                  "Split when you enter the portal in Upper Garden",                                              "AnyNMG");
    AddSetting(false, "AnyNmg_ugPortalExit",     new List<string> {"ugPortalExit"},  "Exit Upper Garden Portal",                   "Split when you exit the portal in Upper Garden",                                               "AnyNMG");
    AddSetting(true,  "AnyNmg27",                new List<string> {"mirroredFates"}, "Mirrored fates",                             "Split on the sacrificial altar cutscene (sand wraith pov)",                                    "AnyNMG");
    AddSetting(true,  "AnyNmg28",                new List<string> {"favorUnknown"},  "A favor unknown",                            "Split on the cutscene where the sand wraith saves the prince (sand wraith pov)",               "AnyNMG");
    AddSetting(true,  "AnyNmg29",                new List<string> {"libraryRevisit"}, "Library revisited",                          "Split when you enter the library",                                                             "AnyNMG");
    AddSetting(true,  "AnyNmg30",                new List<string> {"banana"},        "Light sword",                                "Split when you pick up the light sword in mystic caves",                                       "AnyNMG");
    AddSetting(true,  "AnyNmg31",                new List<string> {"maskOff"},       "The death of a prince",                      "Split on the cutscene where you take the mask off",                                            "AnyNMG");
    AddSetting(true,  "AnyNmg32",                new List<string> {"kaileena"},      "Kaileena",                                   "Split when you kill Kaileena in sacred caves",                                                 "AnyNMG");
    AddSetting(true,  "TeNmg0",                  new List<string> {"boat"},          "Boat",                                       "Split when the boat ending cutscene starts playing",                                           "TENMG");
    AddSetting(true,  "TeNmg1",                  new List<string> {"spiderSword"},   "Spider sword",                               "Split on the cutscene where you get the spider sword",                                         "TENMG");
    AddSetting(false, "TeNmg2",                  new List<string> {"ravenMan"},      "Raven man",                                  "Split on the cutscene where you're introduced to a raven master",                              "TENMG");
    AddSetting(false, "TeNmg3",                  new List<string> {"firstPortal"},   "Time portal",                                "Split when you go through the first time portal",                                              "TENMG");
    AddSetting(true,  "TeNmg4",                  new List<string> {"chasingShahdee"}, "Soutern passage (chasing Shahdee)",          "Split when you come to southern passage past",                                                 "TENMG");
    AddSetting(true,  "TeNmg5",                  new List<string> {"LU019"},         "(1) Southern passage LU",                    "Split when you acquire the life upgrade in southern passage",                                  "TENMG");
    AddSetting(true,  "TeNmg6",                  new List<string> {"shahdee"},       "Shahdee (a damsel in distress)",             "Split when you kill Shahdee",                                                                  "TENMG");
    AddSetting(true,  "TeNmg7",                  new List<string> {"LUShahdee"},     "(2) Sacrificial alter LU",                   "Split when you acquire the life upgrade in sacrificial altar",                                 "TENMG");
    AddSetting(false, "TeNmg_spPortalEnter",     new List<string> {"spPortalEnter"}, "Enter Southern Passage Portal",              "Split when you enter the portal in Southern Passage",                                          "TENMG");
    AddSetting(false, "TeNmg_spPortalExit",      new List<string> {"spPortalExit"},  "Exit Southern Passage Portal",               "Split when you exit the portal in Southern Passage",                                           "TENMG");
    AddSetting(true,  "TeNmg8",                  new List<string> {"princeStare"},   "The Dahaka",                                 "Split on the cutscene before the first Dahaka chase (southern passage present)",               "TENMG");
    AddSetting(true,  "TeNmg9",                  new List<string> {"LUFortress"},    "(3) Fortress entrance LU",                   "Split when you acquire the life upgrade in fortress entrance",                                 "TENMG");
    AddSetting(true,  "TeNmg10",                 new List<string> {"serpentSword"},  "Serpent sword",                              "Split on the cutscene where you get the serpent sword (hourglass chamber)",                    "TENMG");
    AddSetting(true,  "TeNmg11",                 new List<string> {"gardenHall"},    "Garden hall",                                "Split when you come to garden hall",                                                           "TENMG");
    AddSetting(false, "TeNmg12",                 new List<string> {"waterworks"},    "Waterworks",                                 "Split when you come to garden waterworks",                                                     "TENMG");
    AddSetting(true,  "TeNmg13",                 new List<string> {"LUWaterworks"},  "(4) Waterworks LU",                          "Split when you acquire the life upgrade in waterworks",                                        "TENMG");
    AddSetting(true,  "TeNmg15",                 new List<string> {"LUGarden"},      "(5) Garden LU",                              "Split when you acquire the life upgrade in garden",                                            "TENMG");
    AddSetting(true,  "TeNmg16",                 new List<string> {"LUCentralHall"}, "(6) Central hall LU",                        "Split when you acquire the life upgrade in central hall",                                      "TENMG");
    AddSetting(false, "TeNmg17",                 new List<string> {"lionSword"},     "Lion sword",                                 "Split on the cutscene where you get the lion sword (central hall)",                            "TENMG");
    AddSetting(true,  "TeNmg18",                 new List<string> {"mechTower"},     "Mechanical tower",                           "Split when you clilmb up into the mechanical tower",                                           "TENMG");
    AddSetting(false, "TeNmg19",                 new List<string> {"mechElevator"},  "Mechanical tower v2 (elevator cutscene)",    "Split on the cutscene where you jump down on the elevator at the start of mech tower",         "TENMG");
    AddSetting(false, "TeNmg_mpPortalEnter",     new List<string> {"mpPortalEnter"}, "Enter Mechanical Pit Portal",                "Split when you enter the portal in Mechanical Pit",                                            "TENMG");
    AddSetting(true,  "TeNmg20",                 new List<string> {"mechPortal"},    "Mechanical Pit Portal",                      "Split when you go through the time portal in mechanical pit",                                  "TENMG");
    AddSetting(false, "TeNmg_mpPortalExit",      new List<string> {"mpPortalExit"},  "Exit Mechanical Pit Portal",                 "Split when you exit the portal in Mechanical Pit",                                             "TENMG");
    AddSetting(true,  "TeNmg21",                 new List<string> {"activationRuin"}, "Activation room in ruin",                    "Split when you come to the mech tower activation room in the present",                         "TENMG");
    AddSetting(false, "TeNmg_arPortalEnter",     new List<string> {"arPortalEnter"}, "Enter Activation room Portal",               "Split when you enter the portal in Activation room",                                           "TENMG");
    AddSetting(false, "TeNmg_arPortalExit",      new List<string> {"arPortalExit"},  "Exit Activation room Portal",                "Split when you exit the portal in Activation room",                                            "TENMG");
    AddSetting(false, "TeNmg22",                 new List<string> {"activationRestore"}, "Activation room restored",                   "Split when you come to the mech tower activation room in the past",                            "TENMG");
    AddSetting(true,  "TeNmg23",                 new List<string> {"LUMechTower"},   "(7) Mechanical tower LU",                    "Split when you acquire the life upgrade in mechanical tower",                                  "TENMG");
    AddSetting(true,  "TeNmg24",                 new List<string> {"sandWraithDeathV1"}, "The death of a sand wraith (central hall)",  "Split in centrall hall next to the fountain after you've activated both towers",               "TENMG");
    AddSetting(false, "TeNmg25",                 new List<string> {"sandWraithDeathV2"}, "The death of a sand wraith v2 (central hall)", "Alternate split deeper into the corridor so you can't hit it early when jumping down",         "TENMG");
    AddSetting(true,  "TeNmg26",                 new List<string> {"kaileenaFirst"}, "Death of the empress",                       "Split when you kill Kaileena in the throne room (34->38)",                                     "TENMG");
    AddSetting(true,  "TeNmg27",                 new List<string> {"exitTomb"},      "Exit the tomb",                              "Split when you leave the tomb",                                                                "TENMG");
    AddSetting(false, "TeNmg_prPortalEnter",     new List<string> {"prPortalEnter"}, "Enter Prison Portal",                        "Split when you enter the portal in Prison",                                                    "TENMG");
    AddSetting(false, "TeNmg_prPortalExit",      new List<string> {"prPortalExit"},  "Exit Prison Portal",                         "Split when you exit the portal in Prison",                                                     "TENMG");
    AddSetting(true,  "TeNmg28",                 new List<string> {"scorpionSword"}, "Scorpion sword",                             "Split when you get the scorpion sword",                                                        "TENMG");
    AddSetting(true,  "TeNmg29",                 new List<string> {"LUPrison"},      "(8) Prison LU",                              "Split when you acquire the life upgrade in prison",                                            "TENMG");
    AddSetting(false, "TeNmg30",                 new List<string> {"libraryV1"},     "Library",                                    "Split on the library opening cutscene",                                                        "TENMG");
    AddSetting(false, "TeNmg31",                 new List<string> {"libraryV2"},     "Library v2",                                 "Split when you move into the library (after the opening cutscene)",                            "TENMG");
    AddSetting(true,  "TeNmg32",                 new List<string> {"LULibrary"},     "(9) Library LU",                             "Split when you acquire the life upgrade in library",                                           "TENMG");
    AddSetting(false, "TeNmg33",                 new List<string> {"hourglassRevisit"}, "Hourglass revisited",                        "Split when you come back to the hourglass chamber after you've killed Kaileena",               "TENMG");
    AddSetting(true,  "TeNmg34",                 new List<string> {"WaterSword"},    "Water sword",                                "Split when you get the water sword",                                                           "TENMG");
    AddSetting(false, "TeNmg_trPortalEnter",     new List<string> {"trPortalEnter"}, "Enter Throne Room Portal",                   "Split when you enter the cutscene after breaking Throne Room wall",                            "TENMG");
    AddSetting(false, "TeNmg_trPortalExit",      new List<string> {"trPortalExit"},  "Exit Throne Room Portal",                    "Split when you exit the portal in Throne Room",                                                "TENMG");
    AddSetting(true,  "TeNmg35",                 new List<string> {"maskOn"},        "The mask of the wraith",                     "Split when you get to the mask",                                                               "TENMG");
    AddSetting(false, "TeNmg_scPortalEnter",     new List<string> {"scPortalEnter"}, "Enter Sacred Caves Portal",                  "Split when you enter the portal in Sacred Caves",                                              "TENMG");
    AddSetting(false, "TeNmg_scPortalExit",      new List<string> {"scPortalExit"},  "Exit Sacred Caves Portal",                   "Split when you exit the portal in Sacred Caves",                                               "TENMG");
    AddSetting(true,  "TeNmg36",                 new List<string> {"griffinV1"},     "Sand griffin",                               "Split when you kill the griffin",                                                              "TENMG");
    AddSetting(false, "TeNmg37",                 new List<string> {"griffinV2"},     "Sand griffin v2",                            "Split when you jump to the platform after you've killed the griffin",                          "TENMG");
    AddSetting(false, "TeNmg_ugPortalEnter",     new List<string> {"ugPortalEnter"}, "Enter Upper Garden Portal",                  "Split when you enter the portal in Upper Garden",                                              "TENMG");
    AddSetting(false, "TeNmg_ugPortalExit",      new List<string> {"ugPortalExit"},  "Exit Upper Garden Portal",                   "Split when you exit the portal in Upper Garden",                                               "TENMG");
    AddSetting(true,  "TeNmg38",                 new List<string> {"mirroredFates"}, "Mirrored fates",                             "Split on the sacrificial altar cutscene (sand wraith pov)",                                    "TENMG");
    AddSetting(true,  "TeNmg39",                 new List<string> {"favorUnknown"},  "A favor unknown",                            "Split on the cutscene where the sand wraith saves the prince (sand wraith pov)",               "TENMG");
    AddSetting(true,  "TeNmg40",                 new List<string> {"libraryRevisit"}, "Library revisited",                          "Split when you enter the library",                                                             "TENMG");
    AddSetting(true,  "TeNmg41",                 new List<string> {"banana"},        "Light sword",                                "Split when you pick up the light sword in mystic caves",                                       "TENMG");
    AddSetting(true,  "TeNmg42",                 new List<string> {"maskOff"},       "The death of a prince",                      "Split on the cutscene where you take the mask off",                                            "TENMG");
    AddSetting(true,  "TeNmg43",                 new List<string> {"Dahaka"},        "Dahaka",                                     "Split when you defeat Dahaka",                                                                 "TENMG");
    // The Two Thrones splits:
    AddSetting(true,  "TheRamparts",             new List<string> {"TheRamparts"},   "The Ramparts",                               "Split after the harbor district save fountain",                                                "pop_t2t.asl");
    AddSetting(true,  "HarborDistrict",          new List<string> {"HarborDistrict"}, "The Harbor District",                        "Split after first palace save fountain",                                                       "pop_t2t.asl");
    AddSetting(true,  "ThePalace",               new List<string> {"ThePalace"},     "The Palace",                                 "Split at the end of throne room",                                                              "pop_t2t.asl");
    AddSetting(false, "TrappedHallway",          new List<string> {"TrappedHallway"}, "The Trapped Hallway",                        "Split at end of trapped hallway at the cutscene",                                              "pop_t2t.asl");
    AddSetting(false, "TheSewers",               new List<string> {"TheSewers"},     "The Sewers",                                 "Split on finishing the sewers dark prince section",                                            "pop_t2t.asl");
    AddSetting(false, "TheSewerz",               new List<string> {"TheSewerz"},     "The Sewers (alternate)",                     "Split just before the tunnels save fountain",                                                  "pop_t2t.asl");
    AddSetting(false, "TheFortress",             new List<string> {"TheFortress"},   "The Fortress",                               "Split just before entering the first Chariot",                                                 "pop_t2t.asl");
    AddSetting(false, "Chariot1",                new List<string> {"Chariot1"},      "Chariot 1",                                  "Split on finishing the first chariot",                                                         "pop_t2t.asl");
    AddSetting(false, "LowerCity",               new List<string> {"LowerCity"},     "The Lower City",                             "Split after the lower city dark prince section",                                               "pop_t2t.asl");
    AddSetting(false, "LowerCityRooftops",       new List<string> {"LowerCityRooftops"}, "The Lower City Rooftops",                    "Split after killing Klompa",                                                                   "pop_t2t.asl");
    AddSetting(false, "ArenaDeload",             new List<string> {"ArenaDeload"},   "Arena Deload",                               "Split at the black crushers in the arena dark prince section",                                 "pop_t2t.asl");
    AddSetting(false, "TheBalconies",            new List<string> {"TheBalconies"},  "The Balconies",                              "Split on exiting the room with the slomo gate",                                                "pop_t2t.asl");
    AddSetting(false, "DarkAlley",               new List<string> {"DarkAlley"},     "The Dark Alley",                             "Split on entering the cutscene at start of temple rooftops",                                   "pop_t2t.asl");
    AddSetting(true,  "TheTempleRooftops",       new List<string> {"TheTempleRooftops"}, "The Temple Rooftops",                        "Split on entering the door into temple",                                                       "pop_t2t.asl");
    AddSetting(false, "TheTemple",               new List<string> {"TheTemple"},     "The Temple",                                 "Split on finishing the temple dark prince section",                                            "pop_t2t.asl");
    AddSetting(true,  "TheMarketplace",          new List<string> {"TheMarketplace"}, "The Marketplace",                            "Split at save fountain before cutscene drop",                                                  "pop_t2t.asl");
    AddSetting(false, "MarketDistrict",          new List<string> {"MarketDistrict"}, "The Market District",                        "Split at the save fountain after the long cutscene",                                           "pop_t2t.asl");
    AddSetting(false, "TheBrothel",              new List<string> {"TheBrothel"},    "The Brothel",                                "Split on finishing the brothel dark prince section",                                           "pop_t2t.asl");
    AddSetting(true,  "ThePlaza",                new List<string> {"ThePlaza"},      "The Plaza",                                  "Split at the door after Mahasti fight",                                                        "pop_t2t.asl");
    AddSetting(false, "TheUpperCity",            new List<string> {"TheUpperCity"},  "The Upper City",                             "Split just before the skippable Farah cutscene",                                               "pop_t2t.asl");
    AddSetting(false, "CityGarderns",            new List<string> {"CityGarderns"},  "The City Garderns",                          "Split just before the Stone Guardian encounter",                                               "pop_t2t.asl");
    AddSetting(false, "ThePromenade",            new List<string> {"ThePromenade"},  "The Promenade",                              "Split on entering the royal workshop",                                                         "pop_t2t.asl");
    AddSetting(true,  "RoyalWorkshop",           new List<string> {"RoyalWorkshop"}, "Royal Workshop",                             "Split on entering the king's road",                                                            "pop_t2t.asl");
    AddSetting(false, "KingsRoad",               new List<string> {"KingsRoad"},     "The King's Road",                            "Split on defeating the twins",                                                                 "pop_t2t.asl");
    AddSetting(false, "KingzRoad",               new List<string> {"KingzRoad"},     "The King's Road (alternate)",                "Split on the transition to palace entrance after twins fight",                                 "pop_t2t.asl");
    AddSetting(false, "PalaceEntrance",          new List<string> {"PalaceEntrance"}, "The Palace Entrance",                        "Split on entering the elevator cutscene",                                                      "pop_t2t.asl");
    AddSetting(false, "HangingGardens",          new List<string> {"HangingGardens"}, "The Hanging Gardens",                        "Split at the swing pole before the last sand gate",                                            "pop_t2t.asl");
    AddSetting(false, "HangingGardenz",          new List<string> {"HangingGardenz"}, "The Hanging Gardens (alternate)",            "Split at the structure's mind save fountain",                                                  "pop_t2t.asl");
    AddSetting(false, "StructuresMind",          new List<string> {"StructuresMind"}, "The Structure's Mind",                       "Split at the cutscene after the puzzle",                                                       "pop_t2t.asl");
    AddSetting(false, "StructurezMind",          new List<string> {"StructurezMind"}, "The Structure's Mind (alternate)",           "Split after the transition to Well of Ancestors",                                              "pop_t2t.asl");
    AddSetting(false, "BottomofWell",            new List<string> {"BottomofWell"},  "Bottom of the Well",                         "Split after the death abuse at the bottom of the well",                                        "pop_t2t.asl");
    AddSetting(false, "WellofAncestors",         new List<string> {"WellofAncestors"}, "The Well of Ancestors",                      "Split on finishing the well dark prince section",                                              "pop_t2t.asl");
    AddSetting(false, "TheLabyrinth",            new List<string> {"TheLabyrinth"},  "The Labyrinth",                              "Split on entering the underground cave after breakable wall",                                  "pop_t2t.asl");
    AddSetting(false, "CaveDeath",               new List<string> {"CaveDeath"},     "Underground Cave Death",                     "Split on the death abuse at the end of underground cave (for zipping categories)",             "pop_t2t.asl");
    AddSetting(false, "UndergroundCave",         new List<string> {"UndergroundCave"}, "The Underground Cave",                       "Split on entering the kitchen",                                                                "pop_t2t.asl");
    AddSetting(false, "LowerTower",              new List<string> {"LowerTower"},    "The Lower Tower",                            "Split on entering the trap corridor after lower tower",                                        "pop_t2t.asl");
    AddSetting(false, "MiddleTower",             new List<string> {"MiddleTower"},   "The Middle Tower",                           "Split on entering the trap corridor after middle tower",                                       "pop_t2t.asl");
    AddSetting(true,  "UpperTower",              new List<string> {"UpperTower"},    "The Upper Tower",                            "Split at the upper tower save fountain",                                                       "pop_t2t.asl");
    AddSetting(true,  "TheTerrace",              new List<string> {"TheTerrace"},    "The Terrace",                                "Split on entering the mental realm",                                                           "pop_t2t.asl");
    AddSetting(true,  "MentalRealm",             new List<string> {"MentalRealm"},   "The Mental Realm",                           "Split on finishing the game",                                                                  "pop_t2t.asl");
    AddSetting(false, "T2TLU1",                  new List<string> {"T2TLU1"},        "Life Upgrade 1",                             "Split after obtaining the first life upgrade in Tunnels",                                      "pop_t2t.asl");
    AddSetting(false, "T2TLU2",                  new List<string> {"T2TLU2"},        "Life Upgrade 2",                             "Split after obtaining the second life upgrade in Lower City Rooftops",                         "pop_t2t.asl");
    AddSetting(false, "T2TLU3",                  new List<string> {"T2TLU3"},        "Life Upgrade 3",                             "Split after obtaining the third life upgrade in Temple",                                       "pop_t2t.asl");
    AddSetting(false, "T2TLU4",                  new List<string> {"T2TLU4"},        "Life Upgrade 4",                             "Split after obtaining the fourth life upgrade in Tunnels",                                     "pop_t2t.asl");
    AddSetting(false, "T2TLU5",                  new List<string> {"T2TLU5"},        "Life Upgrade 5",                             "Split after obtaining the fifth life upgrade in Canal",                                        "pop_t2t.asl");
    AddSetting(false, "T2TLU6",                  new List<string> {"T2TLU6"},        "Life Upgrade 6",                             "Split after obtaining the sixth life upgrade in Middle Tower",                                 "pop_t2t.asl");

    // ================================================== events ==================================================

    Action action;
    Action<float, float, float, float> actionRange;
    Action<float, float, float, float, float, float> actionBounds;
    Action<int[]> actionInts;

    // Start Events (run starts on whichever game is launched first)
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(StartEvent, "Start_SoT",               new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => timer.CurrentPhase == TimerPhase.NotRunning && vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2) && current.startValue == 1 && current.xCam <= -92.8f)) (-103.264f, -103.262f, -4.8f, -4.798f, 1.341f, 1.343f);
    (actionInts=maps                  => AddEvent(StartEvent, "Start_WW",                new List<string> {}, Maps(maps),                () => timer.CurrentPhase == TimerPhase.NotRunning && vars.game == 5 && MapOneOfCurrent(maps) && old.cutscene == 1 && current.cutscene == 2)) (new int[] {1292342859});
    (action=()                        => AddEvent(StartEvent, "Start_T2T",               new List<string> {}, HashNull(),                () => timer.CurrentPhase == TimerPhase.NotRunning && vars.game == 6 && InXBoundsCurrent(-404.9f, -404.8f) && current.xCam <= 0.832f && current.xCam >= 0.8318f && current.yCam <= 0.1082f && current.yCam >= 0.1080f)) ();

    // Game Setup Splits (splits at the start of each subsequent game)
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "setupSplits_SoT",         new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => { if (vars.game == 4 && vars.noGameRunning && !CompletedGames.Contains(4) && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2) && current.startValue == 1 && current.xCam <= -92.8f) { vars.noGameRunning = false; return true; } return false; })) (-103.264f, -103.262f, -4.8f, -4.798f, 1.341f, 1.343f);
    (actionInts=maps                  => AddEvent(SplitEvent, "setupSplits_WW",          new List<string> {}, Maps(maps),                () => { if (vars.game == 5 && vars.noGameRunning && !CompletedGames.Contains(5) && MapOneOfCurrent(maps) && old.cutscene == 1 && current.cutscene == 2) { vars.noGameRunning = false; return true; } return false; })) (new int[] {1292342859});
    (action=()                        => AddEvent(SplitEvent, "setupSplits_T2T",         new List<string> {}, HashNull(),                () => { if (vars.game == 6 && vars.noGameRunning && !CompletedGames.Contains(6) && InXBoundsCurrent(-404.9f, -404.8f) && current.xCam <= 0.832f && current.xCam >= 0.8318f && current.yCam <= 0.1082f && current.yCam >= 0.1080f) { vars.noGameRunning = false; return true; } return false; })) ();

    // SoT Misc Events
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(MiscEvent,  "AboveCredits",            new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (658.26f, 661.46f, 210.92f, 213.72f, 12.5f, 30f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(MiscEvent,  "SoTLU_Reset",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => { if (vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2)) { CompletedEvents.Remove("SoTLU"); return true; } return false; })) (-477.88f, -477f, -298f, -297.1f, -0.5f, -0.4f);

    // ================================================== Sands of Time Events ==================================================
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "GasStation",              new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (252f, 258f, 130.647f, 134f, 22.999f, 23.001f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "SandsUnleashed",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-6.177f, -6.175f, 62.905f, 62.907f, 7.604f, 7.606f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "FirstGuestRoom",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (30.297f, 30.299f, 42.126f, 42.128f, 12.998f, 13f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "SultanChamberZipless",    new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (98.445f, 98.447f, 39.567f, 39.57f, -8.96f, -8.958f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "SultanChamber",           new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (134.137f, 134.139f, 54.990f, 54.992f, -32.791f, -32.789f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "PalaceDefence",           new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (4.547f, 8.851f, 40.494f, 47.519f, -39.001f, -38.999f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "DadStart",                new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (6.714f, 6.716f, 57.698f, 57.7f, 21.005f, 21.007f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "DadDead",                 new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-6.001f, -5.999f, -18.6f, -18.4f, 1.998f, 2.001f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheWarehouse",            new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-73.352f, -71.233f, -28.5f, -26.868f, -1.001f, -0.818f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheZoo",                  new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-141.299f, -139.797f, -47.21f, -42.801f, -31.1f, -30.9f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "BirdCage",                new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-211f, -208f, -23f, -21f, -9f, -8.8f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "CliffWaterfalls",         new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-233.6f, -231.4f, 33.7f, 35f, -42.6f, -42.4f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheBathsZipless",         new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-215.85f, -214.089f, 54.261f, 58.699f, -43.501f, -43.499f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheBaths",                new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-211.427f, -211.425f, 56.602f, 56.604f, -43.501f, -43.499f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "SecondSword",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-106.819f, -106.817f, 81.097f, 81.099f, -27.269f, -27.267f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheDaybreak",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-76f, -70f, 192.4f, 197.6f, -56.6f, -54f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheMesshall",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-183.267f, -183.265f, 234.685f, 234.687f, -37.528f, -37.526f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "DrawbridgeTower",         new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-267f, -262f, 232f, 267f, -35.6f, -35.5f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "BrokenBridge",            new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-265f, -257f, 159f, 167f, -13.6f, -13.4f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheCavesZipless",         new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-303f, -297.5f, 112f, 113.5f, -56.1f, -55.9f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheCaves",                new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-246.839f, -241.677f, 78.019f, 87.936f, -71.731f, -70.7f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheWaterfall",            new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-242f, -240.5f, 79.5f, 83f, -121f, -118f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheUGReservoirZipless",   new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-121f, -110f, -9f, -7f, -154.1f, -153.9f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheUGReservoir",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-51.477f, -48.475f, 72.155f, 73.657f, -24.802f, -24.799f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "HallofLearning",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (73f, 79f, 161f, 163f, -24.1f, -23.9f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheObservatory",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (139.231f, 139.233f, 162.556f, 162.558f, -29.502f, -29.5f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "ObservatoryExit",         new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (137f, 141f, 164f, 164.67f, -29.5f, -29.2f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "HoLCourtyardsExit",       new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (72f, 77f, 90f, 95.7f, -27.1f, -26.9f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheAzadPrison",           new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (190f, 195f, -21f, -19f, -17.6f, -17.3f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TortureChamberZipless",   new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (187.5f, 192.5f, -39f, -37.5f, -119.1f, -118.9f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TortureChamber",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (189.999f, 190.001f, -43.278f, -43.276f, -119.001f, -118.999f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheElevator",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (74f, 75f, -46.751f, -43.252f, -34f, -33f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheDreamZipless",         new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (99f, 101f, -11f, -10f, -56f, -54f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheDream",                new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (95.8f, 96f, -25.1f, -24.9f, -74.9f, -74.7f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheTomb",                 new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (100.643f, 100.645f, -11.543f, -11.541f, -67.588f, -67.586f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TowerofDawn",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (35.5f, 35.7f, -50f, -39f, -32f, -30f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "SettingSun",              new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (60f, 61f, -58f, -57f, 30f, 32f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "HonorGlory",              new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (81f, 82f, -60.3f, -59.7f, 89f, 90f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "GrandRewind",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (660.376f, 660.378f, 190.980f, 190.983f, 0.432f, 0.434f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "SoTLU",                   new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => { if (vars.game == 4 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2)) { CompletedEvents.Remove("SoTLU_Reset"); return true; } return false; })) (-492.608f, -492.606f, -248.833f, -248.831f, 0.219f, 0.221f);
    (action=()                        => AddEvent(SplitEvent, "SoTEnd",                  new List<string> {}, HashNull(),                () => { if (vars.game == 4 && ((InPosWithBoundsCurrent(658.26f, 661.46f, 210.92f, 213.72f, 9.8f, 12.5f) && CompletedEvents.Contains("AboveCredits")) || current.vizierHealth == 4)) { CompletedGames.Add(4); vars.noGameRunning = true; return true; } return false; })) ();

    // ================================================== Warrior Within Events ==================================================
    // Spatial XYZ splits (bounds-based O(1) hash lookup)
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "spPortalEnter",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 5 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (95.5f, 97.5f, -107f, -106f, 413.8f, 414.2f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "spPortalExit",           new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 5 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (95.5f, 97.5f, -107f, -106f, 113.8f, 114.2f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "mpPortalEnter",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 5 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-211f, -209f, 139f, 141f, 440.8f, 441.2f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "mpPortalExit",           new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 5 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-211f, -209f, 139f, 141f, 140.8f, 141.2f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "arPortalEnter",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 5 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-172f, -170f, 188f, 189f, 181.8f, 182.2f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "arPortalExit",           new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 5 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-172f, -170f, 188f, 189f, 481.8f, 482.2f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "prPortalEnter",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 5 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-71f, -69f, -117f, -115f, 19.8f, 20.2f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "prPortalExit",           new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 5 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-71f, -69f, -117f, -115f, 319.8f, 320.2f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "trPortalExit",           new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 5 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-53.5f, -51.5f, 113f, 114f, 117.8f, 118.2f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "scPortalEnter",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 5 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-72f, -70f, 273f, 274f, 132.8f, 133.2f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "scPortalExit",           new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 5 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-72f, -70f, 273f, 274f, 432.8f, 433.2f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "ugPortalEnter",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 5 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (78f, 80f, 107f, 108f, 412.3f, 412.7f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "ugPortalExit",           new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 5 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (78f, 80f, 107f, 108f, 112.3f, 112.7f);

    // Boss splits
    (actionInts=maps                  => AddEvent(SplitEvent, "boat",                   new List<string> {}, Maps(maps),                () => vars.game == 5 && BossDieWW(maps[0]))) (new int[] {67109218});
    (actionInts=maps                  => AddEvent(SplitEvent, "shahdee",                new List<string> {}, Maps(maps),                () => vars.game == 5 && BossDieWW(maps[0]))) (new int[] {285225347});
    (actionInts=maps                  => AddEvent(SplitEvent, "griffinV1",              new List<string> {}, Maps(maps),                () => vars.game == 5 && BossDieWW(maps[0]))) (new int[] {285231574});
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "kaileena",               new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => { if (vars.game == 5 && (InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2) || CutsceneHitWW(285233519))) { CompletedGames.Add(5); vars.noGameRunning = true; return true; } return false; })) (-69.5f, -65.5f, 290f, 292f, 432.8f, 433.2f);
    (actionInts=maps                  => AddEvent(SplitEvent, "Dahaka",                 new List<string> {}, Maps(maps),                () => { if (vars.game == 5 && CutsceneHitWW(maps[0])) { CompletedGames.Add(5); vars.noGameRunning = true; return true; } return false; })) (new int[] {285231792});

    // StoryGate splits
    (action=()                        => AddEvent(SplitEvent, "rng59",                  new List<string> {}, HashNull(),                () => vars.game == 5 && StoryGateAdvWW(59))) ();
    (action=()                        => AddEvent(SplitEvent, "rng63",                  new List<string> {}, HashNull(),                () => vars.game == 5 && StoryGateAdvWW(63))) ();
    (action=()                        => AddEvent(SplitEvent, "kaileenaFirst",          new List<string> {}, HashNull(),                () => vars.game == 5 && StoryGateAdvWW(38))) ();

    // Weapon & drinking splits
    (actionInts=maps                  => AddEvent(SplitEvent, "banana",                 new List<string> {}, Maps(maps),                () => vars.game == 5 && MapOneOfCurrent(maps) && old.secondaryWeapon != 50 && current.secondaryWeapon == 50)) (new int[] {587202754, 587203393});
    (action=()                        => AddEvent(SplitEvent, "foundryFountain",        new List<string> {}, HashNull(),                () => vars.game == 5 && (current.storyValue == 58 || current.storyValue == 59) && old.state != 11 && current.state == 11)) ();

    // Map transition splits
    (actionInts=maps                  => AddEvent(SplitEvent, "hourglassRevisit",       new List<string> {}, Maps(maps),                () => vars.game == 5 && MapChangeWW(1006704427, maps[0]) && current.storyValue == 45)) (new int[] {1006704429});
    (actionInts=maps                  => AddEvent(SplitEvent, "trPortalEnter",          new List<string> {}, Maps(maps),                () => vars.game == 5 && MapChangeWW(1006704431, maps[0]) && current.storyValue == 45)) (new int[] {-1509855113});

    // Cutscene splits (single map)
    (actionInts=maps                  => AddEvent(SplitEvent, "ravenMan",               new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]))) (new int[] {135462572});
    (actionInts=maps                  => AddEvent(SplitEvent, "firstPortal",            new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]) && current.storyValue == 2)) (new int[] {285231807});
    (actionInts=maps                  => AddEvent(SplitEvent, "LUFortress",             new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]))) (new int[] {135501679});
    (actionInts=maps                  => AddEvent(SplitEvent, "LUMechTower",            new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]))) (new int[] {67145445});
    (actionInts=maps                  => AddEvent(SplitEvent, "LUCentralHall",          new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]))) (new int[] {67144144});
    (actionInts=maps                  => AddEvent(SplitEvent, "spiderSword",            new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]))) (new int[] {135462576});
    (actionInts=maps                  => AddEvent(SplitEvent, "chasingShahdee",         new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]))) (new int[] {989860400});
    (actionInts=maps                  => AddEvent(SplitEvent, "princeStare",            new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]))) (new int[] {989884886});
    (actionInts=maps                  => AddEvent(SplitEvent, "serpentSword",           new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]) && current.storyValue == 13)) (new int[] {1006704429});
    (actionInts=maps                  => AddEvent(SplitEvent, "waterworks",             new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]))) (new int[] {687877048});
    (actionInts=maps                  => AddEvent(SplitEvent, "lionSword",              new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]) && current.storyValue == 21)) (new int[] {67112526});
    (actionInts=maps                  => AddEvent(SplitEvent, "mechElevator",           new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]))) (new int[] {687876652});
    (actionInts=maps                  => AddEvent(SplitEvent, "mechPortal",             new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]))) (new int[] {285235081});
    (actionInts=maps                  => AddEvent(SplitEvent, "activationRuin",         new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]))) (new int[] {687876878});
    (actionInts=maps                  => AddEvent(SplitEvent, "activationRestore",      new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]))) (new int[] {687876865});
    (actionInts=maps                  => AddEvent(SplitEvent, "exitTomb",               new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]))) (new int[] {989863897});
    (actionInts=maps                  => AddEvent(SplitEvent, "mirroredFates",          new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]))) (new int[] {285227786});
    (actionInts=maps                  => AddEvent(SplitEvent, "favorUnknown",           new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]))) (new int[] {285227788});
    (actionInts=maps                  => AddEvent(SplitEvent, "maskOn",                 new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]))) (new int[] {285234565});
    (actionInts=maps                  => AddEvent(SplitEvent, "lastPortal",             new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]))) (new int[] {285233519});
    (actionInts=maps                  => AddEvent(SplitEvent, "maskOff",                new List<string> {}, Maps(maps),                () => vars.game == 5 && CutsceneHitWW(maps[0]) && current.storyValue == 64)) (new int[] {67112526});

    // Cutscene splits (multi map or position guarded)
    (actionInts=maps                  => AddEvent(SplitEvent, "LUGarden",               new List<string> {}, Maps(maps),                () => vars.game == 5 && MapOneOfCurrent(maps) && old.cutscene == 0 && current.cutscene == 1)) (new int[] {687877048, 687877050});
    (actionInts=maps                  => AddEvent(SplitEvent, "LULibrary",              new List<string> {}, Maps(maps),                () => vars.game == 5 && MapOneOfCurrent(maps) && old.cutscene == 0 && current.cutscene == 1)) (new int[] {67116816, 67116818});
    (actionInts=maps                  => AddEvent(SplitEvent, "LUShahdee",              new List<string> {}, Maps(maps),                () => vars.game == 5 && MapOneOfCurrent(maps) && old.cutscene == 0 && current.cutscene == 1)) (new int[] {285225347, 1006717295});
    (actionInts=maps                  => AddEvent(SplitEvent, "LU019",                  new List<string> {}, Maps(maps),                () => vars.game == 5 && MapOneOfCurrent(maps) && old.cutscene == 0 && current.cutscene == 1)) (new int[] {989860398, 1006711848});
    (actionInts=maps                  => AddEvent(SplitEvent, "gardenHall",             new List<string> {}, Maps(maps),                () => vars.game == 5 && MapOneOfCurrent(maps) && old.cutscene == 0 && current.cutscene == 1)) (new int[] {135495097, 135495099});
    (actionInts=maps                  => AddEvent(SplitEvent, "libraryV1",              new List<string> {}, Maps(maps),                () => vars.game == 5 && MapOneOfCurrent(maps) && old.cutscene == 0 && current.cutscene == 1)) (new int[] {67116816, 67116821});
    (actionInts=maps                  => AddEvent(SplitEvent, "LUWaterworks",           new List<string> {}, Maps(maps),                () => vars.game == 5 && MapOneOfCurrent(maps) && old.cutscene == 0 && current.cutscene == 1 && current.xPos > 70)) (new int[] {687877046, 687877489});
    (actionInts=maps                  => AddEvent(SplitEvent, "WaterSword",             new List<string> {}, Maps(maps),                () => vars.game == 5 && MapOneOfCurrent(maps) && old.cutscene == 0 && current.cutscene == 1 && old.xPos > -98)) (new int[] {1006704427, 1006704429});
    (actionInts=maps                  => AddEvent(SplitEvent, "LUPrison",               new List<string> {}, Maps(maps),                () => vars.game == 5 && MapOneOfCurrent(maps) && old.cutscene == 0 && current.cutscene == 1 && current.xPos > -120)) (new int[] {135483948, 135516393, 16809649});
    (actionInts=maps                  => AddEvent(SplitEvent, "scorpionSword",          new List<string> {}, Maps(maps),                () => vars.game == 5 && MapOneOfCurrent(maps) && old.cutscene == 0 && current.cutscene == 1 && current.xPos < -164)) (new int[] {135483948, 135483950, 135505359, 135516393, 16809649});

    // Other coordinate / map checks
    (actionInts=maps                  => AddEvent(SplitEvent, "mechTower",              new List<string> {}, Maps(maps),                () => vars.game == 5 && MapOneOfCurrent(maps) && old.zPos < 410 && current.zPos >= 410)) (new int[] {687876481});
    (actionInts=maps                  => AddEvent(SplitEvent, "sandWraithDeathV1",      new List<string> {}, Maps(maps),                () => vars.game == 5 && MapOneOfCurrent(maps) && old.yPos < -13 && current.yPos >= -13 && current.zPos < 391 && current.storyValue == 33)) (new int[] {67112526});
    (actionInts=maps                  => AddEvent(SplitEvent, "sandWraithDeathV2",      new List<string> {}, Maps(maps),                () => vars.game == 5 && MapOneOfCurrent(maps) && old.yPos < -7 && current.yPos >= -9 && current.storyValue == 33)) (new int[] {67112526});
    (actionInts=maps                  => AddEvent(SplitEvent, "libraryV2",              new List<string> {}, Maps(maps),                () => vars.game == 5 && MapOneOfCurrent(maps) && old.xPos < -112 && current.xPos >= -112 && current.storyValue == 42)) (new int[] {67116821});
    (actionInts=maps                  => AddEvent(SplitEvent, "griffinV2",              new List<string> {}, Maps(maps),                () => vars.game == 5 && MapOneOfCurrent(maps) && old.yPos > 166.5 && current.yPos <= 166.5)) (new int[] {285231574});
    (actionInts=maps                  => AddEvent(SplitEvent, "libraryRevisit",         new List<string> {}, Maps(maps),                () => vars.game == 5 && MapOneOfCurrent(maps) && old.xPos < -112 && current.xPos >= -112 && current.storyValue == 60)) (new int[] {67116821});

    // ================================================== The Two Thrones Events ==================================================
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheRamparts",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-271f, -265f, 187f, 188f, 74f, 75f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "HarborDistrict",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-93f, -88f, 236.2f, 238f, 83f, 88f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "ThePalace",               new List<string> {}, BoundsRange(x,y,z,range),    () => vars.game == 6 && CutsceneHitT2T(x, y, z, range))) (-35f, 232f, 147f, 10f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "TrappedHallway",          new List<string> {}, BoundsRange(x,y,z,range),    () => vars.game == 6 && CutsceneHitT2T(x, y, z, range))) (-52f, 134f, 76f, 10f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheSewerz",              new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-100f, -96f, -83f, -79f, 19.9f, 20f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "TheSewers",               new List<string> {}, BoundsRange(x,y,z,range),    () => vars.game == 6 && CutsceneHitT2T(x, y, z, range))) (-89f, -15f, 5f, 10f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "TheFortress",             new List<string> {}, BoundsRange(x,y,z,range),    () => vars.game == 6 && CutsceneHitT2T(x, y, z, range))) (-71f, 10f, 44f, 10f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "Chariot1",               new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-443.37f, -443.36f, 355.80f, 355.81f, 57.71f, 57.72f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "LowerCity",               new List<string> {}, BoundsRange(x,y,z,range),    () => vars.game == 6 && CutsceneHitT2T(x, y, z, range))) (-318f, 330f, 96f, 10f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "LowerCityRooftops",       new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-261.5f, -261f, 318f, 319.5f, 46f, 48f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "ArenaDeload",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-256.1f, -251.9f, 358f, 361.5f, 53.9f, 63.3f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheBalconies",            new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-194f, -190f, 328f, 329.7f, 32.6f, 33.6f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "DarkAlley",               new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-114f, -110f, 328f, 338f, 55f, 59f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheTempleRooftops",       new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-122.6f, -117.7f, 421.6f, 423f, 107f, 108.1f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheTemple",               new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-213f, -210f, 419.0f, 421f, 80.5f, 82.5f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheMarketplace",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-213f, -207f, 484f, 490f, 101f, 103f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "MarketDistrict",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-185.5f, -175.5f, 524f, 530f, 90f, 92f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheBrothel",              new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-152.3f, -152.0f, 549.8f, 549.9f, 91.8f, 92f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "ThePlaza",                new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-104f, -100f, 548f, 553f, 105.5f, 106.1f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheUpperCity",            new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-124.5f, -122.5f, 500f, 505f, 97f, 99f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "CityGarderns",            new List<string> {}, BoundsRange(x,y,z,range),    () => vars.game == 6 && CutsceneHitT2T(x, y, z, range))) (-63f, 390f, 85f, 10f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "ThePromenade",            new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-3f, -1f, 515f, 519f, 72f, 75f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "RoyalWorkshop",           new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (58f, 62f, 470f, 480f, 79f, 81f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "KingsRoad",               new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (91.9289f, 91.9290f, 230.0479f, 230.0480f, 70.9877f, 70.9879f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "KingzRoad",               new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (53f, 70f, 240f, 250f, 70f, 73f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "PalaceEntrance",          new List<string> {}, BoundsRange(x,y,z,range),    () => vars.game == 6 && CutsceneHitT2T(x, y, z, range))) (31f, 271f, 126f, 10f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "HangingGardens",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (26f, 28f, 211f, 213f, 191f, 193f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "HangingGardenz",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (5.2f, 5.4f, 213.5f, 215.6f, 194.9f, 196.2f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "StructuresMind",          new List<string> {}, BoundsRange(x,y,z,range),    () => vars.game == 6 && CutsceneHitT2T(x, y, z, range))) (-30f, 245f, 179f, 10f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "StructurezMind",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (5f, 12f, 243f, 265f, 104f, 104.1f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "BottomofWell",            new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-21.35f, -21.34f, 252.67f, 252.68f, 20.95f, 20.96f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "WellofAncestors",         new List<string> {}, BoundsRange(x,y,z,range),    () => vars.game == 6 && CutsceneHitT2T(x, y, z, range))) (-13f, 241f, 1f, 10f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "CaveDeath",               new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (5.99f, 6.00f, 306.96f, 306.97f, 42f, 42.01f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheLabyrinth",            new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-25.5f, -23f, 325f, 338f, 35.9f, 37.5f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "UndergroundCave",         new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-11f, -9f, 327f, 334f, 73f, 74f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "LowerTower",              new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-5f, -3f, 316f, 317.5f, 139.9f, 140.1f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "MiddleTower",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-18f, -12f, 303f, 305f, 184.8f, 185.1f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "UpperTower",              new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-8f, -7f, 296f, 298f, 226.9f, 227f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheTerrace",              new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-7.2f, -6.9f, 245.6f, 245.9f, 677f, 679f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "MentalRealm",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => { if (vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2) && current.princeAction == 17) { CompletedGames.Add(6); vars.noGameRunning = true; return true; } return false; })) (189f, 194f, 318f, 330f, 540f, 560f);

    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "T2TLU1",                  new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-14.9972f, -14.9970f, -112.8152f, -112.8150f, 20.0732f, 20.0734f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "T2TLU2",                  new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-302.0919f, -302.0917f, 370.8710f, 370.8712f, 52.858f, 52.8582f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "T2TLU3",                  new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-187.3369f, -187.3367f, -455.9863f, 455.9865f, 78.0330f, 78.0332f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "T2TLU4",                  new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-55.0147f, -55.0145f, 395.7608f, 395.761f, 72.0774f, 72.0776f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "T2TLU5",                  new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-30.1223f, -30.1221f, 281.8893f, 281.8895f, 104.0796f, 104.0798f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "T2TLU6",                  new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => vars.game == 6 && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-23.9663f, -23.9661f, 253.9438f, 253.944f, 183.0634f, 183.0636f);

    // ====================================================================================================================
    // ================================================== STARTUP SCRIPT ==================================================
    // ====================================================================================================================

    // ================================================== apply configured setting-event links ==================================================

    foreach (var setting in mySettings.Values)
    {
        foreach (string eventSlug in setting.Item3)
        {
            Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>> myEvent;
            if (!events.TryGetValue(eventSlug, out myEvent))
                throw new Exception("Internal exception (ASL): cannot write event " + eventSlug + " to setting " + setting.Item2 + " because this event doesn't exist");
            myEvent.Item3.Add(setting.Item2);
        }
    }

    var slugsTemp = new HashSet<string>(); // GC

    // add each event that references a setting to that setting's events list,
    // or throw an exception if an event points to a setting that doesn't exist
    // and remove duplicate settings from each event's settings list
    foreach (var @event in events.Values)
    {
        foreach (string settingSlug in @event.Item3)
        {
            Tuple<bool, string, List<string>, string, string, string> setting;
            if (!mySettings.TryGetValue(settingSlug, out setting))
                throw new Exception("Internal exception (ASL): cannot write setting " + settingSlug + " to event " + @event.Item2 + " because this setting doesn't exist");
            setting.Item3.Add(@event.Item2);
            slugsTemp.Add(settingSlug);
        }
        @event.Item3.Clear();
        @event.Item3.AddRange(slugsTemp);
        @event.Item3.TrimExcess();
        slugsTemp.Clear();
    }

    // remove duplicate events from each setting's events list
    foreach (var setting in mySettings.Values)
    {
        foreach (string eventSlug in setting.Item3)
            slugsTemp.Add(eventSlug);
        setting.Item3.Clear();
        setting.Item3.AddRange(slugsTemp);
        setting.Item3.TrimExcess();
        slugsTemp.Clear();
    }

    // ================================================== apply configured events ==================================================

    // fill XyzEventHashMap, MapEventHashMap, and OtherEvents
    foreach (var @event in events.Values)
    {
        if (@event.Item4.Item1 == null && @event.Item4.Item2 == null)
        {
            OtherEvents.Add(@event);
            continue;
        }
        int[] maps = @event.Item4.Item2 ?? Array.Empty<int>();
        int[] hashCodesMaps = maps;
        foreach (int hashCode in hashCodesMaps)
        {
            List<Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>> localEvents;
            if (MapEventHashMap.TryGetValue(hashCode, out localEvents))
            {
                localEvents.Add(@event);
                continue;
            }
            MapEventHashMap.Add(hashCode, new List<Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>> {@event});
        }
        if (@event.Item4.Item2 != null)
            continue;
        ValueTuple<float, float, float, float, float, float> xyzBounds = @event.Item4.Item1.Value;
        int[] hashCodes = GetHashCodesForBounds(xyzBounds.Item1, xyzBounds.Item2, xyzBounds.Item3, xyzBounds.Item4, xyzBounds.Item5, xyzBounds.Item6);
        foreach (int hashCode in hashCodes)
        {
            List<Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>> localEvents;
            if (XyzEventHashMap.TryGetValue(hashCode, out localEvents))
            {
                localEvents.Add(@event);
                continue;
            }
            XyzEventHashMap.Add(hashCode, new List<Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>> {@event});
        }
    }

    foreach (var bucket in XyzEventHashMap.Values.Concat(MapEventHashMap.Values))
        bucket.TrimExcess();

    // allocate a large enough capacity at startup so that the CompletedEvents hashset does not need to be reallocated as it grows during runtime
    CompletedEvents = new HashSet<string>(events.Count);

    // ================================================== debug ==================================================

    var infoBuilder = new StringBuilder(); // GC
    var settingsWithNoEvents = new List<string>(); // GC
    var eventsWithNoSettings = new List<string>(); // GC

    infoBuilder.Append("\r\n");

    // settings and events

    infoBuilder.Append("Settings detected:\r\n");
    infoBuilder.Append("\t" + "{Default} {Setting}".PadRight(36) + " : " + "{Parent}".PadRight(30) + " => {Count:[..Events]}\r\n");
    foreach (var setting in mySettings.Values)
    {
        if (setting.Item3.Count == 0 && setting.Item6 != null)
            settingsWithNoEvents.Add(setting.Item2);
        infoBuilder.Append("\t" + setting.Item1.ToString().PadRight(5) + " " + setting.Item2.PadRight(30) + " : " + (setting.Item6 ?? "{null}").PadRight(30)
            + " => " + setting.Item3.Count + ":[" + string.Join(", ", setting.Item3) + "]\r\n");
    }
    infoBuilder.Append("Total settings: " + mySettings.Count.ToString() + "\r\n\r\n");

    infoBuilder.Append("Events detected:\r\n");
    infoBuilder.Append("\t" + "{EventType}     {Event}".PadRight(46) + " {HasXyzBounds} {HasMaps} => {Count:[..Settings]}\r\n");
    foreach (var @event in events.Values)
    {
        if (@event.Item3.Count == 0)
            eventsWithNoSettings.Add(@event.Item2);
        infoBuilder.Append("\t" + GetEventString(@event.Item1).PadRight(15) + " " + @event.Item2.PadRight(30) + " " + (@event.Item4.Item1 != null).ToString().PadRight(14) + " " + (@event.Item4.Item2 != null).ToString().PadRight(9)
            + " => " + @event.Item3.Count + ":[" + string.Join(", ", @event.Item3) + "]\r\n");
    }
    infoBuilder.Append("Total events: " + events.Count.ToString() + "\r\n\r\n");

    infoBuilder.Append("Settings with no events: (total=" + settingsWithNoEvents.Count.ToString() + ")\r\n");
    foreach (string settingSlug in settingsWithNoEvents)
        infoBuilder.Append("\t" + settingSlug + "\r\n");
    infoBuilder.Append("\r\n");

    infoBuilder.Append("Events with no settings: (total=" + eventsWithNoSettings.Count.ToString() + ")\r\n");
    foreach (string eventSlug in eventsWithNoSettings)
        infoBuilder.Append("\t" + eventSlug + "\r\n");
    infoBuilder.Append("\r\n");

    // buckets

    infoBuilder.Append("Bucket size: " + BucketSize.ToString() + "\r\n\r\n");

    int xyzEventHashMapCapacity;
    int mapEventHashMapCapacity;
    {
        FieldInfo entriesField =
            typeof(Dictionary<int, List<Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>>>)
            .GetField("entries", BindingFlags.NonPublic | BindingFlags.Instance);
        Array xyzBackingArray = (Array)entriesField.GetValue(XyzEventHashMap);
        Array mapBackingArray = (Array)entriesField.GetValue(MapEventHashMap);
        xyzEventHashMapCapacity = xyzBackingArray != null ? xyzBackingArray.Length : 0;
        mapEventHashMapCapacity = mapBackingArray != null ? mapBackingArray.Length : 0;
    }
    infoBuilder.Append("XyzEventHashMap capacity: " + XyzEventHashMap.Count.ToString() + "/" + xyzEventHashMapCapacity + "\r\n");
    infoBuilder.Append("MapEventHashMap capacity: " + MapEventHashMap.Count.ToString() + "/" + mapEventHashMapCapacity + "\r\n");
    infoBuilder.Append("OtherEvents capacity: " + OtherEvents.Count.ToString() + "/" + OtherEvents.Capacity.ToString() + "\r\n");
    infoBuilder.Append("\r\n");

    Action<Dictionary<int, List<Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>>>> PrintBucketInfo = eventHashMap =>
    {
        int collisionSum = 0;
        int maxEventsPerBucket = 0;
        double avgEventsPerBucket;
        var bucketGroupsPerEventCount = new List<List<List<Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>>>>();
        var bucketCountsPerEventCount = new List<int>();
        const int MinEventCountPerBucketToCompute = 2;
        foreach (var bucket in eventHashMap.Values)
        {
            collisionSum += bucket.Count;
            if (bucket.Count >= maxEventsPerBucket)
                maxEventsPerBucket = bucket.Count;
            for (int i = bucketGroupsPerEventCount.Count; i <= bucket.Count; i++)
            {
                bucketGroupsPerEventCount.Add(new List<List<Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>>>());
                bucketCountsPerEventCount.Add(0);
            }
            if (bucket.Count >= MinEventCountPerBucketToCompute)
                bucketGroupsPerEventCount[bucket.Count].Add(bucket);
            bucketCountsPerEventCount[bucket.Count]++;
        }
        avgEventsPerBucket = eventHashMap.Count > 0 ? (double)collisionSum / (double)eventHashMap.Count : 0.0;

        infoBuilder.Append("Average events per bucket: " + avgEventsPerBucket.ToString() + "\r\n");
        infoBuilder.Append("Maximum events per bucket: " + maxEventsPerBucket.ToString() + "\r\n");
        infoBuilder.Append("\r\n");

        for (int i = bucketGroupsPerEventCount.Count - 1; i >= 1; i--)
        {
            bool omit = i < MinEventCountPerBucketToCompute;
            infoBuilder.Append("Buckets with " + i + " events (total=" + bucketCountsPerEventCount[i] + "):" + (omit ? " (omitted)\r\n" : string.Empty) + "\r\n");
            if (omit)
                continue;
            foreach (var bucket in bucketGroupsPerEventCount[i])
                infoBuilder.Append("\t[" + string.Join(", ", bucket.Select(@event => @event.Item2)) + "]\r\n");
            infoBuilder.Append("\r\n");
        }
    };

    infoBuilder.Append("Xyz info:\r\n\r\n");
    PrintBucketInfo(XyzEventHashMap);
    
    infoBuilder.Append("Map info:\r\n\r\n");
    PrintBucketInfo(MapEventHashMap);

    infoBuilder.Append("Non-location-based events: (total=" + OtherEvents.Count + ")\r\n");
    foreach (var @event in OtherEvents)
        infoBuilder.Append("\t" + @event.Item2 + "\r\n");
    infoBuilder.Append("\r\n");

    print(infoBuilder.ToString());

    // ================================================== timing method prompt ==================================================

    if (timer.CurrentTimingMethod != TimingMethod.GameTime)
    {
        DialogResult mbox = MessageBox.Show(timer.Form,
        "Removing setup time between games requires switching to Game Time.\nWould you like to do so?",
        "LiveSplit | Multi-Prince of Persia-Runs",
        MessageBoxButtons.YesNo);

        if (mbox == DialogResult.Yes)
            timer.CurrentTimingMethod = TimingMethod.GameTime;
    }

    // ================================================== cleanup ==================================================

    // de-reference unneeded collections to allow for garbage collection
    mySettings = null;
    events = null;
    slugsTemp = null;
    infoBuilder = null;
    settingsWithNoEvents = null;
    eventsWithNoSettings = null;

    // =====================================================================================================================
    // ================================================== RUNTIME ACTIONS ==================================================
    // =====================================================================================================================

    // ================================================== init ==================================================

    Action<ExpandoObject, ExpandoObject, object> Init = (newOld, newCurrent, newSettings) =>
    {
        old = newOld;
        current = newCurrent;
        settings = newSettings;
        initCustomVariables = true;
    };
    vars.Init = Init;

    // ================================================== onReset ==================================================

    Action OnReset = () =>
    {
        CompletedEvents.Clear();
        initCustomVariables = true;
        vars.IGTValue = 0L;
        CompletedGames.Clear();
        vars.noGameRunning = false;
        print("CompletedEvents cleared.");
    };
    vars.OnReset = OnReset;

    // ================================================== update ==================================================

    var EmptyEventList = new List<Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>>();
    Func<ExpandoObject, bool> Update = newOld =>
    {
        old = newOld;

        if (initCustomVariables)
        {
            switch (game.ProcessName.ToLower())
            {
                case "pop":  vars.game = 4; break;
                case "pop2": vars.game = 5; break;
                case "pop3": vars.game = 6; break;
                default:     vars.game = 0; break;
            }
        }

        if (vars.game == 5)
        {
            if (initCustomVariables || old.storyValue != current.storyValue)
                SetCustomVariable("storyGate", current.storyValue.ToString());
        }

        initCustomVariables = false;

        TriggeredEvent = null;
        int xyzHashCode = GetXyzHashCodeCurrent();
        List<Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>> localXyzEvents;
        List<Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>> localMapEvents = null;
        XyzEventHashMap.TryGetValue(xyzHashCode, out localXyzEvents);
        if (vars.game == 5 && MapEventHashMap.Count > 0)
        {
            int mapHashCode = current.map;
            MapEventHashMap.TryGetValue(mapHashCode, out localMapEvents);
        }
        localXyzEvents = localXyzEvents ?? EmptyEventList;
        localMapEvents = localMapEvents ?? EmptyEventList;

        foreach (var @event in localXyzEvents.Concat(localMapEvents).Concat(OtherEvents))
        {
            if (CompletedEvents.Contains(@event.Item2))
                continue;
            if (!@event.Item5())
                continue;
            TriggeredEvent = @event;
            break;
        }

        return true;
    };
    vars.Update = Update;

    // ================================================== start ==================================================

    Func<bool> Start = () => CheckEvent(StartEvent);
    vars.Start = Start;

    // ================================================== reset ==================================================

    Func<bool> Reset = () => CheckEvent(ResetEvent);
    vars.Reset = Reset;

    // ================================================== split ==================================================

    Func<bool> Split = () =>
    {
        CheckEvent(MiscEvent);
        return CheckEvent(SplitEvent);
    };
    vars.Split = Split;

    // ====================================================================================================

    print("multipop.asl " + DateTime.Now.ToString());
}

init
{
    vars.Init(old, current, settings);
}

onStart
{
    vars.OnReset();
}

onReset
{
    vars.OnReset();
}

// note that the update block - along with every other block except startup and shutdown - does not run when LiveSplit is not hooked to any game process
update
{
    return vars.Update(old);
}

start
{
    return vars.Start();
}

reset
{
    return vars.Reset();
}

split
{
    return vars.Split();
}


isLoading
{
    return vars.noGameRunning || vars.game == 5;
}

gameTime
{
    if (vars.game == 5)
    {
        long tickDelta = current.physicsTicks - old.physicsTicks;

        // While rewinding, the scaled tick delta is used so that time doesn't run backwards
        if (tickDelta < 0) tickDelta = current.scaledTicks - old.scaledTicks;

        if (tickDelta > 0) vars.IGTValue += tickDelta;

        return TimeSpan.FromSeconds(vars.IGTValue * current.tickMul);
    }

    return null;
}
