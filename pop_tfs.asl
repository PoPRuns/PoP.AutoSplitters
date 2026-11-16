state("prince of persia")
{
    float xPos          : 0xDA4D20;
    float yPos          : 0xDA4D24;
    float zPos          : 0xDA4D28;
    int gameState       : 0x00DA52EC, 0x18, 0xF8, 0x150;
    int cpIcon          : 0x007186D4, 0x0, 0x0, 0x24, 0x1C, 0x1C, 0x870;
    int isMenu          : 0xDA2F70;
    bool isLoading      : "", 0x00DA5724, 0x50;
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

// Data structures:
// record class Setting: bool Default, string Slug, List<string> EventSlugs, string Description, string? ToolTip, string? ParentSlug
// record class Event:   int EventType, string Slug, List<string> SettingSlugs, (float, float, float, float, float, float)? XyzBounds, Func<bool> Condition

// Data structures as tuples:
// Setting: Tuple<bool, string, List<string>, string, string, string>
// Event:   Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>>

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
    Func<float, float, bool> InXBoundsOldOnly = (min, max) => old.xPos >= min && old.xPos <= max && !(current.xPos >= min && current.xPos <= max);
    Func<float, float, bool> InYBoundsOldOnly = (min, max) => old.yPos >= min && old.yPos <= max && !(current.yPos >= min && current.yPos <= max);
    Func<float, float, bool> InZBoundsOldOnly = (min, max) => old.zPos >= min && old.zPos <= max && !(current.zPos >= min && current.zPos <= max);
    Func<float, float, bool> InXBoundsCurrentOnly = (min, max) => !(old.xPos >= min && old.xPos <= max) && current.xPos >= min && current.xPos <= max;
    Func<float, float, bool> InYBoundsCurrentOnly = (min, max) => !(old.yPos >= min && old.yPos <= max) && current.yPos >= min && current.yPos <= max;
    Func<float, float, bool> InZBoundsCurrentOnly = (min, max) => !(old.zPos >= min && old.zPos <= max) && current.zPos >= min && current.zPos <= max;

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

    Func<float, float, float, float, float, float, bool> InPosWithBoundsOldOnly = (xMin, xMax, yMin, yMax, zMin, zMax)
    =>
        old.xPos >= xMin && old.xPos <= xMax &&
        old.yPos >= yMin && old.yPos <= yMax &&
        old.zPos >= zMin && old.zPos <= zMax &&
        !(current.xPos >= xMin && current.xPos <= xMax &&
          current.yPos >= yMin && current.yPos <= yMax &&
          current.zPos >= zMin && current.zPos <= zMax);
    
    Func<float, float, float, float, float, float, bool> InPosWithBoundsCurrentOnly = (xMin, xMax, yMin, yMax, zMin, zMax)
    =>
        !(old.xPos >= xMin && old.xPos <= xMax &&
          old.yPos >= yMin && old.yPos <= yMax &&
          old.zPos >= zMin && old.zPos <= zMax) &&
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
    Func<float, float, bool> InXRangeOldOnly = (targ, range) => old.xPos >= targ - range && old.xPos <= targ + range && !(current.xPos >= targ - range && current.xPos <= targ + range);
    Func<float, float, bool> InYRangeOldOnly = (targ, range) => old.yPos >= targ - range && old.yPos <= targ + range && !(current.yPos >= targ - range && current.yPos <= targ + range);
    Func<float, float, bool> InZRangeOldOnly = (targ, range) => old.zPos >= targ - range && old.zPos <= targ + range && !(current.zPos >= targ - range && current.zPos <= targ + range);
    Func<float, float, bool> InXRangeCurrentOnly = (targ, range) => !(old.xPos >= targ - range && old.xPos <= targ + range) && current.xPos >= targ - range && current.xPos <= targ + range;
    Func<float, float, bool> InYRangeCurrentOnly = (targ, range) => !(old.yPos >= targ - range && old.yPos <= targ + range) && current.yPos >= targ - range && current.yPos <= targ + range;
    Func<float, float, bool> InZRangeCurrentOnly = (targ, range) => !(old.zPos >= targ - range && old.zPos <= targ + range) && current.zPos >= targ - range && current.zPos <= targ + range;

    Func<float, float, float, bool> InXyRangeOld = (xTarg, yTarg, range)
    =>
        old.xPos >= xTarg - range && old.xPos <= xTarg + range &&
        old.yPos >= yTarg - range && old.yPos <= yTarg + range;
    
    Func<float, float, float, bool> InXyRangeCurrent = (xTarg, yTarg, range)
    =>
        current.xPos >= xTarg - range && current.xPos <= xTarg + range &&
        current.yPos >= yTarg - range && current.yPos <= yTarg + range;

    Func<float, float, float, bool> InXyRangeOldOnly = (xTarg, yTarg, range)
    =>
        old.xPos >= xTarg - range && old.xPos <= xTarg + range &&
        old.yPos >= yTarg - range && old.yPos <= yTarg + range &&
        !(current.xPos >= xTarg - range && current.xPos <= xTarg + range &&
          current.yPos >= yTarg - range && current.yPos <= yTarg + range);

    Func<float, float, float, bool> InXyRangeCurrentOnly = (xTarg, yTarg, range)
    =>
        !(old.xPos >= xTarg - range && old.xPos <= xTarg + range &&
          old.yPos >= yTarg - range && old.yPos <= yTarg + range) &&
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

    Func<float, float, float, float, bool> InPosWithRangeOldOnly = (xTarg, yTarg, zTarg, range)
    =>
        old.xPos >= xTarg - range && old.xPos <= xTarg + range &&
        old.yPos >= yTarg - range && old.yPos <= yTarg + range &&
        old.zPos >= zTarg - range && old.zPos <= zTarg + range &&
        !(current.xPos >= xTarg - range && current.xPos <= xTarg + range &&
          current.yPos >= yTarg - range && current.yPos <= yTarg + range &&
          current.zPos >= zTarg - range && current.zPos <= zTarg + range);

    Func<float, float, float, float, bool> InPosWithRangeCurrentOnly = (xTarg, yTarg, zTarg, range)
    =>
        !(old.xPos >= xTarg - range && old.xPos <= xTarg + range &&
          old.yPos >= yTarg - range && old.yPos <= yTarg + range &&
          old.zPos >= zTarg - range && old.zPos <= zTarg + range) &&
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

    Func<float, float, float, float, float, bool> InPosWithRangeXyZOldOnly = (xTarg, yTarg, zTarg, xyRange, zRange)
    =>
        old.xPos >= xTarg - xyRange && old.xPos <= xTarg + xyRange &&
        old.yPos >= yTarg - xyRange && old.yPos <= yTarg + xyRange &&
        old.zPos >= zTarg - zRange && old.zPos <= zTarg + zRange &&
        !(current.xPos >= xTarg - xyRange && current.xPos <= xTarg + xyRange &&
          current.yPos >= yTarg - xyRange && current.yPos <= yTarg + xyRange &&
          current.zPos >= zTarg - zRange && current.zPos <= zTarg + zRange);

    Func<float, float, float, float, float, bool> InPosWithRangeXyZCurrentOnly = (xTarg, yTarg, zTarg, xyRange, zRange)
    =>
        !(old.xPos >= xTarg - xyRange && old.xPos <= xTarg + xyRange &&
          old.yPos >= yTarg - xyRange && old.yPos <= yTarg + xyRange &&
          old.zPos >= zTarg - zRange && old.zPos <= zTarg + zRange) &&
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
    
    Func<float, float, float, bool> InPosExactOldOnly = (xTarg, yTarg, zTarg)
    =>
        xTarg == old.xPos &&
        yTarg == old.yPos &&
        zTarg == old.zPos &&
        !(xTarg == current.xPos &&
          yTarg == current.yPos &&
          zTarg == current.zPos);

    Func<float, float, float, bool> InPosExactCurrentOnly = (xTarg, yTarg, zTarg)
    =>
        !(xTarg == old.xPos &&
          yTarg == old.yPos &&
          zTarg == old.zPos) &&
        xTarg == current.xPos &&
        yTarg == current.yPos &&
        zTarg == current.zPos;
    
    Func<float, float, float, float, bool> InPosExactXy = (xTarg, yTarg, xPos, yPos)
    =>
        xTarg == xPos &&
        yTarg == yPos;
    
    Func<float, float, bool> InPosExactXyOld = (xTarg, yTarg)
    =>
        xTarg == old.xPos &&
        yTarg == old.yPos;
        
    Func<float, float, bool> InPosExactXyCurrent = (xTarg, yTarg)
    =>
        xTarg == current.xPos &&
        yTarg == current.yPos;
    
    Func<float, float, bool> InPosExactXyOldOnly = (xTarg, yTarg)
    =>
        xTarg == old.xPos &&
        yTarg == old.yPos &&
        !(xTarg == current.xPos &&
          yTarg == current.yPos);
    
    Func<float, float, bool> InPosExactXyCurrentOnly = (xTarg, yTarg)
    =>
        !(xTarg == old.xPos &&
          yTarg == old.yPos) &&
        xTarg == current.xPos &&
        yTarg == current.yPos;

    Func<float, float, float, float, float, float, ValueTuple<float, float, float, float, float, float>> Bounds = (x1, x2, y1, y2, z1, z2)
        => ValueTuple.Create(x1, x2, y1, y2, z1, z2);

    Func<float, float, float, float, ValueTuple<float, float, float, float, float, float>> BoundsRange = (x, y, z, range)
        => ValueTuple.Create(x - range, x + range, y - range, y + range, z - range, z + range);
    
    Func<float, float, float, float, float, ValueTuple<float, float, float, float, float, float>> BoundsRangeXyZ = (x, y, z, xyRange, zRange)
        => ValueTuple.Create(x - xyRange, x + xyRange, y - xyRange, y + xyRange, z - zRange, z + zRange);
    
    Func<float, float, float, ValueTuple<float, float, float, float, float, float>> BoundsExact = (x, y, z)
        => ValueTuple.Create(x, x, y, y, z, z);

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
    var events = new Dictionary<string, Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>>>(); // GC
    Action<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>> AddEvent = (eventType, slug, settingSlugs, xyzBounds, condition) =>
    {
        if (events.ContainsKey(slug))
            throw new Exception("Internal exception (ASL): event " + slug + " has already been added.");
        events.Add(slug, Tuple.Create(eventType, slug, settingSlugs, xyzBounds, condition));
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

    Func<float, float, float, float, bool> CpGet = (xTarg, yTarg, zTarg, range)
    =>
        old.cpIcon < 1 && current.cpIcon >= 1 &&
        current.xPos >= xTarg - range && current.xPos <= xTarg + range &&
        current.yPos >= yTarg - range && current.yPos <= yTarg + range &&
        current.zPos >= zTarg - range && current.zPos <= zTarg + range;

    // ===================================================================================================================
    // ================================================== CONFIGURATION ==================================================
    // ===================================================================================================================

    // ================================================== settings ==================================================

    //Default:bool    Slug:string            EventSlugs:List<string>                   Description:string           ToolTip:string?                                                             ParentSlug:string?
    AddSetting(true,  "Malik",               new List<string> {"Malik"},               "Malik",                     "Split on the checkpoint where you meet Malik",                             null);
    AddSetting(true,  "PowerOfTime",         new List<string> {"PowerOfTime"},         "The Power of Time",         "Split on obtaining the Rewind power",                                      null);
    AddSetting(true,  "Works",               new List<string> {"Works"},               "The Works",                 "Split on reaching the room with the rising lever platform",                null);
    AddSetting(true,  "Courtyard",           new List<string> {"Courtyard"},           "The Courtyard",             "Split on reaching the top of the fortress courtyard",                      null);
    AddSetting(true,  "PowerOfWater",        new List<string> {"PowerOfWater"},        "The Power of Water",        "Split on obtaining the Freeze power",                                      null);
    AddSetting(true,  "Sewers",              new List<string> {"Sewers"},              "The Sewers",                "Split on the checkpoint where Summoners are introduced",                   null);
    AddSetting(true,  "Ratash",              new List<string> {"Ratash"},              "Ratash",                    "Split on finishing the Ratash chase sequence",                             null);
    AddSetting(true,  "Observatory",         new List<string> {"Observatory"},         "The Observatory",           "Split on exiting the Observatory",                                         null);
    AddSetting(true,  "PowerOfLight",        new List<string> {"PowerOfLight"},        "The Power of Light",        "Split on obtaining the Dash power",                                        null);
    AddSetting(true,  "Gardens",             new List<string> {"Gardens"},             "The Gardens",               "Split on the checkpoint where Wizards are introduced",                     null);
    AddSetting(true,  "Possession",          new List<string> {"Possession"},          "Possession",                "Split on completing the big fight before the second Ratash encounter",     null);
    AddSetting(true,  "PowerOfKnowledge",    new List<string> {"PowerOfKnowledge"},    "The Power of Knowledge",    "Split on obtaining the Memory power",                                      null);
    AddSetting(true,  "Reservoir",           new List<string> {"Reservoir"},           "The Reservoir",             "Split at the beginning of the Rekem reservoir",                            null);
    AddSetting(true,  "PowerOfRazia",        new List<string> {"PowerOfRazia"},        "The Power of Razia",        "Split when Razia becomes one with the sword",                              null);
    AddSetting(true,  "Climb",               new List<string> {"Climb"},               "The Climb",                 "Split on starting the final climb",                                        null);
    AddSetting(true,  "Storm",               new List<string> {"Storm"},               "The Storm",                 "Split on starting the journey through the storm",                          null);
    AddSetting(true,  "End",                 new List<string> {"End"},                 "The End",                   "Split on finishing the game",                                              null);

    // ================================================== events ==================================================

    Action action;
    Action<float, float, float> actionPos;
    Action<float, float, float, float> actionRange;
    Action<float, float, float, float, float> actionRangeXyZ;
    Action<float, float, float, float, float, float> actionBounds;
    Action<int[]> actionInts;

    //                                                                                                    HashParams:
    //                                                                               SettingSlugs:         (float,float,float,
    //                                   EventType:int        Slug:string             List<string>         float,float,float)?       Condition:Func<bool>
    (actionRange=(x,y,z,range)        => AddEvent(StartEvent, "Start",               new List<string> {}, BoundsRange(x,y,z,range),  () => InXBoundsCurrent(268.929f, 268.93f) && current.gameState == 4)) (269f, 161f, -147f, 5f);
    (actionRange=(x,y,z,range)        => AddEvent(ResetEvent, "Reset",               new List<string> {}, BoundsRange(x,y,z,range),  () => InXBoundsCurrent(268.929f, 268.93f) && current.gameState == 1)) (269f, 161f, -147f, 5f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "Malik",               new List<string> {}, BoundsRange(x,y,z,range),  () => CpGet(x, y, z, range))) (-37f, 231f, -148f, 10f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "PowerOfTime",         new List<string> {}, BoundsRange(x,y,z,range),  () => CpGet(x, y, z, range))) (597f, -217f, -2f, 10f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "Works",               new List<string> {}, BoundsRange(x,y,z,range),  () => CpGet(x, y, z, range))) (-513f, -408f, -167f, 10f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "Courtyard",           new List<string> {}, BoundsRange(x,y,z,range),  () => CpGet(x, y, z, range))) (-434f, -533f, -127f, 10f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "PowerOfWater",        new List<string> {}, BoundsRange(x,y,z,range),  () => CompletedEvents.Contains("PowerOfTime") && CpGet(x, y, z, range))) (519f, -227f, 6f, 10f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "Sewers",              new List<string> {}, BoundsRange(x,y,z,range),  () => CpGet(x, y, z, range))) (-228f, 245f, 20f, 10f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "Ratash",              new List<string> {}, BoundsRange(x,y,z,range),  () => CpGet(x, y, z, range))) (-406f, 403f, 64f, 10f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "Observatory",         new List<string> {}, BoundsRange(x,y,z,range),  () => CpGet(x, y, z, range))) (-510f, 460f, 104f, 10f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "PowerOfLight",        new List<string> {}, BoundsRange(x,y,z,range),  () => CompletedEvents.Contains("PowerOfWater") && CpGet(x, y, z, range))) (540f, -219f, 6f, 10f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "Gardens",             new List<string> {}, BoundsRange(x,y,z,range),  () => CpGet(x, y, z, range))) (240f, -227f, -114f, 10f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "Possession",          new List<string> {}, BoundsRange(x,y,z,range),  () => CpGet(x, y, z, range))) (89f, -477f, -83f, 1f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "PowerOfKnowledge",    new List<string> {}, BoundsRange(x,y,z,range),  () => CompletedEvents.Contains("PowerOfLight") && CpGet(x, y, z, range))) (548f, -217f, 4f, 10f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "Reservoir",           new List<string> {}, BoundsRange(x,y,z,range),  () => CpGet(x, y, z, range))) (644f, 385f, -63f, 10f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "PowerOfRazia",        new List<string> {}, BoundsRange(x,y,z,range),  () => CompletedEvents.Contains("PowerOfKnowledge") && CpGet(x, y, z, range))) (430f, 268f, -99f, 10f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "Climb",               new List<string> {}, BoundsRange(x,y,z,range),  () => CpGet(x, y, z, range))) (912f, 256f, -56f, 10f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "Storm",               new List<string> {}, BoundsRange(x,y,z,range),  () => CpGet(x, y, z, range))) (948f, -284f, 86f, 10f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "End",                 new List<string> {}, BoundsRange(x,y,z,range),  () => InPosWithRangeCurrent(x, y, z, range))) (821f, -257f, -51f, 10f);

    // ====================================================================================================================
    // ================================================== STARTUP SCRIPT ==================================================
    // ====================================================================================================================

    refreshRate = 120;

    // ================================================== apply configured setting-event links ==================================================

    // add each setting that references an event to that event's settings list,
    // or throw an exception if a setting points to an event that doesn't exist
    foreach (var setting in mySettings.Values)
    {
        foreach (string eventSlug in setting.Item3)
        {
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
    
    OtherEvents.TrimExcess();

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

    int xyzEventHashMapCapacity;
    int mapEventHashMapCapacity;
    {
        FieldInfo entriesField =
            typeof(Dictionary<int, List<Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>>>>)
            .GetField("entries", BindingFlags.NonPublic | BindingFlags.Instance);
        Array backingArray = (Array)entriesField.GetValue(XyzEventHashMap);
        xyzEventHashMapCapacity = backingArray != null ? backingArray.Length : 0;
    }
    infoBuilder.Append("XyzEventHashMap capacity: " + XyzEventHashMap.Count.ToString() + "/" + xyzEventHashMapCapacity + "\r\n");
    infoBuilder.Append("OtherEvents capacity: " + OtherEvents.Count.ToString() + "/" + OtherEvents.Capacity.ToString() + "\r\n");
    infoBuilder.Append("\r\n");

    int collisionSum = 0;
    int maxEventsPerBucket = 0;
    double avgEventsPerBucket;
    var bucketGroupsPerEventCount = new List<List<List<Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>>>>>();
    var bucketCountsPerEventCount = new List<int>();
    const int MinEventCountPerBucketToCompute = 2;
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
    avgEventsPerBucket = XyzEventHashMap.Count > 0 ? (double)collisionSum / (double)XyzEventHashMap.Count : 0.0;

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

    infoBuilder.Append("Non-hash-based events: (total=" + OtherEvents.Count + ")\r\n");
    foreach (var @event in OtherEvents)
        infoBuilder.Append("\t" + @event.Item2 + "\r\n");
    infoBuilder.Append("\r\n");

    print(infoBuilder.ToString());

    // ================================================== timing method prompt ==================================================

    if (timer.CurrentTimingMethod != TimingMethod.GameTime)
    {
        DialogResult mbox = MessageBox.Show(timer.Form,
        "Removing load/crash times requires switching to Game Time.\nWould you like to do so?",
        "LiveSplit | Prince of Persia: The Forgotten Sands",
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
    };
    vars.Init = Init;

    // ================================================== onReset ==================================================

    Action OnReset = () =>
    {
        CompletedEvents.Clear();
        print("CompletedEvents cleared.");
    };
    vars.OnReset = OnReset;

    // ================================================== update ==================================================

    var EmptyEventList = new List<Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>>>();
    Func<ExpandoObject, bool> Update = newOld =>
    {
        old = newOld;

        TriggeredEvent = null;
        int xyzHashCode = GetXyzHashCodeCurrent();
        List<Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>>> localEvents;
        XyzEventHashMap.TryGetValue(xyzHashCode, out localEvents);
        localEvents = localEvents ?? EmptyEventList;

        // Concat function means we iterate through the lists one after the other; it does not create a concatenated list
        foreach (var @event in localEvents.Concat(OtherEvents))
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

    print("pop_tfs.asl " + DateTime.Now.ToString());
}

init
{
    vars.Init(old, current, settings);
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


exit
{
    // we do not need to unpause the IGT timer because the next time the game is running, the isLoading block will run and then it will be handled there
    // however if we didn't have an isLoading block, then we would need to explicitly unpause in the init block
    timer.IsGameTimePaused = true;
}

isLoading
{
    return (current.isMenu == 0 || current.isLoading);
}
