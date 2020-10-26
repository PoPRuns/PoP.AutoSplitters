state("PrinceOfPersia_Launcher"){
	int seedCount : 0x00B37F64, 0xDC;
	float xPos : 0x00B30D08, 0x40;
	float yPos : 0x00B30D08, 0x44;
	float zPos : 0x00B30D08, 0x48;
	int combat : 0x00B37F6C, 0xE0, 0x1C, 0xC, 0x7CC;
}

state("Prince Of Persia"){
	int seedCount : 0x00F37F64, 0xDC;
	float xPos : 0x00F30D08, 0x40;
	float yPos : 0x00F30D08, 0x44;
	float zPos : 0x00F30D08, 0x48;
	int combat : 0x00F37F6C, 0xE0, 0x1C, 0xC, 0x7CC;
}

init{
	 //setting refresh rate to double of game's framerate just to be sure:
	 refreshRate = 120;
	 
	//this function will take 2 float values as input and check if X co-ordinate is within those values:
	vars.inXRange = (Func <float, float, bool>)((xMin, xMax) => { return current.xPos >= xMin && current.xPos <= xMax ? true : false; });
	
	//this function will take 2 float values as input and check if Y co-ordinate is within those values:
	vars.inYRange = (Func <float, float, bool>)((yMin, yMax) => { return current.yPos >= yMin && current.yPos <= yMax ? true : false; });
	
	//this function will take 2 float values as input and check if Z co-ordinate is within those values:
	vars.inZRange = (Func <float, float, bool>)((zMin, zMax) => { return current.zPos >= zMin && current.zPos <= zMax ? true : false; });
	
	//this function will take 6 float values as input and check if X,Y and Z co-ordinates are within those values:
	vars.inPosFull = (Func <float, float, float, float, float, float, bool>)((xMin, xMax, yMin, yMax, zMin, zMax) => { return vars.inXRange(xMin, xMax) && vars.inYRange(yMin, yMax) && vars.inZRange(zMin, zMax) ? true : false; });
	
	//this function will take 3 float values for x,y and z of target split location and 1 integer for half-size of range as input and check if X,Y and Z co-ordinates within the range of the target:
	vars.inPosWithRange = (Func <float, float, float, int, bool>)((xTarg, yTarg, zTarg, range) => {
		return
			current.xPos >= xTarg - range && current.xPos <= xTarg + range &&
			current.yPos >= yTarg - range && current.yPos <= yTarg + range &&
			current.zPos >= zTarg - range && current.zPos <= zTarg + range ? true : false;
	});
	
	//This function checks if x,y,z co-ordinates are in a certain range and if a seed has just been picked:
	vars.splitSeed = (Func <float, float, float, bool>)((xTarg, yTarg, zTarg) => { return vars.inPosWithRange(xTarg, yTarg, zTarg, 3) && vars.seedGet ? true : false; });
	
	//This function checks if x,y,z co-ordinates are in a certain range and if a combat has just ended:
	vars.splitBoss = (Func <float, float, float, bool>)((xTarg, yTarg, zTarg) => { return vars.inPosWithRange(xTarg, yTarg, zTarg, 30) && vars.kill ? true : false; });
}


reset {
	//When the Prince's x coordinate is set after loading into the Canyon, reset.
	return old.xPos != -465 && current.xPos == -465;
}


start {
	//When the Prince's y coordinate is set after loading into the Canyon, start.
	return old.yPos != -351 && current.yPos == -351;
}


split{
	//Unmarking flags from previous cycle:
	vars.kill = false;
	vars.seedGet = false;
	
	//Checking and setting flags if conditions are met:
	if (old.combat == 2 && current.combat == 0) vars.kill = true;
	if (current.seedCount == old.seedCount + 1) vars.seedGet = true;

	// Initializing split conditions:
	bool Alchemist        = vars.splitBoss(-296.593f, 697.233f, 296.199f) ? true : false;
	bool BluePlate        = current.zPos >= 32.4 && old.zPos <= 0 ? true : false;
	bool Canyon           = vars.inXRange(-208f, -200f)   && vars.inYRange(-38f, -27.5f) && current.zPos >= -511 ? true : false;
	bool Cauldron         = vars.splitSeed(107.123f, 183.394f, -5.628f) ? true : false;
	bool Cavern           = vars.splitSeed(251.741f, 65.773f, -13.616f) ? true : false;
	bool CityGate         = vars.splitSeed(547.488f, 45.41f, -27.107f) ? true : false;
	bool Concubine        = vars.splitBoss(352.792f, 801.051f, 150.260f) ? true : false;
	bool ConstructionYard = vars.splitSeed(-151.121f, 303.514f, 27.95f) ? true : false;
	bool CoronationHall   = vars.splitSeed(264.497f, 589.336f, 38.67f) ? true : false;
	bool CoronationHallH  = vars.splitBoss(340f, 582.5f, 32.5f) ? true : false;
	bool DoubleJump       = vars.inPosFull(6.12f, 6.19f, -233.49f, -225.18f, -33.01f, -32.5f) ? true : false;
	bool FirstFightSkip   = current.yPos >= -331 && vars.inZRange(-31f, -28f) ? true : false;
	bool HeavensStair     = vars.splitSeed(-85.968f, 573.338f, 30.558f) ? true : false;
	bool HeavensStairH    = vars.splitBoss(-291f, 651.5f, 99.2f) ? true : false;
	bool Hunter           = vars.splitBoss(-929.415f, 320.888f, -89.038f) ? true : false;
	bool King             = vars.splitBoss(5f, -365f, -32f) ? true : false;
	bool KingsGate        = vars.splitSeed(-538.834f, -67.159f, 12.732f) ? true : false;
	bool MachineryGround  = vars.splitSeed(-361.121f, 480.114f, 12.928f) ? true : false;
	bool MarshGrounds     = vars.splitSeed(-806.671f, 112.803f, 21.645f) ? true : false;
	bool MartyrsTower     = vars.splitSeed(-564.202f, 207.312f, 22f) ? true : false;
	bool MTtoMG           = vars.splitSeed(-454.824f, 398.571f, 27.028f) ? true : false;
	bool QueensTower      = vars.splitSeed(637.262f, 27.224f, -28.603f) ? true : false;
	bool Reservoir08      = vars.splitSeed(-150.082f, 406.606f, 34.673f) ? true : false;
	bool Resurrection     = vars.inXRange(5.562f, 5.566f) && vars.inYRange(-222.745f, -222.517f) && current.zPos >= -33.1 ? true : false;
	bool SpireOfDreams    = vars.splitSeed(-28.088f, 544.298f, 34.942f) ? true : false;
	bool SunTemple08      = vars.splitSeed(-670.471f, -56.147f, 16.46f) ? true : false;
	bool TempleArrive     = vars.inXRange(-0.5f, 12f) && current.yPos <= -234.5 && current.zPos >= -37 ? true : false;
	bool TheGod           = vars.inXRange(7.129f, 7.131f) && vars.inYRange(-401.502f, -401.5f) && current.zPos >= -31.4  ? true : false;
	bool TowerOfOrmazd    = vars.splitSeed(609.907f, 61.905f, -35.001f) ? true : false;
	bool Warrior          = vars.splitBoss(1070.478f, 279.147f, -29.571f) ? true : false;
	bool Windmills        = vars.splitSeed(-597.945f, 209.241f, 23.339f) ? true : false;
	bool YellowPlate      = vars.inXRange(6.6f, 6.8f) && vars.inYRange(-171.8f, -171.6f) && current.zPos == -49 ? true : false;

	// Checking qualifications to complete each split:
	switch (timer.CurrentSplitIndex) {
		case 0: return FirstFightSkip;    // First Fight Skip
		case 1: return Canyon;            // The Canyon
		case 2: return KingsGate;         // King's Gate
		case 3: return SunTemple08;       // Sun Temple
		case 4: return MarshGrounds;      // Marshalling Grounds
		case 5: return Windmills;         // Windmills
		case 6: return MartyrsTower;      // Martyrs' Tower
		case 7: return MTtoMG;            // MT -> MG
		case 8: return MachineryGround;   // Machinery Ground
		case 9: return HeavensStair;      // Heaven's Stair
		case 10: return SpireOfDreams;    // Spire of Dreams
		case 11: return Reservoir08;      // Reservoir
		case 12: return ConstructionYard; // Construction Yard
		case 13: return Cauldron;         // Cauldron
		case 14: return Cavern;           // Cavern
		case 15: return CityGate;         // City Gate
		case 16: return TowerOfOrmazd;    // Tower of Ormazd
		case 17: return QueensTower;      // Queen's Tower
		case 18: return TempleArrive;     // The Temple (Arrive)
		case 19: return DoubleJump;       // Double Jump
		case 20: return YellowPlate;      // Wings of Ormazd
		case 21: return Warrior;          // The Warrior
		case 22: return CoronationHallH;  // Heal Coronation Hall
		case 23: return CoronationHall;   // Coronation Hall
		case 24: return HeavensStairH;    // Heal Heaven's Stair
		case 25: return Alchemist;        // The Alchemist
		case 26: return Hunter;           // The Hunter
		case 27: return BluePlate;        // Hand of Ormazd
		case 28: return Concubine;        // The Concubine
		case 29: return King;             // The King
		case 30: return TheGod;           // The God
		case 31: return Resurrection;	  // Resurrection
	}
}
