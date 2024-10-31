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
    float xPos          : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x30;
    float yPos          : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x34;
    float zPos          : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x38;

    // Currently loaded area id (changes with every load trigger)
    int map             : 0x523594;

    // State of the prince (11 is drinking)
    int state           : 0x90C414, 0x18, 0x4, 0x48, 0x3F8;
}

state("POP3")
{
    // The Prince's coords
    float xPos          : 0x00A2A498, 0xC, 0x30;
    float yPos          : 0x00A2A498, 0xC, 0x34;
    float zPos          : 0x00A2A498, 0xC, 0x38;

    float xCam          : 0x928548;
    float yCam          : 0x928554;

    // A value that reliably changes with prince's actions (17 during cutscenes)
    int princeAction    : 0x005EBD78, 0x30, 0x18, 0x4, 0x48, 0x7F0;
}

startup
{
    vars.splitTypes = new Dictionary<string, string> {
        { "pop_sot.asl", "Sands of Time splits" },
        { "pop_ww.asl", "Warrior Within splits" },
        { "pop_t2t.asl", "The Two Thrones splits" },
    };
    
    vars.WWsplitTypes = new Dictionary<string, string> {
        { "AnyGlitched", "Any% (Standard) and Any% (Zipless) splits" },
        { "AnyNMG", "Any% (No Major Glitches) splits" },
        { "TEStandard", "True Ending (Standard) splits" },
        { "TEZipless", "True Ending (Zipless) splits" },
        { "TENMG", "True Ending (No Major Glitches) splits" },
    };

    // Key - Setting ID, Value - Tuple of (Default setting, Description, Tooltip, Game ID and Trigger condition).
    vars.splitsData = new Dictionary<string, Tuple<bool, string, string, string, int, Func<bool>>> {
        // Sands of Time
        {"GasStation", Tuple.Create(true, "Enter Treasure Vaults", "pop_sot.asl", "Split just before the first save prompt", 4, new Func<bool>(() => vars.GasStation()))},
        {"SandsUnleashed", Tuple.Create(true, "Sands Unleashed", "pop_sot.asl", "Split on starting the first fight after the CGI cutscene", 4, new Func<bool>(() => vars.SandsUnleashed()))},
        {"FirstGuestRoom", Tuple.Create(false, "First Guest Room", "pop_sot.asl", "Split on entering the first guest room", 4, new Func<bool>(() => vars.FirstGuestRoom()))},
        {"SultanChamberZipless", Tuple.Create(false, "The Sultan's Chamber", "pop_sot.asl", "Split on entering the Sultan's chamber at the cutscene", 4, new Func<bool>(() => vars.SultanChamberZipless()))},
        {"SultanChamber", Tuple.Create(false, "The Sultan's Chamber (death)", "pop_sot.asl", "Split at the death abuse in Sultan's chamber", 4, new Func<bool>(() => vars.SultanChamber()))},
        {"PalaceDefence", Tuple.Create(false, "The Palace's Defence System", "pop_sot.asl", "Split on exiting the palace defense system", 4, new Func<bool>(() => vars.PalaceDefence()))},
        {"DadStart", Tuple.Create(false, "The Sand King", "pop_sot.asl", "Split on starting the fight with the Sand King", 4, new Func<bool>(() => vars.DadStart()))},
        {"DadDead", Tuple.Create(true, "Death of the Sand King", "pop_sot.asl", "Split at the end of the fight on loading the next area", 4, new Func<bool>(() => vars.DadDead()))},
        {"TheWarehouse", Tuple.Create(false, "The Warehouse", "pop_sot.asl", "Split on hitting the button to let Farah enter Warehouse", 4, new Func<bool>(() => vars.TheWarehouse()))},
        {"TheZoo", Tuple.Create(false, "The Sultan's Zoo", "pop_sot.asl", "Split on entering the zoo", 4, new Func<bool>(() => vars.TheZoo()))},
        {"BirdCage", Tuple.Create(false, "Atop a Bird Cage", "pop_sot.asl", "Split at the 'Atop a bird cage' save vortex", 4, new Func<bool>(() => vars.BirdCage()))},
        {"CliffWaterfalls", Tuple.Create(false, "Cliffs and Waterfall", "pop_sot.asl", "Split at the start of cliffs and waterfall", 4, new Func<bool>(() => vars.CliffWaterfalls()))},
        {"TheBathsZipless", Tuple.Create(false, "The Baths", "pop_sot.asl", "Split at the end of cliffs and Waterfall", 4, new Func<bool>(() => vars.TheBathsZipless()))},
        {"TheBaths", Tuple.Create(false, "The Baths (death)", "pop_sot.asl", "Split on death abuse at the start of baths", 4, new Func<bool>(() => vars.TheBaths()))},
        {"SecondSword", Tuple.Create(false, "Second Sword", "pop_sot.asl", "Split on obtaining the second sword at baths", 4, new Func<bool>(() => vars.SecondSword()))},
        {"TheDaybreak", Tuple.Create(false, "Daybreak", "pop_sot.asl", "Split at the start of daybreak", 4, new Func<bool>(() => vars.TheDaybreak()))},
        {"TheMesshall", Tuple.Create(false, "Soldiers' Mess Hall (death)", "pop_sot.asl", "Split on death abuse in the mess hall", 4, new Func<bool>(() => vars.TheMesshall()))},
        {"DrawbridgeTower", Tuple.Create(false, "Drawbridge Tower", "pop_sot.asl", "Split near the first lever at Drawbridge Tower", 4, new Func<bool>(() => vars.DrawbridgeTower()))},
        {"BrokenBridge", Tuple.Create(false, "A Broken Bridge", "pop_sot.asl", "Split at the end of the collapsing bridge", 4, new Func<bool>(() => vars.BrokenBridge()))},
        {"TheCavesZipless", Tuple.Create(false, "The Caves", "pop_sot.asl", "Split on entering the caves after the door", 4, new Func<bool>(() => vars.TheCavesZipless()))},
        {"TheCaves", Tuple.Create(false, "The Caves (alternate)", "pop_sot.asl", "Split on the beam at the start of Waterfall", 4, new Func<bool>(() => vars.TheCaves()))},
        {"TheWaterfall", Tuple.Create(false, "The Waterfall", "pop_sot.asl", "Split at the end of the descent in Waterfall", 4, new Func<bool>(() => vars.TheWaterfall()))},
        {"TheUGReservoirZipless", Tuple.Create(false, "Enter Underground Reservoir", "pop_sot.asl", "Split on entering the underground reservoir", 4, new Func<bool>(() => vars.TheUGReservoirZipless()))},
        {"TheUGReservoir", Tuple.Create(false, "Exit Underground Reservoir", "pop_sot.asl", "Split on exiting the underground reservoir", 4, new Func<bool>(() => vars.TheUGReservoir()))},
        {"HallofLearning", Tuple.Create(false, "The Hall of Learning", "pop_sot.asl", "Split on entering the hall of learning", 4, new Func<bool>(() => vars.HallofLearning()))},
        {"TheObservatory", Tuple.Create(false, "Observatory (death)", "pop_sot.asl", "Split on death abuse at the end of observatory", 4, new Func<bool>(() => vars.TheObservatory()))},
        {"ObservatoryExit", Tuple.Create(false, "Exit Observatory", "pop_sot.asl", "Split on exiting the observatory", 4, new Func<bool>(() => vars.ObservatoryExit()))},
        {"HoLCourtyardsExit", Tuple.Create(false, "Exit Hall of Learning Courtyards", "pop_sot.asl", "Split on exiting hall of learning courtyards", 4, new Func<bool>(() => vars.HoLCourtyardsExit()))},
        {"TheAzadPrison", Tuple.Create(false, "The Azad Prison", "pop_sot.asl", "Split on entering the prison", 4, new Func<bool>(() => vars.TheAzadPrison()))},
        {"TortureChamberZipless", Tuple.Create(false, "Torture Chamber", "pop_sot.asl", "Split on entering the torture chamber", 4, new Func<bool>(() => vars.TortureChamberZipless()))},
        {"TortureChamber", Tuple.Create(false, "Torture Chamber (death)", "pop_sot.asl", "Split on death abuse at the start of torture chamber", 4, new Func<bool>(() => vars.TortureChamber()))},
        {"TheElevator", Tuple.Create(false, "The Elevator", "pop_sot.asl", "Split on entering the elevator", 4, new Func<bool>(() => vars.TheElevator()))},
        {"TheDreamZipless", Tuple.Create(false, "A Magic Cavern", "pop_sot.asl", "Split at the start of the long unskippable cutscene", 4, new Func<bool>(() => vars.TheDreamZipless()))},
        {"TheDream", Tuple.Create(false, "A Magic Cavern (alternate)", "pop_sot.asl", "Split at the start of the 'infinite' stairs", 4, new Func<bool>(() => vars.TheDream()))},
        {"TheTomb", Tuple.Create(false, "The Tomb", "pop_sot.asl", "Split at the start of the tomb", 4, new Func<bool>(() => vars.TheTomb()))},
        {"TowerofDawn", Tuple.Create(false, "Tower of Dawn", "pop_sot.asl", "Split at the start of the ascent back up the Tower of Dawn", 4, new Func<bool>(() => vars.TowerofDawn()))},
        {"SettingSun", Tuple.Create(false, "Setting Sun", "pop_sot.asl", "Split on the Ladder near the setting sun save", 4, new Func<bool>(() => vars.SettingSun()))},
        {"HonorGlory", Tuple.Create(true, "Honor and Glory", "pop_sot.asl", "Split on starting the last fight with enemies", 4, new Func<bool>(() => vars.HonorGlory()))},
        {"GrandRewind", Tuple.Create(true, "Grand Rewind", "pop_sot.asl", "Split on starting the Vizier fight", 4, new Func<bool>(() => vars.GrandRewind()))},
        {"SoTEnd", Tuple.Create(true, "The End", "pop_sot.asl", "Split on defeating the Vizier or hitting the credits trigger", 4, new Func<bool>(() => vars.SoTEnd()))},
        {"SoTLU", Tuple.Create(false, "Life Upgrades", "pop_sot.asl", "Split on obtaining each life upgrade", 4, new Func<bool>(() => vars.SoTLU()))},

        // Warrior Within
        {"Any0", Tuple.Create(true, "Boat", "AnyGlitched", "Split when the boat ending cutscene starts playing", 5, new Func<bool>(() => vars.boat()))},
        {"Any1", Tuple.Create(true, "Raven man", "AnyGlitched", "Split on the cutscene where you're introduced to a raven master", 5, new Func<bool>(() => vars.ravenMan()))},
        {"Any2", Tuple.Create(true, "Time portal", "AnyGlitched", "Split when you go through the first time portal", 5, new Func<bool>(() => vars.firstPortal()))},
        {"Any3", Tuple.Create(true, "Foundy fountain", "AnyGlitched", "Split when you drink from the foundry fountain while having 58/59 storygate", 5, new Func<bool>(() => vars.foundryFountain()))},
        {"Any4", Tuple.Create(true, "Scorpion sword", "AnyGlitched", "Split when you get the scorpion sword", 5, new Func<bool>(() => vars.scorpionSword()))},
        {"Any5", Tuple.Create(false, "Light sword", "AnyGlitched", "Split when you pick up the light sword in mystic caves", 5, new Func<bool>(() => vars.banana()))},
        {"Any6", Tuple.Create(true, "Mechanical tower (63)", "AnyGlitched", "Split when you acquire storygate 63", 5, new Func<bool>(() => vars.rng63()))},
        {"Any7", Tuple.Create(true, "Second portal", "AnyGlitched", "Split when you go through the time portal in the throne room", 5, new Func<bool>(() => vars.lastPortal()))},
        {"Any8", Tuple.Create(true, "Kaileena", "AnyGlitched", "Split when you kill Kaileena in sacred caves", 5, new Func<bool>(() => vars.kaileena()))},

        {"TeStandard0", Tuple.Create(true, "Boat", "TEStandard", "Split when the boat ending cutscene starts playing", 5, new Func<bool>(() => vars.boat()))},
        {"TeStandard1", Tuple.Create(true, "Raven man", "TEStandard", "Split on the cutscene where you're introduced to a raven master", 5, new Func<bool>(() => vars.ravenMan()))},
        {"TeStandard2", Tuple.Create(true, "Time portal", "TEStandard", "Split when you go through the first time portal", 5, new Func<bool>(() => vars.firstPortal()))},
        {"TeStandard3", Tuple.Create(true, "(1) fortress entrance LU", "TEStandard", "Split when you acquire the life upgrade in fortress entrance", 5, new Func<bool>(() => vars.LUFortress()))},
        {"TeStandard4", Tuple.Create(true, "(2) Prison LU", "TEStandard", "Split when you acquire the life upgrade in prison", 5, new Func<bool>(() => vars.LUPrison()))},
        {"TeStandard5", Tuple.Create(true, "(3) Library LU", "TEStandard", "Split when you acquire the life upgrade in library", 5, new Func<bool>(() => vars.LULibrary()))},
        {"TeStandard6", Tuple.Create(true, "(4) Mechanical tower LU", "TEStandard", "Split when you acquire the life upgrade in mechanical tower", 5, new Func<bool>(() => vars.LUMechTower()))},
        {"TeStandard7", Tuple.Create(true, "(5) Garden LU", "TEStandard", "Split when you acquire the life upgrade in garden", 5, new Func<bool>(() => vars.LUGarden()))},
        {"TeStandard8", Tuple.Create(true, "(6) Waterworks LU", "TEStandard", "Split when you acquire the life upgrade in waterworks", 5, new Func<bool>(() => vars.LUWaterworks()))},
        {"TeStandard9", Tuple.Create(true, "(7) Sacrificial altar LU", "TEStandard", "Split when you acquire the life upgrade in sacrificial altar", 5, new Func<bool>(() => vars.LUShahdee()))},
        {"TeStandard10", Tuple.Create(true, "(8) Southern passage LU", "TEStandard", "Split when you acquire the life upgrade in southern passage", 5, new Func<bool>(() => vars.LU019()))},
        {"TeStandard11", Tuple.Create(true, "(9) Central hall LU", "TEStandard", "Split when you acquire the life upgrade in central hall", 5, new Func<bool>(() => vars.LUCentralHall()))},
        {"TeStandard12", Tuple.Create(true, "Water sword", "TEStandard", "Split when you get the water sword", 5, new Func<bool>(() => vars.WaterSword()))},
        {"TeStandard13", Tuple.Create(true, "Dahaka", "TEStandard", "Split when you defeat Dahaka", 5, new Func<bool>(() => vars.Dahaka()))},

        {"TeZipless0", Tuple.Create(true, "Boat", "TEZipless", "Split when the boat ending cutscene starts playing", 5, new Func<bool>(() => vars.boat()))},
        {"TeZipless1", Tuple.Create(true, "Raven man", "TEZipless", "Split on the cutscene where you're introduced to a raven master", 5, new Func<bool>(() => vars.ravenMan()))},
        {"TeZipless2", Tuple.Create(false, "Time portal", "TEZipless", "Split when you go through the first time portal", 5, new Func<bool>(() => vars.firstPortal()))},
        {"TeZipless3", Tuple.Create(true, "(1) Central hall LU", "TEZipless", "Split when you acquire the life upgrade in central hall", 5, new Func<bool>(() => vars.LUCentralHall()))},
        {"TeZipless4", Tuple.Create(true, "(2) Waterworks LU", "TEZipless", "Split when you acquire the life upgrade in waterworks", 5, new Func<bool>(() => vars.LUWaterworks()))},
        {"TeZipless5", Tuple.Create(true, "(3) Garden LU", "TEZipless", "Split when you acquire the life upgrade in garden", 5, new Func<bool>(() => vars.LUGarden()))},
        {"TeZipless6", Tuple.Create(true, "(4) Fortress entrance LU", "TEZipless", "Split when you acquire the life upgrade in fortress entrance", 5, new Func<bool>(() => vars.LUFortress()))},
        {"TeZipless7", Tuple.Create(true, "Foundry (59)", "TEZipless", "Split when you acquire storygate 59", 5, new Func<bool>(() => vars.rng59()))},
        {"TeZipless8", Tuple.Create(true, "(5) Prison LU", "TEZipless", "Split when you acquire the life upgrade in prison", 5, new Func<bool>(() => vars.LUPrison()))},
        {"TeZipless9", Tuple.Create(true, "(6) Library LU", "TEZipless", "Split when you acquire the life upgrade in library", 5, new Func<bool>(() => vars.LULibrary()))},
        {"TeZipless10", Tuple.Create(false, "Light sword", "TEZipless", "Split when you pick up the light sword in mystic caves", 5, new Func<bool>(() => vars.banana()))},
        {"TeZipless11", Tuple.Create(true, "Mechanical tower (63)", "TEZipless", "Split when you acquire storygate 63", 5, new Func<bool>(() => vars.rng63()))},
        {"TeZipless12", Tuple.Create(true, "(7) Mechanical tower LU", "TEZipless", "Split when you acquire the life upgrade in mechanical tower", 5, new Func<bool>(() => vars.LUMechTower()))},
        {"TeZipless13", Tuple.Create(true, "(8) Southern passage LU", "TEZipless", "Split when you acquire the life upgrade in southern passage", 5, new Func<bool>(() => vars.LU019()))},
        {"TeZipless14", Tuple.Create(true, "(9) Sacrificial altar LU", "TEZipless", "Split when you acquire the life upgrade in sacrificial altar", 5, new Func<bool>(() => vars.LUShahdee()))},
        {"TeZipless15", Tuple.Create(true, "Water sword", "TEZipless", "Split when you get the water sword", 5, new Func<bool>(() => vars.WaterSword()))},
        {"TeZipless16", Tuple.Create(true, "Dahaka", "TEZipless", "Split when you defeat Dahaka", 5, new Func<bool>(() => vars.Dahaka()))},

        {"AnyNmg0", Tuple.Create(true, "Boat", "AnyNMG", "Split when the boat ending cutscene starts playing", 5, new Func<bool>(() => vars.boat()))},
        {"AnyNmg1", Tuple.Create(true, "Spider sword", "AnyNMG", "Split on the cutscene where you get the spider sword", 5, new Func<bool>(() => vars.spiderSword()))},
        {"AnyNmg2", Tuple.Create(false, "Raven man", "AnyNMG", "Split on the cutscene where you're introduced to a raven master", 5, new Func<bool>(() => vars.ravenMan()))},
        {"AnyNmg3", Tuple.Create(false, "Time portal", "AnyNMG", "Split when you go through the first time portal", 5, new Func<bool>(() => vars.firstPortal()))},
        {"AnyNmg4", Tuple.Create(true, "Soutern passage (chasing Shahdee)", "AnyNMG", "Split when you come to southern passage past", 5, new Func<bool>(() => vars.chasingShahdee()))},
        {"AnyNmg5", Tuple.Create(true, "Shahdee (a damsel in distress)", "AnyNMG", "Split when you kill Shahdee", 5, new Func<bool>(() => vars.shahdee()))},
        {"AnyNmg_spPortalEnter", Tuple.Create(false, "Enter Southern Passage Portal", "AnyNMG", "Split when you enter the portal in Southern Passage", 5, new Func<bool>(() => vars.spPortalEnter()))},
        {"AnyNmg_spPortalExit", Tuple.Create(false, "Exit Southern Passage Portal", "AnyNMG", "Split when you exit the portal in Southern Passage", 5, new Func<bool>(() => vars.spPortalExit()))},
        {"AnyNmg6", Tuple.Create(true, "The Dahaka", "AnyNMG", "Split on the cutscene before the first Dahaka chase (southern passage present)", 5, new Func<bool>(() => vars.princeStare()))},
        {"AnyNmg7", Tuple.Create(true, "Serpent sword", "AnyNMG", "Split on the cutscene where you get the serpent sword (hourglass chamber)", 5, new Func<bool>(() => vars.serpentSword()))},
        {"AnyNmg8", Tuple.Create(true, "Garden hall", "AnyNMG", "Split when you come to garden hall", 5, new Func<bool>(() => vars.gardenHall()))},
        {"AnyNmg9", Tuple.Create(true, "Waterworks", "AnyNMG", "Split when you come to garden waterworks", 5, new Func<bool>(() => vars.waterworks()))},
        {"AnyNmg10", Tuple.Create(true, "Lion sword", "AnyNMG", "Split on the cutscene where you get the lion sword (central hall)", 5, new Func<bool>(() => vars.lionSword()))},
        {"AnyNmg11", Tuple.Create(true, "Mechanical tower", "AnyNMG", "Split when you clilmb up into the mechanical tower", 5, new Func<bool>(() => vars.mechTower()))},
        {"AnyNmg12", Tuple.Create(false, "Mechanical tower v2 (elevator cutscene)", "AnyNMG", "Split on the cutscene where you jump down on the elevator at the start of mech tower", 5, new Func<bool>(() => vars.mechElevator()))},
        {"AnyNmg_mpPortalEnter", Tuple.Create(false, "Enter Mechanical Pit Portal", "AnyNMG", "Split when you enter the portal in Mechanical Pit", 5, new Func<bool>(() => vars.mpPortalEnter()))},
        {"AnyNmg13", Tuple.Create(true, "Mechanical Pit Portal", "AnyNMG", "Split when you go through the time portal in mechanical pit", 5, new Func<bool>(() => vars.mechPortal()))},
        {"AnyNmg_mpPortalExit", Tuple.Create(false, "Exit Mechanical Pit Portal", "AnyNMG", "Split when you exit the portal in Mechanical Pit", 5, new Func<bool>(() => vars.mpPortalExit()))},
        {"AnyNmg14", Tuple.Create(true, "Activation room in ruin", "AnyNMG", "Split when you come to the mech tower activation room in the present", 5, new Func<bool>(() => vars.activationRuin()))},
        {"AnyNmg_arPortalEnter", Tuple.Create(false, "Enter Activation room Portal", "AnyNMG", "Split when you enter the portal in Activation room", 5, new Func<bool>(() => vars.arPortalEnter()))},
        {"AnyNmg_arPortalExit", Tuple.Create(false, "Exit Activation room Portal", "AnyNMG", "Split when you exit the portal in Activation room", 5, new Func<bool>(() => vars.arPortalExit()))},
        {"AnyNmg15", Tuple.Create(true, "Activation room restored", "AnyNMG", "Split when you come to the mech tower activation room in the past", 5, new Func<bool>(() => vars.activationRestore()))},
        {"AnyNmg16", Tuple.Create(true, "The death of a sand wraith (central hall)", "AnyNMG", "Split in centrall hall next to the fountain after you've activated both towers", 5, new Func<bool>(() => vars.sandWraithDeathV1()))},
        {"AnyNmg17", Tuple.Create(false, "The death of a sand wraith v2 (central hall)", "AnyNMG", "This is slightly different version of the previous split. It's located deeper into the corridor so you can't hit it early when jumping down", 5, new Func<bool>(() => vars.sandWraithDeathV2()))},
        {"AnyNmg18", Tuple.Create(true, "Death of the empress", "AnyNMG", "Split when you kill Kaileena in the throne room (34->38)", 5, new Func<bool>(() => vars.kaileenaFirst()))},
        {"AnyNmg19", Tuple.Create(true, "Exit the tomb", "AnyNMG", "Split when you leave the tomb", 5, new Func<bool>(() => vars.exitTomb()))},
        {"AnyNmg_prPortalEnter", Tuple.Create(false, "Enter Prison Portal", "AnyNMG", "Split when you enter the portal in Prison", 5, new Func<bool>(() => vars.prPortalEnter()))},
        {"AnyNmg_prPortalExit", Tuple.Create(false, "Exit Prison Portal", "AnyNMG", "Split when you exit the portal in Prison", 5, new Func<bool>(() => vars.prPortalExit()))},
        {"AnyNmg20", Tuple.Create(true, "Scorpion sword", "AnyNMG", "Split when you get the scorpion sword", 5, new Func<bool>(() => vars.scorpionSword()))},
        {"AnyNmg21", Tuple.Create(false, "Library", "AnyNMG", "Split on the library opening cutscene", 5, new Func<bool>(() => vars.libraryV1()))},
        {"AnyNmg22", Tuple.Create(true, "Library v2", "AnyNMG", "Split when you move into the library (after the opening cutscene)", 5, new Func<bool>(() => vars.libraryV2()))},
        {"AnyNmg23", Tuple.Create(true, "Hourglass revisited", "AnyNMG", "Split when you come back to the hourglass chamber after you've killed Kaileena", 5, new Func<bool>(() => vars.hourglassRevisit()))},
        {"AnyNmg_trPortalEnter", Tuple.Create(false, "Enter Throne Room Portal", "AnyNMG", "Split when you enter the cutscene after breaking Throne Room wall", 5, new Func<bool>(() => vars.trPortalEnter()))},
        {"AnyNmg_trPortalExit", Tuple.Create(false, "Exit Throne Room Portal", "AnyNMG", "Split when you exit the portal in Throne Room", 5, new Func<bool>(() => vars.trPortalExit()))},
        {"AnyNmg24", Tuple.Create(true, "The mask of the wraith", "AnyNMG", "Split when you get to the mask", 5, new Func<bool>(() => vars.maskOn()))},
        {"AnyNmg_scPortalEnter", Tuple.Create(false, "Enter Sacred Caves Portal", "AnyNMG", "Split when you enter the portal in Sacred Caves", 5, new Func<bool>(() => vars.scPortalEnter()))},
        {"AnyNmg_scPortalExit", Tuple.Create(false, "Exit Sacred Caves Portal", "AnyNMG", "Split when you exit the portal in Sacred Caves", 5, new Func<bool>(() => vars.scPortalExit()))},
        {"AnyNmg25", Tuple.Create(true, "Sand griffin", "AnyNMG", "Split when you kill the griffin", 5, new Func<bool>(() => vars.griffinV1()))},
        {"AnyNmg26", Tuple.Create(false, "Sand griffin v2", "AnyNMG", "Split when you jump to the platform after you've killed the griffin", 5, new Func<bool>(() => vars.griffinV2()))},
        {"AnyNmg_ugPortalEnter", Tuple.Create(false, "Enter Upper Garden Portal", "AnyNMG", "Split when you enter the portal in Upper Garden", 5, new Func<bool>(() => vars.ugPortalEnter()))},
        {"AnyNmg_ugPortalExit", Tuple.Create(false, "Exit Upper Garden Portal", "AnyNMG", "Split when you exit the portal in Upper Garden", 5, new Func<bool>(() => vars.ugPortalExit()))},
        {"AnyNmg27", Tuple.Create(true, "Mirrored fates", "AnyNMG", "Split on the sacrificial altar cutscene (sand wraith pov)", 5, new Func<bool>(() => vars.mirroredFates()))},
        {"AnyNmg28", Tuple.Create(true, "A favor unknown", "AnyNMG", "Split on the cutscene where the sand wraith saves the prince by throwing an axe (sand wraith pov)", 5, new Func<bool>(() => vars.favorUnknown()))},
        {"AnyNmg29", Tuple.Create(true, "Library revisited", "AnyNMG", "Split when you enter the library", 5, new Func<bool>(() => vars.libraryRevisit()))},
        {"AnyNmg30", Tuple.Create(true, "Light sword", "AnyNMG", "Split when you pick up the light sword in mystic caves", 5, new Func<bool>(() => vars.banana()))},
        {"AnyNmg31", Tuple.Create(true, "The death of a prince", "AnyNMG", "Split on the cutscene where you take the mask off", 5, new Func<bool>(() => vars.maskOff()))},
        {"AnyNmg32", Tuple.Create(true, "Kaileena", "AnyNMG", "Split when you kill Kaileena in sacred caves", 5, new Func<bool>(() => vars.kaileena()))},

        {"TeNmg0", Tuple.Create(true, "Boat", "TENMG", "Split when the boat ending cutscene starts playing", 5, new Func<bool>(() => vars.boat()))},
        {"TeNmg1", Tuple.Create(true, "Spider sword", "TENMG", "Split on the cutscene where you get the spider sword", 5, new Func<bool>(() => vars.spiderSword()))},
        {"TeNmg2", Tuple.Create(false, "Raven man", "TENMG", "Split on the cutscene where you're introduced to a raven master", 5, new Func<bool>(() => vars.ravenMan()))},
        {"TeNmg3", Tuple.Create(false, "Time portal", "TENMG", "Split when you go through the first time portal", 5, new Func<bool>(() => vars.firstPortal()))},
        {"TeNmg4", Tuple.Create(true, "Soutern passage (chasing Shahdee)", "TENMG", "Split when you come to southern passage past", 5, new Func<bool>(() => vars.chasingShahdee()))},
        {"TeNmg5", Tuple.Create(true, "(1) Southern passage LU", "TENMG", "Split when you acquire the life upgrade in southern passage", 5, new Func<bool>(() => vars.LU019()))},
        {"TeNmg6", Tuple.Create(true, "Shahdee (a damsel in distress)", "TENMG", "Split when you kill Shahdee", 5, new Func<bool>(() => vars.shahdee()))},
        {"TeNmg7", Tuple.Create(true, "(2) Sacrificial alter LU", "TENMG", "Split when you acquire the life upgrade in sacrificial altar", 5, new Func<bool>(() => vars.LUShahdee()))},
        {"TeNmg_spPortalEnter", Tuple.Create(false, "Enter Southern Passage Portal", "TENMG", "Split when you enter the portal in Southern Passage", 5, new Func<bool>(() => vars.spPortalEnter()))},
        {"TeNmg_spPortalExit", Tuple.Create(false, "Exit Southern Passage Portal", "TENMG", "Split when you exit the portal in Southern Passage", 5, new Func<bool>(() => vars.spPortalExit()))},
        {"TeNmg8", Tuple.Create(true, "The Dahaka", "TENMG", "Split on the cutscene before the first Dahaka chase (southern passage present)", 5, new Func<bool>(() => vars.princeStare()))},
        {"TeNmg9", Tuple.Create(true, "(3) Fortress entrance LU", "TENMG", "Split when you acquire the life upgrade in fortress entrance", 5, new Func<bool>(() => vars.LUFortress()))},
        {"TeNmg10", Tuple.Create(true, "Serpent sword", "TENMG", "Split on the cutscene where you get the serpent sword (hourglass chamber)", 5, new Func<bool>(() => vars.serpentSword()))},
        {"TeNmg11", Tuple.Create(true, "Garden hall", "TENMG", "Split when you come to garden hall", 5, new Func<bool>(() => vars.gardenHall()))},
        {"TeNmg12", Tuple.Create(false, "Waterworks", "TENMG", "Split when you come to garden waterworks", 5, new Func<bool>(() => vars.waterworks()))},
        {"TeNmg13", Tuple.Create(true, "(4) Waterworks LU", "TENMG", "Split when you acquire the life upgrade in waterworks", 5, new Func<bool>(() => vars.LUWaterworks()))},
        {"TeNmg15", Tuple.Create(true, "(5) Garden LU", "TENMG", "Split when you acquire the life upgrade in garden", 5, new Func<bool>(() => vars.LUGarden()))},
        {"TeNmg16", Tuple.Create(true, "(6) Central hall LU", "TENMG", "Split when you acquire the life upgrade in central hall", 5, new Func<bool>(() => vars.LUCentralHall()))},
        {"TeNmg17", Tuple.Create(false, "Lion sword", "TENMG", "Split on the cutscene where you get the lion sword (central hall)", 5, new Func<bool>(() => vars.lionSword()))},
        {"TeNmg18", Tuple.Create(true, "Mechanical tower", "TENMG", "Split when you clilmb up into the mechanical tower", 5, new Func<bool>(() => vars.mechTower()))},
        {"TeNmg19", Tuple.Create(false, "Mechanical tower v2 (elevator cutscene)", "TENMG", "Split on the cutscene where you jump down on the elevator at the start of mech tower", 5, new Func<bool>(() => vars.mechElevator()))},
        {"TeNmg_mpPortalEnter", Tuple.Create(false, "Enter Mechanical Pit Portal", "TENMG", "Split when you enter the portal in Mechanical Pit", 5, new Func<bool>(() => vars.mpPortalEnter()))},
        {"TeNmg20", Tuple.Create(true, "Mechanical Pit Portal", "TENMG", "Split when you go through the time portal in mechanical pit", 5, new Func<bool>(() => vars.mechPortal()))},
        {"TeNmg_mpPortalExit", Tuple.Create(false, "Exit Mechanical Pit Portal", "TENMG", "Split when you exit the portal in Mechanical Pit", 5, new Func<bool>(() => vars.mpPortalExit()))},
        {"TeNmg21", Tuple.Create(true, "Activation room in ruin", "TENMG", "Split when you come to the mech tower activation room in the present", 5, new Func<bool>(() => vars.activationRuin()))},
        {"TeNmg_arPortalEnter", Tuple.Create(false, "Enter Activation room Portal", "TENMG", "Split when you enter the portal in Activation room", 5, new Func<bool>(() => vars.arPortalEnter()))},
        {"TeNmg_arPortalExit", Tuple.Create(false, "Exit Activation room Portal", "TENMG", "Split when you exit the portal in Activation room", 5, new Func<bool>(() => vars.arPortalExit()))},
        {"TeNmg22", Tuple.Create(false, "Activation room restored", "TENMG", "Split when you come to the mech tower activation room in the past", 5, new Func<bool>(() => vars.activationRestore()))},
        {"TeNmg23", Tuple.Create(true, "(7) Mechanical tower LU", "TENMG", "Split when you acquire the life upgrade in mechanical tower", 5, new Func<bool>(() => vars.LUMechTower()))},
        {"TeNmg24", Tuple.Create(true, "The death of a sand wraith (central hall)", "TENMG", "Split in centrall hall next to the fountain after you've activated both towers", 5, new Func<bool>(() => vars.sandWraithDeathV1()))},
        {"TeNmg25", Tuple.Create(false, "The death of a sand wraith v2 (central hall)", "TENMG", "This is slightly different version of the previous split. It's located deeper into the corridor so you can't hit it early when jumping down", 5, new Func<bool>(() => vars.sandWraithDeathV2()))},
        {"TeNmg26", Tuple.Create(true, "Death of the empress", "TENMG", "Split when you kill Kaileena in the throne room (34->38)", 5, new Func<bool>(() => vars.kaileenaFirst()))},
        {"TeNmg27", Tuple.Create(true, "Exit the tomb", "TENMG", "Split when you leave the tomb", 5, new Func<bool>(() => vars.exitTomb()))},
        {"TeNmg_prPortalEnter", Tuple.Create(false, "Enter Prison Portal", "TENMG", "Split when you enter the portal in Prison", 5, new Func<bool>(() => vars.prPortalEnter()))},
        {"TeNmg_prPortalExit", Tuple.Create(false, "Exit Prison Portal", "TENMG", "Split when you exit the portal in Prison", 5, new Func<bool>(() => vars.prPortalExit()))},
        {"TeNmg28", Tuple.Create(true, "Scorpion sword", "TENMG", "Split when you get the scorpion sword", 5, new Func<bool>(() => vars.scorpionSword()))},
        {"TeNmg29", Tuple.Create(true, "(8) Prison LU", "TENMG", "Split when you acquire the life upgrade in prison", 5, new Func<bool>(() => vars.LUPrison()))},
        {"TeNmg30", Tuple.Create(false, "Library", "TENMG", "Split on the library opening cutscene", 5, new Func<bool>(() => vars.libraryV1()))},
        {"TeNmg31", Tuple.Create(false, "Library v2", "TENMG", "Split when you move into the library (after the opening cutscene)", 5, new Func<bool>(() => vars.libraryV2()))},
        {"TeNmg32", Tuple.Create(true, "(9) Library LU", "TENMG", "Split when you acquire the life upgrade in library", 5, new Func<bool>(() => vars.LULibrary()))},
        {"TeNmg33", Tuple.Create(false, "Hourglass revisited", "TENMG", "Split when you come back to the hourglass chamber after you've killed Kaileena", 5, new Func<bool>(() => vars.hourglassRevisit()))},
        {"TeNmg34", Tuple.Create(true, "Water sword", "TENMG", "Split when you get the water sword", 5, new Func<bool>(() => vars.WaterSword()))},
        {"TeNmg_trPortalEnter", Tuple.Create(false, "Enter Throne Room Portal", "TENMG", "Split when you enter the cutscene after breaking Throne Room wall", 5, new Func<bool>(() => vars.trPortalEnter()))},
        {"TeNmg_trPortalExit", Tuple.Create(false, "Exit Throne Room Portal", "TENMG", "Split when you exit the portal in Throne Room", 5, new Func<bool>(() => vars.trPortalExit()))},
        {"TeNmg35", Tuple.Create(true, "The mask of the wraith", "TENMG", "Split when you get to the mask", 5, new Func<bool>(() => vars.maskOn()))},
        {"TeNmg_scPortalEnter", Tuple.Create(false, "Enter Sacred Caves Portal", "TENMG", "Split when you enter the portal in Sacred Caves", 5, new Func<bool>(() => vars.scPortalEnter()))},
        {"TeNmg_scPortalExit", Tuple.Create(false, "Exit Sacred Caves Portal", "TENMG", "Split when you exit the portal in Sacred Caves", 5, new Func<bool>(() => vars.scPortalExit()))},
        {"TeNmg36", Tuple.Create(true, "Sand griffin", "TENMG", "Split when you kill the griffin", 5, new Func<bool>(() => vars.griffinV1()))},
        {"TeNmg37", Tuple.Create(false, "Sand griffin v2", "TENMG", "Split when you jump to the platform after you've killed the griffin", 5, new Func<bool>(() => vars.griffinV2()))},
        {"TeNmg_ugPortalEnter", Tuple.Create(false, "Enter Upper Garden Portal", "TENMG", "Split when you enter the portal in Upper Garden", 5, new Func<bool>(() => vars.ugPortalEnter()))},
        {"TeNmg_ugPortalExit", Tuple.Create(false, "Exit Upper Garden Portal", "TENMG", "Split when you exit the portal in Upper Garden", 5, new Func<bool>(() => vars.ugPortalExit()))},
        {"TeNmg38", Tuple.Create(true, "Mirrored fates", "TENMG", "Split on the sacrificial altar cutscene (sand wraith pov)", 5, new Func<bool>(() => vars.mirroredFates()))},
        {"TeNmg39", Tuple.Create(true, "A favor unknown", "TENMG", "Split on the cutscene where the sand wraith saves the prince by throwing an axe (sand wraith pov)", 5, new Func<bool>(() => vars.favorUnknown()))},
        {"TeNmg40", Tuple.Create(true, "Library revisited", "TENMG", "Split when you enter the library", 5, new Func<bool>(() => vars.libraryRevisit()))},
        {"TeNmg41", Tuple.Create(true, "Light sword", "TENMG", "Split when you pick up the light sword in mystic caves", 5, new Func<bool>(() => vars.banana()))},
        {"TeNmg42", Tuple.Create(true, "The death of a prince", "TENMG", "Split on the cutscene where you take the mask off", 5, new Func<bool>(() => vars.maskOff()))},
        {"TeNmg43", Tuple.Create(true, "Dahaka", "TENMG", "Split when you defeat Dahaka", 5, new Func<bool>(() => vars.Dahaka()))},

        // The Two Thrones
        {"TheRamparts", Tuple.Create(true, "The Ramparts", "pop_t2t.asl", "Split after the harbor district save fountain", 6, new Func<bool>(() => vars.TheRamparts()))},
        {"HarborDistrict", Tuple.Create(true, "The Harbor District", "pop_t2t.asl", "Split after first palace save fountain", 6, new Func<bool>(() => vars.HarborDistrict()))},
        {"ThePalace", Tuple.Create(true, "The Palace", "pop_t2t.asl", "Split at the end of throne room", 6, new Func<bool>(() => vars.ThePalace()))},
        {"TrappedHallway", Tuple.Create(false, "The Trapped Hallway", "pop_t2t.asl", "Split at end of trapped hallway at the cutscene", 6, new Func<bool>(() => vars.TrappedHallway()))},
        {"TheSewers", Tuple.Create(false, "The Sewers", "pop_t2t.asl", "Split on finishing the sewers dark prince section", 6, new Func<bool>(() => vars.TheSewers()))},
        {"TheSewerz", Tuple.Create(false, "The Sewers (alternate)", "pop_t2t.asl", "Split just before the tunnels save fountain", 6, new Func<bool>(() => vars.TheSewerz()))},
        {"TheFortress", Tuple.Create(false, "The Fortress", "pop_t2t.asl", "Split just before entering the first Chariot", 6, new Func<bool>(() => vars.TheFortress()))},
        {"Chariot1", Tuple.Create(false, "Chariot 1", "pop_t2t.asl", "Split on finishing the first chariot", 6, new Func<bool>(() => vars.Chariot1()))},
        {"LowerCity", Tuple.Create(false, "The Lower City", "pop_t2t.asl", "Split after the lower city dark prince section", 6, new Func<bool>(() => vars.LowerCity()))},
        {"LowerCityRooftops", Tuple.Create(false, "The Lower City Rooftops", "pop_t2t.asl", "Split after killing Klompa", 6, new Func<bool>(() => vars.LowerCityRooftops()))},
        {"ArenaDeload", Tuple.Create(false, "Arena Deload", "pop_t2t.asl", "Split at the black crushers in the arena dark prince section", 6, new Func<bool>(() => vars.ArenaDeload()))},
        {"TheBalconies", Tuple.Create(false, "The Balconies", "pop_t2t.asl", "Split on exiting the room with the slomo gate", 6, new Func<bool>(() => vars.TheBalconies()))},
        {"DarkAlley", Tuple.Create(false, "The Dark Alley", "pop_t2t.asl", "Split on entering the cutscene at start of temple rooftops", 6, new Func<bool>(() => vars.DarkAlley()))},
        {"TheTempleRooftops", Tuple.Create(true, "The Temple Rooftops", "pop_t2t.asl", "Split on entering the door into temple", 6, new Func<bool>(() => vars.TheTempleRooftops()))},
        {"TheTemple", Tuple.Create(false, "The Temple", "pop_t2t.asl", "Split on finishing the temple dark prince section", 6, new Func<bool>(() => vars.TheTemple()))},
        {"TheMarketplace", Tuple.Create(true, "The Marketplace", "pop_t2t.asl", "Split at save fountain before cutscene drop", 6, new Func<bool>(() => vars.TheMarketplace()))},
        {"MarketDistrict", Tuple.Create(false, "The Market District", "pop_t2t.asl", "Split at the save fountain after the long cutscene", 6, new Func<bool>(() => vars.MarketDistrict()))},
        {"TheBrothel", Tuple.Create(false, "The Brothel", "pop_t2t.asl", "Split on finishing the brothel dark prince section", 6, new Func<bool>(() => vars.TheBrothel()))},
        {"ThePlaza", Tuple.Create(true, "The Plaza", "pop_t2t.asl", "Split at the door after Mahasti fight", 6, new Func<bool>(() => vars.ThePlaza()))},
        {"TheUpperCity", Tuple.Create(false, "The Upper City", "pop_t2t.asl", "Split just before the skippable Farah cutscene", 6, new Func<bool>(() => vars.TheUpperCity()))},
        {"CityGarderns", Tuple.Create(false, "The City Garderns", "pop_t2t.asl", "Split just before the Stone Guardian encounter", 6, new Func<bool>(() => vars.CityGarderns()))},
        {"ThePromenade", Tuple.Create(false, "The Promenade", "pop_t2t.asl", "Split on entering the royal workshop", 6, new Func<bool>(() => vars.ThePromenade()))},
        {"RoyalWorkshop", Tuple.Create(true, "Royal Workshop", "pop_t2t.asl", "Split on entering the king's road", 6, new Func<bool>(() => vars.RoyalWorkshop()))},
        {"KingsRoad", Tuple.Create(false, "The King's Road", "pop_t2t.asl", "Split on defeating the twins", 6, new Func<bool>(() => vars.KingsRoad()))},
        {"KingzRoad", Tuple.Create(false, "The King's Road (alternate)", "pop_t2t.asl", "Split on the transition to palace entrance after twins fight", 6, new Func<bool>(() => vars.KingzRoad()))},
        {"PalaceEntrance", Tuple.Create(false, "The Palace Entrance", "pop_t2t.asl", "Split on entering the elevator cutscene", 6, new Func<bool>(() => vars.PalaceEntrance()))},
        {"HangingGardens", Tuple.Create(false, "The Hanging Gardens", "pop_t2t.asl", "Split at the swing pole before the last sand gate", 6, new Func<bool>(() => vars.HangingGardens()))},
        {"HangingGardenz", Tuple.Create(false, "The Hanging Gardens (alternate)", "pop_t2t.asl", "Split at the structure's mind save fountain", 6, new Func<bool>(() => vars.HangingGardenz()))},
        {"StructuresMind", Tuple.Create(false, "The Structure's Mind", "pop_t2t.asl", "Split at the cutscene after the puzzle", 6, new Func<bool>(() => vars.StructuresMind()))},
        {"StructurezMind", Tuple.Create(false, "The Structure's Mind (alternate)", "pop_t2t.asl", "Split after the transition to Well of Ancestors", 6, new Func<bool>(() => vars.StructurezMind()))},
        {"BottomofWell", Tuple.Create(false, "Bottom of the Well", "pop_t2t.asl", "Split after the death abuse at the bottom of the well", 6, new Func<bool>(() => vars.BottomofWell()))},
        {"WellofAncestors", Tuple.Create(false, "The Well of Ancestors", "pop_t2t.asl", "Split on finishing the well dark prince section", 6, new Func<bool>(() => vars.WellofAncestors()))},
        {"TheLabyrinth", Tuple.Create(false, "The Labyrinth", "pop_t2t.asl", "Split on entering the underground cave after breakable wall", 6, new Func<bool>(() => vars.TheLabyrinth()))},
        {"CaveDeath", Tuple.Create(false, "Underground Cave Death", "pop_t2t.asl", "Split on the death abuse at the end of underground cave (for zipping categories)", 6, new Func<bool>(() => vars.CaveDeath()))},
        {"UndergroundCave", Tuple.Create(false, "The Underground Cave", "pop_t2t.asl", "Split on entering the kitchen", 6, new Func<bool>(() => vars.UndergroundCave()))},
        {"LowerTower", Tuple.Create(false, "The Lower Tower", "pop_t2t.asl", "Split on entering the trap corridor after lower tower", 6, new Func<bool>(() => vars.LowerTower()))},
        {"MiddleTower", Tuple.Create(false, "The Middle Tower", "pop_t2t.asl", "Split on entering the trap corridor after middle tower", 6, new Func<bool>(() => vars.MiddleTower()))},
        {"UpperTower", Tuple.Create(true, "The Upper Tower", "pop_t2t.asl", "Split at the upper tower save fountain", 6, new Func<bool>(() => vars.UpperTower()))},
        {"TheTerrace", Tuple.Create(true, "The Terrace", "pop_t2t.asl", "Split on entering the mental realm", 6, new Func<bool>(() => vars.TheTerrace()))},
        {"MentalRealm", Tuple.Create(true, "The Mental Realm", "pop_t2t.asl", "Split on finishing the game", 6, new Func<bool>(() => vars.MentalRealm()))},

        {"T2TLU1", Tuple.Create(false, "Life Upgrade 1", "pop_t2t.asl", "Split after obtaining the first life upgrade in Tunnels", 6, new Func<bool>(() => vars.T2TLU1()))},
        {"T2TLU2", Tuple.Create(false, "Life Upgrade 2", "pop_t2t.asl", "Split after obtaining the second life upgrade in Lower City Rooftops", 6, new Func<bool>(() => vars.T2TLU2()))},
        {"T2TLU3", Tuple.Create(false, "Life Upgrade 3", "pop_t2t.asl", "Split after obtaining the third life upgrade in Temple", 6, new Func<bool>(() => vars.T2TLU3()))},
        {"T2TLU4", Tuple.Create(false, "Life Upgrade 4", "pop_t2t.asl", "Split after obtaining the fourth life upgrade in Tunnels", 6, new Func<bool>(() => vars.T2TLU4()))},
        {"T2TLU5", Tuple.Create(false, "Life Upgrade 5", "pop_t2t.asl", "Split after obtaining the fifth life upgrade in Canal", 6, new Func<bool>(() => vars.T2TLU5()))},
        {"T2TLU6", Tuple.Create(false, "Life Upgrade 6", "pop_t2t.asl", "Split after obtaining the sixth life upgrade in Middle Tower", 6, new Func<bool>(() => vars.T2TLU6()))},
    };

    foreach (var splitType in vars.splitTypes) {
        settings.Add(splitType.Key, true, splitType.Value);
    }

    foreach (var splitType in vars.WWsplitTypes) {
        settings.Add(splitType.Key, false, splitType.Value, "pop_ww.asl");
    }

    foreach (var data in vars.splitsData) {
        settings.Add(data.Key, data.Value.Item1, data.Value.Item2, data.Value.Item3);
        settings.SetToolTip(data.Key, data.Value.Item4);
    }

    vars.game = 0;
    vars.noGameRunning = false;
    vars.CompletedSplits = new HashSet<string>();
    vars.CompletedGames = new HashSet<int>();
}

init
{
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

    vars.splitFountainByStory = (Func<HashSet<int>, bool>)((storyGates) => {
        return (storyGates.Contains(current.storyValue) && vars.oldState != 11 && current.state == 11);
    });

    vars.splitByMapSecondary = (Func<HashSet<int>, int, bool>)((mapIds, secondaryId) => {
        return (mapIds.Contains(current.map) && vars.oldSecondary != secondaryId && current.secondaryWeapon == secondaryId);
    });

    vars.splitByStoryGate = (Func<int, bool>)((storyId) => {
        return (vars.oldStory != storyId && current.storyValue == storyId);
    });

    // List of SoT Splits
    vars.FarahBalcony = (Func <bool>)(() => { return vars.splitByXYZ(-103.264f, -103.262f, -4.8f, -4.798f, 1.341f, 1.343f); });
    vars.GasStation = (Func <bool>)(() => { return vars.splitByXYZ(252f, 258f, 130.647f, 134f, 22.999f, 23.001f); });
    vars.SandsUnleashed = (Func <bool>)(() => { return vars.splitByXYZ(-6.177f, -6.175f, 62.905f, 62.907f, 7.604f, 7.606f); });
    vars.FirstGuestRoom = (Func <bool>)(() => { return vars.splitByXYZ(30.297f, 30.299f, 42.126f, 42.128f, 12.998f, 13f); });
    vars.SultanChamberZipless = (Func <bool>)(() => { return vars.splitByXYZ(98.445f, 98.447f, 39.567f, 39.57f, -8.96f, -8.958f); });
    vars.SultanChamber = (Func <bool>)(() => { return vars.splitByXYZ(134.137f, 134.139f, 54.990f, 54.992f, -32.791f, -32.789f); });
    vars.PalaceDefence = (Func <bool>)(() => { return vars.splitByXYZ(4.547f, 8.851f, 40.494f, 47.519f, -39.001f, -38.999f); });
    vars.DadStart = (Func <bool>)(() => { return vars.splitByXYZ(6.714f, 6.716f, 57.698f, 57.7f, 21.005f, 21.007f); });
    vars.DadDead = (Func <bool>)(() => { return vars.splitByXYZ(-6.001f, -5.999f, -18.6f, -18.4f, 1.998f, 2.001f); });
    vars.TheWarehouse = (Func <bool>)(() => { return vars.splitByXYZ(-73.352f, -71.233f, -28.5f, -26.868f, -1.001f, -0.818f); });
    vars.TheZoo = (Func <bool>)(() => { return vars.splitByXYZ(-141.299f, -139.797f, -47.21f, -42.801f, -31.1f, -30.9f); });
    vars.BirdCage = (Func <bool>)(() => { return vars.splitByXYZ(-211f, -208f, -23f, -21f, -9f, -8.8f); });
    vars.CliffWaterfalls = (Func <bool>)(() => { return vars.splitByXYZ(-233.6f, -231.4f, 33.7f, 35f, -42.6f, -42.4f); });
    vars.TheBathsZipless = (Func <bool>)(() => { return vars.splitByXYZ(-215.85f, -214.089f, 54.261f, 58.699f, -43.501f, -43.499f); });
    vars.TheBaths = (Func <bool>)(() => { return vars.splitByXYZ(-211.427f, -211.425f, 56.602f, 56.604f, -43.501f, -43.499f); });
    vars.SecondSword = (Func <bool>)(() => { return vars.splitByXYZ(-106.819f, -106.817f, 81.097f, 81.099f, -27.269f, -27.267f); });
    vars.TheDaybreak = (Func <bool>)(() => { return vars.splitByXYZ(-76f, -70f, 192.4f, 197.6f, -56.6f, -54f); });
    vars.TheMesshall = (Func <bool>)(() => { return vars.splitByXYZ(-183.267f, -183.265f, 234.685f, 234.687f, -37.528f, -37.526f); });
    vars.DrawbridgeTower = (Func <bool>)(() => { return vars.splitByXYZ(-267f, -262f, 232f, 267f, -35.6f, -35.5f); });
    vars.BrokenBridge = (Func <bool>)(() => { return vars.splitByXYZ(-265f, -257f, 159f, 167f, -13.6f, -13.4f); });
    vars.TheCavesZipless = (Func <bool>)(() => { return vars.splitByXYZ(-303f, -297.5f, 112f, 113.5f, -56.1f, -55.9f); });
    vars.TheCaves = (Func <bool>)(() => { return vars.splitByXYZ(-246.839f, -241.677f, 78.019f, 87.936f, -71.731f, -70.7f); });
    vars.TheWaterfall = (Func <bool>)(() => { return vars.splitByXYZ(-242f, -240.5f, 79.5f, 83f, -121f, -118f); });
    vars.TheUGReservoirZipless = (Func <bool>)(() => { return vars.splitByXYZ(-121f, -110f, -9f, -7f, -154.1f, -153.9f); });
    vars.TheUGReservoir = (Func <bool>)(() => { return vars.splitByXYZ(-51.477f, -48.475f, 72.155f, 73.657f, -24.802f, -24.799f); });
    vars.HallofLearning = (Func <bool>)(() => { return vars.splitByXYZ(73f, 79f, 161f, 163f, -24.1f, -23.9f); });
    vars.TheObservatory = (Func <bool>)(() => { return vars.splitByXYZ(139.231f, 139.233f, 162.556f, 162.558f, -29.502f, -29.5f); });
    vars.ObservatoryExit = (Func <bool>)(() => { return vars.splitByXYZ(137f, 141f, 164f, 164.67f, -29.5f, -29.2f); });
    vars.HoLCourtyardsExit = (Func <bool>)(() => { return vars.splitByXYZ(72f, 77f, 90f, 95.7f, -27.1f, -26.9f); });
    vars.TheAzadPrison = (Func <bool>)(() => { return vars.splitByXYZ(190f, 195f, -21f, -19f, -17.6f, -17.3f); });
    vars.TortureChamberZipless = (Func <bool>)(() => { return vars.splitByXYZ(187.5f, 192.5f, -39f, -37.5f, -119.1f, -118.9f); });
    vars.TortureChamber = (Func <bool>)(() => { return vars.splitByXYZ(189.999f, 190.001f, -43.278f, -43.276f, -119.001f, -118.999f); });
    vars.TheElevator = (Func <bool>)(() => { return vars.splitByXYZ(74f, 75f, -46.751f, -43.252f, -34f, -33f); });
    vars.TheDreamZipless = (Func <bool>)(() => { return vars.splitByXYZ(99f, 101f, -11f, -10f, -56f, -54f); });
    vars.TheDream = (Func <bool>)(() => { return vars.splitByXYZ(95.8f, 96f, -25.1f, -24.9f, -74.9f, -74.7f); });
    vars.TheTomb = (Func <bool>)(() => { return vars.splitByXYZ(100.643f, 100.645f, -11.543f, -11.541f, -67.588f, -67.586f); });
    vars.TowerofDawn = (Func <bool>)(() => { return vars.splitByXYZ(35.5f, 35.7f, -50f, -39f, -32f, -30f); });
    vars.SettingSun = (Func <bool>)(() => { return vars.splitByXYZ(60f, 61f, -58f, -57f, 30f, 32f); });
    vars.HonorGlory = (Func <bool>)(() => { return vars.splitByXYZ(81f, 82f, -60.3f, -59.7f, 89f, 90f); });
    vars.GrandRewind = (Func <bool>)(() => { return vars.splitByXYZ(660.376f, 660.378f, 190.980f, 190.983f, 0.432f, 0.434f); });
    vars.SoTEnd = (Func <bool>)(() => { return (vars.splitByXYZ(658.26f, 661.46f, 210.92f, 213.72f, 9.8f, 12.5f) && vars.CompletedSplits.Contains("AboveCredits")) || current.vizierHealth == 4; });
    vars.SoTLU = (Func <bool>)(() => { return vars.splitByXYZ(-492.608f, -492.606f, -248.833f, -248.831f, 0.219f, 0.221f); });

    // List of WW Splits
    vars.boat = (Func<bool>)(() => { return (vars.splitBossByMap(new HashSet<int> { 67109218 })); });
    vars.ravenMan = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 135462572 })); });
    vars.firstPortal = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 285231807 })); });
    vars.foundryFountain = (Func<bool>)(() => { return (vars.splitFountainByStory(new HashSet<int> { 58, 59 })); });
    vars.scorpionSword = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 135483948, 135483950, 135505359, 135516393, 16809649 }) && current.xPos < -164); });
    vars.banana = (Func<bool>)(() => { return (vars.splitByMapSecondary(new HashSet<int> { 587202754, 587203393 }, 50)); });
    vars.rng63 = (Func<bool>)(() => { return (vars.splitByStoryGate(63)); });
    vars.lastPortal = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { -1509855113, 285233488 })); });
    vars.kaileena = (Func<bool>)(() => { return (vars.splitBossByMap(new HashSet<int> { 989966866 })); });

    vars.LUFortress = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 135501679 })); });
    vars.LUPrison = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 135483948, 135516393, 16809649 }) && current.xPos > -120); });
    vars.LULibrary = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 67144064, 67144084 })); });
    vars.LUMechTower = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 67145445 })); });
    vars.LUGarden = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 1006690753, 1006690755 })); });
    vars.LUWaterworks = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 687877046, 687877489 }) && current.xPos > 70); });
    vars.LUShahdee = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 285225347, 1006717295 })); });
    vars.LU019 = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 989860398, 1006711848 })); });
    vars.LUCentralHall = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 67144144 })); });
    vars.WaterSword = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 1006704427, 1006704429 }) && vars.oldX > -98); });
    vars.Dahaka = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 989966868 }) && current.yPos > 200); });

    vars.rng59 = (Func<bool>)(() => { return (vars.splitByStoryGate(59)); });

    vars.spiderSword = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 135462576 })); });
    vars.chasingShahdee = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 989860400 })); });
    vars.shahdee = (Func<bool>)(() => { return (vars.splitBossByMap(new HashSet<int> { 1006801609 })); });
    vars.spPortalEnter = (Func<bool>)(() => { return (vars.splitByXYZ(95.5f, 97.5f, -107f, -106f, 413.8f, 414.2f)); });
    vars.spPortalExit = (Func<bool>)(() => { return (vars.splitByXYZ(95.5f, 97.5f, -107f, -106f, 113.8f, 114.2f)); });
    vars.princeStare = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 989884886 })); });
    vars.serpentSword = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 1006704429 }) && current.storyValue == 13); });
    vars.gardenHall = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 135495097, 135495099 })); });
    vars.waterworks = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 687877048 })); });
    vars.lionSword = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 67112526 }) && current.storyValue == 21); });
    vars.mechTower = (Func<bool>)(() => { return (current.map == 687876481 && vars.oldZ < 410 && current.zPos >= 410); });
    vars.mechElevator = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 687876652 })); });
    vars.mpPortalEnter = (Func<bool>)(() => { return (vars.splitByXYZ(-211f, -209f, 139f, 141f, 440.8f, 441.2f)); });
    vars.mechPortal = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 285235400 })); });
    vars.mpPortalExit = (Func<bool>)(() => { return (vars.splitByXYZ(-211f, -209f, 139f, 141f, 140.8f, 141.2f)); });
    vars.activationRuin = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 67145437 })); });
    vars.arPortalEnter = (Func<bool>)(() => { return (vars.splitByXYZ(-172f, -170f, 188f, 189f, 181.8f, 182.2f)); });
    vars.arPortalExit = (Func<bool>)(() => { return (vars.splitByXYZ(-172f, -170f, 188f, 189f, 481.8f, 482.2f)); });
    vars.activationRestore = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 67145455 })); });
    vars.sandWraithDeathV1 = (Func<bool>)(() => { return (current.map == 67112526 && vars.oldY < -13 && current.yPos >= -13 && current.zPos < 391 && current.storyValue == 33); });
    vars.sandWraithDeathV2 = (Func<bool>)(() => { return (current.map == 67112526 && vars.oldY < -8 && current.yPos >= -8 && current.storyValue == 33); });
    vars.kaileenaFirst = (Func<bool>)(() => { return (vars.splitByStoryGate(38)); });
    vars.exitTomb = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 135464247 }) && current.zPos > 33); });
    vars.prPortalEnter = (Func<bool>)(() => { return (vars.splitByXYZ(-71f, -69f, -117f, -115f, 19.8f, 20.2f)); });
    vars.prPortalExit = (Func<bool>)(() => { return (vars.splitByXYZ(-71f, -69f, -117f, -115f, 319.8f, 320.2f)); });
    vars.libraryV1 = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 67116821, 67116816 })); });
    vars.libraryV2 = (Func<bool>)(() => { return (current.map == 67116821 && vars.oldX < -112 && current.xPos >= -112 && current.storyValue == 42); });
    vars.hourglassRevisit = (Func<bool>)(() => { return (vars.oldMap == 1006704427 && current.map == 1006704429 && current.storyValue == 45); });
    vars.trPortalEnter = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { -1509855113, 1006704431 })); });
    vars.trPortalExit = (Func<bool>)(() => { return (vars.splitByXYZ(-53.5f, -51.5f, 113f, 114f, 117.8f, 118.2f)); });
    vars.maskOn = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 285231214 })); });
    vars.scPortalEnter = (Func<bool>)(() => { return (vars.splitByXYZ(-72f, -70f, 273f, 274f, 132.8f, 133.2f)); });
    vars.scPortalExit = (Func<bool>)(() => { return (vars.splitByXYZ(-72f, -70f, 273f, 274f, 432.8f, 433.2f)); });
    vars.griffinV1 = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 285231574 }) && current.yPos < 195); });
    vars.griffinV2 = (Func<bool>)(() => { return (current.map == 285231574 && vars.oldY > 166.5 && current.yPos <= 166.5); });
    vars.ugPortalEnter = (Func<bool>)(() => { return (vars.splitByXYZ(78f, 80f, 107f, 108f, 412.3f, 412.7f)); });
    vars.ugPortalExit = (Func<bool>)(() => { return (vars.splitByXYZ(78f, 80f, 107f, 108f, 112.3f, 112.7f)); });
    vars.mirroredFates = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 1006801611 })); });
    vars.favorUnknown = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 135501700 })); });
    vars.libraryRevisit = (Func<bool>)(() => { return (current.map == 67116821 && vars.oldX < -112 && current.xPos >= -112 && current.storyValue == 60); });
    vars.maskOff = (Func<bool>)(() => { return (vars.splitCutsceneByMap(new HashSet<int> { 67112526 }) && current.storyValue == 64); });

    // List of T2T Splits
    vars.TheRamparts = (Func <bool>)(() => { return vars.splitByXYZ(-271f, -265f, 187f, 188f, 74f, 75f); });
    vars.HarborDistrict = (Func <bool>)(() => { return vars.splitByXYZ(-93f, -88f, 236.2f, 238f, 83f, 88f); });
    vars.ThePalace = (Func <bool>)(() => { return vars.splitByXYZ(-35.5f, -35.4f, 232.3f, 232.4f, 146.9f, 147f); });
    vars.TrappedHallway = (Func <bool>)(() => { return vars.splitByXYZ(-52.1f, -52.0f, 135.8f, 135.9f, 75.8f, 76f); });
    vars.TheSewerz = (Func <bool>)(() => { return vars.splitByXYZ(-100f, -96f, -83f, -79f, 19.9f, 20f); });
    vars.TheSewers = (Func <bool>)(() => { return vars.splitByXYZ(-89.0f, -88.0f, -15.2f, -14.7f, 4.9f, 5.1f); });
    vars.TheFortress = (Func <bool>)(() => { return vars.splitByXYZ(-71.4f, -71.3f, 9.6f, 9.7f, 44f, 44.1f); });
    vars.Chariot1 = (Func <bool>)(() => { return vars.splitByXYZ(-443.37f, -443.36f, 355.80f, 355.81f, 57.71f, 57.72f); });
    vars.LowerCity = (Func <bool>)(() => { return vars.splitByXYZ(-319f, -316.5f, 317f, 332.6f, 95.1f, 98f); });
    vars.LowerCityRooftops = (Func <bool>)(() => { return vars.splitByXYZ(-261.5f, -261f, 318f, 319.5f, 46f, 48f); });
    vars.ArenaDeload = (Func <bool>)(() => { return vars.splitByXYZ(-256.1f, -251.9f, 358f, 361.5f, 53.9f, 63.3f); });
    vars.TheBalconies = (Func <bool>)(() => { return vars.splitByXYZ(-194f, -190f, 328f, 329.7f, 32.6f, 33.6f); });
    vars.DarkAlley = (Func <bool>)(() => { return vars.splitByXYZ(-114f, -110f, 328f, 338f, 55f, 59f); });
    vars.TheTempleRooftops = (Func <bool>)(() => { return vars.splitByXYZ(-122.6f, -117.7f, 421.6f, 423f, 107f, 108.1f); });
    vars.TheTemple = (Func <bool>)(() => { return vars.splitByXYZ(-212.2f, -211.9f, 419.0f, 419.8f, 81f, 82f); });
    vars.TheMarketplace= (Func <bool>)(() => { return vars.splitByXYZ(-213f, -207f, 484f, 490f, 101f, 103f); });
    vars.MarketDistrict = (Func <bool>)(() => { return vars.splitByXYZ(-185.5f, -175.5f, 524f, 530f, 90f, 92f); });
    vars.TheBrothel = (Func <bool>)(() => { return vars.splitByXYZ(-152.3f, -152.0f, 549.8f, 549.9f, 91.8f, 92f); });
    vars.ThePlaza = (Func <bool>)(() => { return vars.splitByXYZ(-104f, -100f, 548f, 553f, 105.5f, 106.1f); });
    vars.TheUpperCity = (Func <bool>)(() => { return vars.splitByXYZ(-124.5f, -122.5f, 500f, 505f, 97f, 99f); });
    vars.CityGarderns = (Func <bool>)(() => { return vars.splitByXYZ(-63.5f, -63.4f, 389.7f, 389.8f, 85.2f, 85.3f); });
    vars.ThePromenade = (Func <bool>)(() => { return vars.splitByXYZ(-3f, -1f, 515f, 519f, 72f, 75f); });
    vars.RoyalWorkshop = (Func <bool>)(() => { return vars.splitByXYZ(58f, 62f, 470f, 480f, 79f, 81f); });
    vars.KingsRoad = (Func <bool>)(() => { return vars.splitByXYZ(91.9289f, 91.9290f, 230.0479f, 230.0480f, 70.9877f, 70.9879f); });
    vars.KingzRoad = (Func <bool>)(() => { return vars.splitByXYZ(53f, 70f, 240f, 250f, 70f, 73f); });
    vars.PalaceEntrance = (Func <bool>)(() => { return vars.splitByXYZ(30.8f, 30.9f, 271.2f, 271.3f, 126f, 126.1f); });
    vars.HangingGardens = (Func <bool>)(() => { return vars.splitByXYZ(26f, 28f, 211f, 213f, 191f, 193f); });
    vars.HangingGardenz = (Func <bool>)(() => { return vars.splitByXYZ(5.2f, 5.4f, 213.5f, 215.6f, 194.9f, 196.2f); });
    vars.StructuresMind = (Func <bool>)(() => { return vars.splitByXYZ(-34f, -27f, 240f, 250f, 178f, 180f); });
    vars.StructurezMind = (Func <bool>)(() => { return vars.splitByXYZ(5f, 12f, 243f, 265f, 104f, 104.1f); });
    vars.BottomofWell = (Func <bool>)(() => { return vars.splitByXYZ(-21.35f, -21.34f, 252.67f, 252.68f, 20.95f, 20.96f); });
    vars.WellofAncestors = (Func <bool>)(() => { return vars.splitByXYZ(-12.6f, -12.5f, 241.2f, 241.3f, 0.9f, 1f); });
    vars.CaveDeath = (Func <bool>)(() => { return vars.splitByXYZ(5.99f, 6.00f, 306.96f, 306.97f, 42f, 42.01f); });
    vars.TheLabyrinth = (Func <bool>)(() => { return vars.splitByXYZ(-25.5f, -23f, 325f, 338f, 35.9f, 37.5f); });
    vars.UndergroundCave = (Func <bool>)(() => { return vars.splitByXYZ(-11f, -9f, 327f, 334f, 73f, 74f); });
    vars.LowerTower = (Func <bool>)(() => { return vars.splitByXYZ(-5f, -3f, 316f, 317.5f, 139.9f, 140.1f); });
    vars.MiddleTower = (Func <bool>)(() => { return vars.splitByXYZ(-18f, -12f, 303f, 305f, 184.8f, 185.1f); });
    vars.UpperTower = (Func <bool>)(() => { return vars.splitByXYZ(-8f, -7f, 296f, 298f, 226.9f, 227f); });
    vars.TheTerrace = (Func <bool>)(() => { return vars.splitByXYZ(-7.2f, -6.9f, 245.6f, 245.9f, 677f, 679f); });
    vars.MentalRealm = (Func <bool>)(() => { return vars.splitByXYZ(189f, 194f, 318f, 330f, 540f, 560f) && current.princeAction == 17; });
    vars.T2TLU1 = (Func <bool>)(() => { return vars.splitByXYZ(-14.9972f, -14.9970f, -112.8152f, -112.8150f, 20.0732f, 20.0734f); });
    vars.T2TLU2 = (Func <bool>)(() => { return vars.splitByXYZ(-302.0919f, -302.0917f, 370.8710f, 370.8712f, 52.858f, 52.8582f); });
    vars.T2TLU3 = (Func <bool>)(() => { return vars.splitByXYZ(-187.3369f, -187.3367f, -455.9863f, 455.9865f, 78.0330f, 78.0332f); });
    vars.T2TLU4 = (Func <bool>)(() => { return vars.splitByXYZ(-55.0147f, -55.0145f, 395.7608f, 395.761f, 72.0774f, 72.0776f); });
    vars.T2TLU5 = (Func <bool>)(() => { return vars.splitByXYZ(-30.1223f, -30.1221f, 281.8893f, 281.8895f, 104.0796f, 104.0798f); });
    vars.T2TLU6 = (Func <bool>)(() => { return vars.splitByXYZ(-23.9663f, -23.9661f, 253.9438f, 253.944f, 183.0634f, 183.0636f); });

    vars.CheckSplit = (Func<string, bool>)(key => {
        return (vars.CompletedSplits.Add(key) && settings[key]);
    });

    switch(game.ProcessName.ToLower()) {
        case "pop": vars.game = 4; break;
        case "pop2": vars.game = 5; break;
        case "pop3": vars.game = 6; break;
    }
}

update
{
    bool justStarted = false;
    bool justEnded = false;

    switch((short)vars.game) {
        case 4:
            if (vars.splitByXYZ(-477.88f, -477f, -298f, -297.1f, -0.5f, -0.4f)) vars.CompletedSplits.Remove("SoTLU");
            if (vars.splitByXYZ(658.26f, 661.46f, 210.92f, 213.72f, 12.5f, 30f)) vars.CompletedSplits.Add("AboveCredits");

            justStarted = vars.FarahBalcony() && current.startValue == 1;
            justEnded = vars.SoTEnd();

            break;

        case 5:
            // This is a work-around for the "old" state not working as expected in the init block
            vars.oldCutscene = old.cutscene;
            vars.oldState = old.state;
            vars.oldSecondary = old.secondaryWeapon;
            vars.oldStory = old.storyValue;
            vars.oldMap = old.map;
            vars.oldX = old.xPos;
            vars.oldY = old.yPos;
            vars.oldZ = old.zPos;

            justStarted = current.map == 1292342859 && old.cutscene == 1 && current.cutscene == 2;
            justEnded = vars.kaileena() || vars.Dahaka();

            break;

        case 6:
            justStarted = vars.inXRange(-404.9f, -404.8f) && current.xCam <= 0.832 && current.xCam >= 0.8318 && current.yCam <= 0.1082 && current.yCam >= 0.1080;
            justEnded = vars.MentalRealm();

            break;
    }

    if (justStarted && !vars.CompletedGames.Contains(vars.game)) {
        vars.noGameRunning = false;
    }

    if (justEnded) {
        vars.CompletedGames.Add(vars.game);
        vars.noGameRunning = true;
    }
}

start
{
    switch((short)vars.game) {
        case 0: return false;
        case 4: return vars.FarahBalcony() && current.startValue == 1;
        case 5: return current.map == 1292342859 && old.cutscene == 1 && current.cutscene == 2;
        case 6: return vars.inXRange(-404.9f, -404.8f) && current.xCam <= 0.832 && current.xCam >= 0.8318 && current.yCam <= 0.1082 && current.yCam >= 0.1080;
    }
}

onStart
{
    // Refresh all splits when we start the run, none are yet completed
    vars.CompletedSplits.Clear();
}

isLoading
{
    return vars.noGameRunning;
}

split
{
    foreach (var data in vars.splitsData) {
        if (vars.game == data.Value.Item5 && data.Value.Item6() && vars.CheckSplit(data.Key)) {
            print(data.Key);
            return true;
        }
    }
}
