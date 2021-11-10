// Game:           Prince of Persia v1.4
// Emulator:       DOSBox 0.74-3
// DOS version by: ThePedMeister, Karlgamer, WinterThunder, Smathlax, GMP, eien86
// Apple 2 Port:   GMP
// Inspiration:    Shauing, Mattcubing
// Updated:        2021-11-10
// IGT timing:     YES
//
// Base memory path is everything before final offset
// e.g. in ["DOSBox.exe", 0x193C370, 0x1D0F4] base path is the ["DOSBox.exe", 0x193C370].
//
// Base memory paths for versions:
// AppleWin 1.30.3.0: "AppleWin.exe", 0x1F5498


state("AppleWin")
{
    byte Level      : "AppleWin.exe", 0x1F5498, 0x031C;        // shows level 1-14 changes as door is entered
    ushort Ticks    : "AppleWin.exe", 0x1F5498, 0x0306;        // Ticks one per frame, pauses during loads and resets to 0 at start of the game
    byte EndGame    : "AppleWin.exe", 0x1F5498, 0xE14A;        // Changes to 255 at the end.
    byte Reset1     : "AppleWin.exe", 0x1F5498, 0xC11E;        // Reset flags. 0 in menu and 1 during levels.
    byte Reset2     : "AppleWin.exe", 0x1F5498, 0xC158;        // ^
    byte Reset3     : "AppleWin.exe", 0x1F5498, 0xC1CB;        // ^^
}

start
{
    return(current.Level == 1 && current.Ticks == 0);
}

gameTime
{
    double minutesElapsed = current.Ticks / 725.0;
    
    if(old.Level == 13 && current.Level == 14) {
        secondsElapsed -= 0.002;   // hack for splits.io issue - if last split is empty, gametime won't be available
    }
    
    return TimeSpan.FromMinutes(minutesElapsed);
}

reset
{
    return((current.Reset1 == 0 && current.Reset2 == 0 && current.Reset3 == 0) || game.ProcessName != "AppleWin");
}

split
{
    return ((old.Level == current.Level - 1) || (current.Level == 14 && current.EndGame == 0xFF));    // if level changes or if currently on level 14 and EndGame changes to 255 (FF in hexadecimal)
    
}

isLoading
{
    return true;
}
