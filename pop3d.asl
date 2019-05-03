state("pop3d"){

	int loading : 0x00091244, 0x394;
	float xLPos : 0x003F93CC, 0x34, 0x2A4, 0x0, 0x2C, 0x44;
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
	if(old.xLPos != 22 && current.xLPos == 22){
		return true;
	}
}

start {
	if(current.xLPos > 20.554 && current.xLPos < 20.556){
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
