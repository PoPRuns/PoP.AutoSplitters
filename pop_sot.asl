state("POP")
{
    // Some memory value that reliably changes when 'New Game' is pressed.
    int startValue      : 0x6BC980;

    // Prince's position
    float x             : 0x00699474, 0xC, 0x30;
    float y             : 0x00699474, 0xC, 0x34;
    float z             : 0x00699474, 0xC, 0x38;

    float xCam          : 0x006DA1B0, 0xC, 0x30;

    // The Vizier's health where 0 is unharmed and 4 is dead.
    int vizierHealth    : 0x0040E518, 0x6C, 0x18, 0x4, 0x44, 0x0;

    // Sand Capacity
    int maxSands        : 0x006DB8F4, 0x0;
    int sandPieces      : 0x006DB89C, 0x0;

    // 1 when rewinding, 0 otherwise
    byte rewind         : 0x006DC46C, 0x138;
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
    const int SoT = 1;
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
        => AddEventBase(eventType, slug, settingSlugs, hashCodes, condition, emptyPostAction, SoT);
    
    Action<int, string, List<string>, int[], Func<bool>, Action<bool>> AddEvent_ = 
        (eventType, slug, settingSlugs, hashCodes, condition, postAction)
        => AddEventBase(eventType, slug, settingSlugs, hashCodes, condition, postAction, SoT);
    
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
        case NoGame:   return "NoGame";
        case SoT:      return "SoT";
        default:       return "UnknownGame";
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

    int SandClouds = -1;

    // ===================================================================================================================
    // ================================================== CONFIGURATION ==================================================
    // ===================================================================================================================

    // ================================================== settings ==================================================

    //Default:bool    Slug:string               EventSlugs:List<string>                            Description:string                  ToolTip:string?                                                 ParentSlug:string?
    AddSetting(true,  "GasStation",             new List<string> {"GasStation"},                   "Enter Treasure Vaults",            "Split just before the first save prompt",                      null);
    AddSetting(true,  "SandsUnleashed",         new List<string> {"SandsUnleashed"},               "Sands Unleashed",                  "Split on starting the first fight after the CGI cutscene",     null);
    AddSetting(false, "FirstGuestRoom",         new List<string> {"FirstGuestRoom"},               "First Guest Room",                 "Split on entering the first guest room",                       null);
    AddSetting(false, "SultanChamberZipless",   new List<string> {"SultanChamberZipless"},         "The Sultan's Chamber",             "Split on entering the Sultan's chamber at the cutscene",       null);
    AddSetting(false, "SultanChamber",          new List<string> {"SultanChamber"},                "The Sultan's Chamber (death)",     "Split at the death abuse in Sultan's chamber",                 null);
    AddSetting(false, "PalaceDefence",          new List<string> {"PalaceDefence"},                "The Palace's Defence System",      "Split on exiting the palace defense system",                   null);
    AddSetting(false, "DadStart",               new List<string> {"DadStart"},                     "The Sand King",                    "Split on starting the fight with the Sand King",               null);
    AddSetting(true,  "DadDead",                new List<string> {"DadDead"},                      "Death of the Sand King",           "Split at the end of the fight on loading the next area",       null);
    AddSetting(false, "TheWarehouse",           new List<string> {"TheWarehouse"},                 "The Warehouse",                    "Split on hitting the button to let Farah enter Warehouse",     null);
    AddSetting(false, "TheZoo",                 new List<string> {"TheZoo"},                       "The Sultan's Zoo",                 "Split on entering the zoo",                                    null);
    AddSetting(false, "BirdCage",               new List<string> {"BirdCage"},                     "Atop a Bird Cage",                 "Split at the 'Atop a bird cage' save vortex",                  null);
    AddSetting(false, "CliffWaterfalls",        new List<string> {"CliffWaterfalls"},              "Cliffs and Waterfall",             "Split at the start of cliffs and waterfall",                   null);
    AddSetting(false, "TheBathsZipless",        new List<string> {"TheBathsZipless"},              "The Baths",                        "Split at the end of cliffs and Waterfall",                     null);
    AddSetting(false, "TheBaths",               new List<string> {"TheBaths"},                     "The Baths (death)",                "Split on death abuse at the start of baths",                   null);
    AddSetting(false, "SecondSword",            new List<string> {"SecondSword"},                  "Second Sword",                     "Split on obtaining the second sword at baths",                 null);
    AddSetting(false, "TheDaybreak",            new List<string> {"TheDaybreak"},                  "Daybreak",                         "Split at the start of daybreak",                               null);
    AddSetting(false, "TheMesshall",            new List<string> {"TheMesshall"},                  "Soldiers' Mess Hall (death)",      "Split on death abuse in the mess hall",                        null);
    AddSetting(false, "DrawbridgeTower",        new List<string> {"DrawbridgeTower"},              "Drawbridge Tower",                 "Split near the first lever at Drawbridge Tower",               null);
    AddSetting(false, "BrokenBridge",           new List<string> {"BrokenBridge"},                 "A Broken Bridge",                  "Split at the end of the collapsing bridge",                    null);
    AddSetting(false, "TheCavesZipless",        new List<string> {"TheCavesZipless"},              "The Caves",                        "Split on entering the caves after the door",                   null);
    AddSetting(false, "TheCaves",               new List<string> {"TheCaves"},                     "The Caves (alternate)",            "Split on the beam at the start of Waterfall",                  null);
    AddSetting(false, "TheWaterfall",           new List<string> {"TheWaterfall"},                 "The Waterfall",                    "Split at the end of the descent in Waterfall",                 null);
    AddSetting(false, "TheUGReservoirZipless",  new List<string> {"TheUGReservoirZipless"},        "Enter Underground Reservoir",      "Split on entering the underground reservoir",                  null);
    AddSetting(false, "OutOfTheWell",           new List<string> {"OutOfTheWell"},                 "Out Of The Well",                  "Split when exiting the well",                                  null);
    AddSetting(false, "TheUGReservoir",         new List<string> {"TheUGReservoir"},               "Exit Underground Reservoir",       "Split after the well, when passing through the archway",       null);
    AddSetting(false, "TheSultanHarem",         new List<string> {"TheSultanHarem"},               "The Sultan's Harem",               "Split on the sultan's harem",                                  null);
    AddSetting(false, "WhatDidYouCallMe",       new List<string> {"WhatDidYouCallMe"},             "What Did You Call Me",             "Split on The Sultan's Harem battle beginning",                 null);
    AddSetting(false, "HallofLearning",         new List<string> {"HallofLearning"},               "The Hall of Learning",             "Split on entering the hall of learning",                       null);
    AddSetting(false, "TheObservatory",         new List<string> {"TheObservatory"},               "Observatory (death)",              "Split on death abuse at the end of observatory",               null);
    AddSetting(false, "ObservatoryEnter",       new List<string> {"ObservatoryEnter"},             "Enter Observatory",                "Split on enter the observatory",                               null);
    AddSetting(false, "ObservatoryExit",        new List<string> {"ObservatoryExit"},              "Exit Observatory",                 "Split on exiting the observatory",                             null);
    AddSetting(false, "HoLCourtyardsExit",      new List<string> {"HoLCourtyardsExit"},            "Exit Hall of Learning Courtyards", "Split on exiting hall of learning courtyards",                 null);
    AddSetting(false, "TheAzadPrison",          new List<string> {"TheAzadPrison"},                "The Azad Prison",                  "Split on entering the prison",                                 null);
    AddSetting(false, "TortureChamberZipless",  new List<string> {"TortureChamberZipless"},        "Torture Chamber",                  "Split on entering the torture chamber",                        null);
    AddSetting(false, "TortureChamber",         new List<string> {"TortureChamber"},               "Torture Chamber (death)",          "Split on death abuse at the start of torture chamber",         null);
    AddSetting(false, "TheElevator",            new List<string> {"TheElevator"},                  "The Elevator",                     "Split on entering the elevator",                               null);
    AddSetting(false, "TheDreamZipless",        new List<string> {"TheDreamZipless"},              "A Magic Cavern",                   "Split at the start of the long unskippable cutscene",          null);
    AddSetting(false, "TheDream",               new List<string> {"TheDream"},                     "A Magic Cavern (alternate)",       "Split at the start of the 'infinite' stairs",                  null);
    AddSetting(false, "TheTomb",                new List<string> {"TheTomb"},                      "The Tomb",                         "Split at the start of the tomb",                               null);
    AddSetting(false, "TowerofDawn",            new List<string> {"TowerofDawn"},                  "Tower of Dawn",                    "Split at the start of the ascent back up the Tower of Dawn",   null);
    AddSetting(false, "SettingSun",             new List<string> {"SettingSun"},                   "Setting Sun",                      "Split on the Ladder near the setting sun save",                null);
    AddSetting(true,  "HonorGlory",             new List<string> {"HonorGlory"},                   "Honor and Glory",                  "Split on starting the last fight with enemies",                null);
    AddSetting(true,  "GrandRewind",            new List<string> {"GrandRewind"},                  "Grand Rewind",                     "Split on starting the Vizier fight",                           null);
    AddSetting(true,  "SoTEnd",                 new List<string> {"SoTEndCredits","SoTEndVizier"}, "The End",                          "Split on defeating the Vizier or hitting the credits trigger", null);
    AddSetting(false, "SoTLU",                  new List<string> {"SoTLU"},                        "Life Upgrades",                    "Split on obtaining each life upgrade",                         null);

    // ================================================== events ==================================================

    Action action;
    Action<float, float, float> actionXyz;
    Action<float, float, float, float> actionXyzRange;
    Action<float, float, float, float, float> actionXyZRange;
    Action<float, float, float, float, float, float> actionXyzBounds;
    Action<int[]> actionInts;

    //                                                                                     SettingSlugs:
    //                                      EventType:int         Slug:string               List<string>        HashCodes:int[]?                  Condition:Func<bool>
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(StartEvent,  "Start",                 new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2) && old.startValue != 1 && current.startValue == 1 && current.xCam <= -92.8f)) (-103.264f, -103.262f, -4.8f, -4.798f, 1.341f, 1.343f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(ResetEvent,  "Reset",                 new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2) && current.xCam <= -92f && current.xCam > -92.8f)) (-103.264f, -103.262f, -4.8f, -4.798f, 1.341f, 1.343f);

    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "GasStation",            new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (252f, 258f, 130.647f, 134f, 22.999f, 23.001f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "SandsUnleashed",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-6.177f, -6.175f, 62.905f, 62.907f, 7.604f, 7.606f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "FirstGuestRoom",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (30.297f, 30.299f, 42.126f, 42.128f, 12.998f, 13f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "SultanChamberZipless",  new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (98.445f, 98.447f, 39.567f, 39.57f, -8.96f, -8.958f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "SultanChamber",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (134.137f, 134.139f, 54.990f, 54.992f, -32.791f, -32.789f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "PalaceDefence",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (4.547f, 8.851f, 40.494f, 47.519f, -39.001f, -38.999f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "DadStart",              new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (6.714f, 6.716f, 57.698f, 57.7f, 21.005f, 21.007f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "DadDead",               new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-6.001f, -5.999f, -18.6f, -18.4f, 1.998f, 2.001f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TheWarehouse",          new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-73.352f, -71.233f, -28.5f, -26.868f, -1.001f, -0.818f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TheZoo",                new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-141.299f, -139.797f, -47.21f, -42.801f, -31.1f, -30.9f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "BirdCage",              new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-211f, -208f, -23f, -21f, -9f, -8.8f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "CliffWaterfalls",       new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-233.6f, -231.4f, 33.7f, 35f, -42.6f, -42.4f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TheBathsZipless",       new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-215.85f, -214.089f, 54.261f, 58.699f, -43.501f, -43.499f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TheBaths",              new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-211.427f, -211.425f, 56.602f, 56.604f, -43.501f, -43.499f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "SecondSword",           new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-106.819f, -106.817f, 81.097f, 81.099f, -27.269f, -27.267f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TheDaybreak",           new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-76f, -70f, 192.4f, 197.6f, -56.6f, -54f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TheMesshall",           new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-183.267f, -183.265f, 234.685f, 234.687f, -37.528f, -37.526f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "DrawbridgeTower",       new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-267f, -262f, 232f, 267f, -35.6f, -35.5f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "BrokenBridge",          new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-265f, -257f, 159f, 167f, -13.6f, -13.4f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TheCavesZipless",       new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-303f, -297.5f, 112f, 113.5f, -56.1f, -55.9f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TheCaves",              new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-246.839f, -241.677f, 78.019f, 87.936f, -71.731f, -70.7f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TheWaterfall",          new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-242f, -240.5f, 79.5f, 83f, -121f, -118f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TheUGReservoirZipless", new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-121f, -110f, -9f, -7f, -154.1f, -153.9f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "OutOfTheWell",          new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-62.93f, -62.61f, 58.10f, 58.12f, -26.18f, -24.09f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TheUGReservoir",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-51.477f, -48.475f, 72.155f, 73.657f, -24.802f, -24.799f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TheSultanHarem",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-9.3f, -6.604f, 148.46f, 151.7f, -24f, -23.8f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "WhatDidYouCallMe",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (35.90f, 38f, 134.01f, 137f, -23.99f, -23.8f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "HallofLearning",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (73f, 79f, 161f, 163f, -24.1f, -23.9f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TheObservatory",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (139.231f, 139.233f, 162.556f, 162.558f, -29.502f, -29.5f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "ObservatoryEnter",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (86.778f, 88.996f, 183.5f, 186.2f, -23.5f, -23.5f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "ObservatoryExit",       new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (137f, 141f, 164f, 164.67f, -29.5f, -29.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "HoLCourtyardsExit",     new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (72f, 77f, 90f, 95.7f, -27.1f, -26.9f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TheAzadPrison",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (190f, 195f, -21f, -19f, -17.6f, -17.3f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TortureChamberZipless", new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (187.5f, 192.5f, -39f, -37.5f, -119.1f, -118.9f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TortureChamber",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (189.999f, 190.001f, -43.278f, -43.276f, -119.001f, -118.999f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TheElevator",           new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (74f, 75f, -46.751f, -43.252f, -34f, -33f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TheDreamZipless",       new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (99f, 101f, -11f, -10f, -56f, -54f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TheDream",              new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (95.8f, 96f, -25.1f, -24.9f, -74.9f, -74.7f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TheTomb",               new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (100.643f, 100.645f, -11.543f, -11.541f, -67.588f, -67.586f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "TowerofDawn",           new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (35.5f, 35.7f, -50f, -39f, -32f, -30f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "SettingSun",            new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (60f, 61f, -58f, -57f, 30f, 32f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "HonorGlory",            new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (81f, 82f, -60.3f, -59.7f, 89f, 90f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "GrandRewind",           new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (660.376f, 660.378f, 190.980f, 190.983f, 0.432f, 0.434f);

    (actionXyZRange=(x,y,z,r1,r2)        => AddEvent(SplitEvent,  "SoTEndVizier",          new List<string> {}, HashXyZRange(x,y,z,r1,r2),        () => InXyZRangeCurrent(x, y, z, r1, r2) && current.vizierHealth == 4)) (660f, 213f, 0f, 10f, 3f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent(SplitEvent,  "SoTEndCredits",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2) && current.rewind == 0)) (658.26f, 661.46f, 210.92f, 213.72f, 9.8f, 12.5f);

    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEvent_(SplitEvent, "SoTLU",                 new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrentOnly(x1, x2, y1, y2, z1, z2), _ => CompletedEvents.Remove("SoTLU"))) (-492.608f, -492.606f, -248.833f, -248.831f, 0.219f, 0.221f);

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
        "LiveSplit | Prince of Persia: The Sands of Time",
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

        ConfigureGameType(SoT);
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

        int sandClouds = (current.maxSands - 4) * 8 + current.sandPieces;
        sandClouds = sandClouds > 0 ? sandClouds : 0;
        if (SandClouds != (SandClouds = sandClouds))
            timer.Run.Metadata.SetCustomVariable("sandClouds", SandClouds + " / 48");

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

    print("pop_sot.asl " + DateTime.Now.ToString());
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

