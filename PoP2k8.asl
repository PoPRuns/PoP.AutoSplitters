state("PrinceOfPersia_Launcher"){

	int seedCount : 0x00B37F64, 0xDC;
	float xPos : 0x00B30D08, 0x40;
	float yPos : 0x00B30D08, 0x44;
	float zPos : 0x00B30D08, 0x48;
	int combat : 0x00B37F6C, 0xE0, 0x1C, 0xC, 0x7CC;
}

startup{
	bool kill = false;
	bool startUp = false;
}

init {
	
}

reset {
	if(old.xPos != -465 && current.xPos == -465){
		return true;
	}
}
start {
	
	if(old.xPos != -351 && current.yPos == -351){
	return true;
}

	vars.kill = false;
	vars.startUp = true;
	

}

split{
	
	if(!vars.startUp){
		vars.kill = false;
		vars.startUp = true;
	}
	
	if(old.combat == 2 && current.combat == 0){
		vars.kill = true;
	}
	
switch (timer.CurrentSplitIndex)
			{
				case 0:
					if (current.zPos >= -31 && current.zPos <= -28 && current.yPos >= -331)
						return true;
					break;
				case 1:
					if (current.xPos <= -200 && current.xPos >= -208 && current.yPos <= -27.5 && current.yPos >= -38 && current.zPos >= -511)
						return true;
					break;
				case 2:
					if(current.seedCount == 43)
						return true;
					break;
				case 3:
					if(current.seedCount == 56)
						return true;
					break;
				case 4:
					if(current.seedCount == 83)
						return true;
					break;
				case 5:
					if(current.seedCount == 119)
						return true;
					break;
				case 6:
					if(current.seedCount == 148)
						return true;
					break;					
				case 7:
					if(current.seedCount == 159)
						return true;
					break;
				case 8:
					if(current.seedCount == 184)
						return true;
					break;
				case 9:
					if(current.seedCount == 207)
						return true;
					break;
				case 10:
					if(current.seedCount == 235)
						return true;
					break;
				case 11:
					if(current.seedCount == 250)
						return true;
					break;
				case 12:
					if(current.seedCount == 280)
						return true;
					break;
				case 13:
					if(current.seedCount == 303)
						return true;
					break;
				case 14:
					if(current.seedCount == 346)
						return true;
					break;
				case 15:
					if(current.seedCount == 364)
						return true;
					break;
				case 16:
					if(current.seedCount == 385)
						return true;
					break;
				case 17:
					if(current.yPos <= -234.5 && current.zPos >= -33.1 && current.xPos >= 3.9 && current.xPos <= 8)
						return true;
					break;
				case 18:
					if(current.xPos <= 6.19 && current.xPos >= 6.12 && current.yPos >= -233.49 && current.yPos <= -225.18 && current.zPos >= -33.01 && current.zPos <= -32.5)
						return true;
					break;
				case 19:
					if(current.xPos >= 6.6 && current.xPos <= 6.8 && current.yPos >= -171.8 && current.yPos <= -171.6 && current.zPos == -49)
						return true;
					break;
				case 20:
					if(current.seedCount == 410)
						return true;
					break;
				case 21:
					if(current.xPos <= 815 && current.xPos >= 795 && current.yPos <= 105 && current.yPos >= 95 && current.zPos >= -42.6 && vars.kill)
						return true;
					break;
				case 22:
					if(current.seedCount == 455)
						return true;
					break;
				case 23:
					if(current.seedCount == 480)
						return true;
					break;
				case 24:
					if(current.xPos >= 328 && current.xPos <= 352 && current.yPos >= 570 && current.yPos <= 595 && current.zPos >= 32.4 && vars.kill)
						return true;
					break;
				case 25:
					if(current.seedCount == 518)
						return true;
					break;
				case 26:
					if(current.xPos >= -322 && current.xPos <= -260 && current.yPos >= 628 && current.yPos <= 675 && current.zPos >= 99.2 && vars.kill)
						return true;
					break;
				case 27:
					if(old.zPos <= 0 && current.zPos >= 99.2)
						return true;
					break;
				case 28:
					if(current.seedCount == 565)
						return true;
					break;
				case 29:
					if(current.seedCount == 590)
						return true;
					break;
				case 30:
					if(current.xPos <= 20 && current.xPos >= -10 && current.yPos >= -375 && current.yPos <= -355 && current.zPos <= -32 && vars.kill)
						return true;
					break;
				case 31:
					if(current.xPos <= 7.131 && current.xPos >= 7.129 && current.yPos >= -401.502 && current.yPos <= -401.5 && current.zPos >= -31.4)
						return true;
					break;
				case 32:
					if(current.xPos <= 5.566 && current.xPos >= 5.562 && current.yPos >= -222.745 && current.yPos <= -222.517 && current.zPos >= -33.1)
						return true;
					break;
				
			}
			
			vars.kill = false;
}
