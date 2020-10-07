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


isLoading{
	if(current.isMenu == 0 || current.isLoading)
		return true;
	return false;
}


startup{	
//Delcaring flags & targets.
	bool cpGet = false;
} 


//When the Prince's x coordinate is set after loading into the first cutscene, reset.
reset{	
	if(current.xPos <= 268.93 && current.xPos >= 268.929 && current.gameState == 1)
		return true;
}


//When the Prince is in the starting position and a cutscene has just been skipped, start.
start{	
	if(current.xPos <= 268.93 && current.xPos >= 268.929 && current.gameState == 4)
		return true;
}


split{
//List of TFS splits
	vars.SplitTFScp = (Func <int, int, int, bool>)((xTarg, yTarg, zTarg) => {				//This is a standard type of split which occurs when the prince is within a certain range of coords and a checkposhort is just acquired
		if(current.xPos <= (xTarg+10) && current.xPos >= (xTarg-10) &&
		   current.yPos <= (yTarg+10) && current.yPos >= (yTarg-10) &&
		   current.zPos <= (zTarg+10) && current.zPos >= (zTarg-10) &&
		   vars.cpGet)
			return true;		
		return false;
	});
	vars.Possession = (Func <int, int, int, bool>)((xTarg, yTarg, zTarg) => {				//This is exactly same as above but the trigger size is reduced as there is another cp very close
		if(current.xPos <= (xTarg+1) && current.xPos >= (xTarg-1) &&
		   current.yPos <= (yTarg+1) && current.yPos >= (yTarg-1) &&
		   current.zPos <= (zTarg+1) && current.zPos >= (zTarg-1) &&
		   vars.cpGet)
			return true;		
		return false;
	});
	vars.TheEnd = (Func <int, int, int, bool>)((xTarg, yTarg, zTarg) => {					//This is a purely location based split
		if(current.xPos <= (xTarg+1) && current.xPos >= (xTarg-1) &&
		   current.yPos <= (yTarg+1) && current.yPos >= (yTarg-1) &&
		   current.zPos <= (zTarg+1) && current.zPos >= (zTarg-1))
			return true;		
		return false;
	});
	
	
//Unmarking flags from the previous cycle:
	vars.cpGet = false;

//Setting cpGet to true any time you acquire a checkpoint:
	if(current.cpIcon >= 1)
		vars.cpGet = true;
	
//In the case of each split, looking for qualifications to complete the split:
	switch (timer.CurrentSplitIndex)
	{
		case 0: return vars.SplitTFScp(-37, 231, -148);			//Malik
		case 1: return vars.SplitTFScp(597, -217, -2);			//The Power of Time
		case 2: return vars.SplitTFScp(-513, -408, -167);		//The Works
		case 3: return vars.SplitTFScp(-434, -533, -127);		//The Courtyard
		case 4: return vars.SplitTFScp(519, -227, 6);			//The Power of Water
		case 5: return vars.SplitTFScp(-228, 245, 20);			//The Sewers
		case 6: return vars.SplitTFScp(-406, 403, 64);			//Ratash
		case 7: return vars.SplitTFScp(-510, 460, 104);			//The Observatory
		case 8: return vars.SplitTFScp(540, -219, 6);			//The Power of Light
		case 9: return vars.SplitTFScp(240, -227, -114);		//The Gardens
		case 10: return vars.Possession(89, -477, -83);			//Possession
		case 11: return vars.SplitTFScp(548, -217, 4);			//The Power of Knowledge
		case 12: return vars.SplitTFScp(644, 385, -63);			//The Reservoir
		case 13: return vars.SplitTFScp(430, 268, -99);			//The Power of Razia
		case 14: return vars.SplitTFScp(912, 256, -56);			//The Climb
		case 15: return vars.SplitTFScp(948, -284, 86);			//The Storm
		case 16: return vars.TheEnd(821, -257, -51);			//The End
	}
}
