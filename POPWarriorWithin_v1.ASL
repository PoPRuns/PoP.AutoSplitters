//Authors: 		@Samabam#8840
//
//Last Updated:	2018/08/25	(ISO date format)
//
//Instructions:	If you're updating this script it means I'm probably dead. Thank god for that. The concept is fairly simple.
//				By monitoring the Prince's coordinates we're able to create what I call 'virtual hitboxes.' I attempted to
//				place my VHBs in places that no sane person would skip using the current route.
//				IMPORTANT: The 'f's in the split coordinates are necessary and the script won't run without them.
//
//Notes: 		This script is based on the Sands of Time splitter, which was primarily written by @Ynscription#6173. 


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
	
//Camera values
	float cameraX : 0x863A90;
	float cameraY : 0x863A94;
}

startup{
	//Int used to keep track of how many splits should have triggered by a given point.
	int split;

	//A flag that determines if the game process is running
	bool isGameRunning = false;

	//A flag to ensure initialization happens regardless of how the timer was started.
	bool unknownStart = true;
}

init {
		
	//init runs when the game process is found
	vars.isGameRunning = true;

	//Function that determines if the prince is within a bounding box ASSUMES min IS LESS THAN max IN ALL COMPONENTS
	vars.IsInBox = (Func <Vector3f, Vector3f, bool>) ((min, max) => {
		bool x = vars.princePos.X >= min.X && vars.princePos.X <= max.X;
		bool y = vars.princePos.Y >= min.Y && vars.princePos.Y <= max.Y;
		bool z = vars.princePos.Z >= min.Z && vars.princePos.Z <= max.Z;
		return x && y && z;
	});

	//Function that determines the current split number
	vars.GetSplit = (Func<int, int>) ((lastSplit) => {
		int splitResult = -1;
		//Check for each remaining split if the prince is within split distance and has correct story value
		vars.princePos = new Vector3f (current.xPos, current.yPos, current.zPos);
		int fiveAhead = (lastSplit +6) * 2;
		int maxCheck = vars.splitPositions.Length < fiveAhead ? vars.splitPositions.Length : fiveAhead;
		for (int i = (lastSplit +1) *2; i <  maxCheck && splitResult == -1; i += 2) {
			if (vars.IsInBox(vars.splitPositions[i], vars.splitPositions[i +1]) && current.storyValue == vars.splitStoryValues[(i/2)]) {
				splitResult = i/2;
			}
			//Checking splits that aren't location based
			else if(vars.splitPositions[i].X == 0){
				//Splitting on retrieval of the light sword for each relevant category.
				if(current.secondaryWeapon == 50 && current.storyValue == 61 && (i/2) < vars.swordSplit+1){
					splitResult = vars.swordSplit;
				}
				//Splitting on retrieval of the wraith mask for each relevant category.
				if(current.storyValue == 59 && (i/2) < (vars.maskSplit+1) && lastSplit > 1){
					splitResult = vars.maskSplit;
				}
			}
			
		}
		
		//Only splitting if there is no boss or the boss is dead.
		if(current.bossHealth != 0 && current.bossHealth <= 50000){
			splitResult = -1;
		}
		
		return splitResult;
	});

	//Function that skips a split
	vars.SkipSplit = (Func<int>)(() => {
		timer.CurrentSplit.SplitTime = default(Time);
        timer.CurrentSplitIndex++;
        timer.Run.HasChanged = true;
		return 0;
	});

	//Function to select splits based on category
	vars.SetSplitsByCategory = (Func<int>)(() => {
		//Get the category and subcategory names
		string cat = timer.Run.CategoryName;
		string subCat = timer.Run.GetExtendedCategoryName();
		if (subCat == string.Empty || subCat == null) {
			return -1;
		}
		int parenthesisStart = subCat.IndexOf('(') + 1;
		subCat = subCat.Substring(parenthesisStart, subCat.IndexOf(')') - parenthesisStart);

		//Return a code based on category
		int result = -1;
		if (cat == "Any%") {
			result = 0;
		}
		else if (cat == "True Ending") {
			result = 3;
		}
		else {
			return -1;
		}

		if (subCat == "Normal") {
			result += 0;
		}
		else if (subCat == "Zipless") {
			result += 1;
		}
		else if (subCat == "No Major Glitches") {
			result += 2;
		}
		else {
			return -1;
		}
		return result;
	});

}

exit {
	//Exit runs when the game process exits
	vars.isGameRunning = false;
}

start{
	//============= Any% Normal (Zipful) splits ==============
	//An array to store the positions for each split 
	Vector3f [] spAnyNormal = {
	new Vector3f (-998f, -977f, 409f), new Vector3f (-997f, -975f, 410f), 						//0 Starting Position
	new Vector3f (-1003f, -1028f, 14f), new Vector3f (-995f, -1016f, 15f), 						//1 The Boat
	new Vector3f (-5.359f, -161.539f, 66.5f), new Vector3f (-4.913f, -161.500f, 67.5f), 		//2 The Raven Man
	new Vector3f (122.8f, -156.1f, 368.5f), new Vector3f (122.9f, -156f, 369.5f), 				//3 The Time Portal
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//4 Mask of the Wraith
	new Vector3f (-170.1f, -127.3f, 335.5f), new Vector3f (-170f, -127.2f, 336.5f), 			//5 Scorpion Sword
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//6 Light Sword
	new Vector3f (-52.7f, 137.2f, 418f), new Vector3f (-52.6f, 137.3f, 419f), 					//7 Back to the Future
	new Vector3f (-35f, 170f, 128.9f), new Vector3f (-5f, 205f, 129.1f), 						//8 The End
	};

	//============= Any% Zipless splits ==============
	//An array to store the positions for each split 
	Vector3f [] spAnyZipless = {
	new Vector3f (-998f, -977f, 409f), new Vector3f (-997f, -975f, 410f), 						//0 Starting Position
	new Vector3f (-1003f, -1028f, 14f), new Vector3f (-995f, -1016f, 15f), 						//1 The Boat
	new Vector3f (-5.359f, -161.539f, 66.5f), new Vector3f (-4.913f, -161.500f, 67.5f), 		//2 The Raven Man
	new Vector3f (122.8f, -156.1f, 368.5f), new Vector3f (122.9f, -156f, 369.5f), 				//3 The Time Portal
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//4 Mask of the Wraith
	new Vector3f (-170.1f, -127.3f, 335.5f), new Vector3f (-170f, -127.2f, 336.5f), 			//5 Scorpion Sword
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//6 Light Sword
	new Vector3f (-52.7f, 137.2f, 418f), new Vector3f (-52.6f, 137.3f, 419f), 					//7 Back to the Future
	new Vector3f (-35f, 170f, 128.9f), new Vector3f (-5f, 205f, 129.1f), 						//8 The End
	};
				
	//============= Any% NMG splits ==============
	//An array to store the positions for each split 
	Vector3f [] spAnyNMG = {
	new Vector3f (-998f, -977f, 409f), new Vector3f (-997f, -975f, 410f), 						//0 Starting Position 0
	new Vector3f (-1003f, -1028f, 14f), new Vector3f (-995f, -1016f, 15f), 						//1 The Boat 0
	new Vector3f (-46.3f, -138.8f, 67f), new Vector3f (-46f, -138f, 68f),		 				//2 The Spider Sword 2
	new Vector3f (43.3f, -75.7f, 370f), new Vector3f (43.4f, -75.6f, 370.1f), 					//3 Chasing Shadee 7
	new Vector3f (115f, -114f, 357f), new Vector3f (132f, -80f, 361f), 							//4 A Damsel in Distress 8
	new Vector3f (40.1f, -96.1f, 86f), new Vector3f (41.5f, -95.9f, 86.1f), 					//5 The Dahaka 9
	new Vector3f (-96.5f, 41.3f, 407.4f), new Vector3f (-96.4f, 41.4f, 407.5f), 				//6 The Serpent Sword 13
	new Vector3f (66.9f, 11.4f, 400f), new Vector3f (67.1f, 11.6f, 400.2f), 					//7 The Garden Hall 22
	new Vector3f (65f, 60f, 402f), new Vector3f (68f, 62f, 402.1f), 							//8 Exit Water Maiden 25
	new Vector3f (31.1f, 82.1f, 150.9f), new Vector3f (31.3f, 82.3f, 151.1f), 					//9 The Waterworks in Ruin 28
	new Vector3f (23f, 41f, 441f), new Vector3f (29f, 43f, 450f), 								//10 The Waterworks Restored 30
	new Vector3f (-44.7f, -27.1f, 389f), new Vector3f (44.6f, -27f, 389.1f), 					//11 The Lion Sword 21
	new Vector3f (-181.7f, -34f, 411f), new Vector3f (-181.5f, -33.9f, 411.3f), 				//12 The Mechanical Tower 15
	new Vector3f (-210.018f, 164.259f, 440.9f), new Vector3f (-210.016f, 164.261f, 441.1f), 	//13 The Ravages of Time 16
	new Vector3f (-206f, 63f, 163.8f), new Vector3f (-205.8f, 63.2f, 163.9f), 					//14 Activation Room in Ruin 18
	new Vector3f (-192.5f, 109f, 471.9f), new Vector3f (-189.5f, 111f, 472.1f), 				//15 Activation Room Restored 19
	new Vector3f (-45.5f, -27.7f, 388.9f), new Vector3f (-45.3f, 27.5f, 389.1f), 				//16 The Death of a Sand Wraith 33
	new Vector3f (-73f, 52f, 414.9f), new Vector3f (31f, 104f, 416f), 							//17 Death of the Empress 34
	new Vector3f (-100f, -190f, 33f), new Vector3f (-97.5f, -187f, 33.2f), 						//18 Exit the Tomb 39
	new Vector3f (-170.1f, -127.3f, 335.5f), new Vector3f (-170f, -127.2f, 336.5f), 			//19 Scorpion Sword 41
	new Vector3f (-112f, -144f, 384.9f), new Vector3f (-111f, -137f, 389f), 					//20 The Library 42
	new Vector3f (-108.3f, 40f, 407.3f), new Vector3f (-106f, 45f, 407.5f), 					//21 The Hourglass Revisited 45
	new Vector3f (-20.5f, 236.8f, 133f), new Vector3f (-20.4f, 267f, 133.1f), 					//22 The Mask of the Wraith 46
	new Vector3f (-23f, 163f, 429f), new Vector3f (-15f, 166.5f, 431f),							//23 The Sand Griffin 48
	new Vector3f (136.7f, -110.6f, 377.9f), new Vector3f (136.9f, -110.4f, 378f), 				//24 Mirrored Fates 55
	new Vector3f (41.1f, -180.1f, 368.9f), new Vector3f (41.2f, -180f, 369.1f), 				//25 A Favor Unknown 57
	new Vector3f (-112f, -144f, 384.9f), new Vector3f (-111f, -137f, 389f), 					//26 The Library Revisited 60
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//27 The Light Sword 61
	new Vector3f (-66f, -23.3f, 399.9f), new Vector3f (-65.9f, -23.2f, 400f), 					//28 The Death of a Prince 64
	new Vector3f (-35f, 170f, 128.9f), new Vector3f (-5f, 205f, 129.1f), 						//29 The End 67
	};

	//============= TE Normal (Zipful) splits ==============
	//An array to store the positions for each split 
	Vector3f [] spTENormal = {
	new Vector3f (-998f, -977f, 409f), new Vector3f (-997f, -975f, 410f), 						//0 Starting Position 0
	new Vector3f (-1003f, -1028f, 14f), new Vector3f (-995f, -1016f, 15f), 						//1 The Boat 0
	new Vector3f (-5.359f, -161.539f, 66.5f), new Vector3f (-4.913f, -161.500f, 67.5f), 		//2 The Raven Man
	new Vector3f (52f, -188.7f, 381.9f), new Vector3f (52.1f, -188.6f, 382.1f), 				//3 Health 1 	2
	new Vector3f (-112.1f, -66.1f, 360.9f), new Vector3f (-112f, -66f, 361f), 					//4 Health 2	59
	new Vector3f (-74.8f, -102.8f, 378.9f), new Vector3f (-74.7f, -102.7f, 379f), 				//5 Health 3	60
	new Vector3f (-161.2f, 170.3f, 471.9f), new Vector3f (-161f, 170.4f, 472.1f), 				//6 Health 4	63
	new Vector3f (138.8f, 115.3f, 382.5f), new Vector3f (138.9f, 115.4f, 382.6f), 				//7 Health 5 	64
	new Vector3f (76.1f, 64.8f, 461.4f), new Vector3f (76.2f, 64.9f, 461.6f), 					//8 Health 6	64
	new Vector3f (190.2f, -131.9f, 353.9f), new Vector3f (190.3f, -131.8f, 354.1f), 			//9 Health 7	64
	new Vector3f (162.2f, -37.5f, 392.9f), new Vector3f (162.3f, -37.4f, 393.1f), 				//10 Health 8	64
	new Vector3f (-114.3f, -47.2f, 368.9f), new Vector3f (-114.1f, -47f, 369.1f), 				//12 Health 9	64
	new Vector3f (-96.643f, 43.059f, 407.4f), new Vector3f (-96.641f, 43.061f, 407.5f), 		//13 The Watersword	 66
	new Vector3f (-35f, 170f, 128.9f), new Vector3f (-5f, 205f, 129.1f), 						//14 The End 67	
	};

	//============= TE Zipless splits ==============
	//An array to store the positions for each split 
	Vector3f [] spTEZipless = {
	new Vector3f (-998f, -977f, 409f), new Vector3f (-997f, -975f, 410f), 						//0 Starting Position 0
	new Vector3f (-1003f, -1028f, 14f), new Vector3f (-995f, -1016f, 15f), 						//1 The Boat 0
	new Vector3f (-5.359f, -161.539f, 66.5f), new Vector3f (-4.913f, -161.500f, 67.5f), 		//2 The Raven Man
	new Vector3f (-114.3f, -47.2f, 368.9f), new Vector3f (-114.1f, -47f, 369.1f), 				//3 Health 1	36
	new Vector3f (76.1f, 64.8f, 461.4f), new Vector3f (76.2f, 64.9f, 461.6f), 					//4 Health 2	36
	new Vector3f (138.8f, 115.3f, 382.5f), new Vector3f (138.9f, 115.4f, 382.6f), 				//5 Health 3 	36
	new Vector3f (52f, -188.7f, 381.9f), new Vector3f (52.1f, -188.6f, 382.1f), 				//6 Health 4 	36
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//7 Mask of the Wraith 59
	new Vector3f (-112.1f, -66.1f, 360.9f), new Vector3f (-112f, -66f, 361f), 					//8 Health 5	59
	new Vector3f (-74.8f, -102.8f, 378.9f), new Vector3f (-74.7f, -102.7f, 379f), 				//9 Health 6	60
	new Vector3f (-208f, -35.5f, 419.9f), new Vector3f (-205f, -32.5f, 423f), 					//10 The Mechanical Tower 63
	new Vector3f (-161.2f, 170.3f, 471.9f), new Vector3f (-161f, 170.4f, 472.1f), 				//11 Health 7	63
	new Vector3f (162.2f, -37.5f, 392.9f), new Vector3f (162.3f, -37.4f, 393.1f), 				//12 Health 8	64
	new Vector3f (190.2f, -131.9f, 353.9f), new Vector3f (190.3f, -131.8f, 354.1f), 			//13 Health 9	64	
	new Vector3f (-96.643f, 43.059f, 407.4f), new Vector3f (-96.641f, 43.061f, 407.5f), 		//14 The Watersword	 66
	new Vector3f (-35f, 170f, 128.9f), new Vector3f (-5f, 205f, 129.1f), 						//15 The End 67
	}; 

	//============= TE NMG splits ==============
	//An array to store the positions for each split 
	Vector3f [] spTENMG = {
	new Vector3f (-998f, -977f, 409f), new Vector3f (-997f, -975f, 410f), 						//0 Starting Position 0
	new Vector3f (-1003f, -1028f, 14f), new Vector3f (-995f, -1016f, 15f), 						//1 The Boat 0
	new Vector3f (-46.3f, -138.8f, 67f), new Vector3f (-46f, -138f, 68f),		 				//2 The Spider Sword 2
	new Vector3f (52f, -188.7f, 381.9f), new Vector3f (52.1f, -188.6f, 382.1f), 				//3 Health 1 	3
	new Vector3f (115f, -114f, 357f), new Vector3f (132f, -80f, 361f), 							//4 A Damsel in Distress 8
	new Vector3f (190.2f, -131.9f, 353.9f), new Vector3f (190.3f, -131.8f, 354.1f), 			//5 Health 2	8
	new Vector3f (40.1f, -96.1f, 86f), new Vector3f (41.5f, -95.9f, 86.1f), 					//6 The Dahaka 9
	new Vector3f (-96.5f, 41.3f, 407.4f), new Vector3f (-96.4f, 41.4f, 407.5f), 				//7 The Serpent Sword 13
	new Vector3f (138.8f, 115.3f, 382.5f), new Vector3f (138.9f, 115.4f, 382.6f), 				//8 Health 3 23
	new Vector3f (65f, 60f, 402f), new Vector3f (68f, 62f, 402.1f), 							//9 Exit Water Maiden 25
	new Vector3f (31.1f, 82.1f, 150.9f), new Vector3f (31.3f, 82.3f, 151.1f), 					//10 The Waterworks in Ruin 28
	new Vector3f (23f, 41f, 441f), new Vector3f (29f, 43f, 450f), 								//11 The Waterworks Restored 30
	new Vector3f (76.1f, 64.8f, 461.4f), new Vector3f (76.2f, 64.9f, 461.6f), 					//12 Health 4	31
	new Vector3f (-114.3f, -47.2f, 368.9f), new Vector3f (-114.1f, -47f, 369.1f), 				//13 Health 5	21
	new Vector3f (-181.7f, -34f, 411f), new Vector3f (-181.5f, -33.9f, 411.3f), 				//14 The Mechanical Tower 15
	new Vector3f (-210.018f, 164.259f, 440.9f), new Vector3f (-210.016f, 164.261f, 441.1f), 	//15 The Ravages of Time 16
	new Vector3f (-206f, 63f, 163.8f), new Vector3f (-205.8f, 63.2f, 163.9f), 					//16 Activation Room in Ruin 18
	new Vector3f (-161.2f, 170.3f, 471.9f), new Vector3f (-161f, 170.4f, 472.1f), 				//17 Health 6	19
	new Vector3f (-45.5f, -27.7f, 388.9f), new Vector3f (-45.3f, 27.5f, 389.1f), 				//18 The Death of a Sand Wraith 33
	new Vector3f (-73f, 52f, 414.9f), new Vector3f (31f, 104f, 416f), 							//19 Death of the Empress 34
	new Vector3f (-100f, -190f, 33f), new Vector3f (-97.5f, -187f, 33.2f), 						//20 Exit the Tomb 39
	new Vector3f (-170.1f, -127.3f, 335.5f), new Vector3f (-170f, -127.2f, 336.5f), 			//21 Scorpion Sword 41
	new Vector3f (-112.1f, -66.1f, 360.9f), new Vector3f (-112f, -66f, 361f), 					//22 Health 7	41
	new Vector3f (-74.8f, -102.8f, 378.9f), new Vector3f (-74.7f, -102.7f, 379f), 				//23 Health 8	42
	new Vector3f (162.2f, -37.5f, 392.9f), new Vector3f (162.3f, -37.4f, 393.1f), 				//24 Health 9	44
	new Vector3f (-96.643f, 43.059f, 407.4f), new Vector3f (-96.641f, 43.061f, 407.5f), 		//25 The Watersword	 45
	new Vector3f (-20.5f, 236.8f, 133f), new Vector3f (-20.4f, 267f, 133.1f), 					//26 The Mask of the Wraith 46
	new Vector3f (-23f, 163f, 429f), new Vector3f (-15f, 166.5f, 431f),							//27 The Sand Griffin 48
	new Vector3f (136.7f, -110.6f, 377.9f), new Vector3f (136.9f, -110.4f, 378f), 				//28 Mirrored Fates 55
	new Vector3f (41.1f, -180.1f, 368.9f), new Vector3f (41.2f, -180f, 369.1f), 				//29 A Favor Unknown 57
	new Vector3f (-112f, -144f, 384.9f), new Vector3f (-111f, -137f, 389f), 					//30 The Library Revisited 60
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//31 The Light Sword 61
	new Vector3f (-66f, -23.3f, 399.9f), new Vector3f (-65.9f, -23.2f, 400f), 					//32 The Death of a Prince 64
	new Vector3f (-35f, 170f, 128.9f), new Vector3f (-5f, 205f, 129.1f), 						//33 The End 67
	}; 

	//Check for category to determine which splits to use
	int selection = vars.SetSplitsByCategory();
	if (selection == 0) {
		vars.splitPositions = spAnyNormal;
		vars.swordSplit = 6;
		vars.maskSplit = 4;
		vars.splitStoryValues = new int [] {
		0, 0, 2, 2, 59, 59, 61, 66, 67
		};
	}
	else if (selection == 1) {
		vars.splitPositions = spAnyZipless;
		vars.maskSplit = 4;
		vars.swordSplit = 6;		
		vars.splitStoryValues = new int [] {
		0, 0, 2, 2, 59, 59, 61, 66, 67
		};
	}
	else if (selection == 2) {
		vars.splitPositions = spAnyNMG;
		vars.maskSplit = null;
		vars.swordSplit = 27;		
		vars.splitStoryValues = new int [] {
		0, 0, 2, 7, 8, 9, 13, 22, 25, 28, 30, 21, 15, 16, 18, 19, 33, 34, 39, 41, 42, 45, 46, 48, 55, 57, 60, 61, 64, 67
		};
	}
	else if (selection == 3) {
		vars.splitPositions = spTENormal;
		vars.maskSplit = null;
		vars.swordSplit = null;
		vars.splitStoryValues = new int [] {
		0, 0, 2, 2, 59, 60, 63, 64, 64, 64, 64, 64, 66, 67
		};
	}
	else if (selection == 4) {
		vars.splitPositions = spTEZipless;
		vars.maskSplit = 7;
		vars.swordSplit = null;
		vars.splitStoryValues = new int [] {
		0, 0, 2, 36, 36, 36, 36, 59, 59, 60, 63, 63, 64, 64, 66, 67
		};
	}
	else if (selection == 5) {
		vars.splitPositions = spTENMG;
		vars.maskSplit = null;
		vars.swordSplit = 31;
		vars.splitStoryValues = new int [] {
		0, 0, 2, 3, 8, 8, 9, 13, 23, 25, 28, 30, 31, 21, 15, 16, 18, 19, 33, 34, 39, 41, 41, 42, 44, 45, 46, 48, 55, 57, 60, 61, 64, 67
		};
	}
	else {
		vars.splitPositions = spAnyNormal;
		vars.swordSplit = 6;
		vars.maskSplit = 4;
		vars.splitStoryValues = new int [] {
		0, 0, 2, 2, 59, 59, 61, 66, 67
		};
	}
	vars.unknowStart = true;

	//Detecting if the Prince is on the boat and if NewGame has been pressed.
	if (vars.GetSplit(-1) == 0 && current.startValue == 2){
			//Initializing variables if the game has started
			vars.split = 0;
			vars.unknowStart = false;
			return true;
	}
}

split{
	//The run was started without running the start block
	if (vars.unknowStart) {
		vars.split = 0;
		vars.unknowStart = false;
	}

	//Get the current split (-1 if we haven't hit a split trigger this update or if the game is not running)
	int currSplit = vars.isGameRunning ? vars.GetSplit(vars.split) : -1;

	//Check if we have hit a split trigger
	if (currSplit > 0) {

		//Difference between last split and current split
		int diff = currSplit - vars.split;

		//We have missed a split at some point
		if (diff > 1) {
			//We must skip (diff - 1) splits that we have missed
			for (int i = 1; i < diff; i++) {
				vars.SkipSplit();
			}
		}

		//Split normally
		vars.split = currSplit;
		return true;
	}
}
