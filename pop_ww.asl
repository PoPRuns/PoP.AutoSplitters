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

    // Gallery trackers
    ulong chestBits     : 0x8D2EA8;
    ulong weaponBits    : 0x8D2EB0;
}

startup
{
    vars.splitTypes = new Dictionary<string, string> {
        { "AnyGlitched", "Any% (Standard) and Any% (Zipless) splits" },
        { "AnyNMG", "Any% (No Major Glitches) splits" },
        { "TEStandard", "True Ending (Standard) splits" },
        { "TEZipless", "True Ending (Zipless) splits" },
        { "TENMG", "True Ending (No Major Glitches) splits" },
    };

    // Key - Setting ID, Value - Tuple of (Default setting, Description, Split type, Tooltip and Trigger condition).
    // The keys have been named the way they are to not mess-up users' already set settings.
    // To anyone looking add new splits - please make the key descriptive too, it won't affect anything already added.
    vars.splitsData = new Dictionary<string, Tuple<bool, string, string, string, Func<bool>>> {
        {"Any0", Tuple.Create(true, "Boat", "AnyGlitched", "Split when the boat ending cutscene starts playing", new Func<bool>(() => vars.boat()))},
        {"Any1", Tuple.Create(true, "Raven man", "AnyGlitched", "Split on the cutscene where you're introduced to a raven master", new Func<bool>(() => vars.ravenMan()))},
        {"Any2", Tuple.Create(true, "Time portal", "AnyGlitched", "Split when you go through the first time portal", new Func<bool>(() => vars.firstPortal()))},
        {"Any3", Tuple.Create(true, "Foundy fountain", "AnyGlitched", "Split when you drink from the foundry fountain while having 58/59 storygate", new Func<bool>(() => vars.foundryFountain()))},
        {"Any4", Tuple.Create(true, "Scorpion sword", "AnyGlitched", "Split when you get the scorpion sword", new Func<bool>(() => vars.scorpionSword()))},
        {"Any5", Tuple.Create(false, "Light sword", "AnyGlitched", "Split when you pick up the light sword in mystic caves", new Func<bool>(() => vars.banana()))},
        {"Any6", Tuple.Create(true, "Mechanical tower (63)", "AnyGlitched", "Split when you acquire storygate 63", new Func<bool>(() => vars.rng63()))},
        {"Any7", Tuple.Create(true, "Second portal", "AnyGlitched", "Split when you go through the time portal in the throne room", new Func<bool>(() => vars.lastPortal()))},
        {"Any8", Tuple.Create(true, "Kaileena", "AnyGlitched", "Split when you kill Kaileena in sacred caves", new Func<bool>(() => vars.kaileena()))},

        {"TeStandard0", Tuple.Create(true, "Boat", "TEStandard", "Split when the boat ending cutscene starts playing", new Func<bool>(() => vars.boat()))},
        {"TeStandard1", Tuple.Create(true, "Raven man", "TEStandard", "Split on the cutscene where you're introduced to a raven master", new Func<bool>(() => vars.ravenMan()))},
        {"TeStandard2", Tuple.Create(true, "Time portal", "TEStandard", "Split when you go through the first time portal", new Func<bool>(() => vars.firstPortal()))},
        {"TeStandard3", Tuple.Create(true, "(1) fortress entrance LU", "TEStandard", "Split when you acquire the life upgrade in fortress entrance", new Func<bool>(() => vars.LUFortress()))},
        {"TeStandard4", Tuple.Create(true, "(2) Prison LU", "TEStandard", "Split when you acquire the life upgrade in prison", new Func<bool>(() => vars.LUPrison()))},
        {"TeStandard5", Tuple.Create(true, "(3) Library LU", "TEStandard", "Split when you acquire the life upgrade in library", new Func<bool>(() => vars.LULibrary()))},
        {"TeStandard6", Tuple.Create(true, "(4) Mechanical tower LU", "TEStandard", "Split when you acquire the life upgrade in mechanical tower", new Func<bool>(() => vars.LUMechTower()))},
        {"TeStandard7", Tuple.Create(true, "(5) Garden LU", "TEStandard", "Split when you acquire the life upgrade in garden", new Func<bool>(() => vars.LUGarden()))},
        {"TeStandard8", Tuple.Create(true, "(6) Waterworks LU", "TEStandard", "Split when you acquire the life upgrade in waterworks", new Func<bool>(() => vars.LUWaterworks()))},
        {"TeStandard9", Tuple.Create(true, "(7) Sacrificial altar LU", "TEStandard", "Split when you acquire the life upgrade in sacrificial altar", new Func<bool>(() => vars.LUShahdee()))},
        {"TeStandard10", Tuple.Create(true, "(8) Southern passage LU", "TEStandard", "Split when you acquire the life upgrade in southern passage", new Func<bool>(() => vars.LU019()))},
        {"TeStandard11", Tuple.Create(true, "(9) Central hall LU", "TEStandard", "Split when you acquire the life upgrade in central hall", new Func<bool>(() => vars.LUCentralHall()))},
        {"TeStandard12", Tuple.Create(true, "Water sword", "TEStandard", "Split when you get the water sword", new Func<bool>(() => vars.WaterSword()))},
        {"TeStandard13", Tuple.Create(true, "Dahaka", "TEStandard", "Split when you defeat Dahaka", new Func<bool>(() => vars.Dahaka()))},

        {"TeZipless0", Tuple.Create(true, "Boat", "TEZipless", "Split when the boat ending cutscene starts playing", new Func<bool>(() => vars.boat()))},
        {"TeZipless1", Tuple.Create(true, "Raven man", "TEZipless", "Split on the cutscene where you're introduced to a raven master", new Func<bool>(() => vars.ravenMan()))},
        {"TeZipless2", Tuple.Create(false, "Time portal", "TEZipless", "Split when you go through the first time portal", new Func<bool>(() => vars.firstPortal()))},
        {"TeZipless3", Tuple.Create(true, "(1) Central hall LU", "TEZipless", "Split when you acquire the life upgrade in central hall", new Func<bool>(() => vars.LUCentralHall()))},
        {"TeZipless4", Tuple.Create(true, "(2) Waterworks LU", "TEZipless", "Split when you acquire the life upgrade in waterworks", new Func<bool>(() => vars.LUWaterworks()))},
        {"TeZipless5", Tuple.Create(true, "(3) Garden LU", "TEZipless", "Split when you acquire the life upgrade in garden", new Func<bool>(() => vars.LUGarden()))},
        {"TeZipless6", Tuple.Create(true, "(4) Fortress entrance LU", "TEZipless", "Split when you acquire the life upgrade in fortress entrance", new Func<bool>(() => vars.LUFortress()))},
        {"TeZipless7", Tuple.Create(true, "Foundry (59)", "TEZipless", "Split when you acquire storygate 59", new Func<bool>(() => vars.rng59()))},
        {"TeZipless8", Tuple.Create(true, "(5) Prison LU", "TEZipless", "Split when you acquire the life upgrade in prison", new Func<bool>(() => vars.LUPrison()))},
        {"TeZipless9", Tuple.Create(true, "(6) Library LU", "TEZipless", "Split when you acquire the life upgrade in library", new Func<bool>(() => vars.LULibrary()))},
        {"TeZipless10", Tuple.Create(false, "Light sword", "TEZipless", "Split when you pick up the light sword in mystic caves", new Func<bool>(() => vars.banana()))},
        {"TeZipless11", Tuple.Create(true, "Mechanical tower (63)", "TEZipless", "Split when you acquire storygate 63", new Func<bool>(() => vars.rng63()))},
        {"TeZipless12", Tuple.Create(true, "(7) Mechanical tower LU", "TEZipless", "Split when you acquire the life upgrade in mechanical tower", new Func<bool>(() => vars.LUMechTower()))},
        {"TeZipless13", Tuple.Create(true, "(8) Southern passage LU", "TEZipless", "Split when you acquire the life upgrade in southern passage", new Func<bool>(() => vars.LU019()))},
        {"TeZipless14", Tuple.Create(true, "(9) Sacrificial altar LU", "TEZipless", "Split when you acquire the life upgrade in sacrificial altar", new Func<bool>(() => vars.LUShahdee()))},
        {"TeZipless15", Tuple.Create(true, "Water sword", "TEZipless", "Split when you get the water sword", new Func<bool>(() => vars.WaterSword()))},
        {"TeZipless16", Tuple.Create(true, "Dahaka", "TEZipless", "Split when you defeat Dahaka", new Func<bool>(() => vars.Dahaka()))},

        {"AnyNmg0", Tuple.Create(true, "Boat", "AnyNMG", "Split when the boat ending cutscene starts playing", new Func<bool>(() => vars.boat()))},
        {"AnyNmg1", Tuple.Create(true, "Spider sword", "AnyNMG", "Split on the cutscene where you get the spider sword", new Func<bool>(() => vars.spiderSword()))},
        {"AnyNmg2", Tuple.Create(false, "Raven man", "AnyNMG", "Split on the cutscene where you're introduced to a raven master", new Func<bool>(() => vars.ravenMan()))},
        {"AnyNmg3", Tuple.Create(false, "Time portal", "AnyNMG", "Split when you go through the first time portal", new Func<bool>(() => vars.firstPortal()))},
        {"AnyNmg4", Tuple.Create(true, "Soutern passage (chasing Shahdee)", "AnyNMG", "Split when you come to southern passage past", new Func<bool>(() => vars.chasingShahdee()))},
        {"AnyNmg5", Tuple.Create(true, "Shahdee (a damsel in distress)", "AnyNMG", "Split when you kill Shahdee", new Func<bool>(() => vars.shahdee()))},
        {"AnyNmg_spPortalEnter", Tuple.Create(false, "Enter Southern Passage Portal", "AnyNMG", "Split when you enter the portal in Southern Passage", new Func<bool>(() => vars.spPortalEnter()))},
        {"AnyNmg_spPortalExit", Tuple.Create(false, "Exit Southern Passage Portal", "AnyNMG", "Split when you exit the portal in Southern Passage", new Func<bool>(() => vars.spPortalExit()))},
        {"AnyNmg6", Tuple.Create(true, "The Dahaka", "AnyNMG", "Split on the cutscene before the first Dahaka chase (southern passage present)", new Func<bool>(() => vars.princeStare()))},
        {"AnyNmg7", Tuple.Create(true, "Serpent sword", "AnyNMG", "Split on the cutscene where you get the serpent sword (hourglass chamber)", new Func<bool>(() => vars.serpentSword()))},
        {"AnyNmg8", Tuple.Create(true, "Garden hall", "AnyNMG", "Split when you come to garden hall", new Func<bool>(() => vars.gardenHall()))},
        {"AnyNmg9", Tuple.Create(true, "Waterworks", "AnyNMG", "Split when you come to garden waterworks", new Func<bool>(() => vars.waterworks()))},
        {"AnyNmg10", Tuple.Create(true, "Lion sword", "AnyNMG", "Split on the cutscene where you get the lion sword (central hall)", new Func<bool>(() => vars.lionSword()))},
        {"AnyNmg11", Tuple.Create(true, "Mechanical tower", "AnyNMG", "Split when you clilmb up into the mechanical tower", new Func<bool>(() => vars.mechTower()))},
        {"AnyNmg12", Tuple.Create(false, "Mechanical tower v2 (elevator cutscene)", "AnyNMG", "Split on the cutscene where you jump down on the elevator at the start of mech tower", new Func<bool>(() => vars.mechElevator()))},
        {"AnyNmg_mpPortalEnter", Tuple.Create(false, "Enter Mechanical Pit Portal", "AnyNMG", "Split when you enter the portal in Mechanical Pit", new Func<bool>(() => vars.mpPortalEnter()))},
        {"AnyNmg13", Tuple.Create(true, "Mechanical Pit Portal", "AnyNMG", "Split when you go through the time portal in mechanical pit", new Func<bool>(() => vars.mechPortal()))},
        {"AnyNmg_mpPortalExit", Tuple.Create(false, "Exit Mechanical Pit Portal", "AnyNMG", "Split when you exit the portal in Mechanical Pit", new Func<bool>(() => vars.mpPortalExit()))},
        {"AnyNmg14", Tuple.Create(true, "Activation room in ruin", "AnyNMG", "Split when you come to the mech tower activation room in the present", new Func<bool>(() => vars.activationRuin()))},
        {"AnyNmg_arPortalEnter", Tuple.Create(false, "Enter Activation room Portal", "AnyNMG", "Split when you enter the portal in Activation room", new Func<bool>(() => vars.arPortalEnter()))},
        {"AnyNmg_arPortalExit", Tuple.Create(false, "Exit Activation room Portal", "AnyNMG", "Split when you exit the portal in Activation room", new Func<bool>(() => vars.arPortalExit()))},
        {"AnyNmg15", Tuple.Create(true, "Activation room restored", "AnyNMG", "Split when you come to the mech tower activation room in the past", new Func<bool>(() => vars.activationRestore()))},
        {"AnyNmg16", Tuple.Create(true, "The death of a sand wraith (central hall)", "AnyNMG", "Split in centrall hall next to the fountain after you've activated both towers", new Func<bool>(() => vars.sandWraithDeathV1()))},
        {"AnyNmg17", Tuple.Create(false, "The death of a sand wraith v2 (central hall)", "AnyNMG", "This is slightly different version of the previous split. It's located deeper into the corridor so you can't hit it early when jumping down", new Func<bool>(() => vars.sandWraithDeathV2()))},
        {"AnyNmg18", Tuple.Create(true, "Death of the empress", "AnyNMG", "Split when you kill Kaileena in the throne room (34->38)", new Func<bool>(() => vars.kaileenaFirst()))},
        {"AnyNmg19", Tuple.Create(true, "Exit the tomb", "AnyNMG", "Split when you leave the tomb", new Func<bool>(() => vars.exitTomb()))},
        {"AnyNmg_prPortalEnter", Tuple.Create(false, "Enter Prison Portal", "AnyNMG", "Split when you enter the portal in Prison", new Func<bool>(() => vars.prPortalEnter()))},
        {"AnyNmg_prPortalExit", Tuple.Create(false, "Exit Prison Portal", "AnyNMG", "Split when you exit the portal in Prison", new Func<bool>(() => vars.prPortalExit()))},
        {"AnyNmg20", Tuple.Create(true, "Scorpion sword", "AnyNMG", "Split when you get the scorpion sword", new Func<bool>(() => vars.scorpionSword()))},
        {"AnyNmg21", Tuple.Create(false, "Library", "AnyNMG", "Split on the library opening cutscene", new Func<bool>(() => vars.libraryV1()))},
        {"AnyNmg22", Tuple.Create(true, "Library v2", "AnyNMG", "Split when you move into the library (after the opening cutscene)", new Func<bool>(() => vars.libraryV2()))},
        {"AnyNmg23", Tuple.Create(true, "Hourglass revisited", "AnyNMG", "Split when you come back to the hourglass chamber after you've killed Kaileena", new Func<bool>(() => vars.hourglassRevisit()))},
        {"AnyNmg_trPortalEnter", Tuple.Create(false, "Enter Throne Room Portal", "AnyNMG", "Split when you enter the cutscene after breaking Throne Room wall", new Func<bool>(() => vars.trPortalEnter()))},
        {"AnyNmg_trPortalExit", Tuple.Create(false, "Exit Throne Room Portal", "AnyNMG", "Split when you exit the portal in Throne Room", new Func<bool>(() => vars.trPortalExit()))},
        {"AnyNmg24", Tuple.Create(true, "The mask of the wraith", "AnyNMG", "Split when you get to the mask", new Func<bool>(() => vars.maskOn()))},
        {"AnyNmg_scPortalEnter", Tuple.Create(false, "Enter Sacred Caves Portal", "AnyNMG", "Split when you enter the portal in Sacred Caves", new Func<bool>(() => vars.scPortalEnter()))},
        {"AnyNmg_scPortalExit", Tuple.Create(false, "Exit Sacred Caves Portal", "AnyNMG", "Split when you exit the portal in Sacred Caves", new Func<bool>(() => vars.scPortalExit()))},
        {"AnyNmg25", Tuple.Create(true, "Sand griffin", "AnyNMG", "Split when you kill the griffin", new Func<bool>(() => vars.griffinV1()))},
        {"AnyNmg26", Tuple.Create(false, "Sand griffin v2", "AnyNMG", "Split when you jump to the platform after you've killed the griffin", new Func<bool>(() => vars.griffinV2()))},
        {"AnyNmg_ugPortalEnter", Tuple.Create(false, "Enter Upper Garden Portal", "AnyNMG", "Split when you enter the portal in Upper Garden", new Func<bool>(() => vars.ugPortalEnter()))},
        {"AnyNmg_ugPortalExit", Tuple.Create(false, "Exit Upper Garden Portal", "AnyNMG", "Split when you exit the portal in Upper Garden", new Func<bool>(() => vars.ugPortalExit()))},
        {"AnyNmg27", Tuple.Create(true, "Mirrored fates", "AnyNMG", "Split on the sacrificial altar cutscene (sand wraith pov)", new Func<bool>(() => vars.mirroredFates()))},
        {"AnyNmg28", Tuple.Create(true, "A favor unknown", "AnyNMG", "Split on the cutscene where the sand wraith saves the prince by throwing an axe (sand wraith pov)", new Func<bool>(() => vars.favorUnknown()))},
        {"AnyNmg29", Tuple.Create(true, "Library revisited", "AnyNMG", "Split when you enter the library", new Func<bool>(() => vars.libraryRevisit()))},
        {"AnyNmg30", Tuple.Create(true, "Light sword", "AnyNMG", "Split when you pick up the light sword in mystic caves", new Func<bool>(() => vars.banana()))},
        {"AnyNmg31", Tuple.Create(true, "The death of a prince", "AnyNMG", "Split on the cutscene where you take the mask off", new Func<bool>(() => vars.maskOff()))},
        {"AnyNmg32", Tuple.Create(true, "Kaileena", "AnyNMG", "Split when you kill Kaileena in sacred caves", new Func<bool>(() => vars.kaileena()))},

        {"TeNmg0", Tuple.Create(true, "Boat", "TENMG", "Split when the boat ending cutscene starts playing", new Func<bool>(() => vars.boat()))},
        {"TeNmg1", Tuple.Create(true, "Spider sword", "TENMG", "Split on the cutscene where you get the spider sword", new Func<bool>(() => vars.spiderSword()))},
        {"TeNmg2", Tuple.Create(false, "Raven man", "TENMG", "Split on the cutscene where you're introduced to a raven master", new Func<bool>(() => vars.ravenMan()))},
        {"TeNmg3", Tuple.Create(false, "Time portal", "TENMG", "Split when you go through the first time portal", new Func<bool>(() => vars.firstPortal()))},
        {"TeNmg4", Tuple.Create(true, "Soutern passage (chasing Shahdee)", "TENMG", "Split when you come to southern passage past", new Func<bool>(() => vars.chasingShahdee()))},
        {"TeNmg5", Tuple.Create(true, "(1) Southern passage LU", "TENMG", "Split when you acquire the life upgrade in southern passage", new Func<bool>(() => vars.LU019()))},
        {"TeNmg6", Tuple.Create(true, "Shahdee (a damsel in distress)", "TENMG", "Split when you kill Shahdee", new Func<bool>(() => vars.shahdee()))},
        {"TeNmg7", Tuple.Create(true, "(2) Sacrificial alter LU", "TENMG", "Split when you acquire the life upgrade in sacrificial altar", new Func<bool>(() => vars.LUShahdee()))},
        {"TeNmg_spPortalEnter", Tuple.Create(false, "Enter Southern Passage Portal", "TENMG", "Split when you enter the portal in Southern Passage", new Func<bool>(() => vars.spPortalEnter()))},
        {"TeNmg_spPortalExit", Tuple.Create(false, "Exit Southern Passage Portal", "TENMG", "Split when you exit the portal in Southern Passage", new Func<bool>(() => vars.spPortalExit()))},
        {"TeNmg8", Tuple.Create(true, "The Dahaka", "TENMG", "Split on the cutscene before the first Dahaka chase (southern passage present)", new Func<bool>(() => vars.princeStare()))},
        {"TeNmg9", Tuple.Create(true, "(3) Fortress entrance LU", "TENMG", "Split when you acquire the life upgrade in fortress entrance", new Func<bool>(() => vars.LUFortress()))},
        {"TeNmg10", Tuple.Create(true, "Serpent sword", "TENMG", "Split on the cutscene where you get the serpent sword (hourglass chamber)", new Func<bool>(() => vars.serpentSword()))},
        {"TeNmg11", Tuple.Create(true, "Garden hall", "TENMG", "Split when you come to garden hall", new Func<bool>(() => vars.gardenHall()))},
        {"TeNmg12", Tuple.Create(false, "Waterworks", "TENMG", "Split when you come to garden waterworks", new Func<bool>(() => vars.waterworks()))},
        {"TeNmg13", Tuple.Create(true, "(4) Waterworks LU", "TENMG", "Split when you acquire the life upgrade in waterworks", new Func<bool>(() => vars.LUWaterworks()))},
        {"TeNmg15", Tuple.Create(true, "(5) Garden LU", "TENMG", "Split when you acquire the life upgrade in garden", new Func<bool>(() => vars.LUGarden()))},
        {"TeNmg16", Tuple.Create(true, "(6) Central hall LU", "TENMG", "Split when you acquire the life upgrade in central hall", new Func<bool>(() => vars.LUCentralHall()))},
        {"TeNmg17", Tuple.Create(false, "Lion sword", "TENMG", "Split on the cutscene where you get the lion sword (central hall)", new Func<bool>(() => vars.lionSword()))},
        {"TeNmg18", Tuple.Create(true, "Mechanical tower", "TENMG", "Split when you clilmb up into the mechanical tower", new Func<bool>(() => vars.mechTower()))},
        {"TeNmg19", Tuple.Create(false, "Mechanical tower v2 (elevator cutscene)", "TENMG", "Split on the cutscene where you jump down on the elevator at the start of mech tower", new Func<bool>(() => vars.mechElevator()))},
        {"TeNmg_mpPortalEnter", Tuple.Create(false, "Enter Mechanical Pit Portal", "TENMG", "Split when you enter the portal in Mechanical Pit", new Func<bool>(() => vars.mpPortalEnter()))},
        {"TeNmg20", Tuple.Create(true, "Mechanical Pit Portal", "TENMG", "Split when you go through the time portal in mechanical pit", new Func<bool>(() => vars.mechPortal()))},
        {"TeNmg_mpPortalExit", Tuple.Create(false, "Exit Mechanical Pit Portal", "TENMG", "Split when you exit the portal in Mechanical Pit", new Func<bool>(() => vars.mpPortalExit()))},
        {"TeNmg21", Tuple.Create(true, "Activation room in ruin", "TENMG", "Split when you come to the mech tower activation room in the present", new Func<bool>(() => vars.activationRuin()))},
        {"TeNmg_arPortalEnter", Tuple.Create(false, "Enter Activation room Portal", "TENMG", "Split when you enter the portal in Activation room", new Func<bool>(() => vars.arPortalEnter()))},
        {"TeNmg_arPortalExit", Tuple.Create(false, "Exit Activation room Portal", "TENMG", "Split when you exit the portal in Activation room", new Func<bool>(() => vars.arPortalExit()))},
        {"TeNmg22", Tuple.Create(false, "Activation room restored", "TENMG", "Split when you come to the mech tower activation room in the past", new Func<bool>(() => vars.activationRestore()))},
        {"TeNmg23", Tuple.Create(true, "(7) Mechanical tower LU", "TENMG", "Split when you acquire the life upgrade in mechanical tower", new Func<bool>(() => vars.LUMechTower()))},
        {"TeNmg24", Tuple.Create(true, "The death of a sand wraith (central hall)", "TENMG", "Split in centrall hall next to the fountain after you've activated both towers", new Func<bool>(() => vars.sandWraithDeathV1()))},
        {"TeNmg25", Tuple.Create(false, "The death of a sand wraith v2 (central hall)", "TENMG", "This is slightly different version of the previous split. It's located deeper into the corridor so you can't hit it early when jumping down", new Func<bool>(() => vars.sandWraithDeathV2()))},
        {"TeNmg26", Tuple.Create(true, "Death of the empress", "TENMG", "Split when you kill Kaileena in the throne room (34->38)", new Func<bool>(() => vars.kaileenaFirst()))},
        {"TeNmg27", Tuple.Create(true, "Exit the tomb", "TENMG", "Split when you leave the tomb", new Func<bool>(() => vars.exitTomb()))},
        {"TeNmg_prPortalEnter", Tuple.Create(false, "Enter Prison Portal", "TENMG", "Split when you enter the portal in Prison", new Func<bool>(() => vars.prPortalEnter()))},
        {"TeNmg_prPortalExit", Tuple.Create(false, "Exit Prison Portal", "TENMG", "Split when you exit the portal in Prison", new Func<bool>(() => vars.prPortalExit()))},
        {"TeNmg28", Tuple.Create(true, "Scorpion sword", "TENMG", "Split when you get the scorpion sword", new Func<bool>(() => vars.scorpionSword()))},
        {"TeNmg29", Tuple.Create(true, "(8) Prison LU", "TENMG", "Split when you acquire the life upgrade in prison", new Func<bool>(() => vars.LUPrison()))},
        {"TeNmg30", Tuple.Create(false, "Library", "TENMG", "Split on the library opening cutscene", new Func<bool>(() => vars.libraryV1()))},
        {"TeNmg31", Tuple.Create(false, "Library v2", "TENMG", "Split when you move into the library (after the opening cutscene)", new Func<bool>(() => vars.libraryV2()))},
        {"TeNmg32", Tuple.Create(true, "(9) Library LU", "TENMG", "Split when you acquire the life upgrade in library", new Func<bool>(() => vars.LULibrary()))},
        {"TeNmg33", Tuple.Create(false, "Hourglass revisited", "TENMG", "Split when you come back to the hourglass chamber after you've killed Kaileena", new Func<bool>(() => vars.hourglassRevisit()))},
        {"TeNmg34", Tuple.Create(true, "Water sword", "TENMG", "Split when you get the water sword", new Func<bool>(() => vars.WaterSword()))},
        {"TeNmg_trPortalEnter", Tuple.Create(false, "Enter Throne Room Portal", "TENMG", "Split when you enter the cutscene after breaking Throne Room wall", new Func<bool>(() => vars.trPortalEnter()))},
        {"TeNmg_trPortalExit", Tuple.Create(false, "Exit Throne Room Portal", "TENMG", "Split when you exit the portal in Throne Room", new Func<bool>(() => vars.trPortalExit()))},
        {"TeNmg35", Tuple.Create(true, "The mask of the wraith", "TENMG", "Split when you get to the mask", new Func<bool>(() => vars.maskOn()))},
        {"TeNmg_scPortalEnter", Tuple.Create(false, "Enter Sacred Caves Portal", "TENMG", "Split when you enter the portal in Sacred Caves", new Func<bool>(() => vars.scPortalEnter()))},
        {"TeNmg_scPortalExit", Tuple.Create(false, "Exit Sacred Caves Portal", "TENMG", "Split when you exit the portal in Sacred Caves", new Func<bool>(() => vars.scPortalExit()))},
        {"TeNmg36", Tuple.Create(true, "Sand griffin", "TENMG", "Split when you kill the griffin", new Func<bool>(() => vars.griffinV1()))},
        {"TeNmg37", Tuple.Create(false, "Sand griffin v2", "TENMG", "Split when you jump to the platform after you've killed the griffin", new Func<bool>(() => vars.griffinV2()))},
        {"TeNmg_ugPortalEnter", Tuple.Create(false, "Enter Upper Garden Portal", "TENMG", "Split when you enter the portal in Upper Garden", new Func<bool>(() => vars.ugPortalEnter()))},
        {"TeNmg_ugPortalExit", Tuple.Create(false, "Exit Upper Garden Portal", "TENMG", "Split when you exit the portal in Upper Garden", new Func<bool>(() => vars.ugPortalExit()))},
        {"TeNmg38", Tuple.Create(true, "Mirrored fates", "TENMG", "Split on the sacrificial altar cutscene (sand wraith pov)", new Func<bool>(() => vars.mirroredFates()))},
        {"TeNmg39", Tuple.Create(true, "A favor unknown", "TENMG", "Split on the cutscene where the sand wraith saves the prince by throwing an axe (sand wraith pov)", new Func<bool>(() => vars.favorUnknown()))},
        {"TeNmg40", Tuple.Create(true, "Library revisited", "TENMG", "Split when you enter the library", new Func<bool>(() => vars.libraryRevisit()))},
        {"TeNmg41", Tuple.Create(true, "Light sword", "TENMG", "Split when you pick up the light sword in mystic caves", new Func<bool>(() => vars.banana()))},
        {"TeNmg42", Tuple.Create(true, "The death of a prince", "TENMG", "Split on the cutscene where you take the mask off", new Func<bool>(() => vars.maskOff()))},
        {"TeNmg43", Tuple.Create(true, "Dahaka", "TENMG", "Split when you defeat Dahaka", new Func<bool>(() => vars.Dahaka()))},
    };

    foreach (var splitType in vars.splitTypes) {
        settings.Add(splitType.Key, false, splitType.Value);
    }

    foreach (var data in vars.splitsData) {
        settings.Add(data.Key, data.Value.Item1, data.Value.Item2, data.Value.Item3);
        settings.SetToolTip(data.Key, data.Value.Item4);
    }

    settings.Add("storyViewer", false, "Enable viewing the story gate memory value");

    settings.Add("tracker", false, "Enable tracker for Completionist Categories");
    settings.Add("chests", false, "Artwork Chests", "tracker");
    settings.Add("weapons", false, "Weapons", "tracker");

    vars.SetTextComponent = (Action<string, string>)((id, text) =>
    {
        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
        if (textSetting == null)
        {
        var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
        var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
        timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));

        textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
        textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
        }

        if (textSetting != null)
        textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
    });

    vars.RemoveTextComponent = (Action<string>)((id) => {
        int indexToRemove = -1;
        foreach (dynamic component in timer.Layout.Components) {
            if (component.GetType().Name == "TextComponent" && System.Text.RegularExpressions.Regex.IsMatch(component.Settings.Text1, id)) {
                indexToRemove = timer.Layout.Components.ToList().IndexOf(component);
            }
        }
        if (indexToRemove != -1) {
            timer.Layout.LayoutComponents.RemoveAt(indexToRemove);
        }
    });

    vars.CompletedSplits = new HashSet<string>();

    if (timer.CurrentTimingMethod != TimingMethod.RealTime) {
        DialogResult mbox = MessageBox.Show(timer.Form,
        "This game uses only real time as the timing method.\nWould you like to switch to Real Time?",
        "LiveSplit | Prince of Persia: Warrior Within",
        MessageBoxButtons.YesNo);

        if (mbox == DialogResult.Yes) {
            timer.CurrentTimingMethod = TimingMethod.RealTime;
        }
    }
}

init
{
    // Hamming Weight algorithm
    vars.countBits = (Func<ulong, int>)((x) => {
        x = x - ((x >> 1) & 0x5555555555555555UL);
        x = (x & 0x3333333333333333UL) + ((x >> 2) & 0x3333333333333333UL);
        x = (x + (x >> 4)) & 0x0F0F0F0F0F0F0F0FUL;
        x = x + (x >> 8);
        x = x + (x >> 16);
        x = x + (x >> 32);
        return (int)(x & 0x7F);
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

    vars.inXRange = (Func<float, float, bool>)((xMin, xMax) => { return current.xPos >= xMin && current.xPos <= xMax; });
    vars.inYRange = (Func<float, float, bool>)((yMin, yMax) => { return current.yPos >= yMin && current.yPos <= yMax; });
    vars.inZRange = (Func<float, float, bool>)((zMin, zMax) => { return current.zPos >= zMin && current.zPos <= zMax; });
    vars.splitByXYZ = (Func<float, float, float, float, float, float, bool>)((xMin, xMax, yMin, yMax, zMin, zMax) => {
        return
            vars.inXRange(xMin, xMax) &&
            vars.inYRange(yMin, yMax) &&
            vars.inZRange(zMin, zMax);
    });

    vars.setTrackerTextComponent = (Action<ulong, ulong, string>)((bits, expectedBits, description) => {
        int count = vars.countBits(bits & expectedBits);
        int maxCount = vars.countBits(expectedBits);
        vars.SetTextComponent(description, count.ToString() + " / " + maxCount.ToString());
    });

    vars.removeTrackerTextComponents = (Action<List<string>>)((componentsToRemove) => {
        foreach (string component in componentsToRemove) {
            vars.RemoveTextComponent(component);
        }
    });

    // List of Splits
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

    vars.CheckSplit = (Func<string, bool>)(key => {
        return (vars.CompletedSplits.Add(key) && settings[key]);
    });
}

start
{
    // Start the timer when a new game is started (after the opening cutscene has ended)
    return (current.map == 1292342859 && vars.oldCutscene == 1 && current.cutscene == 2);
}

onStart
{
    // Refresh all splits when we start the run, none are yet completed
    vars.CompletedSplits.Clear();
}

reset
{
    // Reset the timer when a new game is started (when the first area of the boat loads)
    return (old.map == 234881388 && current.map == 1292342859);
}

exit
{
    vars.removeTrackerTextComponents(new List<string> { "Story Gate", "Chests", "Main Weapons", "Swords", "Axes", "Maces", "Daggers", "Secret Weapons" });
}

update
{
    // This is a work-around for the "old" state not working as expected in the init block
    vars.oldCutscene = old.cutscene;
    vars.oldState = old.state;
    vars.oldSecondary = old.secondaryWeapon;
    vars.oldStory = old.storyValue;
    vars.oldMap = old.map;

    vars.oldX = old.xPos;
    vars.oldY = old.yPos;
    vars.oldZ = old.zPos;

    List<string> componentsToRemove = new List<string>();

    if (settings["storyViewer"]) {
        vars.SetTextComponent("Story Gate", current.storyValue.ToString());
    }
    else componentsToRemove.Add("Story Gate");

    if (settings["chests"]) {
        vars.setTrackerTextComponent(current.chestBits, 0x0003FFFFFFFFFFFF, "Chests");
    }
    else componentsToRemove.Add("Chests");

    if (settings["weapons"]) {
        vars.setTrackerTextComponent(current.weaponBits, 0x37C0000000000000, "Main Weapons");
        vars.setTrackerTextComponent(current.weaponBits, 0x0005FFFF00000000, "Swords");
        vars.setTrackerTextComponent(current.weaponBits, 0x0002000000003FFE, "Axes");
        vars.setTrackerTextComponent(current.weaponBits, 0x000000000FF00000, "Maces");
        vars.setTrackerTextComponent(current.weaponBits, 0x00000000000FC000, "Daggers");
        vars.setTrackerTextComponent(current.weaponBits, 0x00080000F0000000, "Secret Weapons");
    }
    else componentsToRemove.AddRange(new List<string> { "Main Weapons", "Swords", "Axes", "Maces", "Daggers", "Secret Weapons" });

    vars.removeTrackerTextComponents(componentsToRemove);
}

split
{
    foreach (var data in vars.splitsData) {
        if (data.Value.Item5() && vars.CheckSplit(data.Key)) {
            print(data.Key);
            return true;
        }
    }
}
