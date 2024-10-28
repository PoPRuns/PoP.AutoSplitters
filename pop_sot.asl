state("POP")
{
    // Some memory value that reliably changes when 'New Game' is pressed.
    int startValue      : 0x6BC980;

    // Prince's position
    float xPos          : 0x00699474, 0xC, 0x30;
    float yPos          : 0x00699474, 0xC, 0x34;
    float zPos          : 0x00699474, 0xC, 0x38;

    // The Vizier's health where 0 is unharmed and 4 is dead.
    int vizierHealth    : 0x0040E518, 0x6C, 0x18, 0x4, 0x44, 0x0;

    int resetValue      : 0x0040E388, 0x4, 0x398;
}

startup
{
    settings.Add("Lastfightskip", false, "Last Fight Skip Route");
}

init
{
    // List of SoT Splits across categories
    vars.GasStation = (Func <bool>)(() => {
        if (current.xPos >= 252 && current.xPos <= 258 &&
           current.yPos >= 130.647 && current.yPos <= 134 &&
           current.zPos >= 22.999 && current.zPos <= 23.001)
            return true;
        return false;
    });
    vars.SandsUnleashed = (Func <bool>)(() => {
        if (current.xPos >= -6.177 && current.xPos <= -6.175 &&
           current.yPos >= 62.905 && current.yPos <= 62.907 &&
           current.zPos >= 7.604 && current.zPos <= 7.606)
            return true;
        return false;
    });
    vars.FirstGuestRoom = (Func <bool>)(() => {
        if (current.xPos >= 30.297 && current.xPos <= 30.299 &&
           current.yPos >= 42.126 && current.yPos <= 42.128 &&
           current.zPos >= 12.998 && current.zPos <= 13)
            return true;
        return false;
    });
    vars.SultanChamberZipless = (Func <bool>)(() => {
        if (current.xPos >= 98.445 && current.xPos <= 98.447 &&
           current.yPos >= 39.567 && current.yPos <= 39.57 &&
           current.zPos >= -8.96 && current.zPos <= -8.958)
            return true;
        return false;
    });
    vars.SultanChamber = (Func <bool>)(() => {
        if (current.xPos >= 134.137 && current.xPos <= 134.139 &&
           current.yPos >= 54.990 && current.yPos <= 54.992 &&
           current.zPos >= -32.791 && current.zPos <= -32.789)
            return true;
        return false;
    });
    vars.PalaceDefence = (Func <bool>)(() => {
        if (current.xPos >= 4.547 && current.xPos <= 8.851 &&
           current.yPos >= 40.494 && current.yPos <= 47.519 &&
           current.zPos >= -39.001 && current.zPos <= -38.999)
            return true;
        return false;
    });
    vars.DadStart = (Func <bool>)(() => {
        if (current.xPos >= 6.714 && current.xPos <= 6.716 &&
           current.yPos >= 57.698 && current.yPos <= 57.7 &&
           current.zPos >= 21.005 && current.zPos <= 21.007)
            return true;
        return false;
    });
    vars.DadDead = (Func <bool>)(() => {
        if (current.xPos >= -6.001 && current.xPos <= -5.999 &&
           current.yPos >= -18.6 && current.yPos <= -18.4 &&
           current.zPos >= 1.998 && current.zPos <= 2.001)
            return true;
        return false;
    });
    vars.TheWarehouse = (Func <bool>)(() => {
        if (current.xPos >= -73.352 && current.xPos <= -71.233 &&
           current.yPos >= -28.5 && current.yPos <= -26.868 &&
           current.zPos >= -1.001 && current.zPos <= -0.818)
            return true;
        return false;
    });
    vars.TheZoo = (Func <bool>)(() => {
        if (current.xPos >= -141.299 && current.xPos <= -139.797 &&
           current.yPos >= -47.21 && current.yPos <= -42.801 &&
           current.zPos >= -31.1 && current.zPos <= -30.9)
            return true;
        return false;
    });
    vars.BirdCage = (Func <bool>)(() => {
        if (current.xPos >= -211 && current.xPos <= -208 &&
           current.yPos >= -23 && current.yPos <= -21 &&
           current.zPos >= -9 && current.zPos <= -8.8)
            return true;
        return false;
    });
    vars.CliffWaterfalls = (Func <bool>)(() => {
        if (current.xPos >= -233.6 && current.xPos <= -231.4 &&
           current.yPos >= 33.7 && current.yPos <= 35 &&
           current.zPos >= -42.6 && current.zPos <= -42.4)
            return true;
        return false;
    });
    vars.TheBathsZipless = (Func <bool>)(() => {
        if (current.xPos >= -215.85 && current.xPos <= -214.089 &&
           current.yPos >= 54.261 && current.yPos <= 58.699 &&
           current.zPos >= -43.501 && current.zPos <= -43.499)
            return true;
        return false;
    });
    vars.TheBaths = (Func <bool>)(() => {
        if (current.xPos >= -211.427 && current.xPos <= -211.425 &&
           current.yPos >= 56.602 && current.yPos <= 56.604 &&
           current.zPos >= -43.501 && current.zPos <= -43.499)
            return true;
        return false;
    });
    vars.SecondSword = (Func <bool>)(() => {
        if (current.xPos >= -106.819 && current.xPos <= -106.817 &&
           current.yPos >= 81.097 && current.yPos <= 81.099 &&
           current.zPos >= -27.269 && current.zPos <= -27.267)
            return true;
        return false;
    });
    vars.TheDaybreak = (Func <bool>)(() => {
        if (current.xPos >= -76 && current.xPos <= -70 &&
           current.yPos >= 192.4 && current.yPos <= 197.6 &&
           current.zPos >= -56.6 && current.zPos <= -54)
            return true;
        return false;
    });
    vars.TheMesshall = (Func <bool>)(() => {
        if (current.xPos >= -183.267 && current.xPos <= -183.265 &&
           current.yPos >= 234.685 && current.yPos <= 234.687 &&
           current.zPos >= -37.528 && current.zPos <= -37.526)
            return true;
        return false;
    });
    vars.DrawbridgeTower = (Func <bool>)(() => {
        if (current.xPos >= -267 && current.xPos <= -262 &&
           current.yPos >= 232 && current.yPos <= 267 &&
           current.zPos >= -35.6 && current.zPos <= -35.5)
            return true;
        return false;
    });
    vars.BrokenBridge = (Func <bool>)(() => {
        if (current.xPos >= -265 && current.xPos <= -257 &&
           current.yPos >= 159 && current.yPos <= 167 &&
           current.zPos >= -13.6 && current.zPos <= -13.4)
            return true;
        return false;
    });
    vars.TheCavesZipless = (Func <bool>)(() => {
        if (current.xPos >= -303 && current.xPos <= -297.5 &&
           current.yPos >= 112 && current.yPos <= 113.5 &&
           current.zPos >= -56.1 && current.zPos <= -55.9)
            return true;
        return false;
    });
    vars.TheCaves = (Func <bool>)(() => {
        if (current.xPos >= -246.839 && current.xPos <= -241.677 &&
           current.yPos >= 78.019 && current.yPos <= 87.936 &&
           current.zPos >= -71.731 && current.zPos <= -70.7)
            return true;
        return false;
    });
    vars.TheCavesAC = (Func <bool>)(() => {
        if (current.xPos >=-171.193 && current.xPos <= -171.191 &&
           current.yPos >= -52.07 && current.yPos <= -52.068 &&
           current.zPos >= -119.863 && current.zPos <= -119.861)
            return true;
        return false;
    });
    vars.TheWaterfall = (Func <bool>)(() => {
        if (current.xPos >= -242 && current.xPos <= -240.5 &&
           current.yPos >= 79.5 && current.yPos <= 83 &&
           current.zPos >= -121 && current.zPos <= -118)
            return true;
        return false;
    });
    vars.TheUGReservoirZipless = (Func <bool>)(() => {
        if (current.xPos >= -121 && current.xPos <= -110 &&
           current.yPos >= -9 && current.yPos <= -7 &&
           current.zPos >= -154.1 && current.zPos <= -153.9)
            return true;
        return false;
    });
    vars.TheUGReservoir = (Func <bool>)(() => {
        if (current.xPos >= -51.477 && current.xPos <= -48.475 &&
           current.yPos >= 72.155 && current.yPos <= 73.657 &&
           current.zPos >= -24.802 && current.zPos <= -24.799)
            return true;
        return false;
    });
    vars.HallofLearning = (Func <bool>)(() => {
        if (current.xPos >= 73 && current.xPos <= 79 &&
           current.yPos >= 161 && current.yPos <= 163 &&
           current.zPos >= -24.1 && current.zPos <= -23.9)
            return true;
        return false;
    });
    vars.TheObservatory = (Func <bool>)(() => {
        if (current.xPos >= 139.231 && current.xPos <= 139.233 &&
           current.yPos >= 162.556 && current.yPos <= 162.558 &&
           current.zPos >= -29.502 && current.zPos <= -29.5)
            return true;
        return false;
    });
    vars.ObservatoryExit = (Func <bool>)(() => {
        if (current.xPos >= 137 && current.xPos <= 141 &&
           current.yPos >= 164 && current.yPos <= 164.67 &&
           current.zPos >= -29.5 && current.zPos <= -29.2)
            return true;
        return false;
    });
    vars.HoLCourtyardsExit = (Func <bool>)(() => {
        if (current.xPos >= 72 && current.xPos <= 77 &&
           current.yPos >= 90 && current.yPos <= 95.7 &&
           current.zPos >= -27.1 && current.zPos <= -26.9)
            return true;
        return false;
    });
    vars.TheAzadPrison = (Func <bool>)(() => {
        if (current.xPos >= 190 && current.xPos <= 195 &&
           current.yPos >= -21 && current.yPos <= -19 &&
           current.zPos >= -17.6 && current.zPos <= -17.3)
            return true;
        return false;
    });
    vars.TortureChamberZipless = (Func <bool>)(() => {
        if (current.xPos >= 187.5 && current.xPos <= 192.5 &&
           current.yPos >= -39 && current.yPos <= -37.5 &&
           current.zPos >= -119.1 && current.zPos <= -118.9)
            return true;
        return false;
    });
    vars.TortureChamber = (Func <bool>)(() => {
        if (current.xPos >= 189.999 && current.xPos <= 190.001 &&
           current.yPos >= -43.278 && current.yPos <= -43.276 &&
           current.zPos >= -119.001 && current.zPos <= -118.999)
            return true;
        return false;
    });
    vars.TheElevator = (Func <bool>)(() => {
        if (current.xPos >= 74 && current.xPos <= 75 &&
           current.yPos >= -46.751 && current.yPos <= -43.252 &&
           current.zPos >= -34 && current.zPos <= -33)
            return true;
        return false;
    });
    vars.TheDreamZipless = (Func <bool>)(() => {
        if (current.xPos >= 99 && current.xPos <= 101 &&
           current.yPos >= -11 && current.yPos <= -10 &&
           current.zPos >= -56 && current.zPos <= -54)
            return true;
        return false;
    });
    vars.TheDream = (Func <bool>)(() => {
        if (current.xPos >= 95.8 && current.xPos <= 96 &&
           current.yPos >= -25.1 && current.yPos <= -24.9 &&
           current.zPos >= -74.9 && current.zPos <= -74.7)
            return true;
        return false;
    });
    vars.TheTomb = (Func <bool>)(() => {
        if (current.xPos >= 100.643 && current.xPos <= 100.645 &&
           current.yPos >= -11.543 && current.yPos <= -11.541 &&
           current.zPos >= -67.588 && current.zPos <= -67.586)
            return true;
        return false;
    });
    vars.TowerofDawn = (Func <bool>)(() => {
        if (current.xPos >= 35.5 && current.xPos <= 35.7 &&
           current.yPos >= -50 && current.yPos <= -39 &&
           current.zPos >= -32 && current.zPos <= -30)
            return true;
        return false;
    });
    vars.SettingSun = (Func <bool>)(() => {
        if (current.xPos >= 60 && current.xPos <= 61 &&
           current.yPos >= -58 && current.yPos <= -57 &&
           current.zPos >= 30 && current.zPos <= 32)
            return true;
        return false;
    });
    vars.HonorGlory = (Func <bool>)(() => {
        if (current.xPos >= 81 && current.xPos <= 82 &&
           current.yPos >= -60.3 && current.yPos <= -59.7 &&
           current.zPos >= 89 && current.zPos <= 90)
            return true;
        return false;
    });
    vars.LastFightSkip = (Func <bool>)(() => {
        if (current.xPos >= 58 && current.xPos <= 61 &&
           current.yPos >= -60 && current.yPos <= -57.5 &&
           current.zPos >= 29 && current.zPos <= 30.5 &&
           settings["Lastfightskip"])
            return true;
        return false;
    });
    vars.GrandRewind = (Func <bool>)(() => {
        if (current.xPos >= 660.376 && current.xPos <= 660.378 &&
          current.yPos >= 190.980 && current.yPos <= 190.983 &&
          current.zPos >= 0.432 && current.zPos <= 0.434)
            return true;
        return false;
    });
    vars.SoTEnd = (Func <bool>)(() => {
        if (current.xPos >= 658.26 && current.xPos <= 661.46 &&
           current.yPos >= 210.92 && current.yPos <= 213.72 &&
           current.zPos >= 12.5)
            vars.aboveCredits = true;
        if (current.xPos >= 658.26 && current.xPos <= 661.46 &&
           current.yPos >= 210.92 && current.yPos <= 213.72 &&
           current.zPos >= 9.8 && current.zPos <= 12.5 &&
           vars.aboveCredits)
            return true;
        if (current.vizierHealth == 4)
            return true;
        return false;
    });
    vars.SoTLU = (Func <bool>)(() => {
        if (current.xPos >= -477.88 && current.xPos <= -477 &&
           current.yPos >= -298 && current.yPos <= -297.1 &&
           current.zPos >= -0.5 && current.zPos <= -0.4) {
            vars.newFountain = true;
            }
        if (current.xPos >= -492.608 && current.xPos <= -492.606 &&
           current.yPos >= -248.833 && current.yPos <= -248.831 &&
           current.zPos >= 0.219 && current.zPos <= 0.221 &&
           vars.newFountain) {
            vars.newFountain = false;
            return true;
            }
        return false;
    });
}

start
{
    // Detecting if the game has started on the balcony.
    return (current.xPos >= -103.264 && current.yPos >= -4.8 && current.zPos >= 1.341 && current.xPos <= -103.262 && current.yPos <= -4.798 && current.zPos <= 1.343 && current.startValue == 1);
}

onStart
{
    vars.aboveCredits = false;
    vars.newFountain = false;
    vars.startUp = true;
}

reset
{
    if (old.resetValue == 1 && current.resetValue == 2) {
        if (current.xPos >= -103.264 && current.yPos >= -4.8 && current.zPos >= 1.341 && current.xPos <= -103.262 && current.yPos <= -4.798 && current.zPos <= 1.343)
            return true;
    }
}

split
{
    switch(timer.Run.GetExtendedCategoryName()) {
        case "Any% (Standard)":
            switch (timer.CurrentSplitIndex) {
                //The Treasure Vaults
                case 0:
                    return vars.GasStation();
                //The Sands of Time
                case 1:
                    return vars.SandsUnleashed();
                //The Sultan's Chamber (Death)
                case 2:
                    return vars.SultanChamber();
                //Death of the Sand King
                case 3:
                    return vars.DadDead();
                //The Baths (Death)
                case 4:
                    return vars.TheBaths();
                //The Messhall (Death)
                case 5:
                    return vars.TheMesshall();
                //The Caves
                case 6:
                    return vars.TheCaves();
                //Exit Underground Reservoir
                case 7:
                    return vars.TheUGReservoir();
                //The Observatory (Death)
                case 8:
                    return vars.TheObservatory();
                //The Torture Chamber (Death)
                case 9:
                    return vars.TortureChamber();
                //The Dream
                case 10:
                    return vars.TheDream();
                //Honor and Glory
                case 11:
                    if (vars.HonorGlory()||vars.LastFightSkip())
                        return true;
                    break;
                //The Grand Rewind
                case 12:
                    return vars.GrandRewind();
                //The End
                case 13:
                    return vars.SoTEnd();
            }
            break;

        case "Any% (Zipless)":
            switch (timer.CurrentSplitIndex) {
                //The Treasure Vaults
                case 0:
                    return vars.GasStation();
                //The Sands of Time
                case 1:
                    return vars.SandsUnleashed();
                //First Guest Room
                case 2:
                    return vars.FirstGuestRoom();
                //The Sultan's Chamber
                case 3:
                    return vars.SultanChamberZipless();
                //Exit Palace Defense
                case 4:
                    return vars.PalaceDefence();
                //The Sand King
                case 5:
                    return vars.DadStart();
                //Death of the Sand King
                case 6:
                    return vars.DadDead();
                //The Warehouse
                case 7:
                    return vars.TheWarehouse();
                //The Zoo
                case 8:
                    return vars.TheZoo();
                //Atop a Bird Cage
                case 9:
                    return vars.BirdCage();
                //Cliffs and Waterfall
                case 10:
                    return vars.CliffWaterfalls();
                //The Baths
                case 11:
                    return vars.TheBathsZipless();
                //Sword of the Mighty Warrior
                case 12:
                    return vars.SecondSword();
                //Daybreak
                case 13:
                    return vars.TheDaybreak();
                //Drawbridge Tower
                case 14:
                    return vars.DrawbridgeTower();
                //A Broken Bridge
                case 15:
                    return vars.BrokenBridge();
                //The Caves
                case 16:
                    return vars.TheCavesZipless();
                //Waterfall
                case 17:
                    return vars.TheWaterfall();
                //An Underground Reservoir
                case 18:
                    return vars.TheUGReservoirZipless();
                //Hall of Learning
                case 19:
                    return vars.HallofLearning();
                //Exit Observatory
                case 20:
                    return vars.ObservatoryExit();
                //Exit Hall of Learning Courtyards
                case 21:
                    return vars.HoLCourtyardsExit();
                //The Prison
                case 22:
                    return vars.TheAzadPrison();
                //The Torture Chamber
                case 23:
                    return vars.TortureChamberZipless();
                //The Elevator
                case 24:
                    return vars.TheElevator();
                //The Dream
                case 25:
                    return vars.TheDreamZipless();
                //The Tomb
                case 26:
                    return vars.TheTomb();
                //The Tower of Dawn
                case 27:
                    return vars.TowerofDawn();
                //The Setting Sun
                case 28:
                    return vars.SettingSun();
                //Honor and Glory
                case 29:
                    return vars.HonorGlory();
                //The Grand Rewind
                case 30:
                    return vars.GrandRewind();
                //The End
                case 31:
                    return vars.SoTEnd();
            }
            break;

        case "Any% (No Major Glitches)":
            switch (timer.CurrentSplitIndex) {
                //The Treasure Vaults
                case 0:
                    return vars.GasStation();
                //The Sands of Time
                case 1:
                    return vars.SandsUnleashed();
                //First Guest Room
                case 2:
                    return vars.FirstGuestRoom();
                //The Sultan's Chamber
                case 3:
                    return vars.SultanChamberZipless();
                //Exit Palace Defense
                case 4:
                    return vars.PalaceDefence();
                //The Sand King
                case 5:
                    return vars.DadStart();
                //Death of the Sand King
                case 6:
                    return vars.DadDead();
                //The Warehouse
                case 7:
                    return vars.TheWarehouse();
                //The Zoo
                case 8:
                    return vars.TheZoo();
                //Atop a Bird Cage
                case 9:
                    return vars.BirdCage();
                //Cliffs and Waterfall
                case 10:
                    return vars.CliffWaterfalls();
                //The Baths
                case 11:
                    return vars.TheBathsZipless();
                //Sword of the Mighty Warrior
                case 12:
                    return vars.SecondSword();
                //Daybreak
                case 13:
                    return vars.TheDaybreak();
                //Drawbridge Tower
                case 14:
                    return vars.DrawbridgeTower();
                //A Broken Bridge
                case 15:
                    return vars.BrokenBridge();
                //The Caves
                case 16:
                    return vars.TheCavesZipless();
                //Waterfall
                case 17:
                    return vars.TheWaterfall();
                //An Underground Reservoir
                case 18:
                    return vars.TheUGReservoirZipless();
                //Hall of Learning
                case 19:
                    return vars.HallofLearning();
                //Exit Observatory
                case 20:
                    return vars.ObservatoryExit();
                //Exit Hall of Learning Courtyards
                case 21:
                    return vars.HoLCourtyardsExit();
                //The Prison
                case 22:
                    return vars.TheAzadPrison();
                //The Torture Chamber
                case 23:
                    return vars.TortureChamberZipless();
                //The Elevator
                case 24:
                    return vars.TheElevator();
                //The Dream
                case 25:
                    return vars.TheDreamZipless();
                //The Tomb
                case 26:
                    return vars.TheTomb();
                //The Tower of Dawn
                case 27:
                    return vars.TowerofDawn();
                //The Setting Sun
                case 28:
                    return vars.SettingSun();
                //Honor and Glory
                case 29:
                    return vars.HonorGlory();
                //The Grand Rewind
                case 30:
                    return vars.GrandRewind();
                //The End
                case 31:
                    return vars.SoTEnd();
            }
            break;

        case "All Collectibles (Standard)":
            switch (timer.CurrentSplitIndex) {
                //The Treasure Vaults
                case 0:
                    return vars.GasStation();
                //The Sands of Time
                case 1:
                    return vars.SandsUnleashed();
                //Life Upgrade 1
                case 2:
                    return vars.SoTLU();
                //Life Upgrade 2
                case 3:
                    return vars.SoTLU();
                //Life Upgrade 3
                case 4:
                    return vars.SoTLU();
                //The Baths (Death)
                case 5:
                    return vars.TheBaths();
                //Life Upgrade 4
                case 6:
                    return vars.SoTLU();
                //The Messhall (Death)
                case 7:
                    return vars.TheMesshall();
                //Life Upgrade 5
                case 8:
                    return vars.SoTLU();
                //The Caves (Death)
                case 9:
                    return vars.TheCaves();
                //Life Upgrade 6
                case 10:
                    return vars.SoTLU();
                //Life Upgrade 7
                case 11:
                    return vars.SoTLU();
                //The Observatory (Death)
                case 12:
                    return vars.TheObservatory();
                //Life Upgrade 8
                case 13:
                    return vars.SoTLU();
                //Life Upgrade 9
                case 14:
                    return vars.SoTLU();
                //The Dream
                case 15:
                    return vars.TheDream();
                //Life Upgrade 10
                case 16:
                    return vars.SoTLU();
                //Honor and Glory
                case 17:
                    if (vars.HonorGlory()||vars.LastFightSkip())
                        return true;
                    break;
                //The Grand Rewind
                case 18:
                    return vars.GrandRewind();
                //The End
                case 19:
                    return vars.SoTEnd();
            }
            break;

        case "All Collectibles (Zipless)":
            switch (timer.CurrentSplitIndex) {
                //The Treasure Vaults
                case 0:
                    return vars.GasStation();
                //The Sands of Time
                case 1:
                    return vars.SandsUnleashed();
                //First Guest Room
                case 2:
                    return vars.FirstGuestRoom();
                //Life Upgrade 1
                case 3:
                    return vars.SoTLU();
                //Exit Palace Defense
                case 4:
                    return vars.PalaceDefence();
                //Life Upgrade 2
                case 5:
                    return vars.SoTLU();
                //Death of the Sand King
                case 6:
                    return vars.DadDead();
                //Life Upgrade 3
                case 7:
                    return vars.SoTLU();
                //The Zoo
                case 8:
                    return vars.TheZoo();
                //Atop a Bird Cage
                case 9:
                    return vars.BirdCage();
                //Cliffs and Waterfall
                case 10:
                    return vars.CliffWaterfalls();
                //The Baths
                case 11:
                    return vars.TheBathsZipless();
                //Life Upgrade 4
                case 12:
                    return vars.SoTLU();
                //Daybreak
                case 13:
                    return vars.TheDaybreak();
                //Drawbridge Tower
                case 14:
                    return vars.DrawbridgeTower();
                //A Broken Bridge
                case 15:
                    return vars.BrokenBridge();
                //Life Upgrade 5
                case 16:
                    return vars.SoTLU();
                //Waterfall
                case 17:
                    return vars.TheWaterfall();
                //An Underground Reservoir
                case 18:
                    return vars.TheUGReservoirZipless();
                //Life Upgrade 6
                case 19:
                    return vars.SoTLU();
                //Hall of Learning
                case 20:
                    return vars.HallofLearning();
                //Life Upgrade 7
                case 21:
                    return vars.SoTLU();
                //Exit Observatory
                case 22:
                    return vars.ObservatoryExit();
                //Exit Hall of Learning Courtyards
                case 23:
                    return vars.HoLCourtyardsExit();
                //The Prison
                case 24:
                    return vars.TheAzadPrison();
                //Life Upgrade 8
                case 25:
                    return vars.SoTLU();
                //Life Upgrade 9
                case 26:
                    return vars.SoTLU();
                //The Dream
                case 27:
                    if (vars.TheDream)
                        return true;
                    break;
                //The Tomb
                case 28:
                    return vars.TheTomb();
                //Life Upgrade 10
                case 29:
                    return vars.SoTLU();
                //The Tower of Dawn
                case 30:
                    return vars.TowerofDawn();
                //The Setting Sun
                case 31:
                    return vars.SettingSun();
                //Honor and Glory
                case 32:
                    return vars.HonorGlory();
                //The Grand Rewind
                case 33:
                    return vars.GrandRewind();
                //The End
                case 34:
                    return vars.SoTEnd();
            }
            break;

        case "All Collectibles (No Major Glitches)":
            switch (timer.CurrentSplitIndex) {
                //The Treasure Vaults
                case 0:
                    return vars.GasStation();
                //The Sands of Time
                case 1:
                    return vars.SandsUnleashed();
                //First Guest Room
                case 2:
                    return vars.FirstGuestRoom();
                //Life Upgrade 1
                case 3:
                    return vars.SoTLU();
                //Exit Palace Defense
                case 4:
                    return vars.PalaceDefence();
                //Life Upgrade 2
                case 5:
                    return vars.SoTLU();
                //Death of the Sand King
                case 6:
                    return vars.DadDead();
                //Life Upgrade 3
                case 7:
                    return vars.SoTLU();
                //The Zoo
                case 8:
                    return vars.TheZoo();
                //Atop a Bird Cage
                case 9:
                    return vars.BirdCage();
                //Cliffs and Waterfall
                case 10:
                    return vars.CliffWaterfalls();
                //The Baths
                case 11:
                    return vars.TheBathsZipless();
                //Life Upgrade 4
                case 12:
                    return vars.SoTLU();
                //Daybreak
                case 13:
                    return vars.TheDaybreak();
                //Drawbridge Tower
                case 14:
                    return vars.DrawbridgeTower();
                //A Broken Bridge
                case 15:
                    return vars.BrokenBridge();
                //Life Upgrade 5
                case 16:
                    return vars.SoTLU();
                //Waterfall
                case 17:
                    return vars.TheWaterfall();
                //An Underground Reservoir
                case 18:
                    return vars.TheUGReservoirZipless();
                //Life Upgrade 6
                case 19:
                    return vars.SoTLU();
                //Hall of Learning
                case 20:
                    return vars.HallofLearning();
                //Life Upgrade 7
                case 21:
                    return vars.SoTLU();
                //Exit Observatory
                case 22:
                    return vars.ObservatoryExit();
                //Exit Hall of Learning Courtyards
                case 23:
                    return vars.HoLCourtyardsExit();
                //The Prison
                case 24:
                    return vars.TheAzadPrison();
                //Life Upgrade 8
                case 25:
                    return vars.SoTLU();
                //Life Upgrade 9
                case 26:
                    return vars.SoTLU();
                //The Dream
                case 27:
                    if (vars.TheDream)
                        return true;
                    break;
                //The Tomb
                case 28:
                    return vars.TheTomb();
                //Life Upgrade 10
                case 29:
                    return vars.SoTLU();
                //The Tower of Dawn
                case 30:
                    return vars.TowerofDawn();
                //The Setting Sun
                case 31:
                    return vars.SettingSun();
                //Honor and Glory
                case 32:
                    return vars.HonorGlory();
                //The Grand Rewind
                case 33:
                    return vars.GrandRewind();
                //The End
                case 34:
                    return vars.SoTEnd();
            }
            break;
    }
}
