state("DOSBox")
{
    byte Level : 0x193C370, 0x3A72C;
	short FrameCount : 0x193C370, 0x3A744;
	byte GameRunning : 0x19175EA;
 
}

startup{
    refreshRate = 24; 
}

start{
	if(old.FrameCount == 0 && current.FrameCount > 0){
		return true;
	}
}

reset{
	if(current.GameRunning == 0)
		return true;
}

split{
    return (old.Level == current.Level-1);
}

gameTime{
	return TimeSpan.FromSeconds(current.FrameCount/9.75);
}

isLoading{
	return true;
}