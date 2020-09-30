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
//PoP1
	settings.Add("sound", false, "Sound for PoP1 ON At Start?");
	
//PoP2
	short ResetDelta = 0;
	bool Resetting = false;
		
//SoT
	bool aboveCredits = false;
	bool newFountain = false;
	bool startUp = false;

//2k8
	bool kill = false;
	bool seedGet = false;
	bool startUp2k8 = false;
	int xTarget = 0;
	int yTarget = 0;
	int zTarget = 0;

//TFS
	bool cpGet = false;
	bool startUptfs = false;
	int xTarget2 = 0;
	int yTarget2 = 0;
	int zTarget2 = 0;	
}
 

start
{
	switch(timer.Run.GetExtendedCategoryName())
	{
	 case "Anthology":
		//PoP1 Start
		// start (sound) && if starting level = 1 AND if level = 1 AND if Minutes = 60 AND count is = 47120384
		return
		((current.Sound == 0 && settings["sound"] == true) || (settings["sound"] == false)) &&
			(current.Start == 0x1) && 
			(current.Level == 0x1) && 
			(current.Time == 0x3C) && 
			(current.Count >= 0x2CE0000);
		break;
	
	case "Sands Trilogy (Any%, Standard)":
	case "Sands Trilogy (Any%, Zipless)":
	case "Sands Trilogy (Any%, No Major Glitches)":
	case "Sands Trilogy (Completionist, Standard)":
	case "Sands Trilogy (Completionist, Zipless)":
	case "Sands Trilogy (Completionist, No Major Glitches)":
		vars.aboveCredits = false;
		vars.newFountain = false;
		vars.startUp = true;
	
		//Detecting if the game has started on the balcony.
		if(current.xPos1 >= -103.264 && current.yPos1 >= -4.8 && current.zPos1 >= 1.341 && current.xPos1 <= -103.262 && current.yPos1 <= -4.798 && current.zPos1 <= 1.343 && current.startValue == 1)
			return true;
		break;
	}
}


isLoading
{
	switch(timer.Run.GetExtendedCategoryName())
	{
	 case "Anthology":
		if(current.xPos3d == 0 && current.yPos3d == 0 && current.zPos3d == 0)
		{
			return true;
		}
		if(current.isMenu == 0 || current.isLoading)
		{
			return true;
		}
	break;
	case "Sands Trilogy (Any%, Standard)":
	case "Sands Trilogy (Any%, Zipless)":
	case "Sands Trilogy (Any%, No Major Glitches)":
	case "Sands Trilogy (Completionist, Standard)":
	case "Sands Trilogy (Completionist, Zipless)":
	case "Sands Trilogy (Completionist, No Major Glitches)":
	break;
	}
}


split
{	
	if(!vars.startUp){
	vars.aboveCredits = false;
	vars.newFountain = false;
	vars.startUp = true;	
	}
	
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
	
	//List of T2T Splits across categories
	
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
	
	//Calling the splits after checking the category
	
	switch(timer.Run.GetExtendedCategoryName())
	{
		case "Sands Trilogy (Any%, Standard)":
		//SoT
			switch (timer.CurrentSplitIndex)
			{
			//The Treasure Vaults
			case 0:
				if(vars.GasStation())
					return true;
				break;
			//The Sands of Time
			case 1:
				if(vars.SandsUnleashed())
					return true;
				break;
			//The Sultan's Chamber (Death)
			case 2:
				if(vars.SultanChamber())
					return true;
				break;
			//Death of the Sand King
			case 3:
				if(vars.DadDead())
							return true;
				break;
			//The Baths (Death)
			case 4:
				if(vars.TheBaths())
					return true;
				break;
			//The Messhall (Death)
			case 5:
				if(vars.TheMesshall())
					return true;
				break;
			//The Caves
			case 6:
				if(vars.TheCaves())
					return true;
				break;
			//Exit Underground Reservoir
			case 7:
				if(vars.TheUGReservoir())
					return true;
				break;
			//The Observatory (Death)
			case 8:
				if(vars.TheObservatory())
					return true;
				break;
			//The Torture Chamber (Death)
			case 9:
				if(vars.TortureChamber())
					return true;
				break;
			//The Dream
			case 10:
				if(vars.TheDream())
					return true;
				break;
			//Honor and Glory
			case 11:
				if(vars.HonorGlory())
					return true;
				break;
			//The Grand Rewind
			case 12:
				if(vars.GrandRewind())
					return true;
				break;
			//The End
			case 13:
				if(vars.SoTEnd())				
					return true;
				break;
			}
		//Setup 1
			if (timer.CurrentSplitIndex == 14)			//~edit: the number here must be equal to the number of splits in the first game.
			{
				if(old.startValue2 == 1 && current.startValue2 == 2)
				{
					if(current.xPos2 >= -997.6757 && current.xPos2 <= -997.6755)
					return true;
				}
			}
		//WW
			switch (timer.CurrentSplitIndex - 15)
			{
			//The Boat
			case 0:
				if(vars.TheBoat())
					return true;
				break;
			//The Raven Man
			case 1:
				if(vars.TheRavenMan())
					return true;
				break;
			//The Time Portal
			case 2:
				if(vars.TimePortal())			
					return true;
				break;
			//Mask of the Wraith (59)
			case 3:
				if(vars.RNGStorygate())
					return true;
				break;
			//The Scorpion Sword
			case 4:
				if(vars.ScorpionSword())
					return true;
				break;
			//Storygate 63
			case 5:
				if(vars.WWEndgame())
					return true;
				break;
			//Back to the Future
			case 6:
				if(vars.SlomoPortal())
					return true;
				break;
			//The End
			case 7:
				if(vars.WWEnd())
					return true;
				break;
			}
		//Setup 2
			if (timer.CurrentSplitIndex == 23)													//~edit: here the number is [# of splits in first game] + [# of splits in second game] + 1
			{
				if(current.xPos3 >= -409.9 && current.xPos3 <= -404.8 && current.yCam <= 0.1082 && current.yCam >= 0.1080 && current.xCam <= 0.832 && current.xCam >= 0.8318)
					return true;
			}
		//T2T
			switch (timer.CurrentSplitIndex - 24)												//~edit: the number we subract here is [# of splits in first game] + [# of splits in second game] + 2
			{
			//The Ramparts
			case 0:
				if(vars.TheRamparts())
					return true;
				break;
			//The Harbor District
			case 1:	
				if(vars.HarbourDistrict())
					return true;	
				break;
			//The Palace
			case 2:	
				if(vars.ThePalace())
					return true;	
				break;
			//Exit Sewers
			case 3:	
				if(vars.TheSewerz())
					return true;	
				break;
			//Exit Lower City
			case 4:	
				if(vars.LowerCity())
					return true;	
				break;
			//The Lower City Rooftops
			case 5:	
				if(vars.LCRooftopZips())
					return true;	
				break;
			//Exit Temple Rooftops
			case 6:	
				if(vars.TheTempleRooftops())
					return true;	
				break;
			//Exit Marketplace
			case 7:	
				if(vars.TheMarketplace())
					return true;	
				break;
			//Exit Plaza
			case 8:	
				if(vars.ThePlaza())
					return true;	
				break;
			//Exit City Gardens
			case 9:	
				if(vars.CityGarderns())
					return true;	
				break;
			//Exit Royal Workshop
			case 10:	
				if(vars.RoyalWorkshop())
					return true;	
				break;
			//The King's Road
			case 11:	
				if(vars.KingzRoad())
					return true;	
				break;
			//Exit Structure's Mind
			case 12:	
				if(vars.StructurezMind())
					return true;	
				break;
			//Exit Labyrinth
			case 13:	
				if(vars.TheLabyrinth())
					return true;	
				break;
			//The Towers
			case 14:	
				if(vars.UpperTower())
					return true;	
				break;
			//The Terrace
			case 15:	
				if(vars.TheTerrace())
					return true;
				break;
			//The Mental Realm
			case 16:	
				if(vars.MentalRealm())
					return true;	
				break;
			}
		break;
		
		case "Sands Trilogy (Any%, Zipless)":
		//SoT
			switch (timer.CurrentSplitIndex)
			{
			//The Treasure Vaults
			case 0:
				if(vars.GasStation())
					return true;
				break;
			//The Sands of Time
			case 1:
				if(vars.SandsUnleashed())
					return true;
				break;
			//First Guest Room
			case 2: 
				if(vars.FirstGuestRoom())
					return true;
				break;
			//The Sultan's Chamber
			case 3: 
				if(vars.SultanChamberZipless()) 		
					return true;
				break;
			//Exit Palace Defense
			case 4: 
				if(vars.PalaceDefence()) 		
					return true;
				break;
			//The Sand King
			case 5:
				if(vars.DadStart()) 		
					return true;
				break;
			//Death of the Sand King
			case 6:
				if(vars.DadDead()) 		
					return true;
				break;
			//The Warehouse
			case 7:
				if(vars.TheWarehouse()) 		
					return true;
				break;
			//The Zoo
			case 8:	
				if(vars.TheZoo())
					return true;
				break;
			//Atop a Bird Cage
			case 9:
				if(vars.BirdCage()) 		
					return true;
				break;
			//Cliffs and Waterfall
			case 10:
				if(vars.CliffWaterfalls()) 		
					return true;
				break;
			//The Baths
			case 11:
				if(vars.TheBaths()) 		
					return true;
				break;
			//Sword of the Mighty Warrior
			case 12:
				if(vars.SecondSword()) 		
					return true;
				break;
			//Daybreak
			case 13:	
				if(vars.TheDaybreak()) 		
					return true;
				break;
			//Drawbridge Tower
			case 14:
				if(vars.DrawbridgeTower()) 		
					return true;
				break;
			//A Broken Bridge
			case 15:
				if(vars.BrokenBridge()) 		
					return true;
				break;
			//The Caves
			case 16:
				if(vars.TheCavesZipless()) 		
					return true;
				break;
			//Waterfall
			case 17:
				if(vars.TheWaterfall())		
					return true;
				break;
			//An Underground Reservoir
			case 18:
				if(vars.TheUGReservoirZipless()) 		
					return true;
				break;
			//Hall of Learning
			case 19:
				if(vars.HallofLearning()) 		
					return true;
				break;
			//Exit Observatory
			case 20:
				if(vars.ObservatoryExit()) 		
					return true;
				break;
			//Exit Hall of Learning Courtyards
			case 21:
				if(vars.HoLCourtyardsExit()) 		
					return true;
				break;
			//The Prison
			case 22:
				if(vars.TheAzadPrison()) 		
					return true;
				break;
			//The Torture Chamber
			case 23:
				if(vars.TortureChamberZipless()) 					
					return true;
				break;
			//The Elevator
			case 24:
				if(vars.TheElevator())		
					return true;
				break;
			//The Dream
			case 25:
				if(vars.TheDreamZipless()) 		
					return true;
				break;
			//The Tomb
			case 26:
				if(vars.TheTomb())		
					return true;
				break;
			//The Tower of Dawn
			case 27:
				if(vars.TowerofDawn()) 		
					return true;
				break;
			//The Setting Sun
			case 28:
				if(vars.SettingSun()) 		
					return true;
				break;
			//Honor and Glory
			case 29:
				if(vars.HonorGlory()) 							
					return true;
				break;
			//The Grand Rewind
			case 30:
				if(vars.GrandRewind()) 			
					return true;
				break;
			//The End
			case 31:
				if(vars.SoTEnd())
					return true;
				break;
			}
		//Setup 1
			if (timer.CurrentSplitIndex == 32)			//~edit: the number here must be equal to the number of splits in the first game.
			{
				if(old.startValue2 == 1 && current.startValue2 == 2)
				{
					if(current.xPos2 >= -997.6757 && current.xPos2 <= -997.6755)
					return true;
				}
			}
		//WW
			switch (timer.CurrentSplitIndex - 33)		//~edit: here the number is [# of splits in first game] + 1
			{
			//The Boat
			case 0:
				if(vars.TheBoat())
					return true;
				break;
			//The Raven Man
			case 1:
				if(vars.TheRavenMan())
					return true;
				break;
			//The Time Portal
			case 2:
				if(vars.TimePortal())			
					return true;
				break;
			//Mask of the Wraith (59)
			case 3:
				if(vars.RNGStorygate())
					return true;
				break;
			//The Scorpion Sword
			case 4:
				if(vars.ScorpionSword())
					return true;
				break;
			//Storygate 63
			case 5:
				if(vars.WWEndgame())
					return true;
				break;
			//Back to the Future
			case 6:
				if(vars.SlomoPortal())
					return true;
				break;
			//The End
			case 7:
				if(vars.WWEnd())
					return true;
				break;
			}
		//Setup 2
			if (timer.CurrentSplitIndex == 41)			//~edit: here the number is [# of splits in first game] + [# of splits in second game] + 1
			{
				if(current.xPos3 >= -409.9 && current.xPos3 <= -404.8 && current.yCam <= 0.1082 && current.yCam >= 0.1080 && current.xCam <= 0.832 && current.xCam >= 0.8318)
					return true;
			}
		//T2T
			switch (timer.CurrentSplitIndex - 42)		//~edit: the number we subract here is [# of splits in first game] + [# of splits in second game] + 2
			{
			//The Ramparts
			case 0:
				if(vars.TheRamparts())
					return true;
				break;
			//The Harbor District
			case 1:	
				if(vars.HarbourDistrict())
					return true;	
				break;
			//The Palace
			case 2:	
				if(vars.ThePalace())
					return true;	
				break;
			//The Trapped Hallway
			case 3:
				if(vars.TrappedHallway())
					return true;
				break;
			//The Sewers
			case 4:
				if(vars.TheSewers())
					return true;
				break;
			//The Fortress
			case 5:
				if(vars.TheFortress())
					return true;
				break;
			//The Lower City
			case 6:
				if(vars.LowerCity())
					return true;
				break;
			//The Lower City Rooftops
			case 7:
				if(vars.LowerCityRooftops())
					return true;
				break;
			//The Balconies
			case 8:
				if(vars.TheBalconies())
					return true;
				break;
			//The Dark Alley
			case 9:
				if(vars.DarkAlley())
					return true;
				break;
			//The Temple Rooftops()
			case 10:
				if(vars.TheTempleRooftops())
					return true;
				break;
			//Exit Marketplace
			case 11:
				if(vars.TheMarketplace())
					return true;
				break;
			//The Market District
			case 12:
				if(vars.MarketDistrict())
					return true;
				break;
			//Exit Plaza
			case 13:
				if(vars.ThePlaza())
					return true;
				break;
			//The Upper City
			case 14:
				if(vars.TheUpperCity())
					return true;
				break;
			//The City Garderns
			case 15:
				if(vars.CityGarderns())
					return true;
				break;
			//The Promenade
			case 16:
				if(vars.ThePromenade())
					return true;
				break;
			//The Royal Workshop
			case 17:
				if(vars.RoyalWorkshop())
					return true;
				break;
			//The King's Road
			case 18:
				if(vars.KingsRoad())
					return true;
				break;
			//The Palace Entrance
			case 19:
				if(vars.PalaceEntrance())
					return true;
				break;
			//The Hanging Gardens
			case 20:
				if(vars.HangingGardens())
					return true;
				break;
			//The Structure's Mind
			case 21:
				if(vars.WellofZipless())
					return true;
				break;
			//The Well of Ancestors
			case 22:
				if(vars.WellofAncestors())
					return true;
				break;
			//The Labyrinth
			case 23:
				if(vars.TheLabyrinth())
					return true;
				break;
			//The Underground Cave
			case 24:
				if(vars.UndergroundCaveZipnt())
					return true;
				break;
			//The Lower Tower
			case 25:
				if(vars.LowerTower())
					return true;
				break;
			//The Middle and Upper Towers
			case 26:
				if(vars.UpperTower())
					return true;
				break;
			//The Death of the Vizier
			case 27:
				if(vars.TheTerrace())
					return true;
				break;
			//The Mental Realm
			case 28:	
				if(vars.MentalRealm())
					return true;	
				break;
			}
		break;
		
		case "Sands Trilogy (Any%, No Major Glitches)":
		//SoT
			switch (timer.CurrentSplitIndex)
			{
			//The Treasure Vaults
			case 0:
				if(vars.GasStation())
					return true;
				break;
			//The Sands of Time
			case 1:
				if(vars.SandsUnleashed())
					return true;
				break;
			//First Guest Room
			case 2: 
				if(vars.FirstGuestRoom())
					return true;
				break;
			//The Sultan's Chamber
			case 3: 
				if(vars.SultanChamberZipless()) 		
					return true;
				break;
			//Exit Palace Defense
			case 4: 
				if(vars.PalaceDefence()) 		
					return true;
				break;
			//The Sand King
			case 5:
				if(vars.DadStart()) 		
					return true;
				break;
			//Death of the Sand King
			case 6:
				if(vars.DadDead()) 		
					return true;
				break;
			//The Warehouse
			case 7:
				if(vars.TheWarehouse()) 		
					return true;
				break;
			//The Zoo
			case 8:	
				if(vars.TheZoo())
					return true;
				break;
			//Atop a Bird Cage
			case 9:
				if(vars.BirdCage()) 		
					return true;
				break;
			//Cliffs and Waterfall
			case 10:
				if(vars.CliffWaterfalls()) 		
					return true;
				break;
			//The Baths
			case 11:
				if(vars.TheBaths()) 		
					return true;
				break;
			//Sword of the Mighty Warrior
			case 12:
				if(vars.SecondSword()) 		
					return true;
				break;
			//Daybreak
			case 13:	
				if(vars.TheDaybreak()) 		
					return true;
				break;
			//Drawbridge Tower
			case 14:
				if(vars.DrawbridgeTower()) 		
					return true;
				break;
			//A Broken Bridge
			case 15:
				if(vars.BrokenBridge()) 		
					return true;
				break;
			//The Caves
			case 16:
				if(vars.TheCavesZipless()) 		
					return true;
				break;
			//Waterfall
			case 17:
				if(vars.TheWaterfall())		
					return true;
				break;
			//An Underground Reservoir
			case 18:
				if(vars.TheUGReservoirZipless()) 		
					return true;
				break;
			//Hall of Learning
			case 19:
				if(vars.HallofLearning()) 		
					return true;
				break;
			//Exit Observatory
			case 20:
				if(vars.ObservatoryExit()) 		
					return true;
				break;
			//Exit Hall of Learning Courtyards
			case 21:
				if(vars.HoLCourtyardsExit()) 		
					return true;
				break;
			//The Prison
			case 22:
				if(vars.TheAzadPrison()) 		
					return true;
				break;
			//The Torture Chamber
			case 23:
				if(vars.TortureChamberZipless()) 					
					return true;
				break;
			//The Elevator
			case 24:
				if(vars.TheElevator())		
					return true;
				break;
			//The Dream
			case 25:
				if(vars.TheDreamZipless()) 		
					return true;
				break;
			//The Tomb
			case 26:
				if(vars.TheTomb())		
					return true;
				break;
			//The Tower of Dawn
			case 27:
				if(vars.TowerofDawn()) 		
					return true;
				break;
			//The Setting Sun
			case 28:
				if(vars.SettingSun()) 		
					return true;
				break;
			//Honor and Glory
			case 29:
				if(vars.HonorGlory()) 							
					return true;
				break;
			//The Grand Rewind
			case 30:
				if(vars.GrandRewind()) 			
					return true;
				break;
			//The End
			case 31:
				if(vars.SoTEnd())
					return true;
				break;
			}
		//Setup 1
			if (timer.CurrentSplitIndex == 32)			//~edit: the number here must be equal to the number of splits in the first game.
			{
				if(old.startValue2 == 1 && current.startValue2 == 2)
				{
					if(current.xPos2 >= -997.6757 && current.xPos2 <= -997.6755)
					return true;
				}
			}
		//WW
			switch (timer.CurrentSplitIndex - 33)		//~edit: the number we subtract here is [# of splits in first game] + 1
			{
			//The Boat
			case 0:
				if(vars.TheBoat())
					return true;
				break;
			//The Spider Sword
			case 1:
				if(vars.SpiderSword())
					return true;
				break;
			//Chasing Shadee
			case 2:
				if(vars.ChaseShadee())
					return true;
				break;
			//A Damsel in Distress
			case 3:
				if(vars.DamselDistress())
					return true;
				break;
			//The Dahaka
			case 4:
				if(vars.TheDahaka())
					return true;
				break;
			//The Serpent Sword
			case 5:
				if(vars.SerpentSword())
					return true;
				break;
			//The Garden Hall
			case 6:
				if(vars.GardenHall())
					return true;
				break;
			//The Waterworks Restored
			case 7:
				if(vars.WaterworksDone())
					return true;
				break;
			//The Lion Sword
			case 8:
				if(vars.LionSword())
					return true;
				break;
			//The Mechanical Tower
			case 9:
				if(vars.TheMechTower())
					return true;
				break;
			//Breath of Fate
			case 10:
				if(vars.RavagesPortal())
					return true;
				break;
			//Activation Room in Ruin
			case 11:
				if(vars.ActivationRuins())
					return true;
				break;
			//Activation Room Restored
			case 12:
				if(vars.ActivationDone())
					return true;
				break;
			//The Death of a Sand Wraith
			case 13:
				if(vars.SandWraithDead())
					return true;
				break;
			//Death of the Empress
			case 14:
				if(vars.KaileenaDead())
					return true;
				break;
			//Exit the Tomb
			case 15:
				if(vars.CatacombsExit())
					return true;
				break;
			//The Scorpion Sword
			case 16:
				if(vars.ScorpionSword())
					return true;
				break;
			//The Library
			case 17:
				if(vars.TheLibrary())
					return true;
				break;
			//The Hourglass Revisited
			case 18:
				if(vars.HourglassRevisited())
					return true;
				break;
			//The Mask of the Wraith
			case 19:
				if(vars.MaskofWraith())
					return true;
				break;
			//The Sand Griffin
			case 20:
				if(vars.SandGriffin())
					return true;
				break;
			//Mirrored Fates
			case 21:
				if(vars.MirroredFates())
					return true;
				break;
			//A Favor Unknown
			case 22:
				if(vars.FavourUnknown())
					return true;
				break;
			//The Library Revisited
			case 23:
				if(vars.TheLibrary())
					return true;
				break;
			//The Light Sword
			case 24:
				if(vars.LightSword())
					return true;
				break;
			//The Death of a Prince
			case 25:
				if(vars.DeathofaPrince())
					return true;
				break;
			//The End
			case 26:
				if(vars.WWEnd())
					return true;
				break;
			}
		//Setup 2
			if (timer.CurrentSplitIndex == 60)			//~edit: here the number is [# of splits in first game] + [# of splits in second game] + 1
			{
				if(current.xPos3 >= -409.9 && current.xPos3 <= -404.8 && current.yCam <= 0.1082 && current.yCam >= 0.1080 && current.xCam <= 0.832 && current.xCam >= 0.8318)
					return true;
			}
		//T2T
			switch (timer.CurrentSplitIndex - 61)		//~edit: the number we subract here is [# of splits in first game] + [# of splits in second game] + 2
			{
			//The Ramparts			
			case 0:
				if(vars.TheRamparts())
					return true;
				break;
			//The Harbor District
			case 1:	
				if(vars.HarbourDistrict())
					return true;	
				break;
			//The Palace
			case 2:	
				if(vars.ThePalace())
					return true;	
				break;
			//The Trapped Hallway
			case 3:
				if(vars.TrappedHallway())
					return true;
				break;
			//The Sewers
			case 4:
				if(vars.TheSewers())
					return true;
				break;
			//The Fortress			
			case 5:
				if(vars.TheFortress())
					return true;
				break;
			//The Lower City			
			case 6:
				if(vars.LowerCity())
					return true;
				break;
			//The Lower City Rooftops
			case 7:
				if(vars.LowerCityRooftops())
					return true;
				break;
			//The Balconies
			case 8:
				if(vars.TheBalconies())
					return true;
				break;
			//The Dark Alley			
			case 9:
				if(vars.DarkAlley())
					return true;
				break;
			//The Temple Rooftops
			case 10:
				if(vars.TheTempleRooftops())
					return true;
				break;
			//The Temple
			case 11:
				if(vars.TheTemple())
					return true;
				break; 
			//The Marketplace
			case 12:
				if(vars.TheMarketplace())
					return true;
				break;
			//The Market District			
			case 13:
				if(vars.MarketDistrict())
					return true;
				break;
			//The Brothel
			case 14:
				if(vars.TheBrothel())
					return true;
				break;
			//The Plaza
			case 15:
				if(vars.ThePlaza())
					return true;
				break;
			//The Upper City
			case 16:
				if(vars.TheUpperCity())
					return true;
				break;
			//The City Gardens			
			case 17:
				if(vars.CityGarderns())
					return true;
				break;
			//The Promenade
			case 18:
				if(vars.ThePromenade())
					return true;
				break;
			//The Royal Workshop
			case 19:
				if(vars.RoyalWorkshop())
					return true;
				break;
			//The King's Road
			case 20:
				if(vars.KingsRoad())
					return true;
				break;
			//The Palace Entrance			
			case 21:
				if(vars.PalaceEntrance())
					return true;
				break;
			//The Hanging Gardens
			case 22:
				if(vars.HangingGardens())
					return true;
				break;
			//The Structure's Mind
			case 23:
				if(vars.StructuresMind())
					return true;
				break;
			//The Well of Ancestors
			case 24:
				if(vars.WellofAncestors())
					return true;
				break;
			//The Labyrinth
			case 25:
				if(vars.TheLabyrinth())
					return true;
				break;
			//The Underground Cave
			case 26:
				if(vars.UndergroundCave())
					return true;
				break;
			//The Lower Tower
			case 27:
				if(vars.LowerTower())
					return true;
				break;
			//The Middle Tower
			case 28:
				if(vars.MiddleTower())
					return true;
				break;			
				//The Upper Tower
			case 29:
				if(vars.UpperTower())
					return true;
				break;
			//The Terrace
			case 30:	
				if(vars.TheTerrace())
					return true;
				break;
			//The Mental Realm			
			case 31:	
				if(vars.MentalRealm())
					return true;	
				break;
			}
		break;
			
		case "Sands Trilogy (Completionist, Standard)":
		//SoT
			switch (timer.CurrentSplitIndex)
			{
			//The Treasure Vaults
			case 0:
				if(vars.GasStation())
					return true;
				break;
			//The Sands of Time
			case 1:
				if(vars.SandsUnleashed())
					return true;
				break;
			//Life Upgrade 1
			case 2:
				if(vars.SoTLU())
					return true;
				break;
			//Life Upgrade 2
			case 3:	
				if(vars.SoTLU())
					return true;
				break;
			//Life Upgrade 3
			case 4:
				if(vars.SoTLU())
					return true;
				break;
			//The Baths (Death)
			case 5:	
				if(vars.TheBaths)
					return true;
				break;
			//Life Upgrade 4
			case 6:	
				if(vars.SoTLU())
					return true;
				break;
			//The Messhall (Death)
			case 7:	
				if(vars.TheMesshall())
					return true;
				break;
			//Life Upgrade 5
			case 8:	
				if(vars.SoTLU())
					return true;
				break;
			//The Caves (Death)
			case 9:	
				if(vars.TheCaves())
					return true;
				break;
			//Life Upgrade 6
			case 10:	
				if(vars.SoTLU())
					return true;
				break;
			//Life Upgrade 7
			case 11:	
				if(vars.SoTLU())
					return true;
				break;
			//The Observatory (Death)
			case 12:	
				if(vars.TheObservatory())
					return true;
				break;
			//Life Upgrade 8
			case 13:	
				if(vars.SoTLU())
					return true;
				break;
			//Life Upgrade 9
			case 14:	
				if(vars.SoTLU())
					return true;
				break;
			//The Dream
			case 15:	
				if(vars.TheDream())
					return true;
				break;
			//Life Upgrade 10
			case 16:	
				if(vars.SoTLU())
					return true;
				break;
			//Honor and Glory
			case 17:	
				if(vars.HonorGlory())
					return true;
				break;
			//The Grand Rewind
			case 18:	
				if(vars.GrandRewind())
					return true;
				break;
			//The End
			case 19:
				if(vars.SoTEnd())	
					return true;
				break;
			}
		//Setup 1
			if (timer.CurrentSplitIndex == 20)			//~edit: the number here must be equal to the number of splits in the first game.
			{
				if(old.startValue2 == 1 && current.startValue2 == 2)
				{
					if(current.xPos2 >= -997.6757 && current.xPos2 <= -997.6755)
					return true;
				}
			}
		//WW
			switch (timer.CurrentSplitIndex - 21)		//~edit: the number we subtract here is [# of splits in first game] + 1
			{
			//The Boat
			case 0:
				if(vars.TheBoat())
					return true;
				break;
			//The Raven Man
			case 1:
				if(vars.TheRavenMan())
					return true;
				break;
			//Life Upgrade 1
			case 2:
				if(vars.WWLU1())
					return true;
				break;
			//Life Upgrade 2
			case 3:
				if(vars.WWLU2())
					return true;
				break;
			//Life Upgrade 3
			case 4:
				if(vars.WWLU3())
					return true;
				break;
			//Life Upgrade 4
			case 5:
				if(vars.WWLU4())
					return true;
				break;
			//Life Upgrade 5
			case 6:
				if(vars.WWLU5())
					return true;
				break;
			//Life Upgrade 6
			case 7:
				if(vars.WWLU6())
					return true;
				break;
			//Life Upgrade 7
			case 8:
				if(vars.WWLU7())
					return true;
				break;
			//Life Upgrade 8
			case 9:
				if(vars.WWLU8())
					return true;
				break;
			//Life Upgrade 9
			case 10:
				if(vars.WWLU9())
					return true;
				break;
			//The Water Sword
			case 11:
				if(vars.WaterSword())
					return true;
				break;
			//The End
			case 12:
				if(vars.WWEnd())
					return true;
				break;
			}
		//Setup 2
			if (timer.CurrentSplitIndex == 34)			//~edit: here the number is [# of splits in first game] + [# of splits in second game] + 1
			{
				if(current.xPos3 >= -409.9 && current.xPos3 <= -404.8 && current.yCam <= 0.1082 && current.yCam >= 0.1080 && current.xCam <= 0.832 && current.xCam >= 0.8318)
					return true;
			}
		//T2T
			switch (timer.CurrentSplitIndex - 35)		//~edit: the number we subract here is [# of splits in first game] + [# of splits in second game] + 2
			{
			//The Ramparts
			case 0:
				if(vars.TheRamparts())
					return true;
				break;
			//The Harbour District
			case 1:	
				if(vars.HarbourDistrict())
					return true;	
				break;
			//The Palace
			case 2:	
				if(vars.ThePalace())
					return true;	
				break;
			//Life Upgrade 1
			case 3:	
				if(vars.T2TLU1())
					return true;	
				break;
			//Exit Lower City
			case 4:	
				if(vars.LowerCity())
					return true;	
				break;
			//Life Upgrade 2
			case 5:	
				if(vars.T2TLU2())
					return true;	
				break;	
			//The Arena
			case 6:	
				if(vars.LCRooftopZips())
					return true;	
				break;
			//The Temple Rooftops Exit
			case 7:	
				if(vars.TheTempleRooftops())
					return true;	
				break;
			//Life Upgrade 3
			case 8:	
				if(vars.T2TLU3())
					return true;	
				break;
			//The Marketplace
			case 9:	
				if(vars.TheMarketplace())
					return true;	
				break;
			//Exit Plaza
			case 10:	
				if(vars.ThePlaza())
					return true;	
				break;
			//Life Upgrade 4
			case 11:	
				if(vars.T2TLU4())
					return true;	
				break;
			//The Royal Workshop
			case 12:	
				if(vars.RoyalWorkshop())
					return true;	
				break;
			//The King's Road
			case 13:	
				if(vars.KingzRoad())
					return true;	
				break;
			//Life Upgrade 5
			case 14:	
				if(vars.T2TLU5)
					return true;	
				break;
			//Exit Structure's Mind
			case 15:	
				if(vars.StructurezMind())
					return true;	
				break;
			//Exit Labyrinth
			case 16:	
				if(vars.TheLabyrinth())
					return true;	
				break;
			//Life Upgrade 6
			case 17:	
				if(vars.T2TLU6())
					return true;	
				break;
			//The Upper Tower
			case 18:	
				if(vars.UpperTower())
					return true;	
				break;
			//The Terrace
			case 19:	
				if(vars.TheTerrace())
					return true;
				break;
			//The Mental Realm
			case 20:	
				if(vars.MentalRealm())
					return true;	
				break;
			}
		break;
		
		case "Sands Trilogy (Completionist, Zipless)":
		//SoT
			switch (timer.CurrentSplitIndex)
			{
			//The Treasure Vaults
			case 0:
				if(vars.GasStation())
					return true;
				break;
			//The Sands of Time
			case 1:
				if(vars.SandsUnleashed())
					return true;
				break;
			//First Guest Room
			case 2: 
				if(vars.FirstGuestRoom())
					return true;
				break;
			//Life Upgrade 1
			case 3:	
				if(vars.SoTLU())
					return true;
				break;
			//Exit Palace Defense
			case 4: 
				if(vars.PalaceDefence()) 		
					return true;
				break;
			//Life Upgrade 2
			case 5:	
				if(vars.SoTLU())
					return true;
				break;
			//Death of the Sand King
			case 6:
				if(vars.DadDead()) 		
					return true;
				break;
			//Life Upgrade 3
			case 7:	
				if(vars.SoTLU())
					return true;
				break;
			//The Zoo
			case 8:	
				if(vars.TheZoo()) 		
					return true;
				break;
			//Atop a Bird Cage
			case 9:
				if(vars.BirdCage()) 		
					return true;
				break;
			//Cliffs and Waterfall
			case 10:
				if(vars.CliffWaterfalls()) 		
					return true;
				break;
			//The Baths
			case 11:
				if(vars.TheBathsZipless()) 		
					return true;
				break;
			//Life Upgrade 4
			case 12:	
				if(vars.SoTLU())
					return true;
				break;
			//Daybreak
			case 13:	
				if(vars.TheDaybreak()) 		
					return true;
				break;
			//Drawbridge Tower
			case 14:
				if(vars.DrawbridgeTower()) 		
					return true;
				break;
			//A Broken Bridge
			case 15:
				if(vars.BrokenBridge()) 		
					return true;
				break;
			//Life Upgrade 5
			case 16:	
				if(vars.SoTLU())
					return true;
				break;
			//Waterfall
			case 17:
				if(vars.TheWaterfall())		
					return true;
				break;
			//An Underground Reservoir
			case 18:
				if(vars.TheUGReservoirZipless()) 		
					return true;
				break;
			//Life Upgrade 6
			case 19:	
				if(vars.SoTLU())
					return true;
				break;
			//Hall of Learning
			case 20:
				if(vars.HallofLearning()) 		
					return true;
				break;
			//Life Upgrade 7
			case 21:	
				if(vars.SoTLU())
					return true;
				break;
			//Exit Observatory
			case 22:
				if(vars.ObservatoryExit()) 		
					return true;
				break;
			//Exit Hall of Learning Courtyards
			case 23:
				if(vars.HoLCourtyardsExit()) 		
					return true;
				break;
			//The Prison
			case 24:
				if(vars.TheAzadPrison()) 		
					return true;
				break;
			//Life Upgrade 8
			case 25:	
				if(vars.SoTLU())
					return true;
				break;
			//Life Upgrade 9
			case 26:	
				if(vars.SoTLU())
					return true;
				break;
			//The Dream
			case 27:
				if(vars.TheDream) 		
					return true;
				break;
			//The Tomb
			case 28:
				if(vars.TheTomb()) 		
					return true;
				break;
			//Life Upgrade 10
			case 29:	
				if(vars.SoTLU())
					return true;
				break;
			//The Tower of Dawn
			case 30:
				if(vars.TowerofDawn()) 		
					return true;
				break;
			//The Setting Sun
			case 31:
				if(vars.SettingSun()) 		
					return true;
				break;
			//Honor and Glory
			case 32:
				if(vars.HonorGlory()) 							
					return true;
				break;
			//The Grand Rewind
			case 33:
				if(vars.GrandRewind()) 			
					return true;
				break;
			//The End
			case 34:
				if(vars.SoTEnd())			
					return true;
				break;
			}
		//Setup 1
			if (timer.CurrentSplitIndex == 35)			//~edit: the number here must be equal to the number of splits in the first game.
			{
				if(old.startValue2 == 1 && current.startValue2 == 2)
				{
					if(current.xPos2 >= -997.6757 && current.xPos2 <= -997.6755)
					return true;
				}
			}
		//WW
			switch (timer.CurrentSplitIndex - 36)		//~edit: the number we subtract here is [# of splits in first game] + 1
			{
			//The Boat
			case 0:
				if(vars.TheBoat())
					return true;
				break;
			//The Raven Man
			case 1:
				if(vars.TheRavenMan())
					return true;
				break;
			//Life Upgrade 1
			case 2:
				if(vars.WWLU9())
					return true;
				break;
			//Life Upgrade 2
			case 3:
				if(vars.WWLU6())
					return true;
				break;
			//Life Upgrade 3
			case 4:
				if(vars.WWLU5())
					return true;
				break;
			//Life Upgrade 4
			case 5:
				if(vars.WWLU1())
					return true;
				break;
			//Mask of the Wraith (59)
			case 6:
				if(vars.RNGStorygate())
					return true;
				break;
			//Life Upgrade 5
			case 7:
				if(vars.WWLU2())
					return true;
				break;			
			//Life Upgrade 6
			case 8:
				if(vars.WWLU3())
					return true;
				break;
			//The Mechanical Tower
			case 9:
				if(vars.TheMechTowTENMG())
					return true;
				break;					
			//Life Upgrade 7
			case 10:
				if(vars.WWLU4())
					return true;
				break;
			//Life Upgrade 8
			case 11:
				if(vars.WWLU8())
					return true;
				break;
			//Life Upgrade 9
			case 12:
				if(vars.WWLU7())
					return true;
				break;
			//The Water Sword
			case 13:
				if(vars.WaterSword())
					return true;
				break;
			//The End
			case 14:
				if(vars.WWEnd())
					return true;
				break;
			}
		//Setup 2
			if (timer.CurrentSplitIndex == 51)			//~edit: here the number is [# of splits in first game] + [# of splits in second game] + 1
			{
				if(current.xPos3 >= -409.9 && current.xPos3 <= -404.8 && current.yCam <= 0.1082 && current.yCam >= 0.1080 && current.xCam <= 0.832 && current.xCam >= 0.8318)
					return true;
			}
		//T2T
			switch (timer.CurrentSplitIndex - 52)		//~edit: the number we subract here is [# of splits in first game] + [# of splits in second game] + 2
			{
			//The Ramparts
			case 0:
				if(vars.TheRamparts())
					return true;
				break;
			//The Harbour District
			case 1:	
				if(vars.HarbourDistrict())
					return true;	
				break;
			//The Palace
			case 2:	
				if(vars.ThePalace())
					return true;	
				break;
			//The Trapped Hallway
			case 3:
				if(vars.TrappedHallway())
					return true;
				break;
			//Life Upgrade 1
			case 4:	
				if(vars.T2TLU1())
					return true;	
				break;
			//The Fortress
			case 5:
				if(vars.TheFortress())
					return true;
				break;
			//The Lower City
			case 6:
				if(vars.LowerCity())
					return true;
				break;
			//Life Upgrade 2
			case 7:	
				if(vars.T2TLU2())
					return true;	
				break;	
			//The Arena
			case 8:
				if(vars.LowerCityRooftops())
					return true;
				break;
			//The Balconies
			case 9:
				if(vars.TheBalconies())
					return true;
				break;
			//The Dark Alley
			case 10:
				if(vars.DarkAlley())
					return true;
				break;
			//The Temple Rooftops
			case 11:
				if(vars.TheTempleRooftops())
					return true;
				break;
			//Life Upgrade 3
			case 12:	
				if(vars.T2TLU3())
					return true;	
				break;
			//The Marketplace
			case 13:
				if(vars.TheMarketplace())
					return true;
				break;
			//The Market District
			case 14:
				if(vars.MarketDistrict())
					return true;
				break;
			//Exit Plaza
			case 15:
				if(vars.ThePlaza())
					return true;
				break;
			//The Upper City
			case 16:
				if(vars.TheUpperCity())
					return true;
				break;
			//Life Upgrade 4
			case 17:	
				if(vars.T2TLU4())
					return true;	
				break;
			//The Promenade
			case 18:
				if(vars.ThePromenade())
					return true;
				break;
			//The Royal Workshop
			case 19:
				if(vars.RoyalWorkshop())
					return true;
				break;
			//The King's Road
			case 20:
				if(vars.KingsRoad())
					return true;
				break;
			//Life Upgrade 5
			case 21:	
				if(vars.T2TLU5())
					return true;	
				break;
			//The Hanging Gardens
			case 22:
				if(vars.HangingGardens())
					return true;
				break;
			//The Structures Mind
			case 23:
				if(vars.WellofZipless())
					return true;
				break;
			//The Well of Ancestors
			case 24:
				if(vars.WellofAncestors())
					return true;
				break;
			//The Labyrinth
			case 25:
				if(vars.TheLabyrinth())
					return true;
				break;
			//The Underground Cave
			case 26:
				if(vars.UndergroundCaveZipnt())
					return true;
				break;
			//The Lower Tower
			case 27:
				if(vars.LowerTower())
					return true;
				break;
			//Life Upgrade 6
			case 28:	
				if(vars.T2TLU6())
					return true;	
				break;
			//The Upper Tower
			case 29:
				if(vars.UpperTower())
					return true;
				break;
			//The Terrace
			case 30:
				if(vars.TheTerrace())
					return true;
				break;
			//The Mental Realm
			case 31:	
				if(vars.MentalRealm())
					return true;	
				break;
			}
		break;
			
		case "Sands Trilogy (Completionist, No Major Glitches)":
		//SoT
			switch (timer.CurrentSplitIndex)
			{ 		
			//The Treasure Vaults
			case 0:
				if(vars.GasStation())
					return true;
				break;
			//The Sands of Time
			case 1:
				if(vars.SandsUnleashed())
					return true;
				break;
			//First Guest Room
			case 2: 
				if(vars.FirstGuestRoom())
					return true;
				break;
			//Life Upgrade 1
			case 3:	
				if(vars.SoTLU())
					return true;
				break;
			//Exit Palace Defense
			case 4: 
				if(vars.PalaceDefence()) 		
					return true;
				break;
			//Life Upgrade 2
			case 5:	
				if(vars.SoTLU())
					return true;
				break;
			//Death of the Sand King
			case 6:
				if(vars.DadDead()) 		
					return true;
				break;
			//Life Upgrade 3
			case 7:	
				if(vars.SoTLU())
					return true;
				break;
			//The Zoo
			case 8:	
				if(vars.TheZoo()) 		
					return true;
				break;
			//Atop a Bird Cage
			case 9:
				if(vars.BirdCage()) 		
					return true;
				break;
			//Cliffs and Waterfall
			case 10:
				if(vars.CliffWaterfalls()) 		
					return true;
				break;
			//The Baths
			case 11:
				if(vars.TheBathsZipless()) 		
					return true;
				break;
			//Life Upgrade 4
			case 12:	
				if(vars.SoTLU())
					return true;
				break;
			//Daybreak
			case 13:	
				if(vars.TheDaybreak()) 		
					return true;
				break;
			//Drawbridge Tower
			case 14:
				if(vars.DrawbridgeTower()) 		
					return true;
				break;
			//A Broken Bridge
			case 15:
				if(vars.BrokenBridge()) 		
					return true;
				break;
			//Life Upgrade 5
			case 16:	
				if(vars.SoTLU())
					return true;
				break;
			//Waterfall
			case 17:
				if(vars.TheWaterfall())		
					return true;
				break;
			//An Underground Reservoir
			case 18:
				if(vars.TheUGReservoirZipless()) 		
					return true;
				break;
			//Life Upgrade 6
			case 19:	
				if(vars.SoTLU())
					return true;
				break;
			//Hall of Learning
			case 20:
				if(vars.HallofLearning()) 		
					return true;
				break;
			//Life Upgrade 7
			case 21:	
				if(vars.SoTLU())
					return true;
				break;
			//Exit Observatory
			case 22:
				if(vars.ObservatoryExit()) 		
					return true;
				break;
			//Exit Hall of Learning Courtyards
			case 23:
				if(vars.HoLCourtyardsExit()) 		
					return true;
				break;
			//The Prison
			case 24:
				if(vars.TheAzadPrison()) 		
					return true;
				break;
			//Life Upgrade 8
			case 25:	
				if(vars.SoTLU())
					return true;
				break;
			//Life Upgrade 9
			case 26:	
				if(vars.SoTLU())
					return true;
				break;
			//The Dream
			case 27:
				if(vars.TheDream) 		
					return true;
				break;
			//The Tomb
			case 28:
				if(vars.TheTomb()) 		
					return true;
				break;
			//Life Upgrade 10
			case 29:	
				if(vars.SoTLU())
					return true;
				break;
			//The Tower of Dawn
			case 30:
				if(vars.TowerofDawn()) 		
					return true;
				break;
			//The Setting Sun
			case 31:
				if(vars.SettingSun()) 		
					return true;
				break;
			//Honor and Glory
			case 32:
				if(vars.HonorGlory()) 							
					return true;
				break;
			//The Grand Rewind
			case 33:
				if(vars.GrandRewind()) 			
					return true;
				break;
			//The End
			case 34:
				if(vars.SoTEnd())			
					return true;
				break;
			}
		//Setup 1
			if (timer.CurrentSplitIndex == 35)			//~edit: the number here must be equal to the number of splits in the first game.
			{
				if(old.startValue2 == 1 && current.startValue2 == 2)
				{
					if(current.xPos2 >= -997.6757 && current.xPos2 <= -997.6755)
					return true;
				}
			}
		//WW
			switch (timer.CurrentSplitIndex - 36)		//~edit: the number we subtract here is [# of splits in first game] + 1
			{
			//The Boat
			case 0:
				if(vars.TheBoat())
					return true;
				break;
			//The Spider Sword
			case 1:
				if(vars.SpiderSword())
					return true;
				break;
			//Life Upgrade 1
			case 2:
				if(vars.WWLU8())
					return true;
				break;
			//A Damsel in Distress
			case 3:
				if(vars.DamselDistress())
					return true;
				break;
			//Life Upgrade 2
			case 4:
				if(vars.vars.WWLU7())
					return true;
				break;
			//The Dahaka
			case 5:
				if(vars.TheDahaka())
					return true;
				break;
			//Life Upgrade 3
			case 6:
				if(vars.WWLU1())
					return true;
				break;
			//The Serpent Sword
			case 7:
				if(vars.SerpentSword())
					return true;
				break;
			//The Garden Hall
			case 8:
				if(vars.GardenHall())
					return true;
				break;
			//Life Upgrade 4
			case 9:
				if(vars.WWLU6())
					return true;
				break;
			//Life Upgrade 5
			case 10:
				if(vars.WWLU5())
					return true;
				break;
			//Life Upgrade 6
			case 11:
				if(vars.WWLU9())
					return true;
				break;
			//The Mechanical Tower
			case 12:
				if(vars.TheMechTower())
					return true;
				break;
			//Breath of Fate
			case 13:
				if(vars.RavagesPortal())
					return true;
				break;
			//Activation Room in Ruin
			case 14:
				if(vars.ActivationRuins())
					return true;
				break;
			//Life Upgrade 7
			case 15:
				if(vars.WWLU4())
					return true;
				break;
			//The Death of a Sand Wraith
			case 16:
				if(vars.SandWraithDead())
					return true;
				break;
			//Death of the Empress
			case 17:
				if(vars.KaileenaDead())
					return true;
				break;
			//Exit the Tomb
			case 18:
				if(vars.CatacombsExit())
					return true;
				break;
			//The Scorpion Sword
			case 19:
				if(vars.ScorpionSword())
					return true;
				break;
			//Life Upgrade 8
			case 20:
				if(vars.WWLU2())
					return true;
				break;
			//Life Upgrade 9
			case 21:
				if(vars.WWLU3())
					return true;
				break;
			//The Water Sword
			case 22:
				if(vars.WaterSword())
					return true;
				break;
			//The Mask of the Wraith
			case 23:
				if(vars.MaskofWraith())
					return true;
				break;
			//The Sand Griffin
			case 24:
				if(vars.SandGriffin())
					return true;
				break;
			//Mirrored Fates
			case 25:
				if(vars.MirroredFates())
					return true;
				break;
			//A Favor Unknown
			case 26:
				if(vars.FavourUnknown())
					return true;
				break;
			//The Library Revisited
			case 27:
				if(vars.TheLibrary())
					return true;
				break;
			//The Light Sword
			case 28:
				if(vars.LightSword())
					return true;
				break;
			//The Death of a Prince
			case 29:
				if(vars.DeathofaPrince())
					return true;
				break;
			//The End
			case 30:
				if(vars.WWEnd())
					return true;
				break;
			}
		//Setup 2
			if (timer.CurrentSplitIndex == 67)			//~edit: here the number is [# of splits in first game] + [# of splits in second game] + 1
			{
				if(current.xPos3 >= -409.9 && current.xPos3 <= -404.8 && current.yCam <= 0.1082 && current.yCam >= 0.1080 && current.xCam <= 0.832 && current.xCam >= 0.8318)
					return true;
			}
		//T2T
			switch (timer.CurrentSplitIndex - 68)		//~edit: the number we subract here is [# of splits in first game] + [# of splits in second game] + 2
			{
			//The Ramparts
			case 0:
				if(vars.TheRamparts())
					return true;
				break;
			//The Harbour District
			case 1:	
				if(vars.HarbourDistrict())
					return true;	
				break;
			//The Palace
			case 2:	
				if(vars.ThePalace())
					return true;	
				break;
			//The Trapped Hallway
			case 3:
				if(vars.TrappedHallway())
					return true;
				break;
			//Life Upgrade 1
			case 4:	
				if(vars.T2TLU1())
					return true;	
				break;
			//The Fortress
			case 5:
				if(vars.TheFortress())
					return true;
				break;
			//The Lower City
			case 6:
				if(vars.LowerCity())
					return true;
				break;
			//Life Upgrade 2
			case 7:	
				if(vars.T2TLU2())
					return true;	
				break;	
			//The Arena
			case 8:
				if(vars.LowerCityRooftops())
					return true;
				break;
			//The Balconies
			case 9:
				if(vars.TheBalconies())
					return true;
				break;
			//The Dark Alley
			case 10:
				if(vars.DarkAlley())
					return true;
				break;
			//The Temple Rooftops
			case 11:
				if(vars.TheTempleRooftops())
					return true;
				break;
			//Life Upgrade 3
			case 12:	
				if(vars.T2TLU3())
					return true;	
				break;
			//The Marketplace
			case 13:
				if(vars.TheMarketplace())
					return true;
				break;
			//The Market District
			case 14:
				if(vars.MarketDistrict())
					return true;
				break;
			//The Brothel
			case 15:
				if(vars.TheBrothel())
					return true;
				break;
			//The Plaza
			case 16:
				if(vars.ThePlaza())
					return true;
				break;
			//The Upper City
			case 17:
				if(vars.TheUpperCity())
					return true;
				break;
			//Life Upgrade 4
			case 18:	
				if(vars.T2TLU4())
					return true;	
				break;
			//The Promenade
			case 19:
				if(vars.ThePromenade())
					return true;
				break;
			//The Royal Workshop
			case 20:
				if(vars.RoyalWorkshop())
					return true;
				break;
			//The King's Road
			case 21:
				if(vars.KingsRoad())
					return true;
				break;
			//Life Upgrade 5
			case 22:	
				if(vars.T2TLU5())
					return true;	
				break;
			//The Hanging Gardens
			case 23:
				if(vars.HangingGardens())
					return true;
				break;
			//The Structure's Mind
			case 24:
				if(vars.StructuresMind())
					return true;
				break;
			//The Well of Ancestors
			case 25:
				if(vars.WellofAncestors())
					return true;
				break;
			//The Labyrinth
			case 26:
				if(vars.TheLabyrinth())
					return true;
				break;
			//The Underground Cave
			case 27:
				if(vars.UndergroundCave())
					return true;
				break;
			//The Lower Tower
			case 28:
				if(vars.LowerTower())
					return true;
				break;
			//Life Upgrade 6
			case 29:	
				if(vars.T2TLU6())
					return true;	
				break;
			//The Upper Tower
			case 30:
				if(vars.UpperTower())
					return true;
				break;
			//The Terrace
			case 31:	
				if(vars.TheTerrace())
					return true;
				break;
			//The Mental Realm
			case 32:	
				if(vars.MentalRealm())
					return true;	
				break;
			}
		break;
		
		case "Anthology":
		//PoP1
			return 
			(old.Level !=  current.Level) || // if level changes
			(current.Level == 0xE && current.EndGame == 0xFF);	// if currently on level 14 and EndGame changes to 255
		//Setup 1
			if (timer.CurrentSplitIndex == 14)
			{
				if(current.Start == 238 && current.Level2 == 1)
				{
					vars.ResetDelta = current.FrameCount;
					return true;
				}
			}
			vars.ResetDelta = 0;
			vars.Resetting = false;
		//PoP2
			if(current.Start == 231){
				vars.Resetting = false;
			}
			return (old.Level2 == current.Level2 - 1);
		//Setup 2
			if (timer.CurrentSplitIndex == 29)
			{
				if(current.lXPos > 20.554 && current.lXPos < 20.556 && current.lZPos > 1.448 && current.lZPos < 1.45)
				{
					return true;
				}
			}
		//PoP3D
			switch (timer.CurrentSplitIndex - 30)
			{
			//Dungeon
			case 0:
				if (old.lYPos == 0 && current.lYPos == -2)
					return true;
					break;
			//Ivory Tower
			case 1:
				if (old.lXPos == 0 && current.lXPos > 13.485 && current.lXPos < 13.487)
					return true;
					break;
			//Cistern
			case 2:
				if (old.lXPos == 0 && current.lXPos > 216.904 && current.lXPos < 216.906)
					return true;
				break;
			//Palace 1
			case 3:
				if (old.lXPos == 0 && current.lXPos == -7)
					return true;
				break;
			//Palace 2
			case 4:
				if (old.lYPos == 0 && current.lYPos == -23)
					return true;
				break;
			//Palace 3
			case 5:
				if (current.lXPos == 0 && current.lYPos == 0 && current.lZPos == 0 && old.health == 0 && current.health != 0)
					return true;
				break;
			//Rooftops	
			case 6:
				if (old.lXPos == 0 && current.lXPos == -42)
					return true;
				break;
			//Streets and Docks
			case 7:
				if (old.lYPos == 0 && current.lYPos == -20)
					return true;
				break;
			//Lower Dirigible 1
			case 8:
				if (old.lYPos == 0 && current.lYPos == 99)
					return true;
				break;
			//Lower Dirigible 2
			case 9:
				if (old.lZPos == 0 && current.lZPos > -77.77 && current.lZPos < -77.75)
					return true;
				break;
			//Upper Dirigible
			case 10:
				if (old.lYPos == 0 && current.lYPos == 103)
					return true;
				break;
			//Dirigible Finale
			case 11:
				if (old.lYPos == 0 && current.lYPos == 61)
					return true;
				break;
			//Floating Ruins
			case 12:
				if (old.lYPos == 0 && current.lYPos == -85)
					return true;
				break;
			//Cliffs
			case 13:
				if (old.lYPos == 0 && current.lYPos > -2.36 && current.lYPos < -2.34)
					return true;
				break;
			//Sun Temple
			case 14:
				if (old.lYPos == 0 && current.lYPos > -19.966 && current.lYPos < -19.964)
					return true;
				break;
			//Moon Temple
			case 15:
				if (old.lYPos == 0 && current.lYPos > -27.4 && current.lYPos < -27.38)
					return true;
				break;
			//Finale
			case 16:
				if(current.xPos == 0 && current.yPos == 0 && current.zPos == 0 && current.eHealth ==0)
					return true;
				break;
			}
		//Setup 3
			if (timer.CurrentSplitIndex == 47)
			{
				if(current.xPos1 >= -103.264 && current.yPos1 >= -4.8 && current.zPos1 >= 1.341 && current.xPos1 <= -103.262 && current.yPos1 <= -4.798 && current.zPos1 <= 1.343 && current.startValue == 1)
					return true;
			}
		//SoT
			switch (timer.CurrentSplitIndex - 48)
			{
			//The Treasure Vaults
			case 0:
				if(vars.GasStation())
					return true;
				break;
			//The Sands of Time
			case 1:
				if(vars.SandsUnleashed())
					return true;
				break;
			//The Sultan's Chamber (Death)
			case 2:
				if(vars.SultanChamber())
					return true;
				break;
			//Death of the Sand King
			case 3:
				if(vars.DadDead())
							return true;
				break;
			//The Baths (Death)
			case 4:
				if(vars.TheBaths())
					return true;
				break;
			//The Messhall (Death)
			case 5:
				if(vars.TheMesshall())
					return true;
				break;
			//The Caves
			case 6:
				if(vars.TheCaves())
					return true;
				break;
			//Exit Underground Reservoir
			case 7:
				if(vars.TheUGReservoir())
					return true;
				break;
			//The Observatory (Death)
			case 8:
				if(vars.TheObservatory())
					return true;
				break;
			//The Torture Chamber (Death)
			case 9:
				if(vars.TortureChamber())
					return true;
				break;
			//The Dream
			case 10:
				if(vars.TheDream())
					return true;
				break;
			//Honor and Glory
			case 11:
				if(vars.HonorGlory())
					return true;
				break;
			//The Grand Rewind
			case 12:
				if(vars.GrandRewind())
					return true;
				break;
			//The End
			case 13:
				if(vars.SoTEnd())				
					return true;
				break;
			}
		//Setup 4
			if (timer.CurrentSplitIndex == 62)			
			{
				if(old.startValue2 == 1 && current.startValue2 == 2)
				{
					if(current.xPos2 >= -997.6757 && current.xPos2 <= -997.6755)
					return true;
				}
			}
		//WW
			switch (timer.CurrentSplitIndex - 63)											//63? Ironic!
			{
			//The Boat
			case 0:
				if(vars.TheBoat())
					return true;
				break;
			//The Raven Man
			case 1:
				if(vars.TheRavenMan())
					return true;
				break;
			//The Time Portal
			case 2:
				if(vars.TimePortal())			
					return true;
				break;
			//Mask of the Wraith (59)
			case 3:
				if(vars.RNGStorygate())
					return true;
				break;
			//The Scorpion Sword
			case 4:
				if(vars.ScorpionSword())
					return true;
				break;
			//Storygate 63
			case 5:
				if(vars.WWEndgame())
					return true;
				break;
			//Back to the Future
			case 6:
				if(vars.SlomoPortal())
					return true;
				break;
			//The End
			case 7:
				if(vars.WWEnd())
					return true;
				break;
			}
		//Setup 5
			if (timer.CurrentSplitIndex == 71)													
			{
				if(current.xPos3 >= -409.9 && current.xPos3 <= -404.8 && current.yCam <= 0.1082 && current.yCam >= 0.1080 && current.xCam <= 0.832 && current.xCam >= 0.8318)
					return true;
			}
		//T2T
			switch (timer.CurrentSplitIndex - 72)												
			{
			//The Ramparts
			case 0:
				if(vars.TheRamparts())
					return true;
				break;
			//The Harbor District
			case 1:	
				if(vars.HarbourDistrict())
					return true;	
				break;
			//The Palace
			case 2:	
				if(vars.ThePalace())
					return true;	
				break;
			//Exit Sewers
			case 3:	
				if(vars.TheSewerz())
					return true;	
				break;
			//Exit Lower City
			case 4:	
				if(vars.LowerCity())
					return true;	
				break;
			//The Lower City Rooftops
			case 5:	
				if(vars.LCRooftopZips())
					return true;	
				break;
			//Exit Temple Rooftops
			case 6:	
				if(vars.TheTempleRooftops())
					return true;	
				break;
			//Exit Marketplace
			case 7:	
				if(vars.TheMarketplace())
					return true;	
				break;
			//Exit Plaza
			case 8:	
				if(vars.ThePlaza())
					return true;	
				break;
			//Exit City Gardens
			case 9:	
				if(vars.CityGarderns())
					return true;	
				break;
			//Exit Royal Workshop
			case 10:	
				if(vars.RoyalWorkshop())
					return true;	
				break;
			//The King's Road
			case 11:	
				if(vars.KingzRoad())
					return true;	
				break;
			//Exit Structure's Mind
			case 12:	
				if(vars.StructurezMind())
					return true;	
				break;
			//Exit Labyrinth
			case 13:	
				if(vars.TheLabyrinth())
					return true;	
				break;
			//The Towers
			case 14:	
				if(vars.UpperTower())
					return true;	
				break;
			//The Terrace
			case 15:	
				if(vars.TheTerrace())
					return true;
				break;
			//The Mental Realm
			case 16:	
				if(vars.MentalRealm())
					return true;	
				break;
			}
		//Setup 6
			if (timer.CurrentSplitIndex == 89)
			{
				if(old.yPos2k8 != -351 && current.yPos2k8 == -351)
				{
					return true;
				}
				//Initializing flags & targets:
				vars.kill = false;
				vars.seedGet = false;
				vars.startUp2k8 = true;
				vars.xTarget = 0;
				vars.yTarget = 0;
				vars.zTarget = 0;
			}
		//2k8
			if(!vars.startUp2k8)
			{
				vars.kill = false;
				vars.seedGet = false;
				vars.startUp2k8 = true;
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
			switch (timer.CurrentSplitIndex - 90)
			{
			//First Fight Skip			
			case 0: 
				if (current.zPos2k8 >= -31 && current.zPos2k8 <= -28 && current.yPos2k8 >= -331)
					return true;
				break;
			//The Canyon
			case 1: 
				if (current.xPos2k8 <= -200 && current.xPos2k8 >= -208 && current.yPos2k8 <= -27.5 && current.yPos2k8 >= -38 && current.zPos2k8 >= -511)
					return true;
				break;
			//King's Gate
			case 2:
				vars.xTarget = -538.834;
				vars.yTarget = -67.159;
				vars.zTarget = 12.732;
				if(current.xPos2k8 <= (vars.xTarget+2) && current.xPos2k8 >= (vars.xTarget-2) && current.yPos2k8 <= (vars.yTarget+2) && current.yPos2k8 >= (vars.yTarget-2) && current.zPos2k8 <= (vars.zTarget+2) && current.zPos2k8 >= (vars.zTarget-2) && vars.seedGet)
					return true;
				break;
			//Sun Temple
			case 3:
				vars.xTarget = -670.471;
				vars.yTarget = -56.147;
				vars.zTarget = 16.46;
				if(current.xPos2k8 <= (vars.xTarget+2) && current.xPos2k8 >= (vars.xTarget-2) && current.yPos2k8 <= (vars.yTarget+2) && current.yPos2k8 >= (vars.yTarget-2) && current.zPos2k8 <= (vars.zTarget+2) && current.zPos2k8 >= (vars.zTarget-2) && vars.seedGet)
					return true;
				break;
			//Marshalling Grounds
			case 4:
				vars.xTarget = -806.671;
				vars.yTarget = 112.803;
				vars.zTarget = 21.645;
				if(current.xPos2k8 <= (vars.xTarget+2) && current.xPos2k8 >= (vars.xTarget-2) && current.yPos2k8 <= (vars.yTarget+2) && current.yPos2k8 >= (vars.yTarget-2) && current.zPos2k8 <= (vars.zTarget+2) && current.zPos2k8 >= (vars.zTarget-2) && vars.seedGet)
					return true;
				break;
			//Windmills
			case 5:
				vars.xTarget = -597.945;
				vars.yTarget = 209.241;
				vars.zTarget = 23.339;
				if(current.xPos2k8 <= (vars.xTarget+2) && current.xPos2k8 >= (vars.xTarget-2) && current.yPos2k8 <= (vars.yTarget+2) && current.yPos2k8 >= (vars.yTarget-2) && current.zPos2k8 <= (vars.zTarget+2) && current.zPos2k8 >= (vars.zTarget-2) && vars.seedGet)
					return true;
				break;
			//Martyrs' Tower
			case 6:
				vars.xTarget = -564.202;
				vars.yTarget = 207.312;
				vars.zTarget = 22;
				if(current.xPos2k8 <= (vars.xTarget+2) && current.xPos2k8 >= (vars.xTarget-2) && current.yPos2k8 <= (vars.yTarget+2) && current.yPos2k8 >= (vars.yTarget-2) && current.zPos2k8 <= (vars.zTarget+2) && current.zPos2k8 >= (vars.zTarget-2) && vars.seedGet)
					return true;
				break;					
			//MT -> MG
			case 7:
				vars.xTarget = -454.824;
				vars.yTarget = 398.571;
				vars.zTarget = 27.028;
				if(current.xPos2k8 <= (vars.xTarget+2) && current.xPos2k8 >= (vars.xTarget-2) && current.yPos2k8 <= (vars.yTarget+2) && current.yPos2k8 >= (vars.yTarget-2) && current.zPos2k8 <= (vars.zTarget+2) && current.zPos2k8 >= (vars.zTarget-2) && vars.seedGet)
					return true;
				break;
			//Machinery Ground
			case 8:
				vars.xTarget = -361.121;
				vars.yTarget = 480.114;
				vars.zTarget = 12.928;
				if(current.xPos2k8 <= (vars.xTarget+2) && current.xPos2k8 >= (vars.xTarget-2) && current.yPos2k8 <= (vars.yTarget+2) && current.yPos2k8 >= (vars.yTarget-2) && current.zPos2k8 <= (vars.zTarget+2) && current.zPos2k8 >= (vars.zTarget-2) && vars.seedGet)
					return true;
				break;
			//Heaven's Stair
			case 9:
				vars.xTarget = -85.968;
				vars.yTarget = 573.338;
				vars.zTarget = 30.558;
				if(current.xPos2k8 <= (vars.xTarget+2) && current.xPos2k8 >= (vars.xTarget-2) && current.yPos2k8 <= (vars.yTarget+2) && current.yPos2k8 >= (vars.yTarget-2) && current.zPos2k8 <= (vars.zTarget+2) && current.zPos2k8 >= (vars.zTarget-2) && vars.seedGet)
					return true;
				break;
			//Spire of Dreams
			case 10:
				vars.xTarget = -28.088;
				vars.yTarget = 544.298;
				vars.zTarget = 34.942;
				if(current.xPos2k8 <= (vars.xTarget+3) && current.xPos2k8 >= (vars.xTarget-3) && current.yPos2k8 <= (vars.yTarget+3) && current.yPos2k8 >= (vars.yTarget-3) && current.zPos2k8 <= (vars.zTarget+3) && current.zPos2k8 >= (vars.zTarget-3) && vars.seedGet)
					return true;
				break;
			//Reservoir
			case 11:
				vars.xTarget = -150.082;
				vars.yTarget = 406.606;
				vars.zTarget = 34.673;
				if(current.xPos2k8 <= (vars.xTarget+2) && current.xPos2k8 >= (vars.xTarget-2) && current.yPos2k8 <= (vars.yTarget+2) && current.yPos2k8 >= (vars.yTarget-2) && current.zPos2k8 <= (vars.zTarget+2) && current.zPos2k8 >= (vars.zTarget-2) && vars.seedGet)
					return true;
				break;
			//Construction Yard
			case 12:
				vars.xTarget = -151.121;
				vars.yTarget = 303.514;
				vars.zTarget = 27.95;
				if(current.xPos2k8 <= (vars.xTarget+2) && current.xPos2k8 >= (vars.xTarget-2) && current.yPos2k8 <= (vars.yTarget+2) && current.yPos2k8 >= (vars.yTarget-2) && current.zPos2k8 <= (vars.zTarget+2) && current.zPos2k8 >= (vars.zTarget-2) && vars.seedGet)
					return true;
				break;
			//Cauldron
			case 13: 
				vars.xTarget = 107.123;
				vars.yTarget = 183.394;
				vars.zTarget = -5.628;
				if(current.xPos2k8 <= (vars.xTarget+2) && current.xPos2k8 >= (vars.xTarget-2) && current.yPos2k8 <= (vars.yTarget+2) && current.yPos2k8 >= (vars.yTarget-2) && current.zPos2k8 <= (vars.zTarget+2) && current.zPos2k8 >= (vars.zTarget-2) && vars.seedGet)
					return true;
				break;
			//Cavern
			case 14:
				vars.xTarget = 251.741;
				vars.yTarget = 65.773;
				vars.zTarget = -13.616;
				if(current.xPos2k8 <= (vars.xTarget+2) && current.xPos2k8 >= (vars.xTarget-2) && current.yPos2k8 <= (vars.yTarget+2) && current.yPos2k8 >= (vars.yTarget-2) && current.zPos2k8 <= (vars.zTarget+2) && current.zPos2k8 >= (vars.zTarget-2) && vars.seedGet)
					return true;
				break;
			//City Gate
			case 15:
				vars.xTarget = 547.488;
				vars.yTarget = 45.41;
				vars.zTarget = -27.107;
				if(current.xPos2k8 <= (vars.xTarget+2) && current.xPos2k8 >= (vars.xTarget-2) && current.yPos2k8 <= (vars.yTarget+2) && current.yPos2k8 >= (vars.yTarget-2) && current.zPos2k8 <= (vars.zTarget+2) && current.zPos2k8 >= (vars.zTarget-2) && vars.seedGet)
					return true;
				break;
			//Tower of Ormazd
			case 16:
				vars.xTarget = 609.907;
				vars.yTarget = 61.905;
				vars.zTarget = -35.001;
				if(current.xPos2k8 <= (vars.xTarget+2) && current.xPos2k8 >= (vars.xTarget-2) && current.yPos2k8 <= (vars.yTarget+2) && current.yPos2k8 >= (vars.yTarget-2) && current.zPos2k8 <= (vars.zTarget+2) && current.zPos2k8 >= (vars.zTarget-2) && vars.seedGet)
					return true;
				break;
			//Queen's Tower
			case 17:
				vars.xTarget = 637.262;
				vars.yTarget = 27.224;
				vars.zTarget = -28.603;
				if(current.xPos2k8 <= (vars.xTarget+2) && current.xPos2k8 >= (vars.xTarget-2) && current.yPos2k8 <= (vars.yTarget+2) && current.yPos2k8 >= (vars.yTarget-2) && current.zPos2k8 <= (vars.zTarget+2) && current.zPos2k8 >= (vars.zTarget-2) && vars.seedGet)
					return true;
				break;
			//The Temple (Arrive)
			case 18:
				if(current.yPos2k8 <= -234.5 && current.zPos2k8 >= -37 && current.xPos2k8 >= -0.5 && current.xPos2k8 <= 12)
					return true;
				break;
			//Double Jump
			case 19:
				if(current.xPos2k8 <= 6.19 && current.xPos2k8 >= 6.12 && current.yPos2k8 >= -233.49 && current.yPos2k8 <= -225.18 && current.zPos2k8 >= -33.01 && current.zPos2k8 <= -32.5)
					return true;
				break;
			//Wings of Ormazd
			case 20:
				if(current.xPos2k8 >= 6.6 && current.xPos2k8 <= 6.8 && current.yPos2k8 >= -171.8 && current.yPos2k8 <= -171.6 && current.zPos2k8 == -49)
					return true;
				break;
			//The Warrior
			case 21:
				vars.xTarget = 1070.478;
				vars.yTarget = 279.147;
				vars.zTarget = -29.571;
				if(current.xPos2k8 <= (vars.xTarget+23) && current.xPos2k8 >= (vars.xTarget-23) && current.yPos2k8 <= (vars.yTarget+23) && current.yPos2k8 >= (vars.yTarget-23) && current.zPos2k8 <= (vars.zTarget+2) && current.zPos2k8 >= (vars.zTarget-2) && vars.kill)
					return true;
				break;
			//Heal Coronation Hall
			case 22:
				if(current.xPos2k8 >= 328 && current.xPos2k8 <= 352 && current.yPos2k8 >= 570 && current.yPos2k8 <= 595 && current.zPos2k8 >= 32.4 && vars.kill)
					return true;
				break;
			//Coronation Hall
			case 23:
				vars.xTarget = 264.497;
				vars.yTarget = 589.336;
				vars.zTarget = 38.67;
				if(current.xPos2k8 <= (vars.xTarget+2) && current.xPos2k8 >= (vars.xTarget-2) && current.yPos2k8 <= (vars.yTarget+2) && current.yPos2k8 >= (vars.yTarget-2) && current.zPos2k8 <= (vars.zTarget+2) && current.zPos2k8 >= (vars.zTarget-2) && vars.seedGet)
					return true;
				break;
			//Heal Heaven's Stair
			case 24:
				if(current.xPos2k8 >= -322 && current.xPos2k8 <= -260 && current.yPos2k8 >= 628 && current.yPos2k8 <= 675 && current.zPos2k8 >= 99.2 && vars.kill)
					return true;
				break;
			//The Alchemist
			case 25:
				vars.xTarget = -296.593;
				vars.yTarget = 697.233;
				vars.zTarget = 296.199;
				if(current.xPos2k8 <= (vars.xTarget+10) && current.xPos2k8 >= (vars.xTarget-10) && current.yPos2k8 <= (vars.yTarget+10) && current.yPos2k8 >= (vars.yTarget-10) && current.zPos2k8 <= (vars.zTarget+2) && current.zPos2k8 >= (vars.zTarget-2) && vars.kill)
					return true;
				break;
			//The Hunter
			case 26:
				vars.xTarget = -929.415;
				vars.yTarget = 320.888;
				vars.zTarget = -89.038;
				if(current.xPos2k8 <= (vars.xTarget+10) && current.xPos2k8 >= (vars.xTarget-10) && current.yPos2k8 <= (vars.yTarget+10) && current.yPos2k8 >= (vars.yTarget-10) && current.zPos2k8 <= (vars.zTarget+2) && current.zPos2k8 >= (vars.zTarget-2) && vars.kill)
					return true;
				break;
			//Hand of Ormazd
			case 27:
				if(old.zPos2k8 <= 0 && current.zPos2k8 >= 32.4)
					return true;
				break;
			//The Concubine
			case 28:
				vars.xTarget = 352.792;
				vars.yTarget = 801.051;
				vars.zTarget = 150.260;
				if(current.xPos2k8 <= (vars.xTarget+26) && current.xPos2k8 >= (vars.xTarget-26) && current.yPos2k8 <= (vars.yTarget+26) && current.yPos2k8 >= (vars.yTarget-26) && current.zPos2k8 <= (vars.zTarget+2) && current.zPos2k8 >= (vars.zTarget-2) && vars.kill)
					return true;
				break;
			//The King
			case 29:
				if(current.xPos2k8 <= 20 && current.xPos2k8 >= -10 && current.yPos2k8 >= -375 && current.yPos2k8 <= -355 && current.zPos2k8 <= -32 && vars.kill)
					return true;
				break;
			//The God
			case 30:
				if(current.xPos2k8 <= 7.131 && current.xPos2k8 >= 7.129 && current.yPos2k8 >= -401.502 && current.yPos2k8 <= -401.5 && current.zPos2k8 >= -31.4)
					return true;
				break;
			//Resurrection
			case 31:
				if(current.xPos2k8 <= 5.566 && current.xPos2k8 >= 5.562 && current.yPos2k8 >= -222.745 && current.yPos2k8 <= -222.517 && current.zPos2k8 >= -33.1)
					return true;
				break;
			}
			//Unmarking flags at the end of each cycle.
				vars.kill = false;
				vars.seedGet = true;
		//Setup 7
			if (timer.CurrentSplitIndex == 122)
			{
				if(current.xPos <= 268.93 && current.xPos >= 268.929 && current.gameState == 4){
					return true;
				}
			}
		//TFS
			//Initializing flags & targets in the event the start function wasn't used.
			if(!vars.startUp)
			{
				vars.cpGet = false;
				vars.startUptfs = true;
				vars.xTarget2 = 0;
				vars.yTarget2 = 0;
				vars.zTarget2 = 0;
			}
			//Setting cpGet to true any time you acquire a checkpoint.
			if(current.cpIcon >= 1)
			{
				vars.cpGet = true;
			}
			//In the case of each split, looking for qualifications to complete the split.
			switch (timer.CurrentSplitIndex - 123)
			{
			case 0: //Malik
				vars.xTarget2 = -37;
				vars.yTarget2 = 231;
				vars.zTarget2 = -148;
				if(current.xPostfs <= (vars.xTarget2+10) && current.xPostfs >= (vars.xTarget2-10) && current.yPostfs <= (vars.yTarget2+10) && current.yPostfs >= (vars.yTarget2-10) && current.zPostfs <= (vars.zTarget2+10) && current.zPostfs >= (vars.zTarget2-10) && vars.cpGet)
					return true;
				break;
			//The Power of Time
			case 1:
				vars.xTarget2 = 597;
				vars.yTarget2 = -217;
				vars.zTarget2 = -2;
				if(current.xPostfs <= (vars.xTarget2+10) && current.xPostfs >= (vars.xTarget2-10) && current.yPostfs <= (vars.yTarget2+10) && current.yPostfs >= (vars.yTarget2-10) && current.zPostfs <= (vars.zTarget2+10) && current.zPostfs >= (vars.zTarget2-10) && vars.cpGet)
					return true;
					break;
			//The Works
			case 2:
				vars.xTarget2 = -513;
				vars.yTarget2 = -408;
				vars.zTarget2 = -167;
				if(current.xPostfs <= (vars.xTarget2+10) && current.xPostfs >= (vars.xTarget2-10) && current.yPostfs <= (vars.yTarget2+10) && current.yPostfs >= (vars.yTarget2-10) && current.zPostfs <= (vars.zTarget2+10) && current.zPostfs >= (vars.zTarget2-10) && vars.cpGet)
					return true;
				break;
			//The Courtyard
			case 3:
				vars.xTarget2 = -434;
				vars.yTarget2 = -533;
				vars.zTarget2 = -127;
				if(current.xPostfs <= (vars.xTarget2+10) && current.xPostfs >= (vars.xTarget2-10) && current.yPostfs <= (vars.yTarget2+10) && current.yPostfs >= (vars.yTarget2-10) && current.zPostfs <= (vars.zTarget2+10) && current.zPostfs >= (vars.zTarget2-10) && vars.cpGet)
					return true;
				break;
			//The Power of Water
			case 4:
				vars.xTarget2 = 519;
				vars.yTarget2 = -227;
				vars.zTarget2 = 6;
				if(current.xPostfs <= (vars.xTarget2+10) && current.xPostfs >= (vars.xTarget2-10) && current.yPostfs <= (vars.yTarget2+10) && current.yPostfs >= (vars.yTarget2-10) && current.zPostfs <= (vars.zTarget2+10) && current.zPostfs >= (vars.zTarget2-10) && vars.cpGet)
					return true;
				break;
			//The Sewers
			case 5:
				vars.xTarget2 = -228;
				vars.yTarget2 = 245;
				vars.zTarget2 = 20;
				if(current.xPostfs <= (vars.xTarget2+10) && current.xPostfs >= (vars.xTarget2-10) && current.yPostfs <= (vars.yTarget2+10) && current.yPostfs >= (vars.yTarget2-10) && current.zPostfs <= (vars.zTarget2+10) && current.zPostfs >= (vars.zTarget2-10) && vars.cpGet)
					return true;
				break;
			//Ratash
			case 6:
				vars.xTarget2 = -406;
				vars.yTarget2 = 403;
				vars.zTarget2 = 64;
				if(current.xPostfs <= (vars.xTarget2+10) && current.xPostfs >= (vars.xTarget2-10) && current.yPostfs <= (vars.yTarget2+10) && current.yPostfs >= (vars.yTarget2-10) && current.zPostfs <= (vars.zTarget2+10) && current.zPostfs >= (vars.zTarget2-10) && vars.cpGet)
					return true;
				break;
			//The Observatory
			case 7:
				vars.xTarget2 = -510;
				vars.yTarget2 = 460;
				vars.zTarget2 = 104;
				if(current.xPostfs <= (vars.xTarget2+10) && current.xPostfs >= (vars.xTarget2-10) && current.yPostfs <= (vars.yTarget2+10) && current.yPostfs >= (vars.yTarget2-10) && current.zPostfs <= (vars.zTarget2+10) && current.zPostfs >= (vars.zTarget2-10) && vars.cpGet)
					return true;
				break;
			//The Power of Light
			case 8:
				vars.xTarget2 = 540;
				vars.yTarget2 = -219;
				vars.zTarget2 = 6;
				if(current.xPostfs <= (vars.xTarget2+10) && current.xPostfs >= (vars.xTarget2-10) && current.yPostfs <= (vars.yTarget2+10) && current.yPostfs >= (vars.yTarget2-10) && current.zPostfs <= (vars.zTarget2+10) && current.zPostfs >= (vars.zTarget2-10) && vars.cpGet)
					return true;
				break;
			//The Gardens
			case 9:
				vars.xTarget2 = 240;
				vars.yTarget2 = -227;
				vars.zTarget2 = -114;
				if(current.xPostfs <= (vars.xTarget2+10) && current.xPostfs >= (vars.xTarget2-10) && current.yPostfs <= (vars.yTarget2+10) && current.yPostfs >= (vars.yTarget2-10) && current.zPostfs <= (vars.zTarget2+10) && current.zPostfs >= (vars.zTarget2-10) && vars.cpGet)
					return true;
				break;
			//Possession
			case 10:
				vars.xTarget2 = 89;
				vars.yTarget2 = -477;
				vars.zTarget2 = -83;
				if(current.xPostfs <= (vars.xTarget2+1) && current.xPostfs >= (vars.xTarget2-1) && current.yPostfs <= (vars.yTarget2+1) && current.yPostfs >= (vars.yTarget2-1) && current.zPostfs <= (vars.zTarget2+1) && current.zPostfs >= (vars.zTarget2-1) && vars.cpGet)
					return true;
				break;
			//The Power of Knowledge
			case 11:
				vars.xTarget2 = 548;
				vars.yTarget2 = -217;
				vars.zTarget2 = 4;
				if(current.xPostfs <= (vars.xTarget2+10) && current.xPostfs >= (vars.xTarget2-10) && current.yPostfs <= (vars.yTarget2+10) && current.yPostfs >= (vars.yTarget2-10) && current.zPostfs <= (vars.zTarget2+10) && current.zPostfs >= (vars.zTarget2-10) && vars.cpGet)
					return true;
				break;
			//The Reservoir
			case 12:
				vars.xTarget2 = 644;
				vars.yTarget2 = 385;
				vars.zTarget2 = -63;
				if(current.xPostfs <= (vars.xTarget2+10) && current.xPostfs >= (vars.xTarget2-10) && current.yPostfs <= (vars.yTarget2+10) && current.yPostfs >= (vars.yTarget2-10) && current.zPostfs <= (vars.zTarget2+10) && current.zPostfs >= (vars.zTarget2-10) && vars.cpGet)
					return true;
				break;
			//The Power of Razia
			case 13:
				vars.xTarget2 = 430;
				vars.yTarget2 = 268;
				vars.zTarget2 = -99;
				if(current.xPostfs <= (vars.xTarget2+10) && current.xPostfs >= (vars.xTarget2-10) && current.yPostfs <= (vars.yTarget2+10) && current.yPostfs >= (vars.yTarget2-10) && current.zPostfs <= (vars.zTarget2+10) && current.zPostfs >= (vars.zTarget2-10) && vars.cpGet)
					return true;
				break;
			//The Climb
			case 14:
				vars.xTarget2 = 912;
				vars.yTarget2 = 256;
				vars.zTarget2 = -56;
				if(current.xPostfs <= (vars.xTarget2+10) && current.xPostfs >= (vars.xTarget2-10) && current.yPostfs <= (vars.yTarget2+10) && current.yPostfs >= (vars.yTarget2-10) && current.zPostfs <= (vars.zTarget2+10) && current.zPostfs >= (vars.zTarget2-10) && vars.cpGet)
					return true;
				break;
			//The Storm
			case 15:
				vars.xTarget2 = 948;
				vars.yTarget2 = -284;
				vars.zTarget2 = 86;
				if(current.xPostfs <= (vars.xTarget2+10) && current.xPostfs >= (vars.xTarget2-10) && current.yPostfs <= (vars.yTarget2+10) && current.yPostfs >= (vars.yTarget2-10) && current.zPostfs <= (vars.zTarget2+10) && current.zPostfs >= (vars.zTarget2-10) && vars.cpGet)
					return true;
				break;
			//The End
			case 16:
				vars.xTarget2 = 821;
				vars.yTarget2 = -257;
				vars.zTarget2 = -51;
				if(current.xPostfs <= (vars.xTarget2+1) && current.xPostfs >= (vars.xTarget2-1) && current.yPostfs <= (vars.yTarget2+1) && current.yPostfs >= (vars.yTarget2-1) && current.zPostfs <= (vars.zTarget2+1) && current.zPostfs >= (vars.zTarget2-1))
					return true;
				break;
			}
			//Unmarking flags at the end of each cycle.
			vars.cpGet = false;
		break;
	}
}
