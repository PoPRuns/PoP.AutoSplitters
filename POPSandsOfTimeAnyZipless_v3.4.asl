state("POP"){
//Some memory value that reliably changes when 'New Game' is pressed.
	int startValue : 0x6BC980;

//Prince's position
	float xPos : 0x00699474, 0xC, 0x30;
	float yPos : 0x00699474, 0xC, 0x34;
	float zPos : 0x00699474, 0xC, 0x38;

//The Vizier's health where 0 is unharmed and 4 is dead.
	int vizierHealth : 0x0040E518, 0x6C, 0x18, 0x4, 0x44, 0x0;

}

startup{
	bool aboveCredits = false;
	
	bool newFountain = false;
	
	bool startUp = false;
}

start{
	
	vars.aboveCredits = false;
	vars.newFountain = false;
	vars.startUp = true;
	
	//Detecting if the game has started on the balcony.
	if(current.xPos >= -103.264 && current.yPos >= -4.8 && current.zPos >= 1.341 && current.xPos <= -103.262 && current.yPos <= -4.798 && current.zPos <= 1.343 && current.startValue == 1)
			return true;
}

reset{
	
}

split{
	
	if(!vars.startUp){
	vars.aboveCredits = false;
	vars.newFountain = false;
	vars.startUp = true;	
	}
	
	switch(timer.Run.GetExtendedCategoryName())
	{
		case "Any% (Normal)":
			switch (timer.CurrentSplitIndex)
			{
			//The Treasure Vaults
			case 0:
				if(current.xPos >= 252 			&& current.yPos >= 130.647 		&& current.zPos >= 22.999 		&& current.xPos <= 258 			&& current.yPos <= 134 			&& current.zPos <= 23.001)
					return true;
				break;
			//The Sands of Time
			case 1:
				if(current.xPos >= -6.177 		&& current.yPos >= 62.905 		&& current.zPos >= 7.604 		&& current.xPos <= -6.175 		&& current.yPos <= 62.907 		&& current.zPos <= 7.606)
					return true;
				break;
			//The Sultan's Chamber (Death)
			case 2:
				if(current.xPos >= 134.137 		&& current.yPos >= 54.990 		&& current.zPos >= -32.791 		&& current.xPos <= 134.139 		&& current.yPos <= 54.992 		&& current.zPos <= -32.789)
					return true;
				break;
			//Death of the Sand King
			case 3:
				if(current.xPos >= -6.001 		&& current.yPos >= -18.6 		&& current.zPos >= 1.998 		&& current.xPos <= -5.999 		&& current.yPos <= -18.4 		&& current.zPos <= 2.001)
							return true;
				break;
			//The Baths (Death)
			case 4:
				if(current.xPos >= -211.427 	&& current.yPos >= 56.602 		&& current.zPos >= -43.501 		&& current.xPos <= -211.425 	&& current.yPos <= 56.604 		&& current.zPos <= -43.499)
					return true;
				break;
			//The Messhall (Death)
			case 5:
				if(current.xPos >= -183.267 	&& current.yPos >= 234.685 		&& current.zPos >= -37.528 		&& current.xPos <= -183.265 	&& current.yPos <= 234.687 		&& current.zPos <= -37.526)
					return true;
				break;
			//The Caves
			case 6:
				if(current.xPos >= -246.839 	&& current.yPos >= 78.019 		&& current.zPos >= -71.731 		&& current.xPos <= -241.677 	&& current.yPos <= 87.936 		&& current.zPos <= -70.7)
					return true;
				break;
			//Exit Underground Reservoir
			case 7:
				if(current.xPos >= -51.477 		&& current.yPos >= 72.155 		&& current.zPos >= -24.802 		&& current.xPos <= -48.475 		&& current.yPos <= 73.657 		&& current.zPos <= -24.799)
					return true;
				break;
			//The Observatory (Death)
			case 8:
				if(current.xPos >= 139.231 		&& current.yPos >= 162.556 		&& current.zPos >= -29.502 		&& current.xPos <= 139.233 		&& current.yPos <= 162.558 		&& current.zPos <= -29.5)
					return true;
				break;
			//The Torture Chamber (Death)
			case 9:
				if(current.xPos >= 189.999 		&& current.yPos >= -43.278 		&& current.zPos >= -119.001 	&& current.xPos <= 190.001 		&& current.yPos <= -43.276 		&& current.zPos <= -118.999)
					return true;
				break;
			//The Dream
			case 10:
				if(current.xPos >= 95.8 		&& current.yPos >= -25.1 		&& current.zPos >= -74.9 		&& current.xPos <= 96 			&& current.yPos <= -24.9 		&& current.zPos <= -74.7)
					return true;
				break;
			//Honor and Glory
			case 11:
				if(current.xPos >= 81 			&& current.yPos >= -60.3 		&& current.zPos >= 89 			&& current.xPos <= 82 			&& current.yPos <= -59.7 		&& current.zPos <= 90)
					return true;
				break;
			//The Grand Rewind
			case 12:
				if(current.xPos >= 660.376 		&& current.yPos >= 190.980 		&& current.zPos >= 0.432 		&& current.xPos <= 660.378 		&& current.yPos <= 190.983 		&& current.zPos <= 0.434)
					return true;
				break;
			//The End
			case 13:
				if(current.xPos >= 658.26 		&& current.yPos >= 210.92 		&& current.zPos >= 12.5 		&& current.xPos <= 661.46 		&& current.yPos <= 213.72)
					vars.aboveCredits = true;
				if(current.xPos >= 658.26 		&& current.yPos >= 210.92 		&& current.zPos >= 9.8 			&& current.xPos <= 661.46 		&& current.yPos <= 213.72 		&& current.zPos <= 12.5 && vars.aboveCredits)
					return true;
				if(current.vizierHealth == 4)				
					return true;
				break;
		}
		break;
		
		case "Any% (Zipless)":
			switch (timer.CurrentSplitIndex)
			{
			//The Treasure Vaults
			case 0:
				if(current.xPos >= 252 			&& current.yPos >= 130.647 		&& current.zPos >= 22.999 		&& current.xPos <= 258 			&& current.yPos <= 134 			&& current.zPos <= 23.001)
					return true;
				break;
			//The Sands of Time
			case 1:
				if(current.xPos >= -6.177 		&& current.yPos >= 62.905 		&& current.zPos >= 7.604 		&& current.xPos <= -6.175 		&& current.yPos <= 62.907 		&& current.zPos <= 7.606)
					return true;
				break;
			//First Guest Room
			case 2: 
				if(current.xPos >= 30.297 		&& current.yPos >= 42.126 		&& current.zPos >= 12.998 		&& current.xPos <= 30.299 		&& current.yPos <= 42.128 		&& current.zPos <= 13)
					return true;
				break;
			//The Sultan's Chamber
			case 3: 
				if(current.xPos >= 98.445 		&& current.yPos >= 39.567 		&& current.zPos >= -8.96 		&& current.xPos <= 98.447 		&& current.yPos <= 39.57 		&& current.zPos <= -8.958) 		
					return true;
				break;
			//Exit Palace Defense
			case 4: 
				if(current.xPos >= 4.547 		&& current.yPos >= 40.494 		&& current.zPos >= -39.001 		&& current.xPos <= 8.851 		&& current.yPos <= 47.519 		&& current.zPos <= -38.999) 		
					return true;
				break;
			//The Sand King
			case 5:
				if(current.xPos >= 6.714 		&& current.yPos >= 57.698 		&& current.zPos >= 21.005 		&& current.xPos <= 6.716 		&& current.yPos <= 57.7 		&& current.zPos <= 21.007) 		
					return true;
				break;
			//Death of the Sand King
			case 6:
				if(current.xPos >= -6.001 		&& current.yPos >= -18.6 		&& current.zPos >= 1.998 		&& current.xPos <= -5.999 		&& current.yPos <= -18.4 		&& current.zPos <= 2.001) 		
					return true;
				break;
			//The Warehouse
			case 7:
				if(current.xPos >= -73.352 		&& current.yPos >= -28.5 		&& current.zPos >= -1.001 		&& current.xPos <= -71.233 		&& current.yPos <= -26.868 		&& current.zPos <= -0.818) 		
					return true;
				break;
			//The Zoo
			case 8:	
				if(current.xPos >= -141.299 	&& current.yPos >= -47.21 		&& current.zPos >= -31.1 		&& current.xPos <= -139.797 	&& current.yPos <= -42.801 		&& current.zPos <= -30.9) 		
					return true;
				break;
			//Atop a Bird Cage
			case 9:
				if(current.xPos >= -211 		&& current.yPos >= -23 			&& current.zPos >= -9 			&& current.xPos <= -208 		&& current.yPos <= -21 			&& current.zPos <= -8.8) 		
					return true;
				break;
			//Cliffs and Waterfall
			case 10:
				if(current.xPos >= -233.6 		&& current.yPos >= 33.7 		&& current.zPos >= -42.6 		&& current.xPos <= -231.4 		&& current.yPos <= 35 			&& current.zPos <= -42.4) 		
					return true;
				break;
			//The Baths
			case 11:
				if(current.xPos >= -215.85 		&& current.yPos >= 54.261 		&& current.zPos >= -43.501 		&& current.xPos <= -214.089 	&& current.yPos <= 58.699 		&& current.zPos <= -43.499) 		
					return true;
				break;
			//Sword of the Mighty Warrior
			case 12:
				if(current.xPos >= -106.819 	&& current.yPos >= 81.097 		&& current.zPos >= -27.269 		&& current.xPos <= -106.817 	&& current.yPos <= 81.099 		&& current.zPos <= -27.267) 		
					return true;
				break;
			//Daybreak
			case 13:	
				if(current.xPos >= -76 			&& current.yPos >= 192.4 		&& current.zPos >= -56.6 		&& current.xPos <= -70 			&& current.yPos <= 197.6 		&& current.zPos <= -54) 		
					return true;
				break;
			//Drawbridge Tower
			case 14:
				if(current.xPos >= -267 		&& current.yPos >= 232 			&& current.zPos >= -35.6 		&& current.xPos <= -262 		&& current.yPos <= 267 			&& current.zPos <= -35.5) 		
					return true;
				break;
			//A Broken Bridge
			case 15:
				if(current.xPos >= -265 		&& current.yPos >= 159 			&& current.zPos >= -13.6 		&& current.xPos <= -257 		&& current.yPos <= 167 			&& current.zPos <= -13.4) 		
					return true;
				break;
			//The Caves
			case 16:
				if(current.xPos >= -303 		&& current.yPos >= 112 			&& current.zPos >= -56.1 		&& current.xPos <= -297.5 		&& current.yPos <= 113.5 		&& current.zPos <= -55.9) 		
					return true;
				break;
			//Waterfall
			case 17:
				if(current.xPos >= -242 		&& current.yPos >= 79.5 		&& current.zPos >= -121 		&& current.xPos <= -240.5 		&& current.yPos <= 83 			&& current.zPos <= -118)		
					return true;
				break;
			//An Underground Reservoir
			case 18:
				if(current.xPos >= -121 		&& current.yPos >= -9 			&& current.zPos >= -154.1 		&& current.xPos <= -110 		&& current.yPos <= -7 			&& current.zPos <= -153.9) 		
					return true;
				break;
			//Hall of Learning
			case 19:
				if(current.xPos >= 73 			&& current.yPos >= 161 			&& current.zPos >= -24.1 		&& current.xPos <= 79 			&& current.yPos <= 163 			&& current.zPos <= -23.9) 		
					return true;
				break;
			//Exit Observatory
			case 20:
				if(current.xPos >= 137 			&& current.yPos >= 164 			&& current.zPos >= -29.5 		&& current.xPos <= 141 			&& current.yPos <= 164.67 		&& current.zPos <= -29.2) 		
					return true;
				break;
			//Exit Hall of Learning Courtyards
			case 21:
				if(current.xPos >= 72 			&& current.yPos >= 90 			&& current.zPos >= -27.1 		&& current.xPos <= 77 			&& current.yPos <= 95.7 		&& current.zPos <= -26.9) 		
					return true;
				break;
			//The Prison
			case 22:
				if(current.xPos >= 190 			&& current.yPos >= -21 			&& current.zPos >= -17.6 		&& current.xPos <= 195 			&& current.yPos <= -19 			&& current.zPos <= -17.3) 		
					return true;
				break;
			//The Torture Chamber
			case 23:
				if(current.xPos >= 187.5 		&& current.yPos >= -39 			&& current.zPos >= -119.1 		&& current.xPos <= 192.5 		&& current.yPos <= -37.5 		&& current.zPos <= -118.9) 					
					return true;
				break;
			//The Elevator
			case 24:
				if(current.xPos >= 74 			&& current.yPos >= -46.751 		&& current.zPos >= -33.501 		&& current.xPos <= 74.171 		&& current.yPos <= -43.252 		&& current.zPos <= -33.499) 		
					return true;
				break;
			//The Dream
			case 25:
				if(current.xPos >= 99 			&& current.yPos >= -11 			&& current.zPos >= -56 			&& current.xPos <= 101 			&& current.yPos <= -10 			&& current.zPos <= -54) 		
					return true;
				break;
			//The Tomb
			case 26:
				if(current.xPos >= 100.643 		&& current.yPos >= -11.543 		&& current.zPos >= -67.588 		&& current.xPos <= 100.645 		&& current.yPos <= -11.541 		&& current.zPos <= -67.586) 		
					return true;
				break;
			//The Tower of Dawn
			case 27:
				if(current.xPos >= 35.5 		&& current.yPos >= -50 			&& current.zPos >= -32 			&& current.xPos <= 35.7 		&& current.yPos <= -39 			&& current.zPos <= -30) 		
					return true;
				break;
			//The Setting Sun
			case 28:
				if(current.xPos >= 60 			&& current.yPos >= -58 			&& current.zPos >= 30 			&& current.xPos <= 61 			&& current.yPos <= -57 			&& current.zPos <= 32) 		
					return true;
				break;
			//Honor and Glory
			case 29:
				if(current.xPos >= 81 			&& current.yPos >= -60.3 		&& current.zPos >= 89 			&& current.xPos <= 82 			&& current.yPos <= -59.7 		&& current.zPos <= 90) 							
					return true;
				break;
			//The Grand Rewind
			case 30:
				if(current.xPos >= 660.376 		&& current.yPos >= 190.980 		&& current.zPos >= 0.432 		&& current.xPos <= 660.378 		&& current.yPos <= 190.983 		&& current.zPos <= 0.434) 			
					return true;
				break;
			//The End
			case 31:
				if(current.xPos >= 658.26 		&& current.yPos >= 210.92 		&& current.zPos >= 9.8 			&& current.xPos <= 661.46 		&& current.yPos <= 213.72 		&& current.zPos <= 12.5)
					return true;
				if(current.vizierHealth == 4)				
					return true;
				break;
			}
			break;
			
		case "Any% (No Major Glitches)":
			switch (timer.CurrentSplitIndex)
			{
			//The Treasure Vaults
			case 0:
				if(current.xPos >= 252 			&& current.yPos >= 130.647 		&& current.zPos >= 22.999 		&& current.xPos <= 258 			&& current.yPos <= 134 			&& current.zPos <= 23.001)
					return true;
				break;
			//The Sands of Time
			case 1:
				if(current.xPos >= -6.177 		&& current.yPos >= 62.905 		&& current.zPos >= 7.604 		&& current.xPos <= -6.175 		&& current.yPos <= 62.907 		&& current.zPos <= 7.606)
					return true;
				break;
			//First Guest Room
			case 2:
				if(current.xPos >=30.297 		&& current.yPos >= 42.126 		&& current.zPos >= 12.998 		&& current.xPos <= 30.299 		&& current.yPos <= 42.128 		&& current.zPos <= 13)	
					return true;
				break;
			//The Sultan's Chamber
			case 3:
				if(current.xPos >=98.445 		&& current.yPos >= 39.567 		&& current.zPos >= -8.96 		&& current.xPos <= 98.447 		&& current.yPos <= 39.57 		&& current.zPos <= -8.958) 
					return true;
				break;
			//Exit Palace Defense
			case 4:
				if(current.xPos >=4.547 		&& current.yPos >= 40.494 		&& current.zPos >= -39.001 		&& current.xPos <= 8.851 		&& current.yPos <= 47.519 		&& current.zPos <= -38.999)
					return true;
				break;
			//The Sand King
			case 5:
				if(current.xPos >=6.714 		&& current.yPos >= 57.698 		&& current.zPos >= 21.005 		&& current.xPos <= 6.716 		&& current.yPos <= 57.7 		&& current.zPos <= 21.007) 
					return true;
				break;
			//Death of the Sand King
			case 6:
				if(current.xPos >=-6.001 		&& current.yPos >= -18.6 		&& current.zPos >= 1.998 		&& current.xPos <= -5.999 		&& current.yPos <= -18.4 		&& current.zPos <= 2.001) 
					return true;
				break;
			//The Warehouse
			case 7:
				if(current.xPos >=-73.352 		&& current.yPos >= -28.5 		&& current.zPos >= -1.001 		&& current.xPos <= -71.233 		&& current.yPos <= -26.868 		&& current.zPos <= -0.818) 
					return true;
				break;
			//The Zoo
			case 8:
				if(current.xPos >=-141.299 		&& current.yPos >= -47.21 		&& current.zPos >= -31.1 		&& current.xPos <= -139.797 	&& current.yPos <= -42.801 		&& current.zPos <= -30.9) 
					return true;
				break;
			//Atop a Bird Cage
			case 9:
				if(current.xPos >=-211 			&& current.yPos >= -23 			&& current.zPos >= -9 			&& current.xPos <= -208 		&& current.yPos <= -21 			&& current.zPos <= -8.8) 
					return true;
				break;
			//Cliffs and Waterfall
			case 10:
				if(current.xPos >=-233.6 		&& current.yPos >= 33.7 		&& current.zPos >= -42.6 		&& current.xPos <= -231.4 		&& current.yPos <= 35 			&& current.zPos <= -42.4) 
					return true;
				break;
			//The Baths
			case 11:
				if(current.xPos >=-215.85 		&& current.yPos >= 54.261 		&& current.zPos >= -43.501 		&& current.xPos <= -214.089 	&& current.yPos <= 58.699 		&& current.zPos <= -43.499) 
					return true;
				break;
			//Sword of the Mighty Warrior
			case 12:
				if(current.xPos >=-106.819 		&& current.yPos >= 81.097 		&& current.zPos >= -27.269 		&& current.xPos <= -106.817 	&& current.yPos <= 81.099 		&& current.zPos <= -27.267) 
					return true;
				break;
			//Daybreak
			case 13:
				if(current.xPos >=-76 			&& current.yPos >= 192.4 		&& current.zPos >= -56.6 		&& current.xPos <= -70 			&& current.yPos <= 197.6 		&& current.zPos <= -54) 
					return true;
				break;
			//Drawbridge Tower
			case 14:
				if(current.xPos >=-267 			&& current.yPos >= 232 			&& current.zPos >= -35.6 		&& current.xPos <= -262 		&& current.yPos <= 267 			&& current.zPos <= -35.5) 
					return true;
				break;
			//A Broken Bridge
			case 15:
				if(current.xPos >=-265 			&& current.yPos >= 159 			&& current.zPos >= -13.6 		&& current.xPos <= -257 		&& current.yPos <= 167 			&& current.zPos <= -13.4) 
					return true;
				break;
			//The Caves
			case 16:
				if(current.xPos >=-303 			&& current.yPos >= 112 			&& current.zPos >= -56.1 		&& current.xPos <= -297.5 		&& current.yPos <= 113.5 		&& current.zPos <= -55.9) 
					return true;
				break;
			//Waterfall
			case 17:
				if(current.xPos >=-242 			&& current.yPos >= 79.5 		&& current.zPos >= -121 		&& current.xPos <= -240.5 		&& current.yPos <= 83 			&& current.zPos <= -118) 
					return true;
				break;
			//An Underground Reservoir
			case 18:
				if(current.xPos >=-121 			&& current.yPos >= -9 			&& current.zPos >= -154.1 		&& current.xPos <= -110 		&& current.yPos <= -7 			&& current.zPos <= -153.9) 
					return true;
				break;
			//Hall of Learning
			case 19:
				if(current.xPos >=73 			&& current.yPos >= 161 			&& current.zPos >= -24.1 		&& current.xPos <= 79 			&& current.yPos <= 163 			&& current.zPos <= -23.9) 
					return true;
				break;
			//Exit Observatory
			case 20:
				if(current.xPos >=137 			&& current.yPos >= 164 			&& current.zPos >= -29.5 		&& current.xPos <= 141 			&& current.yPos <= 164.67 		&& current.zPos <= -29.2) 
					return true;
				break;
			//Exit Hall of Learning Courtyards
			case 21:
				if(current.xPos >=72 			&& current.yPos >= 90 			&& current.zPos >= -27.1 		&& current.xPos <= 77 			&& current.yPos <= 95.7 		&& current.zPos <= -26.9) 
					return true;
				break;
			//The Prison
			case 22:
				if(current.xPos >=190.332 		&& current.yPos >= -20.128 		&& current.zPos >= -17.5 		&& current.xPos <= 190.334 		&& current.yPos <= -20.126 		&& current.zPos <= -17.3) 
					return true;
				break;
			//The Torture Chamber
			case 23:
				if(current.xPos >=187.5 		&& current.yPos >= -39 			&& current.zPos >= -119.1 		&& current.xPos <= 192.5 		&& current.yPos <= -37.5 		&& current.zPos <= -118.9) 
					return true;
				break;
			//The Elevator 
			case 24:
				if(current.xPos >=74 			&& current.yPos >= -46.751 		&& current.zPos >= -33.501 		&& current.xPos <= 74.171 		&& current.yPos <= -43.252 		&& current.zPos <= -33.499) 
					return true;
				break;
			//The Dream
			case 25:
				if(current.xPos >=99 			&& current.yPos >= -11 			&& current.zPos >= -56 			&& current.xPos <= 101 			&& current.yPos <= -10 			&& current.zPos <= -54) 
					return true;
				break;
			//The Tomb
			case 26:
				if(current.xPos >=100.643 		&& current.yPos >= -11.543 		&& current.zPos >= -67.588 		&& current.xPos <= 100.645 		&& current.yPos <= -11.541 		&& current.zPos <= -67.586) 
					return true;
				break;
			//The Tower of Dawn
			case 27:
				if(current.xPos >=35.5 			&& current.yPos >= -50 			&& current.zPos >= -32 			&& current.xPos <= 35.7 		&& current.yPos <= -39 			&& current.zPos <= -30) 
					return true;
				break;
			//The Setting Sun
			case 28:
				if(current.xPos >=60 			&& current.yPos >= -58 			&& current.zPos >= 30 			&& current.xPos <= 61 			&& current.yPos <= -57 			&& current.zPos <= 32) 
					return true;
				break;
			//Honor and Glory
			case 29:
				if(current.xPos >=81 			&& current.yPos >= -60.3 		&& current.zPos >= 89 			&& current.xPos <= 82 			&& current.yPos <= -59.7 		&& current.zPos <= 90) 
					return true;
				break;
			//The Grand Rewind
			case 30:
				if(current.xPos >=660.376 		&& current.yPos >= 190.980 		&& current.zPos >= 0.432 		&& current.xPos <= 660.378 		&& current.yPos <= 190.983 		&& current.zPos <= 0.434) 
					return true;
				break;
			//The End
			case 31:
				if(current.xPos >= 658.26 		&& current.yPos >= 210.92 		&& current.zPos >= 12.5 		&& current.xPos <= 661.46 		&& current.yPos <= 213.72)
					vars.aboveCredits = true;
				if(current.xPos >= 658.26 		&& current.yPos >= 210.92 		&& current.zPos >= 9.8 			&& current.xPos <= 661.46 		&& current.yPos <= 213.72 		&& current.zPos <= 12.5 && vars.aboveCredits)
					return true;
				if(current.vizierHealth == 4)				
					return true;
				break;
			}
			break;
			
		case "All Collectibles (Normal)":
			switch (timer.CurrentSplitIndex)
			{
			//The Treasure Vaults
			case 0:
				if(current.xPos >= 252 			&& current.yPos >= 130.647 			&& current.zPos >= 22.999 		&& current.xPos <= 258 				&& current.yPos <= 134 			&& current.zPos <= 23.001)
					return true;
				break;
			//The Sands of Time
			case 1:
				if(current.xPos >= -6.177 		&& current.yPos >= 62.905 			&& current.zPos >= 7.604 		&& current.xPos <= -6.175 			&& current.yPos <= 62.907 		&& current.zPos <= 7.606)
					return true;
				break;
			//Life Upgrade 1
			case 2:
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//Life Upgrade 2
			case 3:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//Life Upgrade 3
			case 4:
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//The Baths (Death)
			case 5:	
				if(current.xPos >=-211.427 		&& current.yPos >= 56.602 			&& current.zPos >= -43.501 		&& current.xPos <= -211.425 		&& current.yPos <= 56.604 		&& current.zPos <= -43.499)
					return true;
				break;
			//Life Upgrade 4
			case 6:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//The Messhall (Death)
			case 7:	
				if(current.xPos >=-183.267 		&& current.yPos >= 234.685 			&& current.zPos >= -37.528 		&& current.xPos <= -183.265 		&& current.yPos <= 234.687 		&& current.zPos <= -37.526)
					return true;
				break;
			//Life Upgrade 5
			case 8:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//The Caves (Death)
			case 9:	
				if(current.xPos >=-171.193 		&& current.yPos >= -52.07 			&& current.zPos >= -119.863 	&& current.xPos <= -171.191 		&& current.yPos <= -52.068 		&& current.zPos <= -119.861)
					return true;
				break;
			//Life Upgrade 6
			case 10:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//Life Upgrade 7
			case 11:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//The Observatory (Death)
			case 12:	
				if(current.xPos >=139.231 		&& current.yPos >= 162.556 			&& current.zPos >= -29.502 		&& current.xPos <= 139.233 			&& current.yPos <= 162.558 		&& current.zPos <= -29.5)
					return true;
				break;
			//Life Upgrade 8
			case 13:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//Life Upgrade 9
			case 14:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//The Dream
			case 15:	
				if(current.xPos >=95.8 			&& current.yPos >= -25.1 			&& current.zPos >= -74.9 		&& current.xPos <= 96 				&& current.yPos <= -24.9 		&& current.zPos <= -74.7)
					return true;
				break;
			//Life Upgrade 10
			case 16:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//The Setting Sun
			case 17:	
				if(current.xPos >=60 			&& current.yPos >= -58 				&& current.zPos >= 30 			&& current.xPos <= 61 				&& current.yPos <= -57 			&& current.zPos <= 32)
					return true;
				break;
			//Honor and Glory
			case 18:	
				if(current.xPos >=81 			&& current.yPos >= -60.3 			&& current.zPos >= 89 			&& current.xPos <= 82 				&& current.yPos <= -59.7 		&& current.zPos <= 90)
					return true;
				break;
			//The Grand Rewind
			case 19:	
				if(current.xPos >=660.376 		&& current.yPos >= 190.980 			&& current.zPos >= 0.432 		&& current.xPos <= 660.378 			&& current.yPos <= 190.983 		&& current.zPos <= 0.434)
					return true;
				break;
			//The End
			case 20:
				if(current.xPos >= 658.26 		&& current.yPos >= 210.92 			&& current.zPos >= 12.5 		&& current.xPos <= 661.46 			&& current.yPos <= 213.72)
					vars.aboveCredits = true;
				if(current.xPos >= 658.26 		&& current.yPos >= 210.92 			&& current.zPos >= 9.8 			&& current.xPos <= 661.46 			&& current.yPos <= 213.72 		&& current.zPos <= 12.5 && vars.aboveCredits)
					return true;
				if(current.vizierHealth == 4)				
					return true;
				break;
			}
			break;
		
		case "All Collectibles (Zipless)":
			switch (timer.CurrentSplitIndex)
			{
			//The Treasure Vaults
			case 0:
				if(current.xPos >= 252 			&& current.yPos >= 130.647 			&& current.zPos >= 22.999 		&& current.xPos <= 258 			&& current.yPos <= 134 			&& current.zPos <= 23.001)
					return true;
				break;
			//The Sands of Time
			case 1:
				if(current.xPos >= -6.177 		&& current.yPos >= 62.905 			&& current.zPos >= 7.604 		&& current.xPos <= -6.175 		&& current.yPos <= 62.907 		&& current.zPos <= 7.606)
					return true;
				break;
			//First Guest Room
			case 2: 
				if(current.xPos >= 30.297 		&& current.yPos >= 42.126 			&& current.zPos >= 12.998 		&& current.xPos <= 30.299 		&& current.yPos <= 42.128 		&& current.zPos <= 13)
					return true;
				break;
			//Life Upgrade 1
			case 3:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//Exit Palace Defense
			case 4: 
				if(current.xPos >= 4.547 		&& current.yPos >= 40.494 			&& current.zPos >= -39.001 		&& current.xPos <= 8.851 		&& current.yPos <= 47.519 		&& current.zPos <= -38.999) 		
					return true;
				break;
			//Life Upgrade 2
			case 5:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//Death of the Sand King
			case 6:
				if(current.xPos >= -6.001 		&& current.yPos >= -18.6 			&& current.zPos >= 1.998 		&& current.xPos <= -5.999 		&& current.yPos <= -18.4 		&& current.zPos <= 2.001) 		
					return true;
				break;
			//Life Upgrade 3
			case 7:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//The Zoo
			case 8:	
				if(current.xPos >= -141.299 	&& current.yPos >= -47.21 			&& current.zPos >= -31.1 		&& current.xPos <= -139.797 	&& current.yPos <= -42.801 		&& current.zPos <= -30.9) 		
					return true;
				break;
			//Atop a Bird Cage
			case 9:
				if(current.xPos >= -211 		&& current.yPos >= -23 				&& current.zPos >= -9 			&& current.xPos <= -208 		&& current.yPos <= -21 			&& current.zPos <= -8.8) 		
					return true;
				break;
			//Cliffs and Waterfall
			case 10:
				if(current.xPos >= -233.6 		&& current.yPos >= 33.7 			&& current.zPos >= -42.6 		&& current.xPos <= -231.4 		&& current.yPos <= 35 			&& current.zPos <= -42.4) 		
					return true;
				break;
			//The Baths
			case 11:
				if(current.xPos >= -215.85 		&& current.yPos >= 54.261 			&& current.zPos >= -43.501 		&& current.xPos <= -214.089 	&& current.yPos <= 58.699 		&& current.zPos <= -43.499) 		
					return true;
				break;
			//Life Upgrade 4
			case 12:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//Daybreak
			case 13:	
				if(current.xPos >= -76 			&& current.yPos >= 192.4 			&& current.zPos >= -56.6 		&& current.xPos <= -70 			&& current.yPos <= 197.6 		&& current.zPos <= -54) 		
					return true;
				break;
			//Drawbridge Tower
			case 14:
				if(current.xPos >= -267 		&& current.yPos >= 232 				&& current.zPos >= -35.6 		&& current.xPos <= -262 		&& current.yPos <= 267 			&& current.zPos <= -35.5) 		
					return true;
				break;
			//A Broken Bridge
			case 15:
				if(current.xPos >= -265 		&& current.yPos >= 159 				&& current.zPos >= -13.6 		&& current.xPos <= -257 		&& current.yPos <= 167 			&& current.zPos <= -13.4) 		
					return true;
				break;
			//Life Upgrade 5
			case 16:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//Waterfall
			case 17:
				if(current.xPos >= -242 		&& current.yPos >= 79.5 			&& current.zPos >= -121 		&& current.xPos <= -240.5 		&& current.yPos <= 83 			&& current.zPos <= -118)		
					return true;
				break;
			//An Underground Reservoir
			case 18:
				if(current.xPos >= -121 		&& current.yPos >= -9 				&& current.zPos >= -154.1 		&& current.xPos <= -110 		&& current.yPos <= -7 			&& current.zPos <= -153.9) 		
					return true;
				break;
			//Life Upgrade 6
			case 19:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//Hall of Learning
			case 20:
				if(current.xPos >= 73 			&& current.yPos >= 161 				&& current.zPos >= -24.1 		&& current.xPos <= 79 			&& current.yPos <= 163 			&& current.zPos <= -23.9) 		
					return true;
				break;
			//Life Upgrade 7
			case 21:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//Exit Observatory
			case 22:
				if(current.xPos >= 137 			&& current.yPos >= 164 				&& current.zPos >= -29.5 		&& current.xPos <= 141 			&& current.yPos <= 164.67 		&& current.zPos <= -29.2) 		
					return true;
				break;
			//Exit Hall of Learning Courtyards
			case 23:
				if(current.xPos >= 72 			&& current.yPos >= 90 				&& current.zPos >= -27.1 		&& current.xPos <= 77 			&& current.yPos <= 95.7 		&& current.zPos <= -26.9) 		
					return true;
				break;
			//The Prison
			case 24:
				if(current.xPos >= 190 			&& current.yPos >= -21 				&& current.zPos >= -17.6 		&& current.xPos <= 195 			&& current.yPos <= -19 			&& current.zPos <= -17.3) 		
					return true;
				break;
			//Life Upgrade 8
			case 25:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//Life Upgrade 9
			case 26:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//The Dream
			case 27:
				if(current.xPos >= 99 			&& current.yPos >= -11 				&& current.zPos >= -56 			&& current.xPos <= 101 			&& current.yPos <= -10 			&& current.zPos <= -54) 		
					return true;
				break;
			//The Tomb
			case 28:
				if(current.xPos >= 100.643 		&& current.yPos >= -11.543 			&& current.zPos >= -67.588 		&& current.xPos <= 100.645 		&& current.yPos <= -11.541 		&& current.zPos <= -67.586) 		
					return true;
				break;
			//Life Upgrade 10
			case 29:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//The Tower of Dawn
			case 30:
				if(current.xPos >= 35.5 		&& current.yPos >= -50 				&& current.zPos >= -32 			&& current.xPos <= 35.7 		&& current.yPos <= -39 			&& current.zPos <= -30) 		
					return true;
				break;
			//The Setting Sun
			case 31:
				if(current.xPos >= 60 			&& current.yPos >= -58 				&& current.zPos >= 30 			&& current.xPos <= 61 			&& current.yPos <= -57 			&& current.zPos <= 32) 		
					return true;
				break;
			//Honor and Glory
			case 32:
				if(current.xPos >= 81 			&& current.yPos >= -60.3 			&& current.zPos >= 89 			&& current.xPos <= 82 			&& current.yPos <= -59.7 		&& current.zPos <= 90) 							
					return true;
				break;
			//The Grand Rewind
			case 33:
				if(current.xPos >= 660.376 		&& current.yPos >= 190.980 			&& current.zPos >= 0.432 		&& current.xPos <= 660.378 		&& current.yPos <= 190.983 		&& current.zPos <= 0.434) 			
					return true;
				break;
			//The End
			case 34:
				if(current.xPos >= 658.26 		&& current.yPos >= 210.92 			&& current.zPos >= 9.8 			&& current.xPos <= 661.46 		&& current.yPos <= 213.72 		&& current.zPos <= 12.5)
					return true;
				if(current.vizierHealth == 4)				
					return true;
				break;
			}
			break;
			
		case "All Collectibles (No Major Glitches)":
			switch (timer.CurrentSplitIndex)
			{ 		
			//The Treasure Vaults
			case 0:
				if(current.xPos >= 252 			&& current.yPos >= 130.647 			&& current.zPos >= 22.999 		&& current.xPos <= 258 			&& current.yPos <= 134 			&& current.zPos <= 23.001)
					return true;
				break;
			//The Sands of Time
			case 1:
				if(current.xPos >= -6.177 		&& current.yPos >= 62.905 			&& current.zPos >= 7.604 		&& current.xPos <= -6.175 		&& current.yPos <= 62.907 		&& current.zPos <= 7.606)
					return true;
				break;
			//First Guest Room
			case 2: 
				if(current.xPos >= 30.297 		&& current.yPos >= 42.126 			&& current.zPos >= 12.998 		&& current.xPos <= 30.299 		&& current.yPos <= 42.128 		&& current.zPos <= 13)
					return true;
				break;
			//Life Upgrade 1
			case 3:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//Exit Palace Defense
			case 4: 
				if(current.xPos >= 4.547 		&& current.yPos >= 40.494 			&& current.zPos >= -39.001 		&& current.xPos <= 8.851 		&& current.yPos <= 47.519 		&& current.zPos <= -38.999) 		
					return true;
				break;
			//Life Upgrade 2
			case 5:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//Death of the Sand King
			case 6:
				if(current.xPos >= -6.001 		&& current.yPos >= -18.6 			&& current.zPos >= 1.998 		&& current.xPos <= -5.999 		&& current.yPos <= -18.4 		&& current.zPos <= 2.001) 		
					return true;
				break;
			//Life Upgrade 3
			case 7:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//The Zoo
			case 8:	
				if(current.xPos >= -141.299 	&& current.yPos >= -47.21 			&& current.zPos >= -31.1 		&& current.xPos <= -139.797 	&& current.yPos <= -42.801 		&& current.zPos <= -30.9) 		
					return true;
				break;
			//Atop a Bird Cage
			case 9:
				if(current.xPos >= -211 		&& current.yPos >= -23 				&& current.zPos >= -9 			&& current.xPos <= -208 		&& current.yPos <= -21 			&& current.zPos <= -8.8) 		
					return true;
				break;
			//Cliffs and Waterfall
			case 10:
				if(current.xPos >= -233.6 		&& current.yPos >= 33.7 			&& current.zPos >= -42.6 		&& current.xPos <= -231.4 		&& current.yPos <= 35 			&& current.zPos <= -42.4) 		
					return true;
				break;
			//The Baths
			case 11:
				if(current.xPos >= -215.85 		&& current.yPos >= 54.261 			&& current.zPos >= -43.501 		&& current.xPos <= -214.089 	&& current.yPos <= 58.699 		&& current.zPos <= -43.499) 		
					return true;
				break;
			//Life Upgrade 4
			case 12:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//Daybreak
			case 13:	
				if(current.xPos >= -76 			&& current.yPos >= 192.4 			&& current.zPos >= -56.6 		&& current.xPos <= -70 			&& current.yPos <= 197.6 		&& current.zPos <= -54) 		
					return true;
				break;
			//Drawbridge Tower
			case 14:
				if(current.xPos >= -267 		&& current.yPos >= 232 				&& current.zPos >= -35.6 		&& current.xPos <= -262 		&& current.yPos <= 267 			&& current.zPos <= -35.5) 		
					return true;
				break;
			//A Broken Bridge
			case 15:
				if(current.xPos >= -265 		&& current.yPos >= 159 				&& current.zPos >= -13.6 		&& current.xPos <= -257 		&& current.yPos <= 167 			&& current.zPos <= -13.4) 		
					return true;
				break;
			//Life Upgrade 5
			case 16:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//Waterfall
			case 17:
				if(current.xPos >= -242 		&& current.yPos >= 79.5 			&& current.zPos >= -121 		&& current.xPos <= -240.5 		&& current.yPos <= 83 			&& current.zPos <= -118)		
					return true;
				break;
			//An Underground Reservoir
			case 18:
				if(current.xPos >= -121 		&& current.yPos >= -9 				&& current.zPos >= -154.1 		&& current.xPos <= -110 		&& current.yPos <= -7 			&& current.zPos <= -153.9) 		
					return true;
				break;
			//Life Upgrade 6
			case 19:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//Hall of Learning
			case 20:
				if(current.xPos >= 73 			&& current.yPos >= 161 				&& current.zPos >= -24.1 		&& current.xPos <= 79 			&& current.yPos <= 163 			&& current.zPos <= -23.9) 		
					return true;
				break;
			//Life Upgrade 7
			case 21:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//Exit Observatory
			case 22:
				if(current.xPos >= 137 			&& current.yPos >= 164 				&& current.zPos >= -29.5 		&& current.xPos <= 141 			&& current.yPos <= 164.67 		&& current.zPos <= -29.2) 		
					return true;
				break;
			//Exit Hall of Learning Courtyards
			case 23:
				if(current.xPos >= 72 			&& current.yPos >= 90 				&& current.zPos >= -27.1 		&& current.xPos <= 77 			&& current.yPos <= 95.7 		&& current.zPos <= -26.9) 		
					return true;
				break;
			//The Prison
			case 24:
				if(current.xPos >= 190 			&& current.yPos >= -21 				&& current.zPos >= -17.6 		&& current.xPos <= 195 			&& current.yPos <= -19 			&& current.zPos <= -17.3) 		
					return true;
				break;
			//Life Upgrade 8
			case 25:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//Life Upgrade 9
			case 26:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//The Dream
			case 27:
				if(current.xPos >= 99 			&& current.yPos >= -11 				&& current.zPos >= -56 			&& current.xPos <= 101 			&& current.yPos <= -10 			&& current.zPos <= -54) 		
					return true;
				break;
			//The Tomb
			case 28:
				if(current.xPos >= 100.643 		&& current.yPos >= -11.543 			&& current.zPos >= -67.588 		&& current.xPos <= 100.645 		&& current.yPos <= -11.541 		&& current.zPos <= -67.586) 		
					return true;
				break;
			//Life Upgrade 10
			case 29:	
				if(current.xPos >= -477.38 		&& current.yPos >= -297.69 			&& current.zPos >= -0.48 		&& current.xPos <= -477.36 			&& current.yPos <= -297.67 		&& current.zPos <= -0.46){
					vars.newFountain = true;
				}
				if(current.xPos >=-492.608 		&& current.yPos >= -248.833 		&& current.zPos >= 0.219 		&& current.xPos <= -492.606 		&& current.yPos <= -248.831 	&& current.zPos <= 0.221 && vars.newFountain){  
					vars.newFountain = false;
					return true;
				}
				break;
			//The Tower of Dawn
			case 30:
				if(current.xPos >= 35.5 		&& current.yPos >= -50 				&& current.zPos >= -32 			&& current.xPos <= 35.7 		&& current.yPos <= -39 			&& current.zPos <= -30) 		
					return true;
				break;
			//The Setting Sun
			case 31:
				if(current.xPos >= 60 			&& current.yPos >= -58 				&& current.zPos >= 30 			&& current.xPos <= 61 			&& current.yPos <= -57 			&& current.zPos <= 32) 		
					return true;
				break;
			//Honor and Glory
			case 32:
				if(current.xPos >= 81 			&& current.yPos >= -60.3 			&& current.zPos >= 89 			&& current.xPos <= 82 			&& current.yPos <= -59.7 		&& current.zPos <= 90) 							
					return true;
				break;
			//The Grand Rewind
			case 33:
				if(current.xPos >= 660.376 		&& current.yPos >= 190.980 			&& current.zPos >= 0.432 		&& current.xPos <= 660.378 		&& current.yPos <= 190.983 		&& current.zPos <= 0.434) 			
					return true;
				break;
			//The End
			case 34:
				if(current.xPos >= 658.26 		&& current.yPos >= 210.92 			&& current.zPos >= 12.5 		&& current.xPos <= 661.46 		&& current.yPos <= 213.72)
					vars.aboveCredits = true;
				if(current.xPos >= 658.26 		&& current.yPos >= 210.92 			&& current.zPos >= 9.8 			&& current.xPos <= 661.46 		&& current.yPos <= 213.72 		&& current.zPos <= 12.5 && vars.aboveCredits)
					return true;
				if(current.vizierHealth == 4)				
					return true;
				break;
			}
			break;
	}	
}