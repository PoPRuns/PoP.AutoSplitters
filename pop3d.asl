state("pop3d"){

	int loading : 0x00091244, 0x394;
	int xPos : 0x003EF854, 0x160, 0x2F8, 0x8, 0x18, 0x44;
	int yPos : 0x003EF854, 0x160, 0x2F8, 0x8, 0x18, 0x48;
	int zPos : 0x003EF854, 0x160, 0x2F8, 0x8, 0x18, 0x4C;
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
