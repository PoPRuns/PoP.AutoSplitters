state("PrinceOfPersia_Launcher", "Digital")
{
    int seedCount       : 0x00B37F64, 0xDC;
    float xPos          : 0x00B30D08, 0x40;
    float yPos          : 0x00B30D08, 0x44;
    float zPos          : 0x00B30D08, 0x48;
    int combat          : 0x00B37F6C, 0xE0, 0x1C, 0xC, 0x7CC;
    int enemyHP         : 0x00B38130, 0x4E4, 0x444, 0x60, 0x8, 0x250;
}

state("Prince of Persia", "DRM Free")
{
    int seedCount       : 0x00B37F64, 0xDC;
    float xPos          : 0x00B30D08, 0x40;
    float yPos          : 0x00B30D08, 0x44;
    float zPos          : 0x00B30D08, 0x48;
    int combat          : 0x00B37F6C, 0xE0, 0x1C, 0xC, 0x7CC;
    int enemyHP         : 0x00B38130, 0x4E4, 0x444, 0x60, 0x8, 0x250;
}

state("Prince of Persia", "Unknown") {}

// Data structures:
// Setting: bool Default, string Slug, List<string> EventSlugs, string Description, string? ToolTip, string? ParentSlug
// Event: int EventType, string Slug, List<string> SettingSlugs, (float, float, float, float, float, float)? XyzBounds, Func<bool> Condition

// Setting.EventSlugs is cleared during startup
// Event.SettingSlugs is filled during startup, with duplicates removed

// each setting has a list of events that it's tied to, and each event has a list of settings that it's tied to
// however, this does not need to be explicitly specified both ways
// so we may either specify which events are tied to each setting, and let the script auto-fill the settings list for each event,
//      or we may specify which settings are tied to each event,
//      or we can do any combination of both, and the script will auto-fill the settings list for each event, removing any duplicates
// after startup, the events list for each setting is cleared, so only the settings list for each event remains

// if an event has no setting tied to it, then it succeeds upon meeting its condition
// if an event has one or more settings tied to it, then it succeeds upon meeting its condition if and only if at least one of its settings permits it

// for Event.SettingSlugs we prefer a List over a HashSet because iterating over a list is faster
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
startup
{
    // ==========================================================================================================================
    // ================================================== FUNCTION DEFINITIONS ==================================================
    // ==========================================================================================================================

    // ================================================== coordinate checks ==================================================

    Func<float, float, float?, bool> InBounds = (min, max, pos) => pos >= min && pos <= max;
    Func<float, float, bool> InXBoundsOld = (min, max) => InBounds(min, max, vars.old.xPos);
    Func<float, float, bool> InYBoundsOld = (min, max) => InBounds(min, max, vars.old.yPos);
    Func<float, float, bool> InZBoundsOld = (min, max) => InBounds(min, max, vars.old.zPos);
    Func<float, float, bool> InXBoundsCurrent = (min, max) => InBounds(min, max, vars.current.xPos);
    Func<float, float, bool> InYBoundsCurrent = (min, max) => InBounds(min, max, vars.current.yPos);
    Func<float, float, bool> InZBoundsCurrent = (min, max) => InBounds(min, max, vars.current.zPos);

    Func<float, float, float, float, float, float, float?, float?, float?, bool> InPosWithBounds = (xMin, xMax, yMin, yMax, zMin, zMax, xPos, yPos, zPos)
    =>
        xPos >= xMin && xPos <= xMax &&
        yPos >= yMin && yPos <= yMax &&
        zPos >= zMin && zPos <= zMax;
    Func<float, float, float, float, float, float, bool> InPosWithBoundsOld = (xMin, xMax, yMin, yMax, zMin, zMax)
        => InPosWithBounds(xMin, xMax, yMin, yMax, zMin, zMax, vars.old.xPos, vars.old.yPos, vars.old.zPos);
    Func<float, float, float, float, float, float, bool> InPosWithBoundsCurrent = (xMin, xMax, yMin, yMax, zMin, zMax)
        => InPosWithBounds(xMin, xMax, yMin, yMax, zMin, zMax, vars.current.xPos, vars.current.yPos, vars.current.zPos);

    Func<float, float, float?, bool> InRange = (targ, range, pos) => pos >= targ - range && pos <= targ + range;
    Func<float, float, bool> InXRangeOld = (targ, range) => InRange(targ, range, vars.old.xPos);
    Func<float, float, bool> InYRangeOld = (targ, range) => InRange(targ, range, vars.old.yPos);
    Func<float, float, bool> InZRangeOld = (targ, range) => InRange(targ, range, vars.old.zPos);
    Func<float, float, bool> InXRangeCurrent = (targ, range) => InRange(targ, range, vars.current.xPos);
    Func<float, float, bool> InYRangeCurrent = (targ, range) => InRange(targ, range, vars.current.yPos);
    Func<float, float, bool> InZRangeCurrent = (targ, range) => InRange(targ, range, vars.current.zPos);

    Func<float, float, float, float, float?, float?, float?, bool> InPosWithRange = (xTarg, yTarg, zTarg, range, xPos, yPos, zPos)
    =>
        xPos >= xTarg - range && xPos <= xTarg + range &&
        yPos >= xTarg - range && yPos <= yTarg + range &&
        zPos >= zTarg - range && zPos <= zTarg + range;
    Func<float, float, float, float, bool> InPosWithRangeOld = (xTarg, yTarg, zTarg, range)
        => InPosWithRange(xTarg, yTarg, zTarg, range, vars.old.xPos, vars.old.yPos, vars.old.zPos);
    Func<float, float, float, float, bool> InPosWithRangeCurrent = (xTarg, yTarg, zTarg, range)
        => InPosWithRange(xTarg, yTarg, zTarg, range, vars.current.xPos, vars.current.yPos, vars.current.zPos);

    Func<float, float, float, float?, float?, float?, bool> InPosExact = (xTarg, yTarg, zTarg, xPos, yPos, zPos)
    =>
        xTarg == xPos &&
        yTarg == yPos &&
        zTarg == zPos;
    Func<float, float, float, bool> InPosExactOld = (xTarg, yTarg, zTarg)
    =>
        xTarg == vars.old.xPos &&
        yTarg == vars.old.yPos &&
        zTarg == vars.old.zPos;
    Func<float, float, float, bool> InPosExactCurrent = (xTarg, yTarg, zTarg)
    =>
        xTarg == vars.current.xPos &&
        yTarg == vars.current.yPos &&
        zTarg == vars.current.zPos;

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
    Func<float?, int> GetHashCode = coord =>
    {
        if (coord == null)
            return int.MaxValue;
        int bucket = (int)Math.Floor((float)coord / BucketSize);
        return bucket;
    };

    // fast hashing algorithm with wide dispersion where the same inputs ordered differently yield different results
    const uint FnvPrime = 0x01000193;   // https://en.wikipedia.org/wiki/Fowler%E2%80%93Noll%E2%80%93Vo_hash_function#FNV_prime
    Func<int, int, int, int> CombineHashCodes = (xHash, yHash, zHash) =>
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
    Func<int> GetHashCodeCurrent = () =>
    {
        // this whole function could be reduced to just the following line:
        // return CombineHashCodes(GetHashCode(vars.current.xPos), GetHashCode(vars.current.yPos), GetHashCode(vars.current.zPos));
        // but since our methods are lambdas, method calls do not get inlined
        // so, since this is a hot path (called every cycle), we manually inline it for the sake of performance
        uint hash = 0;
        hash = hash * FnvPrime + (vars.current.xPos == null ? int.MaxValue : (uint)(int)Math.Floor(vars.current.xPos / BucketSize));
        hash = hash * FnvPrime + (vars.current.yPos == null ? int.MaxValue : (uint)(int)Math.Floor(vars.current.yPos / BucketSize));
        hash = hash * FnvPrime + (vars.current.zPos == null ? int.MaxValue : (uint)(int)Math.Floor(vars.current.zPos / BucketSize));
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
    Func<float, float, float, float, float, float, int[]> GetHashCodesForBounds = (xMin, xMax, yMin, yMax, zMin, zMax) =>
    {
        int minXBucket = (int)Math.Floor(xMin / BucketSize);
        int maxXBucket = (int)Math.Floor(xMax / BucketSize);
        int xBucketCount = maxXBucket - minXBucket + 1;
        int minYBucket = (int)Math.Floor(yMin / BucketSize);
        int maxYBucket = (int)Math.Floor(yMax / BucketSize);
        int yBucketCount = maxYBucket - minYBucket + 1;
        int minZBucket = (int)Math.Floor(zMin / BucketSize);
        int maxZBucket = (int)Math.Floor(zMax / BucketSize);
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
                    int hashCode = CombineHashCodes(xHashCode, yHashCode, zHashCode);
                    hashCodes[index] = hashCode;
                    index++;
                }
            }
        }
        return hashCodes;
    };

    Func<float, float, float, float, ValueTuple<float, float, float, float, float, float>> GetBounds = (x, y, z, range)
        => ValueTuple.Create(x - range, x + range, y - range, y + range, z - range, z + range);

    // ================================================== startup functions and helper variables ==================================================

    // we use the name mySettings to prevent conflict with the LiveSplit variable "settings"
    // Key: SettingSlug; Value: Setting
    var mySettings = new Dictionary<string, Tuple<bool, string, List<string>, string, string, string>>();
    Action<bool, string, List<string>, string, string, string> AddSetting = (@default, slug, eventSlugs, description, toolTip, parentSlug)
        => mySettings.Add(slug, Tuple.Create(@default, slug, eventSlugs, description, toolTip, parentSlug));
    
    // Key: EventSlug; Value: Event
    const int StartEvent = 0;
    const int ResetEvent = 1;
    const int SplitEvent = 2;
    const int MiscEvent = 3;
    Action action;
    Action<float, float, float, float> actionRange;
    Action<float, float, float, float, float, float> actionBounds;
    var events = new Dictionary<string, Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>, Func<bool>>>();
    Action<int, string, List<string>, ValueTuple<float, float, float, float, float, float>, Func<bool>> AddEvent = (eventType, slug, settingSlugs, xyzBounds, condition)
        => events.Add(slug, Tuple.Create(eventType, slug, settingSlugs, xyzBounds, condition));

    // ================================================== runtime functions and helper variables ==================================================

    // Key: Hash; Value: EventList
    var XyzEventHashMap = new Dictionary<int, List<Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>, Func<bool>>>>();

    // List<Event>
    var OtherEvents = new List<Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>, Func<bool>>>();

    var CompletedEvents = new HashSet<string>();

    // Event
    Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>, Func<bool>> TriggeredEvent = null;

    Func<int, bool> CheckEvent = (eventType) =>
    {
        if (TriggeredEvent == null)
            return false;
        if (TriggeredEvent.Item1 != eventType)
            return false;
        if (!CompletedEvents.Add(TriggeredEvent.Item2))
            return false;
        bool eventSetting = false;
        if (TriggeredEvent.Item3.Count == 0)
            eventSetting = true;
        else foreach (string settingSlug in TriggeredEvent.Item3)
            if (settings[settingSlug])
                eventSetting = true;
        if (!eventSetting)
            return false;
        print(eventType.ToString() + " " + TriggeredEvent.Item2);
        return true;
    };

    // ================================================== game-specific functions and helper variables ==================================================

    const float SeedRange = 5f;
    Func<float, float, float, bool> EventSeedGet = (xTarg, yTarg, zTarg)
    =>
        InPosWithRangeCurrent(xTarg, yTarg, zTarg, SeedRange) &&
        (vars.current.seedCount != null && vars.current.seedCount == vars.old.seedCount + 1);
    
    const float BossRange = 30f;
    Func<float, float, float, bool> EventBossKill = (xTarg, yTarg, zTarg)
    =>
        InPosWithRangeCurrent(xTarg, yTarg, zTarg, BossRange) &&
        (vars.old.combat == 2 && vars.current.combat == 0);
    
    const float DadRange = 30f;
    Func<float, float, float, bool> EventDadKill = (xTarg, yTarg, zTarg)
    =>
        InPosWithRangeCurrent(xTarg, yTarg, zTarg, DadRange) &&
        (vars.old.enemyHP > 0 && vars.current.enemyHP == 0);
    
    // ===================================================================================================================
    // ================================================== CONFIGURATION ==================================================
    // ===================================================================================================================

    // ================================================== settings ==================================================

    // ================================================== events ==================================================

    // ====================================================================================================================
    // ================================================== STARTUP SCRIPT ==================================================
    // ====================================================================================================================

    // ================================================== apply settings ==================================================

    // add each setting that references an event to that event's settings list
    // and clear each setting's events list
    //      so that in the end only the events have references to their respective settings and not the other way around
    foreach (var setting in mySettings.Values)
    {
        foreach (string eventSlug in setting.Item3)
        {
            var @event = events[eventSlug];
            @event.Item3.Add(setting.Item2);
        }
        setting.Item3.Clear();
        setting.Item3.TrimExcess();
    }

    // remove duplicate settings from each event's settings list
    var settingSlugsCopy = new HashSet<string>();
    foreach (var @event in events.Values)
    {
        foreach (string settingSlug in @event.Item3)
            settingSlugsCopy.Add(settingSlug);
        @event.Item3.Clear();
        @event.Item3.AddRange(settingSlugsCopy);
        settingSlugsCopy.Clear();
    }

    // add each setting to the LiveSplit settings variable,
    // reiterating through the mySettings map to ensure that parents get added before children, which LiveSplit requires
    // we stop iterating once all settings are added, or once an iteration yields no change in the addedSettings hashset
    var addedSettings = new HashSet<string>();
    int prevCount;
    do
    {
        prevCount = addedSettings.Count;
        foreach (var setting in mySettings.Values)
        {
            if (addedSettings.Contains(setting.Item2))
                continue;
            if (setting.Item6 == null || addedSettings.Contains(setting.Item6))
            {
                addedSettings.Add(setting.Item2);
                settings.Add(setting.Item2, setting.Item1, setting.Item4, setting.Item6);
                settings.SetToolTip(setting.Item2, setting.Item5);
            }
        }
    } while (addedSettings.Count < mySettings.Count && prevCount < addedSettings.Count);
    if (addedSettings.Count < mySettings.Count)
    {
        print("Error (ASL): the following settings could not be added because they do not have a valid parent:");
        var builder = new StringBuilder();
        foreach (string settingSlug in mySettings.Keys.Except(addedSettings))
            builder.Append("\t" + settingSlug + "\r\n");
        print(builder.ToString());
        throw new Exception("Internal exception (ASL): not all settings have a valid parent");
    }

    // de-reference unneeded collections to allow for garbage collection
    settingSlugsCopy = null;
    addedSettings = null;
    mySettings = null;

    // ================================================== fill XyzEventHashMap and OtherEvents ==================================================

    // ================================================== print info ==================================================

    if (timer.CurrentTimingMethod != TimingMethod.RealTime) {
        DialogResult mbox = MessageBox.Show(timer.Form,
        "This game uses only real time as the timing method.\nWould you like to switch to Real Time?",
        "LiveSplit | Prince of Persia (2008)",
        MessageBoxButtons.YesNo);

        if (mbox == DialogResult.Yes) {
            timer.CurrentTimingMethod = TimingMethod.RealTime;
        }
    }

    print("pop_2008.asl " + DateTime.Now.ToString());
}

init
{
    refreshRate = 120;
    if (game.ProcessName == "PrinceOfPersia_Launcher") {
        version = "Digital";
    } else {
        string MD5Hash;
        using (var md5 = System.Security.Cryptography.MD5.Create())
            using (var s = File.Open(modules.First().FileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
                MD5Hash = md5.ComputeHash(s).Select(x => x.ToString("X2")).Aggregate((a, b) => a + b);

        switch (MD5Hash) {
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
    // but if we explicitly write the new "old" and "current" objects into vars.old and vars.current as they are updated,
    //      then we can safely define functions in both the startup and the init blocks, and they will safely read the updated "old" and "current" objects,
    //      as they are at the time of the function call
    // this is because the "old" and "current" objects are placed behind the "vars" variable,
    //      and the "vars" variable always points to the same "vars" object for the lifetime of the script
    // the "current" and "old" objects are of type System.ExpandoObject which is a reference type, so here we are merely passing a reference to the object,
    //      not copying the actual contents of the object
    vars.old = old;
    vars.current = current;
}

onStart { }

// note that the update block - along with every other block except startup and shutdown - does not run when LiveSplit is not hooked to any game process
update
{
    // we avoid explicitly assigning vars.current = current in the update block since it is not needed,
    // and just in case this allows the compiler to perform some optimisations when accessing the vars.current variable
    vars.old = old;
}

start { }
reset { }
split { }