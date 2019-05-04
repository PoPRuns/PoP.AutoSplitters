state("pop3d"){

	int loading : 0x00091244, 0x394;
	float lXPos : 0x004062E4, 0xD0, 0xC4, 0x18, 0x44;
	float lYPos : 0x004062E4, 0xD0, 0xC4, 0x18, 0x48;
	float xPos : 0x003EF854, 0x160, 0x2F8, 0x8, 0x18, 0x44;
	float yPos : 0x003EF854, 0x160, 0x2F8, 0x8, 0x18, 0x48;
	float zPos : 0x003EF854, 0x160, 0x2F8, 0x8, 0x18, 0x4C;
}

startup{

}

init {
	timer.IsGameTimePaused = false;
	game.Exited += (s, e) => timer.IsGameTimePaused = true;
}

reset {

}

start {
	if(current.lXPos > 20.554 && current.lXPos < 20.556){
		return true;
	}
}

isLoading{
	if(current.xPos == 0 && current.yPos == 0 && current.zPos == 0){
	return true;
	}else{
		return false;
	}
}

split{
	
}
