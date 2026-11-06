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

    // ================================================== state objects ==================================================

    dynamic Old = null;
    dynamic Current = null;

    Action<dynamic> SetOld = _old => Old = _old;
    Action<dynamic> SetCurrent = _current => Current = _current;

    vars.SetOld = SetOld;
    vars.SetCurrent = SetCurrent;

    // ================================================== coordinate checks ==================================================

    Func<float, float, float?, bool> InBounds = (min, max, pos) => pos >= min && pos <= max;
    Func<float, float, bool> InXBoundsOld = (min, max) => InBounds(min, max, Old.xPos);
    Func<float, float, bool> InYBoundsOld = (min, max) => InBounds(min, max, Old.yPos);
    Func<float, float, bool> InZBoundsOld = (min, max) => InBounds(min, max, Old.zPos);
    Func<float, float, bool> InXBoundsCurrent = (min, max) => InBounds(min, max, Current.xPos);
    Func<float, float, bool> InYBoundsCurrent = (min, max) => InBounds(min, max, Current.yPos);
    Func<float, float, bool> InZBoundsCurrent = (min, max) => InBounds(min, max, Current.zPos);

    Func<float, float, float, float, float, float, float?, float?, float?, bool> InPosWithBounds = (xMin, xMax, yMin, yMax, zMin, zMax, xPos, yPos, zPos)
    =>
        xPos >= xMin && xPos <= xMax &&
        yPos >= yMin && yPos <= yMax &&
        zPos >= zMin && zPos <= zMax;
    Func<float, float, float, float, float, float, bool> InPosWithBoundsOld = (xMin, xMax, yMin, yMax, zMin, zMax)
        => InPosWithBounds(xMin, xMax, yMin, yMax, zMin, zMax, Old.xPos, Old.yPos, Old.zPos);
    Func<float, float, float, float, float, float, bool> InPosWithBoundsCurrent = (xMin, xMax, yMin, yMax, zMin, zMax)
        => InPosWithBounds(xMin, xMax, yMin, yMax, zMin, zMax, Current.xPos, Current.yPos, Current.zPos);

    Func<float, float, float?, bool> InRange = (targ, range, pos) => pos >= targ - range && pos <= targ + range;
    Func<float, float, bool> InXRangeOld = (targ, range) => InRange(targ, range, Old.xPos);
    Func<float, float, bool> InYRangeOld = (targ, range) => InRange(targ, range, Old.yPos);
    Func<float, float, bool> InZRangeOld = (targ, range) => InRange(targ, range, Old.zPos);
    Func<float, float, bool> InXRangeCurrent = (targ, range) => InRange(targ, range, Current.xPos);
    Func<float, float, bool> InYRangeCurrent = (targ, range) => InRange(targ, range, Current.yPos);
    Func<float, float, bool> InZRangeCurrent = (targ, range) => InRange(targ, range, Current.zPos);

    Func<float, float, float, float, float?, float?, float?, bool> InPosWithRange = (xTarg, yTarg, zTarg, range, xPos, yPos, zPos)
    =>
        xPos >= xTarg - range && xPos <= xTarg + range &&
        yPos >= xTarg - range && yPos <= yTarg + range &&
        zPos >= zTarg - range && zPos <= zTarg + range;
    Func<float, float, float, float, bool> InPosWithRangeOld = (xTarg, yTarg, zTarg, range)
        => InPosWithRange(xTarg, yTarg, zTarg, range, Old.xPos, Old.yPos, Old.zPos);
    Func<float, float, float, float, bool> InPosWithRangeCurrent = (xTarg, yTarg, zTarg, range)
        => InPosWithRange(xTarg, yTarg, zTarg, range, Current.xPos, Current.yPos, Current.zPos);

    Func<float, float, float, float?, float?, float?, bool> InPosExact = (xTarg, yTarg, zTarg, xPos, yPos, zPos)
    =>
        xTarg == xPos &&
        yTarg == yPos &&
        zTarg == zPos;
    Func<float, float, float, bool> InPosExactOld = (xTarg, yTarg, zTarg)
    =>
        xTarg == Old.xPos &&
        yTarg == Old.yPos &&
        zTarg == Old.zPos;
    Func<float, float, float, bool> InPosExactCurrent = (xTarg, yTarg, zTarg)
    =>
        xTarg == Current.xPos &&
        yTarg == Current.yPos &&
        zTarg == Current.zPos;

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
        // return CombineHashCodes(GetHashCode(Current.xPos), GetHashCode(Current.yPos), GetHashCode(Current.zPos));
        // but since our methods are lambdas, method calls do not get inlined
        // so, since this is a hot path (called every cycle), we manually inline it for the sake of performance
        uint hash = 0;
        hash = hash * FnvPrime + (Current.xPos == null ? int.MaxValue : (uint)(int)Math.Floor(Current.xPos / BucketSize));
        hash = hash * FnvPrime + (Current.yPos == null ? int.MaxValue : (uint)(int)Math.Floor(Current.yPos / BucketSize));
        hash = hash * FnvPrime + (Current.zPos == null ? int.MaxValue : (uint)(int)Math.Floor(Current.zPos / BucketSize));
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
    var events = new Dictionary<string, Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>>>();
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

    var CompletedEvents = new HashSet<string>();

    // Event
    Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>> TriggeredEvent = null;

    Func<int, bool> CheckEvent = eventType =>
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
        print(GetEventString(eventType) + " " + TriggeredEvent.Item2);
        return true;
    };

    // ================================================== game-specific functions and helper variables ==================================================

    const float SeedRange = 5f;
    Func<float, float, float, bool> SeedGet = (xTarg, yTarg, zTarg)
    =>
        InPosWithRangeCurrent(xTarg, yTarg, zTarg, SeedRange) &&
        (Current.seedCount != null && Current.seedCount == Old.seedCount + 1);
    
    const float BossRange = 30f;
    Func<float, float, float, bool> BossKill = (xTarg, yTarg, zTarg)
    =>
        InPosWithRangeCurrent(xTarg, yTarg, zTarg, BossRange) &&
        (Old.combat == 2 && Current.combat == 0);
    
    const float DadRange = 30f;
    Func<float, float, float, bool> DadKill = (xTarg, yTarg, zTarg)
    =>
        InPosWithRangeCurrent(xTarg, yTarg, zTarg, DadRange) &&
        (Old.enemyHP > 0 && Current.enemyHP == 0);
    
    // ===================================================================================================================
    // ================================================== CONFIGURATION ==================================================
    // ===================================================================================================================

    // each setting has a list of events that it's tied to, and each event has a list of settings that it's tied to
    // however, this does not need to be explicitly specified both ways
    // so we may either specify which events are tied to each setting, and let the script auto-fill the settings list for each event,
    //      or we may specify which settings are tied to each event,
    //      or we can do any combination of both, and the script will auto-fill the settings list for each event, removing any duplicates
    // after startup, the events list for each setting is cleared, so only the settings list for each event remains

    // if an event has no setting tied to it, then it succeeds upon meeting its condition
    // if an event has one or more settings tied to it, then it succeeds upon meeting its condition if and only if at least one of its settings permits it

    // if we try to tie to a setting an event which is not defined, an exception will be thrown and startup will fail
    // likewise if we try to tie an event to a setting which is not defined, an exception will be thrown
    // But, WARNING: if we forget to tie an event with a setting,
    //      the script will work normally, the setting will do nothing, and the event will always succeed regardless of the setting

    // ================================================== settings ==================================================

    // parent settings must be specified before their respective children settings
    // settings with the same parent (or lack of parent) will be displayed in the same order as specified here

    // ================================================== events ==================================================

    Action action;
    Action<float, float, float, float> actionRange;
    Action<float, float, float, float, float, float> actionBounds;

    // ====================================================================================================================
    // ================================================== STARTUP SCRIPT ==================================================
    // ====================================================================================================================

    // ================================================== apply configured settings ==================================================

    // add each setting that references an event to that event's settings list
    // and clear each setting's events list
    //      so that in the end only the events have references to their respective settings and not the other way around
    // if a setting points to an event that doesn't exist, an exception will be thrown
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
    // if an event points to a setting that doesn't exist, an exception will be thrown
    var settingSlugsCopy = new HashSet<string>();
    foreach (var @event in events.Values)
    {
        foreach (string settingSlug in @event.Item3)
        {
            if (!mySettings.ContainsKey(settingSlug))
                throw new Exception("Internal exception (ASL): cannot write setting " + settingSlug + " to event " + @event.Item2 + " because this setting doesn't exist");
            settingSlugsCopy.Add(settingSlug);
        }
        @event.Item3.Clear();
        @event.Item3.AddRange(settingSlugsCopy);
        settingSlugsCopy.Clear();
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

    // allocate a large enough capacity at startup so that the CompletedEvents hashset does not need to be reallocated as it grows during runtime
    CompletedEvents = new HashSet<string>(events.Count);

    // ================================================== outputs ==================================================

    // print detected settings and events
    var infoBuilder = new StringBuilder();

    infoBuilder.Append("\r\nSettings detected:\r\n");
    infoBuilder.Append("{Setting} : {Parent}\r\n");
    foreach (var setting in mySettings.Values)
        infoBuilder.Append("\t" + setting.Item2 + " : " + (setting.Item6 ?? "{null}" + "\r\n"));
    infoBuilder.Append("Total settings: " + mySettings.Count.ToString() + "\r\n\r\n");

    infoBuilder.Append("Events detected:\r\n");
    infoBuilder.Append("{EventType} {Event} {HasXyzBounds} => {[..Settings]}\r\n");
    foreach (var @event in events.Values)
        infoBuilder.Append("\t" + GetEventString(@event.Item1) + " " + @event.Item2 + " " + (@event.Item4 != null).ToString() + " => [" + string.Join(", ", @event.Item3) + "]\r\n");
    infoBuilder.Append("Total events: " + events.Count.ToString() + "\r\n");

    print(infoBuilder.ToString());

    // switch to real time prompt
    if (timer.CurrentTimingMethod != TimingMethod.RealTime) {
        DialogResult mbox = MessageBox.Show(timer.Form,
        "This game uses only real time as the timing method.\nWould you like to switch to Real Time?",
        "LiveSplit | Prince of Persia (2008)",
        MessageBoxButtons.YesNo);

        if (mbox == DialogResult.Yes) {
            timer.CurrentTimingMethod = TimingMethod.RealTime;
        }
    }

    // ================================================== cleanup ==================================================

    // de-reference unneeded collections to allow for garbage collection
    settingSlugsCopy = null;
    mySettings = null;
    events = null;
    infoBuilder = null;

    // =====================================================================================================================
    // ================================================== RUNTIME ACTIONS ==================================================
    // =====================================================================================================================

    // ================================================== onStart ==================================================
    Action OnStart = () => CompletedEvents.Clear();
    vars.OnStart = OnStart;

    // ================================================== update ==================================================
    var EmptyEventList = new List<Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>>>();
    Func<bool> Update = () =>
    {
        TriggeredEvent = null;
        int xyzHashCode = GetHashCodeCurrent();
        List<Tuple<int, string, List<string>, ValueTuple<float, float, float, float, float, float>?, Func<bool>>> localEvents;
        XyzEventHashMap.TryGetValue(xyzHashCode, out localEvents);
        
        // print local events:
        /*var builder = new StringBuilder();
        foreach (var @event in localEvents ?? EmptyEventList) builder.Append(@event.Item2 + "\r\n");
        print(builder.ToString());*/

        // Concat function means we iterate through the lists one after the other; it does not create a concatenated list
        foreach (var @event in (localEvents ?? EmptyEventList).Concat(OtherEvents))
        {
            if (@event.Item5())
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
    // but if we explicitly write the new "old" and "current" objects into the "Old" and "Current" variables defined in the startup block as they are updated,
    //      then we can safely define functions in both the startup and the init blocks, and they will safely read the updated "old" and "current" objects,
    //      as they are at the time of the function call
    // this is because the "old" and "current" objects are placed behind the "Old" and "Current" variables
    //      which get captured by the closure created when a function lambda is defined,
    //      so the lambda will always look for the object behind the variable at the time of the function call
    // the "current" and "old" objects are of type System.ExpandoObject which is a reference type, so here we are merely passing a reference to the object,
    //      not copying the actual contents of the object
    vars.SetOld(old);
    vars.SetCurrent(current);
}

onStart
{
    vars.OnStart();
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