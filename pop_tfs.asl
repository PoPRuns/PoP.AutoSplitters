state("prince of persia")
{
    float x        : 0xDA4D20;
    float y        : 0xDA4D24;
    float z        : 0xDA4D28;
    int gameState  : 0x00DA52EC, 0x18, 0xF8, 0x150;
    int cpIcon     : 0x007186D4, 0x0, 0x0, 0x24, 0x1C, 0x1C, 0x870;
    int isMenu     : 0xDA2F70;
    bool isLoading : "", 0x00DA5724, 0x50;
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
    const int TFS = 1;
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
        => AddEventBase(eventType, slug, settingSlugs, hashCodes, condition, emptyPostAction, TFS);
    
    Action<int, string, List<string>, int[], Func<bool>, Action<bool>> AddEvent_ = 
        (eventType, slug, settingSlugs, hashCodes, condition, postAction)
        => AddEventBase(eventType, slug, settingSlugs, hashCodes, condition, postAction, TFS);
    
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
        case NoGame:  return "NoGame";
        case TFS:     return "TFS";
        default:      return "UnknownGame";
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

    Action<int> ConfigureGameType = gameType =>
    {
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

    Func<float, float, float, float, bool> IsCpGet = (xTarg, yTarg, zTarg, range)
    =>
        old.cpIcon < 1 && current.cpIcon >= 1 &&
        current.x >= xTarg - range && current.x <= xTarg + range &&
        current.y >= yTarg - range && current.y <= yTarg + range &&
        current.z >= zTarg - range && current.z <= zTarg + range;

    // ===================================================================================================================
    // ================================================== CONFIGURATION ==================================================
    // ===================================================================================================================

    // ================================================== settings ==================================================

    //Default:bool   Slug:string         EventSlugs:List<string>                Description:string        ToolTip:string?                                                         ParentSlug:string?
    AddSetting(true, "Malik",            new List<string> {"Malik"},            "Malik",                  "Split on the checkpoint where you meet Malik",                         null);
    AddSetting(true, "PowerOfTime",      new List<string> {"PowerOfTime"},      "The Power of Time",      "Split on obtaining the Rewind power",                                  null);
    AddSetting(true, "Works",            new List<string> {"Works"},            "The Works",              "Split on reaching the room with the rising lever platform",            null);
    AddSetting(true, "Courtyard",        new List<string> {"Courtyard"},        "The Courtyard",          "Split on reaching the top of the fortress courtyard",                  null);
    AddSetting(true, "PowerOfWater",     new List<string> {"PowerOfWater"},     "The Power of Water",     "Split on obtaining the Freeze power",                                  null);
    AddSetting(true, "Sewers",           new List<string> {"Sewers"},           "The Sewers",             "Split on the checkpoint where Summoners are introduced",               null);
    AddSetting(true, "Ratash",           new List<string> {"Ratash"},           "Ratash",                 "Split on finishing the Ratash chase sequence",                         null);
    AddSetting(true, "Observatory",      new List<string> {"Observatory"},      "The Observatory",        "Split on exiting the Observatory",                                     null);
    AddSetting(true, "PowerOfLight",     new List<string> {"PowerOfLight"},     "The Power of Light",     "Split on obtaining the Dash power",                                    null);
    AddSetting(true, "Gardens",          new List<string> {"Gardens"},          "The Gardens",            "Split on the checkpoint where Wizards are introduced",                 null);
    AddSetting(true, "Possession",       new List<string> {"Possession"},       "Possession",             "Split on completing the big fight before the second Ratash encounter", null);
    AddSetting(true, "PowerOfKnowledge", new List<string> {"PowerOfKnowledge"}, "The Power of Knowledge", "Split on obtaining the Memory power",                                  null);
    AddSetting(true, "Reservoir",        new List<string> {"Reservoir"},        "The Reservoir",          "Split at the beginning of the Rekem reservoir",                        null);
    AddSetting(true, "PowerOfRazia",     new List<string> {"PowerOfRazia"},     "The Power of Razia",     "Split when Razia becomes one with the sword",                          null);
    AddSetting(true, "Climb",            new List<string> {"Climb"},            "The Climb",              "Split on starting the final climb",                                    null);
    AddSetting(true, "Storm",            new List<string> {"Storm"},            "The Storm",              "Split on starting the journey through the storm",                      null);
    AddSetting(true, "End",              new List<string> {"End"},              "The End",                "Split on finishing the game",                                          null);

    // ================================================== events ==================================================

    Action action;
    Action<float, float, float> actionXyz;
    Action<float, float, float, float> actionXyzRange;
    Action<float, float, float, float, float> actionXyZRange;
    Action<float, float, float, float, float, float> actionXyzBounds;
    Action<int[]> actionInts;

    //                                                                           SettingSlugs:
    //                               EventType:int        Slug:string             List<string>        HashCodes:int[]?           Condition:Func<bool>
    (actionXyzRange=(x,y,z,range) => AddEvent(StartEvent, "Start",               new List<string> {}, HashXyzRange(x,y,z,range), () => InXBoundsCurrent(268.929f, 268.93f) && old.gameState != 4 && current.gameState == 4)) (269f, 161f, -147f, 5f);
    (actionXyzRange=(x,y,z,range) => AddEvent(ResetEvent, "Reset",               new List<string> {}, HashXyzRange(x,y,z,range), () => InXBoundsCurrent(268.929f, 268.93f) && current.gameState == 1)) (269f, 161f, -147f, 5f);
    
    (actionXyzRange=(x,y,z,range) => AddEvent(SplitEvent, "Malik",               new List<string> {}, HashXyzRange(x,y,z,range), () => IsCpGet(x, y, z, range))) (-37f, 231f, -148f, 10f);
    (actionXyzRange=(x,y,z,range) => AddEvent(SplitEvent, "PowerOfTime",         new List<string> {}, HashXyzRange(x,y,z,range), () => IsCpGet(x, y, z, range))) (597f, -217f, -2f, 10f);
    (actionXyzRange=(x,y,z,range) => AddEvent(SplitEvent, "Works",               new List<string> {}, HashXyzRange(x,y,z,range), () => IsCpGet(x, y, z, range))) (-513f, -408f, -167f, 10f);
    (actionXyzRange=(x,y,z,range) => AddEvent(SplitEvent, "Courtyard",           new List<string> {}, HashXyzRange(x,y,z,range), () => IsCpGet(x, y, z, range))) (-434f, -533f, -127f, 10f);
    (actionXyzRange=(x,y,z,range) => AddEvent(SplitEvent, "PowerOfWater",        new List<string> {}, HashXyzRange(x,y,z,range), () => CompletedEvents.Contains("PowerOfTime") && IsCpGet(x, y, z, range))) (519f, -227f, 6f, 10f);
    (actionXyzRange=(x,y,z,range) => AddEvent(SplitEvent, "Sewers",              new List<string> {}, HashXyzRange(x,y,z,range), () => IsCpGet(x, y, z, range))) (-228f, 245f, 20f, 10f);
    (actionXyzRange=(x,y,z,range) => AddEvent(SplitEvent, "Ratash",              new List<string> {}, HashXyzRange(x,y,z,range), () => IsCpGet(x, y, z, range))) (-406f, 403f, 64f, 10f);
    (actionXyzRange=(x,y,z,range) => AddEvent(SplitEvent, "Observatory",         new List<string> {}, HashXyzRange(x,y,z,range), () => IsCpGet(x, y, z, range))) (-510f, 460f, 104f, 10f);
    (actionXyzRange=(x,y,z,range) => AddEvent(SplitEvent, "PowerOfLight",        new List<string> {}, HashXyzRange(x,y,z,range), () => CompletedEvents.Contains("PowerOfWater") && IsCpGet(x, y, z, range))) (540f, -219f, 6f, 10f);
    (actionXyzRange=(x,y,z,range) => AddEvent(SplitEvent, "Gardens",             new List<string> {}, HashXyzRange(x,y,z,range), () => IsCpGet(x, y, z, range))) (240f, -227f, -114f, 10f);
    (actionXyzRange=(x,y,z,range) => AddEvent(SplitEvent, "Possession",          new List<string> {}, HashXyzRange(x,y,z,range), () => IsCpGet(x, y, z, range))) (89f, -477f, -83f, 1f);
    (actionXyzRange=(x,y,z,range) => AddEvent(SplitEvent, "PowerOfKnowledge",    new List<string> {}, HashXyzRange(x,y,z,range), () => CompletedEvents.Contains("PowerOfLight") && IsCpGet(x, y, z, range))) (548f, -217f, 4f, 10f);
    (actionXyzRange=(x,y,z,range) => AddEvent(SplitEvent, "Reservoir",           new List<string> {}, HashXyzRange(x,y,z,range), () => IsCpGet(x, y, z, range))) (644f, 385f, -63f, 10f);
    (actionXyzRange=(x,y,z,range) => AddEvent(SplitEvent, "PowerOfRazia",        new List<string> {}, HashXyzRange(x,y,z,range), () => CompletedEvents.Contains("PowerOfKnowledge") && IsCpGet(x, y, z, range))) (430f, 268f, -99f, 10f);
    (actionXyzRange=(x,y,z,range) => AddEvent(SplitEvent, "Climb",               new List<string> {}, HashXyzRange(x,y,z,range), () => IsCpGet(x, y, z, range))) (912f, 256f, -56f, 10f);
    (actionXyzRange=(x,y,z,range) => AddEvent(SplitEvent, "Storm",               new List<string> {}, HashXyzRange(x,y,z,range), () => IsCpGet(x, y, z, range))) (948f, -284f, 86f, 10f);
    (actionXyzRange=(x,y,z,range) => AddEvent(SplitEvent, "End",                 new List<string> {}, HashXyzRange(x,y,z,range), () => InXyzRangeCurrent(x, y, z, range))) (821f, -257f, -51f, 10f);

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

        ConfigureGameType(TFS);
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

    print("pop_tfs.asl " + DateTime.Now.ToString());
}

init
{
    vars.Init(old, current, settings);
}

exit
{
    // we do not need to unpause the IGT timer because the next time the game is running, the isLoading block will run and then it will be handled there
    // however if we didn't have an isLoading block, then we would need to explicitly unpause in the init block
    timer.IsGameTimePaused = true;

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

isLoading
{
    return current.isMenu == 0 || current.isLoading;
}
