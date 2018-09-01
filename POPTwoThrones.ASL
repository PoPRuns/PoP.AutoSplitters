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


state("POP3"){
//The address used for all bosses' health
	int bossHealth : 0x00604738, 0x1C, 0x53C, 0x54C, 0x750;

//The Prince's coords
	float xPos : 0x00A6A838, 0x0, 0x8, 0x54, 0x218, 0x620;	
	float yPos : 0x00A6A838, 0x0, 0x8, 0x54, 0x218, 0x624;	
	float zPos : 0x00A6A838, 0x0, 0x8, 0x54, 0x218, 0x628;
	float xCam : 0x928548;
	float yCam : 0x928554;
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
			if (vars.IsInBox(vars.splitPositions[i], vars.splitPositions[i +1])) {
				splitResult = i/2;
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
		else if (cat == "All Powers") {
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
	new Vector3f (-404.9f, 113.6f, 61.9f), new Vector3f (-404.8f, 113.7f, 62f), 				//0 Starting Position
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	};

	//============= Any% Zipless splits ==============
	//An array to store the positions for each split 
	Vector3f [] spAnyZipless = {
	new Vector3f (-404.9f, 113.6f, 61.9f), new Vector3f (-404.8f, 113.7f, 62f), 				//0 Starting Position
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	};
				
	//============= Any% NMG splits ==============
	//An array to store the positions for each split 
	Vector3f [] spAnyNMG = {
	new Vector3f (-404.9f, 113.6f, 61.9f), new Vector3f (-404.8f, 113.7f, 62f), 				//0 Starting Position
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	};

	//============= AP Normal (Zipful) splits ==============
	//An array to store the positions for each split 
	Vector3f [] spAPNormal = {
	new Vector3f (-404.9f, 113.6f, 61.9f), new Vector3f (-404.8f, 113.7f, 62f), 				//0 Starting Position
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	};

	//============= AP Zipless splits ==============
	//An array to store the positions for each split 
	Vector3f [] spAPZipless = {
	new Vector3f (-404.9f, 113.6f, 61.9f), new Vector3f (-404.8f, 113.7f, 62f), 				//0 Starting Position
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	}; 

	//============= AP NMG splits ==============
	//An array to store the positions for each split 
	Vector3f [] spAPNMG = {
	new Vector3f (-404.9f, 113.6f, 61.9f), new Vector3f (-404.8f, 113.7f, 62f), 				//0 Starting Position
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	new Vector3f (0f, 0f, 0f), new Vector3f (0f, 0f, 0f), 										//
	}; 

	//Check for category to determine which splits to use
	int selection = vars.SetSplitsByCategory();
	if (selection == 0) {
		vars.splitPositions = spAnyNormal;
	}
	else if (selection == 1) {
		vars.splitPositions = spAnyZipless;
	}
	else if (selection == 2) {
		vars.splitPositions = spAnyNMG;
	}
	else if (selection == 3) {
		vars.splitPositions = spAPNormal;
	}
	else if (selection == 4) {
		vars.splitPositions = spAPZipless;
	}
	else if (selection == 5) {
		vars.splitPositions = spAPNMG;
	}
	else {
		vars.splitPositions = spAnyNormal;
	}
	vars.unknowStart = true;
	
	//Detecting if the control has been gained at start of run
	if (vars.GetSplit(-1) == 0 && current.yCam <= 0.1082 && current.yCam >= 0.1080 && current.xCam <= 0.832 && current.xCam >= 0.8318){
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
