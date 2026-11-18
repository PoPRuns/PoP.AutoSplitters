state("POP3")
{
    // The Prince's coords
    float x             : 0x00A2A498, 0xC, 0x30;
    float y             : 0x00A2A498, 0xC, 0x34;
    float z             : 0x00A2A498, 0xC, 0x38;

    float xCam          : 0x928548;
    float yCam          : 0x928554;

    int princeAction    : 0x005EBD78, 0x30, 0x18, 0x4, 0x48, 0x7F0;
    int saveLoad        : 0x603880;
}

// Data structures:
// record class Setting: bool Default, string Slug, List<string> EventSlugs, string Description, string? ToolTip, string? ParentSlug
// record class Event:   int EventType, string Slug, List<string> SettingSlugs, int[]? HashCodes, Func<bool> Condition, Action<bool> PostAction

// Data structures as tuples:
// Setting: Tuple<bool, string, List<string>, string, string, string>
// Event:   Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>>

// any temporary object that is not needed after startup should be marked with a "GC" comment and set to null before startup finishes
startup
{
    // ==========================================================================================================================
    // ================================================== FUNCTION DEFINITIONS ==================================================
    // ==========================================================================================================================

    // ================================================== coordinate checks ==================================================

    Func<float, float, float, bool> InBounds = (min, max, coord) => coord >= min && coord <= max;
    Func<float, float, bool> InXBoundsOld = (min, max) => old.x >= min && old.x <= max;
    Func<float, float, bool> InYBoundsOld = (min, max) => old.y >= min && old.y <= max;
    Func<float, float, bool> InZBoundsOld = (min, max) => old.z >= min && old.z <= max;
    Func<float, float, bool> InXBoundsCurrent = (min, max) => current.x >= min && current.x <= max;
    Func<float, float, bool> InYBoundsCurrent = (min, max) => current.y >= min && current.y <= max;
    Func<float, float, bool> InZBoundsCurrent = (min, max) => current.z >= min && current.z <= max;
    Func<float, float, bool> InXBoundsOldOnly = (min, max) => old.x >= min && old.x <= max && !(current.x >= min && current.x <= max);
    Func<float, float, bool> InYBoundsOldOnly = (min, max) => old.y >= min && old.y <= max && !(current.y >= min && current.y <= max);
    Func<float, float, bool> InZBoundsOldOnly = (min, max) => old.z >= min && old.z <= max && !(current.z >= min && current.z <= max);
    Func<float, float, bool> InXBoundsCurrentOnly = (min, max) => !(old.x >= min && old.x <= max) && current.x >= min && current.x <= max;
    Func<float, float, bool> InYBoundsCurrentOnly = (min, max) => !(old.y >= min && old.y <= max) && current.y >= min && current.y <= max;
    Func<float, float, bool> InZBoundsCurrentOnly = (min, max) => !(old.z >= min && old.z <= max) && current.z >= min && current.z <= max;

    Func<float, float, float, float, float, float, float, float, float, bool> InXyzBounds = (xMin, xMax, yMin, yMax, zMin, zMax, x, y, z)
    =>
        x >= xMin && x <= xMax &&
        y >= yMin && y <= yMax &&
        z >= zMin && z <= zMax;

    Func<float, float, float, float, float, float, bool> InXyzBoundsOld = (xMin, xMax, yMin, yMax, zMin, zMax)
    =>
        old.x >= xMin && old.x <= xMax &&
        old.y >= yMin && old.y <= yMax &&
        old.z >= zMin && old.z <= zMax;

    Func<float, float, float, float, float, float, bool> InXyzBoundsCurrent = (xMin, xMax, yMin, yMax, zMin, zMax)
    =>
        current.x >= xMin && current.x <= xMax &&
        current.y >= yMin && current.y <= yMax &&
        current.z >= zMin && current.z <= zMax;

    Func<float, float, float, float, float, float, bool> InXyzBoundsOldOnly = (xMin, xMax, yMin, yMax, zMin, zMax)
    =>
        old.x >= xMin && old.x <= xMax &&
        old.y >= yMin && old.y <= yMax &&
        old.z >= zMin && old.z <= zMax &&
        !(current.x >= xMin && current.x <= xMax &&
          current.y >= yMin && current.y <= yMax &&
          current.z >= zMin && current.z <= zMax);
    
    Func<float, float, float, float, float, float, bool> InXyzBoundsCurrentOnly = (xMin, xMax, yMin, yMax, zMin, zMax)
    =>
        !(old.x >= xMin && old.x <= xMax &&
          old.y >= yMin && old.y <= yMax &&
          old.z >= zMin && old.z <= zMax) &&
        current.x >= xMin && current.x <= xMax &&
        current.y >= yMin && current.y <= yMax &&
        current.z >= zMin && current.z <= zMax;

    Func<float, float, float, bool> InRange = (targ, range, coord) => coord >= targ - range && coord <= targ + range;
    Func<float, float, bool> InXRangeOld = (targ, range) => old.x >= targ - range && old.x <= targ + range;
    Func<float, float, bool> InYRangeOld = (targ, range) => old.y >= targ - range && old.y <= targ + range;
    Func<float, float, bool> InZRangeOld = (targ, range) => old.z >= targ - range && old.z <= targ + range;
    Func<float, float, bool> InXRangeCurrent = (targ, range) => current.x >= targ - range && current.x <= targ + range;
    Func<float, float, bool> InYRangeCurrent = (targ, range) => current.y >= targ - range && current.y <= targ + range;
    Func<float, float, bool> InZRangeCurrent = (targ, range) => current.z >= targ - range && current.z <= targ + range;
    Func<float, float, bool> InXRangeOldOnly = (targ, range) => old.x >= targ - range && old.x <= targ + range && !(current.x >= targ - range && current.x <= targ + range);
    Func<float, float, bool> InYRangeOldOnly = (targ, range) => old.y >= targ - range && old.y <= targ + range && !(current.y >= targ - range && current.y <= targ + range);
    Func<float, float, bool> InZRangeOldOnly = (targ, range) => old.z >= targ - range && old.z <= targ + range && !(current.z >= targ - range && current.z <= targ + range);
    Func<float, float, bool> InXRangeCurrentOnly = (targ, range) => !(old.x >= targ - range && old.x <= targ + range) && current.x >= targ - range && current.x <= targ + range;
    Func<float, float, bool> InYRangeCurrentOnly = (targ, range) => !(old.y >= targ - range && old.y <= targ + range) && current.y >= targ - range && current.y <= targ + range;
    Func<float, float, bool> InZRangeCurrentOnly = (targ, range) => !(old.z >= targ - range && old.z <= targ + range) && current.z >= targ - range && current.z <= targ + range;

    Func<float, float, float, bool> InXyRangeOld = (xTarg, yTarg, range)
    =>
        old.x >= xTarg - range && old.x <= xTarg + range &&
        old.y >= yTarg - range && old.y <= yTarg + range;
    
    Func<float, float, float, bool> InXyRangeCurrent = (xTarg, yTarg, range)
    =>
        current.x >= xTarg - range && current.x <= xTarg + range &&
        current.y >= yTarg - range && current.y <= yTarg + range;

    Func<float, float, float, bool> InXyRangeOldOnly = (xTarg, yTarg, range)
    =>
        old.x >= xTarg - range && old.x <= xTarg + range &&
        old.y >= yTarg - range && old.y <= yTarg + range &&
        !(current.x >= xTarg - range && current.x <= xTarg + range &&
          current.y >= yTarg - range && current.y <= yTarg + range);

    Func<float, float, float, bool> InXyRangeCurrentOnly = (xTarg, yTarg, range)
    =>
        !(old.x >= xTarg - range && old.x <= xTarg + range &&
          old.y >= yTarg - range && old.y <= yTarg + range) &&
        current.x >= xTarg - range && current.x <= xTarg + range &&
        current.y >= yTarg - range && current.y <= yTarg + range;

    Func<float, float, float, float, float, float, float, bool> InXyzRange = (xTarg, yTarg, zTarg, range, x, y, z)
    =>
        x >= xTarg - range && x <= xTarg + range &&
        y >= yTarg - range && y <= yTarg + range &&
        z >= zTarg - range && z <= zTarg + range;

    Func<float, float, float, float, bool> InXyzRangeOld = (xTarg, yTarg, zTarg, range)
    =>
        old.x >= xTarg - range && old.x <= xTarg + range &&
        old.y >= yTarg - range && old.y <= yTarg + range &&
        old.z >= zTarg - range && old.z <= zTarg + range;

    Func<float, float, float, float, bool> InXyzRangeCurrent = (xTarg, yTarg, zTarg, range)
    =>
        current.x >= xTarg - range && current.x <= xTarg + range &&
        current.y >= yTarg - range && current.y <= yTarg + range &&
        current.z >= zTarg - range && current.z <= zTarg + range;

    Func<float, float, float, float, bool> InXyzRangeOldOnly = (xTarg, yTarg, zTarg, range)
    =>
        old.x >= xTarg - range && old.x <= xTarg + range &&
        old.y >= yTarg - range && old.y <= yTarg + range &&
        old.z >= zTarg - range && old.z <= zTarg + range &&
        !(current.x >= xTarg - range && current.x <= xTarg + range &&
          current.y >= yTarg - range && current.y <= yTarg + range &&
          current.z >= zTarg - range && current.z <= zTarg + range);

    Func<float, float, float, float, bool> InXyzRangeCurrentOnly = (xTarg, yTarg, zTarg, range)
    =>
        !(old.x >= xTarg - range && old.x <= xTarg + range &&
          old.y >= yTarg - range && old.y <= yTarg + range &&
          old.z >= zTarg - range && old.z <= zTarg + range) &&
        current.x >= xTarg - range && current.x <= xTarg + range &&
        current.y >= yTarg - range && current.y <= yTarg + range &&
        current.z >= zTarg - range && current.z <= zTarg + range;

    Func<float, float, float, float, float, float, float, float, bool> InXyZRange = (xTarg, yTarg, zTarg, xyRange, zRange, x, y, z)
    =>
        x >= xTarg - xyRange && x <= xTarg + xyRange &&
        y >= yTarg - xyRange && y <= yTarg + xyRange &&
        z >= zTarg - zRange && z <= zTarg + zRange;
    
    Func<float, float, float, float, float, bool> InXyZRangeOld = (xTarg, yTarg, zTarg, xyRange, zRange)
    =>
        old.x >= xTarg - xyRange && old.x <= xTarg + xyRange &&
        old.y >= yTarg - xyRange && old.y <= yTarg + xyRange &&
        old.z >= zTarg - zRange && old.z <= zTarg + zRange;
    
    Func<float, float, float, float, float, bool> InXyZRangeCurrent = (xTarg, yTarg, zTarg, xyRange, zRange)
    =>
        current.x >= xTarg - xyRange && current.x <= xTarg + xyRange &&
        current.y >= yTarg - xyRange && current.y <= yTarg + xyRange &&
        current.z >= zTarg - zRange && current.z <= zTarg + zRange;

    Func<float, float, float, float, float, bool> InXyZRangeOldOnly = (xTarg, yTarg, zTarg, xyRange, zRange)
    =>
        old.x >= xTarg - xyRange && old.x <= xTarg + xyRange &&
        old.y >= yTarg - xyRange && old.y <= yTarg + xyRange &&
        old.z >= zTarg - zRange && old.z <= zTarg + zRange &&
        !(current.x >= xTarg - xyRange && current.x <= xTarg + xyRange &&
          current.y >= yTarg - xyRange && current.y <= yTarg + xyRange &&
          current.z >= zTarg - zRange && current.z <= zTarg + zRange);

    Func<float, float, float, float, float, bool> InXyZRangeCurrentOnly = (xTarg, yTarg, zTarg, xyRange, zRange)
    =>
        !(old.x >= xTarg - xyRange && old.x <= xTarg + xyRange &&
          old.y >= yTarg - xyRange && old.y <= yTarg + xyRange &&
          old.z >= zTarg - zRange && old.z <= zTarg + zRange) &&
        current.x >= xTarg - xyRange && current.x <= xTarg + xyRange &&
        current.y >= yTarg - xyRange && current.y <= yTarg + xyRange &&
        current.z >= zTarg - zRange && current.z <= zTarg + zRange;

    Func<float, float, float, float, float, float, bool> InXyzExact = (xTarg, yTarg, zTarg, x, y, z)
    =>
        xTarg == x &&
        yTarg == y &&
        zTarg == z;

    Func<float, float, float, bool> InXyzExactOld = (xTarg, yTarg, zTarg)
    =>
        xTarg == old.x &&
        yTarg == old.y &&
        zTarg == old.z;
        
    Func<float, float, float, bool> InXyzExactCurrent = (xTarg, yTarg, zTarg)
    =>
        xTarg == current.x &&
        yTarg == current.y &&
        zTarg == current.z;
    
    Func<float, float, float, bool> InXyzExactOldOnly = (xTarg, yTarg, zTarg)
    =>
        xTarg == old.x &&
        yTarg == old.y &&
        zTarg == old.z &&
        !(xTarg == current.x &&
          yTarg == current.y &&
          zTarg == current.z);

    Func<float, float, float, bool> InXyzExactCurrentOnly = (xTarg, yTarg, zTarg)
    =>
        !(xTarg == old.x &&
          yTarg == old.y &&
          zTarg == old.z) &&
        xTarg == current.x &&
        yTarg == current.y &&
        zTarg == current.z;
    
    Func<float, float, float, float, bool> InXyExact = (xTarg, yTarg, x, y)
    =>
        xTarg == x &&
        yTarg == y;
    
    Func<float, float, bool> InXyExactOld = (xTarg, yTarg)
    =>
        xTarg == old.x &&
        yTarg == old.y;
        
    Func<float, float, bool> InXyExactCurrent = (xTarg, yTarg)
    =>
        xTarg == current.x &&
        yTarg == current.y;
    
    Func<float, float, bool> InXyExactOldOnly = (xTarg, yTarg)
    =>
        xTarg == old.x &&
        yTarg == old.y &&
        !(xTarg == current.x &&
          yTarg == current.y);
    
    Func<float, float, bool> InXyExactCurrentOnly = (xTarg, yTarg)
    =>
        !(xTarg == old.x &&
          yTarg == old.y) &&
        xTarg == current.x &&
        yTarg == current.y;

    // ================================================== runtime hash code computations ==================================================

    // general hashing

    const uint FnvPrime = 0x01000193;   // https://en.wikipedia.org/wiki/Fowler%E2%80%93Noll%E2%80%93Vo_hash_function#FNV_prime

    // xyz hashing

    // see the hashing section in DOCUMENTATION.md for guidance on what bucket size to choose for each game
    const float BucketSize = 20f; // <---------------------------------------------------------------------------------------------------- game-specific

    const uint XyzSeed = 17;
    Func<int> GetXyzHashCodeCurrent = () =>
    {
        uint hash = XyzSeed;
        hash = hash * FnvPrime + (uint)(int)Math.Floor(current.x / BucketSize);
        hash = hash * FnvPrime + (uint)(int)Math.Floor(current.y / BucketSize);
        hash = hash * FnvPrime + (uint)(int)Math.Floor(current.z / BucketSize);
        return (int)hash;
    };

    // ================================================== one-time hash code computations ==================================================

    // general hashing

    // do not call at run time; rather make a separate runtime version of this method that uses a const seed and unrolls the loop and inlines individual hash code computations
    // e.g. see GetXyzHashCodeCurrent above; seed should be a different prime number for each implementation, (optimally of the form 2^n +/- 1, but it's not a big deal)
    Func<uint, int[], int> ScrambleHashCodes = (seed, hashCodes) =>
    {
        uint hash = seed;
        foreach (int hashCode in hashCodes)
            hash = hash * FnvPrime + (uint)hashCode;
        return (int)hash;
    };

    Func<uint, int[], int[]> HashHashes = (seed, weakHashes) => weakHashes.Select(weakHash => ScrambleHashCodes(seed, new int[] {weakHash})).ToArray();

    // xyz hashing

    Func<float, int> GetCoordHashCode = coord => (int)Math.Floor(coord / BucketSize);

    Func<float, float, float, float, float, float, int[]> HashXyzBounds = (xMin, xMax, yMin, yMax, zMin, zMax) =>
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
                    int hashCode = ScrambleHashCodes(XyzSeed, new int[] {xHashCode, yHashCode, zHashCode});
                    hashCodes[index] = hashCode;
                    index++;
                }
            }
        }
        return hashCodes;
    };

    Func<float, float, float, float, int[]> HashXyzRange = (x, y, z, range) => HashXyzBounds(x - range, x + range, y - range, y + range, z - range, z + range);
    Func<float, float, float, float, float, int[]> HashXyZRange = (x, y, z, xyRange, zRange) => HashXyzBounds(x - xyRange, x + xyRange, y - xyRange, y + xyRange, z - zRange, z + zRange);
    Func<float, float, float, int[]> HashXyzExact = (x, y, z) => HashXyzBounds(x, x, y, y, z, z);

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
    
    const int StartEvent = 0;
    const int ResetEvent = 1;
    const int SplitEvent = 2;
    const int MiscEvent = 3;

    const int NoGame = 0;
    const int T2T = 1;
    const int GameCount = 2; // <---------------------------------------------------------------------------------------------------- game-specific (and AddEvent overloads, GetGameTypeString below)

    // Key: EventSlug; Value: Event
    var eventMaps = new Dictionary<string, Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>>>[GameCount]; // GC
    for (int i = 0; i < GameCount; i++)
        eventMaps[i] = new Dictionary<string, Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>>>();
    var events = new Dictionary<string, Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>>>(); // GC
    Action<bool> emptyPostAction = _ => { };
    Action<int, string, List<string>, int[], Func<bool>, Action<bool>, int> AddEventBase =
        (eventType, slug, settingSlugs, hashCodes, condition, postAction, gameType) =>
    {
        if (events.ContainsKey(slug))
            throw new Exception("Internal exception (ASL): event " + slug + " has already been added.");
        Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>> myEvent =
            Tuple.Create(eventType, slug, settingSlugs, hashCodes, condition, postAction);
        events.Add(slug, myEvent);
        eventMaps[gameType].Add(slug, myEvent);
    };

    Action<int, string, List<string>, int[], Func<bool>> AddEvent = (eventType, slug, settingSlugs, hashCodes, condition)
        => AddEventBase(eventType, slug, settingSlugs, hashCodes, condition, emptyPostAction, T2T);
    
    Action<int, string, List<string>, int[], Func<bool>, Action<bool>> AddEvent_ = 
        (eventType, slug, settingSlugs, hashCodes, condition, postAction)
        => AddEventBase(eventType, slug, settingSlugs, hashCodes, condition, postAction, T2T);
    
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

    Func<int, string> GetGameTypeString = gameType =>
    {
        switch (gameType)
        {
        case NoGame: return "NoGame";
        case T2T:    return "T2T";
        default:     return "UnknownGame";
        }
    };

    // ================================================== runtime functions and helper variables ==================================================

    // Key: Hash; Value: EventList
    var EventHashMaps = new Dictionary<int, List<Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>>>>[GameCount];
    for (int i = 0; i < GameCount; i++)
        EventHashMaps[i] = new Dictionary<int, List<Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>>>>();
    var EventHashMap = EventHashMaps[NoGame];

    // List<Event>
    var OtherEventLists = new List<Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>>>[GameCount];
    for (int i = 0; i < GameCount; i++)
        OtherEventLists[i] = new List<Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>>>();
    var OtherEvents = OtherEventLists[NoGame];

    int CurrentGame = NoGame;
    Action<int> ConfigureGameType = gameType =>
    {
        CurrentGame = gameType;
        EventHashMap = EventHashMaps[gameType];
        OtherEvents = OtherEventLists[gameType];
        print("Configuration for " + GetGameTypeString(gameType) + " done.");
    };

    HashSet<string> CompletedEvents = null;

    // update block sets this to an event that is not in CompletedEvents and has been triggered on this cycle
    Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>> TriggeredEvent = null;

    Action OnReset = null;
    Func<int, bool> CheckEvent = eventType =>
    {
        if (TriggeredEvent == null)
            return false;
        if (TriggeredEvent.Item1 != eventType)
            return false;
        bool eventTypeEnabled = true;
        switch (eventType)
        {
        case StartEvent: eventTypeEnabled = settings.StartEnabled; break;
        case ResetEvent: eventTypeEnabled = settings.ResetEnabled; break;
        case SplitEvent: eventTypeEnabled = settings.SplitEnabled; break;
        }
        bool eventSetting = false;
        if (eventTypeEnabled)
        {
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
        }
        CompletedEvents.Add(TriggeredEvent.Item2);
        TriggeredEvent.Item6(eventSetting);
        print(GetEventString(eventType) + " " + TriggeredEvent.Item2 + " " + eventSetting);
        if (eventType == StartEvent && !eventSetting) // if start is not enabled then the timer won't start and so a reset will never happen,
            OnReset(); // and then start won't work even when it does get enabled; so we manually simulate a reset condition to clear CompletedEvents
        return eventSetting;
    };

    // ================================================== game-specific functions and helper variables ==================================================

    Func<float, float, float, float, bool> IsCutsceneHit = (xTarg, yTarg, zTarg, range)
    =>
        old.princeAction != 17 && current.princeAction == 17 &&
        current.x >= xTarg - range && current.x <= xTarg + range &&
        current.y >= yTarg - range && current.y <= yTarg + range &&
        current.z >= zTarg - range && current.z <= zTarg + range;

    // ===================================================================================================================
    // ================================================== CONFIGURATION ==================================================
    // ===================================================================================================================

    // ================================================== settings ==================================================

    //Default:bool    Slug:string          EventSlugs:List<string>                 Description:string                  ToolTip:string?                                                                     ParentSlug:string?
    AddSetting(false, "TheRamparts",       new List<string> {"TheRamparts"},       "The Ramparts",                     "Split after the harbor district save fountain",                                    null);
    AddSetting(false, "HarborDistrict",    new List<string> {"HarborDistrict"},    "The Harbor District",              "Split after first palace save fountain",                                           null);
    AddSetting(false, "ThePalace",         new List<string> {"ThePalace"},         "The Palace",                       "Split at the end of throne room",                                                  null);
    AddSetting(false, "TrappedHallway",    new List<string> {"TrappedHallway"},    "The Trapped Hallway",              "Split at end of trapped hallway at the cutscene",                                  null);
    AddSetting(false, "TheSewers",         new List<string> {"TheSewers"},         "The Sewers",                       "Split on finishing the sewers dark prince section",                                null);
    AddSetting(false, "TheSewerz",         new List<string> {"TheSewerz"},         "The Sewers (alternate)",           "Split just before the tunnels save fountain",                                      null);
    AddSetting(false, "TheFortress",       new List<string> {"TheFortress"},       "The Fortress",                     "Split just before entering the first Chariot",                                     null);
    AddSetting(false, "Chariot1",          new List<string> {"Chariot1"},          "Chariot 1",                        "Split on finishing the first chariot",                                             null);
    AddSetting(false, "LowerCity",         new List<string> {"LowerCity"},         "The Lower City",                   "Split after the lower city dark prince section",                                   null);
    AddSetting(false, "LowerCityRooftops", new List<string> {"LowerCityRooftops"}, "The Lower City Rooftops",          "Split after killing Klompa",                                                       null);
    AddSetting(false, "ArenaDeload",       new List<string> {"ArenaDeload"},       "Arena Deload",                     "Split at the black crushers in the arena dark prince section",                     null);
    AddSetting(false, "TheBalconies",      new List<string> {"TheBalconies"},      "The Balconies",                    "Split on exiting the room with the slomo gate",                                    null);
    AddSetting(false, "DarkAlley",         new List<string> {"DarkAlley"},         "The Dark Alley",                   "Split on entering the cutscene at start of temple rooftops",                       null);
    AddSetting(false, "TheTempleRooftops", new List<string> {"TheTempleRooftops"}, "The Temple Rooftops",              "Split on entering the door into temple",                                           null);
    AddSetting(false, "TheTempleRooftopz", new List<string> {"TheTempleRooftopz"}, "The Temple Rooftops (alternate)",  "Split on the ledge after the temple cutscene",                                     null);
    AddSetting(false, "TheTemple",         new List<string> {"TheTemple"},         "The Temple",                       "Split on finishing the temple dark prince section",                                null);
    AddSetting(false, "TheMarketplace",    new List<string> {"TheMarketplace"},    "The Marketplace",                  "Split at save fountain before cutscene drop",                                      null);
    AddSetting(false, "MarketDistrict",    new List<string> {"MarketDistrict"},    "The Market District",              "Split at the save fountain after the long cutscene",                               null);
    AddSetting(false, "TheBrothel",        new List<string> {"TheBrothel"},        "The Brothel",                      "Split on finishing the brothel dark prince section",                               null);
    AddSetting(false, "ThePlaza",          new List<string> {"ThePlaza"},          "The Plaza",                        "Split at the door after Mahasti fight",                                            null);
    AddSetting(false, "TheUpperCity",      new List<string> {"TheUpperCity"},      "The Upper City",                   "Split just before the skippable Farah cutscene",                                   null);
    AddSetting(false, "CityGarderns",      new List<string> {"CityGarderns"},      "The City Garderns",                "Split just before the Stone Guardian encounter",                                   null);
    AddSetting(false, "ThePromenade",      new List<string> {"ThePromenade"},      "The Promenade",                    "Split on entering the royal workshop",                                             null);
    AddSetting(false, "RoyalWorkshop",     new List<string> {"RoyalWorkshop"},     "Royal Workshop",                   "Split on entering the king's road",                                                null);
    AddSetting(false, "KingsRoad",         new List<string> {"KingsRoad"},         "The King's Road",                  "Split on defeating the twins",                                                     null);
    AddSetting(false, "KingzRoad",         new List<string> {"KingzRoad"},         "The King's Road (alternate)",      "Split on the transition to palace entrance after twins fight",                     null);
    AddSetting(false, "PalaceEntrance",    new List<string> {"PalaceEntrance"},    "The Palace Entrance",              "Split on entering the elevator cutscene",                                          null);
    AddSetting(false, "HangingGardens",    new List<string> {"HangingGardens"},    "The Hanging Gardens",              "Split at the swing pole before the last sand gate",                                null);
    AddSetting(false, "HangingGardenz",    new List<string> {"HangingGardenz"},    "The Hanging Gardens (alternate)",  "Split at the structure's mind save fountain",                                      null);
    AddSetting(false, "StructuresMind",    new List<string> {"StructuresMind"},    "The Structure's Mind",             "Split at the cutscene after the puzzle",                                           null);
    AddSetting(false, "StructurezMind",    new List<string> {"StructurezMind"},    "The Structure's Mind (alternate)", "Split after the transition to Well of Ancestors",                                  null);
    AddSetting(false, "BottomofWell",      new List<string> {"BottomofWell"},      "Bottom of the Well",               "Split after the death abuse at the bottom of the well",                            null);
    AddSetting(false, "WellofAncestors",   new List<string> {"WellofAncestors"},   "The Well of Ancestors",            "Split on finishing the well dark prince section",                                  null);
    AddSetting(false, "TheLabyrinth",      new List<string> {"TheLabyrinth"},      "The Labyrinth",                    "Split on entering the underground cave after breakable wall",                      null);
    AddSetting(false, "CaveDeath",         new List<string> {"CaveDeath"},         "Underground Cave Death",           "Split on the death abuse at the end of underground cave (for zipping categories)", null);
    AddSetting(false, "UndergroundCave",   new List<string> {"UndergroundCave"},   "The Underground Cave",             "Split on entering the kitchen",                                                    null);
    AddSetting(false, "LowerTower",        new List<string> {"LowerTower"},        "The Lower Tower",                  "Split on entering the trap corridor after lower tower",                            null);
    AddSetting(false, "MiddleTower",       new List<string> {"MiddleTower"},       "The Middle Tower",                 "Split on entering the trap corridor after middle tower",                           null);
    AddSetting(false, "UpperTower",        new List<string> {"UpperTower"},        "The Upper Tower",                  "Split at the upper tower save fountain",                                           null);
    AddSetting(false, "TheTerrace",        new List<string> {"TheTerrace"},        "The Terrace",                      "Split on entering the mental realm",                                               null);
    AddSetting(false, "MentalRealm",       new List<string> {"MentalRealm"},       "The Mental Realm",                 "Split on finishing the game",                                                      null);
    AddSetting(false, "T2TLU1",            new List<string> {"T2TLU1"},            "Life Upgrade 1",                   "Split after obtaining the first life upgrade in Tunnels",                          null);
    AddSetting(false, "T2TLU2",            new List<string> {"T2TLU2"},            "Life Upgrade 2",                   "Split after obtaining the second life upgrade in Lower City Rooftops",             null);
    AddSetting(false, "T2TLU3",            new List<string> {"T2TLU3"},            "Life Upgrade 3",                   "Split after obtaining the third life upgrade in Temple",                           null);
    AddSetting(false, "T2TLU4",            new List<string> {"T2TLU4"},            "Life Upgrade 4",                   "Split after obtaining the fourth life upgrade in Tunnels",                         null);
    AddSetting(false, "T2TLU5",            new List<string> {"T2TLU5"},            "Life Upgrade 5",                   "Split after obtaining the fifth life upgrade in Canal",                            null);
    AddSetting(false, "T2TLU6",            new List<string> {"T2TLU6"},            "Life Upgrade 6",                   "Split after obtaining the sixth life upgrade in Middle Tower",                     null);

    // ================================================== events ==================================================

    Action action;
    Action<float, float, float> actionXyz;
    Action<float, float, float, float> actionXyzRange;
    Action<float, float, float, float, float> actionXyZRange;
    Action<float, float, float, float, float, float> actionXyzBounds;
    Action<int[]> actionInts;

    //                                                                                SettingSlugs:
    //                                      EventType:int        Slug:string           List<string>        HashCodes:int[]?                  Condition:Func<bool>
    (actionXyzRange=(x,y,z,range)        => AddEvent(StartEvent, "StartLoad",         new List<string> {}, HashXyzRange(x,y,z,range),        () => InXyzRangeCurrent(x, y, z, range) && old.saveLoad == 0 && current.saveLoad == 1)) (-408.3f, 116.9f, 61.9f, 0.5f);
    (actionXyzRange=(x,y,z,range)        => AddEvent(ResetEvent, "ResetLoad",         new List<string> {}, HashXyzRange(x,y,z,range),        () => InXyzRangeCurrent(x, y, z, range) && current.saveLoad == 0)) (-408.3f, 116.9f, 61.9f, 0.5f);
    (actionXyzRange=(x,y,z,range)        => AddEvent(StartEvent, "StartNew",          new List<string> {}, HashXyzRange(x,y,z,range),        () => InXBoundsCurrent(-404.9f, -404.8f) && InBounds(0.8318f, 0.832f, current.xCam) && InBounds(0.108f, 0.1082f, current.yCam) && !(InXBoundsOld(-404.9f, -404.8f) && InBounds(0.8318f, 0.832f, old.xCam) && InBounds(0.108f, 0.1082f, old.yCam)))) (-405f, 117f, 62f, 5f);
    (actionXyzRange=(x,y,z,range)        => AddEvent(ResetEvent, "ResetNew",          new List<string> {}, HashXyzRange(x,y,z,range),        () => InXBoundsCurrent(-443f, -442.9f) && current.yCam == 0)) (-443f, 123f, 57f, 5f);

    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheRamparts",       new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-271f, -265f, 187f, 188f, 74f, 75f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "HarborDistrict",    new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-93f, -88f, 236.2f, 238f, 83f, 88f);
    (actionXyzRange=(x,y,z,range)        => AddEvent(SplitEvent, "ThePalace",         new List<string> {}, HashXyzRange(x,y,z,range),        () => IsCutsceneHit(x, y, z, range))) (-35f, 232f, 147f, 10f);
    (actionXyzRange=(x,y,z,range)        => AddEvent(SplitEvent, "TrappedHallway",    new List<string> {}, HashXyzRange(x,y,z,range),        () => IsCutsceneHit(x, y, z, range))) (-52f, 134f, 76f, 10f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheSewerz",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-100f, -96f, -83f, -79f, 19.9f, 20f);
    (actionXyzRange=(x,y,z,range)        => AddEvent(SplitEvent, "TheSewers",         new List<string> {}, HashXyzRange(x,y,z,range),        () => IsCutsceneHit(x, y, z, range))) (-89f, -15f, 5f, 10f);
    (actionXyzRange=(x,y,z,range)        => AddEvent(SplitEvent, "TheFortress",       new List<string> {}, HashXyzRange(x,y,z,range),        () => IsCutsceneHit(x, y, z, range))) (-71f, 10f, 44f, 10f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "Chariot1",          new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-443.37f, -443.36f, 355.80f, 355.81f, 57.71f, 57.72f);
    (actionXyzRange=(x,y,z,range)        => AddEvent(SplitEvent, "LowerCity",         new List<string> {}, HashXyzRange(x,y,z,range),        () => IsCutsceneHit(x, y, z, range))) (-318f, 330f, 96f, 10f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "LowerCityRooftops", new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-261.5f, -261f, 318f, 319.5f, 46f, 48f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "ArenaDeload",       new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-256.1f, -251.9f, 358f, 361.5f, 53.9f, 63.3f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheBalconies",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-194f, -190f, 328f, 329.7f, 32.6f, 33.6f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "DarkAlley",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-114f, -110f, 328f, 338f, 55f, 59f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheTempleRooftops", new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-122.6f, -117.7f, 421.6f, 423f, 107f, 108.1f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheTempleRooftopz", new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-126f, -125f, 424f, 426f, 100f, 100.1f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheTemple",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-213f, -210f, 419.0f, 421f, 80.5f, 82.5f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheMarketplace",    new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-213f, -207f, 484f, 490f, 101f, 103f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "MarketDistrict",    new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-185.5f, -175.5f, 524f, 530f, 90f, 92f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheBrothel",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-152.3f, -152.0f, 549.8f, 549.9f, 91.8f, 92f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "ThePlaza",          new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-104f, -100f, 548f, 553f, 105.5f, 106.1f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheUpperCity",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-124.5f, -122.5f, 500f, 505f, 97f, 99f);
    (actionXyzRange=(x,y,z,range)        => AddEvent(SplitEvent, "CityGarderns",      new List<string> {}, HashXyzRange(x,y,z,range),        () => IsCutsceneHit(x, y, z, range))) (-63f, 390f, 85f, 10f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "ThePromenade",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-3f, -1f, 515f, 519f, 72f, 75f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "RoyalWorkshop",     new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (58f, 62f, 470f, 480f, 79f, 81f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "KingsRoad",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (91.9289f, 91.9290f, 230.0479f, 230.0480f, 70.9877f, 70.9879f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "KingzRoad",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (53f, 70f, 240f, 250f, 70f, 73f);
    (actionXyzRange=(x,y,z,range)        => AddEvent(SplitEvent, "PalaceEntrance",    new List<string> {}, HashXyzRange(x,y,z,range),        () => IsCutsceneHit(x, y, z, range))) (31f, 271f, 126f, 10f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "HangingGardens",    new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (26f, 28f, 211f, 213f, 191f, 193f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "HangingGardenz",    new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (5.2f, 5.4f, 213.5f, 215.6f, 194.9f, 196.2f);
    (actionXyzRange=(x,y,z,range)        => AddEvent(SplitEvent, "StructuresMind",    new List<string> {}, HashXyzRange(x,y,z,range),        () => IsCutsceneHit(x, y, z, range))) (-30f, 245f, 179f, 10f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "StructurezMind",    new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (5f, 12f, 243f, 265f, 104f, 104.1f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "BottomofWell",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-21.35f, -21.34f, 252.67f, 252.68f, 20.95f, 20.96f);
    (actionXyzRange=(x,y,z,range)        => AddEvent(SplitEvent, "WellofAncestors",   new List<string> {}, HashXyzRange(x,y,z,range),        () => IsCutsceneHit(x, y, z, range))) (-13f, 241f, 1f, 10f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "CaveDeath",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (5.99f, 6.00f, 306.96f, 306.97f, 42f, 42.01f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheLabyrinth",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-25.5f, -23f, 325f, 338f, 35.9f, 37.5f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "UndergroundCave",   new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-11f, -9f, 327f, 334f, 73f, 74f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "LowerTower",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-5f, -3f, 316f, 317.5f, 139.9f, 140.1f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "MiddleTower",       new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-18f, -12f, 303f, 305f, 184.8f, 185.1f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "UpperTower",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-8f, -7f, 296f, 298f, 226.9f, 227f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "TheTerrace",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-7.2f, -6.9f, 245.6f, 245.9f, 677f, 679f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "MentalRealm",       new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2) && current.princeAction == 17)) (189f, 194f, 318f, 330f, 540f, 560f);

    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "T2TLU1",            new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-14.9972f, -14.9970f, -112.8152f, -112.8150f, 20.0732f, 20.0734f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "T2TLU2",            new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-302.0919f, -302.0917f, 370.8710f, 370.8712f, 52.858f, 52.8582f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "T2TLU3",            new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-187.3369f, -187.3367f, -455.9863f, 455.9865f, 78.0330f, 78.0332f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "T2TLU4",            new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-55.0147f, -55.0145f, 395.7608f, 395.761f, 72.0774f, 72.0776f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "T2TLU5",            new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-30.1223f, -30.1221f, 281.8893f, 281.8895f, 104.0796f, 104.0798f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "T2TLU6",            new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-23.9663f, -23.9661f, 253.9438f, 253.944f, 183.0634f, 183.0636f);

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
            // for some reason if a type declaration has both a "?" and an "@" it breaks the colour scheme for the rest of the script when using the VSCode ASL plugin
            // which is why here specifically we name the variable "myEvent" instead of "@event"
            Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>> myEvent;
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

    // fill EventHashMap and OtherEvents for each game type
    int myGameType = -1;
    foreach (var @event in eventMaps.SelectMany(eventMap => { myGameType++; return eventMap.Values; }))
    {
        var eventHashMap = EventHashMaps[myGameType];
        var otherEvents = OtherEventLists[myGameType];
        if (@event.Item4 == null)
        {
            otherEvents.Add(@event);
            continue;
        }
        foreach (int hashCode in @event.Item4)
        {
            List<Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>>> localEvents;
            if (eventHashMap.TryGetValue(hashCode, out localEvents))
            {
                localEvents.Add(@event);
                continue;
            }
            eventHashMap.Add(hashCode, new List<Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>>> {@event});
        }
    }

    // since most of the lists in EventHashMap contain only one value and likely have a capacity of 4, it is worth reducing the capacity of the lists
    //      to the actual desired size and reduce memory usage from these lists by almost 4 times
    foreach (var bucket in EventHashMaps.SelectMany(eventMap => eventMap.Values))
        bucket.TrimExcess();
    
    foreach (var bucket in OtherEventLists)
        bucket.TrimExcess();

    // allocate a large enough capacity at startup so that the CompletedEvents hashset does not need to be reallocated as it grows during runtime
    CompletedEvents = new HashSet<string>(events.Count);

    // ================================================== debug ==================================================

    var infoBuilder = new StringBuilder(); // GC
    var settingsWithNoEvents = new List<string>(); // GC
    var eventsWithNoSettings = new List<string>(); // GC

    infoBuilder.AppendLine();

    // settings and events

    infoBuilder.AppendLine("Settings detected:");
    infoBuilder.AppendLine("\t" + "{Default} {Setting}".PadRight(36) + " : " + "{Parent}".PadRight(30) + " => {Count:[..Events]}");
    foreach (var setting in mySettings.Values)
    {
        if (setting.Item3.Count == 0)
            settingsWithNoEvents.Add(setting.Item2);
        infoBuilder.AppendLine("\t" + setting.Item1.ToString().PadRight(5) + " " + setting.Item2.PadRight(30) + " : " + (setting.Item6 ?? "{null}").PadRight(30)
            + " => " + setting.Item3.Count + ":[" + string.Join(", ", setting.Item3) + "]");
    }
    infoBuilder.AppendLine("Total settings: " + mySettings.Count);
    infoBuilder.AppendLine();

    infoBuilder.AppendLine("Events detected:");
    infoBuilder.AppendLine("\t" + "{EventType}     {Event}".PadRight(46) + " {HasHash} => {Count:[..Settings]}");
    foreach (var @event in events.Values)
    {
        if (@event.Item3.Count == 0)
            eventsWithNoSettings.Add(@event.Item2);
        infoBuilder.AppendLine("\t" + GetEventString(@event.Item1).PadRight(15) + " " + @event.Item2.PadRight(30) + " " + (@event.Item4 != null).ToString().PadRight(5)
            + " => " + @event.Item3.Count + ":[" + string.Join(", ", @event.Item3) + "]");
    }
    infoBuilder.AppendLine("Total events: " + events.Count);
    infoBuilder.AppendLine();

    infoBuilder.AppendLine("Settings with no events: (total=" + settingsWithNoEvents.Count + ")");
    foreach (string settingSlug in settingsWithNoEvents)
        infoBuilder.AppendLine("\t" + settingSlug);
    infoBuilder.AppendLine();
    
    infoBuilder.AppendLine("Events with no settings: (total=" + eventsWithNoSettings.Count + ")");
    foreach (string eventSlug in eventsWithNoSettings)
        infoBuilder.AppendLine("\t" + eventSlug);
    infoBuilder.AppendLine();

    // buckets

    infoBuilder.AppendLine("Bucket size: " + BucketSize);
    infoBuilder.AppendLine();

    for (myGameType = 0; myGameType < GameCount; myGameType++)
    {
        if (myGameType == NoGame)
            continue;
        
        infoBuilder.AppendLine(GetGameTypeString(myGameType) + ":");
        infoBuilder.AppendLine();

        var eventHashMap = EventHashMaps[myGameType];
        var otherEvents = OtherEventLists[myGameType];

        // the hash map count is how many keys it actually stores
        // while its capacity is the total number of keys that it can hold based on how much memory it has been allocated
        int eventHashMapCapacity;
        Array backingArray =
            (Array)
            typeof(Dictionary<int, List<Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>>>>)
            .GetField("entries", BindingFlags.NonPublic | BindingFlags.Instance)
            .GetValue(eventHashMap);
        eventHashMapCapacity = backingArray != null ? backingArray.Length : 0;
        infoBuilder.AppendLine("\tEventHashMap capacity: " + eventHashMap.Count + "/" + eventHashMapCapacity);
        infoBuilder.AppendLine("\tOtherEvents capacity: " + otherEvents.Count + "/" + otherEvents.Capacity);
        infoBuilder.AppendLine();

        int collisionSum = 0;
        int maxEventsPerBucket = 0;
        double avgEventsPerBucket;
        var bucketGroupsPerEventCount = new List<List<List<Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>>>>>();
        var bucketCountsPerEventCount = new List<int>();
        const int MinEventCountPerBucketToCompute = 2; // change to a higher number if startup script lags or debug info gets too spammy
        foreach (var bucket in eventHashMap.Values)
        {
            collisionSum += bucket.Count;
            if (bucket.Count >= maxEventsPerBucket)
                maxEventsPerBucket = bucket.Count;
            for (int i = bucketGroupsPerEventCount.Count; i <= bucket.Count; i++)
            {
                bucketGroupsPerEventCount.Add(new List<List<Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>>>>());
                bucketCountsPerEventCount.Add(0);
            }
            if (bucket.Count >= MinEventCountPerBucketToCompute)
                bucketGroupsPerEventCount[bucket.Count].Add(bucket);
            bucketCountsPerEventCount[bucket.Count]++;
        }
        avgEventsPerBucket = (double)collisionSum / (double)eventHashMap.Count;

        infoBuilder.AppendLine("\tAverage events per bucket: " + avgEventsPerBucket);
        infoBuilder.AppendLine("\tMaximum events per bucket: " + maxEventsPerBucket);
        infoBuilder.AppendLine();

        for (int i = bucketGroupsPerEventCount.Count - 1; i >= 1; i--)
        {
            bool omit = i < MinEventCountPerBucketToCompute;
            infoBuilder.AppendLine("\tBuckets with " + i + " events (total=" + bucketCountsPerEventCount[i] + "):" + (omit ? " (omitted)\r\n" : string.Empty));
            if (omit)
                continue;
            foreach (var bucket in bucketGroupsPerEventCount[i])
                infoBuilder.AppendLine("\t\t[" + string.Join(", ", bucket.Select(@event => @event.Item2)) + "]");
            infoBuilder.AppendLine();
        }

        infoBuilder.AppendLine("\tNon-hash-based events: (total=" + otherEvents.Count + ")");
        foreach (var @event in otherEvents)
            infoBuilder.AppendLine("\t\t" + @event.Item2);
        infoBuilder.AppendLine();
    }

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
    eventMaps = null;
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

        ConfigureGameType(T2T);
    };
    vars.Init = Init;

    // ================================================== exit ==================================================

    Action Exit = () => ConfigureGameType(NoGame);
    vars.Exit = Exit;

    // ================================================== onReset ==================================================

    OnReset = () =>
    {
        CompletedEvents.Clear();
        print("CompletedEvents cleared.");
    };
    vars.OnReset = OnReset;

    // ================================================== update ==================================================

    var EmptyEventList = new List<Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>>>();
    Func<ExpandoObject, bool> Update = newOld =>
    {
        old = newOld;

        TriggeredEvent = null;
        int xyzHashCode = GetXyzHashCodeCurrent();
        List<Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>>> localXyzEvents;
        EventHashMap.TryGetValue(xyzHashCode, out localXyzEvents);
        localXyzEvents = localXyzEvents ?? EmptyEventList;
        
        // print local events:
        //if (localXyzEvents.Count > 0) print("xyz: " + string.Join(", ", localXyzEvents.Select(@event => @event.Item2)));

        // Concat function means we iterate through the lists one after the other; it does not create a concatenated list
        foreach (var @event in localXyzEvents.Concat(OtherEvents))
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

    print("pop_t2t.asl " + DateTime.Now.ToString());
}

init
{
    vars.Init(old, current, settings);
}

exit
{
    vars.Exit();
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

