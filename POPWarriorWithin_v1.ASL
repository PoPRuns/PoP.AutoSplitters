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
				if(current.storyValue == 59 && (i/2) < (vars.maskSplit+1)){
					splitResult = vars.maskSplit;
				}
			}
			
		}
		
		//Only splitting if there is no boss or the boss is dead.
		if(current.bossHealth != 0){
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
	new Vector3f (-3.1f, -161.5f, 66.5f), new Vector3f (-3f, -161f, 67.5f), 					//2 The Raven Man
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
	new Vector3f (-3.1f, -161.5f, 66.5f), new Vector3f (-3f, -161f, 67.5f), 					//2 The Raven Man
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
	new Vector3f (-46.2f, -138.8f, 67.1f), new Vector3f (-42.1f, -138.7f, 67f), 				//2 The Spider Sword 2
	new Vector3f (43.3f, -75.7f, 370f), new Vector3f (43.4f, -75.6f, 370.1f), 					//3 Chasing Shadee 7
	new Vector3f (115f, -114f, 357f), new Vector3f (132f, -80f, 361f), 							//4 A Damsel in Distress 8
	new Vector3f (40.1f, -95.9f, 86f), new Vector3f (40.2f, -96.1f, 86.1f), 					//5 The Dahaka 9
	new Vector3f (-96.5f, 41.3f, 407.4f), new Vector3f (-96.4f, 41.4f, 407.5f), 				//6 The Serpent Sword 13
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//7 The Garden Hall
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//8 The Water Maiden
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//9 The Waterworks in Ruin
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//10 The Waterworks Restored
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//11 The Lion Sword
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//12 The Mechanical Tower
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//13 Mechanical Portal
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//14 A Tower in Ruin
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//15 A Tower Restored
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//16 The Death of a Sand Wraith
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//17 Death of the Empress
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//18 Exit the Tomb
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//19 The Scorpion Sword
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//21 The Library
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//22 The Hourglass Revisited
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//23 The Mask of the Wraith
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//24 The Sand Griffin
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//25 Mirrored Fates
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//26 A Favor Unknown
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//27 The Library Revisited
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//28 The Light Sword
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//29 The Death of a Prince
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//30 The End
	};


	//============= TE Normal (Zipful) splits ==============
	//An array to store the positions for each split 
	Vector3f [] spTENormal = {
	new Vector3f (-998f, -977f, 409f), new Vector3f (-997f, -975f, 410f), 						//0 Starting Position
	new Vector3f (-1003f, -1028f, 14f), new Vector3f (-995f, -1016f, 15f), 						//1 The Boat
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//2 The Raven Man
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//3 The Time Portal
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//4 Mask of the Wraith
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//5 Scorpion Sword
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//6 Light Sword
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//7 Back to the Future
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//8 The End
	};


	//============= TE Zipless splits ==============
	//An array to store the positions for each split 
	Vector3f [] spTEZipless = {
	new Vector3f (-998f, -977f, 409f), new Vector3f (-997f, -975f, 410f), 						//0 Starting Position
	new Vector3f (-1003f, -1028f, 14f), new Vector3f (-995f, -1016f, 15f), 						//1 The Boat
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//2 The Raven Man
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//3 The Time Portal
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//4 Mask of the Wraith
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//5 Scorpion Sword
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//6 Light Sword
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//7 Back to the Future
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//8 The End
	}; 


	//============= TE NMG splits ==============
	//An array to store the positions for each split 
	Vector3f [] spTENMG = {
	new Vector3f (-998f, -977f, 409f), new Vector3f (-997f, -975f, 410f), 						//0 Starting Position
	new Vector3f (-1003f, -1028f, 14f), new Vector3f (-995f, -1016f, 15f), 						//1 The Boat
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//2 The Raven Man
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//3 The Time Portal
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//4 Mask of the Wraith
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//5 Scorpion Sword
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//6 Light Sword
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//7 Back to the Future
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//8 The End
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
		0, 0, 2, 2, 59, 59, 61, 66, 67
		};
	}
	else if (selection == 3) {
		vars.splitPositions = spTENormal;
		vars.maskSplit = null;
		vars.swordSplit = null;
		vars.splitStoryValues = new int [] {
		0, 0, 2, 2, 59, 59, 61, 66, 67
		};
	}
	else if (selection == 4) {
		vars.splitPositions = spTEZipless;
		vars.maskSplit = 7;
		vars.swordSplit = null;
		vars.splitStoryValues = new int [] {
		0, 0, 2, 2, 59, 59, 61, 66, 67
		};
	}
	else if (selection == 5) {
		vars.splitPositions = spTENMG;
		vars.maskSplit = null;
		vars.swordSplit = 31;
		vars.splitStoryValues = new int [] {
		0, 0, 2, 2, 59, 59, 61, 66, 67
		};
	}
	else {
		selection = 1;
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
