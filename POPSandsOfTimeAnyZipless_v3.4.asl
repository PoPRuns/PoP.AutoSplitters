//Authors: 		@Samabam#8840
//				@Ynscription#6173
//
//Last Updated:	2018/08/25	(ISO date format)
//
//Instructions:	If you're updating this script it means I'm probably dead. Thank god for that. The concept is fairly simple.
//				By monitoring the Prince's coordinates we're able to create what I call 'virtual hitboxes.' I attempted to
//				place my VHBs in places that no sane person would skip using the current route.
//				IMPORTANT: The 'f's in the split coordinates are necessary and the script won't run without them.
//
//Notes: 		Shoutouts to Tocaloni1 and others for finding the coordinate addresses. Shoutouts to GrizzBear for helping me test.
//				Shoutouts to Ynscription for caring enough to refine & finish this script.


state("POP"){
//Some memory value that reliably changes when 'New Game' is pressed.
	int startValue : 0x6BC980;

//Prince's position in terms of memory values.
	float xPos : 0x00699474, 0xC, 0x30;
	float yPos : 0x00699474, 0xC, 0x34;
	float zPos : 0x00699474, 0xC, 0x38;

//The Vizier's health where 0 is unharmed and 4 is dead.
	int vizierHealth : 0x0040E518, 0x6C, 0x18, 0x4, 0x44, 0x0;
}

startup{
	//Int used to keep track of how many splits should have triggered by a given point.
	int split;

	//A flag that determines if the game process is running
	bool isGameRunning = false;

	//A flag to trigger hp ups splits only once
	bool enteredFountain = false;

	//A flag to ensure initialization happens regardless of how the timer was started.
	bool unknownStart = true;
}

init {
	//init runs when the game process is found
	vars.isGameRunning = true;

	//The position of the magic fountain start
	vars.fountainStart = new Vector3f (-477.372f, -297.682f, -0.479f);


	//Function that determines if a split number is a fountain split
	vars.isFountainSplit = (Func<int, bool>) ((splitNumber) => {
		bool res = false;
		for (int i = 0; i < vars.fountainSplits.Length && !res; i++) {
			res = splitNumber == vars.fountainSplits [i];
		}
		return res;
	});

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
		//Check for each remaining split sphere if the prince is within split distance
		vars.princePos = new Vector3f (current.xPos, current.yPos, current.zPos);
		int fiveAhead = (lastSplit +6) * 2;
		int maxCheck = vars.splitPositions.Length < fiveAhead ? vars.splitPositions.Length : fiveAhead;
		for (int i = (lastSplit +1) *2; i <  maxCheck && splitResult == -1; i += 2) {
			if (vars.IsInBox(vars.splitPositions[i], vars.splitPositions[i +1])) {
				splitResult = i/2;
			}
		}

		//If we just entered the magic fountain area set flag to true
		if (vars.princePos.Distance(vars.fountainStart) < 0.5f) {
			print("Entered the area");
			vars.enteredFountain = true;
		}
		
		//If we got an HP up we will only return the split once
		if (vars.fountainSplits != null && vars.isFountainSplit(splitResult)) {			
			if (vars.enteredFountain) {
				vars.enteredFountain = false;
			}
			else {
				splitResult = -1;
			}
		}

		//Killing vizier
		if ((lastSplit == (vars.splitPositions.Length/2) - 2) && current.vizierHealth == 4) {
			splitResult = (vars.splitPositions.Length/2) - 1;
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
		else if (cat == "All Collectibles") {
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
	//An array to store the positions for each split (insert the trigger for hasDreamed as another split)
	Vector3f [] spAnyNormal = {
		new Vector3f (-103.264f, -4.8f, 1.341f), new Vector3f (-103.262f, -4.798f, 1.343f), 			//0 The starting balcony
		new Vector3f (252f, 130.647f, 22.999f), new Vector3f (258f, 134f, 23.001f), 					//1 The Treasure Vaults
		new Vector3f (-6.177f, 62.905f, 7.604f), new Vector3f (-6.175f, 62.907f, 7.606f), 				//2 The Sands of Time
		new Vector3f (134.137f, 54.990f, -32.791f), new Vector3f (134.139f, 54.992f, -32.789f),			//3 The Sultan's Chamber (Death)
		new Vector3f (-6.001f, -18.6f, 1.998f), new Vector3f (-5.999f, -18.4f, 2.001f),					//7 Death of the Sand King
		new Vector3f (-211.427f, 56.602f, -43.501f), new Vector3f (-211.425f, 56.604f, -43.499f),		//5 The Baths (Death)
		new Vector3f (-183.267f, 234.685f, -37.528f), new Vector3f (-183.265f, 234.687f, -37.526f),		//6 The Messhall (Death)
		new Vector3f (-246.839f, 78.019f, -71.731f), new Vector3f (-241.677f, 87.936f, -70.7f),			//7 The Caves
		new Vector3f (-51.477f, 72.155f, -24.802f), new Vector3f (-48.475f, 73.657f, -24.799f),			//8 Exit Underground Reservoir
		new Vector3f (139.231f, 162.556f, -29.502f), new Vector3f (139.233f, 162.558f, -29.5f),			//9 Exit Observatory (Death)
		new Vector3f (189.999f, -43.278f, -119.001f), new Vector3f (190.001f, -43.276f, -118.999f),		//10 The Torture Chamber (Death)
		new Vector3f (95.8f, -25.1f, -74.9f), new Vector3f (96f, -24.9f, -74.7f),				 		//11 The Dream
		new Vector3f (81f, -60.3f, 89f), new Vector3f (82f, -59.7f, 90f), 								//12 Honor and Glory
		new Vector3f (660.376f, 190.980f, 0.432f), new Vector3f (660.378f, 190.983f, 0.434f),			//13 The Grand Rewind
		new Vector3f (658.26f, 210.92f, 9.8f), new Vector3f (661.46f, 213.72f, 12.5f)					//14 The End
	};

	//============= Any% Zipless splits ==============
	//An array to store the positions for each split (insert the trigger for hasDreamed as another split)
	Vector3f [] spAnyZipless = {
	    new Vector3f (-103.264f, -4.8f, 1.341f), new Vector3f (-103.262f, -4.798f, 1.343f), 		//0 The starting balcony
	    new Vector3f (252f, 130.647f, 22.999f), new Vector3f (258f, 134f, 23.001f), 				//1 The Treasure Vaults
		new Vector3f (-6.177f, 62.905f, 7.604f), new Vector3f (-6.175f, 62.907f, 7.606f), 			//2 The Sands of Time
		new Vector3f (30.297f, 42.126f, 12.998f), new Vector3f (30.299f, 42.128f, 13f),				//3 The First Guest Room
		new Vector3f (98.445f, 39.567f, -8.96f), new Vector3f (98.447f, 39.57f, -8.958f), 			//4 The Sultan's Chamber
		new Vector3f (4.547f, 40.494f, -39.001f), new Vector3f (8.851f, 47.519f, -38.999f), 		//5 Exit Palace Defense
		new Vector3f (6.714f, 57.698f, 21.005f), new Vector3f (6.716f, 57.7f, 21.007f),				//6 The Sand King
		new Vector3f (-6.001f, -18.6f, 1.998f), new Vector3f (-5.999f, -18.4f, 2.001f),				//7 Death of the Sand King
		new Vector3f (-73.352f, -28.5f, -1.001f), new Vector3f (-71.233f, -26.868f, -0.818f),		//8 The Warehouse
		new Vector3f (-141.299f, -47.21f, -31.1f), new Vector3f (-139.797f, -42.801f, -30.9f), 		//9 The Zoo
		new Vector3f (-211f, -23f, -9f), new Vector3f (-208f, -21f, -8.8f), 						//10 Atop a Bird Cage
		new Vector3f (-233.6f, 33.7f, -42.6f), new Vector3f (-231.4f, 35f, -42.4f), 				//11 Cliffs And Waterfall
		new Vector3f (-215.85f, 54.261f, -43.501f), new Vector3f (-214.089f, 58.699f, -43.499f),  	//12 The Baths
		new Vector3f (-106.819f, 81.097f, -27.269f), new Vector3f (-106.817f, 81.099f, -27.267f), 	//13 Sword of the Mighty Warrior
		new Vector3f (-76f, 192.4f, -56.6f), new Vector3f (-70f, 197.6f, -54f),						//14 Daybreak
		new Vector3f (-267f, 232f, -35.6f), new Vector3f (-262f, 267f, -35.5f),						//15 Drawbridge Tower
		new Vector3f (-265f, 159f, -13.6f), new Vector3f (-257f, 167f, -13.4f),						//16 A Broken Bridge
		new Vector3f (-303f, 112f, -56.1f), new Vector3f (-297.5f, 113.5f, -55.9f), 				//17 The Caves
		new Vector3f (-242f, 79.5f, -121f), new Vector3f (-240.5f, 83f, -118f), 					//18 Waterfall
		new Vector3f (-121f, -9f, -154.1f), new Vector3f (-110f, -7f, -153.9f), 					//19 An Underground Reservoir
		new Vector3f (73f, 161f, -24.1f), new Vector3f (79f, 163f, -23.9f), 						//20 The Hall of Learning
		new Vector3f (137f, 164f, -29.5f), new Vector3f (141f, 164.67f, -29.2f), 					//21 Exit Observatory
		new Vector3f (72f, 90f, -27.1f), new Vector3f (77f, 95.7f, -26.9f), 						//22 Exit The Hall of Learning Courtyards
		new Vector3f (188.156f, -20.179f, -17.5f), new Vector3f (188.458f, -20.17f, -17.3f), 		//23 The Prison
		new Vector3f (187.5f, -39f, -119.1f), new Vector3f (192.5f, -37.5f, -118.9f), 				//24 The Torture Chamber
		new Vector3f (74f, -46.751f, -33.501f), new Vector3f (74.171f, -43.252f, -33.499f), 		//25 The Elevator
		new Vector3f (99f, -11f, -56f), new Vector3f (101f, -10f, -54f), 							//26 The Dream
		new Vector3f (100.643f, -11.543f, -67.588f), new Vector3f (100.645f, -11.541f, -67.586f), 	//27 The Tomb
		new Vector3f (35.5f, -50f, -32f), new Vector3f (35.7f, -39f, -30f), 						//28 The Tower of Dawn
		new Vector3f (60f, -58f, 30f), new Vector3f (61f, -57f, 32f), 								//29 The Setting Sun
		new Vector3f (81f, -60.3f, 89f), new Vector3f (82f, -59.7f, 90f), 							//30 Honor and Glory
		new Vector3f (660.376f, 190.980f, 0.432f), new Vector3f (660.378f, 190.983f, 0.434f),		//31 The Grand Rewind
		new Vector3f (658.26f, 210.92f, 9.8f), new Vector3f (661.46f, 213.72f, 12.5f)				//32 The End
	};
				
	//============= Any% NMG splits ==============
	//An array to store the positions for each split (insert the trigger for hasDreamed as another split)
	Vector3f [] spAnyNMG = {
    new Vector3f (-103.264f, -4.8f, 1.341f), new Vector3f (-103.262f, -4.798f, 1.343f), 		//0 The starting balcony
    new Vector3f (252f, 130.647f, 22.999f), new Vector3f (258f, 134f, 23.001f), 				//1 The Treasure Vaults
	new Vector3f (-6.177f, 62.905f, 7.604f), new Vector3f (-6.175f, 62.907f, 7.606f), 			//2 The Sands of Time
	new Vector3f (30.297f, 42.126f, 12.998f), new Vector3f (30.299f, 42.128f, 13f),				//3 The First Guest Room
	new Vector3f (98.445f, 39.567f, -8.96f), new Vector3f (98.447f, 39.57f, -8.958f), 			//4 The Sultan's Chamber
	new Vector3f (4.547f, 40.494f, -39.001f), new Vector3f (8.851f, 47.519f, -38.999f), 		//5 Exit Palace Defense
	new Vector3f (6.714f, 57.698f, 21.005f), new Vector3f (6.716f, 57.7f, 21.007f),				//6 The Sand King
	new Vector3f (-6.001f, -18.6f, 1.998f), new Vector3f (-5.999f, -18.4f, 2.001f),				//7 Death of the Sand King
	new Vector3f (-73.352f, -28.5f, -1.001f), new Vector3f (-71.233f, -26.868f, -0.818f),		//8 The Warehouse
	new Vector3f (-141.299f, -47.21f, -31.1f), new Vector3f (-139.797f, -42.801f, -30.9f), 		//9 The Zoo
	new Vector3f (-211f, -23f, -9f), new Vector3f (-208f, -21f, -8.8f), 						//10 Atop a Bird Cage
	new Vector3f (-233.6f, 33.7f, -42.6f), new Vector3f (-231.4f, 35f, -42.4f), 				//11 Cliffs And Waterfall
	new Vector3f (-215.85f, 54.261f, -43.501f), new Vector3f (-214.089f, 58.699f, -43.499f), 	//12 The Baths
	new Vector3f (-106.819f, 81.097f, -27.269f), new Vector3f (-106.817f, 81.099f, -27.267f),	//13 Sword of the Mighty Warrior
	new Vector3f (-76f, 192.4f, -56.6f), new Vector3f (-70f, 197.6f, -54f),						//14 Daybreak 
	new Vector3f (-267f, 232f, -35.6f), new Vector3f (-262f, 267f, -35.5f),						//15 Drawbridge Tower
	new Vector3f (-265f, 159f, -13.6f), new Vector3f (-257f, 167f, -13.4f),						//16 A Broken Bridge 
	new Vector3f (-303f, 112f, -56.1f), new Vector3f (-297.5f, 113.5f, -55.9f), 				//17 The Caves
	new Vector3f (-242f, 79.5f, -121f), new Vector3f (-240.5f, 83f, -118f), 					//18 Waterfall
	new Vector3f (-121f, -9f, -154.1f), new Vector3f (-110f, -7f, -153.9f), 					//19 An Underground Reservoir
	new Vector3f (73f, 161f, -24.1f), new Vector3f (79f, 163f, -23.9f), 						//20 The Hall of Learning
	new Vector3f (137f, 164f, -29.5f), new Vector3f (141f, 164.67f, -29.2f), 					//21 Exit Observatory
	new Vector3f (72f, 90f, -27.1f), new Vector3f (77f, 95.7f, -26.9f), 						//22 Exit The Hall of Learning Courtyards
	new Vector3f (188.156f, -20.179f, -17.5f), new Vector3f (188.458f, -20.17f, -17.3f), 		//23 The Prison
	new Vector3f (187.5f, -39f, -119.1f), new Vector3f (192.5f, -37.5f, -118.9f), 				//24 The Torture Chamber
	new Vector3f (74f, -46.751f, -33.501f), new Vector3f (74.171f, -43.252f, -33.499f), 		//25 The Elevator
	new Vector3f (99f, -11f, -56f), new Vector3f (101f, -10f, -54f), 							//26 The Dream
	new Vector3f (100.643f, -11.543f, -67.588f), new Vector3f (100.645f, -11.541f, -67.586f), 	//27 The Tomb
	new Vector3f (35.5f, -50f, -32f), new Vector3f (35.7f, -39f, -30f), 						//28 The Tower of Dawn
	new Vector3f (60f, -58f, 30f), new Vector3f (61f, -57f, 32f), 								//29 The Setting Sun
	new Vector3f (81f, -60.3f, 89f), new Vector3f (82f, -59.7f, 90f), 							//30 Honor and Glory
	new Vector3f (660.376f, 190.980f, 0.432f), new Vector3f (660.378f, 190.983f, 0.434f),		//31 The Grand Rewind
	new Vector3f (658.26f, 210.92f, 9.8f), new Vector3f (661.46f, 213.72f, 12.5f)				//32 The End
	};


	//============= AC Normal (Zipful) splits ==============
	//An array to store the positions for each split (insert the trigger for hasDreamed as another split)
	Vector3f [] spACNormal = {
    new Vector3f (-103.264f, -4.8f, 1.341f), new Vector3f (-103.262f, -4.798f, 1.343f), 		//0 The starting balcony
    new Vector3f (252f, 130.647f, 22.999f), new Vector3f (258f, 134f, 23.001f), 				//1 The Treasure Vaults
	new Vector3f (-6.177f, 62.905f, 7.604f), new Vector3f (-6.175f, 62.907f, 7.606f), 			//2 The Sands of Time
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//3 Life Upgrade 1
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//4 Life Upgrade 2
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//5 Life Upgrade 3
	new Vector3f (-211.427f, 56.602f, -43.501f), new Vector3f (-211.425f, 56.604f, -43.499f),	//6 The Baths (Death)
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//7 Life Upgrade 4
	new Vector3f (-183.267f, 234.685f, -37.528f), new Vector3f (-183.265f, 234.687f, -37.526f),	//8 The Messhall (Death)
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//9 Life Upgrade 5
	new Vector3f (-171.193f, -52.07f, -119.863f), new Vector3f (-171.191f, -52.068f, -119.861f),//10 The Caves (Death)
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//11 Life Upgrade 6
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//12 Life Upgrade 7
	new Vector3f (139.231f, 162.556f, -29.502f), new Vector3f (139.233f, 162.558f, -29.5f),		//13 Exit Observatory (Death)
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//14 Life Upgrade 8
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//15 Life Upgrade 9
	new Vector3f (95.8f, -25.1f, -74.9f), new Vector3f (96f, -24.9f, -74.7f),				 	//16 The Dream
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//17 Life Upgrade 10
	new Vector3f (60f, -58f, 30f), new Vector3f (61f, -57f, 32f), 								//18 The Setting Sun
	new Vector3f (81f, -60.3f, 89f), new Vector3f (82f, -59.7f, 90f), 							//19 Honor and Glory
	new Vector3f (660.376f, 190.980f, 0.432f), new Vector3f (660.378f, 190.983f, 0.434f),		//20 The Grand Rewind
	new Vector3f (658.26f, 210.92f, 9.8f), new Vector3f (661.46f, 213.72f, 12.5f)				//21 The End
	};


	//============= AC Zipless splits ==============
	//An array to store the positions for each split (insert the trigger for hasDreamed as another split)
	Vector3f [] spACZipless = {
    new Vector3f (-103.264f, -4.8f, 1.341f), new Vector3f (-103.262f, -4.798f, 1.343f), 		//0 The starting balcony
    new Vector3f (252f, 130.647f, 22.999f), new Vector3f (258f, 134f, 23.001f), 				//1 The Treasure Vaults
	new Vector3f (-6.177f, 62.905f, 7.604f), new Vector3f (-6.175f, 62.907f, 7.606f), 			//2 The Sands of Time
	new Vector3f (30.297f, 42.126f, 12.998f), new Vector3f (30.299f, 42.128f, 13f),				//3 The First Guest Room
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//4 Life Upgrade 1
	new Vector3f (4.547f, 40.494f, -39.001f), new Vector3f (8.851f, 47.519f, -38.999f), 		//5 Exit Palace Defense
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//6 Life Upgrade 2
	new Vector3f (-6.001f, -18.6f, 1.998f), new Vector3f (-5.999f, -18.4f, 2.001f),				//7 Death of the Sand King
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//8 Life Upgrade 3
	new Vector3f (-141.299f, -47.21f, -31.1f), new Vector3f (-139.797f, -42.801f, -30.9f), 		//9 The Zoo
	new Vector3f (-211f, -23f, -9f), new Vector3f (-208f, -21f, -8.8f), 						//10 Atop a Bird Cage
	new Vector3f (-233.6f, 33.7f, -42.6f), new Vector3f (-231.4f, 35f, -42.4f), 				//11 Cliffs And Waterfall
	new Vector3f (-215.85f, 54.261f, -43.501f), new Vector3f (-214.089f, 58.699f, -43.499f),  	//12 The Baths
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//13 Life Upgrade 4
	new Vector3f (-76f, 192.4f, -56.6f), new Vector3f (-70f, 197.6f, -54f),						//14 Daybreak 
	new Vector3f (-267f, 232f, -35.6f), new Vector3f (-262f, 267f, -35.5f),						//15 Drawbridge Tower
	new Vector3f (-265f, 159f, -13.6f), new Vector3f (-257f, 167f, -13.4f),						//16 A Broken Bridge 
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//17 Life Upgrade 5
	new Vector3f (-242f, 79.5f, -121f), new Vector3f (-240.5f, 83f, -118f), 					//18 Waterfall
	new Vector3f (-121f, -9f, -154.1f), new Vector3f (-110f, -7f, -153.9f), 					//19 An Underground Reservoir
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//20 Life Upgrade 6
	new Vector3f (73f, 161f, -24.1f), new Vector3f (79f, 163f, -23.9f), 						//21 The Hall of Learning
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//22 Life Upgrade 7
	new Vector3f (137f, 164f, -29.5f), new Vector3f (141f, 164.67f, -29.2f), 					//23 Exit Observatory
	new Vector3f (72f, 90f, -27.1f), new Vector3f (77f, 95.7f, -26.9f), 						//24 Exit The Hall of Learning Courtyards
	new Vector3f (188.156f, -20.179f, -17.5f), new Vector3f (188.458f, -20.17f, -17.3f), 		//25 The Prison
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//26 Life Upgrade 8
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//27 Life Upgrade 9
	new Vector3f (99f, -11f, -56f), new Vector3f (101f, -10f, -54f), 							//28 The Dream
	new Vector3f (100.643f, -11.543f, -67.588f), new Vector3f (100.645f, -11.541f, -67.586f),	//29 The Tomb
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//30 Life Upgrade 10
	new Vector3f (35.5f, -50f, -32f), new Vector3f (35.7f, -39f, -30f), 						//31 The Tower of Dawn
	new Vector3f (60f, -58f, 30f), new Vector3f (61f, -57f, 32f), 								//32 The Setting Sun
	new Vector3f (81f, -60.3f, 89f), new Vector3f (82f, -59.7f, 90f), 							//33 Honor and Glory
	new Vector3f (660.376f, 190.980f, 0.432f), new Vector3f (660.378f, 190.983f, 0.434f),		//34 The Grand Rewind
	new Vector3f (658.26f, 210.92f, 9.8f), new Vector3f (661.46f, 213.72f, 12.5f)				//35 The End
	}; 


	//============= AC NMG splits ==============
	//An array to store the positions for each split (insert the trigger for hasDreamed as another split)
	Vector3f [] spACNMG = {
    new Vector3f (-103.264f, -4.8f, 1.341f), new Vector3f (-103.262f, -4.798f, 1.343f), 		//0 The starting balcony
    new Vector3f (252f, 130.647f, 22.999f), new Vector3f (258f, 134f, 23.001f), 				//1 The Treasure Vaults
	new Vector3f (-6.177f, 62.905f, 7.604f), new Vector3f (-6.175f, 62.907f, 7.606f), 			//2 The Sands of Time
	new Vector3f (30.297f, 42.126f, 12.998f), new Vector3f (30.299f, 42.128f, 13f),				//3 The First Guest Room
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//4 Life Upgrade 1
	new Vector3f (4.547f, 40.494f, -39.001f), new Vector3f (8.851f, 47.519f, -38.999f), 		//5 Exit Palace Defense
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//6 Life Upgrade 2
	new Vector3f (-6.001f, -18.6f, 1.998f), new Vector3f (-5.999f, -18.4f, 2.001f),				//7 Death of the Sand King
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//8 Life Upgrade 3
	new Vector3f (-141.299f, -47.21f, -31.1f), new Vector3f (-139.797f, -42.801f, -30.9f), 		//9 The Zoo
	new Vector3f (-211f, -23f, -9f), new Vector3f (-208f, -21f, -8.8f), 						//10 Atop a Bird Cage
	new Vector3f (-233.6f, 33.7f, -42.6f), new Vector3f (-231.4f, 35f, -42.4f), 				//11 Cliffs And Waterfall
	new Vector3f (-215.85f, 54.261f, -43.501f), new Vector3f (-214.089f, 58.699f, -43.499f), 	//12 The Baths
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//13 Life Upgrade 4
	new Vector3f (-76f, 192.4f, -56.6f), new Vector3f (-70f, 197.6f, -54f),						//14 Daybreak 
	new Vector3f (-267f, 232f, -35.6f), new Vector3f (-262f, 267f, -35.5f),						//15 Drawbridge Tower
	new Vector3f (-265f, 159f, -13.6f), new Vector3f (-257f, 167f, -13.4f),						//16 A Broken Bridge 
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//17 Life Upgrade 5
	new Vector3f (-242f, 79.5f, -121f), new Vector3f (-240.5f, 83f, -118f), 					//18 Waterfall
	new Vector3f (-121f, -9f, -154.1f), new Vector3f (-110f, -7f, -153.9f), 					//19 An Underground Reservoir
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//20 Life Upgrade 6
	new Vector3f (73f, 161f, -24.1f), new Vector3f (79f, 163f, -23.9f), 						//21 The Hall of Learning
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//22 Life Upgrade 7
	new Vector3f (137f, 164f, -29.5f), new Vector3f (141f, 164.67f, -29.2f), 					//23 Exit Observatory
	new Vector3f (72f, 90f, -27.1f), new Vector3f (77f, 95.7f, -26.9f), 						//24 Exit The Hall of Learning Courtyards
	new Vector3f (188.156f, -20.179f, -17.5f), new Vector3f (188.458f, -20.17f, -17.3f), 		//25 The Prison
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//26 Life Upgrade 8
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//27 Life Upgrade 9
	new Vector3f (99f, -11f, -56f), new Vector3f (101f, -10f, -54f), 							//28 The Dream
	new Vector3f (100.643f, -11.543f, -67.588f), new Vector3f (100.645f, -11.541f, -67.586f), 	//29 The Tomb
	new Vector3f (-492.608f, -248.833f, 0.219f), new Vector3f (-492.606f, -248.831f, 0.221f),	//30 Life Upgrade 10
	new Vector3f (35.5f, -50f, -32f), new Vector3f (35.7f, -39f, -30f), 						//31 The Tower of Dawn
	new Vector3f (60f, -58f, 30f), new Vector3f (61f, -57f, 32f), 								//32 The Setting Sun
	new Vector3f (81f, -60.3f, 89f), new Vector3f (82f, -59.7f, 90f), 							//33 Honor and Glory
	new Vector3f (660.376f, 190.980f, 0.432f), new Vector3f (660.378f, 190.983f, 0.434f),		//34 The Grand Rewind
	new Vector3f (658.26f, 210.92f, 9.8f), new Vector3f (661.46f, 213.72f, 12.5f)				//35 The End
	};

	//Check for category to determine which splits to use
	int selection = vars.SetSplitsByCategory();
	if (selection == 0) {
		vars.splitPositions = spAnyNormal;
		vars.fountainSplits = null;
	}
	else if (selection == 1) {
		vars.splitPositions = spAnyZipless;
		vars.fountainSplits = null;
	}
	else if (selection == 2) {
		vars.splitPositions = spAnyNMG;
		vars.fountainSplits = null;
	}
	else if (selection == 3) {
		vars.splitPositions = spACNormal;
		vars.fountainSplits = new int [] {
			3, 4, 5, 7, 9, 11, 12, 14, 15, 17 
		};
	}
	else if (selection == 4) {
		vars.splitPositions = spACZipless;
		vars.fountainSplits = new int [] {
			4, 6, 8, 13, 17, 20, 22, 26, 27, 31
		};
	}
	else if (selection == 5) {
		vars.splitPositions = spACNMG;
		vars.fountainSplits = new int [] {
		4, 6, 8, 13, 17, 20, 22, 26, 27, 31
		};
	}
	else {
		vars.splitPositions = spAnyZipless;
		vars.fountainSplits = null;
	}

	vars.unknowStart = true;

	//Detecting if the Prince is on the starting balcony and if NewGame has been pressed.
	if (vars.GetSplit(-1) == 0 && current.startValue == 1){
			//Initializing variables if the game has started
			vars.split = 0;
			vars.unknowStart = false;
			vars.enteredFountain = false;
			return true;
	}
}

split{
	//The run was started without running the start block
	if (vars.unknowStart) {
		vars.split = 0;
		vars.unknowStart = false;
		vars.enteredFountain = false;
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
