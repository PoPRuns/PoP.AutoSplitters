state("POP2")
{
    //this variable is 0 during gameplay, 1 in cutscenes, 2 when a cutscene ends
    int cutscene        : 0x0096602C, 0x8, 0x28, 0xA8, 0x3E0;

    //Story counter/gate/value
    int storyValue      : 0x523578;

    //A value that changes reliably depending on which weapon you pick up
    int secondaryWeapon : 0x0053F8F0, 0x4, 0x164, 0xC, 0x364;

    //The address used for most bosses' health
    int bossHealth      : 0x0090C418, 0x18, 0x4, 0x48, 0x198;

    //The Prince's coords
    float xPos          : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x30;
    float yPos          : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x34;
    float zPos          : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x38;

    //currently loaded area id (changes with every load trigger)
    int map             : 0x523594;

    //state of the prince (11 is drinking)
    int state           : 0x90C414, 0x18, 0x4, 0x48, 0x3F8;
}

startup
{
    settings.Add("Any", true, "Any% (Standard) and Any% (Zipless) splits");
    settings.Add("TeStandard", true, "True Ending (Standard) splits");
    settings.Add("TeZipless", true, "True Ending (Zipless) splits");
    settings.Add("AnyNmg", true, "Any% (No Major Glitches) splits");
    settings.Add("TeNmg", true, "True Ending (No Major Glitches) splits");

    string currentCategory = "Any";
    int i = 0;

    //function for easier settings management
    Action<bool, string, string> AddSetting = (defaultCheck, name, tooltip) => {
        settings.Add(currentCategory + i, defaultCheck, name, currentCategory);
        settings.SetToolTip(currentCategory + i, tooltip);
        i++;
    };

    AddSetting(true, "Boat", "Split when the boat ending cutscene starts playing");
    AddSetting(true, "Raven man", "Split on the cutscene where you're introduced to a raven master");
    AddSetting(true, "Time portal", "Split when you go through the first time portal");
    AddSetting(true, "Foundy fountain", "Split when you drink from the foundry fountain while having 58/59 storygate");
    AddSetting(true, "Scorpion sword", "Split when you get the scorpion sword");
    AddSetting(false, "Light sword", "Split when you pick up the light sword in mystic caves");
    AddSetting(true, "Mechanical tower (63)", "Split when you acquire storygate 63");
    AddSetting(true, "Second portal", "Split when you go through the time portal in the throne room");
    AddSetting(true, "Kaileena", "Split when you kill Kaileena in sacred caves");

    currentCategory = "TeStandard";
    i = 0;
    AddSetting(true, "Boat", "Split when the boat ending cutscene starts playing");
    AddSetting(true, "Raven man", "Split on the cutscene where you're introduced to a raven master");
    AddSetting(true, "Time portal", "Split when you go through the first time portal");
    AddSetting(true, "(1) fortress entrance LU", "Split when you acquire the life upgrade in fortress entrance");
    AddSetting(true, "(2) Prison LU", "Split when you acquire the life upgrade in prison");
    AddSetting(true, "(3) Library LU", "Split when you acquire the life upgrade in library");
    AddSetting(true, "(4) Mechanical tower LU", "Split when you acquire the life upgrade in mechanical tower");
    AddSetting(true, "(5) Garden LU", "Split when you acquire the life upgrade in garden");
    AddSetting(true, "(6) Waterworks LU", "Split when you acquire the life upgrade in waterworks");
    AddSetting(true, "(7) Sacrificial altar LU", "Split when you acquire the life upgrade in sacrificial altar");
    AddSetting(true, "(8) Southern passage LU", "Split when you acquire the life upgrade in southern passage");
    AddSetting(true, "(9) Central hall LU", "Split when you acquire the life upgrade in central hall");
    AddSetting(true, "Water sword", "Split when you get the water sword");
    AddSetting(true, "Dahaka", "Split when you defeat Dahaka");


    currentCategory = "TeZipless";
    i = 0;
    AddSetting(true, "Boat", "Split when the boat ending cutscene starts playing");
    AddSetting(true, "Raven man", "Split on the cutscene where you're introduced to a raven master");
    AddSetting(false, "Time portal", "Split when you go through the first time portal");
    AddSetting(true, "(1) Central hall LU", "Split when you acquire the life upgrade in central hall");
    AddSetting(true, "(2) Waterworks LU", "Split when you acquire the life upgrade in waterworks");
    AddSetting(true, "(3) Garden LU", "Split when you acquire the life upgrade in garden");
    AddSetting(true, "(4) Fortress entrance LU", "Split when you acquire the life upgrade in fortress entrance");
    AddSetting(true, "Foundry (59)", "Split when you acquire storygate 59");
    AddSetting(true, "(5) Prison LU", "Split when you acquire the life upgrade in prison");
    AddSetting(true, "(6) Library LU", "Split when you acquire the life upgrade in library");
    AddSetting(false, "Light sword", "Split when you pick up the light sword in mystic caves");
    AddSetting(true, "Mechanical tower (63)", "Split when you acquire storygate 63");
    AddSetting(true, "(7) Mechanical tower LU", "Split when you acquire the life upgrade in mechanical tower");
    AddSetting(true, "(8) Southern passage LU", "Split when you acquire the life upgrade in southern passage");
    AddSetting(true, "(9) Sacrificial altar LU", "Split when you acquire the life upgrade in sacrificial altar");
    AddSetting(true, "Water sword", "Split when you get the water sword");
    AddSetting(true, "Dahaka", "Split when you defeat Dahaka");

    i = 0;
    int k = 0;

    //since Any%(NMG) and TE(NMG) follow the same route, we can process them at the same time to skip repeating alot of the same code
    Action<bool, bool, string, string, bool> AddNmgSettings = (anycheck, techeck, name, tooltip, teonly) => {
        //just have to add extra checks for TE only splits
        if (!teonly) {
            settings.Add("AnyNmg" + i, anycheck, name, "AnyNmg");
            settings.SetToolTip("AnyNmg" + i, tooltip);
            i++;
        }
        settings.Add("TeNmg" + k, techeck, name, "TeNmg");
        settings.SetToolTip("TeNmg" + k, tooltip);
        k++;
    };
    AddNmgSettings(true, true, "Boat", "Split when the boat ending cutscene starts playing", false);
    AddNmgSettings(true, true, "Spider sword", "Split on the cutscene where you get the spider sword", false);
    AddNmgSettings(false, false, "Raven man", "Split on the cutscene where you're introduced to a raven master", false);
    AddNmgSettings(false, false, "Time portal", "Split when you go through the first time portal", false);
    AddNmgSettings(true, true, "Soutern passage (chasing Shahdee)", "Split when you come to southern passage past", false);
    AddNmgSettings(false, true, "(1) Southern passage LU", "Split when you acquire the life upgrade in southern passage", true);
    AddNmgSettings(true, true, "Shahdee (a damsel in distress)", "Split when you kill Shahdee", false);
    AddNmgSettings(false, true, "(2) Sacrificial alter LU", "Split when you acquire the life upgrade in sacrificial altar", true);
    AddNmgSettings(true, true, "The Dahaka", "Split on the cutscene before the first Dahaka chase (southern passage present)", false);
    AddNmgSettings(false, true, "(3) Fortress entrance LU", "Split when you acquire the life upgrade in fortress entrance", true);
    AddNmgSettings(true, true, "Serpent sword", "Split on the cutscene where you get the serpent sword (hourglass chamber)", false);
    AddNmgSettings(true, true, "Garden hall", "Split when you come to garden hall", false);
    AddNmgSettings(true, false, "Waterworks", "Split when you come to garden waterworks", false);
    AddNmgSettings(false, true, "(4) Waterworks LU", "Split when you acquire the life upgrade in waterworks", true);
    AddNmgSettings(false, true, "(5) Garden LU", "Split when you acquire the life upgrade in garden", true);
    AddNmgSettings(false, true, "(6) Central hall LU", "Split when you acquire the life upgrade in central hall", true);
    AddNmgSettings(true, false, "Lion sword", "Split on the cutscene where you get the lion sword (central hall)", false);
    AddNmgSettings(true, true, "Mechanical tower", "Split when you clilmb up into the mechanical tower", false);
    AddNmgSettings(false, false, "Mechanical tower v2 (elevator cutscene)", "Split on the cutscene where you jump down on the elevator at the start of mech tower", false);
    AddNmgSettings(true, true, "Ravages of time", "Split when you go through the time portal in mechanical pit", false);
    AddNmgSettings(true, true, "Activation room in ruin", "Split when you come to the mech tower activation room in the present", false);
    AddNmgSettings(true, false, "Activation room restored", "Split when you come to the mech tower activation room in the past", false);
    AddNmgSettings(false, true, "(7) Mechanical tower LU", "Split when you acquire the life upgrade in mechanical tower", true);
    AddNmgSettings(true, true, "The death of a sand wraith (central hall)", "Split in centrall hall next to the fountain after you've activated both towers", false);
    AddNmgSettings(false, false, "The death of a sand wraith v2 (central hall)", "This is slightly different version of the previous split. It's located deeper into the corridor so you can't hit it early when jumping down", false);
    AddNmgSettings(true, true, "Death of the empress", "Split when you kill Kaileena in the throne room (34->38)", false);
    AddNmgSettings(true, true, "Exit the tomb", "Split when you leave the tomb", false);
    AddNmgSettings(true, true, "Scorpion sword", "Split when you get the scorpion sword", false);
    AddNmgSettings(false, true, "(8) Prison LU", "Split when you acquire the life upgrade in prison", true);
    AddNmgSettings(false, false, "Library", "Split on the library opening cutscene", false);
    AddNmgSettings(true, false, "Library v2", "Split when you move into the library (after the opening cutscene)", false);
    AddNmgSettings(false, true, "(9) Library LU", "Split when you acquire the life upgrade in library", true);
    AddNmgSettings(true, false, "Hourglass revisited", "Split when you come back to the hourglass chamber after you've killed Kaileena", false);
    AddNmgSettings(false, true, "Water sword", "Split when you get the water sword", true);
    AddNmgSettings(true, true, "The mask of the wraith", "Split when you get to the mask", false);
    AddNmgSettings(true, true, "Sand griffin", "Split when you kill the griffin", false);
    AddNmgSettings(false, false, "Sand griffin v2", "Split when you jump to the platform after you've killed the griffin", false);
    AddNmgSettings(true, true, "Mirrored fates", "Split on the sacrificial altar cutscene (sand wraith pov)", false);
    AddNmgSettings(true, true, "A favor unknown", "Split on the cutscene where the sand wraith saves the prince by throwing an axe (sand wraith pov)", false);
    AddNmgSettings(true, true, "Library revisited", "Split when you enter the library", false);
    AddNmgSettings(true, true, "Light sword", "Split when you pick up the light sword in mystic caves", false);
    AddNmgSettings(true, true, "The death of a prince", "Split on the cutscene where you take the mask off", false);
    AddNmgSettings(false, true, "Dahaka", "Split when you defeat Dahaka", true);
    settings.Add("AnyNmg" + i, true, "Kaileena", "AnyNmg");
    settings.SetToolTip("AnyNmg" + i, "Split when you kill Kaileena in sacred caves");

    //this var holds the old timer phase
    vars.oldTimerPhase = TimerPhase.NotRunning;
}

start
{
    //start the timer when a new game is started (after the opening cutscene has ended)
    if (current.map == 1292342859 && old.cutscene == 1 && current.cutscene == 2)
        return true;
}

reset
{
    //reset the timer when a new game is started (when the first area of the boat loads)
    if (old.map == 234881388 && current.map == 1292342859)
        return true;
}

update{
    //check if the timer has started (both manually and automatically)
    if (vars.oldTimerPhase == TimerPhase.NotRunning && timer.CurrentPhase == TimerPhase.Running) {
        int i = 0;
        string category;

        //this list is gonna hold all the split functions needed for the run
        vars.splitList = new List<Func<dynamic, dynamic, bool>>{};
        switch(timer.Run.GetExtendedCategoryName()) {
            case "Any% (Standard)":
            case "Any% (Zipless)":
                category = "Any";
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 67109218 && Current.bossHealth == 0 && Old.cutscene == 0 && Current.cutscene == 1; //boat
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 135462572 && Old.cutscene == 0 && Current.cutscene == 1; //raven man
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 285231807 && Old.cutscene == 0 && Current.cutscene == 1; //portal
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.storyValue == 58 || Current.storyValue == 59) && Old.state != 11 && Current.state == 11; //foundry fountain
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.map == 135505359 || Current.map == 135516393 || Current.map == 135483948 || Current.map == 16809649 || Current.map == 135483950) && Current.xPos < -164 && Old.cutscene == 0 && Current.cutscene == 1; //scorpion
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.map == 587202754 || Current.map == 587203393) && Old.secondaryWeapon != 50 && Current.secondaryWeapon == 50; //banana
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Old.storyValue != 63 && Current.storyValue == 63; //63
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.map == -1509855113 || Current.map == 285233488) && Old.cutscene == 0 && Current.cutscene == 1; //second portal
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 989966866 && Current.bossHealth == 0 && Old.cutscene == 0 && Current.cutscene == 1; //kaileena
                        vars.splitList.Add(split);
                }
                break;


            case "True Ending (Standard)":
                category = "TeStandard";
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 67109218 && Current.bossHealth == 0 && Old.cutscene == 0 && Current.cutscene == 1; //boat
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 135462572 && Old.cutscene == 0 && Current.cutscene == 1; //raven man
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 285231807 && Old.cutscene == 0 && Current.cutscene == 1; //portal
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 135501679 && Old.cutscene == 0 && Current.cutscene == 1; //life 1 (fortress entrance)
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.map == 135516393 || Current.map == 135483948 || Current.map ==  16809649) && Current.xPos > -120 && Old.cutscene == 0 && Current.cutscene == 1; //life 2 (prison)
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.map == 67144064 || Current.map == 67144084) && Old.cutscene == 0 && Current.cutscene == 1; //life 3 (library)
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 67145445 && Old.cutscene == 0 && Current.cutscene == 1; //life 4 (mech tower)
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.map == 1006690753 || Current.map == 1006690755) && Old.cutscene == 0 && Current.cutscene == 1; //life 5 (garden)
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.map == 687877046 || Current.map == 687877489) && Current.xPos > 70 && Old.cutscene == 0 && Current.cutscene == 1; //life 6 (waterworks)
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.map == 285225347 || Current.map == 1006717295) && Old.cutscene == 0 && Current.cutscene == 1; //life 7 (sac altar)
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.map == 989860398 || Current.map == 1006711848) && Old.cutscene == 0 && Current.cutscene == 1; //life 8 (southern passage)
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 67144144 && Old.cutscene == 0 && Current.cutscene == 1; //life 9 (main hall)
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.map == 1006704429 || Current.map == 1006704427) && Old.xPos > -98 && Old.cutscene == 0 && Current.cutscene == 1; //water sword
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 989966868 && Current.yPos > 200 && Old.cutscene == 0 && Current.cutscene == 1; //dahaka
                        vars.splitList.Add(split);
                }
                break;


            case "True Ending (Zipless)":
                category = "TeZipless";
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 67109218 && Current.bossHealth == 0 && Old.cutscene == 0 && Current.cutscene == 1; //boat
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 135462572 && Old.cutscene == 0 && Current.cutscene == 1; //raven man
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 285231807 && Old.cutscene == 0 && Current.cutscene == 1; //portal
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 67144144 && Old.cutscene == 0 && Current.cutscene == 1; //life 1 (main hall)
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.map == 687877046 || Current.map == 687877489) && Current.xPos > 70 && Old.cutscene == 0 && Current.cutscene == 1; //life 2 (waterworks)
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.map == 1006690753 || Current.map == 1006690755) && Old.cutscene == 0 && Current.cutscene == 1; //life 3 (garden)
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 135501679 && Old.cutscene == 0 && Current.cutscene == 1; //life 4 (fortress entrance)
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Old.storyValue == 58 && Current.storyValue == 59; //59
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.map == 135516393 || Current.map == 135483948 || Current.map ==  16809649) && Current.xPos > -120 && Old.cutscene == 0 && Current.cutscene == 1; //life 5 (prison)
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 67144084 && Old.cutscene == 0 && Current.cutscene == 1; //life 6 (library)
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.map == 587202754 || Current.map == 587203393) && Old.secondaryWeapon != 50 && Current.secondaryWeapon == 50; //banana
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Old.storyValue != 63 && Current.storyValue == 63; //63
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 67145445 && Old.cutscene == 0 && Current.cutscene == 1; //life 7 (mech tower)
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.map == 989860398 || Current.map == 1006711848) && Old.cutscene == 0 && Current.cutscene == 1; //life 8 (southern passage)
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.map == 285225347 || Current.map == 1006717295) && Old.cutscene == 0 && Current.cutscene == 1; //life 9 (sacrificial altar)
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.map == 1006704429 || Current.map == 1006704427) && Old.xPos > -98 && Old.cutscene == 0 && Current.cutscene == 1; //water sword
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 989966868 && Current.yPos > 200 && Old.cutscene == 0 && Current.cutscene == 1; //dahaka
                        vars.splitList.Add(split);
                }
                break;

            case "Any% (No Major Glitches)":
            case "True Ending (No Major Glitches)":
                if (timer.Run.GetExtendedCategoryName() == "Any% (No Major Glitches)")
                    category = "AnyNmg";
                else category = "TeNmg";
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 67109218 && Current.bossHealth == 0 && Old.cutscene == 0 && Current.cutscene == 1; //boat
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 135462576 && Old.cutscene == 0 && Current.cutscene == 1; //spider sword
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 135462572 && Old.cutscene == 0 && Current.cutscene == 1; //raven man
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 285231807 && Old.cutscene == 0 && Current.cutscene == 1; //portal
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 989860400 && Old.cutscene == 0 && Current.cutscene == 1; //chasing shahdee
                    vars.splitList.Add(split);
                }
                i++;
                if (category == "TeNmg") {
                    if (settings[category + i]) {
                        Func<dynamic, dynamic, bool> split = (Old, Current) =>
                            Current.map == 1006711848 && Old.cutscene == 0 && Current.cutscene == 1; //life 1 (southern passage) (TE only)
                        vars.splitList.Add(split);
                    }
                    i++;
                }
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 1006801609 && Current.bossHealth == 0 && Old.cutscene == 0 && Current.cutscene == 1; //a damsel in distress
                    vars.splitList.Add(split);
                }
                i++;
                if (category == "TeNmg") {
                    if (settings[category + i]) {
                        Func<dynamic, dynamic, bool> split = (Old, Current) =>
                            Current.map == 1006717295 && Old.cutscene == 0 && Current.cutscene == 1; //life 2 (sacrificial altar) (TE only)
                        vars.splitList.Add(split);
                    }
                    i++;
                }
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 989884886 && Old.cutscene == 0 && Current.cutscene == 1; //the dahaka
                    vars.splitList.Add(split);
                }
                i++;
                if (category == "TeNmg") {
                    if (settings[category + i]) {
                        Func<dynamic, dynamic, bool> split = (Old, Current) =>
                            Current.map == 135501679 && Old.cutscene == 0 && Current.cutscene == 1; //life 3 (fortress entrance) (TE only)
                        vars.splitList.Add(split);
                    }
                    i++;
                }
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 1006704429 && Old.cutscene == 0 && Current.cutscene == 1 && Current.storyValue == 13; //serpent sword
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.map == 135495099 || Current.map == 135495097) && Old.cutscene == 0 && Current.cutscene == 1; //garden hall
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 687877048 && Old.cutscene == 0 && Current.cutscene == 1; //waterworks
                    vars.splitList.Add(split);
                }
                i++;
                if (category == "TeNmg") {
                    if (settings[category + i]) {
                        Func<dynamic, dynamic, bool> split = (Old, Current) =>
                            Current.map == 687877489 && Old.cutscene == 0 && Current.cutscene == 1; //life 4 (waterworks) (TE only)
                        vars.splitList.Add(split);
                    }
                    i++;
                    if (settings[category + i]) {
                        Func<dynamic, dynamic, bool> split = (Old, Current) =>
                            Current.map == 1006690755 && Old.cutscene == 0 && Current.cutscene == 1; //life 5 (garden) (TE only)
                        vars.splitList.Add(split);
                    }
                    i++;
                    if (settings[category + i]) {
                        Func<dynamic, dynamic, bool> split = (Old, Current) =>
                            Current.map == 67144144 && Old.cutscene == 0 && Current.cutscene == 1; //life 6 (main hall) (TE only)
                        vars.splitList.Add(split);
                    }
                    i++;
                }
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 67112526 && Old.cutscene == 0 && Current.cutscene == 1 && Current.storyValue == 21; //lion sword
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 687876481 && Old.zPos < 410 && Current.zPos >= 410; //mech tower
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 687876652 && Old.cutscene == 0 && Current.cutscene == 1; //mech tower elevator
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 285235400 && Old.cutscene == 0 && Current.cutscene == 1; //breath of fate
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 67145437 && Old.cutscene == 0 && Current.cutscene == 1; //activation room in ruin
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 67145455 && Old.cutscene == 0 && Current.cutscene == 1; //activation room restored
                    vars.splitList.Add(split);
                }
                i++;
                if (category == "TeNmg") {
                    if (settings[category + i]) {
                        Func<dynamic, dynamic, bool> split = (Old, Current) =>
                            Current.map == 67145445 && Old.cutscene == 0 && Current.cutscene == 1; //life 7 (mech tower) (TE only)
                        vars.splitList.Add(split);
                    }
                    i++;
                }
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 67112526 && Old.yPos < -13 && Current.yPos >= -13 && Current.zPos < 391 && Current.storyValue == 33; //the death of a sand wraith
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 67112526 && Old.yPos < -8 && Current.yPos >= -8 && Current.storyValue == 33; //the death of a sand wraith v2
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Old.storyValue == 34 && Current.storyValue == 38; //the death of the empress
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 135464247 && Current.zPos > 33 && Old.cutscene == 0 && Current.cutscene == 1; //exit the tomb
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 135483950 && Old.cutscene == 0 && Current.cutscene == 1; //scorpion sword
                    vars.splitList.Add(split);
                }
                i++;
                if (category == "TeNmg") {
                    if (settings[category + i]) {
                        Func<dynamic, dynamic, bool> split = (Old, Current) =>
                            Current.map ==  16809649 && Old.cutscene == 0 && Current.cutscene == 1; //life 8 (prison) (TE only)
                        vars.splitList.Add(split);
                    }
                    i++;
                }
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.map == 67116821 || Current.map == 67116816) && Old.cutscene == 0 && Current.cutscene == 1; //library cutscene
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 67116821 && Old.xPos < -112 && Current.xPos >= -112 && Current.storyValue == 42; //library v2
                    vars.splitList.Add(split);
                }
                i++;
                if (category == "TeNmg") {
                    if (settings[category + i]) {
                        Func<dynamic, dynamic, bool> split = (Old, Current) =>
                            Current.map == 67144084 && Old.cutscene == 0 && Current.cutscene == 1; //life 9 (library) (TE only)
                        vars.splitList.Add(split);
                    }
                    i++;
                }
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Old.map == 1006704427 && Current.map == 1006704429 && Current.storyValue == 45; //hourglass revisited
                    vars.splitList.Add(split);
                }
                i++;
                if (category == "TeNmg") {
                    if (settings[category + i]) {
                        Func<dynamic, dynamic, bool> split = (Old, Current) =>
                            Current.map == 1006704429 && Old.xPos > -98 && Old.cutscene == 0 && Current.cutscene == 1; //water sword (TE only)
                        vars.splitList.Add(split);
                    }
                    i++;
                }
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 285231214 && Old.cutscene == 0 && Current.cutscene == 1; //mask on
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 285231574 && Current.yPos < 195 && Old.cutscene == 0 && Current.cutscene == 1; //sand griffin
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 285231574 && Old.yPos > 166.5 && Current.yPos <= 166.5; //sand griffin v2
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 1006801611 && Old.cutscene == 0 && Current.cutscene == 1; //mirrored fates
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 135501700 && Old.cutscene == 0 && Current.cutscene == 1; //a favor unknown
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 67116821 && Old.xPos < -112 && Current.xPos >= -112 && Current.storyValue == 60; //library revisited
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        (Current.map == 587202754 || Current.map == 587203393) && Old.secondaryWeapon != 50 && Current.secondaryWeapon == 50; //banana
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i]) {
                    Func<dynamic, dynamic, bool> split = (Old, Current) =>
                        Current.map == 67112526 && Old.cutscene == 0 && Current.cutscene == 1 && Current.storyValue == 64; //mask off
                    vars.splitList.Add(split);
                }
                i++;
                if (settings[category + i])
                    if (category == "TeNmg") {
                        Func<dynamic, dynamic, bool> split = (Old, Current) =>
                            Current.map == 989966868 && Current.yPos > 200 && Old.cutscene == 0 && Current.cutscene == 1; //dahaka (if TE)
                            vars.splitList.Add(split);
                    }
                    else {
                        Func<dynamic, dynamic, bool> split = (Old, Current) =>
                            Current.map == 989966866 && Current.bossHealth == 0 && Old.cutscene == 0 && Current.cutscene == 1; //kaileena (if Any%)
                            vars.splitList.Add(split);
                    }
                break;

            default:
                break;
        }
    }
    vars.oldTimerPhase = timer.CurrentPhase;
}

split
{
    return vars.splitList[timer.CurrentSplitIndex](old, current);
}
