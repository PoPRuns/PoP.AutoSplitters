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
reset {
	if(old.xPos != -465 && current.xPos == -465){
		return true;
	}
}

//When the Prince's y coordinate is set after loading into the Canyon, start.
start {
	if(old.yPos != -351 && current.yPos == -351){
		return true;
}

//Initializing flags & targets.
	vars.kill = false;
	vars.seedGet = false;
	vars.startUp = true;
	vars.xTarget = 0;
	vars.yTarget = 0;
	vars.zTarget = 0;
	

}

split{
//Initializing flags & targets in the event the start function wasn't used.
	if(!vars.startUp){
		vars.kill = false;
		vars.seedGet = false;
		vars.startUp = true;
		vars.xTarget = 0;
		vars.yTarget = 0;
		vars.zTarget = 0;
	}
//Setting kill to true any time you exit combat.
	if(old.combat == 2 && current.combat == 0){
		vars.kill = true;
	}
//Setting seedGet to true any time you collect a seed.
	if(current.seedCount == old.seedCount+1){
		vars.seedGet = true;
	}

//In the case of each split, looking for qualifications to complete the split. There are three kinds of splits in this script.
//Location Based: If you're inside the outlined zone, the split fires.
//Seed Based: If you're inside the outlined zone AND collect a seed, the split fires.
//Combat Based: If you're inside the outlined zone AND exit combat, the split fires.
switch (timer.CurrentSplitIndex)
			{
				case 0: //First Fight Skip
					if (current.zPos >= -31 && current.zPos <= -28 && current.yPos >= -331)
						return true;
					break;
				case 1: //The Canyon
					if (current.xPos <= -200 && current.xPos >= -208 && current.yPos <= -27.5 && current.yPos >= -38 && current.zPos >= -511)
						return true;
					break;
				case 2: //King's Gate
					vars.xTarget = -538.834;
					vars.yTarget = -67.159;
					vars.zTarget = 12.732;
					if(current.xPos <= (vars.xTarget+2) && current.xPos >= (vars.xTarget-2) && current.yPos <= (vars.yTarget+2) && current.yPos >= (vars.yTarget-2) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.seedGet)
						return true;
					break;
				case 3: //Sun Temple
					vars.xTarget = -670.471;
					vars.yTarget = -56.147;
					vars.zTarget = 16.46;
					if(current.xPos <= (vars.xTarget+2) && current.xPos >= (vars.xTarget-2) && current.yPos <= (vars.yTarget+2) && current.yPos >= (vars.yTarget-2) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.seedGet)
						return true;
					break;
				case 4: //Marshalling Grounds
					vars.xTarget = -806.671;
					vars.yTarget = 112.803;
					vars.zTarget = 21.645;
					if(current.xPos <= (vars.xTarget+2) && current.xPos >= (vars.xTarget-2) && current.yPos <= (vars.yTarget+2) && current.yPos >= (vars.yTarget-2) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.seedGet)
						return true;
					break;
				case 5: //Windmills
					vars.xTarget = -597.945;
					vars.yTarget = 209.241;
					vars.zTarget = 23.339;
					if(current.xPos <= (vars.xTarget+2) && current.xPos >= (vars.xTarget-2) && current.yPos <= (vars.yTarget+2) && current.yPos >= (vars.yTarget-2) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.seedGet)
						return true;
					break;
				case 6: //Martyrs' Tower
					vars.xTarget = -564.202;
					vars.yTarget = 207.312;
					vars.zTarget = 22;
					if(current.xPos <= (vars.xTarget+2) && current.xPos >= (vars.xTarget-2) && current.yPos <= (vars.yTarget+2) && current.yPos >= (vars.yTarget-2) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.seedGet)
						return true;
					break;					
				case 7: //MT -> MG
					vars.xTarget = -454.824;
					vars.yTarget = 398.571;
					vars.zTarget = 27.028;
					if(current.xPos <= (vars.xTarget+2) && current.xPos >= (vars.xTarget-2) && current.yPos <= (vars.yTarget+2) && current.yPos >= (vars.yTarget-2) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.seedGet)
						return true;
					break;
				case 8: //Machinery Ground
					vars.xTarget = -361.121;
					vars.yTarget = 480.114;
					vars.zTarget = 12.928;
					if(current.xPos <= (vars.xTarget+2) && current.xPos >= (vars.xTarget-2) && current.yPos <= (vars.yTarget+2) && current.yPos >= (vars.yTarget-2) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.seedGet)
						return true;
					break;
				case 9: //Heaven's Stair
					vars.xTarget = -85.968;
					vars.yTarget = 573.338;
					vars.zTarget = 30.558;
					if(current.xPos <= (vars.xTarget+2) && current.xPos >= (vars.xTarget-2) && current.yPos <= (vars.yTarget+2) && current.yPos >= (vars.yTarget-2) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.seedGet)
						return true;
					break;
				case 10: //Spire of Dreams
					vars.xTarget = -28.088;
					vars.yTarget = 544.298;
					vars.zTarget = 34.942;
					if(current.xPos <= (vars.xTarget+3) && current.xPos >= (vars.xTarget-3) && current.yPos <= (vars.yTarget+3) && current.yPos >= (vars.yTarget-3) && current.zPos <= (vars.zTarget+3) && current.zPos >= (vars.zTarget-3) && vars.seedGet)
						return true;
					break;
				case 11: //Reservoir
					vars.xTarget = -150.082;
					vars.yTarget = 406.606;
					vars.zTarget = 34.673;
					if(current.xPos <= (vars.xTarget+2) && current.xPos >= (vars.xTarget-2) && current.yPos <= (vars.yTarget+2) && current.yPos >= (vars.yTarget-2) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.seedGet)
						return true;
					break;
				case 12: //Construction Yard
					vars.xTarget = -151.121;
					vars.yTarget = 303.514;
					vars.zTarget = 27.95;
					if(current.xPos <= (vars.xTarget+2) && current.xPos >= (vars.xTarget-2) && current.yPos <= (vars.yTarget+2) && current.yPos >= (vars.yTarget-2) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.seedGet)
						return true;
					break;
				case 13: //Cauldron
					vars.xTarget = 107.123;
					vars.yTarget = 183.394;
					vars.zTarget = -5.628;
					if(current.xPos <= (vars.xTarget+2) && current.xPos >= (vars.xTarget-2) && current.yPos <= (vars.yTarget+2) && current.yPos >= (vars.yTarget-2) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.seedGet)
						return true;
					break;
				case 14: //Cavern
					vars.xTarget = 251.741;
					vars.yTarget = 65.773;
					vars.zTarget = -13.616;
					if(current.xPos <= (vars.xTarget+2) && current.xPos >= (vars.xTarget-2) && current.yPos <= (vars.yTarget+2) && current.yPos >= (vars.yTarget-2) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.seedGet)
						return true;
					break;
				case 15: //City Gate
					vars.xTarget = 547.488;
					vars.yTarget = 45.41;
					vars.zTarget = -27.107;
					if(current.xPos <= (vars.xTarget+2) && current.xPos >= (vars.xTarget-2) && current.yPos <= (vars.yTarget+2) && current.yPos >= (vars.yTarget-2) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.seedGet)
						return true;
					break;
				case 16: //Tower of Ormazd
					vars.xTarget = 609.907;
					vars.yTarget = 61.905;
					vars.zTarget = -35.001;
					if(current.xPos <= (vars.xTarget+2) && current.xPos >= (vars.xTarget-2) && current.yPos <= (vars.yTarget+2) && current.yPos >= (vars.yTarget-2) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.seedGet)
						return true;
					break;
				case 17: //Queen's Tower
					vars.xTarget = 637.262;
					vars.yTarget = 27.224;
					vars.zTarget = -28.603;
					if(current.xPos <= (vars.xTarget+2) && current.xPos >= (vars.xTarget-2) && current.yPos <= (vars.yTarget+2) && current.yPos >= (vars.yTarget-2) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.seedGet)
						return true;
					break;
				case 18: //The Temple (Arrive)
					if(current.yPos <= -234.5 && current.zPos >= -33.1 && current.xPos >= 3.9 && current.xPos <= 8)
						return true;
					break;
				case 19: //Double Jump
					if(current.xPos <= 6.19 && current.xPos >= 6.12 && current.yPos >= -233.49 && current.yPos <= -225.18 && current.zPos >= -33.01 && current.zPos <= -32.5)
						return true;
					break;
				case 20: //Wings of Ormazd
					if(current.xPos >= 6.6 && current.xPos <= 6.8 && current.yPos >= -171.8 && current.yPos <= -171.6 && current.zPos == -49)
						return true;
					break;
				case 21: //The Warrior
					vars.xTarget = 1070.478;
					vars.yTarget = 279.147;
					vars.zTarget = -29.571;
					if(current.xPos <= (vars.xTarget+23) && current.xPos >= (vars.xTarget-23) && current.yPos <= (vars.yTarget+23) && current.yPos >= (vars.yTarget-23) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.kill)
						return true;
					break;
				case 22: //Heal Coronation Hall
					if(current.xPos >= 328 && current.xPos <= 352 && current.yPos >= 570 && current.yPos <= 595 && current.zPos >= 32.4 && vars.kill)
						return true;
					break;
				case 23: //Coronation Hall (Seeds)
					vars.xTarget = 264.497;
					vars.yTarget = 589.336;
					vars.zTarget = 38.67;
					if(current.xPos <= (vars.xTarget+2) && current.xPos >= (vars.xTarget-2) && current.yPos <= (vars.yTarget+2) && current.yPos >= (vars.yTarget-2) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.seedGet)
						return true;
					break;
				case 24: //Heal Heaven's Stair
					if(current.xPos >= -322 && current.xPos <= -260 && current.yPos >= 628 && current.yPos <= 675 && current.zPos >= 99.2 && vars.kill)
						return true;
					break;
				case 25: //Heaven's Stair (Seeds)
					vars.xTarget = -279.466;
					vars.yTarget = 695.742;
					vars.zTarget = 87.415;
					if(current.xPos <= (vars.xTarget+2) && current.xPos >= (vars.xTarget-2) && current.yPos <= (vars.yTarget+2) && current.yPos >= (vars.yTarget-2) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.seedGet)
						return true;
					break;
				case 26: //The Alchemist
					vars.xTarget = -296.593;
					vars.yTarget = 697.233;
					vars.zTarget = 296.199;
					if(current.xPos <= (vars.xTarget+10) && current.xPos >= (vars.xTarget-10) && current.yPos <= (vars.yTarget+10) && current.yPos >= (vars.yTarget-10) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.kill)
						return true;
					break;
				case 27: //The Hunter
					vars.xTarget = -929.415;
					vars.yTarget = 320.888;
					vars.zTarget = -89.038;
					if(current.xPos <= (vars.xTarget+10) && current.xPos >= (vars.xTarget-10) && current.yPos <= (vars.yTarget+10) && current.yPos >= (vars.yTarget-10) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.kill)
						return true;
					break;
				case 28: //Hand of Ormazd
					if(old.zPos <= 0 && current.zPos >= 32.4)
						return true;
					break;
				case 29: //The Concubine
					vars.xTarget = 352.792;
					vars.yTarget = 801.051;
					vars.zTarget = 150.260;
					if(current.xPos <= (vars.xTarget+26) && current.xPos >= (vars.xTarget-26) && current.yPos <= (vars.yTarget+26) && current.yPos >= (vars.yTarget-26) && current.zPos <= (vars.zTarget+2) && current.zPos >= (vars.zTarget-2) && vars.kill)
						return true;
					break;
				case 30: //The King
					if(current.xPos <= 20 && current.xPos >= -10 && current.yPos >= -375 && current.yPos <= -355 && current.zPos <= -32 && vars.kill)
						return true;
					break;
				case 31: //The God
					if(current.xPos <= 7.131 && current.xPos >= 7.129 && current.yPos >= -401.502 && current.yPos <= -401.5 && current.zPos >= -31.4)
						return true;
					break;
				case 32: //Resurrection
					if(current.xPos <= 5.566 && current.xPos >= 5.562 && current.yPos >= -222.745 && current.yPos <= -222.517 && current.zPos >= -33.1)
						return true;
					break;
				
			}
			
//Unmarking flags at the end of each cycle.
	vars.kill = false;
	vars.seedGet = true;
}
