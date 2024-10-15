// Game         : Multi-Prince of Persia-Runs
// Original by  : Smathlax
// Scripts by   : Samabam (PoP2, PoP3D, SoT, WW, T2T, 2008, TFS), WinterThunder (PoP 1 and 2), Karlgamer (PoP 1), ThePedMeister (PoP 1), Ynscription (SoT), SuicideMachine (TFS)
// Tweaks by    : Ero, GMP
// Updated      : 31 Aug 2021
// IGT timing   : YES for appropriate games
// Load Remover : YES for appropriate games

// Note: DOSBox autosplitter breaks (doesn't find correct memory address) if you alter the dosbox.conf in a specific way.
// Known ways to break the autosplitter:
// 1. Alter the PATH system variable -> don't invoke SET PATH=xyz
// 2. Setting gus=true (make sure gus is set to false)

// Brief outline of how this script works:
/* When you load the script, variables called "game" and "offset" (among several others) are initialized, it keeps track of which game is currently being run.
   When you load a certain game, the start condition for that games is checked, this is done with the help of a global function called "game.ProcessName()".
   And when the start condition is satisfied, the timer starts and the appropriate value for "game" is set.
   Here is the list of process names (converted to lower case) and game values for each game:
   ------------------------------------------------------------------------------------------------
   Game Title                                   Process Name                Game Value
   ------------------------------------------------------------------------------------------------
   Prince of Persia (1989)                      dosbox                      1
   Prince of Persia 2: Shadow and the Flame     dosbox                      2
   Prince of Persia 3D                          pop3d                       3
   Prince of Persia: Sands of Time              pop                         4
   Prince of Persia: Warrior Within             pop2                        5
   Prince of Persia: The Two Thrones            pop3                        6
   Prince of Persia (2008)                      princeofpersia_launcher     7
   Prince of Persia: The Forgotten Sands        prince of persia            8
   Default (No game running)                    NA                          0
   -------------------------------------------------------------------------------------------------
   It is worth noting that the process name is initialised right when the game is loaded, but the game value is set only when the start condition is met.
   After the timer starts, the splits conditions for the appropriate game is checked.
   At the very last split of the game, the game variable is set to 0 and offset is incremented by the number of splits that occurred in that game.
   Now the current split is one of the setup splits between two games and the timer is paused.
   The script again checks for start conditions of each game.
   When the start condition of a certain game is met,the approriate game value is set and the timer unpauses.
   This time when checking for splits, the offset is subtracted from the split index such that it again starts from case 0.
   This makes playing the games in any order possible as long as the total number of splits in all the games combined is equal to what the script expects to it be.
   IGT scripts/load and crash removers of appropriate games will be loaded by again checking the game variable.

   Known ways to break the script from a logical perspective:
   * If a split fails and you dont skip it by the end of the game, the script breaks. (Potential solution - add backup skip split triggers)
   * If the end split of a game fails, the script breaks (should especially look into T2T)
*/

//Defining the memory values of each game
state("DOSBox")
{
    // Prince of Persia 1989
    byte scene          : 0x193C370, 0x1A4BA; // shows level 1-14 changes as scenes end
    byte level1         : 0x193C370, 0x1D0F4; // shows level 1-14 changes as door is entered
    byte start1         : 0x193C370, 0x1D694; // the level you start the game at
    byte endGame        : 0x193C370, 0x1D74A; // 0 before endgame, 255 at endgame cutscene
    byte mins           : 0x193C370, 0x1E350; // Minutes
    int frames          : 0x193C370, 0x1E354; // Frames
    short secs          : 0x193C370, 0x1E356; // Frames in second part of time
    byte sound          : 0x193C370, 0x2F233; // 0 if sound is on, 1 if sound is off

    // Prince of Persia 2: The Shadow and the Flame
    byte level2         : 0x193C370, 0x38796;
    short frameCount    : 0x193C370, 0x387B0;
    byte start2         : 0x193C370, 0x38FF2;
    string300 directory : 0x17D91E8;

    // Common
    byte gameRunning    : 0x19175EA;
}

state("pop3d")
{
    // Prince of Persia 3D
    float xPos3d  : 0x3EF854, 0x160, 0x2F8, 0x8, 0x18, 0x44;
    float yPos3d  : 0x3EF854, 0x160, 0x2F8, 0x8, 0x18, 0x48;
    float zPos3d  : 0x3EF854, 0x160, 0x2F8, 0x8, 0x18, 0x4C;
    short eHealth : 0x3FBC84;
    short health  : 0x4062E4, 0x130;
    float xPos    : 0x4062E4, 0xD0, 0xC4, 0x18, 0x44;
    float yPos    : 0x4062E4, 0xD0, 0xC4, 0x18, 0x48;
    float zPos    : 0x4062E4, 0xD0, 0xC4, 0x18, 0x4C;
}

state("POP")
{
    // Prince of Persia: The Sands of Time
    short resetValue   : 0x40E388, 0x4, 0x398;
    short vizierHealth : 0x40E518, 0x6C, 0x18, 0x4, 0x44, 0x0; // The Vizier's health where 0 is unharmed and 4 is dead.
    float xPos         : 0x699474, 0xC, 0x30; // Prince's position
    float yPos         : 0x699474, 0xC, 0x34;
    float zPos         : 0x699474, 0xC, 0x38;
    short startValue   : 0x6BC980; // Some memory value that reliably changes when 'New Game' is pressed.
}

state("pop2")
{
    // Prince of Persia: Warrior Within
    short storyValue      : 0x523578;                             // Story counter/gate/value.
    short secondaryWeapon : 0x53F8F0, 0x4, 0x164, 0xC, 0x364;     // A value that changes reliably depending on which weapon you pick up.
    float xPos            : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x30; // The Prince's coords.
    float yPos            : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x34;
    float zPos            : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x38;
    short bossHealth      : 0x90C418, 0x18, 0x4, 0x48, 0x198;     // The address used for all bosses' health.
    short startValue      : 0x96602C, 0x8, 0x28, 0xA8, 0x3E0;     // Some memory value that reliably changes when you gain control after a load.
}

state("POP3")
{
    // Prince of Persia: The Two Thrones
    float xCam  : 0x928548;
    float yCam  : 0x928554;
    float xPos  : 0xA2A498, 0xC, 0x30; //The Prince's coords
    float yPos  : 0xA2A498, 0xC, 0x34;
    float zPos  : 0xA2A498, 0xC, 0x38;
}

state("PrinceOfPersia_Launcher")
{
    // Prince of Persia 2008
    float xPos      : 0xB30D08, 0x40;
    float yPos      : 0xB30D08, 0x44;
    float zPos      : 0xB30D08, 0x48;
    short seedCount : 0xB37F64, 0xDC;
    short combat    : 0xB37F6C, 0xE0, 0x1C, 0xC, 0x7CC;
}

state("prince of persia")
{
    // Prince of Persia: The Forgotten Sands
    short cpIcon    : 0x64D34, 0x0, 0x0, 0x24, 0x18, 0x50, 0x870;
    short isMenu    : 0xDA2F70;
    float xPos      : 0xDA4D20;
    float yPos      : 0xDA4D24;
    float zPos      : 0xDA4D28;
    short gameState : 0xDA52EC, 0x18, 0xF8, 0x150;
    bool isLoading  : 0xDA5724, 0x50;
}

//This runs exactly once when the script loads
startup
{
    vars.aboveCredits = false;
    vars.framesOnStart = 0;
    vars.game = 0;
    vars.newFountain = false;
    vars.offset = 0;
    vars.framesOnStart = 0;
    vars.restartDelta = 0;
    vars.timerDelta = TimeSpan.FromSeconds(0);
    vars.startUp = true;
    vars.timerModel = new TimerModel {CurrentState = timer};
    vars.game1complete = false;
    vars.game2complete = false;
    vars.game3complete = false;
    vars.game4complete = false;
    vars.game5complete = false;
    vars.game6complete = false;
    vars.game7complete = false;
    vars.game8complete = false;
    vars.RestartDelta = 0;
}

//This runs exactly once every time a game is loaded/restarted
init
{
    //Initializing approriate functions, refreshRate, etc. when a process is loaded:
    switch(game.ProcessName.ToLower()) {
        case "dosbox":
            vars.restartDelta = 0;
            break;

        case "pop3d":
        case "pop": case "pop2": case "pop3": case "princeofpersia_launcher": case "prince of persia":
            vars.gameRunning = true;
            game.Exited += (s, e) => vars.gameRunning = false;

            //this action will split and set the current game to null at the end of every game:
            vars.lastSplit = (Action <bool>)((splitName) => { if (splitName) {vars.timerModel.Split(); vars.game = 0; }});

            //this function will take 2 float values as input and check if X co-ordinate is within those values:
            vars.inXRange = (Func <float, float, bool>)((xMin, xMax) => { return current.xPos >= xMin && current.xPos <= xMax ? true : false; });

            //this function will take 2 float values as input and check if Y co-ordinate is within those values:
            vars.inYRange = (Func <float, float, bool>)((yMin, yMax) => { return current.yPos >= yMin && current.yPos <= yMax ? true : false; });

            //this function will take 2 float values as input and check if Z co-ordinate is within those values:
            vars.inZRange = (Func <float, float, bool>)((zMin, zMax) => { return current.zPos >= zMin && current.zPos <= zMax ? true : false; });

            //this function will take 6 float values as input and check if X,Y and Z co-ordinates are within those values:
            vars.inPosFull = (Func <float, float, float, float, float, float, bool>)((xMin, xMax, yMin, yMax, zMin, zMax) => { return vars.inXRange(xMin, xMax) && vars.inYRange(yMin, yMax) && vars.inZRange(zMin, zMax) ? true : false; });

            //this function will take 3 float values for x,y and z of target split location and 1 integer for half-size of range as input and check if X,Y and Z co-ordinates within the range of the target:
            vars.inPosWithRange = (Func <float, float, float, int, bool>)((xTarg, yTarg, zTarg, range) => {
                return
                    current.xPos >= xTarg - range && current.xPos <= xTarg + range &&
                    current.yPos >= yTarg - range && current.yPos <= yTarg + range &&
                    current.zPos >= zTarg - range && current.zPos <= zTarg + range ? true : false;
            });
            break;

            // PoP 2008 - This function checks if x,y,z co-ordinates are in a certain range and if a seed has just been picked:
            vars.splitSeed = (Func <float, float, float, bool>)((xTarg, yTarg, zTarg) => { return vars.inPosWithRange(xTarg, yTarg, zTarg, 3) && seedGet ? true : false; });

            // PoP 2008 - This function checks if x,y,z co-ordinates are in a certain range and if a combat has just ended:
            vars.splitBoss = (Func <float, float, float, bool>)((xTarg, yTarg, zTarg) => { return vars.inPosWithRange(xTarg, yTarg, zTarg, 3) && kill ? true : false; });

            //TFS: This function checks if x,y,z co-ordinates are in a certain range and if a checkpoint has just been acquired:
            vars.splitCP = (Func <float, float, float, bool>)((xTarg, yTarg, zTarg) => { return vars.inPosWithRange(xTarg, yTarg, zTarg, 10) && vars.cpGet ? true : false; });

            //TFS: This function checks if x,y,z co-ordinates are within range of 1 unit from the target split location:
            vars.splitXYZ = (Func <float, float, float, bool>)((xTarg, yTarg, zTarg) => { return vars.inPosWithRange(xTarg, yTarg, zTarg, 1) ? true : false; });
    }
}

//This runs indefinitely until the timer starts
start
{
    //checking for process name (after converting it to lower case):
    //this is done mainly to ensure the script doesnt encounter any undefined variables
    switch(game.ProcessName.ToLower()) {
        case "dosbox":
            if (current.start1 == 1 && current.level1 == 1 && current.mins == 60 && current.frames >= 47120384) {
                vars.game = 1;
                vars.game1complete = true;
                return true;
            }

            if (old.start2 == 238 && current.start2 != 238 && current.level2 == 1) {
                vars.framesOnStart = current.frameCount;
                vars.game = 2;
                vars.game2complete = true;
                return true;
            } break;

        case "pop3d":
            if (vars.inXRange(20.554f, 20.556f) && vars.inZRange(1.448f, 1.45f)) {
                vars.game = 3;
                vars.game3complete = true;
                return true;
            } break;

        case "pop":
            if (vars.inPosFull(-103.264f, -103.262f, -4.8f, -4.798f, 1.341f, 1.343f) && current.startValue == 1) {
                vars.aboveCredits = false;
                vars.newFountain = false;
                vars.game = 4;
                vars.game4complete = true;
                return true;
            } break;

        case "pop2":
            if (vars.inXRange(-997.6757f, -997.6755f) && old.startValue == 1 && current.startValue == 2) {
                vars.game = 5;
                vars.game5complete = true;
                return true;
            } break;

        case "pop3":
            if (vars.inXRange(-409.9f, -404.8f) && current.xCam >= 0.8318 && current.xCam <= 0.832 && current.yCam >= 0.1080 && current.yCam <= 0.1082) {
                vars.game = 6;
                vars.game6complete = true;
                return true;
            } break;

        case "princeofpersia_launcher":
            if (old.yPos != -351 && current.yPos == -351) {
                vars.game = 7;
                vars.game7complete = true;
                return true;
            } break;

        case "prince of persia":
            if (vars.inXRange(268.929f, 268.93f) && current.gameState == 4) {
                vars.game = 8;
                vars.game8complete = true;
                return true;
            } break;
    }
}

//These run indefinitely after the timer starts:

isLoading
{
    //checking which game is active and giving their approriate load/crash remover/IGT scipts:
    switch ((short)vars.game) {

        // Prince of Persia 1989, Prince of Persia 2: The Shadow and the Flame (IGT):
        case 1:
        case 2: return true;

        // Prince of Persia 3D (Load and crash Remover):
        case 3: return (current.xPos3d == 0 && current.yPos3d == 0 && current.zPos3d == 0) || !vars.gameRunning;

        // Prince of Persia: The Forgotten Sands (Load and crash Remover)
        case 8: return current.isMenu == 0 || current.isLoading || !vars.gameRunning;

        // The state between last split of one game and start of next game:
        case 0: return true;

        // Games without a load remover (SoT, WW, T2T, 2k8):
        default: return false;
    }
}

gameTime
{
    //checking which game is active and giving their IGT scripts:
    switch ((short)vars.game) {

        // Prince of Persia 1989:
        case 1:
            int adjustedFramesLeft = current.mins - 1 < 0 ? 0 : (current.mins - 1) * 720 + current.secs;
            return (TimeSpan.FromSeconds((60*720 - adjustedFramesLeft) / 12.0) + vars.timerDelta);

        // Prince of Persia 2: The Shadow and the Flame:
        case 2:
            return ((current.gameRunning == 0)?(TimeSpan.FromSeconds((vars.restartDelta - vars.framesOnStart) / 12.0) + vars.timerDelta):(TimeSpan.FromSeconds((current.frameCount - vars.framesOnStart + vars.restartDelta) / 12.0) + vars.timerDelta));
    }
}

split
{
    switch ((short)vars.game) {

        //This is for the setup splits between 2 games and also updates offsets, and sets the appropriate active game:
        case 0:
            switch(game.ProcessName.ToLower()) {
                case "dosbox":
                    if (current.start1 == 1 && current.level1 == 1 && current.mins == 60 && current.frames >= 47120384 && !vars.game1complete) {
                        vars.timerDelta = timer.Run[timer.CurrentSplitIndex - 1].SplitTime.GameTime;
                        vars.game = 1;
                        vars.game1complete = true;
                        return true;
                    }

                    if (old.start2 == 238 && current.start2 != 238 && current.level2 == 1 && !vars.game2complete) {
                        vars.framesOnStart = current.frameCount;
                        vars.timerDelta = timer.Run[timer.CurrentSplitIndex - 1].SplitTime.GameTime;
                        vars.game = 2;
                        vars.game2complete = true;
                        return true;
                    } break;

                case "pop3d":
                    if (vars.inXRange(20.554f, 20.556f) && vars.inZRange(1.448f, 1.45f) && !vars.game3complete) {
                        vars.offset = timer.CurrentSplitIndex+1;
                        vars.game = 3;
                        vars.game3complete = true;
                        return true;
                    } break;

                case "pop":
                    if (vars.inPosFull(-103.264f, -103.262f, -4.8f, -4.798f, 1.341f, 1.343f) && current.startValue == 1 && !vars.game4complete) {
                        vars.offset = timer.CurrentSplitIndex+1;
                        vars.aboveCredits = false;
                        vars.newFountain = false;
                        vars.game = 4;
                        vars.game4complete = true;
                        return true;
                    } break;

                case "pop2":
                    if (vars.inXRange(-997.6757f, -997.6755f) && old.startValue == 1 && current.startValue == 2 && !vars.game5complete) {
                        vars.offset = timer.CurrentSplitIndex+1;
                        vars.game = 5;
                        vars.game5complete = true;
                        return true;
                    } break;

                case "pop3":
                    if (vars.inXRange(-409.9f, -404.8f) && current.xCam >= 0.8318 && current.xCam <= 0.832 && current.yCam >= 0.1080 && current.yCam <= 0.1082 && !vars.game1complete) {
                        vars.offset = timer.CurrentSplitIndex+1;
                        vars.game = 6;
                        vars.game6complete = true;
                        return true;
                    } break;

                case "princeofpersia_launcher":
                    if (old.yPos != -351 && current.yPos == -351 && !vars.game7complete) {
                        vars.offset = timer.CurrentSplitIndex+1;
                        vars.game = 7;
                        vars.game7complete = true;
                        return true;
                    } break;

                case "prince of persia":
                    if (vars.inXRange(268.929f, 268.93f) && current.gameState == 4 && !vars.game8complete) {
                        vars.offset = timer.CurrentSplitIndex+1;
                        vars.game = 8;
                        vars.game8complete = true;
                        return true;
                    } break;
            }
            break;

        // Prince of Persia (1989):-
        case 1:
            if (old.level1 == current.level1 - 1 && current.gameRunning != 0 && current.level1 != 1)
                return true;
            if (current.level1 == 14 && current.endGame == 255 && current.gameRunning != 0) {
                vars.game = 0;
                return true;
            }
            break;

        // Prince of Persia 2: The Shadow and the Flame:-
        case 2:
            if (old.gameRunning != 0 && current.gameRunning == 0) {
                vars.restartDelta += current.frameCount;
            }
            if (old.level2 == current.level2 - 1 && current.level2 > 1 && current.level2 != 15 && current.gameRunning != 0)
                return true;
            if (current.level2 == 15 && old.level2 == 14) {
                vars.game = 0;
                return true;
            }
            break;

        // Prince of Persia 3D:-
        case 3:
            // Initializing PoP3D splits:
            bool Cistern         = old.xPos == 0 && vars.inXRange(216.904f, 216.906f) ? true : false;
            bool Cliffs          = old.yPos == 0 && vars.inYRange(-2.36f, -2.34) ? true : false;
            bool DirigibleFinale = old.yPos == 0 && current.yPos == 61 ? true : false;
            bool Dungeon         = old.yPos == 0 && current.yPos == -2 ? true : false;
            bool End3D           = current.xPos == 0 && current.yPos == 0 && current.zPos == 0 && current.eHealth == 0 ? true : false;
            bool FloatingRuins   = old.yPos == 0 && current.yPos == -85 ? true : false;
            bool IvoryTower      = old.xPos == 0 && vars.inXRange(13.485f, 13.487f) ? true : false;
            bool LowerDirigible1 = old.yPos == 0 && current.yPos == 99 ? true : false;
            bool LowerDirigible2 = vars.inZRange(-77.77f, -77.75f) && old.zPos == 0 ? true : false;
            bool Palace1         = old.xPos == 0 && current.xPos == -7 ? true : false;
            bool Palace2         = old.yPos == 0 && current.yPos == -23 ? true : false;
            bool Palace3         = current.xPos == 0 && current.yPos == 0 && current.zPos == 0 && old.health == 0 && current.health != 0 ? true : false;
            bool Rooftops        = old.xPos == 0 && current.xPos == -42 ? true : false;
            bool StreetsDocks    = old.yPos == 0 && current.yPos == -20 ? true : false;
            bool UpperDirigible  = old.yPos == 0 && current.yPos == 103 ? true : false;
            bool SunTemple3D     = old.yPos == 0 && vars.inYRange(-19.966f, -19.964) ? true : false;
            bool MoonTemple      = old.yPos == 0 && vars.inYRange(-27.4f, -27.38) ? true : false;

            // Checking qualifications to complete each split:
            switch (timer.CurrentSplitIndex - (short)vars.offset) {
                case 0: return Dungeon;          // Dungeon
                case 1: return IvoryTower;       // Ivory Tower
                case 2: return Cistern;          // Cistern
                case 3: return Palace1;          // Palace 1
                case 4: return Palace2;          // Palace 2
                case 5: return Palace3;          // Palace 3
                case 6: return Rooftops;         // Rooftops
                case 7: return StreetsDocks;     // Streets and Docks
                case 8: return LowerDirigible1;  // Lower Dirigible 1
                case 9: return LowerDirigible2;  // Lower Dirigible 2
                case 10: return UpperDirigible;  // Upper Dirigible
                case 11: return DirigibleFinale; // Dirigible Finale
                case 12: return FloatingRuins;   // Floating Ruins
                case 13: return Cliffs;          // Cliffs
                case 14: return SunTemple3D;     // Sun Temple
                case 15: return MoonTemple;      // Moon Temple
                case 16: vars.lastSplit(End3D); break; // Finale
            }
            break;

        // Prince of Persia: Sands of Time:-
        case 4: // Initializing SoT splits.
            bool AzadPrison            = vars.inPosFull(190f, 195f, -21f, -19f, -17.6f, -17.3f);
            bool Baths                 = vars.inPosFull(-211.427f, -211.425f, 56.602f, 56.604f, -43.501f, -43.499f);
            bool BathsZipless          = vars.inPosFull(-215.85f, -214.089f, 54.261f, 58.699f, -43.501f, -43.499f);
            bool BirdCage              = vars.inPosFull(-211f, -208f, -23f, -21f, -9f, -8.8f);
            bool BrokenBridge          = vars.inPosFull(-265f, -257f, 159f, 167f, -13.6f, -13.4f);
            bool Caves                 = vars.inPosFull(-246.839f, -241.677f, 78.019f, 87.936f, -71.731f, -70.7f);
            bool CavesAC               = vars.inPosFull(-171.193f, -171.191f, -52.07f, -52.068f, -119.863f, -119.861f);
            bool CavesZipless          = vars.inPosFull(-303f, -297.5f, 112f, 113.5f, -56.1f, -55.9f);
            bool CliffWaterfalls       = vars.inPosFull(-233.6f, -231.4f, 33.7f, 35f, -42.6f, -42.4f);
            bool DadDead               = vars.inPosFull(-6.001f, -5.999f, -18.6f, -18.4f, 1.998f, 2.001f);
            bool DadStart              = vars.inPosFull(6.714f, 6.716f, 57.698f, 57.7f, 21.005f, 21.007f);
            bool Daybreak              = vars.inPosFull(-76f, -70f, 192.4f, 197.6f, -56.6f, -54f);
            bool DrawbridgeTower       = vars.inPosFull(-267f, -262f, 232f, 267f, -35.6f, -35.5f);
            bool Dream                 = vars.inPosFull(95.8f, 96f, -25.1f, -24.9f, -74.9f, -74.7f);
            bool DreamZipless          = vars.inPosFull(99f, 101f, -11f, -10f, -56f, -54f);
            bool Elevator              = vars.inPosFull(74f, 74.171f, -46.751f, -43.252f, -33.501f, -33.499f);
            bool FirstGuestRoom        = vars.inPosFull(30.297f, 30.299f, 42.126f, 42.128f, 12.998f, 13f);
            bool GasStation            = vars.inPosFull(252f, 258f, 130.647f, 134f, 22.999f, 23.001f);
            bool GrandRewind           = vars.inPosFull(660.376f, 660.378f, 190.980f, 190.983f, 0.432f, 0.434f);
            bool HallOfLearning        = vars.inPosFull(73f, 79f, 161f, 163f, -24.1f, -23.9f);
            bool HoLCourtyardsExit     = vars.inPosFull(72f, 77f, 90f, 95.7f, -27.1f, -26.9f);
            bool HonorGlory            = vars.inPosFull(81f, 82f, -60.3f, -59.7f, 89f, 90f);
            bool LastFightSkip         = vars.inPosFull(66f, 69f, -39f, -36f, 90f, 92f);
            bool Messhall              = vars.inPosFull(-183.267f, -183.265f, 234.685f, 234.687f, -37.528f, -37.526f);
            bool ObservatorySoT        = vars.inPosFull(139.231f, 139.233f, 162.556f, 162.558f, -29.502f, -29.5f);
            bool ObservatoryExit       = vars.inPosFull(137f, 141f, 164f, 164.67f, -29.5f, -29.2f);
            bool PalaceDefence         = vars.inPosFull(4.547f, 8.851f, 40.494f, 47.519f, -39.001f, -38.999f);
            bool SandsUnleashed        = vars.inPosFull(-6.177f, -6.175f, 62.905f, 62.907f, 7.604f, 7.606f);
            bool SecondSword           = vars.inPosFull(-106.819f, -106.817f, 81.097f, 81.099f, -27.269f, -27.267f);
            bool SettingSun            = vars.inPosFull(60f, 61f, -58f, -57f, 30f, 32f);
            bool SoTLU                 = vars.inPosFull(-492.608f, -492.606f, -248.833f, -248.831f, 0.219f, 0.221f) && vars.newFountain;
            bool SoTEnd                = vars.inPosFull(658.26f, 661.46f, 210.92f, 213.72f, 9.8f, 12.5f) || current.vizierHealth == 4;
            bool SultanChamber         = vars.inPosFull(134.137f, 134.139f, 54.990f, 54.992f, -32.791f, -32.789f);
            bool SultanChamberZipless  = vars.inPosFull(98.445f, 98.447f, 39.567f, 39.57f, -8.96f, -8.958f);
            bool TheWarehouse          = vars.inPosFull(-73.352f, -71.233f, -28.5f, -26.868f, -1.001f, -0.818f);
            bool TheZoo                = vars.inPosFull(-141.299f, -139.797f, -47.21f, -42.801f, -31.1f, -30.9f);
            bool Tomb                  = vars.inPosFull(100.643f, 100.645f, -11.543f, -11.541f, -67.588f, -67.586f);
            bool TortureChamber        = vars.inPosFull(189.999f, 190.001f, -43.278f, -43.276f, -119.001f, -118.999f);
            bool TortureChamberZipless = vars.inPosFull(187.5f, 192.5f, -39f, -37.5f, -119.1f, -118.9f);
            bool TowerofDawn           = vars.inPosFull(35.5f, 35.7f, -50f, -39f, -32f, -30f);
            bool UGReservoir           = vars.inPosFull(-51.477f, -48.475f, 72.155f, 73.657f, -24.802f, -24.799f);
            bool UGReservoirZipless    = vars.inPosFull(-121f, -110f, -9f, -7f, -154.1f, -153.9f);
            bool Waterfall             = vars.inPosFull(-242f, -240.5f, 79.5f, 83f, -121f, -118f);

            if (vars.inPosFull(-477.88f, -477f, -298f, -297.1f, -0.5f, -0.4f)) vars.newFountain = true;
            if (SoTLU) vars.newFountain = false;

            // Checking category and qualifications to complete each split:
            switch(timer.Run.GetExtendedCategoryName()) {
                case "Anthology": case "Sands Trilogy (Any%, Standard)":
                switch (timer.CurrentSplitIndex - (short)vars.offset) {
                    case 0: return GasStation;                   //The Treasure Vaults
                    case 1:    return SandsUnleashed;               //The Sands of Time
                    case 2:    return SultanChamber;                //The Sultan's Chamber (Death)
                    case 3:    return DadDead;                      //Death of the Sand King
                    case 4:    return Baths;                        //The Baths (Death)
                    case 5:    return Messhall;                     //The Messhall (Death)
                    case 6:    return Caves;                        //The Caves
                    case 7:    return UGReservoir;                  //Exit Underground Reservoir
                    case 8: return ObservatorySoT;               //The Observatory (Death)
                    case 9:    return TortureChamber;               //The Torture Chamber (Death)
                    case 10: return Dream;                       //The Dream
                    case 11: return HonorGlory || LastFightSkip; //Honor and Glory
                    case 12: return GrandRewind;                 //The Grand Rewind
                    case 13: vars.lastSplit(SoTEnd); break;  //The End
                } break;

                case "Sands Trilogy (Any%, Zipless)":
                case "Sands Trilogy (Any%, No Major Glitches)":
                switch (timer.CurrentSplitIndex - (short)vars.offset) {
                    case 0: return GasStation;             // The Treasure Vaults
                    case 1: return SandsUnleashed;         // The Sands of Time
                    case 2: return FirstGuestRoom;         // First Guest Room
                    case 3: return SultanChamberZipless;   // The Sultan's Chamber
                    case 4: return PalaceDefence;          // Exit Palace Defense
                    case 5: return DadStart;               // The Sand King
                    case 6: return DadDead;                // Death of the Sand King
                    case 7: return TheWarehouse;           // The Warehouse
                    case 8:    return TheZoo;                 // The Zoo
                    case 9: return BirdCage;               // Atop a Bird Cage
                    case 10: return CliffWaterfalls;       // Cliffs and Waterfall
                    case 11: return BathsZipless;          // The Baths
                    case 12: return SecondSword;           // Sword of the Mighty Warrior
                    case 13: return Daybreak;              // Daybreak
                    case 14: return DrawbridgeTower;       // Drawbridge Tower
                    case 15: return BrokenBridge;          // A Broken Bridge
                    case 16: return CavesZipless;          // The Caves
                    case 17: return Waterfall;             // Waterfall
                    case 18: return UGReservoirZipless;    // An Underground Reservoir
                    case 19: return HallOfLearning;        // Hall of Learning
                    case 20: return ObservatoryExit;       // Exit Observatory
                    case 21: return HoLCourtyardsExit;     // Exit Hall of Learning Courtyards
                    case 22: return AzadPrison;            // The Prison
                    case 23: return TortureChamberZipless; // The Torture Chamber
                    case 24: return Elevator;              // The Elevator
                    case 25: return DreamZipless;          // The Dream
                    case 26: return Tomb;                  // The Tomb
                    case 27: return TowerofDawn;           // The Tower of Dawn
                    case 28: return SettingSun;            // The Setting Sun
                    case 29: return HonorGlory;            // Honor and Glory
                    case 30: return GrandRewind;           // The Grand Rewind
                    case 31: vars.lastSplit(SoTEnd); break; //The End
                } break;

                case "Sands Trilogy (Completionist, Standard)":
                switch (timer.CurrentSplitIndex - (short)vars.offset) {
                    case 0: return GasStation;                   // The Treasure Vaults
                    case 1: return SandsUnleashed;               // The Sands of Time
                    case 5: return Baths;                        // The Baths (Death)
                    case 7: return Messhall;                     // The Messhall (Death)
                    case 9: return Caves;                        // The Caves (Death)
                    case 12: return ObservatorySoT;              // The Observatory (Death)
                    case 15: return Dream;                       // The Dream
                    case 2: case 3: case 4: case 6: case 8: case 10: case 11: case 13: case 14:
                    case 16: return SoTLU;                       // Life Upgrades 1-10
                    case 17: return HonorGlory || LastFightSkip; // Honor and Glory
                    case 18: return GrandRewind;                 // The Grand Rewind
                    case 19: vars.lastSplit(SoTEnd); break;  //The End
                } break;

                case "Sands Trilogy (Completionist, Zipless)":
                case "Sands Trilogy (Completionist, No Major Glitches)":
                switch (timer.CurrentSplitIndex - (short)vars.offset) {
                    case 0: return GasStation;                 // The Treasure Vaults
                    case 1: return SandsUnleashed;             // The Sands of Time
                    case 2: return FirstGuestRoom;             // First Guest Room
                    case 4: return PalaceDefence;              // Exit Palace Defense
                    case 6: return DadDead;                    // Death of the Sand King
                    case 8:    return TheZoo;                     // The Zoo
                    case 9: return BirdCage;                   // Atop a Bird Cage
                    case 10: return CliffWaterfalls;           // Cliffs and Waterfall
                    case 11: return BathsZipless;              // The Baths
                    case 13: return Daybreak;                  // Daybreak
                    case 14: return DrawbridgeTower;           // Drawbridge Tower
                    case 15: return BrokenBridge;              // A Broken Bridge
                    case 17: return Waterfall;                 // Waterfall
                    case 18: return UGReservoirZipless;        // An Underground Reservoir
                    case 20: return HallOfLearning;            // Hall of Learning
                    case 22: return ObservatoryExit;           // Exit Observatory
                    case 23: return HoLCourtyardsExit;         // Exit Hall of Learning Courtyards
                    case 24: return AzadPrison;                // The Prison
                    case 27: return Dream;                     // The Dream
                    case 28: return Tomb;                      // The Tomb
                    case 3: case 5: case 7: case 12: case 16: case 19: case 21: case 25: case 26:
                    case 29: return SoTLU;                     // Life Upgrades 1-10
                    case 30: return TowerofDawn;               // The Tower of Dawn
                    case 31: return SettingSun;                // The Setting Sun
                    case 32: return HonorGlory;                // Honor and Glory
                    case 33: return GrandRewind;               // The Grand Rewind
                    case 34: vars.lastSplit(SoTEnd); break; //The End
                } break;
            }
            break;

        // Prince of Persia: Warrior Within:-
        case 5:
            //This function checks if x,y,z co-ordinates are in a certain range and if the story value is appropriate
            var posAndStory = (Func <float, float, float, float, float, float, int, bool>)((xMin, xMax, yMin, yMax, zMin, zMax, storyValue) => {
                return vars.inPosFull(xMin, xMax, yMin, yMax, zMin, zMax) && current.storyValue == storyValue ? true : false;
            });

            // Initializing WW Splits:
            bool ActRoomRestored    = posAndStory(-192.5f, -189.5f, 109f, 111f, 471.9f, 472.1f, 19) ? true : false;
            bool ActRoomRuin        = posAndStory(-206f, -205.8f, 59.8f, 67.4f, 162.6f, 163.1f, 18) ? true : false;
            bool BackToTheFuture    = posAndStory(-52.7f, -52.6f, 137.2f, 137.3f, 418f, 419f, 66) ? true : false;
            bool Boat               = posAndStory(-1003f, -995f, -1028f, -1016f, 14f, 15f, 0) && current.bossHealth == 0 ? true : false;
            bool BreathOfFate       = posAndStory(-210.018f, -210.016f, 164.259f, 164.261f, 440.9f, 441.1f, 16) ? true : false;
            bool ChasingShadee      = posAndStory(43.3f, 43.4f, -75.7f, -75.6f, 370f, 370.1f, 7) ? true : false;
            bool Dahaka             = posAndStory(40.1f, 42.4f, -96.1f, -95.9f, 86f, 86.1f, 9) ? true : false;
            bool DamselInDistress   = posAndStory(115f, 132f, -114f, -80f, 357f, 361f, 8) && current.bossHealth == 0 ? true : false;
            bool DeathOfPrince      = posAndStory(-67f, -65.1f, -23.3f, -23.1f, 399.9f, 400f, 64) ? true : false;
            bool DeathOfSandWraith  = posAndStory(-50f, -39f, -13f, -5f, 388.9f, 389.8f, 33) ? true : false;
            bool DeathOfTheEmpress  = posAndStory(-74f, -31f, 53.5f, 104f, 414f, 422f, 38) && current.bossHealth == 0 ? true : false;
            bool EndGame            = old.storyValue != 63 && current.storyValue == 63 ? true : false;
            bool ExitTomb           = posAndStory(-100f, -97.5f, -190f, -187f, 33f, 33.2f, 39) ? true : false;
            bool FavorUnknown       = posAndStory(41.1f, 41.2f, -180.1f, -180f, 368.9f, 369.1f, 57) ? true : false;
            bool GardenHall         = posAndStory(66.9f, 67.1f, 11.4f, 11.6f, 400f, 400.2f, 22) ? true : false;
            bool HourglassRev       = posAndStory(-108.3f, -106f, 40f, 45f, 407.3f, 407.5f, 45) ? true : false;
            bool Library            = posAndStory(-112f, -111f, -144f, -137f, 384.9f, 389f, 42) ? true : false;
            bool LibraryRev         = posAndStory(-112f, -111f, -144f, -137f, 384.9f, 389f, 60) ? true : false;
            bool LightSword         = current.secondaryWeapon == 50 && current.storyValue == 61 ? true : false;
            bool LionSword          = posAndStory(-44.7f, -44.6f, -27.1f, -27f, 389f, 389.1f, 21) ? true : false;
            bool LU1                = posAndStory(52f, 52.8f, -188.7f, -188.6f, 381.9f, 382.1f, 2) ? true : false;
            bool LU2                = posAndStory(-112.1f, -112f, -66.1f, -65.2f, 360.9f, 361f, 59) ? true : false;
            bool LU3                = posAndStory(-74.8f, -74.2f, -102.8f, -102.7f, 378.9f, 379f, 60) ? true : false;
            bool LU4                = posAndStory(-161.2f, -161f, 170.3f, 171f, 471.9f, 472.1f, 63) ? true : false;
            bool LU5                = posAndStory(138.8f, 139f, 115.3f, 116.7f, 382.5f, 382.6f, 64) ? true : false;
            bool LU6                = posAndStory(76.1f, 76.2f, 64.1f, 64.9f, 461.4f, 461.6f, 64) ? true : false;
            bool LU7                = posAndStory(190.2f, 190.4f, -131.9f, -131.8f, 353.9f, 354.1f, 64) ? true : false;
            bool LU8                = posAndStory(162.2f, 162.7f, -37.5f, -37.3f, 392.9f, 393.1f, 64) ? true : false;
            bool LU9                = posAndStory(-114.7f, -114.1f, -47.2f, -47f, 368.9f, 369.1f, 64) ? true : false;
            bool MaskOfWraith       = posAndStory(-20.5f, -20.4f, 236.8f, 267f, 133f, 133.1f, 46) ? true : false;
            bool MechanicalTower    = posAndStory(-167f, -162f, -47.5f, -46f, 409.6363f, 412f, 15) ? true : false;
            bool MirroredFates      = posAndStory(136.7f, 136.9f, -110.6f, -110.4f, 377.9f, 378f, 55) ? true : false;
            bool RavenMan           = posAndStory(-5.359f, -4.913f, -161.539f, -161.500f, 66.5f, 67.5f, 2) ? true : false;
            bool SandGriffin        = posAndStory(-23f, -15f, 163f, 166.5f, 429f, 431f, 48) ? true : false;
            bool ScorpionSword      = posAndStory(-170.1f, -170f, -127.3f, -127.2f, 335.5f, 336.5f, 59) ? true : false;
            bool SerpentSword       = posAndStory(-96.5f, -96.4f, 41.3f, 41.4f, 407.4f, 407.5f, 13) ? true : false;
            bool SpiderSword        = posAndStory(-46.3f, -46f, -139.7f, -138f, 67f, 68f, 2) ? true : false;
            bool TimePortal         = posAndStory(122.8f, 122.9f, -156.1f, -156f, 368.5f, 369.5f, 2) ? true : false;
            bool WaterSword         = posAndStory(-96.643f, -96.641f, 43.059f, 43.061f, 407.4f, 407.5f, 66) ? true : false;
            bool WaterworksRestored = posAndStory(23f, 29f, 41f, 43f, 441f, 450f, 22) ? true : false;
            bool WWEnd              = vars.inPosFull(-35f, -5f, 170f, 205f, 128.9f, 129.1f) && current.storyValue >= 66 && current.bossHealth == 0 ? true : false;

            // Checking category and qualifications to complete each split:
            switch(timer.Run.GetExtendedCategoryName()) {
                case "Anthology":
                case "Sands Trilogy (Any%, Standard)":
                case "Sands Trilogy (Any%, Zipless)":
                switch (timer.CurrentSplitIndex - (short)vars.offset) {
                    case 0: return Boat;                                                              // The Boat
                    case 1: return RavenMan;                                                          // The Raven Man
                    case 2: return TimePortal;                                                        // The Time Portal
                    case 3: return current.storyValue == 59;                                          // Mask of the Wraith (59)
                    case 4: return ScorpionSword;                                                     // The Scorpion Sword
                    case 5: return EndGame || LightSword;                           // Storygate 63 or The Light Sword
                    case 6: return BackToTheFuture;                                                   // Back to the Future
                    case 7: vars.lastSplit(WWEnd); break;                                         // The End
                } break;

                case "Sands Trilogy (Any%, No Major Glitches)":
                switch (timer.CurrentSplitIndex - (short)vars.offset) {
                    case 0: return Boat;                        // The Boat
                    case 1: return SpiderSword;                 // The Spider Sword
                    case 2: return ChasingShadee;               // Chasing Shadee
                    case 3: return DamselInDistress;            // A Damsel in Distress
                    case 4: return Dahaka;                      // The Dahaka
                    case 5: return SerpentSword;                // The Serpent Sword
                    case 6: return GardenHall;                  // The Garden Hall
                    case 7: return WaterworksRestored;          // The Waterworks Restored
                    case 8: return LionSword;                   // The Lion Sword
                    case 9: return MechanicalTower;             // The Mechanical Tower
                    case 10: return BreathOfFate;               // Breath of Fate
                    case 11: return ActRoomRuin;                // Activation Room in Ruin
                    case 12: return ActRoomRestored;            // Activation Room Restored
                    case 13: return DeathOfSandWraith;          // The Death of a Sand Wraith
                    case 14: return DeathOfTheEmpress;          // Death of the Empress
                    case 15: return ExitTomb;                   // Exit the Tomb
                    case 16: return ScorpionSword;              // The Scorpion Sword
                    case 17: return Library;                    // The Library
                    case 18: return HourglassRev;               // The Hourglass Revisited
                    case 19: return MaskOfWraith;               // The Mask of the Wraith
                    case 20: return SandGriffin;                // The Sand Griffin
                    case 21: return MirroredFates;              // Mirrored Fates
                    case 22: return FavorUnknown;               // A Favor Unknown
                    case 23: return LibraryRev;                 // The Library Revisited
                    case 24: return LightSword;                 // The Light Sword
                    case 25: return DeathOfPrince;              // The Death of a Prince
                    case 26: vars.lastSplit(WWEnd); break;        // The End
                } break;

                case "Sands Trilogy (Completionist, Standard)":
                switch (timer.CurrentSplitIndex - (short)vars.offset) {
                    case 0: return Boat;                    // The Boat
                    case 1: return RavenMan;                // The Raven Man
                    case 2: return LU1;                     // Life Upgrade 1
                    case 3: return LU2;                     // Life Upgrade 2
                    case 4: return LU3;                     // Life Upgrade 3
                    case 5: return LU4;                    // Life Upgrade 4
                    case 6: return LU5;                    // Life Upgrade 5
                    case 7: return LU6;                     // Life Upgrade 6
                    case 8: return LU7;                     // Life Upgrade 7
                    case 9: return LU8;                     // Life Upgrade 8
                    case 10: return LU9;                    // Life Upgrade 9
                    case 11: return WaterSword;            // The Water Sword
                    case 12: vars.lastSplit(WWEnd); break;    // The End
                } break;

                case "Sands Trilogy (Completionist, Zipless)":
                switch (timer.CurrentSplitIndex - (short)vars.offset) {
                    case 0: return Boat;                         // The Boat
                    case 1: return RavenMan;                     // The Raven Man
                    case 2: return LU1;                          // Life Upgrade 1
                    case 3: return LU2;                          // Life Upgrade 2
                    case 4: return LU3;                          // Life Upgrade 3
                    case 5: return LU4;                          // Life Upgrade 4
                    case 6: return current.storyValue == 59;     // Mask of the Wraith (59)
                    case 7: return LU5;                          // Life Upgrade 5
                    case 8: return LU6;                          // Life Upgrade 6
                    case 9: return MechanicalTower;              // The Mechanical Tower
                    case 10: return LU7;                         // Life Upgrade 7
                    case 11: return LU8;                         // Life Upgrade 8
                    case 12: return LU9;                         // Life Upgrade 9
                    case 13: return WaterSword;                  // The Water Sword
                    case 14: vars.lastSplit(WWEnd); break;         // The End
                } break;

                case "Sands Trilogy (Completionist, No Major Glitches)":
                switch (timer.CurrentSplitIndex - (short)vars.offset) {
                    case 0: return Boat;               // The Boat
                    case 1: return SpiderSword;        // The Spider Sword
                    case 2: return LU1;                // Life Upgrade 1
                    case 3: return DamselInDistress;   // A Damsel in Distress
                    case 4: return LU2;                // Life Upgrade 2
                    case 5: return Dahaka;             // The Dahaka
                    case 6: return LU3;                // Life Upgrade 3
                    case 7: return SerpentSword;       // The Serpent Sword
                    case 8: return GardenHall;         // The Garden Hall
                    case 9: return LU4;                // Life Upgrade 4
                    case 10: return LU5;               // Life Upgrade 5
                    case 11: return LU6;               // Life Upgrade 6
                    case 12: return MechanicalTower;   // The Mechanical Tower
                    case 13: return BreathOfFate;      // Breath of Fate
                    case 14: return ActRoomRuin;       // Activation Room in Ruin
                    case 15: return LU7;               // Life Upgrade 7
                    case 16: return DeathOfSandWraith; // The Death of a Sand Wraith
                    case 17: return DeathOfTheEmpress; // Death of the Empress
                    case 18: return ExitTomb;          // Exit the Tomb
                    case 19: return ScorpionSword;     // The Scorpion Sword
                    case 20: return LU8;               // Life Upgrade 8
                    case 21: return LU9;               // Life Upgrade 9
                    case 22: return WaterSword;        // The Water Sword
                    case 23: return MaskOfWraith;      // The Mask of the Wraith
                    case 24: return SandGriffin;       // The Sand Griffin
                    case 25: return MirroredFates;     // Mirrored Fates
                    case 26: return FavorUnknown;      // A Favor Unknown
                    case 27: return LibraryRev;        // The Library Revisited
                    case 28: return LightSword;        // The Light Sword
                    case 29: return DeathOfPrince;     // The Death of a Prince
                    case 30: vars.lastSplit(WWEnd); break; // The End
                } break;
            }
            break;

        //Prince of Persia: The Two Thrones:-
        case 6:
            // Initializing T2T Splits:
            bool ArenaDeload        = vars.inPosFull(-256.1f, -251.9f, 358f, 361.5f, 53.9f, 63.3f) ? true : false;
            bool Balconies            = vars.inPosFull(-194f, -190f, 328f, 329.7f, 32.6f, 33.6f) ? true : false;
            bool BottomofWell        = vars.inPosFull(-21.35f, -21.34f, 252.67f, 252.68f, 20.95f, 20.96f) ? true : false;
            bool Brothel            = vars.inPosFull(-152.3f, -152.0f, 549.8f, 549.9f, 91.8f, 92f) ? true : false;
            bool CaveDeath            = vars.inPosFull(5.99f, 6.00f, 306.96f, 306.97f, 42f, 42.01f) ? true : false;
            bool Chariot1            = vars.inPosFull(-443.37f, -443.36f, 355.80f, 355.81f, 57.71f, 57.72f) ? true : false;
            bool CityGardens        = vars.inPosFull(-63.5f, -63.4f, 389.7f, 389.8f, 85.2f, 85.3f) ? true : false;
            bool DarkAlley            = vars.inPosFull(-114f, -110f, 328f, 338f, 55f, 59f) ? true : false;
            bool Fortress            = vars.inPosFull(-71.4f, -71.3f, 9.6f, 9.7f, 44f, 44.1f) ? true : false;
            bool HangingGardens        = vars.inPosFull(26f, 28f, 211f, 213f, 191f, 193f) ? true : false;
            bool HangingGardenz        = vars.inPosFull(5.2f, 5.4f, 213.5f, 215.6f, 194.9f, 196.2f) ? true : false;
            bool HarbourDistrict        = vars.inPosFull(-93f, -88f, 236.2f, 238f, 83f, 88f) ? true : false;
            bool KingsRoad            = vars.inPosFull(53f, 70f, 240f, 250f, 70f, 73f) ? true : false;
            bool KingsRoadZipless        = vars.inPosFull(91.9289f, 91.9290f, 230.0479f, 230.0480f, 70.9877f, 70.9879f) ? true : false;
            bool Labyrinth            = vars.inPosFull(-25.5f, -23f, 325f, 338f, 35.9f, 37.5f) ? true : false;
            bool LCRooftopZips        = vars.inPosFull(-246f, -241.5f, 373.5f, 383.6f, 66f, 69f) ? true : false;
            bool LowerCity            = vars.inPosFull(-319f, -316.5f, 317f, 332.6f, 95.1f, 98f) ? true : false;
            bool LowerCityRooftops        = vars.inPosFull(-261.5f, -261f, 318f, 319.5f, 46f, 48f) ? true : false;
            bool LowerTower            = vars.inPosFull(-5f, -3f, 316f, 317.5f, 139.9f, 140.1f) ? true : false;
            bool MarketDistrict        = vars.inPosFull(-185.5f, -175.5f, 524f, 530f, 90f, 92f) ? true : false;
            bool Marketplace        = vars.inPosFull(-213f, -207f, 484f, 490f, 101f, 103f) ? true : false;
            bool MentalRealm        = vars.inPosFull(189f, 193f, 319.135f, 320f, 542f, 543f) ? true : false;
            bool MiddleTower        = vars.inPosFull(-18f, -12f, 303f, 305f, 184.8f, 185.1f) ? true : false;
            bool Palace            = vars.inPosFull(-35.5f, -35.4f, 232.3f, 232.4f, 146.9f, 147f) ? true : false;
            bool PalaceEntrance        = vars.inPosFull(30.8f, 30.9f, 271.2f, 271.3f, 126f, 126.1f) ? true : false;
            bool Plaza            = vars.inPosFull(-104f, -100f, 548f, 553f, 105.5f, 106.1f) ? true : false;
            bool Ramparts            = vars.inPosFull(-271f, -265f, 187f, 188f, 74f, 75f) ? true : false;
            bool RoyalWorkshop        = vars.inPosFull(58f, 62f, 470f, 480f, 79f, 81f) ? true : false;
            bool SewersT2T            = vars.inPosFull(-100f, -96f, -83f, -79f, 19.9f, 20f) ? true : false;
            bool SewersZipless        = vars.inPosFull(-89.0f, -88.0f, -15.2f, -14.7f, 4.9f, 5.1f) ? true : false;
            bool StructuresMind             = vars.inPosFull(5f, 12f, 243f, 265f, 104f, 104.1f) ? true : false;
            bool StructuresMindZipless      = vars.inPosFull(-34f, -27f, 240f, 250f, 178f, 180f) ? true : false;
            bool T2TLU1                     = vars.inPosFull(-14.9972f, -14.9970f, -112.8152f, -112.8150f, 20.0732f, 20.0734f) ? true : false;
            bool T2TLU2                     = vars.inPosFull(-302.0919f, -302.0917f, 370.8710f, 370.8712f, 52.858f, 52.8582f) ? true : false;
            bool T2TLU3                     = vars.inPosFull(-187.3369f, -187.3367f, -455.9863f, 455.9865f, 78.0330f, 78.0332f) ? true : false;
            bool T2TLU4                     = vars.inPosFull(-55.0147f, -55.0145f, 395.7608f, 395.761f, 72.0774f, 72.0776f) ? true : false;
            bool T2TLU5                     = vars.inPosFull(-30.1223f, -30.1221f, 281.8893f, 281.8895f, 104.0796f, 104.0798f) ? true : false;
            bool T2TLU6                     = vars.inPosFull(-23.9663f, -23.9661f, 253.9438f, 253.944f, 183.0634f, 183.0636f) ? true : false;
            bool Temple                     = vars.inPosFull(-212.2f, -211.9f, 419.0f, 419.8f, 81f, 82f) ? true : false;
            bool TempleRooftops             = vars.inPosFull(-122.6f, -117.7f, 421.6f, 423f, 107f, 108.1f) ? true : false;
            bool Terrace                    = vars.inPosFull(-7.2f, -6.9f, 245.6f, 245.9f, 677f, 679f) ? true : false;
            bool ThePromenade               = vars.inPosFull(-3f, -1f, 515f, 519f, 72f, 75f) ? true : false;
            bool TrappedHallway             = vars.inPosFull(-52.1f, -52.0f, 135.8f, 135.9f, 75.8f, 76f) ? true : false;
            bool UndergroundCave            = vars.inPosFull(-11f, -9f, 327f, 334f, 73f, 74f) ? true : false;
            bool UndergroundCaveZipless     = vars.inPosFull(27f, 29f, 316.5f, 318f, 99.9f, 100.1f) ? true : false;
            bool UpperCity                  = vars.inPosFull(-124.5f, -122.5f, 500f, 505f, 97f, 99f) ? true : false;
            bool UpperTower                 = vars.inPosFull(-8f, -7f, 296f, 298f, 226.9f, 227f) ? true : false;
            bool WellOfAncestors            = vars.inPosFull(-12.6f, -12.5f, 241.2f, 241.3f, 0.9f, 1f) ? true : false;
            bool WellOfAncestorsZipless     = vars.inPosFull(-28f, -26.5f, 250f, 255f, 20.9f, 30f) ? true : false;

            // Checking category and qualifications to complete each split:
            switch (timer.Run.GetExtendedCategoryName()) {
                case "Anthology": case "Sands Trilogy (Any%, Standard)":
                switch (timer.CurrentSplitIndex - (short)vars.offset) {
                    case 0: return Ramparts;        // The Ramparts
                    case 1: return HarbourDistrict; // The Harbor District
                    case 2: return Palace;          // The Palace
                    case 3: return SewersT2T;       // Exit Sewers
                    case 4: return Chariot1;    // Finish Chariot 1
                    case 5: return ArenaDeload;       // Arena Deload
                    case 6: return TempleRooftops;  // Exit Temple Rooftops
                    case 7: return Marketplace;     // Exit Marketplace
                    case 8: return Plaza;           // Exit Plaza
                    case 9: return CityGardens;     // Exit City Gardens
                    case 10: return RoyalWorkshop;  // Exit Royal Workshop
                    case 11: return KingsRoad;      // The King's Road
                    case 12: return BottomofWell;     // Well Death
                    case 13: return CaveDeath;      // Cave Death
                    case 14: return UpperTower;     // The Towers
                    case 15: return Terrace;        // The Terrace
                    case 16: vars.lastSplit(MentalRealm); break; // The Mental Realm
                } break;

                case "Sands Trilogy (Any%, Zipless)":
                switch (timer.CurrentSplitIndex - (short)vars.offset) {
                    case 0: return Ramparts;                // The Ramparts
                    case 1: return HarbourDistrict;         // The Harbor District
                    case 2: return Palace;                  // The Palace
                    case 3: return TrappedHallway;          // The Trapped Hallway
                    case 4: return SewersZipless;           // The Sewers
                    case 5: return Fortress;                // The Fortress
                    case 6: return LowerCity;               // The Lower City
                    case 7: return LowerCityRooftops;       // The Lower City Rooftops
                    case 8: return Balconies;               // The Balconies
                    case 9: return DarkAlley;               // The Dark Alley
                    case 10: return TempleRooftops;         // The Temple Rooftops
                    case 11: return Marketplace;            // Exit Marketplace
                    case 12: return MarketDistrict;         // The Market District
                    case 13: return Plaza;                  // Exit Plaza
                    case 14: return UpperCity;              // The Upper City
                    case 15: return CityGardens;            // The City Gardens
                    case 16: return RoyalWorkshop;          // The Royal Workshop
                    case 17: return KingsRoadZipless;       // The King's Road
                    case 18: return PalaceEntrance;         // The Palace Entrance
                    case 19: return HangingGardenz;         // The Hanging Gardens
                    case 20: return WellOfAncestorsZipless; // The Structure's Mind
                    case 21: return WellOfAncestors;        // The Well of Ancestors
                    case 22: return Labyrinth;              // The Labyrinth
                    case 23: return LowerTower;             // The Lower Tower
                    case 24: return UpperTower;             // The Middle and Upper Towers
                    case 25: return Terrace;                // The Death of the Vizier
                    case 26: vars.lastSplit(MentalRealm); break; // The Mental Realm
                } break;

                case "Sands Trilogy (Any%, No Major Glitches)":
                switch (timer.CurrentSplitIndex - (short)vars.offset) {
                    case 0: return Ramparts;               // The Ramparts
                    case 1: return HarbourDistrict;        // The Harbor District
                    case 2: return Palace;                 // The Palace
                    case 3: return TrappedHallway;         // The Trapped Hallway
                    case 4: return SewersZipless;          // The Sewers
                    case 5: return Fortress;               // The Fortress
                    case 6: return LowerCity;              // The Lower City
                    case 7: return LowerCityRooftops;      // The Lower City Rooftops
                    case 8: return Balconies;              // The Balconies
                    case 9: return DarkAlley;              // The Dark Alley
                    case 10: return TempleRooftops;        // The Temple Rooftops
                    case 11: return Temple;                // The Temple
                    case 12: return Marketplace;           // The Marketplace
                    case 13: return MarketDistrict;        // The Market District
                    case 14: return Brothel;               // The Brothel
                    case 15: return Plaza;                 // Exit Plaza
                    case 16: return UpperCity;             // The Upper City
                    case 17: return CityGardens;           // The City Gardens
                    case 18: return ThePromenade;          // The Promenade
                    case 19: return RoyalWorkshop;         // The Royal Workshop
                    case 20: return KingsRoadZipless;      // The King's Road
                    case 21: return PalaceEntrance;        // The Palace Entrance
                    case 22: return HangingGardens;        // The Hanging Gardens
                    case 23: return StructuresMindZipless; // The Structure's Mind
                    case 24: return WellOfAncestors;       // The Well of Ancestors
                    case 25: return Labyrinth;             // The Labyrinth
                    case 26: return UndergroundCave;       // The Underground Cave
                    case 27: return LowerTower;            // The Lower Tower
                    case 28: return MiddleTower;           // The Middle Tower
                    case 29: return UpperTower;            // The Upper Tower
                    case 30: return Terrace;               // The Death of the Vizier
                    case 31: vars.lastSplit(MentalRealm); break; // The Mental Realm
                } break;

                case "Sands Trilogy (Completionist, Standard)":
                switch (timer.CurrentSplitIndex - (short)vars.offset) {
                    case 0: return Ramparts;        // The Ramparts
                    case 1: return HarbourDistrict; // The Harbor District
                    case 2: return Palace;          // The Palace
                    case 3: return T2TLU1;          // Life Upgrade 1
                    case 4: return LowerCity;       // Exit Lower City
                    case 5: return T2TLU2;          // Life Upgrade 2
                    case 6: return LCRooftopZips;   // The Arena
                    case 7: return TempleRooftops;  // The Temple Rooftops Exit
                    case 8: return T2TLU3;          // Life Upgrade 3
                    case 9: return Marketplace;     // The Marketplace
                    case 10: return Plaza;          // Exit Plaza
                    case 11: return T2TLU4;         // Life Upgrade 4
                    case 12: return RoyalWorkshop;  // The Royal Workshop
                    case 13: return KingsRoad;      // The King's Road
                    case 14: return T2TLU5;         // Life Upgrade 5
                    case 15: return BottomofWell;   // Well Death
                    case 16: return Labyrinth;      // Exit Labyrinth
                    case 17: return T2TLU6;         // Life Upgrade 6
                    case 18: return UpperTower;     // The Upper Tower
                    case 19: return Terrace;        // The Death of the Vizier
                    case 20: vars.lastSplit(MentalRealm); break; // The Mental Realm
                } break;

                case "Sands Trilogy (Completionist, Zipless)":
                switch (timer.CurrentSplitIndex - (short)vars.offset) {
                    case 0: return Ramparts;                // The Ramparts
                    case 1: return HarbourDistrict;         // The Harbor District
                    case 2: return Palace;                  // The Palace
                    case 3: return TrappedHallway;          // The Trapped Hallway
                    case 4: return T2TLU1;                  // Life Upgrade 1
                    case 5: return Fortress;                // The Fortress
                    case 6: return LowerCity;               // The Lower City
                    case 7: return T2TLU2;                  // Life Upgrade 2
                    case 8: return LowerCityRooftops;       // The Arena
                    case 9: return Balconies;               // The Balconies
                    case 10: return DarkAlley;              // The Dark Alley
                    case 11: return TempleRooftops;         // The Temple Rooftops
                    case 12: return T2TLU3;                 // Life Upgrade 3
                    case 13: return Marketplace;            // The Marketplace
                    case 14: return MarketDistrict;         // The Market District
                    case 15: return Plaza;                  // Exit Plaza
                    case 16: return UpperCity;              // The Upper City
                    case 17: return T2TLU4;                 // Life Upgrade 4
                    case 18: return RoyalWorkshop;          // The Royal Workshop
                    case 19: return KingsRoadZipless;       // The King's Road
                    case 20: return T2TLU5;                 // Life Upgrade 5
                    case 21: return HangingGardenz;         // The Hanging Gardens
                    case 22: return WellOfAncestorsZipless; // The Structure's Mind
                    case 23: return WellOfAncestors;        // The Well of Ancestors
                    case 24: return Labyrinth;              // The Labyrinth
                    case 25: return LowerTower;             // The Lower Tower
                    case 26: return T2TLU6;                 // Life Upgrade 6
                    case 27: return UpperTower;             // The Upper Tower
                    case 28: return Terrace;                // The Death of the Vizier
                    case 29: vars.lastSplit(MentalRealm); break; // The Mental Realm
                } break;

                case "Sands Trilogy (Completionist, No Major Glitches)":
                switch (timer.CurrentSplitIndex - (short)vars.offset) {
                    case 0: return Ramparts;               // The Ramparts
                    case 1: return HarbourDistrict;        // The Harbor District
                    case 2: return Palace;                 // The Palace
                    case 3: return TrappedHallway;         // The Trapped Hallway
                    case 4: return T2TLU1;                 // Life Upgrade 1
                    case 5: return Fortress;               // The Fortress
                    case 6: return LowerCity;              // The Lower City
                    case 7: return T2TLU2;                 // Life Upgrade 2
                    case 8: return LowerCityRooftops;      // The Arena
                    case 9: return Balconies;              // The Balconies
                    case 10: return DarkAlley;             // The Dark Alley
                    case 11: return TempleRooftops;        // The Temple Rooftops
                    case 12: return T2TLU3;                // Life Upgrade 3
                    case 13: return Marketplace;           // The Marketplace
                    case 14: return MarketDistrict;        // The Market District
                    case 15: return Brothel;               // The Brothel
                    case 16: return Plaza;                 // The Plaza
                    case 17: return UpperCity;             // The Upper City
                    case 18: return T2TLU4;                // Life Upgrade 4
                    case 19: return ThePromenade;          // The Promenade
                    case 20: return RoyalWorkshop;         // The Royal Workshop
                    case 21: return KingsRoadZipless;      // The King's Road
                    case 22: return T2TLU5;                // Life Upgrade 5
                    case 23: return HangingGardens;        // The Hanging Gardens
                    case 24: return StructuresMindZipless; // The Structure's Mind
                    case 25: return WellOfAncestors;       // The Well of Ancestors
                    case 26: return Labyrinth;             // The Labyrinth
                    case 27: return UndergroundCave;       // The Underground Cave
                    case 28: return LowerTower;            // The Lower Tower
                    case 29: return T2TLU6;                // Life Upgrade 6
                    case 30: return UpperTower;            // The Upper Tower
                    case 31: return Terrace;               // The Death of the Vizier
                    case 32: vars.lastSplit(MentalRealm); break; // The Mental Realm
                } break;
            }
            break;

        //Prince of Persia (2008):
        case 7:
            //Unmarking flags from previous cycle:
            bool kill = false;
            bool seedGet = false;

            //Checking and setting flags if conditions are met:
            if (old.combat == 2 && current.combat == 0) kill = true;
            if (current.seedCount == old.seedCount + 1) seedGet = true;

            // Initializing 2k8 Splits:
            bool Alchemist        = vars.splitBoss(-296.593f, 697.233f, 296.199f) ? true : false;
            bool BluePlate        = current.zPos >= 32.4 && old.zPos <= 0 ? true : false;
            bool Canyon           = vars.inXRange(-208f, -200f) && vars.inYRange(-38f, -27.5f) && current.zPos >= -511 ? true : false;
            bool Cauldron         = vars.splitSeed(107.123f, 183.394f, -5.628f) ? true : false;
            bool Cavern           = vars.splitSeed(251.741f, 65.773f, -13.616f) ? true : false;
            bool CityGate         = vars.splitSeed(547.488f, 45.41f, -27.107f) ? true : false;
            bool Concubine        = vars.splitBoss(352.792f, 801.051f, 150.260f) ? true : false;
            bool ConstructionYard = vars.splitSeed(-151.121f, 303.514f, 27.95f) ? true : false;
            bool CoronationHall   = vars.splitSeed(264.497f, 589.336f, 38.67f) ? true : false;
            bool CoronationHallH  = vars.splitBoss(340f, 582.5f, 32.5f) ? true : false;
            bool DoubleJump       = vars.inPosFull(6.12f, 6.19f, -233.49f, -225.18f, -33.01f, -32.5f) ? true : false;
            bool FirstFightSkip   = current.yPos >= -331 && vars.inZRange(-31f, -28f) ? true : false;
            bool HeavensStair     = vars.splitSeed(-85.968f, 573.338f, 30.558f) ? true : false;
            bool HeavensStairH    = vars.splitBoss(-291f, 651.5f, 99.2f) ? true : false;
            bool Hunter           = vars.splitBoss(-929.415f, 320.888f, -89.038f) ? true : false;
            bool King             = vars.splitBoss(5f, -365f, -32f) ? true : false;
            bool KingsGate        = vars.splitSeed(-538.834f, -67.159f, 12.732f) ? true : false;
            bool MachineryGround  = vars.splitSeed(-361.121f, 480.114f, 12.928f) ? true : false;
            bool MarshGrounds     = vars.splitSeed(-806.671f, 112.803f, 21.645f) ? true : false;
            bool MartyrsTower     = vars.splitSeed(-564.202f, 207.312f, 22f) ? true : false;
            bool MTtoMG           = vars.splitSeed(-454.824f, 398.571f, 27.028f) ? true : false;
            bool QueensTower      = vars.splitSeed(637.262f, 27.224f, -28.603f) ? true : false;
            bool Reservoir08      = vars.splitSeed(-150.082f, 406.606f, 34.673f) ? true : false;
            bool Resurrection     = vars.inXRange(5.562f, 5.566f) && vars.inYRange(-222.745f, -222.517f) && current.zPos >= -33.1 ? true : false;
            bool SpireOfDreams    = vars.splitSeed(-28.088f, 544.298f, 34.942f) ? true : false;
            bool SunTemple08      = vars.splitSeed(-670.471f, -56.147f, 16.46f) ? true : false;
            bool TempleArrive     = vars.inXRange(-0.5f, 12f) && current.yPos <= -234.5 && current.zPos >= -37 ? true : false;
            bool TheGod           = vars.inXRange(7.129f, 7.131f) && vars.inYRange(-401.502f, -401.5f) && current.zPos >= -31.4  ? true : false;
            bool TowerOfOrmazd    = vars.splitSeed(609.907f, 61.905f, -35.001f) ? true : false;
            bool Warrior          = vars.splitBoss(1070.478f, 279.147f, -29.571f) ? true : false;
            bool Windmills        = vars.splitSeed(-597.945f, 209.241f, 23.339f) ? true : false;
            bool YellowPlate      = vars.inXRange(6.6f, 6.8f) && vars.inYRange(-171.8f, -171.6f) && current.zPos == -49 ? true : false;

            // Checking qualifications to complete each split:
            switch (timer.CurrentSplitIndex - (short)vars.offset) {
                case 0: return FirstFightSkip;    // First Fight Skip
                case 1: return Canyon;            // The Canyon
                case 2: return KingsGate;         // King's Gate
                case 3: return SunTemple08;       // Sun Temple
                case 4: return MarshGrounds;      // Marshalling Grounds
                case 5: return Windmills;         // Windmills
                case 6: return MartyrsTower;      // Martyrs' Tower
                case 7: return MTtoMG;            // MT -> MG
                case 8: return MachineryGround;   // Machinery Ground
                case 9: return HeavensStair;      // Heaven's Stair
                case 10: return SpireOfDreams;    // Spire of Dreams
                case 11: return Reservoir08;      // Reservoir
                case 12: return ConstructionYard; // Construction Yard
                case 13: return Cauldron;         // Cauldron
                case 14: return Cavern;           // Cavern
                case 15: return CityGate;         // City Gate
                case 16: return TowerOfOrmazd;    // Tower of Ormazd
                case 17: return QueensTower;      // Queen's Tower
                case 18: return TempleArrive;     // The Temple (Arrive)
                case 19: return DoubleJump;       // Double Jump
                case 20: return YellowPlate;      // Wings of Ormazd
                case 21: return Warrior;          // The Warrior
                case 22: return CoronationHallH;  // Heal Coronation Hall
                case 23: return CoronationHall;   // Coronation Hall
                case 24: return HeavensStairH;    // Heal Heaven's Stair
                case 25: return Alchemist;        // The Alchemist
                case 26: return Hunter;           // The Hunter
                case 27: return BluePlate;        // Hand of Ormazd
                case 28: return Concubine;        // The Concubine
                case 29: return King;             // The King
                case 30: return TheGod;           // The God
                case 31: vars.lastSplit(Resurrection); break; // Resurrection
            }
            break;

        //Prince of Persia: The Forgotten Sands
        case 8:
            //Unmarking checkpoint flag from the previous cycle:
            vars.cpGet = false;

            //Checking and setting checkpoint flag:
            if (current.cpIcon >= 1) vars.cpGet = true;

            // Initializing TFS Splits:
            bool Climb            = vars.splitCP(912, 256, -56) ? true : false;
            bool CourtyardTFS     = vars.splitCP(-434, -533, -127) ? true : false;
            bool TFSEnd           = vars.splitXYZ(821, -257, -51) ? true : false;
            bool Gardens          = vars.splitCP(240, -227, -114) ? true : false;
            bool Malik            = vars.splitCP(-37, 231, -148) ? true : false;
            bool ObservatoryTFS   = vars.splitCP(-510, 460, 104) ? true : false;
            bool Possession       = vars.splitXYZ(89, -477, -83) && vars.cpGet ? true : false;
            bool PowerOfKnowledge = vars.splitCP(548, -217, 4) ? true : false;
            bool PowerOfLight     = vars.splitCP(540, -219, 6) ? true : false;
            bool PowerOfRazia     = vars.splitCP(430, 268, -99) ? true : false;
            bool PowerOfTime      = vars.splitCP(597, -217, -2) ? true : false;
            bool PowerOfWater     = vars.splitCP(519, -227, 6) ? true : false;
            bool Ratash           = vars.splitCP(-406, 403, 64) ? true : false;
            bool ReservoirTFS     = vars.splitCP(644, 385, -63) ? true : false;
            bool SewersTFS        = vars.splitCP(-228, 245, 20) ? true : false;
            bool Storm            = vars.splitCP(948, -284, 86) ? true : false;
            bool Works            = vars.splitCP(-513, -408, -167) ? true : false;

            // Checking qualifications to complete each split:
            switch (timer.CurrentSplitIndex) {
                case 0: return Malik;             // Malik
                case 1: return PowerOfTime;       // The Power of Time
                case 2: return Works;             // The Works
                case 3: return CourtyardTFS;      // The Courtyard
                case 4: return PowerOfWater;      // The Power of Water
                case 5: return SewersTFS;         // The Sewers
                case 6: return Ratash;            // Ratash
                case 7: return ObservatoryTFS;    // The Observatory
                case 8: return PowerOfLight;      // The Power of Light
                case 9: return Gardens;           // The Gardens
                case 10: return Possession;       // Possession
                case 11: return PowerOfKnowledge; // The Power of Knowledge
                case 12: return ReservoirTFS;     // The Reservoir
                case 13: return PowerOfRazia;     // The Power of Razia
                case 14: return Climb;            // The Climb
                case 15: return Storm;            // The Storm
                case 16: vars.lastSplit(TFSEnd); break; // The End
            }
            break;
    }
}
