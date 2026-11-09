state("PrinceOfPersia_Launcher", "Digital")
{
    int seedCount : 0x00B37F64, 0xDC;
    float xPos    : 0x00B30D08, 0x40;
    float yPos    : 0x00B30D08, 0x44;
    float zPos    : 0x00B30D08, 0x48;
    uint enemyPtr : 0x00B38130, 0x4E4, 0x444, 0x60, 0x8; // pointer to the object that contains enemy data; is zero if there is no enemy
}

state("Prince of Persia", "DRM Free")
{
    int seedCount : 0x00B37F64, 0xDC;
    float xPos    : 0x00B30D08, 0x40;
    float yPos    : 0x00B30D08, 0x44;
    float zPos    : 0x00B30D08, 0x48;
    uint enemyPtr : 0x00B38130, 0x4E4, 0x444, 0x60, 0x8; // see comment above
}

state("Prince of Persia", "Unknown") { }

// Data structures:
// Setting: bool Default, string Slug, List<string> EventSlugs, string Description, string? ToolTip, string? ParentSlug
// Event:   int EventType, string Slug, List<string> SettingSlugs, (float, float, float, float, float, float)? XyzBounds, Func<bool> Condition

// Data structures as tuples:
// Setting: Tuple<bool, string, List<string>, string, string, string>
// Event:   Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>>

// for Event.SettingSlugs and Setting.EventSlugs we prefer a List over a HashSet because iterating over a list is faster
// the downside is that removing duplicates is much slower as it requires an extra hashset allocation and copying items between collections
// but this removal of duplicates is only done upon startup, so we sacrifice some startup performance in order to gain runtime performance

// since the startup block contains all the functions, any reference types defined in this block will not get automatically garbage collected once the block finishes executing
//      because of closures
// so if we allocate any large collections that are no longer needed at runtime,
//      in order to save memory we need to manually de-reference them so that they can get garbage collected
// e.g. if we have a large collection that is no longer needed at runtime:
// var tempCollection = new List<string>();
// then once we're done using it we should de-reference it, i.e.:
// tempCollection = null;
// for any leftover empty/small collections, we don't need to bother
// to help keep track, any declared object that should be de-referenced at the end should be marked with a "GC" comment
startup
{
    // ==========================================================================================================================
    // ================================================== FUNCTION DEFINITIONS ==================================================
    // ==========================================================================================================================

    // ================================================== action variables ==================================================

    Action<dynamic> SetOld = newOld => old = newOld;
    Action<dynamic> SetCurrent = newCurrent => current = newCurrent;
    Action<dynamic> SetSettings = newSettings => settings = newSettings;

    vars.SetOld = SetOld;
    vars.SetCurrent = SetCurrent;
    vars.SetSettings = SetSettings;

    // ================================================== coordinate checks ==================================================

    // for functions that are expected to be called every cycle, we deliberately avoid calling other small functions from within a function
    // because we cannot define real functions but only lambdas, and so the compiler cannot optimise (inline) any function calls
    // so for the sake of performance, we inline small composite functions manually,
    // (e.g. InXBoundsOld manually performs the same check as InBounds instead of just calling InBounds)

    Func<float, float, float?, bool> InBounds = (min, max, pos) => pos >= min && pos <= max;
    Func<float, float, bool> InXBoundsOld = (min, max) => old.xPos >= min && old.xPos <= max;
    Func<float, float, bool> InYBoundsOld = (min, max) => old.yPos >= min && old.yPos <= max;
    Func<float, float, bool> InZBoundsOld = (min, max) => old.zPos >= min && old.zPos <= max;
    Func<float, float, bool> InXBoundsCurrent = (min, max) => current.xPos >= min && current.xPos <= max;
    Func<float, float, bool> InYBoundsCurrent = (min, max) => current.yPos >= min && current.yPos <= max;
    Func<float, float, bool> InZBoundsCurrent = (min, max) => current.zPos >= min && current.zPos <= max;

    Func<float, float, float, float, float, float, float?, float?, float?, bool> InPosWithBounds = (xMin, xMax, yMin, yMax, zMin, zMax, xPos, yPos, zPos)
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

    Func<float, float, float?, bool> InRange = (targ, range, pos) => pos >= targ - range && pos <= targ + range;
    Func<float, float, bool> InXRangeOld = (targ, range) => old.xPos >= targ - range && old.xPos <= targ + range;
    Func<float, float, bool> InYRangeOld = (targ, range) => old.yPos >= targ - range && old.yPos <= targ + range;
    Func<float, float, bool> InZRangeOld = (targ, range) => old.zPos >= targ - range && old.zPos <= targ + range;
    Func<float, float, bool> InXRangeCurrent = (targ, range) => current.xPos >= targ - range && current.xPos <= targ + range;
    Func<float, float, bool> InYRangeCurrent = (targ, range) => current.yPos >= targ - range && current.yPos <= targ + range;
    Func<float, float, bool> InZRangeCurrent = (targ, range) => current.zPos >= targ - range && current.zPos <= targ + range;

    Func<float, float, float, float, float?, float?, float?, bool> InPosWithRange = (xTarg, yTarg, zTarg, range, xPos, yPos, zPos)
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

    Func<float, float, float, float, float, float?, float?, float?, bool> InPosWithRangeXyZ = (xTarg, yTarg, zTarg, xyRange, zRange, xPos, yPos, zPos)
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

    Func<float, float, float, float?, float?, float?, bool> InPosExact = (xTarg, yTarg, zTarg, xPos, yPos, zPos)
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

    Func<float, float, float, float, float, float, ValueTuple<float, float, float, float, float, float>> Bounds = (x1, x2, y1, y2, z1, z2)
        => ValueTuple.Create(x1, x2, y1, y2, z1, z2);

    Func<float, float, float, float, ValueTuple<float, float, float, float, float, float>> BoundsRange = (x, y, z, range)
        => ValueTuple.Create(x - range, x + range, y - range, y + range, z - range, z + range);
    
    Func<float, float, float, float, float, ValueTuple<float, float, float, float, float, float>> BoundsRangeXyZ = (x, y, z, xyRange, zRange)
        => ValueTuple.Create(x - xyRange, x + xyRange, y - xyRange, y + xyRange, z - zRange, z + zRange);
    
    Func<float, float, float, ValueTuple<float, float, float, float, float, float>> BoundsExact = (x, y, z)
        => ValueTuple.Create(x, x, y, y, z, z);

    // ================================================== runtime hash code computations ==================================================

    // see comments on hash code functions below for guidance on what bucket size is appropriate for each game
    const float BucketSize = 20f; // <----------------------------------------------------------------------------------------------------- game-specific

    // all real numbers are broken down into equally sized buckets
    // e.g. if BucketSize = 20f, then:
    //      0f <= coord < 20f falls into bucket 0
    //      20f <= coord < 40f falls into bucket 1
    //      40f <= coord < 60f falls into bucket 2
    //      -20f <= coord < 0f falls into bucket -1
    //      -40f <= coord < -20f falls into bucket -2
    //      and so on...
    // so all coordinates within the same bucket have the same hash code
    // if the coordinate value is not found (i.e. is null), then the largest possible bucket value is used
    //      since it is extremely unlikely that any real coordinates will fall in that bucket
    // if coord is somehow NaN, ∞, or -∞, the cast to an int will turn it into 0, so this function will return 0
    Func<float?, int> GetCoordHashCode = coord =>
    {
        if (coord == null)
            return int.MaxValue;
        int bucket = (int)Math.Floor((float)coord / BucketSize);
        return bucket;
    };

    // fast hashing algorithm with wide dispersion where the same inputs ordered differently yield different results
    const uint FnvPrime = 0x01000193;   // https://en.wikipedia.org/wiki/Fowler%E2%80%93Noll%E2%80%93Vo_hash_function#FNV_prime
    Func<int, int, int, int> CombineCoordHashCodes = (xHash, yHash, zHash) =>
    {
        uint hash = 0;
        hash = hash * FnvPrime + (uint)xHash;
        hash = hash * FnvPrime + (uint)yHash;
        hash = hash * FnvPrime + (uint)zHash;
        return (int)hash;
    };

    // as above, but this time the buckets are cubes,
    // so every point in 3D space falls into a cube bucket of length BucketSize
    // and all coordinates within the same bucket have the same hash code
    // we manually inline here since this is a hot path (see comment about inlining above)
    Func<int> GetXyzHashCodeCurrent = () =>
    {
        uint hash = 0;
        hash = hash * FnvPrime + (current.xPos == null ? int.MaxValue : (uint)(int)Math.Floor(current.xPos / BucketSize));
        hash = hash * FnvPrime + (current.yPos == null ? int.MaxValue : (uint)(int)Math.Floor(current.yPos / BucketSize));
        hash = hash * FnvPrime + (current.zPos == null ? int.MaxValue : (uint)(int)Math.Floor(current.zPos / BucketSize));
        return (int)hash;
    };

    // ================================================== one-time hash code computations ==================================================

    // find all buckets containing coordinates within the given cuboid, and return their hash codes
    // note that if BucketSize is significantly smaller than the lengths of this cuboid,
    // then the size of the returned array will be very large, since it grows cubically
    // so to avoid having to store extremely large arrays in memory, BucketSize should not be smaller than the largest expected cuboid length...
    //      ... by more than an order of magnitude or so
    // on the other hand, if BucketSize is so large that many cuboids are found in the same bucket, this will drastically slow down performance...
    //      ... since the script will have to compare against each cuboid in that bucket on each cycle (e.g. 120 times per second)
    // so for each game an appropriate bucket size should be chosen to get the best mix of saving memory and increasing performance
    // once startup is complete the size of XyzEventHashMap is printed and can be viewed with DebugView
    // so for each game we can try changing BucketSize and seeing how the XyzEventHashMap capacity changes
    // this XyzEventHashMap capacity should inform how big the bucket size should be (multiply it by about 50-100 to get a ballpark estimate of the number of bytes it is occupying in memory)
    // likewise the distribution of buckets that contain collisions is printed at the end, which should also inform us of what bucket size to choose
    // (if the debug output is too spammy, we can increase the MinEventCountPerBucketToCompute constant until it is sufficiently terse)
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
        mySettings.Add(slug, Tuple.Create(@default, slug, eventSlugs, description, toolTip, parentSlug));
        settings.Add(slug, @default, description, parentSlug);
        settings.SetToolTip(slug, toolTip);
    };
    
    // Key: EventSlug; Value: Event
    const int StartEvent = 0;
    const int ResetEvent = 1;
    const int SplitEvent = 2;
    const int MiscEvent = 3;
    var events = new Dictionary<string, Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>>>(); // GC
    Action<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>> AddEvent = (eventType, slug, settingSlugs, xyzBounds, condition)
        => events.Add(slug, Tuple.Create(eventType, slug, settingSlugs, xyzBounds, condition));
    
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
    var XyzEventHashMap = new Dictionary<int, List<Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>>>>();

    // List<Event>
    var OtherEvents = new List<Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>>>();

    HashSet<string> CompletedEvents = null;

    // update block sets this to an event that is not in CompletedEvents and has been triggered on this cycle
    Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>> TriggeredEvent = null;

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
            if (settings[settingSlug])
                eventSetting = true;
        if (!eventSetting)
            return false;
        CompletedEvents.Add(TriggeredEvent.Item2);
        print(GetEventString(eventType) + " " + TriggeredEvent.Item2);
        return true;
    };

    // ================================================== game-specific functions and helper variables ==================================================

    const float SeedRange = 5f;
    Func<float, float, float, bool> SeedGet = (xTarg, yTarg, zTarg)
    =>
        old.seedCount != null && current.seedCount == old.seedCount + 1 &&
        current.xPos >= xTarg - SeedRange && current.xPos <= xTarg + SeedRange &&
        current.yPos >= yTarg - SeedRange && current.yPos <= yTarg + SeedRange &&
        current.zPos >= zTarg - SeedRange && current.zPos <= zTarg + SeedRange;
    
    // this is the moment the combat state finishes and the enemy HP bar disappears
    const float CombatRangeXy = 30f;
    const float CombatRangeZ = 6f;
    Func<float, float, float, bool> CombatFin = (xTarg, yTarg, zTarg)
    =>
        old.enemyPtr != 0 && current.enemyPtr == 0 &&
        current.xPos >= xTarg - CombatRangeXy && current.xPos <= xTarg + CombatRangeXy &&
        current.yPos >= yTarg - CombatRangeXy && current.yPos <= yTarg + CombatRangeXy &&
        current.zPos >= zTarg - CombatRangeZ && current.zPos <= zTarg + CombatRangeZ;
    
    Func<float, float, float, ValueTuple<float, float, float, float, float, float>> BoundsSeed = (x, y, z)
        => ValueTuple.Create(x - SeedRange, x + SeedRange, y - SeedRange, y + SeedRange, z - SeedRange, z + SeedRange);

    Func<float, float, float, ValueTuple<float, float, float, float, float, float>> BoundsCombat = (x, y, z)
        => ValueTuple.Create(x - CombatRangeXy, x + CombatRangeXy, y - CombatRangeXy, y + CombatRangeXy, z - CombatRangeZ, z + CombatRangeZ);
    
    // ===================================================================================================================
    // ================================================== CONFIGURATION ==================================================
    // ===================================================================================================================

    // each setting has a list of events that it's tied to, and each event has a list of settings that it's tied to
    // however, this does not need to be explicitly specified both ways
    // so we may either specify which events are tied to each setting,
    //      or we may specify which settings are tied to each event,
    //      or we can do any combination of both, and the script will auto-fill the settings list for each event and the events list for each setting, removing any duplicates
    // after startup all Setting objects get garbage collected and only Event objects remain

    // if an event has no setting tied to it, then it succeeds upon meeting its condition (as long as it is not in CompletedEvents)
    // if an event has one or more settings tied to it, then it succeeds upon meeting its condition if only if at least one of its settings permits it (as long as it is not in CompletedEvents)

    // if we try to tie to a setting an event which is not defined, an exception will be thrown and startup will fail
    // likewise if we try to tie an event to a setting which is not defined, an exception will be thrown
    // But, WARNING: if we forget to tie an event with a setting,
    //      the script will work normally, the setting will do nothing, and the event will always succeed regardless of the setting
    // to avoid forgetting to tie settings with events, when we make a change, we should open DebugView and review the printed settings, events, and statistics thereof to make sure they are correct

    // ================================================== settings ==================================================

    // parent settings must be specified before their respective children settings (else an exception will be thrown on startup)
    // settings with the same parent (or lack of parent) will be displayed in the same order as specified here

    //Default:bool    Slug:string            EventSlugs:List<string>                   Description:string                              ToolTip:string?                                                   ParentSlug:string?
    AddSetting(true,  "specialEvents",       new List<string> {},                      "Split on scripted game events",                 null,                                                             null);
    AddSetting(true,  "combatEvents",        new List<string> {},                      "Split on defeating enemies in specific levels", null,                                                             null);
    AddSetting(true,  "anyStandard",         new List<string> {},                      "Splits specific to the Any% (Standard) route",  null,                                                             null);
    AddSetting(false, "miscEvents",          new List<string> {},                      "Miscellaneous splits",                          null,                                                             null);
    AddSetting(false, "anyLegacy",           new List<string> {},                      "Legacy splits that are outdated for Any%",      null,                                                             null);

    AddSetting(true,  "CollapsingBridge",    new List<string> {"CollapsingBridge"},    "Collapsing Bridge",                             null,                                                             "specialEvents");
    AddSetting(true,  "PreDad1",             new List<string> {"PreDad1"},             "Tree of Life",                                  "Reach the tree of life inside the temple for the first time",    "specialEvents");
    AddSetting(true,  "ThiccCutscene",       new List<string> {"ThiccCutscene"},       "Thicc Cutscene",                                null,                                                             "specialEvents");
    AddSetting(true,  "RedPlate",            new List<string> {"RedPlate"},            "Step of Ormazd",                                "Splits on entering the Red plate realm",                         "specialEvents");
    AddSetting(true,  "BluePlate",           new List<string> {"BluePlate"},           "Hand of Ormazd",                                "Splits on entering the Blue plate realm",                        "specialEvents");
    AddSetting(true,  "YellowPlate",         new List<string> {"YellowPlate"},         "Wings of Ormazd",                               "Splits on entering the Yellow plate realm",                      "specialEvents");
    AddSetting(true,  "GreenPlate",          new List<string> {"GreenPlate"},          "Breath of Ormazd",                              "Splits on entering the Green plate realm",                       "specialEvents");
    AddSetting(true,  "TheGod",              new List<string> {"TheGod"},              "Defeat Ahriman",                                "Splits on defeating Ahriman in the Temple",                      "specialEvents");
    AddSetting(true,  "Resurrection",        new List<string> {"Resurrection"},        "Resurrection",                                  "Splits on finishing the game",                                   "specialEvents");

    AddSetting(false, "ThirdFight",          new List<string> {"ThirdFight"},          "Third Fight",                                   "Splits on defeating all human enemies in Fight 3",               "combatEvents");
    AddSetting(true,  "Dad1",                new List<string> {"Dad1"},                "Dad Fight 1",                                   "Splits on finishing the Dad 1 fight",                            "combatEvents");
    AddSetting(true,  "Dad2",                new List<string> {"Dad2"},                "Dad Fight 2",                                   "Splits on finishing the Dad 2 fight",                            "combatEvents");
    AddSetting(true,  "KingsGateH",          new List<string> {"KingsGateH"},          "King's Gate",                                   "Splits on defeating Hunter in King's Gate",                      "combatEvents");
    AddSetting(true,  "SunTempleH",          new List<string> {"SunTempleH"},          "The Sun Temple",                                "Splits on defeating Hunter in The Sun Temple",                   "combatEvents");
    AddSetting(true,  "MarshallingGroundH",  new List<string> {"MarshallingGroundH"},  "Marshalling Ground",                            "Splits on defeating Hunter in Marshalling Ground",               "combatEvents");
    AddSetting(true,  "MartyrsTowerH",       new List<string> {"MartyrsTowerH"},       "Martyrs' Tower",                                "Splits on defeating Hunter in Martyrs' Tower",                   "combatEvents");
    AddSetting(true,  "WindmillsH",          new List<string> {"WindmillsH"},          "The Windmills",                                 "Splits on defeating Hunter in The Windmills",                    "combatEvents");
    AddSetting(true,  "Hunter",              new List<string> {"Hunter"},              "Hunter's Lair",                                 "Splits on defeating Hunter in his Lair",                         "combatEvents");
    AddSetting(true,  "CauldronH",           new List<string> {"CauldronH"},           "The Cauldron",                                  "Splits on defeating Alchemist in The Cauldron",                  "combatEvents");
    AddSetting(true,  "ConstructionYardH",   new List<string> {"ConstructionYardH"},   "Construction Yard",                             "Splits on defeating Alchemist in Construction Yard",             "combatEvents");
    AddSetting(true,  "MachineryGroundH",    new List<string> {"MachineryGroundH"},    "Machinery Ground",                              "Splits on defeating Alchemist in Machinery Ground",              "combatEvents");
    AddSetting(true,  "MachineryGroundH2",   new List<string> {"MachineryGroundH2"},   "Machinery Ground (Alternate)",                  "Splits on healing the fertile ground in Machinery Ground",       "combatEvents");
    AddSetting(true,  "ReservoirH",          new List<string> {"ReservoirH"},          "Reservoir",                                     "Splits on defeating Alchemist in Reservoir",                     "combatEvents");
    AddSetting(true,  "HeavensStairH",       new List<string> {"HeavensStairH"},       "Heaven's Stair",                                "Splits on defeating Alchemist in Heaven's Stair",                "combatEvents");
    AddSetting(true,  "Alchemist",           new List<string> {"Alchemist"},           "The Observatory",                               "Splits on defeating Alchemist in The Observatory",               "combatEvents");
    AddSetting(true,  "CavernH",             new List<string> {"CavernH"},             "The Cavern",                                    "Splits on defeating Concubine in The Cavern",                    "combatEvents");
    AddSetting(true,  "RoyalGardensH",       new List<string> {"RoyalGardensH"},       "Royal Gardens",                                 "Splits on defeating Concubine in Royal Gardens",                 "combatEvents");
    AddSetting(true,  "SpireOfDreamsH",      new List<string> {"SpireOfDreamsH"},      "Spire of Dreams",                               "Splits on defeating Concubine in Spire of Dreams",               "combatEvents");
    AddSetting(true,  "RoyalSpireH",         new List<string> {"RoyalSpireH"},         "Royal Spire",                                   "Splits on defeating Concubine in Royal Spire",                   "combatEvents");
    AddSetting(true,  "CoronationHallH",     new List<string> {"CoronationHallH"},     "Coronation Hall",                               "Splits on defeating Concubine in Coronation Hall",               "combatEvents");
    AddSetting(true,  "Concubine",           new List<string> {"Concubine"},           "The Palace Rooms",                              "Splits on defeating Concubine in The Palace Rooms",              "combatEvents");
    AddSetting(true,  "CityGateH",           new List<string> {"CityGateH"},           "City Gate",                                     "Splits on defeating Warrior in City Gate",                       "combatEvents");
    AddSetting(true,  "TowerOfArhimanH",     new List<string> {"TowerOfAhrimanH"},     "Tower of Ahriman",                              "Splits on defeating Warrior in Tower of Ahriman",                "combatEvents");
    AddSetting(true,  "TowerOfOrmazdH",      new List<string> {"TowerOfOrmazdH"},      "Tower of Ormazd",                               "Splits on defeating Warrior in Tower of Ormazd",                 "combatEvents");
    AddSetting(true,  "QueensTowerH",        new List<string> {"QueensTowerH"},        "Queen's Tower",                                 "Splits on defeating Warrior in Queen's Tower",                   "combatEvents");
    AddSetting(true,  "CityOfLightH",        new List<string> {"CityOfLightH"},        "City of Light",                                 "Splits on defeating Warrior in City of Light",                   "combatEvents");
    AddSetting(true,  "Warrior",             new List<string> {"Warrior"},             "Warrior's Fortress",                            "Splits on defeating Warrior in his Fortress",                    "combatEvents");
    AddSetting(true,  "King",                new List<string> {"King"},                "Dad Fight 4",                                   "Splits on defeating the Mourning King before Ahriman encounter", "combatEvents");

    AddSetting(true,  "NeoBarrierSkip",      new List<string> {"NeoBarrierSkip"},      "Barrier Skip",                                  "Splits right after getting out of elika-walk at King's Gate",    "anyStandard");
    AddSetting(true,  "KingsGate",           new List<string> {"KingsGate"},           "King's Gate",                                   null,                                                             "anyStandard");
    AddSetting(true,  "SunTemple",           new List<string> {"SunTemple"},           "Sun Temple",                                    null,                                                             "anyStandard");
    AddSetting(true,  "MarshGrounds",        new List<string> {"MarshGrounds"},        "Marshalling Ground",                            null,                                                             "anyStandard");
    AddSetting(true,  "Windmills",           new List<string> {"Windmills"},           "Windmills",                                     null,                                                             "anyStandard");
    AddSetting(true,  "MartyrsTower",        new List<string> {"MartyrsTower"},        "Martyrs' Tower",                                null,                                                             "anyStandard");
    AddSetting(true,  "MachineryGround",     new List<string> {"MachineryGround"},     "Machinery Ground",                              null,                                                             "anyStandard");
    AddSetting(true,  "HeavensStair",        new List<string> {"HeavensStair"},        "Heaven's Stair",                                null,                                                             "anyStandard");
    AddSetting(true,  "SpireOfDreams",       new List<string> {"SpireOfDreams"},       "Spire of Dreams",                               null,                                                             "anyStandard");
    AddSetting(true,  "CoronationHall",      new List<string> {"CoronationHall"},      "Coronation Hall",                               null,                                                             "anyStandard");
    AddSetting(true,  "RoyalSpire1",         new List<string> {"RoyalSpire1"},         "Royal Spire I",                                 null,                                                             "anyStandard");
    AddSetting(true,  "Reservoir",           new List<string> {"Reservoir"},           "Reservoir",                                     null,                                                             "anyStandard");
    AddSetting(true,  "ConstructionYard",    new List<string> {"ConstructionYard"},    "Construction Yard",                             null,                                                             "anyStandard");
    AddSetting(true,  "Cauldron",            new List<string> {"Cauldron"},            "Cauldron",                                      null,                                                             "anyStandard");
    AddSetting(true,  "Cavern",              new List<string> {"Cavern"},              "Cavern I",                                      null,                                                             "anyStandard");
    AddSetting(true,  "CityGate",            new List<string> {"CityGate"},            "City Gate",                                     null,                                                             "anyStandard");
    AddSetting(true,  "TowerOfAhriman",      new List<string> {"TowerOfAhriman"},      "Tower of Ahriman",                              null,                                                             "anyStandard");
    AddSetting(true,  "QueensTower",         new List<string> {"QueensTower"},         "Queen's Tower",                                 null,                                                             "anyStandard");
    AddSetting(true,  "CityOfLight",         new List<string> {"CityOfLight"},         "City of Light",                                 null,                                                             "anyStandard");
    AddSetting(true,  "TowerOfOrmazd",       new List<string> {"TowerOfOrmazd"},       "Tower of Ormazd",                               null,                                                             "anyStandard");
    AddSetting(true,  "RoyalSpire2",         new List<string> {"RoyalSpire2"},         "Royal Spire II",                                null,                                                             "anyStandard");
    AddSetting(true,  "RoyalGardens",        new List<string> {"RoyalGardens"},        "Royal Gardens",                                 null,                                                             "anyStandard");
    AddSetting(true,  "Cavern2",             new List<string> {"Cavern2"},             "Cavern II",                                     null,                                                             "anyStandard");

    AddSetting(false, "DoubleJump",          new List<string> {"DoubleJump"},          "Double Jump",                                   "Splits on dying after getting double jump (used for NG+)",       "miscEvents");

    AddSetting(true,  "BarrierSkip",         new List<string> {"BarrierSkip"},         "Barrier Skip",                                  "Splits after barrier skip",                                      "anyLegacy");
    AddSetting(true,  "SunTempleNDJE",       new List<string> {"SunTempleNDJE"},       "Sun Temple",                                    null,                                                             "anyLegacy");
    AddSetting(true,  "MartyrsTowerNDJE",    new List<string> {"MartyrsTowerNDJE"},    "Martyrs' Tower",                                null,                                                             "anyLegacy");
    AddSetting(true,  "MTtoMG",              new List<string> {"MTtoMG"},              "MT -> McG",                                     null,                                                             "anyLegacy");
    AddSetting(true,  "MachineryGroundNDJE", new List<string> {"MachineryGroundNDJE"}, "Machinery Ground",                              null,                                                             "anyLegacy");
    AddSetting(true,  "TowerOfOrmazdNDJE",   new List<string> {"TowerOfOrmazdNDJE"},   "Tower of Ormazd",                               null,                                                             "anyLegacy");
    AddSetting(true,  "QueensTowerNDJE",     new List<string> {"QueensTowerNDJE"},     "Queen's Tower",                                 null,                                                             "anyLegacy");
    AddSetting(true,  "CoronationHallNDJE",  new List<string> {"CoronationHallNDJE"},  "Coronation Hall",                               null,                                                             "anyLegacy");
    AddSetting(true,  "Seed540",             new List<string> {"Seed540"},             "540 Seeds",                                     "Splits on getting the final seed at Heaven's Stair",             "anyLegacy");

    // ================================================== events ==================================================

    Action action;
    Action<float, float, float> actionPos;
    Action<float, float, float, float> actionRange;
    Action<float, float, float, float, float> actionRangeXyZ;
    Action<float, float, float, float, float, float> actionBounds;

    //                                                                                                    XyzBounds:
    //                                                                               SettingSlugs:         (float,float,float,
    //                                   EventType:int        Slug:string             List<string>         float,float,float)?        Condition:Func<bool>
    (actionRange=(x,y,z,range)        => AddEvent(StartEvent, "StartLoad",           new List<string> {}, BoundsRange(x,y,z,range),  () => (old.xPos == x && old.yPos == y) && (current.xPos != x || current.yPos != y))) (-465f, -351f, -24f, 5f);
    (actionRange=(x,y,z,range)        => AddEvent(ResetEvent, "ResetLoad",           new List<string> {}, BoundsRange(x,y,z,range),  () => (old.xPos != x || old.yPos != y) && (current.xPos == x && current.yPos == y))) (-465f, -351f, -24f, 5f);
    (actionRange=(x,y,z,range)        => AddEvent(StartEvent, "StartNew",            new List<string> {}, BoundsRange(x,y,z,5f),     () => InPosWithRangeOld(x, y, z, range) && !InPosWithRangeCurrent(x, y, z, range))) (-462.302f, -348.223f, -23.956f, 0.003f);
    (actionRange=(x,y,z,range)        => AddEvent(ResetEvent, "ResetNew",            new List<string> {}, BoundsRange(x,y,z,range),  () => !InPosWithRangeOld(x, y, z, range) && InPosWithRangeCurrent(x, y, z, range))) (-462.302f, -348.223f, -23.956f, 0.003f);

    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "CollapsingBridge",    new List<string> {}, BoundsRange(x,y,z,range),  () => InPosWithRangeCurrent(x, y, z, range))) (-310.25f, -241.0f, -30.2f, 0.2f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "PreDad1",             new List<string> {}, BoundsRange(x,y,z,range),  () => InPosWithRangeCurrent(x, y, z, range))) (4f, -388.6f, -40f, 2f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "ThiccCutscene",       new List<string> {}, BoundsRange(x,y,z,range),  () => CompletedEvents.Contains("Dad1") && old.yPos < -238f && InPosWithRangeCurrent(x, y, z, range))) (6f, -233.5f, -33f, 2f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "RedPlate",            new List<string> {}, BoundsRange(x,y,z,range),  () => InPosWithRangeCurrent(x, y, z, range))) (-55f, -447f, -180f, 2f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "BluePlate",           new List<string> {}, BoundsRange(x,y,z,range),  () => InPosWithRangeCurrent(x, y, z, range))) (45f, -456f, -180f, 2f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "YellowPlate",         new List<string> {}, BoundsRange(x,y,z,range),  () => InPosWithRangeCurrent(x, y, z, range))) (-156f, -413f, -180f, 2f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "GreenPlate",          new List<string> {}, BoundsRange(x,y,z,range),  () => InPosWithRangeCurrent(x, y, z, range))) (150f, -444f, -182f, 2f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheGod",              new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (7.129f, 7.131f, -401.502f, -401.5f, -31.4f, -21f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "Resurrection",        new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (5.562f, 5.566f, -222.745f, -222.517f, -33.1f, -21f);

    (actionPos=(x,y,z)                => AddEvent(MiscEvent,  "Fight3_1",            new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (-186f, -140f, -32f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "ThirdFight",          new List<string> {}, BoundsCombat(x,y,z),       () => CompletedEvents.Contains("Fight3_1") && CombatFin(x, y, z))) (-186f, -140f, -32f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "Dad1",                new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (5f, -402f, -40f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "Dad2",                new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (6f, -187f, -48f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "KingsGateH",          new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (-413.5f, -66.5f, 25f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "SunTempleH",          new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (-554.5f, -54f, 34f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "MarshallingGroundH",  new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (-761.5f, -17.5f, 19f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "MartyrsTowerH",       new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (-559.5f, 193.5f, 35f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "WindmillsH",          new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (-761f, 150f, 45f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "Hunter",              new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (-929.415f, 320.888f, -90.3f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "CauldronH",           new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (-168f, 225f, 20f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "ConstructionYardH",   new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (-251.5f, 456.5f, 31f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "MachineryGroundH",    new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (-400f, 457f, 18f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "MachineryGroundH2",   new List<string> {}, BoundsExact(x,y,z),        () => InPosExactCurrent(x, y, z))) (-393.2969971f, 517.6463623f, 56.27552414f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "ReservoirH",          new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (-156.5f, 571.5f, 8f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "HeavensStairH",       new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (-291f, 651.5f, 99.2f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "Alchemist",           new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (-296.593f, 697.233f, 296.199f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "CavernH",             new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (155f, 180.5f, -22.5f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "RoyalGardensH",       new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (265f, 381.5f, 35.5f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "SpireOfDreamsH",      new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (187.5f, 550f, 141.5f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "RoyalSpireH",         new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (468.5f, 426f, 141.5f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "CoronationHallH",     new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (340f, 582.5f, 32.5f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "Concubine",           new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (352.792f, 801.051f, 150.260f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "CityGateH",           new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (421.5f, -87.5f, -24f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "TowerOfAhrimanH",     new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (598.5f, 13.5f, 86f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "TowerOfOrmazdH",      new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (654f, 208f, -7f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "QueensTowerH",        new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (787f, -32.5f, 98.5f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "CityOfLightH",        new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (804f, 113f, -42.5f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "Warrior",             new List<string> {}, BoundsCombat(x,y,z),       () => CombatFin(x, y, z))) (1070.478f, 279.147f, -29.571f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "King",                new List<string> {}, BoundsCombat(x,y,z),       () => CompletedEvents.Contains("ThiccCutscene") && CombatFin(x, y, z))) (5f, -365f, -32f);

    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "NeoBarrierSkip",      new List<string> {}, BoundsRange(x,y,z,range),  () => InPosWithRangeCurrent(x, y, z, range))) (-331.5f, -4.5f, -9.9f, 1f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "KingsGate",           new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (-538.834f, -67.159f, 12.732f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "SunTemple",           new List<string> {}, BoundsRange(x,y,z,range),  () => InPosWithRangeCurrent(x, y, z, range))) (-673.8f, -53.9f, 16.3f, 1f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "MarshGrounds",        new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (-806.671f, 112.803f, 21.645f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "Windmills",           new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (-597.945f, 209.241f, 23.339f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "MartyrsTower",        new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (-548f, 230f, 26f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "MachineryGround",     new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (-370f, 468f, 17f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "HeavensStair",        new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (-85.968f, 573.338f, 30.558f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "SpireOfDreams",       new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (266f, 602f, 36f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "CoronationHall",      new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (399f, 535f, 39.5f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "RoyalSpire1",         new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (-88.5f, 538.5f, 44.5f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "Reservoir",           new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (-150.082f, 406.606f, 34.673f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "ConstructionYard",    new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (-166f, 293f, 20.5f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "Cauldron",            new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (-12f, 135f, -15f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "Cavern",              new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (251.741f, 65.773f, -13.616f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "CityGate",            new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (547.488f, 45.41f, -27.107f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "TowerOfAhriman",      new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (667f, -14f, -30f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "QueensTower",         new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (842f, -16f, -40f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "CityOfLight",         new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (735f, 166f, -35f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "TowerOfOrmazd",       new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (655f, 227f, -37f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "RoyalSpire2",         new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (407f, 399f, 34f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "RoyalGardens",        new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (152f, 244f, 9f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "Cavern2",             new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (80f, 182f, -8f);

    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "DoubleJump",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => CompletedEvents.Contains("PreDad1") && InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (0f, 10f, -253f, -243f, -70f, -43f);

    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "BarrierSkip",         new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-208f, -200f, -38f, -27.5f, -51f, -41f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "SunTempleNDJE",       new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (-664f, -58f, 12f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "MartyrsTowerNDJE",    new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (-564.202f, 207.312f, 22f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "MTtoMG",              new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (-454.824f, 398.571f, 27.028f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "MachineryGroundNDJE", new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (-361.121f, 480.114f, 12.928f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "TowerOfOrmazdNDJE",   new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (609.907f, 61.905f, -35.001f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "QueensTowerNDJE",     new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (637.262f, 27.224f, -28.603f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "CoronationHallNDJE",  new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (340f, 590f, 19f);
    (actionPos=(x,y,z)                => AddEvent(SplitEvent, "Seed540",             new List<string> {}, BoundsSeed(x,y,z),         () => SeedGet(x, y, z))) (-280f, 696f, 87f);

    // ====================================================================================================================
    // ================================================== STARTUP SCRIPT ==================================================
    // ====================================================================================================================

    // ================================================== apply configured setting-event links ==================================================

    // add each setting that references an event to that event's settings list,
    // or throw an exception if a setting points to an event that doesn't exist
    foreach (var setting in mySettings.Values)
    {
        foreach (string eventSlug in setting.Item3)
        {
            // for some reason if a type declaration has both a "?" and an "@" it breaks the colour scheme for the rest of the script when using the VSCode ASL plugin
            // which is why here specifically we name the variable "myEvent" instead of "@event"
            Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>> myEvent;
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

    // fill XyzEventHashMap and OtherEvents
    foreach (var @event in events.Values)
    {
        if (@event.Item4 == null)
        {
            OtherEvents.Add(@event);
            continue;
        }
        ValueTuple<float, float, float, float, float, float> xyzBounds = @event.Item4.Value;
        int[] hashCodes = GetHashCodesForBounds(xyzBounds.Item1, xyzBounds.Item2, xyzBounds.Item3, xyzBounds.Item4, xyzBounds.Item5, xyzBounds.Item6);
        foreach (int hashCode in hashCodes)
        {
            List<Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>>> localEvents;
            if (XyzEventHashMap.TryGetValue(hashCode, out localEvents))
            {
                localEvents.Add(@event);
                continue;
            }
            XyzEventHashMap.Add(hashCode, new List<Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>>> {@event});
        }
    }

    // since most of the lists in XyzEventHashMap contain only one value and likely have a capacity of 4, it is worth reducing the capacity of the lists
    //      to the actual desired size and reduce memory usage from these lists by almost 4 times
    foreach (var bucket in XyzEventHashMap.Values)
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
        if (setting.Item3.Count == 0)
            settingsWithNoEvents.Add(setting.Item2);
        infoBuilder.Append("\t" + setting.Item1.ToString().PadRight(5) + " " + setting.Item2.PadRight(30) + " : " + (setting.Item6 ?? "{null}").PadRight(30)
            + " => " + setting.Item3.Count + ":[" + string.Join(", ", setting.Item3) + "]\r\n");
    }
    infoBuilder.Append("Total settings: " + mySettings.Count.ToString() + "\r\n\r\n");

    infoBuilder.Append("Events detected:\r\n");
    infoBuilder.Append("\t" + "{EventType}     {Event}".PadRight(46) + " {HasXyzBounds} => {Count:[..Settings]}\r\n");
    foreach (var @event in events.Values)
    {
        if (@event.Item3.Count == 0)
            eventsWithNoSettings.Add(@event.Item2);
        infoBuilder.Append("\t" + GetEventString(@event.Item1).PadRight(15) + " " + @event.Item2.PadRight(30) + " " + (@event.Item4 != null).ToString().PadRight(5)
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

    // the hash map count is how many keys it actually stores
    // while its capacity is the total number of keys that it can hold based on how much memory it has been allocated
    int xyzEventHashMapCapacity =
        ((Array)
        typeof(Dictionary<int, List<Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>>>>)
        .GetField("entries", BindingFlags.NonPublic | BindingFlags.Instance)
        .GetValue(XyzEventHashMap))
        .Length;
    infoBuilder.Append("XyzEventHashMap capacity: " + XyzEventHashMap.Count.ToString() + "/" + xyzEventHashMapCapacity + "\r\n");
    infoBuilder.Append("OtherEvents capacity: " + OtherEvents.Count.ToString() + "/" + OtherEvents.Capacity.ToString() + "\r\n");
    infoBuilder.Append("\r\n");

    int collisionSum = 0;
    int maxEventsPerBucket = 0;
    double avgEventsPerBucket;
    var bucketGroupsPerEventCount = new List<List<List<Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>>>>>(); // GC
    var bucketCountsPerEventCount = new List<int>(); // GC
    const int MinEventCountPerBucketToCompute = 2; // change to a higher number if startup script lags or debug info gets too spammy
    foreach (var bucket in XyzEventHashMap.Values)
    {
        collisionSum += bucket.Count;
        if (bucket.Count >= maxEventsPerBucket)
            maxEventsPerBucket = bucket.Count;
        for (int i = bucketGroupsPerEventCount.Count; i <= bucket.Count; i++)
        {
            bucketGroupsPerEventCount.Add(new List<List<Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>>>>());
            bucketCountsPerEventCount.Add(0);
        }
        if (bucket.Count >= MinEventCountPerBucketToCompute)
            bucketGroupsPerEventCount[bucket.Count].Add(bucket);
        bucketCountsPerEventCount[bucket.Count]++;
    }
    avgEventsPerBucket = (double)collisionSum / (double)XyzEventHashMap.Count;

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

    print(infoBuilder.ToString());

    // ================================================== timing method prompt ==================================================

    if (timer.CurrentTimingMethod != TimingMethod.RealTime)
    {
        DialogResult mbox = MessageBox.Show(timer.Form,
        "This game uses only real time as the timing method.\nWould you like to switch to Real Time?",
        "LiveSplit | Prince of Persia (2008)",
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
    bucketGroupsPerEventCount = null;
    bucketCountsPerEventCount = null;

    // =====================================================================================================================
    // ================================================== RUNTIME ACTIONS ==================================================
    // =====================================================================================================================

    // ================================================== onReset ==================================================

    Action OnReset = () => CompletedEvents.Clear();
    vars.OnReset = OnReset;

    // ================================================== update ==================================================

    var EmptyEventList = new List<Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>>>();
    Func<bool> Update = () =>
    {
        TriggeredEvent = null;
        int xyzHashCode = GetXyzHashCodeCurrent();
        List<Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>>> localEvents;
        XyzEventHashMap.TryGetValue(xyzHashCode, out localEvents);
        localEvents = localEvents ?? EmptyEventList;
        
        // print local events:
        /*var builderLocal = new StringBuilder();
        foreach (var @event in localEvents) builderLocal.Append(@event.Item2 + "\r\n");
        if (localEvents.Count > 0) print(builderLocal.ToString());*/

        // print non-location-based events:
        /*var builderOther = new StringBuilder();
        foreach (var @event in OtherEvents) builderOther.Append(@event.Item2 + "\r\n");
        if (OtherEvents.Count > 0) print(builderOther.ToString());*/

        // Concat function means we iterate through the lists one after the other; it does not create a concatenated list
        foreach (var @event in localEvents.Concat(OtherEvents))
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

    print("pop_2008.asl " + DateTime.Now.ToString());
}

init
{
    refreshRate = 120;
    if (game.ProcessName == "PrinceOfPersia_Launcher")
    {
        version = "Digital";
    }
    else
    {
        string MD5Hash;
        using (var md5 = System.Security.Cryptography.MD5.Create())
            using (var s = File.Open(modules.First().FileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
                MD5Hash = md5.ComputeHash(s).Select(x => x.ToString("X2")).Aggregate((a, b) => a + b);

        switch (MD5Hash)
        {
        case "445CC13490EC170E1C281E9357FF3E52": version = "DRM Free"; break;
        default: version = "Unknown"; break;
        }
    }
    
    // when LiveSplit hooks to a game process, it creates one "current" object and the "current" variable always points to the same object for the lifetime of the process hook
    // however when LiveSplit initially hooks to a game process, the "old" variable also points to the same object as the "current" variable
    // then LiveSplit creates a new "old" object every cycle
    // so with each cycle, LiveSplit dismisses the old "old" object and creates a new one, copying all data from the "current" object,
    //      and then reads new data from the game process and copies it into the existing "current" object, overwriting the previous data
    // note that if we write any functions that use the "old" and "current" variables in the init block,
    //      those functions will treat the "old" and "current" variables as the same since they both pointed to the same object at the time the function was defined
    // (this is a "feature" of the ASL variables specifically; in standard C#, functions use the updated values at the time the function is called; cf. closure)
    // likewise any functions defined in the startup block will not be able to read the "old" and "current" values at the time of the function call at all,
    //      since those variables point to nothing (that is, old=null and current=null) at the time of startup
    // but if we explicitly write the new "old" and "current" objects into the "Old" and "Current" variables defined in the startup block as they are updated,
    //      then we can safely define functions in both the startup and the init blocks, and they will safely read the updated "old" and "current" objects,
    //      as they are at the time of the function call - as long as we refer to the manually created "Old" and "Current" variables rather than the built-in "old" and "current" ones
    // this is because the "old" and "current" objects are placed behind the "Old" and "Current" variables
    //      which get captured by the closure created when a function lambda is defined,
    //      so the lambda will always look for the object behind the variable at the time of the function call
    // the "current" and "old" objects are of type System.ExpandoObject which is a reference type, so here we are merely passing a reference to the object,
    //      not copying the actual contents of the object
    vars.SetOld(old);
    vars.SetCurrent(current);
    vars.SetSettings(settings);
}

onReset
{
    vars.OnReset();
}

// note that the update block - along with every other block except startup and shutdown - does not run when LiveSplit is not hooked to any game process
update
{
    // we avoid explicitly assigning vars.SetCurrent(current) in the update block since it is not needed,
    // and just in case this allows the compiler to perform some optimisations when accessing the Current variable
    vars.SetOld(old);

    return vars.Update();
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