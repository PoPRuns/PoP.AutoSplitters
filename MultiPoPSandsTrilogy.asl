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



startup
{
//SoT
	bool aboveCredits = false;
	
	bool newFountain = false;
	
	bool startUp = false;		
}
 

start
{
	//SoT
	vars.aboveCredits = false;
	vars.newFountain = false;
	vars.startUp = true;
	
	//Detecting if the game has started on the balcony.
	if(current.xPos1 >= -103.264 && current.yPos1 >= -4.8 && current.zPos1 >= 1.341 && current.xPos1 <= -103.262 && current.yPos1 <= -4.798 && current.zPos1 <= 1.343 && current.startValue == 1)
			return true;
	/*
	//WW
	//Detecting if the game has started on the boat.
	if(old.startValue2 == 1 && current.startValue2 == 2){
		if(current.xPos2 >= -997.6757 && current.xPos2 <= -997.6755)
			return true;
	}
		
	//T2T	
	//Detecting if the game has started on the ramparts.
	if(current.xPos3 >= -404.9 && current.xPos3 <= -404.8 && current.yCam <= 0.1082 && current.yCam >= 0.1080 && current.xCam <= 0.832 && current.xCam >= 0.8318)
		return true;	
	*/
}



split{	
	if(!vars.startUp){
	vars.aboveCredits = false;
	vars.newFountain = false;
	vars.startUp = true;	
	}
	
	//List of SoT Splits across categories
	
	vars.GasStation = (Func <bool>)(() => {
		if(current.xPos1 >= 252 			&& current.yPos1 >= 130.647 		&& current.zPos1 >= 22.999 		&& current.xPos1 <= 258 			&& current.yPos1 <= 134 			&& current.zPos1 <= 23.001)
			return true;
		else
			return false;
	});
	vars.SandsUnleashed = (Func <bool>)(() => {
		if(current.xPos1 >= -6.177 		&& current.yPos1 >= 62.905 		&& current.zPos1 >= 7.604 		&& current.xPos1 <= -6.175 		&& current.yPos1 <= 62.907 		&& current.zPos1 <= 7.606)
			return true;
		else
			return false;
	});
	vars.FirstGuestRoom = (Func <bool>)(() => {
		if(current.xPos1 >= 30.297 		&& current.yPos1 >= 42.126 		&& current.zPos1 >= 12.998 		&& current.xPos1 <= 30.299 		&& current.yPos1 <= 42.128 		&& current.zPos1 <= 13)
			return true;
		else
			return false;
	});
	vars.SultanChamberZipless = (Func <bool>)(() => {
		if(current.xPos1 >= 98.445 		&& current.yPos1 >= 39.567 		&& current.zPos1 >= -8.96 		&& current.xPos1 <= 98.447 		&& current.yPos1 <= 39.57 		&& current.zPos1 <= -8.958) 		
			return true;
		else
			return false;
	});
	vars.SultanChamber = (Func <bool>)(() => {
		if(current.xPos1 >= 134.137 		&& current.yPos1 >= 54.990 		&& current.zPos1 >= -32.791 		&& current.xPos1 <= 134.139 		&& current.yPos1 <= 54.992 		&& current.zPos1 <= -32.789)
			return true;
		else
			return false;
	});
	vars.PalaceDefence = (Func <bool>)(() => {
		if(current.xPos1 >= 4.547 		&& current.yPos1 >= 40.494 		&& current.zPos1 >= -39.001 		&& current.xPos1 <= 8.851 		&& current.yPos1 <= 47.519 		&& current.zPos1 <= -38.999) 		
			return true;
		else
			return false;
	});
	vars.DadStart = (Func <bool>)(() => {
		if(current.xPos1 >= 6.714 		&& current.yPos1 >= 57.698 		&& current.zPos1 >= 21.005 		&& current.xPos1 <= 6.716 		&& current.yPos1 <= 57.7 		&& current.zPos1 <= 21.007) 		
			return true;
		else
			return false;
	});
	vars.DadDead = (Func <bool>)(() => {
		if(current.xPos1 >= -6.001 		&& current.yPos1 >= -18.6 		&& current.zPos1 >= 1.998 		&& current.xPos1 <= -5.999 		&& current.yPos1 <= -18.4 		&& current.zPos1 <= 2.001)
			return true;
		else
			return false;
	});
	vars.TheWarehouse = (Func <bool>)(() => {
		if(current.xPos1 >= -73.352 		&& current.yPos1 >= -28.5 		&& current.zPos1 >= -1.001 		&& current.xPos1 <= -71.233 		&& current.yPos1 <= -26.868 		&& current.zPos1 <= -0.818) 		
			return true;
		else
			return false;
	});
	vars.TheZoo = (Func <bool>)(() => {
		if(current.xPos1 >= -141.299 	&& current.yPos1 >= -47.21 		&& current.zPos1 >= -31.1 		&& current.xPos1 <= -139.797 	&& current.yPos1 <= -42.801 		&& current.zPos1 <= -30.9) 		
			return true;
		else
			return false;
	});
	vars.BirdCage = (Func <bool>)(() => {
		if(current.xPos1 >= -211 		&& current.yPos1 >= -23 			&& current.zPos1 >= -9 			&& current.xPos1 <= -208 		&& current.yPos1 <= -21 			&& current.zPos1 <= -8.8) 		
			return true;
		else
			return false;
	});
	vars.CliffWaterfalls = (Func <bool>)(() => {
		if(current.xPos1 >= -233.6 		&& current.yPos1 >= 33.7 		&& current.zPos1 >= -42.6 		&& current.xPos1 <= -231.4 		&& current.yPos1 <= 35 			&& current.zPos1 <= -42.4) 		
			return true;
		else
			return false;
	});
	vars.TheBathsZipless = (Func <bool>)(() => {
		if(current.xPos1 >= -215.85 		&& current.yPos1 >= 54.261 		&& current.zPos1 >= -43.501 		&& current.xPos1 <= -214.089 	&& current.yPos1 <= 58.699 		&& current.zPos1 <= -43.499) 		
			return true;
		else
			return false;
	});
	vars.TheBaths = (Func <bool>)(() => {
		if(current.xPos1 >= -211.427 	&& current.yPos1 >= 56.602 		&& current.zPos1 >= -43.501 		&& current.xPos1 <= -211.425 	&& current.yPos1 <= 56.604 		&& current.zPos1 <= -43.499)
			return true;
		else
			return false;
	});
	vars.SecondSword = (Func <bool>)(() => {
		if(current.xPos1 >= -106.819 	&& current.yPos1 >= 81.097 		&& current.zPos1 >= -27.269 		&& current.xPos1 <= -106.817 	&& current.yPos1 <= 81.099 		&& current.zPos1 <= -27.267) 		
			return true;
		else
			return false;
	});
	vars.TheDaybreak = (Func <bool>)(() => {
		if(current.xPos1 >= -76 			&& current.yPos1 >= 192.4 		&& current.zPos1 >= -56.6 		&& current.xPos1 <= -70 			&& current.yPos1 <= 197.6 		&& current.zPos1 <= -54) 		
			return true;
		else
			return false;
	});
	vars.TheMesshall = (Func <bool>)(() => {
		if(current.xPos1 >= -183.267 	&& current.yPos1 >= 234.685 		&& current.zPos1 >= -37.528 		&& current.xPos1 <= -183.265 	&& current.yPos1 <= 234.687 		&& current.zPos1 <= -37.526)
			return true;
		else
			return false;
	});
	vars.DrawbridgeTower = (Func <bool>)(() => {
		if(current.xPos1 >= -267 		&& current.yPos1 >= 232 			&& current.zPos1 >= -35.6 		&& current.xPos1 <= -262 		&& current.yPos1 <= 267 			&& current.zPos1 <= -35.5) 		
			return true;
		else
			return false;
	});
	vars.BrokenBridge = (Func <bool>)(() => {
		if(current.xPos1 >= -265 		&& current.yPos1 >= 159 			&& current.zPos1 >= -13.6 		&& current.xPos1 <= -257 		&& current.yPos1 <= 167 			&& current.zPos1 <= -13.4) 		
			return true;
		else
			return false;
	});
	vars.TheCavesZipless = (Func <bool>)(() => {
		if(current.xPos1 >= -303 		&& current.yPos1 >= 112 			&& current.zPos1 >= -56.1 		&& current.xPos1 <= -297.5 		&& current.yPos1 <= 113.5 		&& current.zPos1 <= -55.9) 		
			return true;
		else
			return false;
	});
	vars.TheCaves = (Func <bool>)(() => {
		if(current.xPos1 >= -246.839 	&& current.yPos1 >= 78.019 		&& current.zPos1 >= -71.731 		&& current.xPos1 <= -241.677 	&& current.yPos1 <= 87.936 		&& current.zPos1 <= -70.7)
			return true;
		else
			return false;
	});
	vars.TheCavesAC = (Func <bool>)(() => {
		if(current.xPos1 >=-171.193 		&& current.yPos1 >= -52.07 			&& current.zPos1 >= -119.863 	&& current.xPos1 <= -171.191 		&& current.yPos1 <= -52.068 		&& current.zPos1 <= -119.861)
			return true;
		else
			return false;
	});
	vars.TheWaterfall = (Func <bool>)(() => {
		if(current.xPos1 >= -242 		&& current.yPos1 >= 79.5 		&& current.zPos1 >= -121 		&& current.xPos1 <= -240.5 		&& current.yPos1 <= 83 			&& current.zPos1 <= -118)		
			return true;
		else
			return false;
	});
	vars.TheUGReservoirZipless = (Func <bool>)(() => {
		if(current.xPos1 >= -121 		&& current.yPos1 >= -9 			&& current.zPos1 >= -154.1 		&& current.xPos1 <= -110 		&& current.yPos1 <= -7 			&& current.zPos1 <= -153.9) 		
			return true;
		else
			return false;
	});
	vars.TheUGReservoir = (Func <bool>)(() => {
		if(current.xPos1 >= -51.477 		&& current.yPos1 >= 72.155 		&& current.zPos1 >= -24.802 		&& current.xPos1 <= -48.475 		&& current.yPos1 <= 73.657 		&& current.zPos1 <= -24.799)
			return true;
		else
			return false;
	});
	vars.HallofLearning = (Func <bool>)(() => {
		if(current.xPos1 >= 73 			&& current.yPos1 >= 161 			&& current.zPos1 >= -24.1 		&& current.xPos1 <= 79 			&& current.yPos1 <= 163 			&& current.zPos1 <= -23.9) 		
			return true;
		else
			return false;
	});
	vars.TheObservatory = (Func <bool>)(() => {
		if(current.xPos1 >= 139.231 		&& current.yPos1 >= 162.556 		&& current.zPos1 >= -29.502 		&& current.xPos1 <= 139.233 		&& current.yPos1 <= 162.558 		&& current.zPos1 <= -29.5)
			return true;
		else
			return false;
	});
	vars.ObservatoryExit = (Func <bool>)(() => {
		if(current.xPos1 >= 137 			&& current.yPos1 >= 164 			&& current.zPos1 >= -29.5 		&& current.xPos1 <= 141 			&& current.yPos1 <= 164.67 		&& current.zPos1 <= -29.2) 		
			return true;
		else
			return false;
	});
	vars.HoLCourtyardsExit = (Func <bool>)(() => {
		if(current.xPos1 >= 72 			&& current.yPos1 >= 90 			&& current.zPos1 >= -27.1 		&& current.xPos1 <= 77 			&& current.yPos1 <= 95.7 		&& current.zPos1 <= -26.9) 		
			return true;
		else
			return false;
	});
	vars.TheAzadPrison = (Func <bool>)(() => {
		if(current.xPos1 >= 190 			&& current.yPos1 >= -21 			&& current.zPos1 >= -17.6 		&& current.xPos1 <= 195 			&& current.yPos1 <= -19 			&& current.zPos1 <= -17.3) 		
					return true;
		else
			return false;
	});
	vars.TortureChamberZipless = (Func <bool>)(() => {
		if(current.xPos1 >= 187.5 		&& current.yPos1 >= -39 			&& current.zPos1 >= -119.1 		&& current.xPos1 <= 192.5 		&& current.yPos1 <= -37.5 		&& current.zPos1 <= -118.9) 					
			return true;
		else
			return false;
	});
	vars.TortureChamber = (Func <bool>)(() => {
		if(current.xPos1 >= 139.231 		&& current.yPos1 >= 162.556 		&& current.zPos1 >= -29.502 		&& current.xPos1 <= 139.233 		&& current.yPos1 <= 162.558 		&& current.zPos1 <= -29.5)
			return true;
		else
			return false;
	});
	vars.TheElevator = (Func <bool>)(() => {
		if(current.xPos1 >= 74 			&& current.yPos1 >= -46.751 		&& current.zPos1 >= -33.501 		&& current.xPos1 <= 74.171 		&& current.yPos1 <= -43.252 		&& current.zPos1 <= -33.499) 		
			return true;
		else
			return false;
	});
	vars.TheDreamZipless = (Func <bool>)(() => {
		if(current.xPos1 >= 99 			&& current.yPos1 >= -11 			&& current.zPos1 >= -56 			&& current.xPos1 <= 101 			&& current.yPos1 <= -10 			&& current.zPos1 <= -54) 		
			return true;
		else
			return false;
	});
	vars.TheDream = (Func <bool>)(() => {
		if(current.xPos1 >= 95.8 		&& current.yPos1 >= -25.1 		&& current.zPos1 >= -74.9 		&& current.xPos1 <= 96 			&& current.yPos1 <= -24.9 		&& current.zPos1 <= -74.7)
			return true;
		else
			return false;
	});
	vars.TheTomb = (Func <bool>)(() => {
		if(current.xPos1 >= 100.643 		&& current.yPos1 >= -11.543 		&& current.zPos1 >= -67.588 		&& current.xPos1 <= 100.645 		&& current.yPos1 <= -11.541 		&& current.zPos1 <= -67.586) 		
			return true;
		else
			return false;
	});
	vars.TowerofDawn = (Func <bool>)(() => {
		if(current.xPos1 >= 35.5 		&& current.yPos1 >= -50 			&& current.zPos1 >= -32 			&& current.xPos1 <= 35.7 		&& current.yPos1 <= -39 			&& current.zPos1 <= -30) 		
			return true;
		else
			return false;
	});
	vars.SettingSun = (Func <bool>)(() => {
		if(current.xPos1 >= 60 			&& current.yPos1 >= -58 			&& current.zPos1 >= 30 			&& current.xPos1 <= 61 			&& current.yPos1 <= -57 			&& current.zPos1 <= 32) 		
			return true;
		else
			return false;
	});
	vars.HonorGlory = (Func <bool>)(() => {
		if(current.xPos1 >= 81 			&& current.yPos1 >= -60.3 		&& current.zPos1 >= 89 			&& current.xPos1 <= 82 			&& current.yPos1 <= -59.7 		&& current.zPos1 <= 90)
			return true;
		else
			return false;
	});
	vars.GrandRewind = (Func <bool>)(() => {
		if(current.xPos1 >= 660.376 		&& current.yPos1 >= 190.980 		&& current.zPos1 >= 0.432 		&& current.xPos1 <= 660.378 		&& current.yPos1 <= 190.983 		&& current.zPos1 <= 0.434)
			return true;
		else
			return false;
	});
	vars.SoTEnd = (Func <bool>)(() => {
		if(current.xPos1 >= 658.26 		&& current.yPos1 >= 210.92 		&& current.zPos1 >= 12.5 		&& current.xPos1 <= 661.46 		&& current.yPos1 <= 213.72)
			vars.aboveCredits = true;
		if(current.xPos1 >= 658.26 		&& current.yPos1 >= 210.92 		&& current.zPos1 >= 9.8 			&& current.xPos1 <= 661.46 		&& current.yPos1 <= 213.72 		&& current.zPos1 <= 12.5 && vars.aboveCredits)
			return true;
		if(current.vizierHealth == 4)				
			return true;
		else
			return false;
	});
	vars.SoTLU = (Func <bool>)(() => {
		if(current.xPos1 >= -477.88 		&& current.yPos1 >= -298 			&& current.zPos1 >= -0.5 		&& current.xPos1 <= -477 			&& current.yPos1 <= -297.1 		&& current.zPos1 <= -0.4){
			vars.newFountain = true;
			}
		if(current.xPos1 >=-492.608 		&& current.yPos1 >= -248.833 		&& current.zPos1 >= 0.219 		&& current.xPos1 <= -492.606 		&& current.yPos1 <= -248.831 	&& current.zPos1 <= 0.221 && vars.newFountain){  
			vars.newFountain = false;
			return true;
		}
		else
			return false;
	});
	
	//List of WW Splits across categories
	
	vars.TheBoat = (Func <bool>)(() => {
		if(current.xPos2 >= -1003 		&& current.yPos2 >=  -1028 		&& current.zPos2 >=  14 			&& current.xPos2 <=  -995 		&& current.yPos2 <=  -1016 		&& current.zPos2 <=  15			&& current.storyValue == 0		&& current.bossHealth == 0)
			return true;
		else
			return false;
	});
	vars.SpiderSword = (Func <bool>)(() => {
		if(current.xPos2 >= 43.3 		&& current.yPos2 >=  -75.7 		&& current.zPos2 >=  370 		&& current.xPos2 <=  43.4 		&& current.yPos2 <=  -75.6 		&& current.zPos2 <=  370.1		&& current.storyValue == 7)
			return true;
		else
			return false;
	});
	vars.TheRavenMan = (Func <bool>)(() => {
		if(current.xPos2 >= -5.359 		&& current.yPos2 >= -161.539 	&& current.zPos2 >= 66.5 		&& current.xPos2 <= -4.913 		&& current.yPos2 <= -161.500 	&& current.zPos2 <= 67.5 	&& current.storyValue == 2)
			return true;
		else
			return false;
	});
	vars.TimePortal = (Func <bool>)(() => {
		if(current.xPos2 >= 122.8 		&& current.yPos2 >= -156.1 		&& current.zPos2 >= 368.5 		&& current.xPos2 <= 122.9 		&& current.yPos2 <= -156 		&& current.zPos2 <= 369.5 	&& current.storyValue == 2)			
			return true;
		else
			return false;
	});
	vars.ChaseShadee = (Func <bool>)(() => {
		if(current.xPos2 >= 43.3 		&& current.yPos2 >=  -75.7 		&& current.zPos2 >=  370 		&& current.xPos2 <=  43.4 		&& current.yPos2 <=  -75.6 		&& current.zPos2 <=  370.1		&& current.storyValue == 7)
			return true;
		else
			return false;
	});
	vars.DamselDistress = (Func <bool>)(() => {
		if(current.xPos2 >= 115 			&& current.yPos2 >=  -114 		&& current.zPos2 >=  357 		&& current.xPos2 <=  132 		&& current.yPos2 <=  -80 		&& current.zPos2 <=  361			&& current.storyValue == 8		&& current.bossHealth == 0)
			return true;
		else
			return false;
	});
	vars.TheDahaka = (Func <bool>)(() => {
		if(current.xPos2 >= 40.1 		&& current.yPos2 >=  -96.1 		&& current.zPos2 >=  86 			&& current.xPos2 <=  42.4 		&& current.yPos2 <=  -95.9 		&& current.zPos2 <=  86.1		&& current.storyValue == 9)
			return true;
		else
			return false;
	});
	vars.SerpentSword = (Func <bool>)(() => {
		if(current.xPos2 >= -96.5 		&& current.yPos2 >=  41.3 		&& current.zPos2 >=  407.4 		&& current.xPos2 <=  -96.4 		&& current.yPos2 <=  41.4 		&& current.zPos2 <=  407.5		&& current.storyValue == 13)
			return true;
		else
			return false;
	});
	vars.GardenHall = (Func <bool>)(() => {
		if(current.xPos2 >= 66.9 		&& current.yPos2 >=  11.4 		&& current.zPos2 >=  400 		&& current.xPos2 <=  67.1 		&& current.yPos2 <=  11.6 		&& current.zPos2 <=  400.2		&& current.storyValue == 22)
			return true;
		else
			return false;
	});
	vars.WaterworksDone = (Func <bool>)(() => {
		if(current.xPos2 >= 23 			&& current.yPos2 >=  41 			&& current.zPos2 >=  441 		&& current.xPos2 <=  29 			&& current.yPos2 <=  43 			&& current.zPos2 <=  450			&& current.storyValue == 22)
			return true;
		else
			return false;
	});
	vars.LionSword = (Func <bool>)(() => {
		if(current.xPos2 >= -44.7 		&& current.yPos2 >=  -27.1 		&& current.zPos2 >=  389 		&& current.xPos2 <=  -44.6 		&& current.yPos2 <=  -27 		&& current.zPos2 <=  389.1		&& current.storyValue == 21)
			return true;
		else
			return false;
	});
	vars.TheMechTower = (Func <bool>)(() => {
		if(current.xPos2 >= -167 		&& current.yPos2 >=  -47.5 		&& current.zPos2 >=  409.6363 	&& current.xPos2 <=  -162 		&& current.yPos2 <=  -46 		&& current.zPos2 <=  412			&& current.storyValue == 15)
			return true;
		else
			return false;
	});
	vars.TheMechTowTENMG = (Func <bool>)(() => {
		if(current.xPos >= -208			&& current.yPos >= -35.5		&& current.zPos >= 419.9		&& current.xPos <= -205			&& current.yPos <= -32.5		&& current.zPos <= 423			&& current.storyValue == 63)
			return true;
		else
			return false;
	});
	vars.RavagesPortal = (Func <bool>)(() => {
		if(current.xPos2 >= -210.018 	&& current.yPos2 >=  164.259 	&& current.zPos2 >=  440.9 		&& current.xPos2 <=  -210.016 	&& current.yPos2 <=  164.261 	&& current.zPos2 <=  441.1		&& current.storyValue == 16)
			return true;
		else
			return false;
	});
	vars.ActivationRuins = (Func <bool>)(() => {
		if(current.xPos2 >= -206 		&& current.yPos2 >=  59.8 		&& current.zPos2 >=  162.6 		&& current.xPos2 <=  -205.8 		&& current.yPos2 <=  67.4 		&& current.zPos2 <=  163.1		&& current.storyValue == 18)
			return true;
		else
			return false;
	});
	vars.ActivationDone = (Func <bool>)(() => {
		if(current.xPos2 >= -192.5 		&& current.yPos2 >=  109 		&& current.zPos2 >=  471.9 		&& current.xPos2 <=  -189.5 		&& current.yPos2 <=  111 		&& current.zPos2 <=  472.1		&& current.storyValue == 19)
			return true;
		else
			return false;
	});
	vars.SandWraithDead = (Func <bool>)(() => {
		if(current.xPos2 >= -50 			&& current.yPos2 >=  -13 		&& current.zPos2 >=  388.9 		&& current.xPos2 <=  -39 		&& current.yPos2 <=  -5 			&& current.zPos2 <=  389.8		&& current.storyValue == 33)
			return true;
		else
			return false;
	});
	vars.KaileenaDead = (Func <bool>)(() => {
		if(current.xPos2 >= -74 			&& current.yPos2 >=  53.5 		&& current.zPos2 >=  414 		&& current.xPos2 <=  -31 		&& current.yPos2 <=  104 		&& current.zPos2 <=  422			&& current.storyValue == 38		&& current.bossHealth == 0)
			return true;
		else
			return false;
	});
	vars.CatacombsExit = (Func <bool>)(() => {
		if(current.xPos2 >= -100 		&& current.yPos2 >=  -190 		&& current.zPos2 >=  33 			&& current.xPos2 <=  -97.5 		&& current.yPos2 <=  -187 		&& current.zPos2 <=  33.2		&& current.storyValue == 39)
			return true;
		else
			return false;
	});
	vars.ScorpionSword = (Func <bool>)(() => {
		if(current.xPos2 >= -170.1 		&& current.yPos2 >= -127.3 		&& current.zPos2 >= 335.5 		&& current.xPos2 <= -170 		&& current.yPos2 <= -127.2 		&& current.zPos2 <= 336.5 	&& current.storyValue == 59)
			return true;
		else
			return false;
	});
	vars.TheLibrary = (Func <bool>)(() => {
		if(current.xPos2 >= -112 		&& current.yPos2 >=  -144 		&& current.zPos2 >=  384.9 		&& current.xPos2 <=  -111 		&& current.yPos2 <=  -137 		&& current.zPos2 <=  389)
			return true;
		else
			return false;
	});
	vars.HourglassRevisited = (Func <bool>)(() => {
		if(current.xPos2 >= -108.3 		&& current.yPos2 >=  40 			&& current.zPos2 >=  407.3 		&& current.xPos2 <=  -106 		&& current.yPos2 <=  45 			&& current.zPos2 <=  407.5		&& current.storyValue == 45)
			return true;
		else
			return false;
	});
	vars.MaskofWraith = (Func <bool>)(() => {
		if(current.xPos2 >= -20.5 		&& current.yPos2 >=  236.8 		&& current.zPos2 >=  133 		&& current.xPos2 <=  -20.4 		&& current.yPos2 <=  267 		&& current.zPos2 <=  133.1		&& current.storyValue == 46)
			return true;
		else
			return false;
	});
	vars.SandGriffin = (Func <bool>)(() => {
		if(current.xPos2 >= -23 			&& current.yPos2 >=  163 		&& current.zPos2 >=  429 		&& current.xPos2 <=  -15 		&& current.yPos2 <=  166.5 		&& current.zPos2 <=  431			&& current.storyValue == 48)
			return true;
		else
			return false;
	});
	vars.MirroredFates = (Func <bool>)(() => {
		if(current.xPos2 >= 136.7 		&& current.yPos2 >=  -110.6 		&& current.zPos2 >=  377.9 		&& current.xPos2 <=  136.9 		&& current.yPos2 <=  -110.4 		&& current.zPos2 <=  378			&& current.storyValue == 55)
			return true;
		else
			return false;
	});
	vars.FavourUnknown = (Func <bool>)(() => {
		if(current.xPos2 >= 41.1 		&& current.yPos2 >=  -180.1 		&& current.zPos2 >=  368.9 		&& current.xPos2 <=  41.2 		&& current.yPos2 <=  -180 		&& current.zPos2 <=  369.1		&& current.storyValue == 57)
			return true;
		else
			return false;
	});
	vars.RNGStorygate = (Func <bool>)(() => {
		if(current.storyValue == 59)
			return true;
		else
			return false;
	});
	vars.LightSword = (Func <bool>)(() => {
		if(current.secondaryWeapon == 50 && current.storyValue == 61)
			return true;
		else
			return false;
	});
	vars.WWEndgame = (Func <bool>)(() => {
		if((current.storyValue == 63))
					return true;
		else
			return false;
	});
	vars.DeathofaPrince = (Func <bool>)(() => {
		if(current.xPos2 >= -67 			&& current.yPos2 >=  -23.3 		&& current.zPos2 >=  399.9 		&& current.xPos2 <=  -65.1 		&& current.yPos2 <=  -23.1 		&& current.zPos2 <=  400			&& current.storyValue == 64)
			return true;
		else
			return false;
	});
	vars.SlomoPortal = (Func <bool>)(() => {
		if(current.xPos2 >= -52.7 		&& current.yPos2 >= 137.2 		&& current.zPos2 >= 418 			&& current.xPos2 <= -52.6 		&& current.yPos2 <= 137.3 		&& current.zPos2 <= 419 		&& current.storyValue == 66)
			return true;
		else
			return false;
	});
	vars.WWEnd = (Func <bool>)(() => {
		if(current.xPos2 >= -35 			&& current.yPos2 >= 170 			&& current.zPos2 >= 128.9 		&& current.xPos2 <= -5 			&& current.yPos2 <= 205 			&& current.zPos2 <= 129.1 	&& current.storyValue >= 66 && current.bossHealth == 0)
			return true;
		else
			return false;
	});
	vars.WWLU1 = (Func <bool>)(() => {
		if(current.xPos2 >= 52			&& current.yPos2 >= -188.7		&& current.zPos2 >= 381.9		&& current.xPos2 <= 52.8			&& current.yPos2 <= -188.6		&& current.zPos2 <= 382.1		&& current.storyValue == 2)
			return true;
		else
			return false;
	});
	vars.WWLU2 = (Func <bool>)(() => {
		if(current.xPos2 >= -112.1		&& current.yPos2 >= -66.1		&& current.zPos2 >= 360.9		&& current.xPos2 <= -112			&& current.yPos2 <= -65.2		&& current.zPos2 <= 361			&& current.storyValue == 59)
			return true;
		else
			return false;
	});
	vars.WWLU3 = (Func <bool>)(() => {
		if(current.xPos2 >= -74.8		&& current.yPos2 >= -102.8		&& current.zPos2 >= 378.9		&& current.xPos2 <= -74.2		&& current.yPos2 <= -102.7		&& current.zPos2 <= 379			&& current.storyValue == 60)
			return true;
		else
			return false;
	});
	vars.WWLU4 = (Func <bool>)(() => {
		if(current.xPos2 >= -161.2		&& current.yPos2 >= 170.3		&& current.zPos2 >= 471.9		&& current.xPos2 <= -161			&& current.yPos2 <= 171			&& current.zPos2 <= 472.1		&& current.storyValue == 63)
			return true;
		else
			return false;
	});
	vars.WWLU5 = (Func <bool>)(() => {
		if(current.xPos2 >= 138.8		&& current.yPos2 >= 115.3		&& current.zPos2 >= 382.5		&& current.xPos2 <= 139			&& current.yPos2 <= 116.7		&& current.zPos2 <= 382.6		&& current.storyValue == 64)
			return true;
		else
			return false;
	});
	vars.WWLU6 = (Func <bool>)(() => {
		if(current.xPos2 >= 76.1			&& current.yPos2 >= 64.1			&& current.zPos2 >= 461.4		&& current.xPos2 <= 76.2			&& current.yPos2 <= 64.9			&& current.zPos2 <= 461.6		&& current.storyValue == 64)
			return true;
		else
			return false;
	});
	vars.WWLU7 = (Func <bool>)(() => {
		if(current.xPos2 >= 190.2		&& current.yPos2 >= -131.9		&& current.zPos2 >= 353.9		&& current.xPos2 <= 190.4		&& current.yPos2 <= -131.8		&& current.zPos2 <= 354.1		&& current.storyValue == 64)
			return true;
		else
			return false;
	});
	vars.WWLU8 = (Func <bool>)(() => {
		if(current.xPos2 >= 162.2		&& current.yPos2 >= -37.5		&& current.zPos2 >= 392.9		&& current.xPos2 <= 162.7		&& current.yPos2 <= -37.3		&& current.zPos2 <= 393.1		&& current.storyValue == 64)
			return true;
		else
			return false;
	});
	vars.WWLU9 = (Func <bool>)(() => {
		if(current.xPos2 >= -114.7		&& current.yPos2 >= -47.2		&& current.zPos2 >= 368.9		&& current.xPos2 <= -114.1		&& current.yPos2 <= -47			&& current.zPos2 <= 369.1		&& current.storyValue == 64)
			return true;
		else
			return false;
	});
	vars.WaterSword = (Func <bool>)(() => {
		if(current.xPos2 >= -96.643		&& current.yPos2 >= 43.059		&& current.zPos2 >= 407.4		&& current.xPos2 <= -96.641		&& current.yPos2 <= 43.061		&& current.zPos2 <= 407.5		&& current.storyValue == 66)
			return true;
		else
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
		case "Sands Trilogy (Any%, Normal)":
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
			
		case "Sands Trilogy (Completionist, Normal)":
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
	}
}
