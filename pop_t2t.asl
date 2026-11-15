state("POP3")
{
    // The Prince's coords
    float xPos          : 0x00A2A498, 0xC, 0x30;
    float yPos          : 0x00A2A498, 0xC, 0x34;
    float zPos          : 0x00A2A498, 0xC, 0x38;

    float xCam          : 0x928548;
    float yCam          : 0x928554;

    int princeAction    : 0x005EBD78, 0x30, 0x18, 0x4, 0x48, 0x7F0;
    int saveLoad        : 0x603880;
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

    Func<float, float, float, float, bool> CutsceneHit = (xTarg, yTarg, zTarg, range)
    =>
        old.princeAction != 17 && current.princeAction == 17 &&
        current.xPos >= xTarg - range && current.xPos <= xTarg + range &&
        current.yPos >= yTarg - range && current.yPos <= yTarg + range &&
        current.zPos >= zTarg - range && current.zPos <= zTarg + range;

    // ===================================================================================================================
    // ================================================== CONFIGURATION ==================================================
    // ===================================================================================================================

    refreshRate = 120;

    // ================================================== settings ==================================================

    //Default:bool    Slug:string               EventSlugs:List<string>            Description:string                           ToolTip:string?                                                                                        ParentSlug:string?
    AddSetting(false, "TheRamparts",            new List<string> {"TheRamparts"},   "The Ramparts",                               "Split after the harbor district save fountain",                                                null);
    AddSetting(false, "HarborDistrict",         new List<string> {"HarborDistrict"}, "The Harbor District",                        "Split after first palace save fountain",                                                       null);
    AddSetting(false, "ThePalace",              new List<string> {"ThePalace"},     "The Palace",                                 "Split at the end of throne room",                                                              null);
    AddSetting(false, "TrappedHallway",         new List<string> {"TrappedHallway"}, "The Trapped Hallway",                        "Split at end of trapped hallway at the cutscene",                                              null);
    AddSetting(false, "TheSewers",              new List<string> {"TheSewers"},     "The Sewers",                                 "Split on finishing the sewers dark prince section",                                            null);
    AddSetting(false, "TheSewerz",              new List<string> {"TheSewerz"},     "The Sewers (alternate)",                     "Split just before the tunnels save fountain",                                                  null);
    AddSetting(false, "TheFortress",            new List<string> {"TheFortress"},   "The Fortress",                               "Split just before entering the first Chariot",                                                 null);
    AddSetting(false, "Chariot1",               new List<string> {"Chariot1"},      "Chariot 1",                                  "Split on finishing the first chariot",                                                         null);
    AddSetting(false, "LowerCity",              new List<string> {"LowerCity"},     "The Lower City",                             "Split after the lower city dark prince section",                                               null);
    AddSetting(false, "LowerCityRooftops",      new List<string> {"LowerCityRooftops"}, "The Lower City Rooftops",                    "Split after killing Klompa",                                                                   null);
    AddSetting(false, "ArenaDeload",            new List<string> {"ArenaDeload"},   "Arena Deload",                               "Split at the black crushers in the arena dark prince section",                                 null);
    AddSetting(false, "TheBalconies",           new List<string> {"TheBalconies"},  "The Balconies",                              "Split on exiting the room with the slomo gate",                                                null);
    AddSetting(false, "DarkAlley",              new List<string> {"DarkAlley"},     "The Dark Alley",                             "Split on entering the cutscene at start of temple rooftops",                                   null);
    AddSetting(false, "TheTempleRooftops",      new List<string> {"TheTempleRooftops"}, "The Temple Rooftops",                        "Split on entering the door into temple",                                                       null);
    AddSetting(false, "TheTempleRooftopz",      new List<string> {"TheTempleRooftopz"}, "The Temple Rooftops (alternate)",            "Split on the ledge after the temple cutscene",                                                 null);
    AddSetting(false, "TheTemple",              new List<string> {"TheTemple"},     "The Temple",                                 "Split on finishing the temple dark prince section",                                            null);
    AddSetting(false, "TheMarketplace",         new List<string> {"TheMarketplace"}, "The Marketplace",                            "Split at save fountain before cutscene drop",                                                  null);
    AddSetting(false, "MarketDistrict",         new List<string> {"MarketDistrict"}, "The Market District",                        "Split at the save fountain after the long cutscene",                                           null);
    AddSetting(false, "TheBrothel",             new List<string> {"TheBrothel"},    "The Brothel",                                "Split on finishing the brothel dark prince section",                                           null);
    AddSetting(false, "ThePlaza",               new List<string> {"ThePlaza"},      "The Plaza",                                  "Split at the door after Mahasti fight",                                                        null);
    AddSetting(false, "TheUpperCity",           new List<string> {"TheUpperCity"},  "The Upper City",                             "Split just before the skippable Farah cutscene",                                               null);
    AddSetting(false, "CityGarderns",           new List<string> {"CityGarderns"},  "The City Garderns",                          "Split just before the Stone Guardian encounter",                                               null);
    AddSetting(false, "ThePromenade",           new List<string> {"ThePromenade"},  "The Promenade",                              "Split on entering the royal workshop",                                                         null);
    AddSetting(false, "RoyalWorkshop",          new List<string> {"RoyalWorkshop"}, "Royal Workshop",                             "Split on entering the king's road",                                                            null);
    AddSetting(false, "KingsRoad",              new List<string> {"KingsRoad"},     "The King's Road",                            "Split on defeating the twins",                                                                 null);
    AddSetting(false, "KingzRoad",              new List<string> {"KingzRoad"},     "The King's Road (alternate)",                "Split on the transition to palace entrance after twins fight",                                 null);
    AddSetting(false, "PalaceEntrance",         new List<string> {"PalaceEntrance"}, "The Palace Entrance",                        "Split on entering the elevator cutscene",                                                      null);
    AddSetting(false, "HangingGardens",         new List<string> {"HangingGardens"}, "The Hanging Gardens",                        "Split at the swing pole before the last sand gate",                                            null);
    AddSetting(false, "HangingGardenz",         new List<string> {"HangingGardenz"}, "The Hanging Gardens (alternate)",            "Split at the structure's mind save fountain",                                                  null);
    AddSetting(false, "StructuresMind",         new List<string> {"StructuresMind"}, "The Structure's Mind",                       "Split at the cutscene after the puzzle",                                                       null);
    AddSetting(false, "StructurezMind",         new List<string> {"StructurezMind"}, "The Structure's Mind (alternate)",           "Split after the transition to Well of Ancestors",                                              null);
    AddSetting(false, "BottomofWell",           new List<string> {"BottomofWell"},  "Bottom of the Well",                         "Split after the death abuse at the bottom of the well",                                        null);
    AddSetting(false, "WellofAncestors",        new List<string> {"WellofAncestors"}, "The Well of Ancestors",                      "Split on finishing the well dark prince section",                                              null);
    AddSetting(false, "TheLabyrinth",           new List<string> {"TheLabyrinth"},  "The Labyrinth",                              "Split on entering the underground cave after breakable wall",                                  null);
    AddSetting(false, "CaveDeath",              new List<string> {"CaveDeath"},     "Underground Cave Death",                     "Split on the death abuse at the end of underground cave (for zipping categories)",             null);
    AddSetting(false, "UndergroundCave",        new List<string> {"UndergroundCave"}, "The Underground Cave",                       "Split on entering the kitchen",                                                                null);
    AddSetting(false, "LowerTower",             new List<string> {"LowerTower"},    "The Lower Tower",                            "Split on entering the trap corridor after lower tower",                                        null);
    AddSetting(false, "MiddleTower",            new List<string> {"MiddleTower"},   "The Middle Tower",                           "Split on entering the trap corridor after middle tower",                                       null);
    AddSetting(false, "UpperTower",             new List<string> {"UpperTower"},    "The Upper Tower",                            "Split at the upper tower save fountain",                                                       null);
    AddSetting(false, "TheTerrace",             new List<string> {"TheTerrace"},    "The Terrace",                                "Split on entering the mental realm",                                                           null);
    AddSetting(false, "MentalRealm",            new List<string> {"MentalRealm"},   "The Mental Realm",                           "Split on finishing the game",                                                                  null);
    AddSetting(false, "T2TLU1",                 new List<string> {"T2TLU1"},        "Life Upgrade 1",                             "Split after obtaining the first life upgrade in Tunnels",                                      null);
    AddSetting(false, "T2TLU2",                 new List<string> {"T2TLU2"},        "Life Upgrade 2",                             "Split after obtaining the second life upgrade in Lower City Rooftops",                         null);
    AddSetting(false, "T2TLU3",                 new List<string> {"T2TLU3"},        "Life Upgrade 3",                             "Split after obtaining the third life upgrade in Temple",                                       null);
    AddSetting(false, "T2TLU4",                 new List<string> {"T2TLU4"},        "Life Upgrade 4",                             "Split after obtaining the fourth life upgrade in Tunnels",                                     null);
    AddSetting(false, "T2TLU5",                 new List<string> {"T2TLU5"},        "Life Upgrade 5",                             "Split after obtaining the fifth life upgrade in Canal",                                        null);
    AddSetting(false, "T2TLU6",                 new List<string> {"T2TLU6"},        "Life Upgrade 6",                             "Split after obtaining the sixth life upgrade in Middle Tower",                                 null);

    // ================================================== events ==================================================

    Action action;
    Action<float, float, float> actionPos;
    Action<float, float, float, float> actionRange;
    Action<float, float, float, float, float> actionRangeXyZ;
    Action<float, float, float, float, float, float> actionBounds;
    Action<int[]> actionInts;

    (actionRange=(x,y,z,range)        => AddEvent(StartEvent, "StartLoad",               new List<string> {}, BoundsRange(x,y,z,range),    () => InPosWithRangeCurrent(x, y, z, range) && old.saveLoad == 0 && current.saveLoad == 1)) (-408.3f, 116.9f, 61.9f, 0.5f);
    (actionRange=(x,y,z,range)        => AddEvent(ResetEvent, "ResetLoad",               new List<string> {}, BoundsRange(x,y,z,range),    () => InPosWithRangeCurrent(x, y, z, range) && current.saveLoad == 0)) (-408.3f, 116.9f, 61.9f, 0.5f);
    (actionRange=(x,y,z,range)        => AddEvent(StartEvent, "StartNew",                new List<string> {}, BoundsRange(x,y,z,range),    () => InXBoundsCurrent(-404.9f, -404.8f) && InBounds(0.8318f, 0.832f, current.xCam) && InBounds(0.108f, 0.1082f, current.yCam))) (-405f, 117f, 62f, 5f);
    (actionRange=(x,y,z,range)        => AddEvent(ResetEvent, "ResetNew",                new List<string> {}, BoundsRange(x,y,z,range),    () => InXBoundsCurrent(-443f, -442.9f) && current.yCam == 0)) (-443f, 123f, 57f, 5f);

    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheRamparts",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-271f, -265f, 187f, 188f, 74f, 75f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "HarborDistrict",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-93f, -88f, 236.2f, 238f, 83f, 88f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "ThePalace",               new List<string> {}, BoundsRange(x,y,z,range),    () => CutsceneHit(x, y, z, range))) (-35f, 232f, 147f, 10f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "TrappedHallway",          new List<string> {}, BoundsRange(x,y,z,range),    () => CutsceneHit(x, y, z, range))) (-52f, 134f, 76f, 10f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheSewerz",              new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-100f, -96f, -83f, -79f, 19.9f, 20f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "TheSewers",               new List<string> {}, BoundsRange(x,y,z,range),    () => CutsceneHit(x, y, z, range))) (-89f, -15f, 5f, 10f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "TheFortress",             new List<string> {}, BoundsRange(x,y,z,range),    () => CutsceneHit(x, y, z, range))) (-71f, 10f, 44f, 10f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "Chariot1",               new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-443.37f, -443.36f, 355.80f, 355.81f, 57.71f, 57.72f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "LowerCity",               new List<string> {}, BoundsRange(x,y,z,range),    () => CutsceneHit(x, y, z, range))) (-318f, 330f, 96f, 10f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "LowerCityRooftops",       new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-261.5f, -261f, 318f, 319.5f, 46f, 48f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "ArenaDeload",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-256.1f, -251.9f, 358f, 361.5f, 53.9f, 63.3f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheBalconies",            new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-194f, -190f, 328f, 329.7f, 32.6f, 33.6f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "DarkAlley",               new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-114f, -110f, 328f, 338f, 55f, 59f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheTempleRooftops",       new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-122.6f, -117.7f, 421.6f, 423f, 107f, 108.1f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheTempleRooftopz",       new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-126f, -125f, 424f, 426f, 100f, 100.1f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheTemple",               new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-213f, -210f, 419.0f, 421f, 80.5f, 82.5f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheMarketplace",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-213f, -207f, 484f, 490f, 101f, 103f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "MarketDistrict",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-185.5f, -175.5f, 524f, 530f, 90f, 92f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheBrothel",              new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-152.3f, -152.0f, 549.8f, 549.9f, 91.8f, 92f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "ThePlaza",                new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-104f, -100f, 548f, 553f, 105.5f, 106.1f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheUpperCity",            new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-124.5f, -122.5f, 500f, 505f, 97f, 99f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "CityGarderns",            new List<string> {}, BoundsRange(x,y,z,range),    () => CutsceneHit(x, y, z, range))) (-63f, 390f, 85f, 10f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "ThePromenade",            new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-3f, -1f, 515f, 519f, 72f, 75f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "RoyalWorkshop",           new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (58f, 62f, 470f, 480f, 79f, 81f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "KingsRoad",               new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (91.9289f, 91.9290f, 230.0479f, 230.0480f, 70.9877f, 70.9879f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "KingzRoad",               new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (53f, 70f, 240f, 250f, 70f, 73f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "PalaceEntrance",          new List<string> {}, BoundsRange(x,y,z,range),    () => CutsceneHit(x, y, z, range))) (31f, 271f, 126f, 10f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "HangingGardens",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (26f, 28f, 211f, 213f, 191f, 193f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "HangingGardenz",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (5.2f, 5.4f, 213.5f, 215.6f, 194.9f, 196.2f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "StructuresMind",          new List<string> {}, BoundsRange(x,y,z,range),    () => CutsceneHit(x, y, z, range))) (-30f, 245f, 179f, 10f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "StructurezMind",          new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (5f, 12f, 243f, 265f, 104f, 104.1f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "BottomofWell",            new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-21.35f, -21.34f, 252.67f, 252.68f, 20.95f, 20.96f);
    (actionRange=(x,y,z,range)        => AddEvent(SplitEvent, "WellofAncestors",         new List<string> {}, BoundsRange(x,y,z,range),    () => CutsceneHit(x, y, z, range))) (-13f, 241f, 1f, 10f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "CaveDeath",               new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (5.99f, 6.00f, 306.96f, 306.97f, 42f, 42.01f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheLabyrinth",            new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-25.5f, -23f, 325f, 338f, 35.9f, 37.5f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "UndergroundCave",         new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-11f, -9f, 327f, 334f, 73f, 74f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "LowerTower",              new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-5f, -3f, 316f, 317.5f, 139.9f, 140.1f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "MiddleTower",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-18f, -12f, 303f, 305f, 184.8f, 185.1f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "UpperTower",              new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-8f, -7f, 296f, 298f, 226.9f, 227f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheTerrace",              new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-7.2f, -6.9f, 245.6f, 245.9f, 677f, 679f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "MentalRealm",             new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2) && current.princeAction == 17)) (189f, 194f, 318f, 330f, 540f, 560f);

    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "T2TLU1",                  new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-14.9972f, -14.9970f, -112.8152f, -112.8150f, 20.0732f, 20.0734f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "T2TLU2",                  new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-302.0919f, -302.0917f, 370.8710f, 370.8712f, 52.858f, 52.8582f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "T2TLU3",                  new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-187.3369f, -187.3367f, -455.9863f, 455.9865f, 78.0330f, 78.0332f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "T2TLU4",                  new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-55.0147f, -55.0145f, 395.7608f, 395.761f, 72.0774f, 72.0776f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "T2TLU5",                  new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-30.1223f, -30.1221f, 281.8893f, 281.8895f, 104.0796f, 104.0798f);
    (actionBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "T2TLU6",                  new List<string> {}, Bounds(x1,x2,y1,y2,z1,z2), () => InPosWithBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-23.9663f, -23.9661f, 253.9438f, 253.944f, 183.0634f, 183.0636f);

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
        "LiveSplit | Prince of Persia: The Two Thrones",
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
        initCustomVariables = true;
    };
    vars.Init = Init;

    // ================================================== onReset ==================================================

    Action OnReset = () =>
    {
        CompletedEvents.Clear();
        initCustomVariables = true;
        print("CompletedEvents cleared.");
    };
    vars.OnReset = OnReset;

    // ================================================== update ==================================================

    var EmptyEventList = new List<Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>>();
    Func<ExpandoObject, bool> Update = newOld =>
    {
        old = newOld;

        initCustomVariables = false;

        TriggeredEvent = null;
        int xyzHashCode = GetXyzHashCodeCurrent();
        List<Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>> localXyzEvents;
        List<Tuple<int, string, List<string>, ValueTuple<ValueTuple<float, float, float, float, float, float>?, int[]>, Func<bool>>> localMapEvents = null;
        XyzEventHashMap.TryGetValue(xyzHashCode, out localXyzEvents);
        if (MapEventHashMap.Count > 0)
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

    print("pop_t2t.asl " + DateTime.Now.ToString());
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

