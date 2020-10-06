state("PrinceOfPersia_Launcher"){
	int seedCount : 0x00B37F64, 0xDC;
	float xPos : 0x00B30D08, 0x40;
	float yPos : 0x00B30D08, 0x44;
	float zPos : 0x00B30D08, 0x48;
	int combat : 0x00B37F6C, 0xE0, 0x1C, 0xC, 0x7CC;
}


startup{	
//Delcaring flags & targets
	bool kill = false;
	bool seedGet = false;
	bool startUp = false;
}


//When the Prince's x coordinate is set after loading into the Canyon, reset.
reset{
	if(old.xPos != -465 && current.xPos == -465)
		return true;
}


//When the Prince's y coordinate is set after loading into the Canyon, start.
start{
	if(old.yPos != -351 && current.yPos == -351)
		return true;

	//Initializing flags & targets.
	vars.kill = false;
	vars.seedGet = false;
	vars.startUp = true;
}


split{
//List of splits functions
vars.SplitSeed = (Func <float, float, float, bool>)((float xTarg, float yTarg, float zTarg) => {								//This is a standard type of split which occurs when the prince is within a certain range of coords and has just got a seed
		if(current.xPos <= (xTarg+2) && current.xPos >= (xTarg-2) &&
		   current.yPos <= (yTarg+2) && current.yPos >= (yTarg-2) &&
		   current.zPos <= (zTarg+2) && current.zPos >= (zTarg-2) &&
		   vars.seedGet)
			return true;		
		return false;
	});
	vars.SplitBoss = (Func <float, float, float, float, bool>)((float xTarg, float yTarg, float zTarg, float size) => {		//This is a standard type of split which occurs when the prince is within a platform and has just killed a boss
		if(current.xPos <= (xTarg+size) && current.xPos >= (xTarg-size) &&
		   current.yPos <= (yTarg+size) && current.yPos >= (yTarg-size) &&
		   current.zPos <= (zTarg+2) && current.zPos >= (zTarg-2) &&
		   vars.kill)
			return true;		
		return false;
	});
//List of purely locaion based splits
	vars.FirstFightSkip = (Func <bool>)(() => {
		if(current.zPos >= -31 && current.zPos <= -28 &&
		   current.yPos >= -331)
			return true;		
		return false;
	});
	vars.Canyon = (Func <bool>)(() => {
		if(current.xPos <= -200 && current.xPos >= -208 &&
		   current.yPos <= -27.5 && current.yPos >= -38 &&
		   current.zPos >= -511)
			return true;		
		return false;
	});
	vars.TempleArrive = (Func <bool>)(() => {
		if(current.xPos >= -0.5 && current.xPos <= 12 &&
		   current.yPos <= -234.5 && current.zPos >= -37)
			return true;		
		return false;
	});	
	vars.DoubleJump = (Func <bool>)(() => {
		if(current.xPos <= 6.19 && current.xPos >= 6.12 &&
		   current.yPos >= -233.49 && current.yPos <= -225.18 &&
		   current.zPos >= -33.01 && current.zPos <= -32.5)
			return true;		
		return false;
	});			
	vars.YellowPlate = (Func <bool>)(() => {
		if(current.xPos >= 6.6 && current.xPos <= 6.8 &&
		   current.yPos >= -171.8 && current.yPos <= -171.6 &&
		   current.zPos == -49)
			return true;		
		return false;
	});	
	vars.BluePlate = (Func <bool>)(() => {
		if(old.zPos <= 0 && current.zPos >= 32.4)
			return true;		
		return false;
	});
	vars.TheGod = (Func <bool>)(() => {
		if(current.xPos <= 7.131 && current.xPos >= 7.129 &&
		   current.yPos >= -401.502 && current.yPos <= -401.5 &&
		   current.zPos >= -31.4)
			return true;		
		return false;
	});
	vars.Resurrection = (Func <bool>)(() => {
		if(current.xPos <= 5.566 && current.xPos >= 5.562 &&
		   current.yPos >= -222.745 && current.yPos <= -222.517 &&
		   current.zPos >= -33.1)
			return true;		
		return false;
	});
	
//Initializing flags & targets in the event the start function wasn't used.
	if(!vars.startUp)
	{
		vars.kill = false;
		vars.seedGet = false;
		vars.startUp = true;
	}
	
//Setting kill to true any time you exit combat:
	if(old.combat == 2 && current.combat == 0)
	{
		vars.kill = true;
	}
	
//Setting seedGet to true any time you collect a seed.
	if(current.seedCount == old.seedCount+1)
	{
		vars.seedGet = true;
	}

//In the case of each split, looking for qualifications to complete the split. There are three kinds of splits in this script.
//Location Based: If you're inside the outlined zone, the split fires.
//Seed Based: If you're inside the outlined zone AND collect a seed, the split fires.
//Combat Based: If you're inside the outlined zone AND exit combat, the split fires.

	switch (timer.CurrentSplitIndex)
	{
		case 0: return vars.FirstFightSkip();					//First Fight Skip	
		case 1: return vars.Canyon();						//The Canyon
		case 2: return vars.SplitSeed(-538.834f, -67.159f, 12.732f);		//King's Gate
		case 3: return vars.SplitSeed(-670.471f, -56.147f, 16.46f);		//Sun Temple
		case 4: return vars.SplitSeed(-806.671f, 112.803f, 21.645f);		//Marshalling Grounds
		case 5: return vars.SplitSeed(-597.945f, 209.241f, 23.339f);		//Windmills
		case 6: return vars.SplitSeed(-564.202f, 207.312f, 22f);		//Martyrs' Tower
		case 7: return vars.SplitSeed(-454.824f, 398.571f, 27.028f);		//MT -> MG
		case 8: return vars.SplitSeed(-361.121f, 480.114f, 12.928f);		//Machinery Ground
		case 9: return vars.SplitSeed(-85.968f, 573.338f, 30.558f);		//Heaven's Stair
		case 10: return vars.SplitSeed(-28.088f, 544.298f, 34.942f);		//Spire of Dreams
		case 11: return vars.SplitSeed(-150.082f, 406.606f, 34.673f);		//Reservoir
		case 12: return vars.SplitSeed(-151.121f, 303.514f, 27.95f);		//Construction Yard
		case 13: return vars.SplitSeed(107.123f, 183.394f, -5.628f);		//Cauldron
		case 14: return vars.SplitSeed(251.741f, 65.773f, -13.616f);		//Cavern
		case 15: return vars.SplitSeed(547.488f, 45.41f, -27.107f);		//City Gate
		case 16: return vars.SplitSeed(609.907f, 61.905f, -35.001f);		//Tower of Ormazd
		case 17: return vars.SplitSeed(637.262f, 27.224f, -28.603f);		//Queen's Tower
		case 18: return vars.TempleArrive();					//The Temple (Arrive)
		case 19: return vars.DoubleJump();					//Double Jump
		case 20: return vars.YellowPlate();					//Wings of Ormazd
		case 21: return vars.SplitBoss(1070.478f, 279.147f, -29.571f);		//The Warrior
		case 22: return vars.SplitBoss(340f, 582.5f, 32.5f);			//Heal Coronation Hall
		case 23: return vars.SplitSeed(264.497f, 589.336f, 38.67f);		//Coronation Hall
		case 24: return vars.SplitBoss(-291f, 651.5f, 99.2f);			//Heal Heaven's Stair
		case 25: return vars.SplitBoss(-296.593f, 697.233f, 296.199f);		//The Alchemist
		case 26: return vars.SplitBoss(-929.415f, 320.888f, -89.038f);		//The Hunter
		case 27: return vars.BluePlate();					//Hand of Ormazd
		case 28: return vars.SplitBoss(352.792f, 801.051f, 150.260f);		//The Concubine
		case 29: return vars.SplitBoss(5f, -365f, -32f);			//The King
		case 30: return vars.TheGod();						//The God
		case 31: return vars.Resurrection();					//Resurrection
	}
	//Unmarking flags at the end of each cycle.
		vars.kill = false;
		vars.seedGet = false;
}
