state("POP")
{
    // Prince's position
    float xPos          : 0x699474, 0xC, 0x30; 
    float yPos          : 0x699474, 0xC, 0x34;
    float zPos          : 0x699474, 0xC, 0x38;

    // Some memory value that reliably changes when 'New Game' is pressed.
    short startValue    : 0x6BC980;

    // The Vizier's health where 0 is unharmed and 4 is dead.
    short vizierHealth  : 0x40E518, 0x6C, 0x18, 0x4, 0x44, 0x0;
}

state("POP2")
{
    // This variable is 0 during gameplay, 1 in cutscenes, 2 when a cutscene ends
    int cutscene        : 0x9665D0, 0x18, 0x4, 0x48, 0xE0;

    // Story counter/gate/value
    int storyValue      : 0x523578;

    // The address used for most bosses' health
    int bossHealth      : 0x90C418, 0x18, 0x4, 0x48, 0x198;

    // The Prince's coords
    float xPos          : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x30;
    float yPos          : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x34;
    float zPos          : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x38;

    // Currently loaded area id (changes with every load trigger)
    int map             : 0x523594;
}

state("POP3")
{
    // The Prince's coords
    float xPos  : 0x00A2A498, 0xC, 0x30;
    float yPos  : 0x00A2A498, 0xC, 0x34;
    float zPos  : 0x00A2A498, 0xC, 0x38;

    float xCam  : 0x928548;
    float yCam  : 0x928554;

    int princeAction   : 0x005EBD78, 0x30, 0x18, 0x4, 0x48, 0x7F0;
}

startup
{
    // Method to add a Scriptable Auto Splitter component to the livesplit layout for a given game
    vars.setASLComponent = (Action<int>)((gameId) => {
        vars.removeASLComponent(gameId);
        string scriptPath = "Components\\" + vars.gameScriptMapping[gameId].Item2;
        var aslSettings = timer.Layout.Components.Where(x => x.GetType().Name == "ASLComponent").Select(x => x.GetType().GetField("_settings", BindingFlags.Instance | BindingFlags.NonPublic).GetValue(x));
        var aslSetting = aslSettings.FirstOrDefault(x => (x.GetType().GetProperty("ScriptPath").GetValue(x, null) as string) == scriptPath);

        if (aslSetting == null) {
            var aslComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.ScriptableAutoSplit.dll");
            var aslComponent = Activator.CreateInstance(aslComponentAssembly.GetType("LiveSplit.UI.Components.ASLComponent"), timer);
            timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.ScriptableAutoSplit.dll", aslComponent as LiveSplit.UI.Components.LogicComponent));
            aslSetting = aslComponent.GetType().GetField("_settings", BindingFlags.Instance | BindingFlags.NonPublic).GetValue(aslComponent);
            aslSetting.GetType().GetProperty("ScriptPath").SetValue(aslSetting, scriptPath);
            aslSetting.GetType().GetField("_basic_settings_state", BindingFlags.Instance | BindingFlags.NonPublic)
                .SetValue(aslSetting, new Dictionary<string, bool> {
                    { "start", false },
                    { "reset", false },
                    { "split", true },
                });
            aslSetting.GetType().GetField("_custom_settings_state", BindingFlags.Instance | BindingFlags.NonPublic)
                .SetValue(aslSetting, vars.getGameSettings(gameId));
        }
    });

    // Method to remove the Scriptable Auto Splitter component of a given game from the livesplit layout
    vars.removeASLComponent = (Action<int>)((gameId) => {
        string scriptPath = "Components\\" + vars.gameScriptMapping[gameId].Item2;
        int indexToRemove = -1;
        do {
            indexToRemove = -1;
            foreach (dynamic component in timer.Layout.Components) {
                if (component.GetType().Name == "ASLComponent" && vars.getScriptPath(component) == scriptPath) {
                    indexToRemove = timer.Layout.Components.ToList().IndexOf(component);
                    component.Dispose();
                }
            }
            if (indexToRemove != -1) {
                timer.Layout.LayoutComponents.RemoveAt(indexToRemove);
            }
        } while (indexToRemove != -1);
    });

    // Key - Game ID, Value - Tuple of (Game Name, Script File, Regex Pattern to match settings).
    vars.gameScriptMapping = new Dictionary<int, Tuple<string, string, string>> {
        { 4, Tuple.Create("Sands of Time", "pop_sot.asl", @"""(?<key>\w+)"",\s*Tuple\.Create\((?<isEnabled>true|false),\s*""(?<displayName>[^""]+)"",\s*""(?<description>[^""]+)"",") },
        { 5, Tuple.Create("Warrior Within", "pop_ww.asl", @"""(?<key>\w+)"",\s*Tuple\.Create\((?<isEnabled>true|false),\s*""(?<displayName>[^""]+)"",\s*""(?<parentSetting>[^""]+)"",\s*""(?<description>[^""]+)"",") },
        { 6, Tuple.Create("The Two Thrones", "pop_t2t.asl", @"""(?<key>\w+)"",\s*Tuple\.Create\((?<isEnabled>true|false),\s*""(?<displayName>[^""]+)"",\s*""(?<description>[^""]+)"",") },
    };

    vars.processNameMap = new Dictionary<string, int> {
        { "pop", 4 },
        { "pop2", 5 },
        { "pop3", 6 }
    };

    // WW has a more elaborate settings structure
    vars.WWSplitTypes = new Dictionary<string, string> {
        { "AnyGlitched", "Any% (Standard) and Any% (Zipless) splits" },
        { "AnyNMG", "Any% (No Major Glitches) splits" },
        { "TEStandard", "True Ending (Standard) splits" },
        { "TEZipless", "True Ending (Zipless) splits" },
        { "TENMG", "True Ending (No Major Glitches) splits" },
    };

    vars.settingsMapping = new Dictionary<int, HashSet<string>> {
        { 4, new HashSet<string>() },
        { 5, new HashSet<string>() },
        { 6, new HashSet<string>() },
    };

    // Extracting settings from individual game scripts and adding them
    foreach (var mapping in vars.gameScriptMapping) {
        settings.Add(mapping.Value.Item2, true, mapping.Value.Item1 + " Settings");
        string fileContent;
        using (var reader = new StreamReader("Components\\" + mapping.Value.Item2))
        {
            fileContent = reader.ReadToEnd();
        }
        HashSet<string> gameSettingsSet = vars.settingsMapping[mapping.Key];

        if (mapping.Key == 5) {
            foreach (var categoryMap in vars.WWSplitTypes) {
                settings.Add(categoryMap.Key, false, categoryMap.Value, mapping.Value.Item2);
                gameSettingsSet.Add(categoryMap.Key);
            }
        }

        foreach (System.Text.RegularExpressions.Match match in System.Text.RegularExpressions.Regex.Matches(fileContent, mapping.Value.Item3))
        {
            string parentSetting = string.IsNullOrEmpty(match.Groups["parentSetting"].Value) ? mapping.Value.Item2 : match.Groups["parentSetting"].Value;
            settings.Add(match.Groups["key"].Value, (match.Groups["isEnabled"].Value == "true"), match.Groups["displayName"].Value, parentSetting);
            settings.SetToolTip(match.Groups["key"].Value, match.Groups["description"].Value);
            gameSettingsSet.Add(match.Groups["key"].Value);
        }
    }

    vars.getScriptPath = (Func<dynamic, string>)((component) => {
        var componentSetting = component.GetType().GetField("_settings", BindingFlags.Instance | BindingFlags.NonPublic).GetValue(component);
        return componentSetting.GetType().GetProperty("ScriptPath").GetValue(componentSetting) as string;
    });

    vars.removeAllASLComponents = (Action)(() => {
        foreach (var mapping in vars.gameScriptMapping) {
            vars.removeASLComponent(mapping.Key);
        }
    });
    vars.removeAllASLComponents();

    vars.game = 0;
    vars.gameNotRunning = true;
    vars.aboveSoTCredits = false;
}

init
{
    vars.getGameSettings = (Func<int, Dictionary<string, bool>>)((gameId) => {
        HashSet<string> gameSettingsSet = vars.settingsMapping[gameId];
        Dictionary<string, bool> gameSettings = new Dictionary<string, bool> {
            { "start", false },
            { "reset", false },
            { "split", true },
        };
        foreach (string gameSetting in gameSettingsSet) {
            gameSettings.Add(gameSetting, settings[gameSetting]);
        }
        return gameSettings;
    });

    vars.inXRange = (Func<float, float, bool>)((xMin, xMax) => { return current.xPos >= xMin && current.xPos <= xMax; });
    vars.inYRange = (Func<float, float, bool>)((yMin, yMax) => { return current.yPos >= yMin && current.yPos <= yMax; });
    vars.inZRange = (Func<float, float, bool>)((zMin, zMax) => { return current.zPos >= zMin && current.zPos <= zMax; });
    vars.splitByXYZ = (Func<float, float, float, float, float, float, bool>)((xMin, xMax, yMin, yMax, zMin, zMax) => {
        return
            vars.inXRange(xMin, xMax) &&
            vars.inYRange(yMin, yMax) &&
            vars.inZRange(zMin, zMax);
    });

    vars.splitCutsceneByMap = (Func<HashSet<int>, bool>)((mapIds) => {
        return (mapIds.Contains(current.map) && vars.oldCutscene == 0 && current.cutscene == 1);
    });

    vars.splitBossByMap = (Func<HashSet<int>, bool>)((mapIds) => {
        return (vars.splitCutsceneByMap(mapIds) && current.bossHealth == 0);
    });

    if (vars.gameNotRunning) {
        switch(game.ProcessName.ToLower()) {
            case "pop": vars.game = 4; break;
            case "pop2": vars.game = 5; break;
            case "pop3": vars.game = 6; break;
        }

        if (settings.SplitEnabled) {
            vars.setASLComponent(vars.game);
        }
    }
}

start
{
    switch((short)vars.game) {
        case 0: return false;
        case 4: return vars.splitByXYZ(-103.264f, -103.262f, -4.8f, -4.798f, 1.341f, 1.343f) && current.startValue == 1;
        case 5: return current.map == 1292342859 && old.cutscene == 1 && current.cutscene == 2;
        case 6: return vars.inXRange(-404.9f, -404.8f) && current.xCam <= 0.832 && current.xCam >= 0.8318 && current.yCam <= 0.1082 && current.yCam >= 0.1080;
    }
}

onStart
{
    vars.aboveSoTCredits = false;
    vars.gameNotRunning = false;
}

onReset
{
    vars.gameNotRunning = true;
    vars.removeAllASLComponents();
}

update
{
    bool justStarted = false;
    bool justEnded = false;

    switch((short)vars.game) {
        case 4:
            if (vars.splitByXYZ(658.26f, 661.46f, 210.92f, 213.72f, 12.5f, 30f)) vars.aboveSoTCredits = true;
            justStarted = vars.splitByXYZ(-103.264f, -103.262f, -4.8f, -4.798f, 1.341f, 1.343f) && current.startValue == 1;
            justEnded = current.vizierHealth == 4 || (vars.splitByXYZ(658.26f, 661.46f, 210.92f, 213.72f, 9.8f, 12.5f) && vars.aboveSoTCredits);
            break;
        case 5:
            vars.oldCutscene = old.cutscene;
            justStarted = current.map == 1292342859 && old.cutscene == 1 && current.cutscene == 2;
            justEnded = vars.splitBossByMap(new HashSet<int> { 989966866 }) || (vars.splitCutsceneByMap(new HashSet<int> { 989966868 }) && current.yPos > 200);
            break;
        case 6:
            justStarted = vars.inXRange(-404.9f, -404.8f) && current.xCam <= 0.832 && current.xCam >= 0.8318 && current.yCam <= 0.1082 && current.yCam >= 0.1080;
            justEnded = vars.splitByXYZ(189f, 194f, 318f, 330f, 540f, 560f) && current.princeAction == 17;
            break;
    }

    vars.gameNotRunning = !justStarted && (justEnded || vars.gameNotRunning);
}

isLoading
{
    return vars.gameNotRunning;
}

split {
    return false;
}

exit
{
    if (vars.gameNotRunning) {
        vars.removeASLComponent(vars.game);
    }
}

shutdown
{
    vars.removeAllASLComponents();
}
