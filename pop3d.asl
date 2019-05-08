state("pop3d"){

	int health : 0x004062E4, 0x130;
	int eHealth : 0x3FBC84;
	float lXPos : 0x004062E4, 0xD0, 0xC4, 0x18, 0x44;
	float lYPos : 0x004062E4, 0xD0, 0xC4, 0x18, 0x48;
	float lZPos : 0x004062E4, 0xD0, 0xC4, 0x18, 0x4C;
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
	if(current.lXPos == 22 && current.lYPos < 0.01 && current.lYPos > 0.001){
		return true;
}
}

start {
	if(current.lXPos > 20.554 && current.lXPos < 20.556 && current.lZPos > 1.448 && current.lZPos < 1.45){
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
	switch (timer.CurrentSplitIndex)
			{
				case 0:
					if (old.lYPos == 0 && current.lYPos == -2)
						return true;
					break;
				case 1:
					if (old.lXPos == 0 && current.lXPos > 13.485 && current.lXPos < 13.487)
						return true;
					break;
				case 2:
					if (old.lXPos == 0 && current.lXPos > 216.904 && current.lXPos < 216.906)
						return true;
					break;
				case 3:
					if (old.lXPos == 0 && current.lXPos == -7)
						return true;
					break;
				case 4:
					if (old.lYPos == 0 && current.lYPos == -23)
						return true;
					break;
				case 5:
					if (current.lXPos == 0 && current.lYPos == 0 && current.lZPos == 0 && old.health == 0 && current.health != 0)
						return true;
					break;
				case 6:
					if (old.lXPos == 0 && current.lXPos == -42)
						return true;
					break;
				case 7:
					if (old.lYPos == 0 && current.lYPos == -20)
						return true;
					break;
				case 8:
					if (old.lYPos == 0 && current.lYPos == 99)
						return true;
					break;
				case 9:
					if (old.lYPos == 0 && current.lYPos > -77.77 && current.lYPos < -77.75)
						return true;
					break;
				case 10:
					if (old.lYPos == 0 && current.lYPos == 103)
						return true;
					break;
				case 11:
					if (old.lYPos == 0 && current.lYPos == 61)
						return true;
					break;
				case 12:
					if (old.lYPos == 0 && current.lYPos == -85)
						return true;
					break;
				case 13:
					if (old.lYPos == 0 && current.lYPos > -2.36 && current.lYPos < -2.34)
						return true;
					break;
				case 14:
					if (old.lYPos == 0 && current.lYPos > -19.966 && current.lYPos < -19.964)
						return true;
					break;
				case 15:
					if (old.lYPos == 0 && current.lYPos > -27.4 && current.lYPos < -27.38)
						return true;
					break;
				case 16:
					if(current.xPos == 0 && current.yPos == 0 && current.zPos == 0 && current.eHealth ==0)
						return true;
					break;
			}

}
