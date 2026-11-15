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

    // Sand Capacity
    int maxSands        : 0x006DB8F4, 0x0;
    int sandPieces      : 0x006DB89C, 0x0;
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
    bool InitCustomVariables = true;

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

    int PrevSandClouds = -1;

    // ===================================================================================================================
    // ================================================== CONFIGURATION ==================================================
    // ===================================================================================================================

    refreshRate = 120;

    // ================================================== settings ==================================================

    //Default:bool    Slug:string                EventSlugs:List<string>            Description:string                           ToolTip:string?                                                                                        ParentSlug:string?
    AddSetting(true,  "GasStation",              new List<string> {"GasStation"},    "Enter Treasure Vaults",                      "Split just before the first save prompt",                                                      null);
    AddSetting(true,  "SandsUnleashed",          new List<string> {"SandsUnleashed"}, "Sands Unleashed",                            "Split on starting the first fight after the CGI cutscene",                                     null);
    AddSetting(false, "FirstGuestRoom",          new List<string> {"FirstGuestRoom"}, "First Guest Room",                           "Split on entering the first guest room",                                                       null);
    AddSetting(false, "SultanChamberZipless",    new List<string> {"SultanChamberZipless"}, "The Sultan's Chamber",                       "Split on entering the Sultan's chamber at the cutscene",                                       null);
    AddSetting(false, "SultanChamber",           new List<string> {"SultanChamber"}, "The Sultan's Chamber (death)",               "Split at the death abuse in Sultan's chamber",                                                 null);
    AddSetting(false, "PalaceDefence",           new List<string> {"PalaceDefence"}, "The Palace's Defence System",                "Split on exiting the palace defense system",                                                   null);
    AddSetting(false, "DadStart",                new List<string> {"DadStart"},      "The Sand King",                              "Split on starting the fight with the Sand King",                                               null);
    AddSetting(true,  "DadDead",                 new List<string> {"DadDead"},       "Death of the Sand King",                     "Split at the end of the fight on loading the next area",                                       null);
    AddSetting(false, "TheWarehouse",            new List<string> {"TheWarehouse"},  "The Warehouse",                              "Split on hitting the button to let Farah enter Warehouse",                                     null);
    AddSetting(false, "TheZoo",                  new List<string> {"TheZoo"},        "The Sultan's Zoo",                           "Split on entering the zoo",                                                                    null);
    AddSetting(false, "BirdCage",                new List<string> {"BirdCage"},      "Atop a Bird Cage",                           "Split at the 'Atop a bird cage' save vortex",                                                  null);
    AddSetting(false, "CliffWaterfalls",         new List<string> {"CliffWaterfalls"}, "Cliffs and Waterfall",                       "Split at the start of cliffs and waterfall",                                                   null);
    AddSetting(false, "TheBathsZipless",         new List<string> {"TheBathsZipless"}, "The Baths",                                  "Split at the end of cliffs and Waterfall",                                                     null);
    AddSetting(false, "TheBaths",                new List<string> {"TheBaths"},      "The Baths (death)",                          "Split on death abuse at the start of baths",                                                   null);
    AddSetting(false, "SecondSword",             new List<string> {"SecondSword"},   "Second Sword",                               "Split on obtaining the second sword at baths",                                                 null);
    AddSetting(false, "TheDaybreak",             new List<string> {"TheDaybreak"},   "Daybreak",                                   "Split at the start of daybreak",                                                               null);
    AddSetting(false, "TheMesshall",             new List<string> {"TheMesshall"},   "Soldiers' Mess Hall (death)",                "Split on death abuse in the mess hall",                                                        null);
    AddSetting(false, "DrawbridgeTower",         new List<string> {"DrawbridgeTower"}, "Drawbridge Tower",                           "Split near the first lever at Drawbridge Tower",                                               null);
    AddSetting(false, "BrokenBridge",            new List<string> {"BrokenBridge"},  "A Broken Bridge",                            "Split at the end of the collapsing bridge",                                                    null);
    AddSetting(false, "TheCavesZipless",         new List<string> {"TheCavesZipless"}, "The Caves",                                  "Split on entering the caves after the door",                                                   null);
    AddSetting(false, "TheCaves",                new List<string> {"TheCaves"},      "The Caves (alternate)",                      "Split on the beam at the start of Waterfall",                                                  null);
    AddSetting(false, "TheWaterfall",            new List<string> {"TheWaterfall"},  "The Waterfall",                              "Split at the end of the descent in Waterfall",                                                 null);
    AddSetting(false, "TheUGReservoirZipless",   new List<string> {"TheUGReservoirZipless"}, "Enter Underground Reservoir",                "Split on entering the underground reservoir",                                                  null);
    AddSetting(false, "OutOfTheWell",            new List<string> {"OutOfTheWell"},  "Out Of The Well",                            "Split when exiting the well",                                                                  null);
    AddSetting(false, "TheUGReservoir",          new List<string> {"TheUGReservoir"}, "Exit Underground Reservoir",                 "Split after the well, when passing through the archway",                                       null);
    AddSetting(false, "TheSultanHarem",          new List<string> {"TheSultanHarem"}, "The Sultan's Harem",                         "Split on the sultan's harem",                                                                  null);
    AddSetting(false, "WhatDidYouCallMe",        new List<string> {"WhatDidYouCallMe"}, "What Did You Call Me",                       "Split on The Sultan's Harem battle beginning",                                                 null);
    AddSetting(false, "HallofLearning",          new List<string> {"HallofLearning"}, "The Hall of Learning",                       "Split on entering the hall of learning",                                                       null);
    AddSetting(false, "TheObservatory",          new List<string> {"TheObservatory"}, "Observatory (death)",                        "Split on death abuse at the end of observatory",                                               null);
    AddSetting(false, "ObservatoryEnter",        new List<string> {"ObservatoryEnter"}, "Enter Observatory",                          "Split on enter the observatory",                                                               null);
    AddSetting(false, "ObservatoryExit",         new List<string> {"ObservatoryExit"}, "Exit Observatory",                           "Split on exiting the observatory",                                                             null);
    AddSetting(false, "HoLCourtyardsExit",       new List<string> {"HoLCourtyardsExit"}, "Exit Hall of Learning Courtyards",           "Split on exiting hall of learning courtyards",                                                 null);
    AddSetting(false, "TheAzadPrison",           new List<string> {"TheAzadPrison"}, "The Azad Prison",                            "Split on entering the prison",                                                                 null);
    AddSetting(false, "TortureChamberZipless",   new List<string> {"TortureChamberZipless"}, "Torture Chamber",                            "Split on entering the torture chamber",                                                        null);
    AddSetting(false, "TortureChamber",          new List<string> {"TortureChamber"}, "Torture Chamber (death)",                    "Split on death abuse at the start of torture chamber",                                         null);
    AddSetting(false, "TheElevator",             new List<string> {"TheElevator"},   "The Elevator",                               "Split on entering the elevator",                                                               null);
    AddSetting(false, "TheDreamZipless",         new List<string> {"TheDreamZipless"}, "A Magic Cavern",                             "Split at the start of the long unskippable cutscene",                                          null);
    AddSetting(false, "TheDream",                new List<string> {"TheDream"},      "A Magic Cavern (alternate)",                 "Split at the start of the 'infinite' stairs",                                                  null);
    AddSetting(false, "TheTomb",                 new List<string> {"TheTomb"},       "The Tomb",                                   "Split at the start of the tomb",                                                               null);
    AddSetting(false, "TowerofDawn",             new List<string> {"TowerofDawn"},   "Tower of Dawn",                              "Split at the start of the ascent back up the Tower of Dawn",                                   null);
    AddSetting(false, "SettingSun",              new List<string> {"SettingSun"},    "Setting Sun",                                "Split on the Ladder near the setting sun save",                                                null);
    AddSetting(true,  "HonorGlory",              new List<string> {"HonorGlory"},    "Honor and Glory",                            "Split on starting the last fight with enemies",                                                null);
    AddSetting(true,  "GrandRewind",             new List<string> {"GrandRewind"},   "Grand Rewind",                               "Split on starting the Vizier fight",                                                           null);
    AddSetting(true,  "SoTEnd",                  new List<string> {"SoTEnd"},        "The End",                                    "Split on defeating the Vizier or hitting the credits trigger",                                 null);
    AddSetting(false, "SoTLU",                   new List<string> {"SoTLU"},         "Life Upgrades",                              "Split on obtaining each life upgrade",                                                         null);

    // ================================================== events ==================================================

    Action action;
    Action<float, float, float, float, float, float> actionBounds;

    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(StartEvent, "Start",                   new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2) && current.startValue == 1 && current.xCam <= -92.8f)) (-103.264f, -103.262f, -4.8f, -4.798f, 1.341f, 1.343f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(ResetEvent, "Reset",                   new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2) && current.xCam <= -92f && current.xCam > -92.8f)) (-103.264f, -103.262f, -4.8f, -4.798f, 1.341f, 1.343f);

    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(MiscEvent,  "AboveCredits",            new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (658.26f, 661.46f, 210.92f, 213.72f, 12.5f, 30f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(MiscEvent,  "SoTLU_Reset",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => { if (InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2)) { CompletedEvents.Remove("SoTLU"); return true; } return false; })) (-477.88f, -477f, -298f, -297.1f, -0.5f, -0.4f);

    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "GasStation",              new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (252f, 258f, 130.647f, 134f, 22.999f, 23.001f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "SandsUnleashed",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-6.177f, -6.175f, 62.905f, 62.907f, 7.604f, 7.606f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "FirstGuestRoom",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (30.297f, 30.299f, 42.126f, 42.128f, 12.998f, 13f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "SultanChamberZipless",    new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (98.445f, 98.447f, 39.567f, 39.57f, -8.96f, -8.958f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "SultanChamber",           new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (134.137f, 134.139f, 54.990f, 54.992f, -32.791f, -32.789f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "PalaceDefence",           new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (4.547f, 8.851f, 40.494f, 47.519f, -39.001f, -38.999f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "DadStart",                new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (6.714f, 6.716f, 57.698f, 57.7f, 21.005f, 21.007f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "DadDead",                 new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-6.001f, -5.999f, -18.6f, -18.4f, 1.998f, 2.001f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheWarehouse",            new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-73.352f, -71.233f, -28.5f, -26.868f, -1.001f, -0.818f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheZoo",                  new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-141.299f, -139.797f, -47.21f, -42.801f, -31.1f, -30.9f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "BirdCage",                new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-211f, -208f, -23f, -21f, -9f, -8.8f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "CliffWaterfalls",         new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-233.6f, -231.4f, 33.7f, 35f, -42.6f, -42.4f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheBathsZipless",         new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-215.85f, -214.089f, 54.261f, 58.699f, -43.501f, -43.499f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheBaths",                new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-211.427f, -211.425f, 56.602f, 56.604f, -43.501f, -43.499f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "SecondSword",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-106.819f, -106.817f, 81.097f, 81.099f, -27.269f, -27.267f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheDaybreak",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-76f, -70f, 192.4f, 197.6f, -56.6f, -54f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheMesshall",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-183.267f, -183.265f, 234.685f, 234.687f, -37.528f, -37.526f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "DrawbridgeTower",         new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-267f, -262f, 232f, 267f, -35.6f, -35.5f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "BrokenBridge",            new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-265f, -257f, 159f, 167f, -13.6f, -13.4f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheCavesZipless",         new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-303f, -297.5f, 112f, 113.5f, -56.1f, -55.9f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheCaves",                new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-246.839f, -241.677f, 78.019f, 87.936f, -71.731f, -70.7f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheWaterfall",            new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-242f, -240.5f, 79.5f, 83f, -121f, -118f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheUGReservoirZipless",   new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-121f, -110f, -9f, -7f, -154.1f, -153.9f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "OutOfTheWell",            new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-62.93f, -62.61f, 58.10f, 58.12f, -26.18f, -24.09f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheUGReservoir",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-51.477f, -48.475f, 72.155f, 73.657f, -24.802f, -24.799f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheSultanHarem",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-9.3f, -6.604f, 148.46f, 151.7f, -24f, -23.8f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "WhatDidYouCallMe",        new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (35.90f, 38f, 134.01f, 137f, -23.99f, -23.8f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "HallofLearning",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (73f, 79f, 161f, 163f, -24.1f, -23.9f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheObservatory",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (139.231f, 139.233f, 162.556f, 162.558f, -29.502f, -29.5f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "ObservatoryEnter",        new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (86.778f, 88.996f, 183.5f, 186.2f, -23.5f, -23.5f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "ObservatoryExit",         new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (137f, 141f, 164f, 164.67f, -29.5f, -29.2f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "HoLCourtyardsExit",       new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (72f, 77f, 90f, 95.7f, -27.1f, -26.9f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheAzadPrison",           new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (190f, 195f, -21f, -19f, -17.6f, -17.3f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TortureChamberZipless",   new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (187.5f, 192.5f, -39f, -37.5f, -119.1f, -118.9f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TortureChamber",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (189.999f, 190.001f, -43.278f, -43.276f, -119.001f, -118.999f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheElevator",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (74f, 75f, -46.751f, -43.252f, -34f, -33f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheDreamZipless",         new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (99f, 101f, -11f, -10f, -56f, -54f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheDream",                new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (95.8f, 96f, -25.1f, -24.9f, -74.9f, -74.7f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheTomb",                 new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (100.643f, 100.645f, -11.543f, -11.541f, -67.588f, -67.586f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TowerofDawn",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (35.5f, 35.7f, -50f, -39f, -32f, -30f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "SettingSun",              new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (60f, 61f, -58f, -57f, 30f, 32f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "HonorGlory",              new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (81f, 82f, -60.3f, -59.7f, 89f, 90f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "GrandRewind",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (660.376f, 660.378f, 190.980f, 190.983f, 0.432f, 0.434f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "SoTLU",                   new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => { if (InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2)) { CompletedEvents.Remove("SoTLU_Reset"); return true; } return false; })) (-492.608f, -492.606f, -248.833f, -248.831f, 0.219f, 0.221f);
    (action=()                        => AddEvent(SplitEvent, "SoTEnd",                  new List<string> {}, HashNull(),                () => (InPosWithBoundsCurrent(658.26f, 661.46f, 210.92f, 213.72f, 9.8f, 12.5f) && CompletedEvents.Contains("AboveCredits")) || current.vizierHealth == 4)) ();

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

    if (timer.CurrentTimingMethod != TimingMethod.RealTime)
    {
        DialogResult mbox = MessageBox.Show(timer.Form,
        "This game uses only real time as the timing method.\nWould you like to switch to Real Time?",
        "LiveSplit | Prince of Persia: The Sands of Time",
        MessageBoxButtons.YesNo);

        if (mbox == DialogResult.Yes)
            timer.CurrentTimingMethod = TimingMethod.RealTime;
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
        InitCustomVariables = true;
    };
    vars.Init = Init;

    // ================================================== onReset ==================================================

    Action OnReset = () =>
    {
        CompletedEvents.Clear();
        InitCustomVariables = true;
        PrevSandClouds = -1;
        print("CompletedEvents cleared.");
    };
    vars.OnReset = OnReset;

    // ================================================== update ==================================================

    var EmptyEventList = new List<Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>>();
    Func<ExpandoObject, bool> Update = newOld =>
    {
        old = newOld;

        int sandClouds = (current.maxSands - 4) * 8 + current.sandPieces;
        sandClouds = sandClouds > 0 ? sandClouds : 0;

        if (InitCustomVariables || sandClouds != PrevSandClouds)
        {
            PrevSandClouds = sandClouds;
            timer.Run.Metadata.SetCustomVariable("sandClouds", sandClouds.ToString() + " / 48");
        }

        InitCustomVariables = false;

        TriggeredEvent = null;
        int xyzHashCode = GetXyzHashCodeCurrent();
        int mapHashCode = 0;
        List<Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>> localXyzEvents;
        List<Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>> localMapEvents;
        XyzEventHashMap.TryGetValue(xyzHashCode, out localXyzEvents);
        MapEventHashMap.TryGetValue(mapHashCode, out localMapEvents);
        localXyzEvents = localXyzEvents ?? EmptyEventList;
        localMapEvents = localMapEvents ?? EmptyEventList;

        foreach (var @event in localXyzEvents.Concat(localMapEvents).Concat(OtherEvents))
        {
            if (!CompletedEvents.Contains(@event.Item2) && @event.Item5())
            {
                TriggeredEvent = @event;
                break;
            }
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

    print("pop_sot.asl " + DateTime.Now.ToString());
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

