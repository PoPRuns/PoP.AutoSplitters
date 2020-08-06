state("DOSBox")
{
    byte Level : 0x193C370, 0x3A72C;
	byte Start : 0x193C370, 0x3AFEC;
	short FrameCount : 0x193C370, 0x3A744;
	byte GameRunning : 0x19175EA;
}

startup{
	short ResetDelta = 0;
	bool Resetting = false;
    refreshRate = 24; 
}

start{
	if(current.Start == 238){
		vars.ResetDelta = current.FrameCount;
		return true;
	}
	vars.ResetDelta = 0;
	vars.Resetting = false;
}

reset{
	if(current.Start == 238 && vars.Resetting == false && current.Level == 1){
		vars.Resetting = true;
		return true;
	}
}

split{
	if(current.Start == 231){
		vars.Resetting = false;
	}
	
    return (old.Level == current.Level-1);
}

gameTime{
	return TimeSpan.FromSeconds((current.FrameCount-vars.ResetDelta)/12);
}

isLoading{
	return true;
}
 
