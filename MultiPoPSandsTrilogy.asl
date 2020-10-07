state("DOSBOX")
{
//Memory values in PoP1
    byte Level          : 0x0074F6D0, 0x1D0F4;          // shows level 1-14 changes as door is entered
    byte Scene          : 0x0074F6D0, 0x1A4BA;          // shows level 1-14 changes as scenes end 
    byte EndGame        : 0x0074F6D0, 0x1D74A;          // 0 before endgame, 255 at endgame cutscene
    byte Start	        : 0x0074F6D0, 0x1D694;          // the level you start the game at
    byte GameRunning    : "DOSBox.exe", 0x19195EA;      // 0 if game isn't running 
    byte Time           : 0x0074F6D0, 0x1E350;          // Minutes
    int  Count          : 0x0074F6D0, 0x1E354;          // Seconds
    byte Sound          : 0x0074F6D0, 0x2F233;          // 0 if sound is on, 1 if sound is off

	
//Memory values in PoP2
	byte Level2			: 0x193C370, 0x38796;
	byte Start2			: 0x193C370, 0x38FF2;
	byte GameRunning2	: 0x19175EA;
}


//Memory values in PoP3D
state("pop3d")
{
	int health : 0x004062E4, 0x130;
	int eHealth : 0x3FBC84;
	float lXPos : 0x004062E4, 0xD0, 0xC4, 0x18, 0x44;
	float lYPos : 0x004062E4, 0xD0, 0xC4, 0x18, 0x48;
	float lZPos : 0x004062E4, 0xD0, 0xC4, 0x18, 0x4C;
	float xPos3d : 0x003EF854, 0x160, 0x2F8, 0x8, 0x18, 0x44;
	float yPos3d : 0x003EF854, 0x160, 0x2F8, 0x8, 0x18, 0x48;
	float zPos3d : 0x003EF854, 0x160, 0x2F8, 0x8, 0x18, 0x4C;
}


//Memory values in SoT
state("POP")
{
//Some memory value that reliably changes when 'New Game' is pressed.
	int startValue : 0x6BC980;

//Prince's position
	float xPos1 : 0x00699474, 0xC, 0x30;
	float yPos1 : 0x00699474, 0xC, 0x34;
	float zPos1 : 0x00699474, 0xC, 0x38;

//The Vizier's health where 0 is unharmed and 4 is dead.
	int vizierHealth : 0x0040E518, 0x6C, 0x18, 0x4, 0x44, 0x0;
	
	int resetValue : 0x0040E388, 0x4, 0x398;
}


//Memory values in WW
state("POP2")
{
//Some memory value that reliably changes when you gain control after a load.
	int startValue2 : 0x0096602C, 0x8, 0x28, 0xA8, 0x3E0;
	
//Story counter/gate/value
	int storyValue : 0x523578;	

//A value that changes reliably depending on which weapon you pick up
	int secondaryWeapon : 0x0053F8F0, 0x4, 0x164, 0xC, 0x364;
	
//The address used for all bosses' health
	int bossHealth : 0x0090C418, 0x18, 0x4, 0x48, 0x198;

//The Prince's coords
	float xPos2 : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x30;	
	float yPos2 : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x34;
	float zPos2 : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x38;	
}


//Memory values in T2T
state("POP3")
{
//The Prince's coords
	float xPos3 : 0x00A2A498, 0xC, 0x30;
	float yPos3 : 0x00A2A498, 0xC, 0x34;
	float zPos3 : 0x00A2A498, 0xC, 0x38;
	float xCam : 0x928548;
	float yCam : 0x928554;
}


//Memory values in 2k8
state("PrinceOfPersia_Launcher")
{
	int seedCount : 0x00B37F64, 0xDC;
	float xPos2k8 : 0x00B30D08, 0x40;
	float yPos2k8 : 0x00B30D08, 0x44;
	float zPos2k8 : 0x00B30D08, 0x48;
	int combat : 0x00B37F6C, 0xE0, 0x1C, 0xC, 0x7CC;
}


//Memory values in TFS
state("prince of persia")
{
	float xPostfs : 0xDA4D20;
	float yPostfs : 0xDA4D24;
	float zPostfs : 0xDA4D28;
	int gameState : 0x00DA52EC, 0x18, 0xF8, 0x150;
	int cpIcon : 0x00064D34, 0x0, 0x0, 0x24, 0x18, 0x50, 0x870;
	int isMenu : 0xDA2F70;
	bool isLoading: "", 0x00DA5724, 0x50;
}


startup
{

//general
	short activeGame = 0;
	short offset = 0;

//PoP2
	int ResetDelta = 0;
	bool Resetting = false;
		
//SoT
	bool aboveCredits = false;
	bool newFountain = false;

//2k8
	bool kill = false;
	bool seedGet = false;

//TFS
	bool cpGet = false;
}


	
start
{
	vars.activeGame = 0;
	switch(game.ProcessName)
	{
	//PoP1
	case "DOSBOX":
		if((current.Start == 0x1) && 
		   (current.Level == 0x1) && 
		   (current.Time == 0x3C) && 
		   (current.Count >= 0x2CE0000))
		{
			vars.activeGame = 1;
			vars.offset = 0;
			return true;
		}
	
	//PoP2:SnF
		if(current.Start == 238 && current.Level2 == 1)
		{
			vars.ResetDelta = current.FrameCount;
			vars.activeGame = 2;
			vars.offset = 14;
			return true;
		}
		vars.ResetDelta = 0;
		vars.Resetting = false;
	break;
	
	//3D
	case "pop3d":
		if(current.lXPos > 20.554 && current.lXPos < 20.556 &&
		   current.lZPos > 1.448 && current.lZPos < 1.45)
		{
			vars.activeGame = 3;
			vars.offset = 0;
			return true;
		}
	break;
	
	//SoT
	case "POP":
	case "pop":
		vars.aboveCredits = false;
		vars.newFountain = false;
		if(current.xPos1 >= -103.264 && current.xPos1 <= -103.262 &&
		   current.yPos1 >= -4.8 && current.yPos1 <= -4.798 &&
		   current.zPos1 >= 1.341 && current.zPos1 <= 1.343 &&
		   current.startValue == 1)
		{
			vars.activeGame = 4;
			vars.offset = 0;
			return true;
		}
	break;
	
	//WW
	case "POP2":
	case "pop2":
		if((old.startValue2 == 1 && current.startValue2 == 2) && 
		   (current.xPos2 >= -997.6757 && current.xPos2 <= -997.6755))
		{
			vars.activeGame = 5;
			vars.offset = 0;
			return true;
		}
	break;
	
	//T2T
	case "POP3":
	case "pop3":
		if(current.xPos3 >= -409.9 && current.xPos3 <= -404.8 &&
		   current.xCam >= 0.8318 && current.xCam <= 0.832 &&
		   current.yCam >= 0.1080  && current.yCam <= 0.1082)
		{
			vars.activeGame = 6;
			vars.offset = 0;
			return true;
		}
	break;
	
	//2k8
	case "Prince of Persia":
	case "PrinceOfPersia_Launcher":
		if(old.yPos2k8 != -351 && current.yPos2k8 == -351)
		{
			//Initializing flags & targets:
			vars.kill = false;
			vars.seedGet = false;
			vars.offset = 0;
			vars.activeGame = 7;
			return true;			
		}
	break;
	
	//TFS
	case "prince of persia":
		if(current.xPostfs <= 268.93 && current.xPostfs >= 268.929 &&
		   current.gameState == 4)
		{
			vars.activeGame = 8;
			vars.offset = 0;
			return true;
		}
	break;
	}
}


isLoading
{
	switch((short)vars.activeGame)
	{
		case 0: //State when no game is active
			return true;
		break;
		
		case 1: //PoP1 (IGT)
		break;
		
		case 2: //PoP2 (IGT)
		break;
		
		case 3:	//PoP 3D (Load Remover)
			if(current.xPos3d == 0 && current.yPos3d == 0 && current.zPos3d == 0)
			{
				return true;
			}
		break;
		
		case 8: //TFS (Load Remover)
			if(current.isMenu == 0 || current.isLoading)
			{
				return true;
			}
		break;
	}
	return false;
}


split
{
	//Calling the splits after checking the active game and category (if applicable)
	//If no game is active (case 0), it checks for start condition of each game and sets the active game
	
	switch((short)vars.activeGame)
	{
		case 0:	//Setup splits
			switch(game.ProcessName)
			{
			//PoP1
			case "DOSBOX":
				if((current.Start == 0x1) && 
				   (current.Level == 0x1) && 
				   (current.Time == 0x3C) && 
				   (current.Count >= 0x2CE0000))
				{
					vars.activeGame = 1;
					vars.offset++;
					return true;
				}
			
			//PoP2:SnF
				if(current.Start == 238 && current.Level2 == 1)
				{
					vars.ResetDelta = current.FrameCount;
					vars.activeGame = 2;
					vars.offset += 14;
					return true;
				}
				vars.ResetDelta = 0;
				vars.Resetting = false;
			break;
			
			//3D
			case "pop3d":
				if(current.lXPos > 20.554 && current.lXPos < 20.556 &&
				   current.lZPos > 1.448 && current.lZPos < 1.45)
				{
					vars.activeGame = 3;
					vars.offset++;
					return true;
				}
			break;
			
			//SoT
			case "POP":
			case "pop":
				vars.aboveCredits = false;
				vars.newFountain = false;
				if(current.xPos1 >= -103.264 && current.xPos1 <= -103.262 &&
				   current.yPos1 >= -4.8 && current.yPos1 <= -4.798 &&
				   current.zPos1 >= 1.341 && current.zPos1 <= 1.343 &&
				   current.startValue == 1)
				{
					vars.activeGame = 4;
					vars.offset++;
					return true;
				}
			break;
			
			//WW
			case "POP2":
			case "pop2":
				if((old.startValue2 == 1 && current.startValue2 == 2) && 
				   (current.xPos2 >= -997.6757 && current.xPos2 <= -997.6755))
				{
					vars.activeGame = 5;
					vars.offset++;
					return true;
				}
			break;
			
			//T2T
			case "pop3":
			case "POP3":
				if(current.xPos3 >= -409.9 && current.xPos3 <= -404.8 &&
				   current.xCam >= 0.8318 && current.xCam <= 0.832 &&
				   current.yCam >= 0.1080  && current.yCam <= 0.1082)
				{
					vars.activeGame = 6;
					vars.offset++;
					return true;
				}
			break;
			
			//2k8
			case "Prince of Persia":
			case "PrinceOfPersia_Launcher":
				if(old.yPos2k8 != -351 && current.yPos2k8 == -351)
				{
					//Initializing flags & targets:
					vars.kill = false;
					vars.seedGet = false;
					vars.offset++;
					vars.activeGame = 7;		
					return true;
				}
			break;
			
			//TFS
			case "prince of persia":
				if(current.xPostfs <= 268.93 && current.xPostfs >= 268.929 &&
				   current.gameState == 4)
				{
					vars.activeGame = 8;
					vars.offset++;
					return true;
				}
			break;
			}
		break;
		
		case 1: //PoP1
		if(old.Level !=  current.Level)
			return true;
		if(current.Level == 0xE && current.EndGame == 0xFF){
			vars.activeGame = 0;
			vars.offset += 14;
			return true;
		}
		break;
		
		case 2: //PoP2: SnF
			if(current.Start == 231){
				vars.Resetting = false;
			}
			if(old.Level2 == current.Level2 - 1)
				return true;
		break;
		
		case 3: //PoP3D
			//List of PoP3D Splits
			vars.Dungeon = (Func <bool>)(() => {
				if(old.lYPos == 0 && current.lYPos == -2)
					return true;
				return false;
			});
			vars.IvoryTower = (Func <bool>)(() => {
				if(current.lXPos > 13.485 && current.lXPos < 13.487 &&
				   old.lXPos == 0)
					return true;
				return false;
			});
			vars.Cistern = (Func <bool>)(() => {
				if(current.lXPos > 216.904 && current.lXPos < 216.906 &&
				   old.lXPos == 0)
					return true;
				return false;
			});	
			vars.Palace1 = (Func <bool>)(() => {
				if(old.lXPos == 0 && current.lXPos == -7)
					return true;
				return false;
			});
			vars.Palace2 = (Func <bool>)(() => {
				if(old.lYPos == 0 && current.lYPos == -23)
					return true;
				return false;
			});
			vars.Palace3 = (Func <bool>)(() => {
				if(current.lXPos == 0 && current.lYPos == 0 && current.lZPos == 0 &&
				   old.health == 0 && current.health != 0)
					return true;
				return false;
			});
			vars.Rooftops = (Func <bool>)(() => {
				if(old.lXPos == 0 && current.lXPos == -42)
					return true;
				return false;
			});		
			vars.StreetsDocks = (Func <bool>)(() => {
				if(old.lYPos == 0 && current.lYPos == -20)
					return true;
				return false;
			});	
			vars.LowerDirigible1 = (Func <bool>)(() => {
				if(old.lYPos == 0 && current.lYPos == 99)
					return true;
				return false;
			});	
			vars.LowerDirigible2 = (Func <bool>)(() => {
				if(current.lZPos > -77.77 && current.lZPos < -77.75 &&
				   old.lZPos == 0)
					return true;
				return false;
			});			
			vars.UpperDirigible = (Func <bool>)(() => {
				if(old.lYPos == 0 && current.lYPos == 103)
					return true;
				return false;
			});
			vars.UpperDirigible = (Func <bool>)(() => {
				if(old.lYPos == 0 && current.lYPos == 103)
					return true;
				return false;
			});
			vars.DirigibleFinale = (Func <bool>)(() => {
				if(old.lYPos == 0 && current.lYPos == 61)
					return true;
				return false;
			});
			vars.FloatingRuins = (Func <bool>)(() => {
				if(old.lYPos == 0 && current.lYPos == -85)
					return true;
				return false;
			});
			vars.FloatingRuins = (Func <bool>)(() => {
				if(current.lYPos > -2.36 && current.lYPos < -2.34 &&
				   old.lYPos == 0)
					return true;
				return false;
			});	
			vars.SunTemple = (Func <bool>)(() => {
				if(current.lYPos > -19.966 && current.lYPos < -19.964 &&
				   old.lYPos == 0)
					return true;
				return false;
			});			
			vars.MoonTemple = (Func <bool>)(() => {
				if(current.lYPos > -27.4 && current.lYPos < -27.38 &&
				   old.lYPos == 0)
					return true;
				return false;
			});			
			vars.End3D = (Func <bool>)(() => {
				if(current.xPos == 0 && current.yPos == 0 && current.zPos == 0 &&
				   current.eHealth ==0)
					return true;
				return false;
			});
		
			//In the case of each split, looking for qualifications to complete the split:
			switch (timer.CurrentSplitIndex - (short)vars.offset)
			{
				case 0: return vars.Dungeon();				//Dungeon
				case 1: return vars.IvoryTower();			//Ivory Tower
				case 2: return vars.Cistern();				//Cistern
				case 3: return vars.Palace1();				//Palace 1
				case 4: return vars.Palace2();				//Palace 2
				case 5: return vars.Palace3();				//Palace 3	
				case 6: return vars.Rooftops();				//Rooftops
				case 7: return vars.StreetsDocks();			//Streets and Docks
				case 8: return vars.LowerDirigible1();			//Lower Dirigible 1
				case 9: return vars.LowerDirigible2();			//Lower Dirigible 2
				case 10: return vars.UpperDirigible();			//Upper Dirigible
				case 11: return vars.DirigibleFinale();			//Dirigible Finale
				case 12: return vars.FloatingRuins();			//Floating Ruins
				case 13: return vars.Cliffs();				//Cliffs
				case 14: return vars.SunTemple();			//Sun Temple
				case 15: return vars.MoonTemple();			//Moon Temple
				case 16: if(vars.End3D)					//Finale
						 {
							 vars.activeGame = 0;
							 vars.offset += 17;
							 return true;
						 }
				break;
			}
		break;
		
		case 4:	//SoT
			//List of SoT Splits across categories
			vars.GasStation = (Func <bool>)(() => {
				if(current.xPos1 >= 252 && current.xPos1 <= 258 &&
				   current.yPos1 >= 130.647 && current.yPos1 <= 134 &&
				   current.zPos1 >= 22.999 && current.zPos1 <= 23.001)
					return true;
				return false;
			});
			vars.SandsUnleashed = (Func <bool>)(() => {
				if(current.xPos1 >= -6.177 && current.xPos1 <= -6.175 &&
				   current.yPos1 >= 62.905 && current.yPos1 <= 62.907 &&
				   current.zPos1 >= 7.604 && current.zPos1 <= 7.606)
					return true;
				return false;
			});
			vars.FirstGuestRoom = (Func <bool>)(() => {
				if(current.xPos1 >= 30.297 && current.xPos1 <= 30.299 &&
				   current.yPos1 >= 42.126 && current.yPos1 <= 42.128 &&
				   current.zPos1 >= 12.998 && current.zPos1 <= 13)
					return true;
				return false;
			});
			vars.SultanChamberZipless = (Func <bool>)(() => {
				if(current.xPos1 >= 98.445 && current.xPos1 <= 98.447 &&
				   current.yPos1 >= 39.567 && current.yPos1 <= 39.57 &&
				   current.zPos1 >= -8.96 && current.zPos1 <= -8.958) 		
					return true;
				return false;
			});
			vars.SultanChamber = (Func <bool>)(() => {
				if(current.xPos1 >= 134.137 && current.xPos1 <= 134.139 &&
				   current.yPos1 >= 54.990 && current.yPos1 <= 54.992 &&
				   current.zPos1 >= -32.791 && current.zPos1 <= -32.789)
					return true;
				return false;
			});
			vars.PalaceDefence = (Func <bool>)(() => {
				if(current.xPos1 >= 4.547 && current.xPos1 <= 8.851 &&
				   current.yPos1 >= 40.494 && current.yPos1 <= 47.519 &&
				   current.zPos1 >= -39.001 && current.zPos1 <= -38.999) 		
					return true;
				return false;
			});
			vars.DadStart = (Func <bool>)(() => {
				if(current.xPos1 >= 6.714 && current.xPos1 <= 6.716	&&
				   current.yPos1 >= 57.698 && current.yPos1 <= 57.7 &&
				   current.zPos1 >= 21.005 && current.zPos1 <= 21.007) 		
					return true;
				return false;
			});
			vars.DadDead = (Func <bool>)(() => {
				if(current.xPos1 >= -6.001 && current.xPos1 <= -5.999 &&
				   current.yPos1 >= -18.6 && current.yPos1 <= -18.4	&&
				   current.zPos1 >= 1.998 && current.zPos1 <= 2.001)
					return true;
				return false;
			});
			vars.TheWarehouse = (Func <bool>)(() => {
				if(current.xPos1 >= -73.352 && current.xPos1 <= -71.233	&&
				   current.yPos1 >= -28.5 && current.yPos1 <= -26.868 &&
				   current.zPos1 >= -1.001 && current.zPos1 <= -0.818) 		
					return true;
				return false;
			});
			vars.TheZoo = (Func <bool>)(() => {
				if(current.xPos1 >= -141.299 && current.xPos1 <= -139.797 &&
				   current.yPos1 >= -47.21 && current.yPos1 <= -42.801 &&
				   current.zPos1 >= -31.1 && current.zPos1 <= -30.9) 		
					return true;
				return false;
			});
			vars.BirdCage = (Func <bool>)(() => {
				if(current.xPos1 >= -211 && current.xPos1 <= -208 &&
				   current.yPos1 >= -23 && current.yPos1 <= -21 &&
				   current.zPos1 >= -9 && current.zPos1 <= -8.8) 		
					return true;
				return false;
			});
			vars.CliffWaterfalls = (Func <bool>)(() => {
				if(current.xPos1 >= -233.6 && current.xPos1 <= -231.4 &&
				   current.yPos1 >= 33.7 && current.yPos1 <= 35 &&
				   current.zPos1 >= -42.6 && current.zPos1 <= -42.4) 		
					return true;
				return false;
			});
			vars.TheBathsZipless = (Func <bool>)(() => {
				if(current.xPos1 >= -215.85 && current.xPos1 <= -214.089 &&
				   current.yPos1 >= 54.261 && current.yPos1 <= 58.699 &&
				   current.zPos1 >= -43.501 && current.zPos1 <= -43.499) 		
					return true;
				return false;
			});
			vars.TheBaths = (Func <bool>)(() => {
				if(current.xPos1 >= -211.427 && current.xPos1 <= -211.425 &&
				   current.yPos1 >= 56.602 && current.yPos1 <= 56.604 &&
				   current.zPos1 >= -43.501 && current.zPos1 <= -43.499)
					return true;
				return false;
			});
			vars.SecondSword = (Func <bool>)(() => {
				if(current.xPos1 >= -106.819 && current.xPos1 <= -106.817 &&
				   current.yPos1 >= 81.097 && current.yPos1 <= 81.099 &&
				   current.zPos1 >= -27.269 && current.zPos1 <= -27.267) 		
					return true;
				return false;
			});
			vars.TheDaybreak = (Func <bool>)(() => {
				if(current.xPos1 >= -76 && current.xPos1 <= -70	&&
				   current.yPos1 >= 192.4 && current.yPos1 <= 197.6	&&
				   current.zPos1 >= -56.6 && current.zPos1 <= -54) 		
					return true;
				return false;
			});
			vars.TheMesshall = (Func <bool>)(() => {
				if(current.xPos1 >= -183.267 && current.xPos1 <= -183.265 &&
				   current.yPos1 >= 234.685 && current.yPos1 <= 234.687 &&
				   current.zPos1 >= -37.528 && current.zPos1 <= -37.526)
					return true;
				return false;
			});
			vars.DrawbridgeTower = (Func <bool>)(() => {
				if(current.xPos1 >= -267 && current.xPos1 <= -262 &&
				   current.yPos1 >= 232 && current.yPos1 <= 267	&&
				   current.zPos1 >= -35.6 && current.zPos1 <= -35.5) 		
					return true;
				return false;
			});
			vars.BrokenBridge = (Func <bool>)(() => {
				if(current.xPos1 >= -265 && current.xPos1 <= -257 &&
				   current.yPos1 >= 159 && current.yPos1 <= 167 &&
				   current.zPos1 >= -13.6 && current.zPos1 <= -13.4) 		
					return true;
				return false;
			});
			vars.TheCavesZipless = (Func <bool>)(() => {
				if(current.xPos1 >= -303 && current.xPos1 <= -297.5 &&
				   current.yPos1 >= 112 && current.yPos1 <= 113.5 &&
				   current.zPos1 >= -56.1 && current.zPos1 <= -55.9) 		
					return true;
				return false;
			});
			vars.TheCaves = (Func <bool>)(() => {
				if(current.xPos1 >= -246.839 && current.xPos1 <= -241.677 &&
				   current.yPos1 >= 78.019 && current.yPos1 <= 87.936 &&
				   current.zPos1 >= -71.731 && current.zPos1 <= -70.7)
					return true;
				return false;
			});
			vars.TheCavesAC = (Func <bool>)(() => {
				if(current.xPos1 >=-171.193 && current.xPos1 <= -171.191 &&
				   current.yPos1 >= -52.07 && current.yPos1 <= -52.068 &&
				   current.zPos1 >= -119.863 && current.zPos1 <= -119.861)
					return true;
				return false;
			});
			vars.TheWaterfall = (Func <bool>)(() => {
				if(current.xPos1 >= -242 && current.xPos1 <= -240.5 &&
				   current.yPos1 >= 79.5 && current.yPos1 <= 83 &&
				   current.zPos1 >= -121 && current.zPos1 <= -118)		
					return true;
				return false;
			});
			vars.TheUGReservoirZipless = (Func <bool>)(() => {
				if(current.xPos1 >= -121 && current.xPos1 <= -110 &&
				   current.yPos1 >= -9 && current.yPos1 <= -7 &&
				   current.zPos1 >= -154.1 && current.zPos1 <= -153.9) 		
					return true;
				return false;
			});
			vars.TheUGReservoir = (Func <bool>)(() => {
				if(current.xPos1 >= -51.477 && current.xPos1 <= -48.475 &&
				   current.yPos1 >= 72.155 && current.yPos1 <= 73.657 &&
				   current.zPos1 >= -24.802 && current.zPos1 <= -24.799)
					return true;
				return false;
			});
			vars.HallofLearning = (Func <bool>)(() => {
				if(current.xPos1 >= 73 && current.xPos1 <= 79 &&
				   current.yPos1 >= 161 && current.yPos1 <= 163 &&
				   current.zPos1 >= -24.1 && current.zPos1 <= -23.9) 		
					return true;
				return false;
			});
			vars.TheObservatory = (Func <bool>)(() => {
				if(current.xPos1 >= 139.231 && current.xPos1 <= 139.233	&&
				   current.yPos1 >= 162.556 && current.yPos1 <= 162.558 &&
				   current.zPos1 >= -29.502 && current.zPos1 <= -29.5)
					return true;
				return false;
			});
			vars.ObservatoryExit = (Func <bool>)(() => {
				if(current.xPos1 >= 137 && current.xPos1 <= 141	&&
				   current.yPos1 >= 164 && current.yPos1 <= 164.67 &&
				   current.zPos1 >= -29.5 && current.zPos1 <= -29.2) 		
					return true;
				return false;
			});
			vars.HoLCourtyardsExit = (Func <bool>)(() => {
				if(current.xPos1 >= 72 && current.xPos1 <= 77 &&
				   current.yPos1 >= 90 && current.yPos1 <= 95.7 &&
				   current.zPos1 >= -27.1 && current.zPos1 <= -26.9) 		
					return true;
				return false;
			});
			vars.TheAzadPrison = (Func <bool>)(() => {
				if(current.xPos1 >= 190 && current.xPos1 <= 195 &&
				   current.yPos1 >= -21 && current.yPos1 <= -19 &&
				   current.zPos1 >= -17.6 && current.zPos1 <= -17.3) 		
					return true;
				return false;
			});
			vars.TortureChamberZipless = (Func <bool>)(() => {
				if(current.xPos1 >= 187.5 && current.xPos1 <= 192.5 &&
				   current.yPos1 >= -39 && current.yPos1 <= -37.5 &&
				   current.zPos1 >= -119.1 && current.zPos1 <= -118.9) 					
					return true;
				return false;
			});
			vars.TortureChamber = (Func <bool>)(() => {
				if(current.xPos1 >= 139.231 && current.xPos1 <= 139.233	&&
				   current.yPos1 >= 162.556 && current.yPos1 <= 162.558 && 
				   current.zPos1 >= -29.502 && current.zPos1 <= -29.5)
					return true;
				return false;
			});
			vars.TheElevator = (Func <bool>)(() => {
				if(current.xPos1 >= 74 && current.xPos1 <= 74.171 &&
				   current.yPos1 >= -46.751 && current.yPos1 <= -43.252 &&
				   current.zPos1 >= -33.501 && current.zPos1 <= -33.499) 		
					return true;
				return false;
			});
			vars.TheDreamZipless = (Func <bool>)(() => {
				if(current.xPos1 >= 99 && current.xPos1 <= 101 &&
				   current.yPos1 >= -11 && current.yPos1 <= -10 &&
				   current.zPos1 >= -56 && current.zPos1 <= -54) 		
					return true;
				return false;
			});
			vars.TheDream = (Func <bool>)(() => {
				if(current.xPos1 >= 95.8 && current.xPos1 <= 96 &&
				   current.yPos1 >= -25.1 && current.yPos1 <= -24.9 &&
				   current.zPos1 >= -74.9 && current.zPos1 <= -74.7)
					return true;
				return false;
			});
			vars.TheTomb = (Func <bool>)(() => {
				if(current.xPos1 >= 100.643 && current.xPos1 <= 100.645 &&
				   current.yPos1 >= -11.543 && current.yPos1 <= -11.541 &&
				   current.zPos1 >= -67.588 && current.zPos1 <= -67.586) 		
					return true;
				return false;
			});
			vars.TowerofDawn = (Func <bool>)(() => {
				if(current.xPos1 >= 35.5 && current.xPos1 <= 35.7 &&
				   current.yPos1 >= -50 && current.yPos1 <= -39	&&
				   current.zPos1 >= -32 && current.zPos1 <= -30) 		
					return true;
				return false;
			});
			vars.SettingSun = (Func <bool>)(() => {
				if(current.xPos1 >= 60 && current.xPos1 <= 61 &&
				   current.yPos1 >= -58 && current.yPos1 <= -57	&&
				   current.zPos1 >= 30 && current.zPos1 <= 32) 		
					return true;
				return false;
			});
			vars.HonorGlory = (Func <bool>)(() => {
				if(current.xPos1 >= 81 && current.xPos1 <= 82 &&
				   current.yPos1 >= -60.3 && current.yPos1 <= -59.7 &&
				   current.zPos1 >= 89 && current.zPos1 <= 90)
					return true;
				return false;
			});
			vars.GrandRewind = (Func <bool>)(() => {
				if(current.xPos1 >= 660.376 && current.xPos1 <= 660.378 &&
				  current.yPos1 >= 190.980 && current.yPos1 <= 190.983 &&
				  current.zPos1 >= 0.432 && current.zPos1 <= 0.434)
					return true;
				return false;
			});
			vars.SoTEnd = (Func <bool>)(() => {
				if(current.xPos1 >= 658.26 && current.xPos1 <= 661.46 &&
				   current.yPos1 >= 210.92 && current.yPos1 <= 213.72 &&
				   current.zPos1 >= 12.5)
					vars.aboveCredits = true;
				if(current.xPos1 >= 658.26 && current.xPos1 <= 661.46 &&
				   current.yPos1 >= 210.92 && current.yPos1 <= 213.72 &&
				   current.zPos1 >= 9.8 && current.zPos1 <= 12.5 &&
				   vars.aboveCredits)
					return true;
				if(current.vizierHealth == 4)				
					return true;
				return false;
			});
			vars.SoTLU = (Func <bool>)(() => {
				if(current.xPos1 >= -477.88 && current.xPos1 <= -477 &&
				   current.yPos1 >= -298 && current.yPos1 <= -297.1 &&
				   current.zPos1 >= -0.5 && current.zPos1 <= -0.4){
					vars.newFountain = true;
					}
				if(current.xPos1 >= -492.608 && current.xPos1 <= -492.606 &&
				   current.yPos1 >= -248.833 && current.yPos1 <= -248.831 &&
				   current.zPos1 >= 0.219 && current.zPos1 <= 0.221 &&
				   vars.newFountain){  
					vars.newFountain = false;
					return true;
					}
				return false;
			});
			
			//Checking category and qualifications to complete each split:
			switch(timer.Run.GetExtendedCategoryName())
			{
				case "Sands Trilogy (Any%, Standard)":
				case "Anthology":
					switch (timer.CurrentSplitIndex - (short)vars.offset)
					{
						case 0: return vars.GasStation();			//The Treasure Vaults
						case 1:	return vars.SandsUnleashed();			//The Sands of Time
						case 2:	return vars.SultanChamber();			//The Sultan's Chamber (Death)
						case 3:	return vars.DadDead();				//Death of the Sand King
						case 4:	return vars.TheBaths();				//The Baths (Death)
						case 5:	return vars.TheMesshall();			//The Messhall (Death)
						case 6:	return vars.TheCaves();				//The Caves
						case 7:	return vars.TheUGReservoir();			//Exit Underground Reservoir
						case 8: return vars.TheObservatory();			//The Observatory (Death)
						case 9:	return vars.TortureChamber();			//The Torture Chamber (Death)
						case 10: return vars.TheDream();			//The Dream
						case 11: return vars.HonorGlory();			//Honor and Glory
						case 12: return vars.GrandRewind();			//The Grand Rewind
						case 13: if(vars.SoTEnd())				//The End
								 {
									 vars.offset += 14;
									 vars.activeGame = 0;
									 return true;
								 }
						break;
					}
				break;
				case "Sands Trilogy (Any%, Zipless)":
				case "Sands Trilogy (Any%, No Major Glitches)":
					switch (timer.CurrentSplitIndex - (short)vars.offset)
					{
						case 0: return vars.GasStation();			//The Treasure Vaults
						case 1: return vars.SandsUnleashed();			//The Sands of Time
						case 2:	return vars.FirstGuestRoom();			//First Guest Room
						case 3: return vars.SultanChamberZipless();		//The Sultan's Chamber
						case 4: return vars.PalaceDefence();			//Exit Palace Defense
						case 5: return vars.DadStart();				//The Sand King
						case 6:	return vars.DadDead();				//Death of the Sand King
						case 7: return vars.TheWarehouse(); 			//The Warehouse
						case 8: return vars.TheZoo();				//The Zoo
						case 9: return vars.BirdCage();				//Atop a Bird Cage	
						case 10: return vars.CliffWaterfalls();			//Cliffs and Waterfall
						case 11: return vars.TheBaths();			//The Baths	
						case 12: return vars.SecondSword();			//Sword of the Mighty Warrior		
						case 13: return vars.TheDaybreak(); 			//Daybreak	
						case 14: return vars.DrawbridgeTower();			//Drawbridge Tower	
						case 15: return vars.BrokenBridge();			//A Broken Bridge
						case 16: return vars.TheCavesZipless();			//The Caves
						case 17: return vars.TheWaterfall();			//Waterfall
						case 18: return vars.TheUGReservoirZipless();		//An Underground Reservoir
						case 19: return vars.HallofLearning();			//Hall of Learning
						case 20: return vars.ObservatoryExit();			//Exit Observatory
						case 21: return vars.HoLCourtyardsExit();		//Exit Hall of Learning Courtyards 		
						case 22: return vars.TheAzadPrison();			//The Prison	
						case 23: return vars.TortureChamberZipless();		//The Torture Chamber				
						case 24: return vars.TheElevator();			//The Elevator
						case 25: return vars.TheDreamZipless();			//The Dream
						case 26: return vars.TheTomb();				//The Tomb
						case 27: return vars.TowerofDawn();			//The Tower of Dawn
						case 28: return vars.SettingSun();			//The Setting Sun
						case 29: return vars.HonorGlory();			//Honor and Glory
						case 30: return vars.GrandRewind();			//The Grand Rewind
						case 31: if(vars.SoTEnd())				//The End
								 {
									 vars.activeGame = 0;
									 vars.offset += 32;
									 return true;
								 }
						break;
					}
				break;
				case "Sands Trilogy (Completionist, Standard)":
					switch (timer.CurrentSplitIndex - (short)vars.offset)
					{
						case 0:	return vars.GasStation();			//The Treasure Vaults
						case 1: return vars.SandsUnleashed();			//The Sands of Time
						case 5:	return vars.TheBaths();				//The Baths (Death)
						case 7: return vars.TheMesshall();			//The Messhall (Death)
						case 9: return vars.TheCaves();				//The Caves (Death)
						case 12: return vars.TheObservatory();			//The Observatory (Death)
						case 15: return vars.TheDream();			//The Dream
						case 17: return vars.HonorGlory();			//Honor and Glory
						case 18: return vars.GrandRewind();			//The Grand Rewind
						case 2: 						//Life Upgrade 1
						case 3: 						//Life Upgrade 2
						case 4: 						//Life Upgrade 3
						case 6:							//Life Upgrade 4
						case 8:							//Life Upgrade 5
						case 10: 						//Life Upgrade 6
						case 11: 						//Life Upgrade 7
						case 13: 						//Life Upgrade 8
						case 14: 						//Life Upgrade 9
						case 16: return vars.SoTLU();				//Life Upgrade 10
						case 19: if(vars.SoTEnd())				//The End
								 {	
									 vars.activeGame = 0;
									 vars.offset += 20;
									 return true;
								 }
						break;
					}
				break;
				case "Sands Trilogy (Completionist, Zipless)":
				case "Sands Trilogy (Completionist, No Major Glitches)":
					switch (timer.CurrentSplitIndex - (short)vars.offset)
					{
						case 0:	return vars.GasStation();			//The Treasure Vaults
						case 1: return vars.SandsUnleashed();			//The Sands of Time
						case 2: return vars.FirstGuestRoom();			//First Guest Room
						case 4: return vars.PalaceDefence();			//Exit Palace Defense
						case 6: return vars.DadDead();				//Death of the Sand King
						case 8:	return vars.TheZoo(); 				//The Zoo
						case 9:	return vars.BirdCage(); 			//Atop a Bird Cage
						case 10: return vars.CliffWaterfalls();			//Cliffs and Waterfall
						case 11: return vars.TheBathsZipless();			//The Baths
						case 13: return vars.TheDaybreak();			//Daybreak
						case 14: return vars.DrawbridgeTower();			//Drawbridge Tower
						case 15: return vars.BrokenBridge();			//A Broken Bridge
						case 17: return vars.TheWaterfall();			//Waterfall
						case 18: return vars.TheUGReservoirZipless();		//An Underground Reservoir
						case 20: return vars.HallofLearning();			//Hall of Learning
						case 22: return vars.ObservatoryExit();			//Exit Observatory
						case 23: return vars.HoLCourtyardsExit();		//Exit Hall of Learning Courtyards
						case 24: return vars.TheAzadPrison();			//The Prison
						case 27: return vars.TheDream();			//The Dream
						case 28: return vars.TheTomb();				//The Tomb
						case 30: return vars.TowerofDawn();			//The Tower of Dawn
						case 31: return vars.SettingSun();			//The Setting Sun
						case 32: return vars.HonorGlory();			//Honor and Glory
						case 33: return vars.GrandRewind();			//The Grand Rewind
						case 3: 						//Life Upgrade 1
						case 5: 						//Life Upgrade 2
						case 7: 						//Life Upgrade 3
						case 12: 						//Life Upgrade 4
						case 16: 						//Life Upgrade 5
						case 19: 						//Life Upgrade 6
						case 21: 						//Life Upgrade 7
						case 25: 						//Life Upgrade 8
						case 26: 						//Life Upgrade 9
						case 29: return vars.SoTLU();				//Life Upgrade 10
						case 34: if(vars.SoTEnd())				//The End
								{
									 vars.activeGame = 0;
									 vars.offset += 35;
									 return true;
								}
						break;
					}
				break;
			}
		break;
	
		case 5: //WW
			//List of WW Splits across categories
			vars.TheBoat = (Func <bool>)(() => {
				if(current.xPos2 >= -1003 && current.xPos2 <= -995 &&
				   current.yPos2 >= -1028 && current.yPos2 <= -1016 &&
				   current.zPos2 >= 14 && current.zPos2 <= 15 &&
				   current.storyValue == 0 && current.bossHealth == 0)
					return true;
				return false;
			});
			vars.SpiderSword = (Func <bool>)(() => {
				if(current.xPos2 >= 43.3 && current.xPos2 <= 43.4 &&
				   current.yPos2 >= -75.7 && current.yPos2 <= -75.6 &&
				   current.zPos2 >= 370 && current.zPos2 <= 370.1 &&
				   current.storyValue == 7)
					return true;
				return false;
			});
			vars.TheRavenMan = (Func <bool>)(() => {
				if(current.xPos2 >= -5.359 && current.xPos2 <= -4.913 &&
				   current.yPos2 >= -161.539 && current.yPos2 <= -161.500 &&
				   current.zPos2 >= 66.5 && current.zPos2 <= 67.5 &&
				   current.storyValue == 2)
					return true;
				return false;
			});
			vars.TimePortal = (Func <bool>)(() => {
				if(current.xPos2 >= 122.8 && current.xPos2 <= 122.9 &&
				   current.yPos2 >= -156.1 && current.yPos2 <= -156 &&
				   current.zPos2 >= 368.5 && current.zPos2 <= 369.5 &&
				   current.storyValue == 2)			
					return true;
				return false;
			});
			vars.ChaseShadee = (Func <bool>)(() => {
				if(current.xPos2 >= 43.3 && current.xPos2 <= 43.4 &&
				   current.yPos2 >= -75.7 && current.yPos2 <= -75.6 &&
				   current.zPos2 >= 370 && current.zPos2 <= 370.1 &&
				   current.storyValue == 7)
					return true;
				return false;
			});
			vars.DamselDistress = (Func <bool>)(() => {
				if(current.xPos2 >= 115 && current.xPos2 <= 132 &&
				   current.yPos2 >= -114 && current.yPos2 <= -80 &&
				   current.zPos2 >= 357 && current.zPos2 <= 361 &&
				   current.storyValue == 8 && current.bossHealth == 0)
					return true;
				return false;
			});
			vars.TheDahaka = (Func <bool>)(() => {
				if(current.xPos2 >= 40.1 && current.xPos2 <= 42.4 &&
				   current.yPos2 >= -96.1 && current.yPos2 <= -95.9 &&
				   current.zPos2 >= 86 && current.zPos2 <= 86.1 &&
				   current.storyValue == 9)
					return true;
				return false;
			});
			vars.SerpentSword = (Func <bool>)(() => {
				if(current.xPos2 >= -96.5 && current.xPos2 <= -96.4 &&
				   current.yPos2 >= 41.3 && current.yPos2 <= 41.4 &&
				   current.zPos2 >= 407.4 && current.zPos2 <= 407.5 &&
				   current.storyValue == 13)
					return true;
				return false;
			});
			vars.GardenHall = (Func <bool>)(() => {
				if(current.xPos2 >= 66.9 && current.xPos2 <= 67.1 &&
				   current.yPos2 >= 11.4 && current.yPos2 <= 11.6 &&
				   current.zPos2 >= 400 && current.zPos2 <= 400.2 &&
				   current.storyValue == 22)
					return true;
				return false;
			});
			vars.WaterworksDone = (Func <bool>)(() => {
				if(current.xPos2 >= 23 && current.xPos2 <= 29 &&
				   current.yPos2 >= 41 && current.yPos2 <= 43 &&
				   current.zPos2 >= 441 && current.zPos2 <= 450 &&
				   current.storyValue == 22)
					return true;
				return false;
			});
			vars.LionSword = (Func <bool>)(() => {
				if(current.xPos2 >= -44.7 && current.xPos2 <= -44.6 &&
				   current.yPos2 >= -27.1 && current.yPos2 <= -27 &&
				   current.zPos2 >= 389 && current.zPos2 <= 389.1 &&
				   current.storyValue == 21)
					return true;
				return false;
			});
			vars.TheMechTower = (Func <bool>)(() => {
				if(current.xPos2 >= -167 && current.xPos2 <= -162 &&
				   current.yPos2 >= -47.5 && current.yPos2 <= -46 &&
				   current.zPos2 >= 409.6363 && current.zPos2 <= 412 &&
				   current.storyValue == 15)
					return true;
				return false;
			});
			vars.TheMechTowTENMG = (Func <bool>)(() => {
				if(current.xPos >= -208 && current.xPos <= -205 &&
				   current.yPos >= -35.5 && current.yPos <= -32.5 &&
				   current.zPos >= 419.9 && current.zPos <= 423 &&
				   current.storyValue == 63)
					return true;
				return false;
			});
			vars.RavagesPortal = (Func <bool>)(() => {
				if(current.xPos2 >= -210.018 && current.xPos2 <= -210.016 &&
				   current.yPos2 >= 164.259 && current.yPos2 <= 164.261 &&
				   current.zPos2 >= 440.9 && current.zPos2 <= 441.1 &&
				   current.storyValue == 16)
					return true;
				return false;
			});
			vars.ActivationRuins = (Func <bool>)(() => {
				if(current.xPos2 >= -206 && current.xPos2 <= -205.8 &&
				   current.yPos2 >= 59.8 && current.yPos2 <= 67.4 &&
				   current.zPos2 >= 162.6 && current.zPos2 <= 163.1 &&
				   current.storyValue == 18)
					return true;
				return false;
			});
			vars.ActivationDone = (Func <bool>)(() => {
				if(current.xPos2 >= -192.5 && current.xPos2 <= -189.5 &&
				   current.yPos2 >= 109 && current.yPos2 <= 111 &&
				   current.zPos2 >= 471.9 && current.zPos2 <= 472.1 &&
				   current.storyValue == 19)
					return true;
				return false;
			});
			vars.SandWraithDead = (Func <bool>)(() => {
				if(current.xPos2 >= -50 && current.xPos2 <= -39 &&
				   current.yPos2 >= -13 && current.yPos2 <= -5 &&
				   current.zPos2 >= 388.9 && current.zPos2 <= 389.8 &&
				   current.storyValue == 33)
					return true;
				return false;
			});
			vars.KaileenaDead = (Func <bool>)(() => {
				if(current.xPos2 >= -74 && current.xPos2 <= -31 &&
				   current.yPos2 >= 53.5 && current.yPos2 <= 104 &&
				   current.zPos2 >= 414 && current.zPos2 <= 422 &&
				   current.storyValue == 38 && current.bossHealth == 0)
					return true;
				return false;
			});
			vars.CatacombsExit = (Func <bool>)(() => {
				if(current.xPos2 >= -100 && current.xPos2 <= -97.5 &&
				   current.yPos2 >= -190 && current.yPos2 <= -187 &&
				   current.zPos2 >= 33 && current.zPos2 <= 33.2 &&
				   current.storyValue == 39)
					return true;
				return false;
			});
			vars.ScorpionSword = (Func <bool>)(() => {
				if(current.xPos2 >= -170.1 && current.xPos2 <= -170 &&
				   current.yPos2 >= -127.3 && current.yPos2 <= -127.2 &&
				   current.zPos2 >= 335.5 && current.zPos2 <= 336.5 &&
				   current.storyValue == 59)
					return true;
				return false;
			});
			vars.TheLibrary = (Func <bool>)(() => {
				if(current.xPos2 >= -112 && current.xPos2 <= -111 &&
				   current.yPos2 >= -144 && current.yPos2 <= -137 &&
				   current.zPos2 >= 384.9 && current.zPos2 <= 389)
					return true;
				return false;
			});
			vars.HourglassRevisited = (Func <bool>)(() => {
				if(current.xPos2 >= -108.3 && current.xPos2 <= -106 &&
				   current.yPos2 >= 40 && current.yPos2 <= 45 &&
				   current.zPos2 >= 407.3 && current.zPos2 <= 407.5 &&
				   current.storyValue == 45)
					return true;
				return false;
			});
			vars.MaskofWraith = (Func <bool>)(() => {
				if(current.xPos2 >= -20.5 && current.xPos2 <= -20.4 &&
				   current.yPos2 >= 236.8 && current.yPos2 <= 267 &&
				   current.zPos2 >= 133 && current.zPos2 <= 133.1 &&
				   current.storyValue == 46)
					return true;
				return false;
			});
			vars.SandGriffin = (Func <bool>)(() => {
				if(current.xPos2 >= -23 && current.xPos2 <= -15 &&
				   current.yPos2 >= 163 && current.yPos2 <= 166.5 &&
				   current.zPos2 >= 429 && current.zPos2 <= 431 &&
				   current.storyValue == 48)
					return true;
				return false;
			});
			vars.MirroredFates = (Func <bool>)(() => {
				if(current.xPos2 >= 136.7 && current.xPos2 <= 136.9 &&
				   current.yPos2 >= -110.6 && current.yPos2 <= -110.4 &&
				   current.zPos2 >= 377.9 && current.zPos2 <= 378 &&
				   current.storyValue == 55)
					return true;
				return false;
			});
			vars.FavourUnknown = (Func <bool>)(() => {
				if(current.xPos2 >= 41.1 && current.xPos2 <= 41.2 &&
				   current.yPos2 >= -180.1 && current.yPos2 <= -180 &&
				   current.zPos2 >= 368.9 && current.zPos2 <= 369.1 &&
				   current.storyValue == 57)
					return true;
				return false;
			});
			vars.RNGStorygate = (Func <bool>)(() => {
				if(old.storyValue != 59 && current.storyValue == 59)
					return true;
				return false;
			});
			vars.LightSword = (Func <bool>)(() => {
				if(current.secondaryWeapon == 50 && current.storyValue == 61)
					return true;
				return false;
			});
			vars.WWEndgame = (Func <bool>)(() => {
				if((old.storyValue != 63 && current.storyValue == 63))
					return true;
				return false;
			});
			vars.DeathofaPrince = (Func <bool>)(() => {
				if(current.xPos2 >= -67 && current.xPos2 <= -65.1 &&
				   current.yPos2 >= -23.3 && current.yPos2 <= -23.1 &&
				   current.zPos2 >= 399.9 && current.zPos2 <= 400 &&
				   current.storyValue == 64)
					return true;
				return false;
			});
			vars.SlomoPortal = (Func <bool>)(() => {
				if(current.xPos2 >= -52.7 && current.xPos2 <= -52.6 &&
				   current.yPos2 >= 137.2 && current.yPos2 <= 137.3 &&
				   current.zPos2 >= 418 && current.zPos2 <= 419 &&
				   current.storyValue == 66)
					return true;
				return false;
			});
			vars.WWEnd = (Func <bool>)(() => {
				if(current.xPos2 >= -35 && current.xPos2 <= -5 &&
				   current.yPos2 >= 170 && current.yPos2 <= 205 &&
				   current.zPos2 >= 128.9 && current.zPos2 <= 129.1 &&
				   current.storyValue >= 66 && current.bossHealth == 0)
					return true;
				return false;
			});
			vars.WWLU1 = (Func <bool>)(() => {
				if(current.xPos2 >= 52 && current.xPos2 <= 52.8 &&
				   current.yPos2 >= -188.7 && current.yPos2 <= -188.6 &&
				   current.zPos2 >= 381.9 && current.zPos2 <= 382.1 &&
				   current.storyValue == 2)
					return true;
				return false;
			});
			vars.WWLU2 = (Func <bool>)(() => {
				if(current.xPos2 >= -112.1 && current.xPos2 <= -112 &&
				   current.yPos2 >= -66.1 && current.yPos2 <= -65.2 &&
				   current.zPos2 >= 360.9 && current.zPos2 <= 361 &&
				   current.storyValue == 59)
					return true;
				return false;
			});
			vars.WWLU3 = (Func <bool>)(() => {
				if(current.xPos2 >= -74.8 && current.xPos2 <= -74.2 &&
				   current.yPos2 >= -102.8 && current.yPos2 <= -102.7 &&
				   current.zPos2 >= 378.9 && current.zPos2 <= 379 &&
				   current.storyValue == 60)
					return true;
				return false;
			});
			vars.WWLU4 = (Func <bool>)(() => {
				if(current.xPos2 >= -161.2 && current.xPos2 <= -161 &&
				   current.yPos2 >= 170.3 && current.yPos2 <= 171 &&
				   current.zPos2 >= 471.9 && current.zPos2 <= 472.1 &&
				   current.storyValue == 63)
					return true;
				return false;
			});
			vars.WWLU5 = (Func <bool>)(() => {
				if(current.xPos2 >= 138.8 && current.xPos2 <= 139 &&
				   current.yPos2 >= 115.3 && current.yPos2 <= 116.7 &&
				   current.zPos2 >= 382.5 && current.zPos2 <= 382.6 &&
				   current.storyValue == 64)
					return true;
				return false;
			});
			vars.WWLU6 = (Func <bool>)(() => {
				if(current.xPos2 >= 76.1 && current.xPos2 <= 76.2 &&
				   current.yPos2 >= 64.1 && current.yPos2 <= 64.9 &&
				   current.zPos2 >= 461.4 && current.zPos2 <= 461.6 &&
				   current.storyValue == 64)
					return true;
				return false;
			});
			vars.WWLU7 = (Func <bool>)(() => {
				if(current.xPos2 >= 190.2 && current.xPos2 <= 190.4 &&
				   current.yPos2 >= -131.9 && current.yPos2 <= -131.8 &&
				   current.zPos2 >= 353.9 && current.zPos2 <= 354.1 &&
				   current.storyValue == 64)
					return true;
				return false;
			});
			vars.WWLU8 = (Func <bool>)(() => {
				if(current.xPos2 >= 162.2 && current.xPos2 <= 162.7 &&
				   current.yPos2 >= -37.5 && current.yPos2 <= -37.3 &&
				   current.zPos2 >= 392.9 && current.zPos2 <= 393.1 &&
				   current.storyValue == 64)
					return true;
				return false;
			});
			vars.WWLU9 = (Func <bool>)(() => {
				if(current.xPos2 >= -114.7 && current.xPos2 <= -114.1 &&
				   current.yPos2 >= -47.2 && current.yPos2 <= -47 &&
				   current.zPos2 >= 368.9 && current.zPos2 <= 369.1 &&
				   current.storyValue == 64)
					return true;
				return false;
			});
			vars.WaterSword = (Func <bool>)(() => {
				if(current.xPos2 >= -96.643 && current.xPos2 <= -96.641 &&
				   current.yPos2 >= 43.059 && current.yPos2 <= 43.061 &&
				   current.zPos2 >= 407.4 && current.zPos2 <= 407.5 &&
				   current.storyValue == 66)
					return true;
				return false;
			});
			
			//Checking category and qualifications to complete each split:
			switch(timer.Run.GetExtendedCategoryName())
			{
				case "Sands Trilogy (Any%, Standard)":
				case "Sands Trilogy (Any%, Zipless)":
				case "Anthology":
					switch (timer.CurrentSplitIndex - (short)vars.offset)
					{
						case 0:	return vars.TheBoat();				//The Boat
						case 1: return vars.TheRavenMan();			//The Raven Man
						case 2: return vars.TimePortal();			//The Time Portal
						case 3: return vars.RNGStorygate();			//Mask of the Wraith (59)
						case 4: return vars.ScorpionSword();			//The Scorpion Sword
						case 5: return vars.WWEndgame();			//Storygate 63
						case 6: return vars.SlomoPortal();			//Back to the Future
						case 7: if(vars.WWEnd())				//The End
								{
									 vars.activeGame = 0;
									 vars.offset += 8;
									 return true;
								}
						break;
					}
				break;
				case "Sands Trilogy (Any%, No Major Glitches)":
					switch (timer.CurrentSplitIndex - (short)vars.offset)
					{
						case 0: return vars.TheBoat();				//The Boat
						case 1: return vars.SpiderSword();			//The Spider Sword
						case 2: return vars.ChaseShadee();			//Chasing Shadee
						case 3: return vars.DamselDistress();			//A Damsel in Distress
						case 4: return vars.TheDahaka();			//The Dahaka
						case 5: return vars.SerpentSword();			//The Serpent Sword
						case 6: return vars.GardenHall();			//The Garden Hall
						case 7: return vars.WaterworksDone();			//The Waterworks Restored
						case 8: return vars.LionSword();			//The Lion Sword
						case 9: return vars.TheMechTower();			//The Mechanical Tower
						case 10: return vars.RavagesPortal();			//Breath of Fate
						case 11: return vars.ActivationRuins();			//Activation Room in Ruin
						case 12: return vars.ActivationDone();			//Activation Room Restored
						case 13: return vars.SandWraithDead();			//The Death of a Sand Wraith
						case 14: return vars.KaileenaDead();			//Death of the Empress
						case 15: return vars.CatacombsExit();			//Exit the Tomb
						case 16: return vars.ScorpionSword();			//The Scorpion Sword
						case 17: return vars.TheLibrary();			//The Library
						case 18: return vars.HourglassRevisited();		//The Hourglass Revisited
						case 19: return vars.MaskofWraith();			//The Mask of the Wraith
						case 20: return vars.SandGriffin();			//The Sand Griffin
						case 21: return vars.MirroredFates();			//Mirrored Fates
						case 22: return vars.FavourUnknown();			//A Favor Unknown
						case 23: return vars.TheLibrary();			//The Library Revisited
						case 24: return vars.LightSword();			//The Light Sword
						case 25: return vars.DeathofaPrince();			//The Death of a Prince
						case 26: if(vars.WWEnd())				//The End
								 {
									 vars.activeGame = 0;
									 vars.offset += 27;
									 return true;
								 }
						break;
					}
				break;
				case "Sands Trilogy (Completionist, Standard)":
					switch (timer.CurrentSplitIndex - (short)vars.offset)
					{
						case 0: return vars.TheBoat();				//The Boat
						case 1: return vars.TheRavenMan();			//The Raven Man
						case 2:	return vars.WWLU1();				//Life Upgrade 1
						case 3: return vars.WWLU2();				//Life Upgrade 2
						case 4: return vars.WWLU3();				//Life Upgrade 3
						case 5: return vars.WWLU4();				//Life Upgrade 4
						case 6: return vars.WWLU5();				//Life Upgrade 5
						case 7: return vars.WWLU6();				//Life Upgrade 6
						case 8: return vars.WWLU7();				//Life Upgrade 7
						case 9: return vars.WWLU8();				//Life Upgrade 8
						case 10: return vars.WWLU9();				//Life Upgrade 9
						case 11: return vars.WaterSword();			//The Water Sword
						case 12: if(vars.WWEnd())				//The End
								 {
									 vars.activeGame = 0;
									 vars.offset += 13;
									 return true;
								 }
						break;
					}
				break;
				case "Sands Trilogy (Completionist, Zipless)":
					switch (timer.CurrentSplitIndex - (short)vars.offset)
					{
						case 0: return vars.TheBoat();				//The Boat
						case 1:	return vars.TheRavenMan();			//The Raven Man
						case 2:	return vars.WWLU9();				//Life Upgrade 1
						case 3: return vars.WWLU6();				//Life Upgrade 2
						case 4: return vars.WWLU5();				//Life Upgrade 3
						case 5: return vars.WWLU1();				//Life Upgrade 4
						case 6: return vars.RNGStorygate();			//Mask of the Wraith (59)
						case 7: return vars.WWLU2();				//Life Upgrade 5
						case 8: return vars.WWLU3();				//Life Upgrade 6
						case 9:	return vars.TheMechTowTENMG();			//The Mechanical Tower
						case 10: return vars.WWLU4();				//Life Upgrade 7
						case 11: return vars.WWLU8();				//Life Upgrade 8
						case 12: return vars.WWLU7();				//Life Upgrade 9
						case 13: return vars.WaterSword();			//The Water Sword
						case 14: if(vars.WWEnd())				//The End
								 {
									 vars.activeGame = 0;
									 vars.offset += 15;
									 return true;
								 }
						break;
					}
				break;
				case "Sands Trilogy (Completionist, No Major Glitches)":
					switch (timer.CurrentSplitIndex - (short)vars.offset)
					{
						case 0: return vars.TheBoat();				//The Boat
						case 1: return vars.SpiderSword();			//The Spider Sword
						case 2:	return vars.WWLU8();				//Life Upgrade 1
						case 3: return vars.DamselDistress();			//A Damsel in Distress
						case 4: return vars.WWLU7();				//Life Upgrade 2
						case 5: return vars.TheDahaka();			//The Dahaka
						case 6: return vars.WWLU1();				//Life Upgrade 3
						case 7:	return vars.SerpentSword();			//The Serpent Sword
						case 8: return vars.GardenHall();			//The Garden Hall
						case 9: return vars.WWLU6();				//Life Upgrade 4
						case 10: return vars.WWLU5();				//Life Upgrade 5
						case 11: return vars.WWLU9();				//Life Upgrade 6
						case 12: return vars.TheMechTower();			//The Mechanical Tower
						case 13: return vars.RavagesPortal();			//Breath of Fate
						case 14: return vars.ActivationRuins();			//Activation Room in Ruin
						case 15: return vars.WWLU4();				//Life Upgrade 7
						case 16: return vars.SandWraithDead();			//The Death of a Sand Wraith
						case 17: return vars.KaileenaDead();			//Death of the Empress
						case 18: return vars.CatacombsExit();			//Exit the Tomb
						case 19: return vars.ScorpionSword();			//The Scorpion Sword
						case 20: return vars.WWLU2();				//Life Upgrade 8
						case 21: return vars.WWLU3();				//Life Upgrade 9
						case 22: return vars.WaterSword();			//The Water Sword
						case 23: return vars.MaskofWraith();			//The Mask of the Wraith
						case 24: return vars.SandGriffin();			//The Sand Griffin
						case 25: return vars.MirroredFates();			//Mirrored Fates
						case 26: return vars.FavourUnknown();			//A Favor Unknown
						case 27: return vars.TheLibrary();			//The Library Revisited
						case 28: return vars.LightSword();			//The Light Sword
						case 29: return vars.DeathofaPrince();			//The Death of a Prince
						case 30: if(vars.WWEnd())				//The End
								 {
									 vars.activeGame = 0;
									 vars.offset += 31;
									 return true;
								 }
						break;
					}
				break;
			}
		break;
		
		case 6: //T2T
			//List of T2T Splits across categories:
			vars.TheRamparts = (Func <bool>)(() => {
				if(current.xPos3 >= -271 && current.xPos3 <= -265 &&
				   current.yPos3 >= 187	&& current.yPos3 <= 188  &&
				   current.zPos3 >= 74	&& current.zPos3 <= 75)
					return true;
				return false;
			});
			vars.HarbourDistrict = (Func <bool>)(() => {
				if(current.xPos3 >= -93   && current.xPos3 <= -88 &&
				   current.yPos3 >= 236.2 && current.yPos3 <= 238 &&
				   current.zPos3 >= 83	 && current.zPos3 <= 88)
					return true;
				return false;
			});
			vars.ThePalace = (Func <bool>)(() => {
				if(current.xPos3 >= -35.5 && current.xPos3 <= -35.4 &&
				   current.yPos3 >= 232.3 && current.yPos3 <= 232.4 &&
				   current.zPos3 >= 146.9 && current.zPos3 <= 147)
					return true;
				return false;
			});
			vars.TrappedHallway = (Func <bool>)(() => {
				if(current.xPos3 >= -52.1 && current.xPos3 <= -52.0 &&
				   current.yPos3 >= 135.8 && current.yPos3 <= 135.9 &&
				   current.zPos3 >= 75.8  && current.zPos3 <= 76)
					return true;
				return false;
			});
			vars.TheSewerz = (Func <bool>)(() => {
				if(current.xPos3 >= -100 && current.xPos3 <= -96 &&
				   current.yPos3 >= -83  && current.yPos3 <= -79 &&
				   current.zPos3 >= 19.9 && current.zPos3 <= 20)
					return true;
				return false;
			});
			vars.TheSewers = (Func <bool>)(() => {
				if(current.xPos3 >= -89.0 && current.xPos3 <= -88.0 &&
				   current.yPos3 >= -15.2 && current.yPos3 <= -14.7 &&
				   current.zPos3 >= 4.9	 && current.zPos3 <= 5.1)
					return true;
				return false;
			});
			vars.TheFortress = (Func <bool>)(() => {
				if(current.xPos3 >= -71.4 && current.xPos3 <= -71.3 &&
				   current.yPos3 >= 9.6   && current.yPos3 <= 9.7   &&
				   current.zPos3 >= 44    && current.zPos3 <= 44.1)
					return true;
				return false;
			});
			vars.LowerCity = (Func <bool>)(() => {
				if(current.xPos3 >= -319 && current.xPos3 <= -316.5 &&
				   current.yPos3 >= 317  && current.yPos3 <= 332.6  &&
				   current.zPos3 >= 95.1 && current.zPos3 <= 98)
					return true;
				return false;
			});
			vars.LowerCityRooftops = (Func <bool>)(() => {
				if(current.xPos3 >= -261.5 && current.xPos3 <= -261  &&
				   current.yPos3 >= 318    && current.yPos3 <= 319.5 &&
				   current.zPos3 >= 46     && current.zPos3 <= 48)
					return true;
				return false;
			});
			vars.LCRooftopZips = (Func <bool>)(() => {
				if(current.xPos3 >= -246  && current.xPos3 <= -241.5 &&
				   current.yPos3 >= 373.5 && current.yPos3 <= 383.6  &&
				   current.zPos3 >= 66    && current.zPos3 <= 69)
					return true;
				return false;
			});
			vars.TheBalconies = (Func <bool>)(() => {
				if(current.xPos3 >= -194 && current.xPos3 <= -190  &&
				   current.yPos3 >= 328  && current.yPos3 <= 329.7 &&
				   current.zPos3 >= 32.6 && current.zPos3 <= 33.6)
					return true;
				return false;
			});
			vars.DarkAlley = (Func <bool>)(() => {
				if(current.xPos3 >= -114 && current.xPos3 <= -110 &&
				   current.yPos3 >= 328  && current.yPos3 <= 338  &&
				   current.zPos3 >= 55   && current.zPos3 <= 59)
					return true;
				return false;
			});
			vars.TheTempleRooftops = (Func <bool>)(() => {
				if(current.xPos3 >= -122.6 && current.xPos3 <= -117.7 &&
				   current.yPos3 >= 421.6  && current.yPos3 <= 423    &&
				   current.zPos3 >= 107    && current.zPos3 <= 108.1)
					return true;
				return false;
			});
			vars.TheTemple = (Func <bool>)(() => {
				if(current.xPos3 >= -212.2 && current.xPos3 <= -211.9 &&
				   current.yPos3 >= 419.0  && current.yPos3 <= 419.8  &&
				   current.zPos3 >= 81     && current.zPos3 <= 82)
					return true;
				return false;
			});
			vars.TheMarketplace= (Func <bool>)(() => {
				if(current.xPos3 >= -213 && current.xPos3 <= -207 &&
				   current.yPos3 >= 484  && current.yPos3 <= 490  &&
				   current.zPos3 >= 101  && current.zPos3 <= 103)
					return true;
				return false;
			});
			vars.MarketDistrict = (Func <bool>)(() => {
				if(current.xPos3 >= -185.5 && current.xPos3 <= -175.5 &&
				   current.yPos3 >= 524    && current.yPos3 <= 530    &&
				   current.zPos3 >= 90     && current.zPos3 <= 92)
					return true;
				return false;
			});
			vars.TheBrothel = (Func <bool>)(() => {
				if(current.xPos3 >= -152.3 && current.xPos3 <= -152.0 &&
				   current.yPos3 >= 549.8  && current.yPos3 <= 549.9  &&
				   current.zPos3 >= 91.8   && current.zPos3 <= 92)
					return true;
				return false;
			});
			vars.ThePlaza = (Func <bool>)(() => {
				if(current.xPos3 >= -104  && current.xPos3 <= -100 &&
				   current.yPos3 >= 548   && current.yPos3 <= 553  &&
				   current.zPos3 >= 105.9 && current.zPos3 <= 106.1)
					return true;
				return false;
			});
			vars.TheUpperCity = (Func <bool>)(() => {
				if(current.xPos3 >= -124.5 && current.xPos3 <= -122.5 &&
				   current.yPos3 >= 500    && current.yPos3 <= 505    &&
				   current.zPos3 >= 97     && current.zPos3 <= 99)
					return true;
				return false;
			});
			vars.CityGarderns = (Func <bool>)(() => {
				if(current.xPos3 >= -63.5 && current.xPos3 <= -63.4 &&
				   current.yPos3 >= 389.7 && current.yPos3 <= 389.8 &&
				   current.zPos3 >= 85.2  && current.zPos3 <= 85.3)
					return true;
				return false;
			});
			vars.ThePromenade = (Func <bool>)(() => {
				if(current.xPos3 >= -3  && current.xPos3 <= -1  &&
				   current.yPos3 >= 515 && current.yPos3 <= 519 &&
				   current.zPos3 >= 72  && current.zPos3 <= 75)
					return true;
				return false;
			});
			vars.RoyalWorkshop = (Func <bool>)(() => {
				if(current.xPos3 >= 58  && current.xPos3 <= 62  &&
				   current.yPos3 >= 470 && current.yPos3 <= 480 &&
				   current.zPos3 >= 79  && current.zPos3 <= 81)
					return true;
				return false;
			});
			vars.KingsRoad = (Func <bool>)(() => {
				if(current.xPos3 >= 91.9289  && current.xPos3 <= 91.9290  &&
				   current.yPos3 >= 230.0479 && current.yPos3 <= 230.0480 &&
				   current.zPos3 >= 70.9877  && current.zPos3 <= 70.9879)
					return true;
				return false;
			});
			vars.KingzRoad = (Func <bool>)(() => {
				if(current.xPos3 >= 53  && current.xPos3 <= 70  &&
				   current.yPos3 >= 240 && current.yPos3 <= 250 &&
				   current.zPos3 >= 70 && current.zPos3 <= 73)
					return true;	
				return false;
			});
			vars.PalaceEntrance = (Func <bool>)(() => {
				if(current.xPos3 >= 30.8  && current.xPos3 <= 30.9  &&
				   current.yPos3 >= 271.2 && current.yPos3 <= 271.3 &&
				   current.zPos3 >= 126   && current.zPos3 <= 126.1)
					return true;	
				return false;
			});
			vars.HangingGardens = (Func <bool>)(() => {
				if(current.xPos3 >= 26  && current.xPos3 <= 28  &&
				   current.yPos3 >= 211 && current.yPos3 <= 213 &&
				   current.zPos3 >= 191 && current.zPos3 <= 193)
					return true;
				return false;
			});
			vars.StructuresMind = (Func <bool>)(() => {
				if(current.xPos3 >= -34 && current.xPos3 <= -27 &&
				   current.yPos3 >= 240 && current.yPos3 <= 250 &&
				   current.zPos3 >= 178 && current.zPos3 <= 180)
					return true;
				return false;
			});
			vars.StructurezMind = (Func <bool>)(() => {
				if(current.xPos3 >= 5   && current.xPos3 <= 12  &&
				   current.yPos3 >= 243 && current.yPos3 <= 265 &&
				   current.zPos3 >= 104 && current.zPos3 <= 104.1)
					return true;	
				return false;
			});
			vars.WellofZipless = (Func <bool>)(() => {
				if(current.xPos3 >= -28  && current.xPos3 <= -26.5 &&
				   current.yPos3 >= 250  && current.yPos3 <= 255   &&
				   current.zPos3 >= 20.9 && current.zPos3 <= 30)
					return true;	
				return false;
			});
			vars.WellofAncestors = (Func <bool>)(() => {
				if(current.xPos3 >= -12.6 && current.xPos3 <= -12.5 &&
				   current.yPos3 >= 241.2 && current.yPos3 <= 241.3 &&
				   current.zPos3 >= 0.9   && current.zPos3 <= 1)
					return true;
				return false;
			});
			vars.TheLabyrinth = (Func <bool>)(() => {
				if(current.xPos3 >= -25.5 && current.xPos3 <= -23 &&
				   current.yPos3 >= 325   && current.yPos3 <= 338 &&
				   current.zPos3 >= 35.9  && current.zPos3 <= 36.1)
					return true;	
				return false;
			});
			vars.UndergroundCave = (Func <bool>)(() => {
				if(current.xPos3 >= -11 && current.xPos3 <= -9  &&
				   current.yPos3 >= 327 && current.yPos3 <= 334 &&
				   current.zPos3 >= 73  && current.zPos3 <= 74)
					return true;
				return false;
			});
			vars.UndergroundCaveZipnt = (Func <bool>)(() => {
				if(current.xPos3 >= 27    && current.xPos3 <= 29  &&
				   current.yPos3 >= 316.5 && current.yPos3 <= 318 &&
				   current.zPos3 >= 99.9  && current.zPos3 <= 100.1)
					return true;	
				return false;
			});
			vars.LowerTower = (Func <bool>)(() => {
				if(current.xPos3 >= -5    && current.xPos3 <= -3    &&
				   current.yPos3 >= 316   && current.yPos3 <= 317.5 &&
				   current.zPos3 >= 139.9 && current.zPos3 <= 140.1)
					return true;
				return false;
			});
			vars.MiddleTower = (Func <bool>)(() => {
				if(current.xPos3 >= -18   && current.xPos3 <= -12 &&
				   current.yPos3 >= 303   && current.yPos3 <= 305 &&
				   current.zPos3 >= 184.8 && current.zPos3 <= 185.1)
					return true;
				return false;
			});
			vars.UpperTower = (Func <bool>)(() => {
				if(current.xPos3 >= -8    && current.xPos3 <= -7  &&
				   current.yPos3 >= 296   && current.yPos3 <= 298 &&
				   current.zPos3 >= 226.9 && current.zPos3 <= 227)
					return true;		
				return false;
			});
			vars.TheTerrace = (Func <bool>)(() => {
				if(current.xPos3 >= -7.2  && current.xPos3 <= -6.9  &&
				   current.yPos3 >= 245.6 && current.yPos3 <= 245.9 &&
				   current.zPos3 >= 677   && current.zPos3 <= 679)
					return true;		
				return false;
			});
			vars.MentalRealm = (Func <bool>)(() => {
				if(current.xPos3 >= 189     && current.xPos3 <= 193 &&
				   current.yPos3 >= 319.135 && current.yPos3 <= 320 &&
				   current.zPos3 >= 542	   && current.zPos3 <= 543)
					return true;		
				return false;
			});
			vars.T2TLU1 = (Func <bool>)(() => {
				if(current.xPos3 >= -14.9972  && current.xPos3 <= -14.9970  &&
				   current.yPos3 >= -112.8152 && current.yPos3 <= -112.8150 &&
				   current.zPos3 >= 20.0732   && current.zPos3 <= 20.0734)
					return true;		
				return false;
			});
			vars.T2TLU2 = (Func <bool>)(() => {
				if(current.xPos3 >= -302.0919 && current.xPos3 <= -302.0917 &&
				   current.yPos3 >= 370.8710  && current.yPos3 <= 370.8712  &&
				   current.zPos3 >= 52.858 && current.zPos3 <= 52.8582)
					return true;		
				return false;
			});
			vars.T2TLU3 = (Func <bool>)(() => {
				if(current.xPos3 >= -187.3369 && current.xPos3 <= -187.3367 &&
				   current.yPos3 >= -455.9863 && current.yPos3 <= 455.9865  &&
				   current.zPos3 >= 78.0330   && current.zPos3 <= 78.0332)
					return true;		
				return false;
			});
			vars.T2TLU4 = (Func <bool>)(() => {
				if(current.xPos3 >= -55.0147 && current.xPos3 <= -55.0145 &&
				   current.yPos3 >= 395.7608 && current.yPos3 <= 395.761  &&
				   current.zPos3 >= 72.0774  && current.zPos3 <= 72.0776)
					return true;		
				return false;
			});
			vars.T2TLU5 = (Func <bool>)(() => {
				if(current.xPos3 >= -30.1223 && current.xPos3 <= -30.1221 &&
				   current.yPos3 >= 281.8893 && current.yPos3 <= 281.8895 &&
				   current.zPos3 >= 104.0796 && current.zPos3 <= 104.0798)
					return true;
				return false;
			});
			vars.T2TLU6 = (Func <bool>)(() => {
				if(current.xPos3 >= -23.9663 && current.xPos3 <= -23.9661 &&
				   current.yPos3 >= 253.9438 && current.yPos3 <= 253.944  &&
				   current.zPos3 >= 183.0634 && current.zPos3 <= 183.0636)
					return true;		
				return false;
			});
			
			//Checking category and qualifications to complete each split:
			switch(timer.Run.GetExtendedCategoryName())
			{
				case "Sands Trilogy (Any%, Standard)":
				case "Anthology":
					switch (timer.CurrentSplitIndex - (short)vars.offset)
					{
						case 0: return vars.TheRamparts;			//The Ramparts
						case 1:	return vars.HarbourDistrict();			//The Harbor District
						case 2:	return vars.ThePalace();			//The Palace
						case 3:	return vars.TheSewerz();			//Exit Sewers
						case 4:	return vars.LowerCity();			//Exit Lower City
						case 5:	return vars.LCRooftopZips();			//The Lower City Rooftops
						case 6:	return vars.TheTempleRooftops();		//Exit Temple Rooftops
						case 7:	return vars.TheMarketplace();			//Exit Marketplace
						case 8:	return vars.ThePlaza();				//Exit Plaza
						case 9:	return vars.CityGarderns();			//Exit City Gardens
						case 10: return vars.RoyalWorkshop();			//Exit Royal Workshop
						case 11: return vars.KingzRoad();			//The King's Road
						case 12: return vars.StructurezMind();			//Exit Structure's Mind
						case 13: return vars.TheLabyrinth();			//Exit Labyrinth
						case 14: return vars.UpperTower();			//The Towers
						case 15: return vars.TheTerrace();			//The Terrace
						case 16: if(vars.MentalRealm())				//The Mental Realm
								 {		
									 vars.activeGame = 0;
									 vars.offset += 17;
									 return true;
								 }
						break;
					}
				break;
				case "Sands Trilogy (Any%, Zipless)":
					switch (timer.CurrentSplitIndex - (short)vars.offset)
					{
						case 0: return vars.TheRamparts();			//The Ramparts
						case 1:	return vars.HarbourDistrict();			//The Harbor District
						case 2:	return vars.ThePalace();			//The Palace
						case 3:	return vars.TrappedHallway();			//The Trapped Hallway
						case 4:	return vars.TheSewers();			//The Sewers
						case 5:	return vars.TheFortress();			//The Fortress
						case 6:	return vars.LowerCity();			//The Lower City
						case 7: return vars.LowerCityRooftops();		//The Lower City Rooftops
						case 8:	return vars.TheBalconies();			//The Balconies
						case 9:	return vars.DarkAlley();			//The Dark Alley
						case 10: return vars.TheTempleRooftops();		//The Temple Rooftops
						case 11: return vars.TheMarketplace();			//Exit Marketplace
						case 12: return vars.MarketDistrict();			//The Market District
						case 13: return vars.ThePlaza();			//Exit Plaza
						case 14: return vars.TheUpperCity();			//The Upper City
						case 15: return vars.CityGarderns();			//The City Garderns
						case 16: return vars.ThePromenade();			//The Promenade
						case 17: return vars.RoyalWorkshop();			//The Royal Workshop
						case 18: return vars.KingsRoad();			//The King's Road
						case 19: return vars.PalaceEntrance();			//The Palace Entrance
						case 20: return vars.HangingGardens();			//The Hanging Gardens
						case 21: return vars.WellofZipless();			//The Structure's Mind
						case 22: return vars.WellofAncestors();			//The Well of Ancestors
						case 23: return vars.TheLabyrinth();			//The Labyrinth
						case 24: return vars.UndergroundCaveZipnt();		//The Underground Cave
						case 25: return vars.LowerTower();			//The Lower Tower
						case 26: return vars.UpperTower();			//The Middle and Upper Towers
						case 27: return vars.TheTerrace();			//The Death of the Vizier
						case 28: if(vars.MentalRealm())				//The Mental Realm
								 {
									 vars.activeGame = 0;
									 vars.offset += 29;
									 return true;
								 }
						break;
					}
				break;	
				case "Sands Trilogy (Any%, No Major Glitches)":
					switch (timer.CurrentSplitIndex - (short)vars.offset)
					{
						case 0: return vars.TheRamparts();			//The Ramparts
						case 1:	return vars.HarbourDistrict();			//The Harbor District
						case 2: return vars.ThePalace();			//The Palace
						case 3:	return vars.TrappedHallway();			//The Trapped Hallway
						case 4:	return vars.TheSewers();			//The Sewers
						case 5: return vars.TheFortress();			//The Fortress
						case 6:	return vars.LowerCity();			//The Lower City
						case 7: return vars.LowerCityRooftops();		//The Lower City Rooftops
						case 8:	return vars.TheBalconies();			//The Balconies
						case 9:	return vars.DarkAlley();			//The Dark Alley
						case 10: return vars.TheTempleRooftops();		//The Temple Rooftops
						case 11: return vars.TheTemple();			//The Temple
						case 12: return vars.TheMarketplace();			//The Marketplace	
						case 13: return vars.MarketDistrict();			//The Market District
						case 14: return vars.TheBrothel();			//The Brothel
						case 15: return vars.ThePlaza();			//The Plaza
						case 16: return vars.TheUpperCity();			//The Upper City			
						case 17: return vars.CityGarderns();			//The City Gardens
						case 18: return vars.ThePromenade();			//The Promenade
						case 19: return vars.RoyalWorkshop();			//The Royal Workshop
						case 20: return vars.KingsRoad();			//The King's Road			
						case 21: return vars.PalaceEntrance();			//The Palace Entrance
						case 22: return vars.HangingGardens();			//The Hanging Gardens
						case 23: return vars.StructuresMind();			//The Structure's Mind
						case 24: return vars.WellofAncestors();			//The Well of Ancestors
						case 25: return vars.TheLabyrinth();			//The Labyrinth
						case 26: return vars.UndergroundCave();			//The Underground Cave
						case 27: return vars.LowerTower();			//The Lower Tower
						case 28: return vars.MiddleTower();			//The Middle Tower	
						case 29: return vars.UpperTower();			//The Upper Tower
						case 30: return vars.TheTerrace();			//The Terrace		
						case 31: if(vars.MentalRealm())
								 {
									 vars.activeGame = 0;
									 vars.offset += 32;
									 return true;
								 }
						break;
					}
				break;
				case "Sands Trilogy (Completionist, Standard)":
					switch (timer.CurrentSplitIndex - (short)vars.offset)
					{
						case 0: return vars.TheRamparts();			//The Ramparts
						case 1: return vars.HarbourDistrict();			//The Harbour District
						case 2: return vars.ThePalace();			//The Palace
						case 3: return vars.T2TLU1();				//Life Upgrade 1
						case 4:	return vars.LowerCity();			//Exit Lower City
						case 5:	return vars.T2TLU2();				//Life Upgrade 2
						case 6:	return vars.LCRooftopZips();			//The Arena
						case 7:	return vars.TheTempleRooftops();		//The Temple Rooftops Exit
						case 8:	return vars.T2TLU3();				//Life Upgrade 3
						case 9:	return vars.TheMarketplace();			//The Marketplace
						case 10: return vars.ThePlaza();			//Exit Plaza
						case 11: return vars.T2TLU4();				//Life Upgrade 4
						case 12: return vars.RoyalWorkshop();			//The Royal Workshop
						case 13: return vars.KingzRoad();			//The King's Road
						case 14: return vars.T2TLU5();				//Life Upgrade 5
						case 15: return vars.StructurezMind();			//Exit Structure's Mind
						case 16: return vars.TheLabyrinth();			//Exit Labyrinth
						case 17: return vars.T2TLU6();				//Life Upgrade 6
						case 18: return vars.UpperTower();			//The Upper Tower
						case 19: return vars.TheTerrace();			//The Terrace
						case 20: if(vars.MentalRealm())				//The Mental Realm
								 {
									 vars.activeGame = 0;
									 vars.offset += 21;
									 return true;
								 }
						break;
					}
				break;
				case "Sands Trilogy (Completionist, Zipless)":
					switch (timer.CurrentSplitIndex - (short)vars.offset)
					{
						case 0: return vars.TheRamparts();			//The Ramparts
						case 1: return vars.HarbourDistrict();			//The Harbour District
						case 2: return vars.ThePalace();			//The Palace
						case 3: return vars.TrappedHallway();			//The Trapped Hallway
						case 4: return vars.T2TLU1();				//Life Upgrade 1
						case 5:	return vars.TheFortress();			//The Fortress
						case 6:	return vars.LowerCity();			//The Lower City
						case 7:	return vars.T2TLU2();				//Life Upgrade 2
						case 8:	return vars.LowerCityRooftops();		//The Arena
						case 9:	return vars.TheBalconies();			//The Balconies
						case 10: return vars.DarkAlley();			//The Dark Alley
						case 11: return vars.TheTempleRooftops();		//The Temple Rooftops
						case 12: return vars.T2TLU3();				//Life Upgrade 3
						case 13: return vars.TheMarketplace();			//The Marketplace
						case 14: return vars.MarketDistrict();			//The Market District
						case 15: return vars.ThePlaza();			//Exit Plaza
						case 16: return vars.TheUpperCity();			//The Upper City
						case 17: return vars.T2TLU4();				//Life Upgrade 4
						case 18: return vars.ThePromenade();			//The Promenade
						case 19: return vars.RoyalWorkshop();			//The Royal Workshop
						case 20: return vars.KingsRoad();			//The King's Road
						case 21: return vars.T2TLU5();				//Life Upgrade 5
						case 22: return vars.HangingGardens();			//The Hanging Gardens
						case 23: return vars.WellofZipless();			//The Structures Mind
						case 24: return vars.WellofAncestors();			//The Well of Ancestors
						case 25: return vars.TheLabyrinth();			//The Labyrinth
						case 26: return vars.UndergroundCaveZipnt();		//The Underground Cave
						case 27: return vars.LowerTower();			//The Lower Tower
						case 28: return vars.T2TLU6();				//Life Upgrade 6
						case 29: return vars.UpperTower();			//The Upper Tower
						case 30: return vars.TheTerrace();			//The Terrace
						case 31: if(vars.MentalRealm())				//The Mental Realm
								 {
									 vars.activeGame = 0;
									 vars.offset += 32;
									 return true;
								 }
						break;
					}
				break;
				case "Sands Trilogy (Completionist, No Major Glitches)":
					switch (timer.CurrentSplitIndex - (short)vars.offset)
					{
						case 0: return vars.TheRamparts();			//The Ramparts
						case 1: return vars.HarbourDistrict();			//The Harbour District
						case 2: return vars.ThePalace();			//The Palace
						case 3: return vars.TrappedHallway();			//The Trapped Hallway
						case 4: return vars.T2TLU1();				//Life Upgrade 1
						case 5:	return vars.TheFortress();			//The Fortress
						case 6:	return vars.LowerCity();			//The Lower City
						case 7:	return vars.T2TLU2();				//Life Upgrade 2
						case 8:	return vars.LowerCityRooftops();		//The Arena
						case 9:	return vars.TheBalconies();			//The Balconies
						case 10: return vars.DarkAlley();			//The Dark Alley
						case 11: return vars.TheTempleRooftops();		//The Temple Rooftops
						case 12: return vars.T2TLU3();				//Life Upgrade 3
						case 13: return vars.TheMarketplace();			//The Marketplace
						case 14: return vars.MarketDistrict();			//The Market District
						case 15: return vars.TheBrothel();			//The Brothel
						case 16: return vars.ThePlaza();			//The Plaza
						case 17: return vars.TheUpperCity();			//The Upper City
						case 18: return vars.T2TLU4();				//Life Upgrade 4
						case 19: return vars.ThePromenade();			//The Promenade
						case 20: return vars.RoyalWorkshop();			//The Royal Workshop
						case 21: return vars.KingsRoad();			//The King's Road
						case 22: return vars.T2TLU5();				//Life Upgrade 5
						case 23: return vars.HangingGardens();			//The Hanging Gardens
						case 24: return vars.WellofZipless();			//The Structures Mind
						case 25: return vars.WellofAncestors();			//The Well of Ancestors
						case 26: return vars.TheLabyrinth();			//The Labyrinth
						case 27: return vars.UndergroundCaveZipnt();		//The Underground Cave
						case 28: return vars.LowerTower();			//The Lower Tower
						case 29: return vars.T2TLU6();				//Life Upgrade 6
						case 30: return vars.UpperTower();			//The Upper Tower
						case 31: return vars.TheTerrace();			//The Terrace
						case 32: if(vars.MentalRealm())				//The Mental Realm
								 {
									 vars.activeGame = 0;
									 vars.offset += 33;
									 return true;
								 }
						break;
					}
				break;
			}
		break;

		case 7: //2k8
		//List of splits functions
		vars.SplitSeed = (Func <float, float, float, bool>)((float xTarg, float yTarg, float zTarg) => {								//This is a standard type of split which occurs when the prince is within a certain range of coords and has just got a seed
			if(current.xPos <= (xTarg+2) && current.xPos >= (xTarg-2) &&
			   current.yPos <= (yTarg+2) && current.yPos >= (yTarg-2) &&
			   current.zPos <= (zTarg+2) && current.zPos >= (zTarg-2) &&
			   vars.seedGet)
				return true;		
			return false;
		});
		vars.SplitBoss = (Func <float, float, float, float, bool>)((float xTarg, float yTarg, float zTarg, float size) => {			//This is a standard type of split which occurs when the prince is within a platform and has just killed a boss
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
	
		//Unmarking flags from the previous cycle:
		vars.kill = false;
		vars.seedGet = false;
		
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
			case 31: if(vars.Resurrection())					//Resurrection
					 {
						 vars.activeGame = 0;
						 vars.offset += 32;
						 return true;
					 }
			break;
		}
		break;
		
		case 8: //TFS
		//List of TFS splits and functions
		vars.SplitTFScp = (Func <int, int, int, bool>)((xTarg, yTarg, zTarg) => {				//This is a standard type of split which occurs when the prince is within a certain range of coords and a checkposhort is just acquired
			if(current.xPos <= (xTarg+10) && current.xPos >= (xTarg-10) &&
			   current.yPos <= (yTarg+10) && current.yPos >= (yTarg-10) &&
			   current.zPos <= (zTarg+10) && current.zPos >= (zTarg-10) &&
			   vars.cpGet)
				return true;		
			return false;
		});
		vars.Possession = (Func <int, int, int, bool>)((xTarg, yTarg, zTarg) => {				//This is same as above but trigger size reduced as there are 2 checkpoints very near
			if(current.xPos <= (xTarg+1) && current.xPos >= (xTarg-1) &&
			   current.yPos <= (yTarg+1) && current.yPos >= (yTarg-1) &&
			   current.zPos <= (zTarg+1) && current.zPos >= (zTarg-1) &&
			   vars.cpGet)
				return true;		
			return false;
		});
		vars.TheEnd = (Func <int, int, int, bool>)((xTarg, yTarg, zTarg) => {					//This is split occurs purely based on when the prince is within a certain range of coords
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
			case 16: if(vars.TheEnd(821, -257, -51))			//The End
					 {
						 vars.activeGame = 0;
						 vars.offset += 17;
						 return true;
					 }
			break;
		}
		break;
	}
}
