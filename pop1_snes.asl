// Game:           		Prince of Persia SNES
// Emulator:       		snes9x 1.60 [x64]
// Original by:    		ThePedMeister, Karlgamer, WinterThunder, Smathlax, GMP & eien86 (DOS version)
// Adapted to SNES by:	Shauing, GMP
// Date:        		2021-11-21
//
// Base memory path is everything before final offset
// e.g. in ["snes9x-x64.exe", 0x08D8C38, 0x0579] base path is the ["snes9x-x64.exe", 0x22ABFD0].
//
// Base memory paths for versions:
// snes9x-x64:	0x22ABFD0

state("snes9x-x64")
{
    byte Level          : "snes9x-x64.exe", 0x08D8C38, 0x0544;          // next level - shows level 1-20 changes as door is entered
    byte Menu           : "snes9x-x64.exe", 0x08D8C38, 0xE0C8;          // 180 in menu and 0 when game start is clicked
    byte Jaffar         : "snes9x-x64.exe", 0x08D8C38, 0x050B;          // Jaffar HP
    byte Scene          : "snes9x-x64.exe", 0x08D8C38, 0x0579;          // current level - shows level 1-20 changes as scenes end 
    byte Hourglass      : "snes9x-x64.exe", 0x08D8C38, 0x0629;          // hourglass present - 2 if present, 0 otherwise [If you interrupt the intro before the hourglass appears then it stays 0 until the next cutscene]
    byte Cutscene       : "snes9x-x64.exe", 0x08D8C38, 0x0A84;          // current cutscene - 06 = bad ending, 07 = good ending. It stays so even after the cutscene ends
    byte Start          : "snes9x-x64.exe", 0x08D8C38, 0x0E5D;          // decoded level - level number decoded from an entered password; it stays 00 if you start the training so it's not exactly the same as the DOS variable
    ushort FrameCount   : "snes9x-x64.exe", 0x08D8C38, 0x052D;			// number of elapsed ticks - 1 minute = 0x1A9 (425) ticks, 1 second = 7 ticks
    byte CharScrn       : "snes9x-x64.exe", 0x08D8C38, 0x0462;          // character screen
    byte MsgTimer       : "snes9x-x64.exe", 0x08D8C38, 0x0518;          // message timer
    byte Checkpoint     : "snes9x-x64.exe", 0x08D8C38, 0x0627;          // checkpoint on/off
    
    int SNbelow         : "snes9x-x64.exe", 0x08D8C38, 0x0605;          // variables that cover one of the arrays used for collision detection.
    int SNbelowplus4    : "snes9x-x64.exe", 0x08D8C38, 0x0609;          // SNbelow+4
    short SNbelowplus8  : "snes9x-x64.exe", 0x08D8C38, 0x060D;          // SNbelow+8
}

reset
{
    return (old.Menu != 180 && current.Menu == 180 && current.Level == 0);
}

start
{
    // start when menu goes from 180 to 0
    vars.JaffarDied = false;
    return (old.Menu == 180 && current.Menu == 0);
}

split
{
    if(current.Level == 20 && old.Jaffar != 0 && current.Jaffar == 0){
        vars.JaffarDied = true;
    }
    bool skipSplit = ((old.Level == 19 && !vars.JaffarDied) || (old.Level == 20 && current.Level == 19));
    return((old.Level == current.Level - 1) && !skipSplit);
}
