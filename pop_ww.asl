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
    float x             : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x30;
    float y             : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x34;
    float z             : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x38;

    // Currently loaded area id (changes with every load trigger)
    int map             : 0x523594;

    // State of the prince (11 is drinking)
    int state           : 0x90C414, 0x18, 0x4, 0x48, 0x3F8;

    // Gallery trackers
    ulong chestBits     : 0x8D2EA8;
    ulong weaponBits    : 0x8D2EB0;

    // Unscaled ticks, but goes back with rewind
    ulong physicsTicks   : 0x5409A0;

    // Slows down during slomo, but runs perfectly while rewinding
    ulong scaledTicks    : 0x540990;

    // Multiplier used by the game to convert ticks to seconds
    float tickMul       : 0x4BDF1C;
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
    const int WW = 1;
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
        => AddEventBase(eventType, slug, settingSlugs, hashCodes, condition, emptyPostAction, WW);
    
    Action<int, string, List<string>, int[], Func<bool>, Action<bool>> AddEvent_ = 
        (eventType, slug, settingSlugs, hashCodes, condition, postAction)
        => AddEventBase(eventType, slug, settingSlugs, hashCodes, condition, postAction, WW);
    
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
        case WW:     return "WW";
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

    // Gallery / tracker helpers (Hamming weight algorithm)
    Func<ulong, int> CountBits = (x) =>
    {
        x = x - ((x >> 1) & 0x5555555555555555UL);
        x = (x & 0x3333333333333333UL) + ((x >> 2) & 0x3333333333333333UL);
        x = (x + (x >> 4)) & 0x0F0F0F0F0F0F0F0FUL;
        x = x + (x >> 8);
        x = x + (x >> 16);
        x = x + (x >> 32);
        return (int)(x & 0x7F);
    };

    const ulong ChestMask        = 0x0003FFFFFFFFFFFFUL;
    const ulong WeaponMask       = 0x37CFFFFFFFFFFFFEUL;
    const ulong MainWeaponMask   = 0x37C0000000000000UL;
    const ulong SwordMask        = 0x0005FFFF00000000UL;
    const ulong AxeMask          = 0x0002000000003FFEUL;
    const ulong MaceMask         = 0x000000000FF00000UL;
    const ulong DaggerMask       = 0x00000000000FC000UL;
    const ulong SecretWeaponMask = 0x00080000F0000000UL;

    // we set non-zero values to force an update on first game launch when they're all set to 0
    int StoryValue          = -1;
    ulong VirtualChestBits  = ulong.MaxValue; // virtual means before mask is applied
    ulong ChestBits         = ulong.MaxValue;
    ulong VirtualWeaponBits = ulong.MaxValue;
    ulong WeaponBits        = ulong.MaxValue;
    ulong MainWeaponBits    = ulong.MaxValue;
    ulong SwordBits         = ulong.MaxValue;
    ulong AxeBits           = ulong.MaxValue;
    ulong MaceBits          = ulong.MaxValue;
    ulong DaggerBits        = ulong.MaxValue;
    ulong SecretWeaponBits  = ulong.MaxValue;

    string MaxChests        = CountBits(ChestMask).ToString();
    string MaxWeapons       = CountBits(WeaponMask).ToString();
    string MaxMainWeapons   = CountBits(MainWeaponMask).ToString();
    string MaxSwords        = CountBits(SwordMask).ToString();
    string MaxAxes          = CountBits(AxeMask).ToString();
    string MaxMaces         = CountBits(MaceMask).ToString();
    string MaxDaggers       = CountBits(DaggerMask).ToString();
    string MaxSecretWeapons = CountBits(SecretWeaponMask).ToString();
    string MaxCollectibles  = (CountBits(ChestMask) + CountBits(WeaponMask)).ToString();

    Func<int[], bool> IsMapOneOfCurrent = maps => Array.Exists(maps, map => map == current.map);

    Func<int[], bool> IsCutsceneHit = maps => old.cutscene == 0 && current.cutscene == 1 && Array.Exists(maps, map => map == current.map);
    Func<int[], bool> IsBossDie = maps => old.cutscene == 0 && current.cutscene == 1 && current.bossHealth == 0 && Array.Exists(maps, map => map == current.map);
    Func<int, bool> IsStoryGateAdv = storyId => old.storyValue != storyId && current.storyValue == storyId;
    Func<int, int, bool> IsMapChange = (oldMapId, currentMapId) => old.map == oldMapId && current.map == currentMapId;

    ulong IgtValue = 0;

    // ===================================================================================================================
    // ================================================== CONFIGURATION ==================================================
    // ===================================================================================================================

    // ================================================== settings ==================================================

    //Default:bool    Slug:string              EventSlugs:List<string>                  Description:string                              ToolTip:string?                                                                                      ParentSlug:string?
    AddSetting(false, "AnyGlitched",           new List<string> {},                     "Any% (Standard) and Any% (Zipless) splits",    null,                                                                                                null);
    AddSetting(false, "TEStandard",            new List<string> {},                     "True Ending (Standard) splits",                null,                                                                                                null);
    AddSetting(false, "TEZipless",             new List<string> {},                     "True Ending (Zipless) splits",                 null,                                                                                                null);
    AddSetting(false, "AnyNMG",                new List<string> {},                     "Any% (No Major Glitches) splits",              null,                                                                                                null);
    AddSetting(false, "TENMG",                 new List<string> {},                     "True Ending (No Major Glitches) splits",       null,                                                                                                null);

    AddSetting(true,  "Any0",                  new List<string> {"boat"},               "Boat",                                         "Split when the boat ending cutscene starts playing",                                                "AnyGlitched");
    AddSetting(true,  "Any1",                  new List<string> {"ravenMan"},           "Raven man",                                    "Split on the cutscene where you're introduced to a raven master",                                   "AnyGlitched");
    AddSetting(true,  "Any2",                  new List<string> {"firstPortal"},        "Time portal",                                  "Split when you go through the first time portal",                                                   "AnyGlitched");
    AddSetting(true,  "Any3",                  new List<string> {"foundryFountain"},    "Foundy fountain",                              "Split when you drink from the foundry fountain while having 58/59 storygate",                       "AnyGlitched");
    AddSetting(true,  "Any4",                  new List<string> {"scorpionSword"},      "Scorpion sword",                               "Split when you get the scorpion sword",                                                             "AnyGlitched");
    AddSetting(false, "Any5",                  new List<string> {"banana"},             "Light sword",                                  "Split when you pick up the light sword in mystic caves",                                            "AnyGlitched");
    AddSetting(true,  "Any6",                  new List<string> {"rng63"},              "Mechanical tower (63)",                        "Split when you acquire storygate 63",                                                               "AnyGlitched");
    AddSetting(true,  "Any7",                  new List<string> {"lastPortal"},         "Second portal",                                "Split when you go through the time portal in the throne room",                                      "AnyGlitched");
    AddSetting(true,  "Any8",                  new List<string> {"kaileena"},           "Kaileena",                                     "Split when you kill Kaileena in sacred caves",                                                      "AnyGlitched");

    AddSetting(true,  "TeStandard0",           new List<string> {"boat"},               "Boat",                                         "Split when the boat ending cutscene starts playing",                                                "TEStandard");
    AddSetting(true,  "TeStandard1",           new List<string> {"ravenMan"},           "Raven man",                                    "Split on the cutscene where you're introduced to a raven master",                                   "TEStandard");
    AddSetting(true,  "TeStandard2",           new List<string> {"firstPortal"},        "Time portal",                                  "Split when you go through the first time portal",                                                   "TEStandard");
    AddSetting(true,  "TeStandard3",           new List<string> {"LUFortress"},         "(1) fortress entrance LU",                     "Split when you acquire the life upgrade in fortress entrance",                                      "TEStandard");
    AddSetting(true,  "TeStandard4",           new List<string> {"LUPrison"},           "(2) Prison LU",                                "Split when you acquire the life upgrade in prison",                                                 "TEStandard");
    AddSetting(true,  "TeStandard5",           new List<string> {"LULibrary"},          "(3) Library LU",                               "Split when you acquire the life upgrade in library",                                                "TEStandard");
    AddSetting(true,  "TeStandard6",           new List<string> {"LUMechTower"},        "(4) Mechanical tower LU",                      "Split when you acquire the life upgrade in mechanical tower",                                       "TEStandard");
    AddSetting(true,  "TeStandard7",           new List<string> {"LUGarden"},           "(5) Garden LU",                                "Split when you acquire the life upgrade in garden",                                                 "TEStandard");
    AddSetting(true,  "TeStandard8",           new List<string> {"LUWaterworks"},       "(6) Waterworks LU",                            "Split when you acquire the life upgrade in waterworks",                                             "TEStandard");
    AddSetting(true,  "TeStandard9",           new List<string> {"LUShahdee"},          "(7) Sacrificial altar LU",                     "Split when you acquire the life upgrade in sacrificial altar",                                      "TEStandard");
    AddSetting(true,  "TeStandard10",          new List<string> {"LU019"},              "(8) Southern passage LU",                      "Split when you acquire the life upgrade in southern passage",                                       "TEStandard");
    AddSetting(true,  "TeStandard11",          new List<string> {"LUCentralHall"},      "(9) Central hall LU",                          "Split when you acquire the life upgrade in central hall",                                           "TEStandard");
    AddSetting(true,  "TeStandard12",          new List<string> {"WaterSword"},         "Water sword",                                  "Split when you get the water sword",                                                                "TEStandard");
    AddSetting(true,  "TeStandard13",          new List<string> {"Dahaka"},             "Dahaka",                                       "Split when you defeat Dahaka",                                                                      "TEStandard");

    AddSetting(true,  "TeZipless1",            new List<string> {"ravenMan"},           "Raven man",                                    "Split on the cutscene where you're introduced to a raven master",                                   "TEZipless");
    AddSetting(false, "TeZipless2",            new List<string> {"firstPortal"},        "Time portal",                                  "Split when you go through the first time portal",                                                   "TEZipless");
    AddSetting(true,  "TeZipless3",            new List<string> {"LUCentralHall"},      "(1) Central hall LU",                          "Split when you acquire the life upgrade in central hall",                                           "TEZipless");
    AddSetting(true,  "TeZipless4",            new List<string> {"LUWaterworks"},       "(2) Waterworks LU",                            "Split when you acquire the life upgrade in waterworks",                                             "TEZipless");
    AddSetting(true,  "TeZipless5",            new List<string> {"LUGarden"},           "(3) Garden LU",                                "Split when you acquire the life upgrade in garden",                                                 "TEZipless");
    AddSetting(true,  "TeZipless0",            new List<string> {"boat"},               "Boat",                                         "Split when the boat ending cutscene starts playing",                                                "TEZipless");
    AddSetting(true,  "TeZipless6",            new List<string> {"LUFortress"},         "(4) Fortress entrance LU",                     "Split when you acquire the life upgrade in fortress entrance",                                      "TEZipless");
    AddSetting(true,  "TeZipless7",            new List<string> {"rng59"},              "Foundry (59)",                                 "Split when you acquire storygate 59",                                                               "TEZipless");
    AddSetting(true,  "TeZipless8",            new List<string> {"LUPrison"},           "(5) Prison LU",                                "Split when you acquire the life upgrade in prison",                                                 "TEZipless");
    AddSetting(true,  "TeZipless9",            new List<string> {"LULibrary"},          "(6) Library LU",                               "Split when you acquire the life upgrade in library",                                                "TEZipless");
    AddSetting(false, "TeZipless10",           new List<string> {"banana"},             "Light sword",                                  "Split when you pick up the light sword in mystic caves",                                            "TEZipless");
    AddSetting(true,  "TeZipless11",           new List<string> {"rng63"},              "Mechanical tower (63)",                        "Split when you acquire storygate 63",                                                               "TEZipless");
    AddSetting(true,  "TeZipless12",           new List<string> {"LUMechTower"},        "(7) Mechanical tower LU",                      "Split when you acquire the life upgrade in mechanical tower",                                       "TEZipless");
    AddSetting(true,  "TeZipless13",           new List<string> {"LU019"},              "(8) Southern passage LU",                      "Split when you acquire the life upgrade in southern passage",                                       "TEZipless");
    AddSetting(true,  "TeZipless14",           new List<string> {"LUShahdee"},          "(9) Sacrificial altar LU",                     "Split when you acquire the life upgrade in sacrificial altar",                                      "TEZipless");
    AddSetting(true,  "TeZipless15",           new List<string> {"WaterSword"},         "Water sword",                                  "Split when you get the water sword",                                                                "TEZipless");
    AddSetting(true,  "TeZipless16",           new List<string> {"Dahaka"},             "Dahaka",                                       "Split when you defeat Dahaka",                                                                      "TEZipless");

    AddSetting(true,  "AnyNmg0",               new List<string> {"boat"},               "Boat",                                         "Split when the boat ending cutscene starts playing",                                                "AnyNMG");
    AddSetting(true,  "AnyNmg1",               new List<string> {"spiderSword"},        "Spider sword",                                 "Split on the cutscene where you get the spider sword",                                              "AnyNMG");
    AddSetting(false, "AnyNmg2",               new List<string> {"ravenMan"},           "Raven man",                                    "Split on the cutscene where you're introduced to a raven master",                                   "AnyNMG");
    AddSetting(false, "AnyNmg3",               new List<string> {"firstPortal"},        "Time portal",                                  "Split when you go through the first time portal",                                                   "AnyNMG");
    AddSetting(true,  "AnyNmg4",               new List<string> {"chasingShahdee"},     "Soutern passage (chasing Shahdee)",            "Split when you come to southern passage past",                                                      "AnyNMG");
    AddSetting(true,  "AnyNmgShadeeFight",     new List<string> {"shahdeeFight"},       "A Damsel In Distress (Fight with Shadee)",     "Split before the fight with Shahdee",                                                               "AnyNMG");
    AddSetting(true,  "AnyNmg5",               new List<string> {"shahdee"},            "Shahdee (a damsel in distress)",               "Split when you kill Shahdee",                                                                       "AnyNMG");
    AddSetting(false, "AnyNmg_spPortalEnter",  new List<string> {"spPortalEnter"},      "Enter Southern Passage Portal",                "Split when you enter the portal in Southern Passage",                                               "AnyNMG");
    AddSetting(false, "AnyNmg_spPortal",       new List<string> {"spPortal"},           "Southern Passage (Portal)",                    "Split when you entered the Southern Passage portal",                                                "AnyNMG");
    AddSetting(false, "AnyNmg_spPortalExit",   new List<string> {"spPortalExit"},       "Exit Southern Passage Portal",                 "Split when you exit the portal in Southern Passage",                                                "AnyNMG");
    AddSetting(true,  "AnyNmg6",               new List<string> {"princeStare"},        "The Dahaka",                                   "Split on the cutscene before the first Dahaka chase (southern passage present)",                    "AnyNMG");
    AddSetting(true,  "AnyNmgHElpHand",        new List<string> {"EscapeDahaka01"},     "A Helping Hand (Portal)",                      "Split after the first escape from the Dahaka (When entered the portal)",                            "AnyNMG");
    AddSetting(true,  "AnyNmg7",               new List<string> {"serpentSword"},       "Serpent sword",                                "Split on the cutscene where you get the serpent sword (hourglass chamber)",                         "AnyNMG");
    AddSetting(true,  "AnyNmg8",               new List<string> {"gardenHall"},         "Garden hall",                                  "Split when you come to garden hall",                                                                "AnyNMG");
    AddSetting(true,  "AnyNmg9",               new List<string> {"waterworks"},         "Waterworks",                                   "Split when you come to garden waterworks",                                                          "AnyNMG");
    AddSetting(true,  "AnyNmg10",              new List<string> {"lionSword"},          "Lion sword",                                   "Split on the cutscene where you get the lion sword (central hall)",                                 "AnyNMG");
    AddSetting(false, "AnyNmg_Second_Tower",   new List<string> {"theSecondTower"},     "The Second Tower",                             "Split before the mechanical tower(before fight)",                                                   "AnyNMG");
    AddSetting(true,  "AnyNmg11",              new List<string> {"mechTower"},          "Mechanical tower",                             "Split when you clilmb up into the mechanical tower",                                                "AnyNMG");
    AddSetting(false, "AnyNmg12",              new List<string> {"mechElevator"},       "Mechanical tower v2 (elevator cutscene)",      "Split on the cutscene where you jump down on the elevator at the start of mech tower",              "AnyNMG");
    AddSetting(false, "AnyNmg_mpPortalEnter",  new List<string> {"mpPortalEnter"},      "Enter Mechanical Pit Portal",                  "Split when you enter the portal in Mechanical Pit",                                                 "AnyNMG");
    AddSetting(true,  "AnyNmg13",              new List<string> {"mechPortal"},         "Mechanical Pit Portal",                        "Split when you go through the time portal in mechanical pit",                                       "AnyNMG");
    AddSetting(false, "AnyNmg_mpPortalExit",   new List<string> {"mpPortalExit"},       "Exit Mechanical Pit Portal",                   "Split when you exit the portal in Mechanical Pit",                                                  "AnyNMG");
    AddSetting(true,  "AnyNmg14",              new List<string> {"activationRuin"},     "Activation room in ruin",                      "Split when you come to the mech tower activation room in the present",                              "AnyNMG");
    AddSetting(false, "AnyNmg_arPortalEnter",  new List<string> {"arPortalEnter"},      "Enter Activation room Portal",                 "Split when you enter the portal in Activation room",                                                "AnyNMG");
    AddSetting(true,  "AnyNmg_arPortal",       new List<string> {"arPortal"},           "Activation room (Portal)",                     "Split when you entered the Activation Room portal",                                                 "AnyNMG");
    AddSetting(false, "AnyNmg_arPortalExit",   new List<string> {"arPortalExit"},       "Exit Activation room Portal",                  "Split when you exit the portal in Activation room",                                                 "AnyNMG");
    AddSetting(true,  "AnyNmg15",              new List<string> {"activationRestore"},  "Activation room restored",                     "Split when you come to the mech tower activation room in the past",                                 "AnyNMG");
    AddSetting(false, "AnyNmg16",              new List<string> {"sandWraithDeathV1"},  "The death of a sand wraith (central hall)",    "Split in central hall next to the fountain after you've activated both towers",                     "AnyNMG");
    AddSetting(true,  "AnyNmg17",              new List<string> {"sandWraithDeathV2"},  "The death of a sand wraith v2 (central hall)", "Alternate split located deeper into the corridor so you can't hit it early when jumping down",      "AnyNMG");
    AddSetting(true,  "AnyNmg18",              new List<string> {"kaileenaFirst"},      "Death of the empress",                         "Split when you kill Kaileena in the throne room (34->38)",                                          "AnyNMG");
    AddSetting(true,  "AnyNmgTomb",            new List<string> {"Tomb"},               "Enter the tomb after cutscene",                "Split when you enter the tomb",                                                                     "AnyNMG");
    AddSetting(true,  "AnyNmg19",              new List<string> {"exitTomb"},           "Exit the tomb",                                "Split when you leave the tomb",                                                                     "AnyNMG");
    AddSetting(false, "AnyNmg_prPortalEnter",  new List<string> {"prPortalEnter"},      "Enter Prison Portal",                          "Split when you enter the portal in Prison",                                                         "AnyNMG");
    AddSetting(false, "AnyNmg_prPortal",       new List<string> {"prPortal"},           "Prison Portal (Portal)",                       "Split when you entered the Prison portal",                                                          "AnyNMG");
    AddSetting(false, "AnyNmg_prPortalExit",   new List<string> {"prPortalExit"},       "Exit Prison Portal",                           "Split when you exit the portal in Prison",                                                          "AnyNMG");
    AddSetting(true,  "AnyNmg20",              new List<string> {"scorpionSword"},      "Scorpion sword",                               "Split when you get the scorpion sword",                                                             "AnyNMG");
    AddSetting(true,  "AnyNmg21",              new List<string> {"libraryV1"},          "Library",                                      "Split on the library opening cutscene",                                                             "AnyNMG");
    AddSetting(false, "AnyNmg22",              new List<string> {"libraryV2"},          "Library v2",                                   "Split when you move into the library (after the opening cutscene)",                                 "AnyNMG");
    AddSetting(false, "AnyNmg_LibraryV3",      new List<string> {"libraryV3"},          "Library v3",                                   "Split when you move into the library (An alternative to the cutscene)",                             "AnyNMG");
    AddSetting(true,  "AnyNmg23",              new List<string> {"hourglassRevisit"},   "Hourglass revisited",                          "Split when you come back to the hourglass chamber after you've killed Kaileena",                    "AnyNMG");
    AddSetting(false, "AnyNmg_trPortalEnter",  new List<string> {"trPortalEnter"},      "Enter Throne Room Portal",                     "Split when you enter the cutscene after breaking Throne Room wall",                                 "AnyNMG");
    AddSetting(false, "AnyNmg_trPortal",       new List<string> {"trPortal"},           "Throne Room (Portal)",                         "Split when you entered the Throne Room portal",                                                     "AnyNMG");
    AddSetting(false, "AnyNmg_trPortalExit",   new List<string> {"trPortalExit"},       "Exit Throne Room Portal",                      "Split when you exit the portal in Throne Room",                                                     "AnyNMG");
    AddSetting(true,  "AnyNmg24",              new List<string> {"maskOn"},             "The mask of the wraith",                       "Split when you get to the mask",                                                                    "AnyNMG");
    AddSetting(false, "AnyNmg_scPortalEnter",  new List<string> {"scPortalEnter"},      "Enter Sacred Caves Portal",                    "Split when you enter the portal in Sacred Caves",                                                   "AnyNMG");
    AddSetting(false, "AnyNmg_scPortal",       new List<string> {"scPortal"},           "Sacred Caves (Portal)",                        "Split when you entered the Secret Caves portal",                                                    "AnyNMG");
    AddSetting(false, "AnyNmg_scPortalExit",   new List<string> {"scPortalExit"},       "Exit Sacred Caves Portal",                     "Split when you exit the portal in Sacred Caves",                                                    "AnyNMG");
    AddSetting(true,  "AnyNmg25",              new List<string> {"griffinV1"},          "Sand griffin",                                 "Split when you kill the griffin",                                                                   "AnyNMG");
    AddSetting(false, "AnyNmg26",              new List<string> {"griffinV2"},          "Sand griffin v2",                              "Split when you jump to the platform after you've killed the griffin",                               "AnyNMG");
    AddSetting(false, "AnyNmg_ugPortalEnter",  new List<string> {"ugPortalEnter"},      "Enter Upper Garden Portal",                    "Split when you enter the portal in Upper Garden",                                                   "AnyNMG");
    AddSetting(false, "AnyNmg_ugPortal",       new List<string> {"ugPortal"},           "Upper Garden (Portal)",                        "Split when you entered the Garden Upper Portal",                                                    "AnyNMG");
    AddSetting(false, "AnyNmg_ugPortalExit",   new List<string> {"ugPortalExit"},       "Exit Upper Garden Portal",                     "Split when you exit the portal in Upper Garden",                                                    "AnyNMG");
    AddSetting(true,  "AnyNmg27",              new List<string> {"mirroredFates"},      "Mirrored fates",                               "Split on the sacrificial altar cutscene (sand wraith pov)",                                         "AnyNMG");
    AddSetting(true,  "AnyNmg28",              new List<string> {"favorUnknown"},       "A favor unknown",                              "Split on the cutscene where the sand wraith saves the prince by throwing an axe (sand wraith pov)", "AnyNMG");
    AddSetting(true,  "AnyNmg29",              new List<string> {"libraryRevisit"},     "Library revisited",                            "Split when you enter the library",                                                                  "AnyNMG");
    AddSetting(true,  "AnyNmgCave",            new List<string> {"mysticcaves"},        "Mystic Caves",                                 "Split when you enter mystic caves",                                                                 "AnyNMG");
    AddSetting(true,  "AnyNmg30",              new List<string> {"banana"},             "Light sword",                                  "Split when you pick up the light sword in mystic caves",                                            "AnyNMG");
    AddSetting(true,  "AnyNmgMechTWCave",      new List<string> {"mechtowercave"},      "Mechanical tower (Mystic Caves)",              "Split upon entering the Mechanical Tower from the cave entrance",                                   "AnyNMG");
    AddSetting(true,  "AnyNmg31",              new List<string> {"maskOff"},            "The death of a prince",                        "Split on the cutscene where you take the mask off",                                                 "AnyNMG");
    AddSetting(true,  "AnyNmgKaileenaPresent", new List<string> {"kaileenaPresent"},    "Kaileena in present",                          "Split as you enter the portal after forcing Kaileena through",                                      "AnyNMG");
    AddSetting(true,  "AnyNmg32",              new List<string> {"kaileena"},           "Kaileena",                                     "Split when you kill Kaileena in sacred caves",                                                      "AnyNMG");

    AddSetting(true,  "TeNmg0",                new List<string> {"boat"},              "Boat",                                          "Split when the boat ending cutscene starts playing",                                                "TENMG");
    AddSetting(true,  "TeNmg1",                new List<string> {"spiderSword"},       "Spider sword",                                  "Split on the cutscene where you get the spider sword",                                              "TENMG");
    AddSetting(false, "TeNmg2",                new List<string> {"ravenMan"},          "Raven man",                                     "Split on the cutscene where you're introduced to a raven master",                                   "TENMG");
    AddSetting(false, "TeNmg3",                new List<string> {"firstPortal"},       "Time portal",                                   "Split when you go through the first time portal",                                                   "TENMG");
    AddSetting(true,  "TeNmg4",                new List<string> {"chasingShahdee"},    "Soutern passage (chasing Shahdee)",             "Split when you come to southern passage past",                                                      "TENMG");
    AddSetting(true,  "TeNmgShadeeFight",      new List<string> {"shahdeeFight"},      "A Damsel In Distress (Fight with Shadee)",      "Split before the fight with Shahdee",                                                               "TENMG");
    AddSetting(true,  "TeNmg5",                new List<string> {"LU019"},             "(1) Southern passage LU",                       "Split when you acquire the life upgrade in southern passage",                                       "TENMG");
    AddSetting(true,  "TeNmg6",                new List<string> {"shahdee"},           "Shahdee (a damsel in distress)",                "Split when you kill Shahdee",                                                                       "TENMG");
    AddSetting(true,  "TeNmg7",                new List<string> {"LUShahdee"},         "(2) Sacrificial alter LU",                      "Split when you acquire the life upgrade in sacrificial altar",                                      "TENMG");
    AddSetting(false, "TeNmg_spPortalEnter",   new List<string> {"spPortalEnter"},     "Enter Southern Passage Portal",                 "Split when you enter the portal in Southern Passage",                                               "TENMG");
    AddSetting(false, "TeNmg_spPortal",        new List<string> {"spPortal"},          "Southern Passage (Portal)",                     "Split when you entered the Southern Passage portal",                                                "TENMG");
    AddSetting(false, "TeNmg_spPortalExit",    new List<string> {"spPortalExit"},      "Exit Southern Passage Portal",                  "Split when you exit the portal in Southern Passage",                                                "TENMG");
    AddSetting(true,  "TeNmg8",                new List<string> {"princeStare"},       "The Dahaka",                                    "Split on the cutscene before the first Dahaka chase (southern passage present)",                    "TENMG");
    AddSetting(true,  "TeNmgHElpHand",         new List<string> {"EscapeDahaka01"},    "A Helping Hand (Portal)",                       "Split after the first escape from the Dahaka (When entered the portal)",                            "TENMG");
    AddSetting(true,  "TeNmg9",                new List<string> {"LUFortress"},        "(3) Fortress entrance LU",                      "Split when you acquire the life upgrade in fortress entrance",                                      "TENMG");
    AddSetting(true,  "TeNmg10",               new List<string> {"serpentSword"},      "Serpent sword",                                 "Split on the cutscene where you get the serpent sword (hourglass chamber)",                         "TENMG");
    AddSetting(true,  "TeNmg11",               new List<string> {"gardenHall"},        "Garden hall",                                   "Split when you come to garden hall",                                                                "TENMG");
    AddSetting(false, "TeNmg12",               new List<string> {"waterworks"},        "Waterworks",                                    "Split when you come to garden waterworks",                                                          "TENMG");
    AddSetting(true,  "TeNmg13",               new List<string> {"LUWaterworks"},      "(4) Waterworks LU",                             "Split when you acquire the life upgrade in waterworks",                                             "TENMG");
    AddSetting(true,  "TeNmg15",               new List<string> {"LUGarden"},          "(5) Garden LU",                                 "Split when you acquire the life upgrade in garden",                                                 "TENMG");
    AddSetting(true,  "TeNmg16",               new List<string> {"LUCentralHall"},     "(6) Central hall LU",                           "Split when you acquire the life upgrade in central hall",                                           "TENMG");
    AddSetting(false, "TeNmg17",               new List<string> {"lionSword"},         "Lion sword",                                    "Split on the cutscene where you get the lion sword (central hall)",                                 "TENMG");
    AddSetting(false, "TeNmg_Second_Tower",    new List<string> {"theSecondTower"},    "The Second Tower",                              "Split before the mechanical tower(before fight)",                                                   "TENMG");
    AddSetting(true,  "TeNmg18",               new List<string> {"mechTower"},         "Mechanical tower",                              "Split when you clilmb up into the mechanical tower",                                                "TENMG");
    AddSetting(false, "TeNmg19",               new List<string> {"mechElevator"},      "Mechanical tower v2 (elevator cutscene)",       "Split on the cutscene where you jump down on the elevator at the start of mech tower",              "TENMG");
    AddSetting(false, "TeNmg_mpPortalEnter",   new List<string> {"mpPortalEnter"},     "Enter Mechanical Pit Portal",                   "Split when you enter the portal in Mechanical Pit",                                                 "TENMG");
    AddSetting(true,  "TeNmg20",               new List<string> {"mechPortal"},        "Mechanical Pit Portal",                         "Split when you go through the time portal in mechanical pit",                                       "TENMG");
    AddSetting(false, "TeNmg_mpPortalExit",    new List<string> {"mpPortalExit"},      "Exit Mechanical Pit Portal",                    "Split when you exit the portal in Mechanical Pit",                                                  "TENMG");
    AddSetting(true,  "TeNmg21",               new List<string> {"activationRuin"},    "Activation room in ruin",                       "Split when you come to the mech tower activation room in the present",                              "TENMG");
    AddSetting(false, "TeNmg_arPortalEnter",   new List<string> {"arPortalEnter"},     "Enter Activation room Portal",                  "Split when you enter the portal in Activation room",                                                "TENMG");
    AddSetting(true,  "TeNmg_arPortal",        new List<string> {"arPortal"},          "Activation room (Portal)",                      "Split when you entered the Activation Room portal",                                                 "TENMG");
    AddSetting(false, "TeNmg_arPortalExit",    new List<string> {"arPortalExit"},      "Exit Activation room Portal",                   "Split when you exit the portal in Activation room",                                                 "TENMG");
    AddSetting(false, "TeNmg22",               new List<string> {"activationRestore"}, "Activation room restored",                      "Split when you come to the mech tower activation room in the past",                                 "TENMG");
    AddSetting(true,  "TeNmg23",               new List<string> {"LUMechTower"},       "(7) Mechanical tower LU",                       "Split when you acquire the life upgrade in mechanical tower",                                       "TENMG");
    AddSetting(false, "TeNmg24",               new List<string> {"sandWraithDeathV1"}, "The death of a sand wraith (central hall)",     "Split in central hall next to the fountain after you've activated both towers",                     "TENMG");
    AddSetting(true,  "TeNmg25",               new List<string> {"sandWraithDeathV2"}, "The death of a sand wraith v2 (central hall)",  "Alternate split located deeper into the corridor so you can't hit it early when jumping down",      "TENMG");
    AddSetting(true,  "TeNmg26",               new List<string> {"kaileenaFirst"},     "Death of the empress",                          "Split when you kill Kaileena in the throne room (34->38)",                                          "TENMG");
    AddSetting(true,  "TeNmgTomb",             new List<string> {"Tomb"},              "Enter the tomb after cutscene",                 "Split when you enter the tomb",                                                                     "TENMG");
    AddSetting(true,  "TeNmg27",               new List<string> {"exitTomb"},          "Exit the tomb",                                 "Split when you leave the tomb",                                                                     "TENMG");
    AddSetting(false, "TeNmg_prPortalEnter",   new List<string> {"prPortalEnter"},     "Enter Prison Portal",                           "Split when you enter the portal in Prison",                                                         "TENMG");
    AddSetting(false, "TeNmg_prPortal",        new List<string> {"prPortal"},          "Prison Portal (Portal)",                        "Split when you entered the Prison portal",                                                          "TENMG");
    AddSetting(false, "TeNmg_prPortalExit",    new List<string> {"prPortalExit"},      "Exit Prison Portal",                            "Split when you exit the portal in Prison",                                                          "TENMG");
    AddSetting(true,  "TeNmg28",               new List<string> {"scorpionSword"},     "Scorpion sword",                                "Split when you get the scorpion sword",                                                             "TENMG");
    AddSetting(true,  "TeNmg29",               new List<string> {"LUPrison"},          "(8) Prison LU",                                 "Split when you acquire the life upgrade in prison",                                                 "TENMG");
    AddSetting(true,  "TeNmg30",               new List<string> {"libraryV1"},         "Library",                                       "Split on the library opening cutscene",                                                             "TENMG");
    AddSetting(false, "TeNmg31",               new List<string> {"libraryV2"},         "Library v2",                                    "Split when you move into the library (after the opening cutscene)",                                 "TENMG");
    AddSetting(false, "TeNmg_LibraryV3",       new List<string> {"libraryV3"},         "Library v3",                                    "Split when you move into the library (An alternative to the cutscene)",                             "TENMG");
    AddSetting(true,  "TeNmg32",               new List<string> {"LULibrary"},         "(9) Library LU",                                "Split when you acquire the life upgrade in library",                                                "TENMG");
    AddSetting(false, "TeNmg33",               new List<string> {"hourglassRevisit"},  "Hourglass revisited",                           "Split when you come back to the hourglass chamber after you've killed Kaileena",                    "TENMG");
    AddSetting(true,  "TeNmg34",               new List<string> {"WaterSword"},        "Water sword",                                   "Split when you get the water sword",                                                                "TENMG");
    AddSetting(false, "TeNmg_trPortalEnter",   new List<string> {"trPortalEnter"},     "Enter Throne Room Portal",                      "Split when you enter the cutscene after breaking Throne Room wall",                                 "TENMG");
    AddSetting(false, "TeNmg_trPortal",        new List<string> {"trPortal"},          "Throne Room (Portal)",                          "Split when you entered the Throne Room portal",                                                     "TENMG");
    AddSetting(false, "TeNmg_trPortalExit",    new List<string> {"trPortalExit"},      "Exit Throne Room Portal",                       "Split when you exit the portal in Throne Room",                                                     "TENMG");
    AddSetting(true,  "TeNmg35",               new List<string> {"maskOn"},            "The mask of the wraith",                        "Split when you get to the mask",                                                                    "TENMG");
    AddSetting(false, "TeNmg_scPortalEnter",   new List<string> {"scPortalEnter"},     "Enter Sacred Caves Portal",                     "Split when you enter the portal in Sacred Caves",                                                   "TENMG");
    AddSetting(false, "TeNmg_scPortal",        new List<string> {"scPortal"},          "Sacred Caves (Portal)",                         "Split when you entered the Secret Caves portal",                                                    "TENMG");
    AddSetting(false, "TeNmg_scPortalExit",    new List<string> {"scPortalExit"},      "Exit Sacred Caves Portal",                      "Split when you exit the portal in Sacred Caves",                                                    "TENMG");
    AddSetting(true,  "TeNmg36",               new List<string> {"griffinV1"},         "Sand griffin",                                  "Split when you kill the griffin",                                                                   "TENMG");
    AddSetting(false, "TeNmg37",               new List<string> {"griffinV2"},         "Sand griffin v2",                               "Split when you jump to the platform after you've killed the griffin",                               "TENMG");
    AddSetting(false, "TeNmg_ugPortalEnter",   new List<string> {"ugPortalEnter"},     "Enter Upper Garden Portal",                     "Split when you enter the portal in Upper Garden",                                                   "TENMG");
    AddSetting(false, "TeNmg_ugPortal",        new List<string> {"ugPortal"},          "Upper Garden (Portal)",                         "Split when you entered the Garden Upper Portal",                                                    "TENMG");
    AddSetting(false, "TeNmg_ugPortalExit",    new List<string> {"ugPortalExit"},      "Exit Upper Garden Portal",                      "Split when you exit the portal in Upper Garden",                                                    "TENMG");
    AddSetting(true,  "TeNmg38",               new List<string> {"mirroredFates"},     "Mirrored fates",                                "Split on the sacrificial altar cutscene (sand wraith pov)",                                         "TENMG");
    AddSetting(true,  "TeNmg39",               new List<string> {"favorUnknown"},      "A favor unknown",                               "Split on the cutscene where the sand wraith saves the prince by throwing an axe (sand wraith pov)", "TENMG");
    AddSetting(true,  "TeNmg40",               new List<string> {"libraryRevisit"},    "Library revisited",                             "Split when you enter the library",                                                                  "TENMG");
    AddSetting(true,  "TeNmgCave",             new List<string> {"mysticcaves"},       "Mystic Caves",                                  "Split when you enter mystic caves",                                                                 "TENMG");
    AddSetting(true,  "TeNmg41",               new List<string> {"banana"},            "Light sword",                                   "Split when you pick up the light sword in mystic caves",                                            "TENMG");
    AddSetting(true,  "TeNmgMechTWCave",       new List<string> {"mechtowercave"},     "Mechanical tower (Mystic Caves)",               "Split upon entering the Mechanical Tower from the cave entrance",                                   "TENMG");
    AddSetting(true,  "TeNmg42",               new List<string> {"maskOff"},           "The death of a prince",                         "Split on the cutscene where you take the mask off",                                                 "TENMG");
    AddSetting(true,  "TeNmgKaileenaPresent",  new List<string> {"kaileenaPresent"},   "Kaileena in present",                           "Split as you enter the portal after forcing Kaileena through",                                      "TENMG");
    AddSetting(true,  "TeNmg43",               new List<string> {"Dahaka"},            "Dahaka",                                        "Split when you defeat Dahaka",                                                                      "TENMG");

    // ================================================== events ==================================================

    Action action;
    Action<float, float, float> actionXyz;
    Action<float, float, float, float> actionXyzRange;
    Action<float, float, float, float, float> actionXyZRange;
    Action<float, float, float, float, float, float> actionXyzBounds;
    Action<int[]> actionInts;

    //                                                                                SettingSlugs:
    //                                      EventType:int        Slug:string           List<string>        HashCodes:int[]?                  Condition:Func<bool>
    (actionInts=maps                     => AddEvent(StartEvent, "Start",             new List<string> {}, maps,                             () => IsMapOneOfCurrent(maps) && old.cutscene == 1 && current.cutscene == 2)) (new int[] {1292342859});
    (actionInts=maps                     => AddEvent(ResetEvent, "Reset",             new List<string> {}, maps,                             () => old.map == 234881388 && IsMapOneOfCurrent(maps))) (new int[] {1292342859});

    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "spPortalEnter",     new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (95.5f, 97.5f, -107f, -106f, 413.8f, 414.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "spPortalExit",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (95.5f, 97.5f, -107f, -106f, 113.8f, 114.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "mpPortalEnter",     new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-211f, -209f, 139f, 141f, 440.8f, 441.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "mpPortalExit",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-211f, -209f, 139f, 141f, 140.8f, 141.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "arPortalEnter",     new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-172f, -170f, 188f, 189f, 181.8f, 182.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "arPortalExit",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-172f, -170f, 188f, 189f, 481.8f, 482.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "Tomb",              new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2) && current.storyValue == 39)) (-94f, -93.5f, -193f, -185f, 18f, 18.1f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "prPortalEnter",     new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-71f, -69f, -117f, -115f, 19.8f, 20.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "prPortalExit",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-71f, -69f, -117f, -115f, 319.8f, 320.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "trPortalExit",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-53.5f, -51.5f, 113f, 114f, 117.8f, 118.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "scPortalEnter",     new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-72f, -70f, 273f, 274f, 132.8f, 133.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "scPortalExit",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-72f, -70f, 273f, 274f, 432.8f, 433.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "ugPortalEnter",     new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (78f, 80f, 107f, 108f, 412.3f, 412.7f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "ugPortalExit",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (78f, 80f, 107f, 108f, 112.3f, 112.7f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent, "mechtowercave",     new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2) && current.map == 67111336 && current.storyValue == 61)) (-218f, -216f, 0.4f, 4f, 445f, 446f);

    (actionInts=maps                     => AddEvent(SplitEvent, "boat",              new List<string> {}, maps,                             () => IsBossDie(maps))) (new int[] {67109218});
    (actionInts=maps                     => AddEvent(SplitEvent, "kaileena",          new List<string> {}, maps,                             () => IsBossDie(maps))) (new int[] {989966866});
    (actionInts=maps                     => AddEvent(SplitEvent, "shahdee",           new List<string> {}, maps,                             () => IsBossDie(maps))) (new int[] {1006801609});

    (action=()                           => AddEvent(SplitEvent, "rng59",             new List<string> {}, null,                             () => IsStoryGateAdv(59))) ();
    (action=()                           => AddEvent(SplitEvent, "rng63",             new List<string> {}, null,                             () => IsStoryGateAdv(63))) ();
    (action=()                           => AddEvent(SplitEvent, "kaileenaFirst",     new List<string> {}, null,                             () => IsStoryGateAdv(38))) ();

    (actionInts=maps                     => AddEvent(SplitEvent, "banana",            new List<string> {}, maps,                             () => IsMapOneOfCurrent(maps) && old.secondaryWeapon != 50 && current.secondaryWeapon == 50)) (new int[] {587202754, 587203393});
    (action=()                           => AddEvent(SplitEvent, "foundryFountain",   new List<string> {}, null,                             () => (current.storyValue == 58 || current.storyValue == 59) && old.state != 11 && current.state == 11)) ();

    (actionInts=maps                     => AddEvent(SplitEvent, "hourglassRevisit",  new List<string> {}, maps,                             () => IsMapChange(1006704427, maps[0]) && current.storyValue == 45)) (new int[] {1006704429});
    (actionInts=maps                     => AddEvent(SplitEvent, "trPortalEnter",     new List<string> {}, maps,                             () => IsMapChange(1006704431, maps[0]) && current.storyValue == 45)) (new int[] {-1509855113});
    (actionInts=maps                     => AddEvent(SplitEvent, "trPortal",          new List<string> {}, maps,                             () => IsMapChange(-1509855113, maps[0]) && current.storyValue == 45)) (new int[] {285233488});
    (actionInts=maps                     => AddEvent(SplitEvent, "mysticcaves",       new List<string> {}, maps,                             () => IsMapChange(67116810, maps[0]) && current.storyValue == 60)) (new int[] {1006801523});
    (actionInts=maps                     => AddEvent(SplitEvent, "kaileenaPresent",   new List<string> {}, maps,                             () => IsMapChange(-1509855113, maps[0]) && current.storyValue == 66)) (new int[] {285233488});

    (actionInts=maps                     => AddEvent(SplitEvent, "ravenMan",          new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {135462572});
    (actionInts=maps                     => AddEvent(SplitEvent, "firstPortal",       new List<string> {}, maps,                             () => IsCutsceneHit(maps) && current.storyValue == 2)) (new int[] {285231807});
    (actionInts=maps                     => AddEvent(SplitEvent, "LUFortress",        new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {135501679});
    (actionInts=maps                     => AddEvent(SplitEvent, "LUMechTower",       new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {67145445});
    (actionInts=maps                     => AddEvent(SplitEvent, "LUCentralHall",     new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {67144144});
    (actionInts=maps                     => AddEvent(SplitEvent, "spiderSword",       new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {135462576});
    (actionInts=maps                     => AddEvent(SplitEvent, "chasingShahdee",    new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {989860400});
    (actionInts=maps                     => AddEvent(SplitEvent, "shahdeeFight",      new List<string> {}, maps,                             () => IsCutsceneHit(maps) && current.storyValue == 8)) (new int[] {285225353});
    (actionInts=maps                     => AddEvent(SplitEvent, "spPortal",          new List<string> {}, maps,                             () => IsCutsceneHit(maps) && current.storyValue == 8)) (new int[] {285235301});
    (actionInts=maps                     => AddEvent(SplitEvent, "princeStare",       new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {989884886});
    (actionInts=maps                     => AddEvent(SplitEvent, "EscapeDahaka01",    new List<string> {}, maps,                             () => IsCutsceneHit(maps) && current.storyValue == 10)) (new int[] {285231807});
    (actionInts=maps                     => AddEvent(SplitEvent, "serpentSword",      new List<string> {}, maps,                             () => IsCutsceneHit(maps) && current.storyValue == 13)) (new int[] {1006704429});
    (actionInts=maps                     => AddEvent(SplitEvent, "waterworks",        new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {687877048});
    (actionInts=maps                     => AddEvent(SplitEvent, "lionSword",         new List<string> {}, maps,                             () => IsCutsceneHit(maps) && current.storyValue == 21)) (new int[] {67112526});
    (actionInts=maps                     => AddEvent(SplitEvent, "mechElevator",      new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {687876652});
    (actionInts=maps                     => AddEvent(SplitEvent, "mechPortal",        new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {285235400});
    (actionInts=maps                     => AddEvent(SplitEvent, "activationRuin",    new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {67145437});
    (actionInts=maps                     => AddEvent(SplitEvent, "arPortal",          new List<string> {}, maps,                             () => IsCutsceneHit(maps) && current.storyValue == 18)) (new int[] {285235369});
    (actionInts=maps                     => AddEvent(SplitEvent, "activationRestore", new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {67145455});
    (actionInts=maps                     => AddEvent(SplitEvent, "exitTomb",          new List<string> {}, maps,                             () => IsCutsceneHit(maps) && current.zPos > 33)) (new int[] {135464247});
    (actionInts=maps                     => AddEvent(SplitEvent, "prPortal",          new List<string> {}, maps,                             () => IsCutsceneHit(maps) && current.storyValue == 40)) (new int[] {285235334});
    (actionInts=maps                     => AddEvent(SplitEvent, "maskOn",            new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {285231214});
    (actionInts=maps                     => AddEvent(SplitEvent, "scPortal",          new List<string> {}, maps,                             () => IsCutsceneHit(maps) && current.storyValue == 47)) (new int[] {285233531});
    (actionInts=maps                     => AddEvent(SplitEvent, "griffinV1",         new List<string> {}, maps,                             () => IsCutsceneHit(maps) && current.yPos < 195)) (new int[] {285231574});
    (actionInts=maps                     => AddEvent(SplitEvent, "ugPortal",          new List<string> {}, maps,                             () => IsCutsceneHit(maps) && current.storyValue == 50)) (new int[] {285235445});
    (actionInts=maps                     => AddEvent(SplitEvent, "mirroredFates",     new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {1006801611});
    (actionInts=maps                     => AddEvent(SplitEvent, "favorUnknown",      new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {135501700});
    (actionInts=maps                     => AddEvent(SplitEvent, "maskOff",           new List<string> {}, maps,                             () => IsCutsceneHit(maps) && current.storyValue == 64)) (new int[] {67112526});
    (actionInts=maps                     => AddEvent(SplitEvent, "Dahaka",            new List<string> {}, maps,                             () => IsCutsceneHit(maps) && current.yPos > 200)) (new int[] {989966868});

    (actionInts=maps                     => AddEvent(SplitEvent, "lastPortal",        new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {-1509855113, 285233488});
    (actionInts=maps                     => AddEvent(SplitEvent, "LULibrary",         new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {67144064, 67144084});
    (actionInts=maps                     => AddEvent(SplitEvent, "LUGarden",          new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {1006690753, 1006690755});
    (actionInts=maps                     => AddEvent(SplitEvent, "LUShahdee",         new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {285225347, 1006717295});
    (actionInts=maps                     => AddEvent(SplitEvent, "LU019",             new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {989860398, 1006711848});
    (actionInts=maps                     => AddEvent(SplitEvent, "gardenHall",        new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {135495097, 135495099});
    (actionInts=maps                     => AddEvent(SplitEvent, "libraryV1",         new List<string> {}, maps,                             () => IsCutsceneHit(maps))) (new int[] {67116816, 67116821});
    (actionInts=maps                     => AddEvent(SplitEvent, "LUWaterworks",      new List<string> {}, maps,                             () => IsCutsceneHit(maps) && current.xPos > 70)) (new int[] {687877046, 687877489});
    (actionInts=maps                     => AddEvent(SplitEvent, "WaterSword",        new List<string> {}, maps,                             () => IsCutsceneHit(maps) && old.xPos > -98)) (new int[] {1006704427, 1006704429});
    (actionInts=maps                     => AddEvent(SplitEvent, "LUPrison",          new List<string> {}, maps,                             () => IsCutsceneHit(maps) && current.xPos > -120)) (new int[] {135483948, 135516393, 16809649});
    (actionInts=maps                     => AddEvent(SplitEvent, "scorpionSword",     new List<string> {}, maps,                             () => IsCutsceneHit(maps) && current.xPos < -164)) (new int[] {135483948, 135483950, 135505359, 135516393, 16809649});

    (actionInts=maps                     => AddEvent(SplitEvent, "theSecondTower",    new List<string> {}, maps,                             () => IsMapOneOfCurrent(maps) && old.zPos < 402 && current.zPos >= 400 && current.storyValue == 15)) (new int[] {687907863});
    (actionInts=maps                     => AddEvent(SplitEvent, "mechTower",         new List<string> {}, maps,                             () => IsMapOneOfCurrent(maps) && old.zPos < 410 && current.zPos >= 410)) (new int[] {687876481});
    (actionInts=maps                     => AddEvent(SplitEvent, "sandWraithDeathV1", new List<string> {}, maps,                             () => IsMapOneOfCurrent(maps) && old.yPos < -13 && current.yPos >= -13 && current.zPos < 391 && current.storyValue == 33)) (new int[] {67112526});
    (actionInts=maps                     => AddEvent(SplitEvent, "sandWraithDeathV2", new List<string> {}, maps,                             () => IsMapOneOfCurrent(maps) && old.yPos < -7 && current.yPos >= -9 && current.storyValue == 33)) (new int[] {67112526});
    (actionInts=maps                     => AddEvent(SplitEvent, "libraryV2",         new List<string> {}, maps,                             () => IsMapOneOfCurrent(maps) && old.xPos < -112 && current.xPos >= -112 && current.storyValue == 42)) (new int[] {67116821});
    (actionInts=maps                     => AddEvent(SplitEvent, "libraryV3",         new List<string> {}, maps,                             () => IsMapOneOfCurrent(maps) && current.storyValue == 42 && old.xPos < -114 && current.xPos >= -115)) (new int[] {67116821});
    (actionInts=maps                     => AddEvent(SplitEvent, "griffinV2",         new List<string> {}, maps,                             () => IsMapOneOfCurrent(maps) && old.yPos > 166.5 && current.yPos <= 166.5)) (new int[] {285231574});
    (actionInts=maps                     => AddEvent(SplitEvent, "libraryRevisit",    new List<string> {}, maps,                             () => IsMapOneOfCurrent(maps) && old.xPos < -112 && current.xPos >= -112 && current.storyValue == 60)) (new int[] {67116821});

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
        "This game uses an in-game timer as the primary timing method.\nWould you like to switch to Game Time?",
        "LiveSplit | Prince of Persia: Warrior Within",
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

        ConfigureGameType(WW);
    };
    vars.Init = Init;

    // ================================================== exit ==================================================

    Action Exit = () => ConfigureGameType(NoGame);
    vars.Exit = Exit;

    // ================================================== onReset ==================================================

    OnReset = () =>
    {
        CompletedEvents.Clear();
        IgtValue = 0;
        print("CompletedEvents cleared.");
    };
    vars.OnReset = OnReset;

    // ================================================== update ==================================================

    var EmptyEventList = new List<Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>>>();
    Func<ExpandoObject, bool> Update = newOld =>
    {
        old = newOld;

        bool collectiblesUpdated = false;
        if (StoryValue        != (StoryValue        = current.storyValue))              timer.Run.Metadata.SetCustomVariable("storyGate",     StoryValue.ToString());
        if (VirtualChestBits  != (VirtualChestBits  = current.chestBits)  && ChestBits  != (ChestBits  = ChestMask  & VirtualChestBits)  && (collectiblesUpdated = true))
                                                                                        timer.Run.Metadata.SetCustomVariable("chests",        CountBits(ChestBits)        + " / " + MaxChests);
        if (VirtualWeaponBits != (VirtualWeaponBits = current.weaponBits) && WeaponBits != (WeaponBits = WeaponMask & VirtualWeaponBits) && (collectiblesUpdated = true))
        {
            if (MainWeaponBits   != (MainWeaponBits   = MainWeaponMask   & WeaponBits)) timer.Run.Metadata.SetCustomVariable("mainWeapons",   CountBits(MainWeaponBits)   + " / " + MaxMainWeapons);
            if (SwordBits        != (SwordBits        = SwordMask        & WeaponBits)) timer.Run.Metadata.SetCustomVariable("swords",        CountBits(SwordBits)        + " / " + MaxSwords);
            if (AxeBits          != (AxeBits          = AxeMask          & WeaponBits)) timer.Run.Metadata.SetCustomVariable("axes",          CountBits(AxeBits)          + " / " + MaxAxes);
            if (MaceBits         != (MaceBits         = MaceMask         & WeaponBits)) timer.Run.Metadata.SetCustomVariable("maces",         CountBits(MaceBits)         + " / " + MaxMaces);
            if (DaggerBits       != (DaggerBits       = DaggerMask       & WeaponBits)) timer.Run.Metadata.SetCustomVariable("daggers",       CountBits(DaggerBits)       + " / " + MaxDaggers);
            if (SecretWeaponBits != (SecretWeaponBits = SecretWeaponMask & WeaponBits)) timer.Run.Metadata.SetCustomVariable("secretWeapons", CountBits(SecretWeaponBits) + " / " + MaxSecretWeapons);
        }
        if (collectiblesUpdated)
        {
            int chests = CountBits(ChestBits);
            int weapons = CountBits(WeaponBits);
            int total = chests + weapons;
            string collectiblesText = total + "/" + MaxCollectibles + "\u2009-\u2009C:" + chests + ",\u2009W:" + weapons;
                                                                                        timer.Run.Metadata.SetCustomVariable("collectibles",  collectiblesText);
        }

        TriggeredEvent = null;
        int xyzHashCode = GetXyzHashCodeCurrent();
        int mapHashCode = current.map;
        List<Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>>> localXyzEvents;
        List<Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>>> localMapEvents;
        EventHashMap.TryGetValue(xyzHashCode, out localXyzEvents);
        EventHashMap.TryGetValue(mapHashCode, out localMapEvents);
        localXyzEvents = localXyzEvents ?? EmptyEventList;
        localMapEvents = localMapEvents ?? EmptyEventList;

        // print local events:
        //if (localXyzEvents.Count > 0) print("xyz: " + string.Join(", ", localXyzEvents.Select(@event => @event.Item2)));
        //if (localMapEvents.Count > 0) print("map: " + string.Join(", ", localMapEvents.Select(@event => @event.Item2)));

        // Concat function means we iterate through the lists one after the other; it does not create a concatenated list
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

    // ================================================== gameTime ==================================================

    Func<TimeSpan> GameTime = () =>
    {
        ulong tickDelta = current.physicsTicks - old.physicsTicks;

        // While rewinding, the scaled tick delta is used so that time doesn't run backwards
        if (tickDelta < 0) tickDelta = current.scaledTicks - old.scaledTicks;

        if (tickDelta > 0) IgtValue += tickDelta;

        return TimeSpan.FromSeconds(IgtValue * current.tickMul);
    };
    vars.GameTime = GameTime;

    // ====================================================================================================

    print("pop_ww.asl " + DateTime.Now.ToString());
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

isLoading
{
    return true;
}

gameTime
{
    return vars.GameTime();
}
