// Game:        Prince of Persia v1.4
// Emulator:    DOSBox 0.74-3
// Created by:  ThePedMeister
// Updated by:  Karlgamer
// Updated by:  WinterThunder
// Updated:     2020-05-17
// IGT timing:  YES
//
// Base memory path is everything before final offset
// e.g. in ["DOSBox.exe", 0x193C370, 0x1D0F4] base path is the ["DOSBox.exe", 0x193C370].
//
// Base memory paths for versions:
// DOSBox 0.74:   0x193A1A0
// DOSBox 0.47-2: 0x0074F6D0
// DOSBox 0.47-3: "DOSBox.exe", 0x193C370
// 
// Note: DOSBox autosplitter breaks (doesn't find correct memory address) if you alter the dosbox.conf in a specific way.
// Known ways to break the autosplitter:
// 1. Alter the PATH system variable -> don't invoke SET PATH=xyz
// 2. Set gus=true (make sure gus is set to false)

state("DOSBOX")
{
    byte Level          : "DOSBox.exe", 0x193C370, 0x1D0F4;          // shows level 1-14 changes as door is entered
    byte Scene          : "DOSBox.exe", 0x193C370, 0x1A4BA;          // shows level 1-14 changes as scenes end 
    byte EndGame        : "DOSBox.exe", 0x193C370, 0x1D74A;          // 0 before endgame, 255 at endgame cutscene
    byte Start          : "DOSBox.exe", 0x193C370, 0x1D694;          // the level you start the game at
    byte GameRunning    : "DOSBox.exe", 0x19175EA;                   // 0 if game isn't running 
    byte MinutesLeft    : "DOSBox.exe", 0x193C370, 0x1E350;          // Minutes
    int  Count          : "DOSBox.exe", 0x193C370, 0x1E354;          // Frames
    short FrameSeconds  : "DOSBox.exe", 0x193C370, 0x1E356;          // Frames in second part of time (720-0)
    byte Sound          : "DOSBox.exe", 0x193C370, 0x2F233;          // 0 if sound is on, 1 if sound is off

}

startup
{
    refreshRate = 24; // Prince of Persia runs at 12 fps, let's update twice as often to be sure
    settings.Add("sound", false, "Sound On At Start?");
}

start
{
    // start (sound) && if starting level = 1 AND if level = 1 AND if Minutes = 60 AND count is = 47120384
    return
     ((current.Sound == 0 && settings["sound"] == true) || (settings["sound"] == false)) &&
        (current.Start == 0x1) && 
        (current.Level == 0x1) && 
        (current.MinutesLeft == 0x3C) && 
        (current.Count >= 0x2CE0000);
}

reset
{   // reset if starting level isn't 1 OR game has quit
    return 
        (current.Start == 0x0) || 
        (current.GameRunning == 0x0);
}

gameTime
{
    int minutesLeft = current.MinutesLeft - 1;
    int totalFramesLeft = (minutesLeft * 720) + current.FrameSeconds;
    int elapsedFrames = (60 * 720) - totalFramesLeft;
    double secondsElapsed = elapsedFrames / 12.0;
    //print("POPASL[gameTime]: secondsElapsed = " + secondsElapsed);
    return TimeSpan.FromSeconds(secondsElapsed);
}

split
{
    return 
        (old.Level !=  current.Level) || // if level changes
        (current.Level == 0xE && current.EndGame == 0xFF);    // if currently on level 14 and EndGame changes to 255
}