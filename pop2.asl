state("DOSBox")
{
    byte Level          : 0x193C370, 0x38796;
    byte Start          : 0x193C370, 0x38FF2;
    short FrameCount    : 0x193C370, 0x387B0;
    byte GameRunning    : 0x19175EA;
}

startup
{
    refreshRate = 24;
    
    if (timer.CurrentTimingMethod != TimingMethod.GameTime) {
        DialogResult mbox = MessageBox.Show(timer.Form,
        "This game uses an in-game timer as the primary timing method.\nWould you like to switch to Game Time?",
        "LiveSplit | Prince of Persia 2",
        MessageBoxButtons.YesNo);

        if (mbox == DialogResult.Yes) {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

start
{
    if (current.Start == 238 && current.Level == 1) {
        vars.ResetDelta = current.FrameCount;
        return true;
    }
    vars.ResetDelta = 0;
    vars.RestartDelta = 0;
    vars.CorrectFrames = 0;
    vars.Resetting = false;
}

reset
{
    if (current.Start == 238 && vars.Resetting == false && current.Level == 1) {
        vars.Resetting = true;
        vars.RestartDelta = 0;
        return true;
    }
}

split
{
    if (current.Start == 231) {
        vars.Resetting = false;
    }

    if (old.GameRunning != 0 && current.GameRunning == 0) {
        vars.RestartDelta += current.FrameCount;
    }

    if ((old.Level == current.Level-1) && current.Level > 1) {
        return true;
    }
}

gameTime
{
    vars.CorrectFrames = current.FrameCount - vars.ResetDelta + vars.RestartDelta;

    if (current.GameRunning == 0) {
        vars.CorrectFrames = vars.RestartDelta - vars.ResetDelta;
    }

    return TimeSpan.FromSeconds((vars.CorrectFrames) / 12.0);
}

isLoading
{
    return true;
}
