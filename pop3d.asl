state("pop3d"){

	int loading : 0x00091244, 0x394;
	int xPos : 0x003F93CC, 0x34, 0x2A4, 0x0, 0x2C, 0x44;
	int yPos : 0x003F93CC, 0x34, 0x2A4, 0x0, 0x2C, 0x48;
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
	if(current.loading == 2 || (current.xPos == 0 && current.yPos == 0)){
	return true;
	}else{
		return false;
	}
}

split{
	

}
