state("prince of persia"){
	float xPos : 0xDA4D20;
	float yPos : 0xDA4D24;
	float zPos : 0xDA4D28;
	int gameState : 0x00DA52EC, 0x18, 0xF8, 0x150;
	int cpIcon : 0x00064D34, 0x0, 0x0, 0x24, 0x18, 0x50, 0x870;
	int isMenu : 0xDA2F70;
	bool isLoading: "", 0x00DA5724, 0x50;
}

init{
    timer.IsGameTimePaused = false;
	game.Exited += (s, e) => timer.IsGameTimePaused = true;
}

isLoading
{
	
	if(current.isMenu == 0 || current.isLoading){
		return true;
	}
	return false;
}

startup{	
//Delcaring flags & targets.
	bool cpGet = false;
	bool startUp = false;
	int xTarget = 0;
	int yTarget = 0;
	int zTarget = 0;
} 

//When the Prince's x coordinate is set after loading into the first cutscene, reset.
reset {
	if(current.xPos <= 268.93 && current.xPos >= 268.929 && current.gameState == 1){
		return true;
	}
}

//When the Prince is in the starting position and a cutscene has just been skipped, start.
start {
	if(current.xPos <= 268.93 && current.xPos >= 268.929 && current.gameState == 4){
		return true;
}

//Initializing flags & targets.
	vars.cpGet = false;
	vars.startUp = true;
	vars.xTarget = 0;
	vars.yTarget = 0;
	vars.zTarget = 0;
	

}

split{
//Initializing flags & targets in the event the start function wasn't used.
	if(!vars.startUp){
	vars.cpGet = false;
	vars.startUp = true;
	vars.xTarget = 0;
	vars.yTarget = 0;
	vars.zTarget = 0;
	}
//Setting cpGet to true any time you acquire a checkpoint.
	if(current.cpIcon >= 1){
		vars.cpGet = true;
	}
//In the case of each split, looking for qualifications to complete the split.
switch (timer.CurrentSplitIndex)
			{
				case 0: //Malik
					vars.xTarget = -37;
					vars.yTarget = 231;
					vars.zTarget = -148;
					if(current.xPos <= (vars.xTarget+10) && current.xPos >= (vars.xTarget-10) && current.yPos <= (vars.yTarget+10) && current.yPos >= (vars.yTarget-10) && current.zPos <= (vars.zTarget+10) && current.zPos >= (vars.zTarget-10) && vars.cpGet)
						return true;
					break;
				case 1: //The Power of Time
					vars.xTarget = 597;
					vars.yTarget = -217;
					vars.zTarget = -2;
					if(current.xPos <= (vars.xTarget+10) && current.xPos >= (vars.xTarget-10) && current.yPos <= (vars.yTarget+10) && current.yPos >= (vars.yTarget-10) && current.zPos <= (vars.zTarget+10) && current.zPos >= (vars.zTarget-10) && vars.cpGet)
						return true;
					break;
				case 2: //The Works
					vars.xTarget = -513;
					vars.yTarget = -408;
					vars.zTarget = -167;
					if(current.xPos <= (vars.xTarget+10) && current.xPos >= (vars.xTarget-10) && current.yPos <= (vars.yTarget+10) && current.yPos >= (vars.yTarget-10) && current.zPos <= (vars.zTarget+10) && current.zPos >= (vars.zTarget-10) && vars.cpGet)
						return true;
					break;
				case 3: //The Courtyard
					vars.xTarget = -434;
					vars.yTarget = -533;
					vars.zTarget = -127;
					if(current.xPos <= (vars.xTarget+10) && current.xPos >= (vars.xTarget-10) && current.yPos <= (vars.yTarget+10) && current.yPos >= (vars.yTarget-10) && current.zPos <= (vars.zTarget+10) && current.zPos >= (vars.zTarget-10) && vars.cpGet)
						return true;
					break;
				case 4: //The Power of Water
					vars.xTarget = 519;
					vars.yTarget = -227;
					vars.zTarget = 6;
					if(current.xPos <= (vars.xTarget+10) && current.xPos >= (vars.xTarget-10) && current.yPos <= (vars.yTarget+10) && current.yPos >= (vars.yTarget-10) && current.zPos <= (vars.zTarget+10) && current.zPos >= (vars.zTarget-10) && vars.cpGet)
						return true;
					break;
				case 5: //The Sewers
					vars.xTarget = -228;
					vars.yTarget = 245;
					vars.zTarget = 20;
					if(current.xPos <= (vars.xTarget+10) && current.xPos >= (vars.xTarget-10) && current.yPos <= (vars.yTarget+10) && current.yPos >= (vars.yTarget-10) && current.zPos <= (vars.zTarget+10) && current.zPos >= (vars.zTarget-10) && vars.cpGet)
						return true;
					break;
				case 6: //Ratash
					vars.xTarget = -406;
					vars.yTarget = 403;
					vars.zTarget = 64;
					if(current.xPos <= (vars.xTarget+10) && current.xPos >= (vars.xTarget-10) && current.yPos <= (vars.yTarget+10) && current.yPos >= (vars.yTarget-10) && current.zPos <= (vars.zTarget+10) && current.zPos >= (vars.zTarget-10) && vars.cpGet)
						return true;
					break;
				case 7: //The Observatory
					vars.xTarget = -510;
					vars.yTarget = 460;
					vars.zTarget = 104;
					if(current.xPos <= (vars.xTarget+10) && current.xPos >= (vars.xTarget-10) && current.yPos <= (vars.yTarget+10) && current.yPos >= (vars.yTarget-10) && current.zPos <= (vars.zTarget+10) && current.zPos >= (vars.zTarget-10) && vars.cpGet)
						return true;
					break;
				case 8: //The Power of Light
					vars.xTarget = 540;
					vars.yTarget = -219;
					vars.zTarget = 6;
					if(current.xPos <= (vars.xTarget+10) && current.xPos >= (vars.xTarget-10) && current.yPos <= (vars.yTarget+10) && current.yPos >= (vars.yTarget-10) && current.zPos <= (vars.zTarget+10) && current.zPos >= (vars.zTarget-10) && vars.cpGet)
						return true;
					break;
				case 9: //The Gardens
					vars.xTarget = 240;
					vars.yTarget = -227;
					vars.zTarget = -114;
					if(current.xPos <= (vars.xTarget+10) && current.xPos >= (vars.xTarget-10) && current.yPos <= (vars.yTarget+10) && current.yPos >= (vars.yTarget-10) && current.zPos <= (vars.zTarget+10) && current.zPos >= (vars.zTarget-10) && vars.cpGet)
						return true;
					break;
				case 10: //Possession
					vars.xTarget = 89;
					vars.yTarget = -477;
					vars.zTarget = -83;
					if(current.xPos <= (vars.xTarget+1) && current.xPos >= (vars.xTarget-1) && current.yPos <= (vars.yTarget+1) && current.yPos >= (vars.yTarget-1) && current.zPos <= (vars.zTarget+1) && current.zPos >= (vars.zTarget-1) && vars.cpGet)
						return true;
					break;
				case 11: //The Power of Knowledge
					vars.xTarget = 548;
					vars.yTarget = -217;
					vars.zTarget = 4;
					if(current.xPos <= (vars.xTarget+10) && current.xPos >= (vars.xTarget-10) && current.yPos <= (vars.yTarget+10) && current.yPos >= (vars.yTarget-10) && current.zPos <= (vars.zTarget+10) && current.zPos >= (vars.zTarget-10) && vars.cpGet)
						return true;
					break;
				case 12: //The Reservoir
					vars.xTarget = 644;
					vars.yTarget = 385;
					vars.zTarget = -63;
					if(current.xPos <= (vars.xTarget+10) && current.xPos >= (vars.xTarget-10) && current.yPos <= (vars.yTarget+10) && current.yPos >= (vars.yTarget-10) && current.zPos <= (vars.zTarget+10) && current.zPos >= (vars.zTarget-10) && vars.cpGet)
						return true;
					break;
				case 13: //The Power of Razia
					vars.xTarget = 430;
					vars.yTarget = 268;
					vars.zTarget = -99;
					if(current.xPos <= (vars.xTarget+10) && current.xPos >= (vars.xTarget-10) && current.yPos <= (vars.yTarget+10) && current.yPos >= (vars.yTarget-10) && current.zPos <= (vars.zTarget+10) && current.zPos >= (vars.zTarget-10) && vars.cpGet)
						return true;
					break;
				case 14: //The Climb
					vars.xTarget = 912;
					vars.yTarget = 256;
					vars.zTarget = -56;
					if(current.xPos <= (vars.xTarget+10) && current.xPos >= (vars.xTarget-10) && current.yPos <= (vars.yTarget+10) && current.yPos >= (vars.yTarget-10) && current.zPos <= (vars.zTarget+10) && current.zPos >= (vars.zTarget-10) && vars.cpGet)
						return true;
					break;
				case 15: //The Storm
					vars.xTarget = 948;
					vars.yTarget = -284;
					vars.zTarget = 86;
					if(current.xPos <= (vars.xTarget+10) && current.xPos >= (vars.xTarget-10) && current.yPos <= (vars.yTarget+10) && current.yPos >= (vars.yTarget-10) && current.zPos <= (vars.zTarget+10) && current.zPos >= (vars.zTarget-10) && vars.cpGet)
						return true;
					break;
				case 16: //The End
					vars.xTarget = 821;
					vars.yTarget = -257;
					vars.zTarget = -51;
					if(current.xPos <= (vars.xTarget+1) && current.xPos >= (vars.xTarget-1) && current.yPos <= (vars.yTarget+1) && current.yPos >= (vars.yTarget-1) && current.zPos <= (vars.zTarget+1) && current.zPos >= (vars.zTarget-1))
						return true;
					break;

				
			}
			
//Unmarking flags at the end of each cycle.
	vars.cpGet = false;
}
