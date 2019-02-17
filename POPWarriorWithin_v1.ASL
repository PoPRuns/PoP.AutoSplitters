state("POP2"){
//Some memory value that reliably changes when you gain control after a load.
	int startValue : 0x0096602C, 0x8, 0x28, 0xA8, 0x3E0;
	
//Story counter/gate/value
	int storyValue : 0x523578;	

//A value that changes reliably depending on which weapon you pick up
	int secondaryWeapon : 0x0053F8F0, 0x4, 0x164, 0xC, 0x364;
	
//The address used for all bosses' health
	int bossHealth : 0x0090C418, 0x18, 0x4, 0x48, 0x198;

//The Prince's coords
	float xPos : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x30;	
	float yPos : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x34;
	float zPos : 0x90C414, 0x18, 0x0, 0x4, 0x20, 0x38;	
}

startup{
}

start{
	//Detecting if the game has started on the boat.
	if(old.startValue == 1 && current.startValue == 2){
		if(current.xPos == -997.6756592)
			return true;
	}
}

reset{
	//Detecting if the game has started on the boat.
	if(old.startValue == 1 && current.startValue == 2){
		if(current.xPos == -997.6756592)
			return true;
	}
}

split{
	
	switch(timer.Run.GetExtendedCategoryName())
	{
		case "Any% (Normal)":
			switch (timer.CurrentSplitIndex)
			{
			//The Boat
			case 0:
				if(current.xPos >= -1003 		&& current.yPos >= -1028 		&& current.zPos >= 14 			&& current.xPos <= -995 		&& current.yPos <= -1016 		&& current.zPos <= 15 		&& current.storyValue == 0 && current.bossHealth == 0)
					return true;
				break;
			//The Raven Man
			case 1:
				if(current.xPos >= -5.359 		&& current.yPos >= -161.539 	&& current.zPos >= 66.5 		&& current.xPos <= -4.913 		&& current.yPos <= -161.500 	&& current.zPos <= 67.5 	&& current.storyValue == 2)
					return true;
				break;
			//The Time Portal
			case 2:
				if(current.xPos >= 122.8 		&& current.yPos >= -156.1 		&& current.zPos >= 368.5 		&& current.xPos <= 122.9 		&& current.yPos <= -156 		&& current.zPos <= 369.5 	&& current.storyValue == 2)			
					return true;
				break;
			//Mask of the Wraith (59)
			case 3:
				if(current.storyValue == 59)
					return true;
				break;
			//The Scorpion Sword
			case 4:
				if(current.xPos >= -170.1 		&& current.yPos >= -127.3 		&& current.zPos >= 335.5 		&& current.xPos <= -170 		&& current.yPos <= -127.2 		&& current.zPos <= 336.5 	&& current.storyValue == 59)
					return true;
				break;
			//The Light Sword
			case 5:
				if(current.secondaryWeapon == 50 && current.storyValue == 61)
					return true;
				break;
			//Back to the Future
			case 6:
				if(current.xPos >= -52.7 		&& current.yPos >= 137.2 		&& current.zPos >= 418 		&& current.xPos <= -52.6 		&& current.yPos <= 137.3 		&& current.zPos <= 419 		&& current.storyValue == 66)
					return true;
				break;
			//The End
			case 7:
				if(current.xPos >= -35 			&& current.yPos >= 170 			&& current.zPos >= 128.9 		&& current.xPos <= -5 			&& current.yPos <= 205 			&& current.zPos <= 129.1 	&& current.storyValue == 67 && current.bossHealth == 0)
					return true;
				break;
		}
		break;
		
		case "Any% (Zipless)":
			switch (timer.CurrentSplitIndex)
			{
			//The Boat
			case 0:
				if(current.xPos >= -1003 		&& current.yPos >= -1028 		&& current.zPos >= 14 			&& current.xPos <= -995 		&& current.yPos <= -1016 		&& current.zPos <= 15 		&& current.storyValue == 0 && current.bossHealth == 0)
					return true;
				break;
			//The Raven Man
			case 1:
				if(current.xPos >= -5.359 		&& current.yPos >= -161.539 	&& current.zPos >= 66.5 		&& current.xPos <= -4.913 		&& current.yPos <= -161.500 	&& current.zPos <= 67.5 	&& current.storyValue == 2)
					return true;
				break;
			//The Time Portal
			case 2:
				if(current.xPos >= 122.8 		&& current.yPos >= -156.1 		&& current.zPos >= 368.5 		&& current.xPos <= 122.9 		&& current.yPos <= -156 		&& current.zPos <= 369.5 	&& current.storyValue == 2)			
					return true;
				break;
			//Mask of the Wraith (59)
			case 3:
				if(current.storyValue == 59)
					return true;
				break;
			//The Scorpion Sword
			case 4:
				if(current.xPos >= -170.1 		&& current.yPos >= -127.3 		&& current.zPos >= 335.5 		&& current.xPos <= -170 		&& current.yPos <= -127.2 		&& current.zPos <= 336.5 	&& current.storyValue == 59)
					return true;
				break;
			//The Light Sword
			case 5:
				if(current.secondaryWeapon == 50 && current.storyValue == 61)
					return true;
				break;
			//Back to the Future
			case 6:
				if(current.xPos >= -52.7 		&& current.yPos >= 137.2 		&& current.zPos >= 418 		&& current.xPos <= -52.6 		&& current.yPos <= 137.3 		&& current.zPos <= 419 		&& current.storyValue == 66)
					return true;
				break;
			//The End
			case 7:
				if(current.xPos >= -35 			&& current.yPos >= 170 			&& current.zPos >= 128.9 		&& current.xPos <= -5 			&& current.yPos <= 205 			&& current.zPos <= 129.1 	&& current.storyValue == 67 && current.bossHealth == 0)
					return true;
				break;
		}
		break;
		
		case "Any% (No Major Glitches)":
			switch (timer.CurrentSplitIndex)
			{
			//The Boat
			case 0:
				if(current.xPos >= -1003 		&& current.yPos >=  -1028 		&& current.zPos >=  14 			&& current.xPos <=  -995 		&& current.yPos <=  -1016 		&& current.zPos <=  15			&& current.storyValue == 0		&& current.bossHealth == 0)
					return true;
				break;
			//The Spider Sword
			case 1:
				if(current.xPos >= -46.3 		&& current.yPos >=  -139.7 		&& current.zPos >=  67 			&& current.xPos <=  -46 		&& current.yPos <=  -138 		&& current.zPos <=  68			&& current.storyValue == 2)
					return true;
				break;
			//Chasing Shadee
			case 2:
				if(current.xPos >= 43.3 		&& current.yPos >=  -75.7 		&& current.zPos >=  370 		&& current.xPos <=  43.4 		&& current.yPos <=  -75.6 		&& current.zPos <=  370.1		&& current.storyValue == 7)
					return true;
				break;
			//A Damsel in Distress
			case 3:
				if(current.xPos >= 115 			&& current.yPos >=  -114 		&& current.zPos >=  357 		&& current.xPos <=  132 		&& current.yPos <=  -80 		&& current.zPos <=  361			&& current.storyValue == 8		&& current.bossHealth == 0)
					return true;
				break;
			//The Dahaka
			case 4:
				if(current.xPos >= 40.1 		&& current.yPos >=  -96.1 		&& current.zPos >=  86 			&& current.xPos <=  42.4 		&& current.yPos <=  -95.9 		&& current.zPos <=  86.1		&& current.storyValue == 9)
					return true;
				break;
			//The Serpent Sword
			case 5:
				if(current.xPos >= -96.5 		&& current.yPos >=  41.3 		&& current.zPos >=  407.4 		&& current.xPos <=  -96.4 		&& current.yPos <=  41.4 		&& current.zPos <=  407.5		&& current.storyValue == 13)
					return true;
				break;
			//The Garden Hall
			case 6:
				if(current.xPos >= 66.9 		&& current.yPos >=  11.4 		&& current.zPos >=  400 		&& current.xPos <=  67.1 		&& current.yPos <=  11.6 		&& current.zPos <=  400.2		&& current.storyValue == 22)
					return true;
				break;
			//The Waterworks Restored
			case 7:
				if(current.xPos >= 23 			&& current.yPos >=  41 			&& current.zPos >=  441 		&& current.xPos <=  29 			&& current.yPos <=  43 			&& current.zPos <=  450			&& current.storyValue == 22)
					return true;
				break;
			//The Lion Sword
			case 8:
				if(current.xPos >= -44.7 		&& current.yPos >=  -27.1 		&& current.zPos >=  389 		&& current.xPos <=  -44.6 		&& current.yPos <=  -27 		&& current.zPos <=  389.1		&& current.storyValue == 21)
					return true;
				break;
			//The Mechanical Tower
			case 9:
				if(current.xPos >= -167 		&& current.yPos >=  -47.5 		&& current.zPos >=  409.6363 	&& current.xPos <=  -162 		&& current.yPos <=  -46 		&& current.zPos <=  412			&& current.storyValue == 15)
					return true;
				break;
			//Breath of Fate
			case 10:
				if(current.xPos >= -210.018 	&& current.yPos >=  164.259 	&& current.zPos >=  440.9 		&& current.xPos <=  -210.016 	&& current.yPos <=  164.261 	&& current.zPos <=  441.1		&& current.storyValue == 16)
					return true;
				break;
			//Activation Room in Ruin
			case 11:
				if(current.xPos >= -206 		&& current.yPos >=  59.8 		&& current.zPos >=  162.6 		&& current.xPos <=  -205.8 		&& current.yPos <=  67.4 		&& current.zPos <=  163.1		&& current.storyValue == 18)
					return true;
				break;
			//Activation Room Restored
			case 12:
				if(current.xPos >= -192.5 		&& current.yPos >=  109 		&& current.zPos >=  471.9 		&& current.xPos <=  -189.5 		&& current.yPos <=  111 		&& current.zPos <=  472.1		&& current.storyValue == 19)
					return true;
				break;
			//The Death of a Sand Wraith
			case 13:
				if(current.xPos >= -50 			&& current.yPos >=  -13 		&& current.zPos >=  388.9 		&& current.xPos <=  -39 		&& current.yPos <=  -5 			&& current.zPos <=  389.8		&& current.storyValue == 33)
					return true;
				break;
			//Death of the Empress
			case 14:
				if(current.xPos >= -74 			&& current.yPos >=  53.5 		&& current.zPos >=  414 		&& current.xPos <=  -31 		&& current.yPos <=  104 		&& current.zPos <=  422			&& current.storyValue == 38		&& current.bossHealth == 0)
					return true;
				break;
			//Exit the Tomb
			case 15:
				if(current.xPos >= -100 		&& current.yPos >=  -190 		&& current.zPos >=  33 			&& current.xPos <=  -97.5 		&& current.yPos <=  -187 		&& current.zPos <=  33.2		&& current.storyValue == 39)
					return true;
				break;
			//The Scorpion Sword
			case 16:
				if(current.xPos >= -170.1 		&& current.yPos >=  -127.3 		&& current.zPos >=  335.5 		&& current.xPos <=  -170 		&& current.yPos <=  -127.2 		&& current.zPos <=  336.5		&& current.storyValue == 41)
					return true;
				break;
			//The Library
			case 17:
				if(current.xPos >= -112 		&& current.yPos >=  -144 		&& current.zPos >=  384.9 		&& current.xPos <=  -111 		&& current.yPos <=  -137 		&& current.zPos <=  389			&& current.storyValue == 42)
					return true;
				break;
			//The Hourglass Revisited
			case 18:
				if(current.xPos >= -108.3 		&& current.yPos >=  40 			&& current.zPos >=  407.3 		&& current.xPos <=  -106 		&& current.yPos <=  45 			&& current.zPos <=  407.5		&& current.storyValue == 45)
					return true;
				break;
			//The Mask of the Wraith
			case 19:
				if(current.xPos >= -20.5 		&& current.yPos >=  236.8 		&& current.zPos >=  133 		&& current.xPos <=  -20.4 		&& current.yPos <=  267 		&& current.zPos <=  133.1		&& current.storyValue == 46)
					return true;
				break;
			//The Sand Griffin
			case 20:
				if(current.xPos >= -23 			&& current.yPos >=  163 		&& current.zPos >=  429 		&& current.xPos <=  -15 		&& current.yPos <=  166.5 		&& current.zPos <=  431			&& current.storyValue == 48)
					return true;
				break;
			//Mirrored Fates
			case 21:
				if(current.xPos >= 136.7 		&& current.yPos >=  -110.6 		&& current.zPos >=  377.9 		&& current.xPos <=  136.9 		&& current.yPos <=  -110.4 		&& current.zPos <=  378			&& current.storyValue == 55)
					return true;
				break;
			//A Favor Unknown
			case 22:
				if(current.xPos >= 41.1 		&& current.yPos >=  -180.1 		&& current.zPos >=  368.9 		&& current.xPos <=  41.2 		&& current.yPos <=  -180 		&& current.zPos <=  369.1		&& current.storyValue == 57)
					return true;
				break;
			//The Library Revisited
			case 23:
				if(current.xPos >= -112 		&& current.yPos >=  -144 		&& current.zPos >=  384.9 		&& current.xPos <=  -111 		&& current.yPos <=  -137 		&& current.zPos <=  389			&& current.storyValue == 60)
					return true;
				break;
			//The Light Sword
			case 24:
				if(current.secondaryWeapon == 50 && current.storyValue == 61)
					return true;
				break;
			//The Death of a Prince
			case 25:
				if(current.xPos >= -67 			&& current.yPos >=  -23.3 		&& current.zPos >=  399.9 		&& current.xPos <=  -65.1 		&& current.yPos <=  -23.1 		&& current.zPos <=  400			&& current.storyValue == 64)
					return true;
				break;
			//The End
			case 26:
				if(current.xPos >= -35 			&& current.yPos >=  170 		&& current.zPos >=  128.9 		&& current.xPos <=  -5 			&& current.yPos <=  205 		&& current.zPos <=  129.1		&& current.storyValue == 67		&& current.bossHealth == 0)
					return true;
				break;
		}
		break;
		
		case "True Ending (Normal)":
			switch (timer.CurrentSplitIndex)
			{
			//The Boat
			case 0:
				if(current.xPos >= -1003 		&& current.yPos >= -1028 		&& current.zPos >= 14 			&& current.xPos <= -995 		&& current.yPos <= -1016 		&& current.zPos <= 15 		&& current.storyValue == 0 && current.bossHealth == 0)
					return true;
				break;
			//The Raven Man
			case 1:
				if(current.xPos >= -5.359 		&& current.yPos >= -161.539 	&& current.zPos >= 66.5 		&& current.xPos <= -4.913 		&& current.yPos <= -161.500 	&& current.zPos <= 67.5 	&& current.storyValue == 2)
					return true;
				break;
			//Life Upgrade 1
			case 2:
				if(current.xPos >= 52			&& current.yPos >= -188.7		&& current.zPos >= 381.9		&& current.xPos <= 52.8			&& current.yPos <= -188.6		&& current.zPos <= 382.1		&& current.storyValue == 2)
					return true;
				break;
			//Life Upgrade 2
			case 3:
				if(current.xPos >= -112.1		&& current.yPos >= -66.1		&& current.zPos >= 360.9		&& current.xPos <= -112			&& current.yPos <= -65.2		&& current.zPos <= 361			&& current.storyValue == 59)
					return true;
				break;
			//Life Upgrade 3
			case 4:
				if(current.xPos >= -74.8		&& current.yPos >= -102.8		&& current.zPos >= 378.9		&& current.xPos <= -74.2		&& current.yPos <= -102.7		&& current.zPos <= 379			&& current.storyValue == 60)
					return true;
				break;
			//Life Upgrade 4
			case 5:
				if(current.xPos >= -161.2		&& current.yPos >= 170.3		&& current.zPos >= 471.9		&& current.xPos <= -161			&& current.yPos <= 171			&& current.zPos <= 472.1		&& current.storyValue == 63)
					return true;
				break;
			//Life Upgrade 5
			case 6:
				if(current.xPos >= 138.8		&& current.yPos >= 115.3		&& current.zPos >= 382.5		&& current.xPos <= 139			&& current.yPos <= 116.7		&& current.zPos <= 382.6		&& current.storyValue == 64)
					return true;
				break;
			//Life Upgrade 6
			case 7:
				if(current.xPos >= 76.1			&& current.yPos >= 64.1			&& current.zPos >= 461.4		&& current.xPos <= 76.2			&& current.yPos <= 64.9			&& current.zPos <= 461.6		&& current.storyValue == 64)
					return true;
				break;
			//Life Upgrade 7
			case 8:
				if(current.xPos >= 190.2		&& current.yPos >= -131.9		&& current.zPos >= 353.9		&& current.xPos <= 190.4		&& current.yPos <= -131.8		&& current.zPos <= 354.1		&& current.storyValue == 64)
					return true;
				break;
			//Life Upgrade 8
			case 9:
				if(current.xPos >= 162.2		&& current.yPos >= -37.5		&& current.zPos >= 392.9		&& current.xPos <= 162.7		&& current.yPos <= -37.3		&& current.zPos <= 393.1		&& current.storyValue == 64)
					return true;
				break;
			//Life Upgrade 9
			case 10:
				if(current.xPos >= -114.7		&& current.yPos >= -47.2		&& current.zPos >= 368.9		&& current.xPos <= -114.1		&& current.yPos <= -47			&& current.zPos <= 369.1		&& current.storyValue == 64)
					return true;
				break;
			//The Water Sword
			case 11:
				if(current.xPos >= -96.643		&& current.yPos >= 43.059		&& current.zPos >= 407.4		&& current.xPos <= -96.641		&& current.yPos <= 43.061		&& current.zPos <= 407.5		&& current.storyValue == 66)
					return true;
				break;
			//The End
			case 12:
				if(current.xPos >= -18.959 		&& current.yPos >= 203.667 		&& current.zPos >= 129 			&& current.xPos <= -18.956 		&& current.yPos <= 203.755 		&& current.zPos <=129.2 		&& current.storyValue == 68)
					return true;
				break;
		}
		break;
		
		case "True Ending (Zipless)":
			switch (timer.CurrentSplitIndex)
			{
			//The Boat
			case 0:
				if(current.xPos >= -1003 		&& current.yPos >= -1028 		&& current.zPos >= 14 			&& current.xPos <= -995 		&& current.yPos <= -1016 		&& current.zPos <= 15 			&& current.storyValue == 0 && current.bossHealth == 0)
					return true;
				break;
			//The Raven Man
			case 1:
				if(current.xPos >= -5.359 		&& current.yPos >= -161.539 	&& current.zPos >= 66.5 		&& current.xPos <= -4.913 		&& current.yPos <= -161.500 	&& current.zPos <= 67.5 		&& current.storyValue == 2)
					return true;
				break;
			//Life Upgrade 1
			case 2:
				if(current.xPos >= -114.7		&& current.yPos >= -47.2		&& current.zPos >= 368.9		&& current.xPos <= -114.1		&& current.yPos <= -47			&& current.zPos <= 369.1		&& current.storyValue == 36)
					return true;
				break;
			//Life Upgrade 2
			case 3:
				if(current.xPos >= 76.1			&& current.yPos >= 64.1			&& current.zPos >= 461.4		&& current.xPos <= 76.2			&& current.yPos <= 64.9			&& current.zPos <= 461.6		&& current.storyValue == 36)
					return true;
				break;
			//Life Upgrade 3
			case 4:
				if(current.xPos >= 138.8		&& current.yPos >= 115.3		&& current.zPos >= 382.5		&& current.xPos <= 139			&& current.yPos <= 116.7		&& current.zPos <= 382.6		&& current.storyValue == 36)
					return true;
				break;
			//Life Upgrade 4
			case 5:
				if(current.xPos >= 52			&& current.yPos >= -188.7		&& current.zPos >= 381.9		&& current.xPos <= 52.8			&& current.yPos <= -188.6		&& current.zPos <= 382.1		&& current.storyValue == 36)
					return true;
				break;
			//Mask of the Wraith (59)
			case 6:
				if(current.storyValue == 59)
					return true;
				break;
			//Life Upgrade 5
			case 7:
				if(current.xPos >= -112.1		&& current.yPos >= -66.1		&& current.zPos >= 360.9		&& current.xPos <= -112			&& current.yPos <= -65.2		&& current.zPos <= 361			&& current.storyValue == 59)
					return true;
				break;			
			//Life Upgrade 6
			case 8:
				if(current.xPos >= -74.8		&& current.yPos >= -102.8		&& current.zPos >= 378.9		&& current.xPos <= -74.2		&& current.yPos <= -102.7		&& current.zPos <= 379			&& current.storyValue == 60)
					return true;
				break;
			//The Mechanical Tower
			case 9:
				if(current.xPos >= -208		&& current.yPos >= -35.5		&& current.zPos >= 419.9		&& current.xPos <= -205		&& current.yPos <= -32.5		&& current.zPos <= 423			&& current.storyValue == 63)
					return true;
				break;					
			//Life Upgrade 7
			case 10:
				if(current.xPos >= -161.2		&& current.yPos >= 170.3		&& current.zPos >= 471.9		&& current.xPos <= -161			&& current.yPos <= 171			&& current.zPos <= 472.1		&& current.storyValue == 63)
					return true;
				break;
			//Life Upgrade 8
			case 11:
				if(current.xPos >= 162.2		&& current.yPos >= -37.5		&& current.zPos >= 392.9		&& current.xPos <= 162.7		&& current.yPos <= -37.3		&& current.zPos <= 393.1		&& current.storyValue == 64)
					return true;
				break;
			//Life Upgrade 9
			case 12:
				if(current.xPos >= 190.2		&& current.yPos >= -131.9		&& current.zPos >= 353.9		&& current.xPos <= 190.4		&& current.yPos <= -131.8		&& current.zPos <= 354.1		&& current.storyValue == 64)
					return true;
				break;
			//The Water Sword
			case 13:
				if(current.xPos >= -96.643		&& current.yPos >= 43.059		&& current.zPos >= 407.4		&& current.xPos <= -96.641		&& current.yPos <= 43.061		&& current.zPos <= 407.5		&& current.storyValue == 66)
					return true;
				break;
			//The End
			case 14:
				if(current.xPos >= -18.959 		&& current.yPos >= 203.667 		&& current.zPos >= 129 			&& current.xPos <= -18.956 		&& current.yPos <= 203.755 		&& current.zPos <=129.2 		&& current.storyValue == 68)
					return true;
				break;
		}
		break;
		
		case "True Ending (No Major Glitches)":
			switch (timer.CurrentSplitIndex)
			{
			//The Boat
			case 0:
				if(current.xPos >= -1003 		&& current.yPos >=  -1028 		&& current.zPos >=  14 			&& current.xPos <=  -995 		&& current.yPos <=  -1016 		&& current.zPos <=  15			&& current.storyValue == 0		&& current.bossHealth == 0)
					return true;
				break;
			//The Spider Sword
			case 1:
				if(current.xPos >= -46.3 		&& current.yPos >=  -139.7 		&& current.zPos >=  67 			&& current.xPos <=  -46 		&& current.yPos <=  -138 		&& current.zPos <=  68			&& current.storyValue == 2)
					return true;
				break;
			//Life Upgrade 1
			case 2:
				if(current.xPos >= 162.2		&& current.yPos >= -37.5		&& current.zPos >= 392.9		&& current.xPos <= 162.7		&& current.yPos <= -37.3		&& current.zPos <= 393.1		&& current.storyValue == 7)
					return true;
				break;
			//A Damsel in Distress
			case 3:
				if(current.xPos >= 115 			&& current.yPos >=  -114 		&& current.zPos >=  357 		&& current.xPos <=  132 		&& current.yPos <=  -80 		&& current.zPos <=  361			&& current.storyValue == 8		&& current.bossHealth == 0)
					return true;
				break;
			//Life Upgrade 2
			case 4:
				if(current.xPos >= 190.2		&& current.yPos >= -131.9		&& current.zPos >= 353.9		&& current.xPos <= 190.4		&& current.yPos <= -131.8		&& current.zPos <= 354.1		&& current.storyValue == 8)
					return true;
				break;
			//The Dahaka
			case 5:
				if(current.xPos >= 40.1 		&& current.yPos >=  -96.1 		&& current.zPos >=  86 			&& current.xPos <=  42.4 		&& current.yPos <=  -95.9 		&& current.zPos <=  86.1		&& current.storyValue == 9)
					return true;
				break;
			//Life Upgrade 3
			case 6:
				if(current.xPos >= 52			&& current.yPos >= -188.7		&& current.zPos >= 381.9		&& current.xPos <= 52.8			&& current.yPos <= -188.6		&& current.zPos <= 382.1		&& current.storyValue == 11)
					return true;
				break;
			//The Serpent Sword
			case 7:
				if(current.xPos >= -96.5 		&& current.yPos >=  41.3 		&& current.zPos >=  407.4 		&& current.xPos <=  -96.4 		&& current.yPos <=  41.4 		&& current.zPos <=  407.5		&& current.storyValue == 13)
					return true;
				break;
			//The Waterworks Restored
			case 8:
				if(current.xPos >= 23 			&& current.yPos >=  41 			&& current.zPos >=  441 		&& current.xPos <=  29 			&& current.yPos <=  43 			&& current.zPos <=  450			&& current.storyValue == 22)
					return true;
				break;
			//Life Upgrade 4
			case 9:
				if(current.xPos >= 76.1			&& current.yPos >= 64.1			&& current.zPos >= 461.4		&& current.xPos <= 76.2			&& current.yPos <= 64.9			&& current.zPos <= 461.6		&& current.storyValue == 22)
					return true;
				break;
			//Life Upgrade 5
			case 10:
				if(current.xPos >= 138.8		&& current.yPos >= 115.3		&& current.zPos >= 382.5		&& current.xPos <= 139			&& current.yPos <= 116.7		&& current.zPos <= 382.6		&& current.storyValue == 32)
					return true;
				break;
			//Life Upgrade 6
			case 11:
				if(current.xPos >= -114.7		&& current.yPos >= -47.2		&& current.zPos >= 368.9		&& current.xPos <= -114.1		&& current.yPos <= -47			&& current.zPos <= 369.1		&& current.storyValue == 21)
					return true;
				break;
			//The Mechanical Tower
			case 12:
				if(current.xPos >= -167 		&& current.yPos >=  -47.5 		&& current.zPos >=  409.6363 	&& current.xPos <=  -162 		&& current.yPos <=  -46 		&& current.zPos <=  412			&& current.storyValue == 15)
					return true;
				break;
			//Breath of Fate
			case 13:
				if(current.xPos >= -210.018 	&& current.yPos >=  164.259 	&& current.zPos >=  440.9 		&& current.xPos <=  -210.016 	&& current.yPos <=  164.261 	&& current.zPos <=  441.1		&& current.storyValue == 16)
					return true;
				break;
			//Activation Room in Ruin
			case 14:
				if(current.xPos >= -206 		&& current.yPos >=  59.8 		&& current.zPos >=  162.6 		&& current.xPos <=  -205.8 		&& current.yPos <=  67.4 		&& current.zPos <=  163.1		&& current.storyValue == 18)
					return true;
				break;
			//Life Upgrade 7
			case 15:
				if(current.xPos >= -161.2		&& current.yPos >= 170.3		&& current.zPos >= 471.9		&& current.xPos <= -161			&& current.yPos <= 171			&& current.zPos <= 472.1		&& current.storyValue == 19)
					return true;
				break;
			//The Death of a Sand Wraith
			case 16:
				if(current.xPos >= -50 			&& current.yPos >=  -13 		&& current.zPos >=  388.9 		&& current.xPos <=  -39 		&& current.yPos <=  -5 			&& current.zPos <=  389.8		&& current.storyValue == 33)
					return true;
				break;
			//Death of the Empress
			case 17:
				if(current.xPos >= -74 			&& current.yPos >=  53.5 		&& current.zPos >=  414 		&& current.xPos <=  -31 		&& current.yPos <=  104 		&& current.zPos <=  422			&& current.storyValue == 38		&& current.bossHealth == 0)
					return true;
				break;
			//Exit the Tomb
			case 18:
				if(current.xPos >= -100 		&& current.yPos >=  -190 		&& current.zPos >=  33 			&& current.xPos <=  -97.5 		&& current.yPos <=  -187 		&& current.zPos <=  33.2		&& current.storyValue == 39)
					return true;
				break;
			//The Scorpion Sword
			case 19:
				if(current.xPos >= -170.1 		&& current.yPos >=  -127.3 		&& current.zPos >=  335.5 		&& current.xPos <=  -170 		&& current.yPos <=  -127.2 		&& current.zPos <=  336.5		&& current.storyValue == 41)
					return true;
				break;
			//Life Upgrade 8
			case 20:
				if(current.xPos >= -112.1		&& current.yPos >= -66.1		&& current.zPos >= 360.9		&& current.xPos <= -112			&& current.yPos <= -65.2		&& current.zPos <= 361			&& current.storyValue == 41)
					return true;
				break;
			//Life Upgrade 9
			case 21:
				if(current.xPos >= -74.8		&& current.yPos >= -102.8		&& current.zPos >= 378.9		&& current.xPos <= -74.2		&& current.yPos <= -102.7		&& current.zPos <= 379			&& current.storyValue == 42)
					return true;
				break;
			//The Water Sword
			case 22:
				if(current.xPos >= -96.643		&& current.yPos >= 43.059		&& current.zPos >= 407.4		&& current.xPos <= -96.641		&& current.yPos <= 43.061		&& current.zPos <= 407.5		&& current.storyValue == 45)
					return true;
				break;
			//The Mask of the Wraith
			case 23:
				if(current.xPos >= -20.5 		&& current.yPos >=  236.8 		&& current.zPos >=  133 		&& current.xPos <=  -20.4 		&& current.yPos <=  267 		&& current.zPos <=  133.1		&& current.storyValue == 46)
					return true;
				break;
			//The Sand Griffin
			case 24:
				if(current.xPos >= -23 			&& current.yPos >=  163 		&& current.zPos >=  429 		&& current.xPos <=  -15 		&& current.yPos <=  166.5 		&& current.zPos <=  431			&& current.storyValue == 48)
					return true;
				break;
			//Mirrored Fates
			case 25:
				if(current.xPos >= 136.7 		&& current.yPos >=  -110.6 		&& current.zPos >=  377.9 		&& current.xPos <=  136.9 		&& current.yPos <=  -110.4 		&& current.zPos <=  378			&& current.storyValue == 55)
					return true;
				break;
			//A Favor Unknown
			case 26:
				if(current.xPos >= 41.1 		&& current.yPos >=  -180.1 		&& current.zPos >=  368.9 		&& current.xPos <=  41.2 		&& current.yPos <=  -180 		&& current.zPos <=  369.1		&& current.storyValue == 57)
					return true;
				break;
			//The Library Revisited
			case 27:
				if(current.xPos >= -112 		&& current.yPos >=  -144 		&& current.zPos >=  384.9 		&& current.xPos <=  -111 		&& current.yPos <=  -137 		&& current.zPos <=  389			&& current.storyValue == 60)
					return true;
				break;
			//The Light Sword
			case 28:
				if(current.secondaryWeapon == 50 && current.storyValue == 61)
					return true;
				break;
			//The Death of a Prince
			case 29:
				if(current.xPos >= -67 			&& current.yPos >=  -23.3 		&& current.zPos >=  399.9 		&& current.xPos <=  -65.1 		&& current.yPos <=  -23.1 		&& current.zPos <=  400			&& current.storyValue == 64)
					return true;
				break;
			//The End
			case 30:
				if(current.xPos >= -18.959 		&& current.yPos >= 203.667 		&& current.zPos >= 129 			&& current.xPos <= -18.956 		&& current.yPos <= 203.755 		&& current.zPos <=129.2 		&& current.storyValue == 68)
					return true;
				break;
		}
		break;
	}	
}