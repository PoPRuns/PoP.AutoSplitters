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

// fetching the old value from this block simply yields the current value due to a bug with ASL
// this is why any time we use the old value in this block, we pass it on directly from another block
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
}

onStart { }
update { }
start { }
reset { }
split { }
