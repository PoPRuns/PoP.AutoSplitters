state("PrinceOfPersia_Launcher", "Digital")
{
    uint seedPtr  : 0x00B37F64; // pointer to seed object, is non-zero as soon as title screen starts playing
    int seedCount : 0x00B37F64, 0xDC;
    float x       : 0x00B30D08, 0x40;
    float y       : 0x00B30D08, 0x44;
    float z       : 0x00B30D08, 0x48;
    uint enemyPtr : 0x00B38130, 0x4E4, 0x444, 0x60, 0x8; // pointer to the object that contains enemy data; is zero if there is no enemy
    int enemyHp   : 0x00B38130, 0x4E4, 0x444, 0x60, 0x8, 0x250;
}

state("Prince of Persia", "DRM Free")
{
    uint seedPtr  : 0x00B37F64;
    int seedCount : 0x00B37F64, 0xDC;
    float x       : 0x00B30D08, 0x40;
    float y       : 0x00B30D08, 0x44;
    float z       : 0x00B30D08, 0x48;
    uint enemyPtr : 0x00B38130, 0x4E4, 0x444, 0x60, 0x8;
    int enemyHp   : 0x00B38130, 0x4E4, 0x444, 0x60, 0x8, 0x250;
}

state("Prince of Persia", "Unknown") { }

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
    const int BaseGame = 1;
    const int Epilogue = 2;
    const int GameCount = 3; // <---------------------------------------------------------------------------------------------------- game-specific (and AddEvent overloads, GetGameTypeString below)

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

    Action<int, string, List<string>, int[], Func<bool>> AddEventB = (eventType, slug, settingSlugs, hashCodes, condition)
        => AddEventBase(eventType, slug, settingSlugs, hashCodes, condition, emptyPostAction, BaseGame);

    Action<int, string, List<string>, int[], Func<bool>> AddEventE = (eventType, slug, settingSlugs, hashCodes, condition)
        => AddEventBase(eventType, slug, settingSlugs, hashCodes, condition, emptyPostAction, Epilogue);
    
    Action<int, string, List<string>, int[], Func<bool>, Action<bool>> AddEventB_ = 
        (eventType, slug, settingSlugs, hashCodes, condition, postAction)
        => AddEventBase(eventType, slug, settingSlugs, hashCodes, condition, postAction, BaseGame);

    Action<int, string, List<string>, int[], Func<bool>, Action<bool>> AddEventE_ =
        (eventType, slug, settingSlugs, hashCodes, condition, postAction)
        => AddEventBase(eventType, slug, settingSlugs, hashCodes, condition, postAction, Epilogue);
    
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
        case BaseGame: return "BaseGame";
        case Epilogue: return "Epilogue";
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

    bool GameTypeUpdateRequired = true;

    const float SeedRange = 5f;
    Func<float, float, float, bool> IsSeedGet = (xTarg, yTarg, zTarg)
    =>
        current.seedCount == old.seedCount + 1 &&
        current.x >= xTarg - SeedRange && current.x <= xTarg + SeedRange &&
        current.y >= yTarg - SeedRange && current.y <= yTarg + SeedRange &&
        current.z >= zTarg - SeedRange && current.z <= zTarg + SeedRange;
    
    // this is the moment the combat state finishes and the enemy HP bar disappears
    const float CombatRangeXy = 30f;
    const float CombatRangeZMinus = 2f;
    const float CombatRangeZPlus = 6f;
    Func<float, float, float, bool> IsCombatFin = (xTarg, yTarg, zTarg)
    =>
        old.enemyPtr != 0 && current.enemyPtr == 0 &&
        current.x >= xTarg - CombatRangeXy && current.x <= xTarg + CombatRangeXy &&
        current.y >= yTarg - CombatRangeXy && current.y <= yTarg + CombatRangeXy &&
        current.z >= zTarg - CombatRangeZMinus && current.z <= zTarg + CombatRangeZPlus;
    
    // this is the moment the enemy's HP goes to 0, but while we are still in combat state (assuming these two things overlap)
    // useful for Shapeshifter fights that have the teleport glitch, as the IsCombatFin split would reveal when a user can jump safely and would constitute memory viewing during the run
    //      which is against the rules
    Func<float, float, float, bool> IsEnemyHp0 = (xTarg, yTarg, zTarg)
    =>
        old.enemyHp > 0 && current.enemyPtr != 0 && current.enemyHp == 0 &&
        current.x >= xTarg - CombatRangeXy && current.x <= xTarg + CombatRangeXy &&
        current.y >= yTarg - CombatRangeXy && current.y <= yTarg + CombatRangeXy &&
        current.z >= zTarg - CombatRangeZMinus && current.z <= zTarg + CombatRangeZPlus;
    
    Func<float, float, float, int[]> HashSeed = (x, y, z) => HashXyzRange(x, y, z, SeedRange);
    Func<float, float, float, int[]> HashCombat = (x, y, z) => HashXyzBounds(x - CombatRangeXy, x + CombatRangeXy, y - CombatRangeXy, y + CombatRangeXy, z - CombatRangeZMinus, z + CombatRangeZPlus);
    
    // ===================================================================================================================
    // ================================================== CONFIGURATION ==================================================
    // ===================================================================================================================

    // ================================================== settings ==================================================

    //Default:bool    Slug:string            EventSlugs:List<string>                   Description:string                               ToolTip:string?                                                   ParentSlug:string?
    AddSetting(true,  "baseGame",            new List<string> {},                      "Base Game",                                     null,                                                             null);
    AddSetting(false, "epilogue",            new List<string> {},                      "Epilogue",                                      null,                                                             null);
    
    AddSetting(true,  "specialEvents",       new List<string> {},                      "Split on scripted game events",                 null,                                                             "baseGame");
    AddSetting(true,  "combatEvents",        new List<string> {},                      "Split on defeating enemies in specific levels", null,                                                             "baseGame");
    AddSetting(true,  "anyStandard",         new List<string> {},                      "Splits specific to the Any% (Standard) route",  null,                                                             "baseGame");
    AddSetting(false, "miscEvents",          new List<string> {},                      "Miscellaneous splits",                          null,                                                             "baseGame");
    AddSetting(false, "anyLegacy",           new List<string> {},                      "Legacy splits that are outdated for Any%",      null,                                                             "baseGame");

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
    AddSetting(false, "Dad3",                new List<string> {"Dad3"},                "Dad Fight 3",                                   "Splits on finishing the Dad 3 fight",                            "combatEvents");
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

    AddSetting(true,  "EDad1",               new List<string> {"EDad1"},               "Dad 1",                                         "Splits on finishing the Dad 1 fight",                            "epilogue");
    AddSetting(true,  "EAlleyway",           new List<string> {"EAlleyway"},           "Alleyway",                                      null,                                                             "epilogue");
    AddSetting(true,  "EWaterTank",          new List<string> {"EWaterTank"},          "Water Tank",                                    "Splits on entering the Shapeshifter 1 fight in Water Tank",      "epilogue");
    AddSetting(true,  "EShapeshifter1",      new List<string> {"EShapeshifter1"},      "Shapeshifter 1",                                "Splits on finishing the Shapeshifter 1 fight",                   "epilogue");
    AddSetting(true,  "EChimney",            new List<string> {"EChimney"},            "Chimney",                                       null,                                                             "epilogue");
    AddSetting(true,  "EPurplePlate",        new List<string> {"EPurplePlate"},        "Energize",                                      "Splits on cutscene where we obtain Purple plate",                "epilogue");
    AddSetting(true,  "EHammam",             new List<string> {"EHammam"},             "Hammam",                                        "Splits on entering the Shapeshifter 2 fight in Hammam",          "epilogue");
    AddSetting(true,  "EShapeshifter2",      new List<string> {"EShapeshifter2"},      "Shapeshifter 2",                                "Splits on finishing the Shapeshifter 2 fight",                   "epilogue");
    AddSetting(true,  "EAvenue",             new List<string> {"EAvenue"},             "Avenue",                                        null,                                                             "epilogue");
    AddSetting(true,  "EDad2",               new List<string> {"EDad2"},               "Dad 2",                                         "Splits on finishing the Dad 2 fight",                            "epilogue");
    AddSetting(true,  "ETunnel",             new List<string> {"ETunnel"},             "Tunnel",                                        "Splits on entering the Shapeshifter 3 fight in Tunnel",          "epilogue");
    AddSetting(true,  "EShapeshifter3",      new List<string> {"EShapeshifter3"},      "Shapeshifter 3",                                "Splits on finishing the Shapeshifter 3 fight",                   "epilogue");
    AddSetting(true,  "ETomb1",              new List<string> {"ETomb1"},              "Tomb I",                                        "Splits on entering the Dad 3 fight in Tomb",                     "epilogue");
    AddSetting(true,  "EDad3",               new List<string> {"EDad3"},               "Dad 3",                                         "Splits on finishing the Dad 3 fight",                            "epilogue");
    AddSetting(true,  "ETomb2",              new List<string> {"ETomb2"},              "Tomb II",                                       "Splits on entering the Shapeshifter 4 fight after Tomb",         "epilogue");
    AddSetting(true,  "EShapeshifter4",      new List<string> {"EShapeshifter4"},      "Shapeshifter 4",                                "Splits on finishing the Shapeshifter 4 fight",                   "epilogue");
    AddSetting(true,  "EDad4",               new List<string> {"EDad4"},               "Dad 4",                                         "Splits on finishing the Dad 4 fight",                            "epilogue");
    AddSetting(true,  "EBallroom",           new List<string> {"EBallroom"},           "Ballroom",                                      "Splits on finishing the Epilogue",                               "epilogue");

    // ================================================== events ==================================================

    Action action;
    Action<float, float, float> actionXyz;
    Action<float, float, float, float> actionXyzRange;
    Action<float, float, float, float, float> actionXyZRange;
    Action<float, float, float, float, float, float> actionXyzBounds;
    Action<int[]> actionInts;

    //                                                                                   SettingSlugs:
    //                                      EventType:int         Slug:string             List<string>                  HashCodes:int[]                   Condition:Func<bool>
    (actionXyzRange=(x,y,z,range)        => AddEventB(StartEvent, "StartLoad",           new List<string> {"baseGame"}, HashXyzRange(x,y,z,range),        () => InXyExactOldOnly(x, y))) (-465f, -351f, -24f, 5f);
    (actionXyzRange=(x,y,z,range)        => AddEventB(ResetEvent, "ResetLoad",           new List<string> {"baseGame"}, HashXyzRange(x,y,z,range),        () => InXyExactCurrentOnly(x, y))) (-465f, -351f, -24f, 5f);
    (actionXyzRange=(x,y,z,range)        => AddEventB(StartEvent, "StartNew",            new List<string> {"baseGame"}, HashXyzRange(x,y,z,5f),           () => InXyzRangeOldOnly(x, y, z, range))) (-462.302f, -348.223f, -23.956f, 0.003f);
    (actionXyzRange=(x,y,z,range)        => AddEventB(ResetEvent, "ResetNew",            new List<string> {"baseGame"}, HashXyzRange(x,y,z,range),        () => InXyzRangeCurrentOnly(x, y, z, range))) (-462.302f, -348.223f, -23.956f, 0.003f);

    (actionXyzRange=(x,y,z,range)        => AddEventB(SplitEvent, "CollapsingBridge",    new List<string> {},           HashXyzRange(x,y,z,range),        () => InXyzRangeCurrent(x, y, z, range))) (-310.25f, -241.0f, -30.2f, 0.2f);
    (actionXyzRange=(x,y,z,range)        => AddEventB(SplitEvent, "PreDad1",             new List<string> {},           HashXyzRange(x,y,z,range),        () => InXyzRangeCurrent(x, y, z, range))) (4f, -388.6f, -40f, 2f);
    (actionXyzRange=(x,y,z,range)        => AddEventB(SplitEvent, "ThiccCutscene",       new List<string> {},           HashXyzRange(x,y,z,range),        () => CompletedEvents.Contains("Dad1") && old.y < -238f && InXyzRangeCurrent(x, y, z, range))) (6f, -233.5f, -33f, 2f);
    (actionXyzRange=(x,y,z,range)        => AddEventB(SplitEvent, "RedPlate",            new List<string> {},           HashXyzRange(x,y,z,range),        () => InXyzRangeCurrent(x, y, z, range))) (-55f, -447f, -180f, 2f);
    (actionXyzRange=(x,y,z,range)        => AddEventB(SplitEvent, "BluePlate",           new List<string> {},           HashXyzRange(x,y,z,range),        () => InXyzRangeCurrent(x, y, z, range))) (45f, -456f, -180f, 2f);
    (actionXyzRange=(x,y,z,range)        => AddEventB(SplitEvent, "YellowPlate",         new List<string> {},           HashXyzRange(x,y,z,range),        () => InXyzRangeCurrent(x, y, z, range))) (-156f, -413f, -180f, 2f);
    (actionXyzRange=(x,y,z,range)        => AddEventB(SplitEvent, "GreenPlate",          new List<string> {},           HashXyzRange(x,y,z,range),        () => InXyzRangeCurrent(x, y, z, range))) (150f, -444f, -182f, 2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventB(SplitEvent, "TheGod",              new List<string> {},           HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (7.129f, 7.131f, -401.502f, -401.5f, -31.4f, -21f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventB(SplitEvent, "Resurrection",        new List<string> {},           HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (5.562f, 5.566f, -222.745f, -222.517f, -33.1f, -21f);

    (actionXyz=(x,y,z)                   => AddEventB(MiscEvent,  "Fight3_1",            new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (-186f, -140f, -32f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "ThirdFight",          new List<string> {},           HashCombat(x,y,z),                () => CompletedEvents.Contains("Fight3_1") && IsCombatFin(x, y, z))) (-186f, -140f, -32f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "Dad1",                new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (5f, -402f, -40f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "Dad2",                new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (6f, -187f, -48f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "Dad3",                new List<string> {},           HashCombat(x,y,z),                () => CompletedEvents.Contains("Dad2") && IsCombatFin(x, y, z))) (6f, -187f, -48f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "KingsGateH",          new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (-413.5f, -66.5f, 25f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "SunTempleH",          new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (-554.5f, -54f, 34f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "MarshallingGroundH",  new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (-761.5f, -17.5f, 19f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "MartyrsTowerH",       new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (-559.5f, 193.5f, 35f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "WindmillsH",          new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (-761f, 150f, 45f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "Hunter",              new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (-929.415f, 320.888f, -90.3f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "CauldronH",           new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (-168f, 225f, 20f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "ConstructionYardH",   new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (-251.5f, 456.5f, 31f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "MachineryGroundH",    new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (-400f, 457f, 18f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "MachineryGroundH2",   new List<string> {},           HashXyzExact(x,y,z),              () => InXyzExactCurrent(x, y, z))) (-393.2969971f, 517.6463623f, 56.27552414f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "ReservoirH",          new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (-156.5f, 571.5f, 8f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "HeavensStairH",       new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (-291f, 651.5f, 99.2f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "Alchemist",           new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (-296.593f, 697.233f, 296.199f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "CavernH",             new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (155f, 180.5f, -22.5f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "RoyalGardensH",       new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (265f, 381.5f, 35.5f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "SpireOfDreamsH",      new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (187.5f, 550f, 141.5f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "RoyalSpireH",         new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (468.5f, 426f, 141.5f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "CoronationHallH",     new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (340f, 582.5f, 32.5f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "Concubine",           new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (352.792f, 801.051f, 150.260f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "CityGateH",           new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (421.5f, -87.5f, -24f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "TowerOfAhrimanH",     new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (598.5f, 13.5f, 86f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "TowerOfOrmazdH",      new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (654f, 208f, -7f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "QueensTowerH",        new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (787f, -32.5f, 98.5f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "CityOfLightH",        new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (804f, 113f, -42.5f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "Warrior",             new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (1070.478f, 279.147f, -29.571f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "King",                new List<string> {},           HashCombat(x,y,z),                () => CompletedEvents.Contains("ThiccCutscene") && IsCombatFin(x, y, z))) (5f, -365f, -32f);

    (actionXyzRange=(x,y,z,range)        => AddEventB(SplitEvent, "NeoBarrierSkip",      new List<string> {},           HashXyzRange(x,y,z,range),        () => InXyzRangeCurrent(x, y, z, range))) (-331.5f, -4.5f, -9.9f, 1f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "KingsGate",           new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (-538.834f, -67.159f, 12.732f);
    (actionXyzRange=(x,y,z,range)        => AddEventB(SplitEvent, "SunTemple",           new List<string> {},           HashXyzRange(x,y,z,range),        () => InXyzRangeCurrent(x, y, z, range))) (-673.8f, -53.9f, 16.3f, 1f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "MarshGrounds",        new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (-806.671f, 112.803f, 21.645f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "Windmills",           new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (-597.945f, 209.241f, 23.339f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "MartyrsTower",        new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (-548f, 230f, 26f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "MachineryGround",     new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (-370f, 468f, 17f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "HeavensStair",        new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (-85.968f, 573.338f, 30.558f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "SpireOfDreams",       new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (266f, 602f, 36f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "CoronationHall",      new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (399f, 535f, 39.5f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "RoyalSpire1",         new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (-88.5f, 538.5f, 44.5f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "Reservoir",           new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (-150.082f, 406.606f, 34.673f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "ConstructionYard",    new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (-166f, 293f, 20.5f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "Cauldron",            new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (-12f, 135f, -15f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "Cavern",              new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (251.741f, 65.773f, -13.616f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "CityGate",            new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (547.488f, 45.41f, -27.107f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "TowerOfAhriman",      new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (667f, -14f, -30f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "QueensTower",         new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (842f, -16f, -40f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "CityOfLight",         new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (735f, 166f, -35f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "TowerOfOrmazd",       new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (655f, 227f, -37f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "RoyalSpire2",         new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (407f, 399f, 34f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "RoyalGardens",        new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (152f, 244f, 9f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "Cavern2",             new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (80f, 182f, -8f);

    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventB(SplitEvent, "DoubleJump",          new List<string> {},           HashXyzBounds(x1,x2,y1,y2,z1,z2), () => CompletedEvents.Contains("PreDad1") && InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (0f, 10f, -253f, -243f, -70f, -43f);

    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventB(SplitEvent, "BarrierSkip",         new List<string> {},           HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-208f, -200f, -38f, -27.5f, -51f, -41f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "SunTempleNDJE",       new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (-664f, -58f, 12f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "MartyrsTowerNDJE",    new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (-564.202f, 207.312f, 22f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "MTtoMG",              new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (-454.824f, 398.571f, 27.028f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "MachineryGroundNDJE", new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (-361.121f, 480.114f, 12.928f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "TowerOfOrmazdNDJE",   new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (609.907f, 61.905f, -35.001f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "QueensTowerNDJE",     new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (637.262f, 27.224f, -28.603f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "CoronationHallNDJE",  new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (340f, 590f, 19f);
    (actionXyz=(x,y,z)                   => AddEventB(SplitEvent, "Seed540",             new List<string> {},           HashSeed(x,y,z),                  () => IsSeedGet(x, y, z))) (-280f, 696f, 87f);

    // Epilogue
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventE(StartEvent, "EStart",              new List<string> {"epilogue"}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrentOnly(x1, x2, y1, y2, z1, z2))) (-117.9f, -117.4f, -433f, -432.5f, 19f, 19.027f);
    (actionXyzRange=(x,y,z,range)        => AddEventE(ResetEvent, "EResetNew",           new List<string> {"epilogue"}, HashXyzRange(x,y,z,range),        () => InXyzRangeCurrentOnly(x, y, z, range))) (-137f, -480f, 23f, 5f);

    (actionXyz=(x,y,z)                   => AddEventE(SplitEvent, "EDad1",               new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (-117f, -281f, 0f);
    (actionXyzRange=(x,y,z,range)        => AddEventE(SplitEvent, "EAlleyway",           new List<string> {},           HashXyzRange(x,y,z,range),        () => InXyzRangeCurrent(x, y, z, range))) (53f, -121f, -8f, 7f);
    (actionXyzRange=(x,y,z,range)        => AddEventE(SplitEvent, "EWaterTank",          new List<string> {},           HashXyzRange(x,y,z,range),        () => InXyzRangeCurrent(x, y, z, range))) (-47.2f, -71f, 22f, 0.1f);
    (actionXyz=(x,y,z)                   => AddEventE(SplitEvent, "EShapeshifter1",      new List<string> {},           HashCombat(x,y,z),                () => IsEnemyHp0(x, y, z))) (-60f, -71, 22f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventE(SplitEvent, "EChimney",            new List<string> {},           HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-118f, -115f, -73f, -68.9f, -125f, -123f);
    (actionXyzRange=(x,y,z,range)        => AddEventE(SplitEvent, "EPurplePlate",        new List<string> {},           HashXyzRange(x,y,z,range),        () => InXyzRangeCurrent(x, y, z, range))) (14.9f, 3.9f, -111.6f, 0.1f);
    (actionXyzRange=(x,y,z,range)        => AddEventE(SplitEvent, "EHammam",             new List<string> {},           HashXyzRange(x,y,z,range),        () => InXyzRangeCurrent(x, y, z, range))) (-5.7f, 25.6f, -136.1f, 0.1f);
    (actionXyz=(x,y,z)                   => AddEventE(SplitEvent, "EShapeshifter2",      new List<string> {},           HashCombat(x,y,z),                () => IsEnemyHp0(x, y, z))) (-15f, 29f, -136f);
    (actionXyzRange=(x,y,z,range)        => AddEventE(SplitEvent, "EAvenue",             new List<string> {},           HashXyzRange(x,y,z,range),        () => InXyzRangeCurrent(x, y, z, range))) (330.3f, 61.6f, -126.2f, 1f);
    (actionXyzRange=(x,y,z,range)        => AddEventE(SplitEvent, "EDad2",               new List<string> {},           HashXyzRange(x,y,z,range),        () => InXyzRangeCurrent(x, y, z, range))) (387.867f, 64.639f, -142.15f, 0.1f); // B2 B1^2 and B2 B2* yield different combat state ends, so we use coords only for this fight
    (actionXyZRange=(x,y,z,r1,r2)        => AddEventE(SplitEvent, "ETunnel",             new List<string> {},           HashXyZRange(x,y,z,r1,r2),        () => InXyZRangeCurrent(x, y, z, r1, r2))) (661.5f, 109.5f, -96.45f, 8f, 0.1f);
    (actionXyz=(x,y,z)                   => AddEventE(SplitEvent, "EShapeshifter3",      new List<string> {},           HashCombat(x,y,z),                () => IsEnemyHp0(x, y, z))) (676f, 108f, -96.5f);
    (actionXyzRange=(x,y,z,range)        => AddEventE(SplitEvent, "ETomb1",              new List<string> {},           HashXyzRange(x,y,z,range),        () => InXyzRangeCurrent(x, y, z, range))) (786.554f, 107.579f, -104.003f, 0.1f);
    (actionXyz=(x,y,z)                   => AddEventE(SplitEvent, "EDad3",               new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (803f, 108f, -104f);
    (actionXyzRange=(x,y,z,range)        => AddEventE(SplitEvent, "ETomb2",              new List<string> {},           HashXyzRange(x,y,z,range),        () => InXyzRangeCurrent(x, y, z, range))) (920f, 88.82f, -104f, 0.1f);
    (actionXyz=(x,y,z)                   => AddEventE(SplitEvent, "EShapeshifter4",      new List<string> {},           HashCombat(x,y,z),                () => IsEnemyHp0(x, y, z))) (920f, 76f, -104f);
    (actionXyz=(x,y,z)                   => AddEventE(SplitEvent, "EDad4",               new List<string> {},           HashCombat(x,y,z),                () => IsCombatFin(x, y, z))) (1105f, 43f, -140f);
    (actionXyzRange=(x,y,z,range)        => AddEventE(SplitEvent, "EBallroom",           new List<string> {},           HashXyzRange(x,y,z,range),        () => InXyzRangeCurrent(x, y, z, range))) (1247.5f, 43f, -55.8f, 0.1f);

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
    infoBuilder.AppendLine("\t" + "{EventType}     {Event}".PadRight(46) + " {HasXyzBounds} => {Count:[..Settings]}");
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
        "LiveSplit | Prince of Persia (2008)",
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

    Action<ExpandoObject, ExpandoObject, object, Process> Init = (newOld, newCurrent, newSettings, newGame) =>
    {
        old = newOld;
        current = newCurrent;
        settings = newSettings;
        game = newGame;

        GameTypeUpdateRequired = true;
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

        if (GameTypeUpdateRequired && current.seedPtr != 0)
        {
            int gameType = game.MainWindowTitle.ToLower().Contains("reenergized") ? Epilogue : BaseGame;
            ConfigureGameType(gameType);
            GameTypeUpdateRequired = false;
        }

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

    print("pop_2008.asl " + DateTime.Now.ToString());
}

init
{
    if (game.ProcessName == "PrinceOfPersia_Launcher")
        version = "Digital";
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

    vars.Init(old, current, settings, game);
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