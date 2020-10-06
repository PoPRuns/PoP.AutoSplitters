state("PrinceOfPersia_Launcher"){
	int seedCount : 0x00B37F64, 0xDC;
	float xPos : 0x00B30D08, 0x40;
	float yPos : 0x00B30D08, 0x44;
	float zPos : 0x00B30D08, 0x48;
	int combat : 0x00B37F6C, 0xE0, 0x1C, 0xC, 0x7CC;
}


startup{	
//Delcaring flags & targets.
	bool kill = false;
	bool seedGet = false;
	bool startUp = false;
	int xTarget = 0;
	int yTarget = 0;
	int zTarget = 0;
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
	vars.xTarget = 0;
	vars.yTarget = 0;
	vars.zTarget = 0;
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
	vars.SplitBoss = (Func <float, float, float, short, bool>)((float xTarg, float yTarg, float zTarg, short size) => {		//This is a standard type of split which occurs when the prince is within a platform and has just killed a boss
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
	vars.HealCoronation = (Func <bool>)(() => {
		if(current.xPos >= 328 && current.xPos <= 352 &&
		   current.yPos >= 570 && current.yPos <= 595 &&
		   current.zPos >= 32.4 && vars.kill)
			return true;		
		return false;
	});
	vars.HealHeavensStair = (Func <bool>)(() => {
		if(current.xPos >= -322 && current.xPos <= -260 &&
		   current.yPos >= 628 && current.yPos <= 675 &&
		   current.zPos >= 99.2 && vars.kill)
			return true;		
		return false;
	});
	vars.BluePlate = (Func <bool>)(() => {
		if(old.zPos <= 0 && current.zPos >= 32.4)
			return true;		
		return false;
	});
	vars.TheKing = (Func <bool>)(() => {
		if(current.xPos <= 20 && current.xPos >= -10 &&
		   current.yPos >= -375 && current.yPos <= -355 &&
		   current.zPos <= -32 && vars.kill)
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
		vars.xTarget = 0;
		vars.yTarget = 0;
		vars.zTarget = 0;
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
		//First Fight Skip			
		case 0: 
			if(vars.FirstFightSkip())
				return true;
		break;
		//The Canyon
		case 1: 
			if(vars.Canyon())
				return true;
		break;
		//King's Gate
		case 2:
			if(vars.SplitSeed((float)-538.834, (float)-67.159, (float)12.732))
				return true;
		break;
		//Sun Temple
		case 3:
			if(vars.SplitSeed((float)-670.471, (float)-56.147, (float)16.46))
				return true;
		break;
		//Marshalling Grounds
		case 4:
			if(vars.SplitSeed((float)-806.671, (float)112.803, (float)21.645))
				return true;
		break;
		//Windmills
		case 5:
			if(vars.SplitSeed((float)-597.945, (float)209.241, (float)23.339))
				return true;
		break;
		//Martyrs' Tower
		case 6:
			if(vars.SplitSeed((float)-564.202, (float)207.312, (float)22))
				return true;
		break;					
		//MT -> MG
		case 7:
			if(vars.SplitSeed((float)-454.824, (float)398.571, (float)27.028))
				return true;
		break;
		//Machinery Ground
		case 8:
			if(vars.SplitSeed((float)-361.121, (float)480.114, (float)12.928))
				return true;
		break;
		//Heaven's Stair
		case 9:
			if(vars.SplitSeed((float)-85.968, (float)573.338, (float)30.558))
				return true;
		break;
		//Spire of Dreams
		case 10:
			if(vars.SplitSeed((float)-28.088, (float)544.298, (float)34.942))
				return true;
		break;
		//Reservoir
		case 11:
			if(vars.SplitSeed((float)-150.082, (float)406.606, (float)34.673))
				return true;
		break;
		//Construction Yard
		case 12:
			if(vars.SplitSeed((float)-151.121, (float)303.514, (float)27.95))
				return true;
		break;
		//Cauldron
		case 13: 
			if(vars.SplitSeed((float)107.123, (float)183.394, (float)-5.628))
				return true;
		break;
		//Cavern
		case 14:
			if(vars.SplitSeed((float)251.741, (float)65.773, (float)-13.616))
				return true;
		break;
		//City Gate
		case 15:
			if(vars.SplitSeed((float)547.488, (float)45.41, (float)-27.107))
				return true;
		break;
		//Tower of Ormazd
		case 16:
			if(vars.SplitSeed((float)609.907, (float)61.905, (float)-35.001))
				return true;
		break;
		//Queen's Tower
		case 17:
			if(vars.SplitSeed((float)637.262, (float)27.224, (float)-28.603))
				return true;
		break;
		//The Temple (Arrive)
		case 18:
			if(vars.TempleArrive())
				return true;
		break;
		//Double Jump
		case 19:
			if(vars.DoubleJump())
				return true;
		break;
		//Wings of Ormazd
		case 20:
			if(vars.YellowPlate())
				return true;
		break;
		//The Warrior
		case 21:
			if(vars.SplitBoss((float)1070.478, (float)279.147, (float)-29.571, 23))
				return true;
		break;
		//Heal Coronation Hall
		case 22:
			if(vars.HealCoronation())
				return true;
		break;
		//Coronation Hall
		case 23:
			if(vars.SplitSeed((float)264.497, (float)589.336, (float)38.67))
				return true;
		break;
		//Heal Heaven's Stair
		case 24:
			if(vars.HealHeavensStair())
				return true;
		break;
		//The Alchemist
		case 25:
			if(vars.SplitBoss((float)-296.593, (float)697.233, (float)296.199, (short)10))
				return true;
		break;
		//The Hunter
		case 26:
			if(vars.SplitBoss((float)-929.415, (float)320.888, (float)-89.038, (short)10))
				return true;
		break;
		//Hand of Ormazd
		case 27:
			if(vars.BluePlate())
				return true;
		break;
		//The Concubine
		case 28:
			if(vars.SplitBoss((float)352.792, (float)801.051, (float)150.260, (short)26))
				return true;
		break;
		//The King
		case 29:
			if(vars.TheKing())
				return true;
		break;
		//The God
		case 30:
			if(vars.TheGod())
				return true;
		break;
		//Resurrection
		case 31:
			if(vars.Resurrection())
				return true;
		break;
	}
	//Unmarking flags at the end of each cycle.
		vars.kill = false;
		vars.seedGet = false;
}
