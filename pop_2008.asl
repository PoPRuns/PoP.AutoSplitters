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

startup
{
    // FUNCTION DEFINITIONS

    // Coord Utils

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
    Func<float, float, float> InPosExactOld = (xTarg, yTarg, zTarg)
    =>
        xTarg == vars.old.xPos &&
        yTarg == vars.old.yPos &&
        zTarg == vars.old.zPos;
    Func<float, float, float> InPosExactCurrent = (xTarg, yTarg, zTarg)
    =>
        xTarg == vars.current.xPos &&
        yTarg == vars.current.yPos &&
        zTarg == vars.current.zPos;

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