// SoT
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

// WW
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

// T2T
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
    const int SoT = 1;
    const int WW = 2;
    const int T2T = 3;
    const int GameCount = 4; // <---------------------------------------------------------------------------------------------------- game-specific (and AddEvent overloads, GetGameTypeString below)

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

    Action<int, string, List<string>, int[], Func<bool>> AddEventSoT = (eventType, slug, settingSlugs, hashCodes, condition)
        => AddEventBase(eventType, slug, settingSlugs, hashCodes, condition, emptyPostAction, SoT);
    
    Action<int, string, List<string>, int[], Func<bool>, Action<bool>> AddEventSoT_ = 
        (eventType, slug, settingSlugs, hashCodes, condition, postAction)
        => AddEventBase(eventType, slug, settingSlugs, hashCodes, condition, postAction, SoT);
    
    Action<int, string, List<string>, int[], Func<bool>> AddEventWW = (eventType, slug, settingSlugs, hashCodes, condition)
        => AddEventBase(eventType, slug, settingSlugs, hashCodes, condition, emptyPostAction, WW);
    
    Action<int, string, List<string>, int[], Func<bool>, Action<bool>> AddEventWW_ = 
        (eventType, slug, settingSlugs, hashCodes, condition, postAction)
        => AddEventBase(eventType, slug, settingSlugs, hashCodes, condition, postAction, WW);
    
    Action<int, string, List<string>, int[], Func<bool>> AddEventT2T = (eventType, slug, settingSlugs, hashCodes, condition)
        => AddEventBase(eventType, slug, settingSlugs, hashCodes, condition, emptyPostAction, T2T);
    
    Action<int, string, List<string>, int[], Func<bool>, Action<bool>> AddEventT2T_ = 
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
        case SoT:    return "SoT";
        case WW:     return "WW";
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

    int CurrentRun = NoGame; // this differs from CurrentGame in that it is NoGame between runs even when a game is opened
    TimeSpan GameTimeAtCurrentRunStart = TimeSpan.Zero;

    Action StartRun = () =>
    {
        CurrentRun = CurrentGame;
        GameTimeAtCurrentRunStart = timer.CurrentTime.GameTime ?? TimeSpan.Zero;
    };

    Action EndRun = () => CurrentRun = NoGame;

    // SoT

    int SoTSandClouds = -1;

    // WW

    // Gallery / tracker helpers (Hamming weight algorithm)
    Func<ulong, int> WWCountBits = (x) =>
    {
        x = x - ((x >> 1) & 0x5555555555555555UL);
        x = (x & 0x3333333333333333UL) + ((x >> 2) & 0x3333333333333333UL);
        x = (x + (x >> 4)) & 0x0F0F0F0F0F0F0F0FUL;
        x = x + (x >> 8);
        x = x + (x >> 16);
        x = x + (x >> 32);
        return (int)(x & 0x7F);
    };

    const ulong WWChestMask        = 0x0003FFFFFFFFFFFFUL;
    const ulong WWWeaponMask       = 0x37CFFFFFFFFFFFFEUL;
    const ulong WWMainWeaponMask   = 0x37C0000000000000UL;
    const ulong WWSwordMask        = 0x0005FFFF00000000UL;
    const ulong WWAxeMask          = 0x0002000000003FFEUL;
    const ulong WWMaceMask         = 0x000000000FF00000UL;
    const ulong WWDaggerMask       = 0x00000000000FC000UL;
    const ulong WWSecretWeaponMask = 0x00080000F0000000UL;

    // we set non-zero values to force an update on first game launch when they're all set to 0
    int WWStoryValue          = -1;
    ulong WWVirtualChestBits  = ulong.MaxValue; // virtual means before mask is applied
    ulong WWChestBits         = ulong.MaxValue;
    ulong WWVirtualWeaponBits = ulong.MaxValue;
    ulong WWWeaponBits        = ulong.MaxValue;
    ulong WWMainWeaponBits    = ulong.MaxValue;
    ulong WWSwordBits         = ulong.MaxValue;
    ulong WWAxeBits           = ulong.MaxValue;
    ulong WWMaceBits          = ulong.MaxValue;
    ulong WWDaggerBits        = ulong.MaxValue;
    ulong WWSecretWeaponBits  = ulong.MaxValue;

    string WWMaxChests        = WWCountBits(WWChestMask).ToString();
    string WWMaxWeapons       = WWCountBits(WWWeaponMask).ToString();
    string WWMaxMainWeapons   = WWCountBits(WWMainWeaponMask).ToString();
    string WWMaxSwords        = WWCountBits(WWSwordMask).ToString();
    string WWMaxAxes          = WWCountBits(WWAxeMask).ToString();
    string WWMaxMaces         = WWCountBits(WWMaceMask).ToString();
    string WWMaxDaggers       = WWCountBits(WWDaggerMask).ToString();
    string WWMaxSecretWeapons = WWCountBits(WWSecretWeaponMask).ToString();
    string WWMaxCollectibles  = (WWCountBits(WWChestMask) + WWCountBits(WWWeaponMask)).ToString();

    Func<int[], bool> WWIsMapOneOfCurrent = maps => Array.Exists(maps, map => map == current.map);

    Func<int[], bool> WWIsCutsceneHit = maps => old.cutscene == 0 && current.cutscene == 1 && Array.Exists(maps, map => map == current.map);
    Func<int[], bool> WWIsBossDie = maps => old.cutscene == 0 && current.cutscene == 1 && current.bossHealth == 0 && Array.Exists(maps, map => map == current.map);
    Func<int, bool> WWIsStoryGateAdv = storyId => old.storyValue != storyId && current.storyValue == storyId;
    Func<int, int, bool> WWIsMapChange = (oldMapId, currentMapId) => old.map == oldMapId && current.map == currentMapId;

    ulong WWIgtValue = 0;

    // T2T

    Func<float, float, float, float, bool> T2TIsCutsceneHit = (xTarg, yTarg, zTarg, range)
    =>
        old.princeAction != 17 && current.princeAction == 17 &&
        current.x >= xTarg - range && current.x <= xTarg + range &&
        current.y >= yTarg - range && current.y <= yTarg + range &&
        current.z >= zTarg - range && current.z <= zTarg + range;

    // ===================================================================================================================
    // ================================================== CONFIGURATION ==================================================
    // ===================================================================================================================

    // ================================================== settings ==================================================

    AddSetting(true, "MultiPoPSoT", new List<string> {"SoTStart"},                   "Prince of Persia: The Sands of Time", "Start/split for SoT", null);
    AddSetting(true, "MultiPoPWW",  new List<string> {"WWStart"},                    "Prince of Persia: Warrior Within",    "Start/split for WW",  null);
    AddSetting(true, "MultiPoPT2T", new List<string> {"T2TStartLoad","T2TStartNew"}, "Prince of Persia: The Two Thrones",   "Start/split for T2T", null);

    AddSetting(true, "SoTStartSplit", new List<string> {"SoTStartSplit"},                        "Start New Game", "Split on starting an SoT run", "MultiPoPSoT");
    AddSetting(true, "WWStartSplit",  new List<string> {"WWStartSplit"},                         "Start New Game", "Split on starting a WW run",   "MultiPoPWW");
    AddSetting(true, "T2TStartSplit", new List<string> {"T2TStartLoadSplit","T2TStartNewSplit"}, "Start New Game", "Split on starting a T2T run",  "MultiPoPT2T");

    // SoT

    //Default:bool    Slug:string               EventSlugs:List<string>                            Description:string                  ToolTip:string?                                                 ParentSlug:string?
    AddSetting(true,  "GasStation",             new List<string> {"GasStation"},                   "Enter Treasure Vaults",            "Split just before the first save prompt",                      "MultiPoPSoT");
    AddSetting(true,  "SandsUnleashed",         new List<string> {"SandsUnleashed"},               "Sands Unleashed",                  "Split on starting the first fight after the CGI cutscene",     "MultiPoPSoT");
    AddSetting(false, "FirstGuestRoom",         new List<string> {"FirstGuestRoom"},               "First Guest Room",                 "Split on entering the first guest room",                       "MultiPoPSoT");
    AddSetting(false, "SultanChamberZipless",   new List<string> {"SultanChamberZipless"},         "The Sultan's Chamber",             "Split on entering the Sultan's chamber at the cutscene",       "MultiPoPSoT");
    AddSetting(false, "SultanChamber",          new List<string> {"SultanChamber"},                "The Sultan's Chamber (death)",     "Split at the death abuse in Sultan's chamber",                 "MultiPoPSoT");
    AddSetting(false, "PalaceDefence",          new List<string> {"PalaceDefence"},                "The Palace's Defence System",      "Split on exiting the palace defense system",                   "MultiPoPSoT");
    AddSetting(false, "DadStart",               new List<string> {"DadStart"},                     "The Sand King",                    "Split on starting the fight with the Sand King",               "MultiPoPSoT");
    AddSetting(true,  "DadDead",                new List<string> {"DadDead"},                      "Death of the Sand King",           "Split at the end of the fight on loading the next area",       "MultiPoPSoT");
    AddSetting(false, "TheWarehouse",           new List<string> {"TheWarehouse"},                 "The Warehouse",                    "Split on hitting the button to let Farah enter Warehouse",     "MultiPoPSoT");
    AddSetting(false, "TheZoo",                 new List<string> {"TheZoo"},                       "The Sultan's Zoo",                 "Split on entering the zoo",                                    "MultiPoPSoT");
    AddSetting(false, "BirdCage",               new List<string> {"BirdCage"},                     "Atop a Bird Cage",                 "Split at the 'Atop a bird cage' save vortex",                  "MultiPoPSoT");
    AddSetting(false, "CliffWaterfalls",        new List<string> {"CliffWaterfalls"},              "Cliffs and Waterfall",             "Split at the start of cliffs and waterfall",                   "MultiPoPSoT");
    AddSetting(false, "TheBathsZipless",        new List<string> {"TheBathsZipless"},              "The Baths",                        "Split at the end of cliffs and Waterfall",                     "MultiPoPSoT");
    AddSetting(false, "TheBaths",               new List<string> {"TheBaths"},                     "The Baths (death)",                "Split on death abuse at the start of baths",                   "MultiPoPSoT");
    AddSetting(false, "SecondSword",            new List<string> {"SecondSword"},                  "Second Sword",                     "Split on obtaining the second sword at baths",                 "MultiPoPSoT");
    AddSetting(false, "TheDaybreak",            new List<string> {"TheDaybreak"},                  "Daybreak",                         "Split at the start of daybreak",                               "MultiPoPSoT");
    AddSetting(false, "TheMesshall",            new List<string> {"TheMesshall"},                  "Soldiers' Mess Hall (death)",      "Split on death abuse in the mess hall",                        "MultiPoPSoT");
    AddSetting(false, "DrawbridgeTower",        new List<string> {"DrawbridgeTower"},              "Drawbridge Tower",                 "Split near the first lever at Drawbridge Tower",               "MultiPoPSoT");
    AddSetting(false, "BrokenBridge",           new List<string> {"BrokenBridge"},                 "A Broken Bridge",                  "Split at the end of the collapsing bridge",                    "MultiPoPSoT");
    AddSetting(false, "TheCavesZipless",        new List<string> {"TheCavesZipless"},              "The Caves",                        "Split on entering the caves after the door",                   "MultiPoPSoT");
    AddSetting(false, "TheCaves",               new List<string> {"TheCaves"},                     "The Caves (alternate)",            "Split on the beam at the start of Waterfall",                  "MultiPoPSoT");
    AddSetting(false, "TheWaterfall",           new List<string> {"TheWaterfall"},                 "The Waterfall",                    "Split at the end of the descent in Waterfall",                 "MultiPoPSoT");
    AddSetting(false, "TheUGReservoirZipless",  new List<string> {"TheUGReservoirZipless"},        "Enter Underground Reservoir",      "Split on entering the underground reservoir",                  "MultiPoPSoT");
    AddSetting(false, "OutOfTheWell",           new List<string> {"OutOfTheWell"},                 "Out Of The Well",                  "Split when exiting the well",                                  "MultiPoPSoT");
    AddSetting(false, "TheUGReservoir",         new List<string> {"TheUGReservoir"},               "Exit Underground Reservoir",       "Split after the well, when passing through the archway",       "MultiPoPSoT");
    AddSetting(false, "TheSultanHarem",         new List<string> {"TheSultanHarem"},               "The Sultan's Harem",               "Split on the sultan's harem",                                  "MultiPoPSoT");
    AddSetting(false, "WhatDidYouCallMe",       new List<string> {"WhatDidYouCallMe"},             "What Did You Call Me",             "Split on The Sultan's Harem battle beginning",                 "MultiPoPSoT");
    AddSetting(false, "HallofLearning",         new List<string> {"HallofLearning"},               "The Hall of Learning",             "Split on entering the hall of learning",                       "MultiPoPSoT");
    AddSetting(false, "TheObservatory",         new List<string> {"TheObservatory"},               "Observatory (death)",              "Split on death abuse at the end of observatory",               "MultiPoPSoT");
    AddSetting(false, "ObservatoryEnter",       new List<string> {"ObservatoryEnter"},             "Enter Observatory",                "Split on enter the observatory",                               "MultiPoPSoT");
    AddSetting(false, "ObservatoryExit",        new List<string> {"ObservatoryExit"},              "Exit Observatory",                 "Split on exiting the observatory",                             "MultiPoPSoT");
    AddSetting(false, "HoLCourtyardsExit",      new List<string> {"HoLCourtyardsExit"},            "Exit Hall of Learning Courtyards", "Split on exiting hall of learning courtyards",                 "MultiPoPSoT");
    AddSetting(false, "TheAzadPrison",          new List<string> {"TheAzadPrison"},                "The Azad Prison",                  "Split on entering the prison",                                 "MultiPoPSoT");
    AddSetting(false, "TortureChamberZipless",  new List<string> {"TortureChamberZipless"},        "Torture Chamber",                  "Split on entering the torture chamber",                        "MultiPoPSoT");
    AddSetting(false, "TortureChamber",         new List<string> {"TortureChamber"},               "Torture Chamber (death)",          "Split on death abuse at the start of torture chamber",         "MultiPoPSoT");
    AddSetting(false, "TheElevator",            new List<string> {"TheElevator"},                  "The Elevator",                     "Split on entering the elevator",                               "MultiPoPSoT");
    AddSetting(false, "TheDreamZipless",        new List<string> {"TheDreamZipless"},              "A Magic Cavern",                   "Split at the start of the long unskippable cutscene",          "MultiPoPSoT");
    AddSetting(false, "TheDream",               new List<string> {"TheDream"},                     "A Magic Cavern (alternate)",       "Split at the start of the 'infinite' stairs",                  "MultiPoPSoT");
    AddSetting(false, "TheTomb",                new List<string> {"TheTomb"},                      "The Tomb",                         "Split at the start of the tomb",                               "MultiPoPSoT");
    AddSetting(false, "TowerofDawn",            new List<string> {"TowerofDawn"},                  "Tower of Dawn",                    "Split at the start of the ascent back up the Tower of Dawn",   "MultiPoPSoT");
    AddSetting(false, "SettingSun",             new List<string> {"SettingSun"},                   "Setting Sun",                      "Split on the Ladder near the setting sun save",                "MultiPoPSoT");
    AddSetting(true,  "HonorGlory",             new List<string> {"HonorGlory"},                   "Honor and Glory",                  "Split on starting the last fight with enemies",                "MultiPoPSoT");
    AddSetting(true,  "GrandRewind",            new List<string> {"GrandRewind"},                  "Grand Rewind",                     "Split on starting the Vizier fight",                           "MultiPoPSoT");
    AddSetting(true,  "SoTEnd",                 new List<string> {"SoTEndCredits","SoTEndVizier"}, "The End",                          "Split on defeating the Vizier or hitting the credits trigger", "MultiPoPSoT");
    AddSetting(false, "SoTLU",                  new List<string> {"SoTLU"},                        "Life Upgrades",                    "Split on obtaining each life upgrade",                         "MultiPoPSoT");

    // WW

    //Default:bool    Slug:string              EventSlugs:List<string>                  Description:string                              ToolTip:string?                                                                                      ParentSlug:string?
    AddSetting(false, "AnyGlitched",           new List<string> {},                     "Any% (Standard) and Any% (Zipless) splits",    null,                                                                                                "MultiPoPWW");
    AddSetting(false, "TEStandard",            new List<string> {},                     "True Ending (Standard) splits",                null,                                                                                                "MultiPoPWW");
    AddSetting(false, "TEZipless",             new List<string> {},                     "True Ending (Zipless) splits",                 null,                                                                                                "MultiPoPWW");
    AddSetting(false, "AnyNMG",                new List<string> {},                     "Any% (No Major Glitches) splits",              null,                                                                                                "MultiPoPWW");
    AddSetting(false, "TENMG",                 new List<string> {},                     "True Ending (No Major Glitches) splits",       null,                                                                                                "MultiPoPWW");

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

    // T2T

    //Default:bool    Slug:string          EventSlugs:List<string>                 Description:string                  ToolTip:string?                                                                     ParentSlug:string?
    AddSetting(false, "TheRamparts",       new List<string> {"TheRamparts"},       "The Ramparts",                     "Split after the harbor district save fountain",                                    "MultiPoPT2T");
    AddSetting(false, "HarborDistrict",    new List<string> {"HarborDistrict"},    "The Harbor District",              "Split after first palace save fountain",                                           "MultiPoPT2T");
    AddSetting(false, "ThePalace",         new List<string> {"ThePalace"},         "The Palace",                       "Split at the end of throne room",                                                  "MultiPoPT2T");
    AddSetting(false, "TrappedHallway",    new List<string> {"TrappedHallway"},    "The Trapped Hallway",              "Split at end of trapped hallway at the cutscene",                                  "MultiPoPT2T");
    AddSetting(false, "TheSewers",         new List<string> {"TheSewers"},         "The Sewers",                       "Split on finishing the sewers dark prince section",                                "MultiPoPT2T");
    AddSetting(false, "TheSewerz",         new List<string> {"TheSewerz"},         "The Sewers (alternate)",           "Split just before the tunnels save fountain",                                      "MultiPoPT2T");
    AddSetting(false, "TheFortress",       new List<string> {"TheFortress"},       "The Fortress",                     "Split just before entering the first Chariot",                                     "MultiPoPT2T");
    AddSetting(false, "Chariot1",          new List<string> {"Chariot1"},          "Chariot 1",                        "Split on finishing the first chariot",                                             "MultiPoPT2T");
    AddSetting(false, "LowerCity",         new List<string> {"LowerCity"},         "The Lower City",                   "Split after the lower city dark prince section",                                   "MultiPoPT2T");
    AddSetting(false, "LowerCityRooftops", new List<string> {"LowerCityRooftops"}, "The Lower City Rooftops",          "Split after killing Klompa",                                                       "MultiPoPT2T");
    AddSetting(false, "ArenaDeload",       new List<string> {"ArenaDeload"},       "Arena Deload",                     "Split at the black crushers in the arena dark prince section",                     "MultiPoPT2T");
    AddSetting(false, "TheBalconies",      new List<string> {"TheBalconies"},      "The Balconies",                    "Split on exiting the room with the slomo gate",                                    "MultiPoPT2T");
    AddSetting(false, "DarkAlley",         new List<string> {"DarkAlley"},         "The Dark Alley",                   "Split on entering the cutscene at start of temple rooftops",                       "MultiPoPT2T");
    AddSetting(false, "TheTempleRooftops", new List<string> {"TheTempleRooftops"}, "The Temple Rooftops",              "Split on entering the door into temple",                                           "MultiPoPT2T");
    AddSetting(false, "TheTempleRooftopz", new List<string> {"TheTempleRooftopz"}, "The Temple Rooftops (alternate)",  "Split on the ledge after the temple cutscene",                                     "MultiPoPT2T");
    AddSetting(false, "TheTemple",         new List<string> {"TheTemple"},         "The Temple",                       "Split on finishing the temple dark prince section",                                "MultiPoPT2T");
    AddSetting(false, "TheMarketplace",    new List<string> {"TheMarketplace"},    "The Marketplace",                  "Split at save fountain before cutscene drop",                                      "MultiPoPT2T");
    AddSetting(false, "MarketDistrict",    new List<string> {"MarketDistrict"},    "The Market District",              "Split at the save fountain after the long cutscene",                               "MultiPoPT2T");
    AddSetting(false, "TheBrothel",        new List<string> {"TheBrothel"},        "The Brothel",                      "Split on finishing the brothel dark prince section",                               "MultiPoPT2T");
    AddSetting(false, "ThePlaza",          new List<string> {"ThePlaza"},          "The Plaza",                        "Split at the door after Mahasti fight",                                            "MultiPoPT2T");
    AddSetting(false, "TheUpperCity",      new List<string> {"TheUpperCity"},      "The Upper City",                   "Split just before the skippable Farah cutscene",                                   "MultiPoPT2T");
    AddSetting(false, "CityGarderns",      new List<string> {"CityGarderns"},      "The City Garderns",                "Split just before the Stone Guardian encounter",                                   "MultiPoPT2T");
    AddSetting(false, "ThePromenade",      new List<string> {"ThePromenade"},      "The Promenade",                    "Split on entering the royal workshop",                                             "MultiPoPT2T");
    AddSetting(false, "RoyalWorkshop",     new List<string> {"RoyalWorkshop"},     "Royal Workshop",                   "Split on entering the king's road",                                                "MultiPoPT2T");
    AddSetting(false, "KingsRoad",         new List<string> {"KingsRoad"},         "The King's Road",                  "Split on defeating the twins",                                                     "MultiPoPT2T");
    AddSetting(false, "KingzRoad",         new List<string> {"KingzRoad"},         "The King's Road (alternate)",      "Split on the transition to palace entrance after twins fight",                     "MultiPoPT2T");
    AddSetting(false, "PalaceEntrance",    new List<string> {"PalaceEntrance"},    "The Palace Entrance",              "Split on entering the elevator cutscene",                                          "MultiPoPT2T");
    AddSetting(false, "HangingGardens",    new List<string> {"HangingGardens"},    "The Hanging Gardens",              "Split at the swing pole before the last sand gate",                                "MultiPoPT2T");
    AddSetting(false, "HangingGardenz",    new List<string> {"HangingGardenz"},    "The Hanging Gardens (alternate)",  "Split at the structure's mind save fountain",                                      "MultiPoPT2T");
    AddSetting(false, "StructuresMind",    new List<string> {"StructuresMind"},    "The Structure's Mind",             "Split at the cutscene after the puzzle",                                           "MultiPoPT2T");
    AddSetting(false, "StructurezMind",    new List<string> {"StructurezMind"},    "The Structure's Mind (alternate)", "Split after the transition to Well of Ancestors",                                  "MultiPoPT2T");
    AddSetting(false, "BottomofWell",      new List<string> {"BottomofWell"},      "Bottom of the Well",               "Split after the death abuse at the bottom of the well",                            "MultiPoPT2T");
    AddSetting(false, "WellofAncestors",   new List<string> {"WellofAncestors"},   "The Well of Ancestors",            "Split on finishing the well dark prince section",                                  "MultiPoPT2T");
    AddSetting(false, "TheLabyrinth",      new List<string> {"TheLabyrinth"},      "The Labyrinth",                    "Split on entering the underground cave after breakable wall",                      "MultiPoPT2T");
    AddSetting(false, "CaveDeath",         new List<string> {"CaveDeath"},         "Underground Cave Death",           "Split on the death abuse at the end of underground cave (for zipping categories)", "MultiPoPT2T");
    AddSetting(false, "UndergroundCave",   new List<string> {"UndergroundCave"},   "The Underground Cave",             "Split on entering the kitchen",                                                    "MultiPoPT2T");
    AddSetting(false, "LowerTower",        new List<string> {"LowerTower"},        "The Lower Tower",                  "Split on entering the trap corridor after lower tower",                            "MultiPoPT2T");
    AddSetting(false, "MiddleTower",       new List<string> {"MiddleTower"},       "The Middle Tower",                 "Split on entering the trap corridor after middle tower",                           "MultiPoPT2T");
    AddSetting(false, "UpperTower",        new List<string> {"UpperTower"},        "The Upper Tower",                  "Split at the upper tower save fountain",                                           "MultiPoPT2T");
    AddSetting(false, "TheTerrace",        new List<string> {"TheTerrace"},        "The Terrace",                      "Split on entering the mental realm",                                               "MultiPoPT2T");
    AddSetting(false, "MentalRealm",       new List<string> {"MentalRealm"},       "The Mental Realm",                 "Split on finishing the game",                                                      "MultiPoPT2T");
    AddSetting(false, "T2TLU1",            new List<string> {"T2TLU1"},            "Life Upgrade 1",                   "Split after obtaining the first life upgrade in Tunnels",                          "MultiPoPT2T");
    AddSetting(false, "T2TLU2",            new List<string> {"T2TLU2"},            "Life Upgrade 2",                   "Split after obtaining the second life upgrade in Lower City Rooftops",             "MultiPoPT2T");
    AddSetting(false, "T2TLU3",            new List<string> {"T2TLU3"},            "Life Upgrade 3",                   "Split after obtaining the third life upgrade in Temple",                           "MultiPoPT2T");
    AddSetting(false, "T2TLU4",            new List<string> {"T2TLU4"},            "Life Upgrade 4",                   "Split after obtaining the fourth life upgrade in Tunnels",                         "MultiPoPT2T");
    AddSetting(false, "T2TLU5",            new List<string> {"T2TLU5"},            "Life Upgrade 5",                   "Split after obtaining the fifth life upgrade in Canal",                            "MultiPoPT2T");
    AddSetting(false, "T2TLU6",            new List<string> {"T2TLU6"},            "Life Upgrade 6",                   "Split after obtaining the sixth life upgrade in Middle Tower",                     "MultiPoPT2T");

    // ================================================== events ==================================================

    Action action;
    Action<float, float, float> actionXyz;
    Action<float, float, float, float> actionXyzRange;
    Action<float, float, float, float, float> actionXyZRange;
    Action<float, float, float, float, float, float> actionXyzBounds;
    Action<int[]> actionInts;

    // SoT

    //                                                                                        SettingSlugs:
    //                                      EventType:int            Slug:string               List<string>        HashCodes:int[]?                  Condition:Func<bool>
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT_(StartEvent, "SoTStart",              new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => timer.CurrentPhase == TimerPhase.NotRunning && InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2) && old.startValue != 1 && current.startValue == 1 && current.xCam <= -92.8f, _ => CompletedEvents.Add("SoTStartSplit"))) (-103.264f, -103.262f, -4.8f, -4.798f, 1.341f, 1.343f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT_(SplitEvent, "SoTStartSplit",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => timer.CurrentPhase != TimerPhase.NotRunning && InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2) && old.startValue != 1 && current.startValue == 1 && current.xCam <= -92.8f, _ => StartRun())) (-103.264f, -103.262f, -4.8f, -4.798f, 1.341f, 1.343f);

    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "GasStation",            new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (252f, 258f, 130.647f, 134f, 22.999f, 23.001f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "SandsUnleashed",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-6.177f, -6.175f, 62.905f, 62.907f, 7.604f, 7.606f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "FirstGuestRoom",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (30.297f, 30.299f, 42.126f, 42.128f, 12.998f, 13f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "SultanChamberZipless",  new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (98.445f, 98.447f, 39.567f, 39.57f, -8.96f, -8.958f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "SultanChamber",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (134.137f, 134.139f, 54.990f, 54.992f, -32.791f, -32.789f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "PalaceDefence",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (4.547f, 8.851f, 40.494f, 47.519f, -39.001f, -38.999f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "DadStart",              new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (6.714f, 6.716f, 57.698f, 57.7f, 21.005f, 21.007f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "DadDead",               new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-6.001f, -5.999f, -18.6f, -18.4f, 1.998f, 2.001f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TheWarehouse",          new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-73.352f, -71.233f, -28.5f, -26.868f, -1.001f, -0.818f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TheZoo",                new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-141.299f, -139.797f, -47.21f, -42.801f, -31.1f, -30.9f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "BirdCage",              new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-211f, -208f, -23f, -21f, -9f, -8.8f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "CliffWaterfalls",       new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-233.6f, -231.4f, 33.7f, 35f, -42.6f, -42.4f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TheBathsZipless",       new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-215.85f, -214.089f, 54.261f, 58.699f, -43.501f, -43.499f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TheBaths",              new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-211.427f, -211.425f, 56.602f, 56.604f, -43.501f, -43.499f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "SecondSword",           new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-106.819f, -106.817f, 81.097f, 81.099f, -27.269f, -27.267f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TheDaybreak",           new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-76f, -70f, 192.4f, 197.6f, -56.6f, -54f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TheMesshall",           new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-183.267f, -183.265f, 234.685f, 234.687f, -37.528f, -37.526f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "DrawbridgeTower",       new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-267f, -262f, 232f, 267f, -35.6f, -35.5f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "BrokenBridge",          new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-265f, -257f, 159f, 167f, -13.6f, -13.4f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TheCavesZipless",       new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-303f, -297.5f, 112f, 113.5f, -56.1f, -55.9f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TheCaves",              new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-246.839f, -241.677f, 78.019f, 87.936f, -71.731f, -70.7f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TheWaterfall",          new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-242f, -240.5f, 79.5f, 83f, -121f, -118f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TheUGReservoirZipless", new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-121f, -110f, -9f, -7f, -154.1f, -153.9f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "OutOfTheWell",          new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-62.93f, -62.61f, 58.10f, 58.12f, -26.18f, -24.09f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TheUGReservoir",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-51.477f, -48.475f, 72.155f, 73.657f, -24.802f, -24.799f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TheSultanHarem",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-9.3f, -6.604f, 148.46f, 151.7f, -24f, -23.8f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "WhatDidYouCallMe",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (35.90f, 38f, 134.01f, 137f, -23.99f, -23.8f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "HallofLearning",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (73f, 79f, 161f, 163f, -24.1f, -23.9f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TheObservatory",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (139.231f, 139.233f, 162.556f, 162.558f, -29.502f, -29.5f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "ObservatoryEnter",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (86.778f, 88.996f, 183.5f, 186.2f, -23.5f, -23.5f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "ObservatoryExit",       new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (137f, 141f, 164f, 164.67f, -29.5f, -29.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "HoLCourtyardsExit",     new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (72f, 77f, 90f, 95.7f, -27.1f, -26.9f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TheAzadPrison",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (190f, 195f, -21f, -19f, -17.6f, -17.3f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TortureChamberZipless", new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (187.5f, 192.5f, -39f, -37.5f, -119.1f, -118.9f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TortureChamber",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (189.999f, 190.001f, -43.278f, -43.276f, -119.001f, -118.999f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TheElevator",           new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (74f, 75f, -46.751f, -43.252f, -34f, -33f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TheDreamZipless",       new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (99f, 101f, -11f, -10f, -56f, -54f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TheDream",              new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (95.8f, 96f, -25.1f, -24.9f, -74.9f, -74.7f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TheTomb",               new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (100.643f, 100.645f, -11.543f, -11.541f, -67.588f, -67.586f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "TowerofDawn",           new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (35.5f, 35.7f, -50f, -39f, -32f, -30f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "SettingSun",            new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (60f, 61f, -58f, -57f, 30f, 32f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "HonorGlory",            new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (81f, 82f, -60.3f, -59.7f, 89f, 90f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT(SplitEvent,  "GrandRewind",           new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (660.376f, 660.378f, 190.980f, 190.983f, 0.432f, 0.434f);

    (actionXyZRange=(x,y,z,r1,r2)        => AddEventSoT_(SplitEvent, "SoTEndVizier",          new List<string> {}, HashXyZRange(x,y,z,r1,r2),        () => InXyZRangeCurrent(x, y, z, r1, r2) && current.vizierHealth == 4, _ => EndRun())) (660f, 213f, 0f, 10f, 3f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT_(SplitEvent, "SoTEndCredits",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2) && current.rewind == 0, _ => EndRun())) (658.26f, 661.46f, 210.92f, 213.72f, 9.8f, 12.5f);

    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventSoT_(SplitEvent, "SoTLU",                 new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrentOnly(x1, x2, y1, y2, z1, z2), _ => CompletedEvents.Remove("SoTLU"))) (-492.608f, -492.606f, -248.833f, -248.831f, 0.219f, 0.221f);

    // WW

    //                                                                                   SettingSlugs:
    //                                      EventType:int           Slug:string           List<string>        HashCodes:int[]?                  Condition:Func<bool>
    (actionInts=maps                     => AddEventWW_(StartEvent, "WWStart",           new List<string> {}, maps,                             () => timer.CurrentPhase == TimerPhase.NotRunning && WWIsMapOneOfCurrent(maps) && old.cutscene == 1 && current.cutscene == 2, _ => CompletedEvents.Add("WWStartSplit"))) (new int[] {1292342859});
    (actionInts=maps                     => AddEventWW_(SplitEvent, "WWStartSplit",      new List<string> {}, maps,                             () => timer.CurrentPhase != TimerPhase.NotRunning && WWIsMapOneOfCurrent(maps) && old.cutscene == 1 && current.cutscene == 2, _ => StartRun())) (new int[] {1292342859});

    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventWW(SplitEvent,  "spPortalEnter",     new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (95.5f, 97.5f, -107f, -106f, 413.8f, 414.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventWW(SplitEvent,  "spPortalExit",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (95.5f, 97.5f, -107f, -106f, 113.8f, 114.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventWW(SplitEvent,  "mpPortalEnter",     new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-211f, -209f, 139f, 141f, 440.8f, 441.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventWW(SplitEvent,  "mpPortalExit",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-211f, -209f, 139f, 141f, 140.8f, 141.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventWW(SplitEvent,  "arPortalEnter",     new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-172f, -170f, 188f, 189f, 181.8f, 182.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventWW(SplitEvent,  "arPortalExit",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-172f, -170f, 188f, 189f, 481.8f, 482.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventWW(SplitEvent,  "Tomb",              new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2) && current.storyValue == 39)) (-94f, -93.5f, -193f, -185f, 18f, 18.1f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventWW(SplitEvent,  "prPortalEnter",     new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-71f, -69f, -117f, -115f, 19.8f, 20.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventWW(SplitEvent,  "prPortalExit",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-71f, -69f, -117f, -115f, 319.8f, 320.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventWW(SplitEvent,  "trPortalExit",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-53.5f, -51.5f, 113f, 114f, 117.8f, 118.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventWW(SplitEvent,  "scPortalEnter",     new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-72f, -70f, 273f, 274f, 132.8f, 133.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventWW(SplitEvent,  "scPortalExit",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-72f, -70f, 273f, 274f, 432.8f, 433.2f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventWW(SplitEvent,  "ugPortalEnter",     new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (78f, 80f, 107f, 108f, 412.3f, 412.7f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventWW(SplitEvent,  "ugPortalExit",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (78f, 80f, 107f, 108f, 112.3f, 112.7f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventWW(SplitEvent,  "mechtowercave",     new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2) && current.map == 67111336 && current.storyValue == 61)) (-218f, -216f, 0.4f, 4f, 445f, 446f);

    (actionInts=maps                     => AddEventWW(SplitEvent,  "boat",              new List<string> {}, maps,                             () => WWIsBossDie(maps))) (new int[] {67109218});
    (actionInts=maps                     => AddEventWW_(SplitEvent, "kaileena",          new List<string> {}, maps,                             () => WWIsBossDie(maps), _ => EndRun())) (new int[] {989966866});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "shahdee",           new List<string> {}, maps,                             () => WWIsBossDie(maps))) (new int[] {1006801609});

    (action=()                           => AddEventWW(SplitEvent,  "rng59",             new List<string> {}, null,                             () => WWIsStoryGateAdv(59))) ();
    (action=()                           => AddEventWW(SplitEvent,  "rng63",             new List<string> {}, null,                             () => WWIsStoryGateAdv(63))) ();
    (action=()                           => AddEventWW(SplitEvent,  "kaileenaFirst",     new List<string> {}, null,                             () => WWIsStoryGateAdv(38))) ();

    (actionInts=maps                     => AddEventWW(SplitEvent,  "banana",            new List<string> {}, maps,                             () => WWIsMapOneOfCurrent(maps) && old.secondaryWeapon != 50 && current.secondaryWeapon == 50)) (new int[] {587202754, 587203393});
    (action=()                           => AddEventWW(SplitEvent,  "foundryFountain",   new List<string> {}, null,                             () => (current.storyValue == 58 || current.storyValue == 59) && old.state != 11 && current.state == 11)) ();

    (actionInts=maps                     => AddEventWW(SplitEvent,  "hourglassRevisit",  new List<string> {}, maps,                             () => WWIsMapChange(1006704427, maps[0]) && current.storyValue == 45)) (new int[] {1006704429});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "trPortalEnter",     new List<string> {}, maps,                             () => WWIsMapChange(1006704431, maps[0]) && current.storyValue == 45)) (new int[] {-1509855113});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "trPortal",          new List<string> {}, maps,                             () => WWIsMapChange(-1509855113, maps[0]) && current.storyValue == 45)) (new int[] {285233488});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "mysticcaves",       new List<string> {}, maps,                             () => WWIsMapChange(67116810, maps[0]) && current.storyValue == 60)) (new int[] {1006801523});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "kaileenaPresent",   new List<string> {}, maps,                             () => WWIsMapChange(-1509855113, maps[0]) && current.storyValue == 66)) (new int[] {285233488});

    (actionInts=maps                     => AddEventWW(SplitEvent,  "ravenMan",          new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {135462572});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "firstPortal",       new List<string> {}, maps,                             () => WWIsCutsceneHit(maps) && current.storyValue == 2)) (new int[] {285231807});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "LUFortress",        new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {135501679});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "LUMechTower",       new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {67145445});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "LUCentralHall",     new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {67144144});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "spiderSword",       new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {135462576});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "chasingShahdee",    new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {989860400});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "shahdeeFight",      new List<string> {}, maps,                             () => WWIsCutsceneHit(maps) && current.storyValue == 8)) (new int[] {285225353});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "spPortal",          new List<string> {}, maps,                             () => WWIsCutsceneHit(maps) && current.storyValue == 8)) (new int[] {285235301});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "princeStare",       new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {989884886});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "EscapeDahaka01",    new List<string> {}, maps,                             () => WWIsCutsceneHit(maps) && current.storyValue == 10)) (new int[] {285231807});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "serpentSword",      new List<string> {}, maps,                             () => WWIsCutsceneHit(maps) && current.storyValue == 13)) (new int[] {1006704429});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "waterworks",        new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {687877048});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "lionSword",         new List<string> {}, maps,                             () => WWIsCutsceneHit(maps) && current.storyValue == 21)) (new int[] {67112526});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "mechElevator",      new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {687876652});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "mechPortal",        new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {285235400});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "activationRuin",    new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {67145437});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "arPortal",          new List<string> {}, maps,                             () => WWIsCutsceneHit(maps) && current.storyValue == 18)) (new int[] {285235369});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "activationRestore", new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {67145455});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "exitTomb",          new List<string> {}, maps,                             () => WWIsCutsceneHit(maps) && current.z > 33)) (new int[] {135464247});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "prPortal",          new List<string> {}, maps,                             () => WWIsCutsceneHit(maps) && current.storyValue == 40)) (new int[] {285235334});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "maskOn",            new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {285231214});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "scPortal",          new List<string> {}, maps,                             () => WWIsCutsceneHit(maps) && current.storyValue == 47)) (new int[] {285233531});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "griffinV1",         new List<string> {}, maps,                             () => WWIsCutsceneHit(maps) && current.y < 195)) (new int[] {285231574});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "ugPortal",          new List<string> {}, maps,                             () => WWIsCutsceneHit(maps) && current.storyValue == 50)) (new int[] {285235445});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "mirroredFates",     new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {1006801611});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "favorUnknown",      new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {135501700});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "maskOff",           new List<string> {}, maps,                             () => WWIsCutsceneHit(maps) && current.storyValue == 64)) (new int[] {67112526});
    (actionInts=maps                     => AddEventWW_(SplitEvent, "Dahaka",            new List<string> {}, maps,                             () => WWIsCutsceneHit(maps) && current.y > 200, _ => EndRun())) (new int[] {989966868});

    (actionInts=maps                     => AddEventWW(SplitEvent,  "lastPortal",        new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {-1509855113, 285233488});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "LULibrary",         new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {67144064, 67144084});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "LUGarden",          new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {1006690753, 1006690755});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "LUShahdee",         new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {285225347, 1006717295});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "LU019",             new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {989860398, 1006711848});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "gardenHall",        new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {135495097, 135495099});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "libraryV1",         new List<string> {}, maps,                             () => WWIsCutsceneHit(maps))) (new int[] {67116816, 67116821});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "LUWaterworks",      new List<string> {}, maps,                             () => WWIsCutsceneHit(maps) && current.x > 70)) (new int[] {687877046, 687877489});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "WaterSword",        new List<string> {}, maps,                             () => WWIsCutsceneHit(maps) && old.x > -98)) (new int[] {1006704427, 1006704429});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "LUPrison",          new List<string> {}, maps,                             () => WWIsCutsceneHit(maps) && current.x > -120)) (new int[] {135483948, 135516393, 16809649});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "scorpionSword",     new List<string> {}, maps,                             () => WWIsCutsceneHit(maps) && current.x < -164)) (new int[] {135483948, 135483950, 135505359, 135516393, 16809649});

    (actionInts=maps                     => AddEventWW(SplitEvent,  "theSecondTower",    new List<string> {}, maps,                             () => WWIsMapOneOfCurrent(maps) && old.z < 402 && current.z >= 400 && current.storyValue == 15)) (new int[] {687907863});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "mechTower",         new List<string> {}, maps,                             () => WWIsMapOneOfCurrent(maps) && old.z < 410 && current.z >= 410)) (new int[] {687876481});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "sandWraithDeathV1", new List<string> {}, maps,                             () => WWIsMapOneOfCurrent(maps) && old.y < -13 && current.y >= -13 && current.z < 391 && current.storyValue == 33)) (new int[] {67112526});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "sandWraithDeathV2", new List<string> {}, maps,                             () => WWIsMapOneOfCurrent(maps) && old.y < -7 && current.y >= -9 && current.storyValue == 33)) (new int[] {67112526});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "libraryV2",         new List<string> {}, maps,                             () => WWIsMapOneOfCurrent(maps) && old.x < -112 && current.x >= -112 && current.storyValue == 42)) (new int[] {67116821});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "libraryV3",         new List<string> {}, maps,                             () => WWIsMapOneOfCurrent(maps) && current.storyValue == 42 && old.x < -114 && current.x >= -115)) (new int[] {67116821});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "griffinV2",         new List<string> {}, maps,                             () => WWIsMapOneOfCurrent(maps) && old.y > 166.5 && current.y <= 166.5)) (new int[] {285231574});
    (actionInts=maps                     => AddEventWW(SplitEvent,  "libraryRevisit",    new List<string> {}, maps,                             () => WWIsMapOneOfCurrent(maps) && old.x < -112 && current.x >= -112 && current.storyValue == 60)) (new int[] {67116821});

    // T2T

    //                                                                                    SettingSlugs:
    //                                      EventType:int            Slug:string           List<string>        HashCodes:int[]?                  Condition:Func<bool>
    (actionXyzRange=(x,y,z,range)        => AddEventT2T_(StartEvent, "T2TStartLoad",      new List<string> {}, HashXyzRange(x,y,z,range),        () => timer.CurrentPhase == TimerPhase.NotRunning && InXyzRangeCurrent(x, y, z, range) && old.saveLoad == 0 && current.saveLoad == 1, _ => { CompletedEvents.Add("T2TStartLoadSplit"); CompletedEvents.Add("T2TStartNewSplit"); })) (-408.3f, 116.9f, 61.9f, 0.5f);
    (actionXyzRange=(x,y,z,range)        => AddEventT2T_(SplitEvent, "T2TStartLoadSplit", new List<string> {}, HashXyzRange(x,y,z,range),        () => timer.CurrentPhase != TimerPhase.NotRunning && InXyzRangeCurrent(x, y, z, range) && old.saveLoad == 0 && current.saveLoad == 1, _ => { CompletedEvents.Add("T2TStartNewSplit"); StartRun(); })) (-408.3f, 116.9f, 61.9f, 0.5f);
    (actionXyzRange=(x,y,z,range)        => AddEventT2T_(StartEvent, "T2TStartNew",       new List<string> {}, HashXyzRange(x,y,z,range),        () => timer.CurrentPhase == TimerPhase.NotRunning && InXBoundsCurrent(-404.9f, -404.8f) && InBounds(0.8318f, 0.832f, current.xCam) && InBounds(0.108f, 0.1082f, current.yCam) && !(InXBoundsOld(-404.9f, -404.8f) && InBounds(0.8318f, 0.832f, old.xCam) && InBounds(0.108f, 0.1082f, old.yCam)), _ => { CompletedEvents.Add("T2TStartLoadSplit"); CompletedEvents.Add("T2TStartNewSplit"); })) (-405f, 117f, 62f, 5f);
    (actionXyzRange=(x,y,z,range)        => AddEventT2T_(SplitEvent, "T2TStartNewSplit",  new List<string> {}, HashXyzRange(x,y,z,range),        () => timer.CurrentPhase != TimerPhase.NotRunning && InXBoundsCurrent(-404.9f, -404.8f) && InBounds(0.8318f, 0.832f, current.xCam) && InBounds(0.108f, 0.1082f, current.yCam) && !(InXBoundsOld(-404.9f, -404.8f) && InBounds(0.8318f, 0.832f, old.xCam) && InBounds(0.108f, 0.1082f, old.yCam)), _ => { CompletedEvents.Add("T2TStartLoadSplit"); StartRun(); })) (-405f, 117f, 62f, 5f);

    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "TheRamparts",       new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-271f, -265f, 187f, 188f, 74f, 75f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "HarborDistrict",    new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-93f, -88f, 236.2f, 238f, 83f, 88f);
    (actionXyzRange=(x,y,z,range)        => AddEventT2T(SplitEvent,  "ThePalace",         new List<string> {}, HashXyzRange(x,y,z,range),        () => T2TIsCutsceneHit(x, y, z, range))) (-35f, 232f, 147f, 10f);
    (actionXyzRange=(x,y,z,range)        => AddEventT2T(SplitEvent,  "TrappedHallway",    new List<string> {}, HashXyzRange(x,y,z,range),        () => T2TIsCutsceneHit(x, y, z, range))) (-52f, 134f, 76f, 10f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "TheSewerz",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-100f, -96f, -83f, -79f, 19.9f, 20f);
    (actionXyzRange=(x,y,z,range)        => AddEventT2T(SplitEvent,  "TheSewers",         new List<string> {}, HashXyzRange(x,y,z,range),        () => T2TIsCutsceneHit(x, y, z, range))) (-89f, -15f, 5f, 10f);
    (actionXyzRange=(x,y,z,range)        => AddEventT2T(SplitEvent,  "TheFortress",       new List<string> {}, HashXyzRange(x,y,z,range),        () => T2TIsCutsceneHit(x, y, z, range))) (-71f, 10f, 44f, 10f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "Chariot1",          new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-443.37f, -443.36f, 355.80f, 355.81f, 57.71f, 57.72f);
    (actionXyzRange=(x,y,z,range)        => AddEventT2T(SplitEvent,  "LowerCity",         new List<string> {}, HashXyzRange(x,y,z,range),        () => T2TIsCutsceneHit(x, y, z, range))) (-318f, 330f, 96f, 10f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "LowerCityRooftops", new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-261.5f, -261f, 318f, 319.5f, 46f, 48f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "ArenaDeload",       new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-256.1f, -251.9f, 358f, 361.5f, 53.9f, 63.3f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "TheBalconies",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-194f, -190f, 328f, 329.7f, 32.6f, 33.6f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "DarkAlley",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-114f, -110f, 328f, 338f, 55f, 59f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "TheTempleRooftops", new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-122.6f, -117.7f, 421.6f, 423f, 107f, 108.1f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "TheTempleRooftopz", new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-126f, -125f, 424f, 426f, 100f, 100.1f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "TheTemple",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-213f, -210f, 419.0f, 421f, 80.5f, 82.5f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "TheMarketplace",    new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-213f, -207f, 484f, 490f, 101f, 103f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "MarketDistrict",    new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-185.5f, -175.5f, 524f, 530f, 90f, 92f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "TheBrothel",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-152.3f, -152.0f, 549.8f, 549.9f, 91.8f, 92f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "ThePlaza",          new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-104f, -100f, 548f, 553f, 105.5f, 106.1f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "TheUpperCity",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-124.5f, -122.5f, 500f, 505f, 97f, 99f);
    (actionXyzRange=(x,y,z,range)        => AddEventT2T(SplitEvent,  "CityGarderns",      new List<string> {}, HashXyzRange(x,y,z,range),        () => T2TIsCutsceneHit(x, y, z, range))) (-63f, 390f, 85f, 10f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "ThePromenade",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-3f, -1f, 515f, 519f, 72f, 75f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "RoyalWorkshop",     new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (58f, 62f, 470f, 480f, 79f, 81f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "KingsRoad",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (91.9289f, 91.9290f, 230.0479f, 230.0480f, 70.9877f, 70.9879f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "KingzRoad",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (53f, 70f, 240f, 250f, 70f, 73f);
    (actionXyzRange=(x,y,z,range)        => AddEventT2T(SplitEvent,  "PalaceEntrance",    new List<string> {}, HashXyzRange(x,y,z,range),        () => T2TIsCutsceneHit(x, y, z, range))) (31f, 271f, 126f, 10f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "HangingGardens",    new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (26f, 28f, 211f, 213f, 191f, 193f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "HangingGardenz",    new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (5.2f, 5.4f, 213.5f, 215.6f, 194.9f, 196.2f);
    (actionXyzRange=(x,y,z,range)        => AddEventT2T(SplitEvent,  "StructuresMind",    new List<string> {}, HashXyzRange(x,y,z,range),        () => T2TIsCutsceneHit(x, y, z, range))) (-30f, 245f, 179f, 10f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "StructurezMind",    new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (5f, 12f, 243f, 265f, 104f, 104.1f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "BottomofWell",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-21.35f, -21.34f, 252.67f, 252.68f, 20.95f, 20.96f);
    (actionXyzRange=(x,y,z,range)        => AddEventT2T(SplitEvent,  "WellofAncestors",   new List<string> {}, HashXyzRange(x,y,z,range),        () => T2TIsCutsceneHit(x, y, z, range))) (-13f, 241f, 1f, 10f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "CaveDeath",         new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (5.99f, 6.00f, 306.96f, 306.97f, 42f, 42.01f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "TheLabyrinth",      new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-25.5f, -23f, 325f, 338f, 35.9f, 37.5f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "UndergroundCave",   new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-11f, -9f, 327f, 334f, 73f, 74f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "LowerTower",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-5f, -3f, 316f, 317.5f, 139.9f, 140.1f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "MiddleTower",       new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-18f, -12f, 303f, 305f, 184.8f, 185.1f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "UpperTower",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-8f, -7f, 296f, 298f, 226.9f, 227f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "TheTerrace",        new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-7.2f, -6.9f, 245.6f, 245.9f, 677f, 679f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T_(SplitEvent, "MentalRealm",       new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2) && current.princeAction == 17, _ => EndRun())) (189f, 194f, 318f, 330f, 540f, 560f);

    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "T2TLU1",            new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-14.9972f, -14.9970f, -112.8152f, -112.8150f, 20.0732f, 20.0734f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "T2TLU2",            new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-302.0919f, -302.0917f, 370.8710f, 370.8712f, 52.858f, 52.8582f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "T2TLU3",            new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-187.3369f, -187.3367f, -455.9863f, 455.9865f, 78.0330f, 78.0332f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "T2TLU4",            new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-55.0147f, -55.0145f, 395.7608f, 395.761f, 72.0774f, 72.0776f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "T2TLU5",            new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-30.1223f, -30.1221f, 281.8893f, 281.8895f, 104.0796f, 104.0798f);
    (actionXyzBounds=(x1,x2,y1,y2,z1,z2) => AddEventT2T(SplitEvent,  "T2TLU6",            new List<string> {}, HashXyzBounds(x1,x2,y1,y2,z1,z2), () => InXyzBoundsCurrent(x1, x2, y1, y2, z1, z2))) (-23.9663f, -23.9661f, 253.9438f, 253.944f, 183.0634f, 183.0636f);

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
        "LiveSplit | Multi-Prince of Persia-Runs",
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

    Action<ExpandoObject, ExpandoObject, object, Process> Init = (newOld, newCurrent, newSettings, newGame) =>
    {
        old = newOld;
        current = newCurrent;
        settings = newSettings;
        game = newGame;

        switch (game.ProcessName.ToLower())
        {
        case "pop":  ConfigureGameType(SoT);                                     break;
        case "pop2": ConfigureGameType(WW);                                      break;
        case "pop3": ConfigureGameType(T2T);                                     break;
        default:     print("WARNING: Unknown game process " + game.ProcessName); break;
        }
    };
    vars.Init = Init;

    // ================================================== exit ==================================================

    Action Exit = () => ConfigureGameType(NoGame);
    vars.Exit = Exit;

    // ================================================== onStart ==================================================

    Action OnStart = () => StartRun();
    vars.OnStart = OnStart;

    // ================================================== onReset ==================================================

    OnReset = () =>
    {
        CompletedEvents.Clear();
        print("CompletedEvents cleared.");
        WWIgtValue = 0;
        EndRun();
    };
    vars.OnReset = OnReset;

    // ================================================== update ==================================================

    var EmptyEventList = new List<Tuple<int, string, List<string>, int[], Func<bool>, Action<bool>>>();
    Func<ExpandoObject, bool> Update = newOld =>
    {
        old = newOld;

        // set custom variables
        switch (CurrentGame)
        {
        case SoT:
            int sandClouds = (current.maxSands - 4) * 8 + current.sandPieces;
            sandClouds = sandClouds > 0 ? sandClouds : 0;
            if (SoTSandClouds != (SoTSandClouds = sandClouds))                                      timer.Run.Metadata.SetCustomVariable("sandClouds", SoTSandClouds + " / 48");
            break;
        case WW:
            bool collectiblesUpdated = false;
            if (WWStoryValue        != (WWStoryValue        = current.storyValue))                  timer.Run.Metadata.SetCustomVariable("storyGate",     WWStoryValue.ToString());
            if (WWVirtualChestBits  != (WWVirtualChestBits  = current.chestBits)  && WWChestBits  != (WWChestBits  = WWChestMask  & WWVirtualChestBits)  && (collectiblesUpdated = true))
                                                                                                    timer.Run.Metadata.SetCustomVariable("chests",        WWCountBits(WWChestBits)        + " / " + WWMaxChests);
            if (WWVirtualWeaponBits != (WWVirtualWeaponBits = current.weaponBits) && WWWeaponBits != (WWWeaponBits = WWWeaponMask & WWVirtualWeaponBits) && (collectiblesUpdated = true))
            {
                if (WWMainWeaponBits   != (WWMainWeaponBits   = WWMainWeaponMask   & WWWeaponBits)) timer.Run.Metadata.SetCustomVariable("mainWeapons",   WWCountBits(WWMainWeaponBits)   + " / " + WWMaxMainWeapons);
                if (WWSwordBits        != (WWSwordBits        = WWSwordMask        & WWWeaponBits)) timer.Run.Metadata.SetCustomVariable("swords",        WWCountBits(WWSwordBits)        + " / " + WWMaxSwords);
                if (WWAxeBits          != (WWAxeBits          = WWAxeMask          & WWWeaponBits)) timer.Run.Metadata.SetCustomVariable("axes",          WWCountBits(WWAxeBits)          + " / " + WWMaxAxes);
                if (WWMaceBits         != (WWMaceBits         = WWMaceMask         & WWWeaponBits)) timer.Run.Metadata.SetCustomVariable("maces",         WWCountBits(WWMaceBits)         + " / " + WWMaxMaces);
                if (WWDaggerBits       != (WWDaggerBits       = WWDaggerMask       & WWWeaponBits)) timer.Run.Metadata.SetCustomVariable("daggers",       WWCountBits(WWDaggerBits)       + " / " + WWMaxDaggers);
                if (WWSecretWeaponBits != (WWSecretWeaponBits = WWSecretWeaponMask & WWWeaponBits)) timer.Run.Metadata.SetCustomVariable("secretWeapons", WWCountBits(WWSecretWeaponBits) + " / " + WWMaxSecretWeapons);
            }
            if (collectiblesUpdated)
            {
                int chests = WWCountBits(WWChestBits);
                int weapons = WWCountBits(WWWeaponBits);
                int total = chests + weapons;
                string collectiblesText = total + "/" + WWMaxCollectibles + "\u2009-\u2009C:" + chests + ",\u2009W:" + weapons;
                                                                                                    timer.Run.Metadata.SetCustomVariable("collectibles",  collectiblesText);
            }
            break;
        }

        TriggeredEvent = null;
        int xyzHashCode = GetXyzHashCodeCurrent();
        int mapHashCode = 0;
        switch (CurrentGame)
        {
        case WW: mapHashCode = current.map; break;
        }
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

    // ================================================== split ==================================================

    Func<bool> Split = () =>
    {
        CheckEvent(MiscEvent);
        return CheckEvent(SplitEvent);
    };
    vars.Split = Split;

    // ================================================== isLoading ==================================================

    Func<bool> IsLoading = () =>
    {
        switch (CurrentRun)
        {
        case NoGame: return true;
        case SoT:    return false;
        case WW:     return true;
        case T2T:    return false;
        default:     return false;
        }
    };
    vars.IsLoading = IsLoading;

    // ================================================== gameTime ==================================================

    Func<TimeSpan?> GameTime = () =>
    {
        if (CurrentRun != CurrentGame)
            return null;
        switch (CurrentRun)
        {
        case NoGame:
            return null;
        case SoT:
            return null;
        case WW:
            ulong tickDelta = current.physicsTicks - old.physicsTicks;
            if (tickDelta < 0) tickDelta = current.scaledTicks - old.scaledTicks;
            if (tickDelta > 0) WWIgtValue += tickDelta;
            return GameTimeAtCurrentRunStart + TimeSpan.FromSeconds(WWIgtValue * current.tickMul);
        case T2T:
            return null;
        default:
            return null;
        }
    };
    vars.GameTime = GameTime;

    // ====================================================================================================

    print("multipop.asl " + DateTime.Now.ToString());
}

init
{
    vars.Init(old, current, settings, game);
}

exit
{
    vars.Exit();
}

onStart
{
    vars.OnStart();
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

split
{
    return vars.Split();
}

isLoading
{
    return vars.IsLoading();
}

gameTime
{
    return vars.GameTime();
}