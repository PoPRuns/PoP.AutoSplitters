//Authors: 		@Samabam#8840
//
//Last Updated:	2018/09/15	(ISO date format)
//
//Instructions:	If you're updating this script it means I'm probably dead. Thank god for that. The concept is fairly simple.
//				By monitoring the Prince's coordinates we're able to create what I call 'virtual hitboxes.' I attempted to
//				place my VHBs in places that no sane person would skip using the current route.
//				IMPORTANT: The 'f's in the split coordinates are necessary and the script won't run without them.
//
//Notes: 		This script is based on the Sands of Time splitter, which was primarily written by @Ynscription#6173. 


state("POP3"){

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
	new Vector3f (-271f, 187f, 74f), new Vector3f (-265f, 188f, 75f), 							//1 The Harbor District
	new Vector3f (-93f, 236.2f, 83f), new Vector3f (-88f, 238f, 88f), 							//2 The Palace
	new Vector3f (-35.5f, 232.3f, 146.9f), new Vector3f (-35.4f, 232.4f, 147f), 				//3 The Dagger of Time
	new Vector3f (-100f, -83f, 19.9f), new Vector3f (-96f, -79f, 20f), 							//4 The Tunnels
	new Vector3f (-321f, 324f, 95.5f), new Vector3f (-314f, 330f, 96.5f), 						//5 The Lower City Rooftops
	new Vector3f (-250f, 372f, 66.9f), new Vector3f (-240f, 382f, 67.1f), 						//6 The Death of Klompa
	new Vector3f (-122.6f, 419.7f, 109.6994f), new Vector3f (-122.5f, 419.8f, 109.6996f), 		//7 The Temple
	new Vector3f (-239f, 465f, 86.8f), new Vector3f (-235f, 473f, 86.9f), 						//8 The Market District
	new Vector3f (-104f, 548f, 105.9f), new Vector3f (-100f, 553f, 106.1f), 					//9 The Death of Mahasti
	new Vector3f (-63.5f, 389.7f, 85.2f), new Vector3f (-63.4f, 389.8f, 85.3f), 				//10 The Stone Guardian
	new Vector3f (60.1f, 477.5f, 80f), new Vector3f (60.2f, 477.6f, 80.1f), 					//11 The King's Road
	new Vector3f (53f, 240f, 71f), new Vector3f (70f, 250f, 71.1f), 							//12 The Death of the Twins
	new Vector3f (5f, 243f, 104f), new Vector3f (12f, 265f, 104.1f), 							//13 The Well of Ancestors
	new Vector3f (-25.5f, 334f, 35.9f), new Vector3f (-25f, 336f, 36.1f), 						//14 The Underground Cave
	new Vector3f (-8f, 296f, 226.9f), new Vector3f (-7f, 298f, 227f), 							//15 The Upper Tower
	new Vector3f (189f, 319.135f, 542f), new Vector3f (193f, 320f, 543f), 						//16 The End
	};

	//============= Any% Zipless splits ==============
	//An array to store the positions for each split 
	Vector3f [] spAnyZipless = {
	new Vector3f (-404.9f, 113.6f, 61.9f), new Vector3f (-404.8f, 113.7f, 62f), 				//0 Starting Position
	new Vector3f (-271f, 187f, 74f), new Vector3f (-265f, 188f, 75f), 							//1 The Harbor District
	new Vector3f (-93f, 236.2f, 83f), new Vector3f (-88f, 238f, 88f), 							//2 The Palace
	new Vector3f (-35.5f, 232.3f, 146.9f), new Vector3f (-35.4f, 232.4f, 147f), 				//3 The Dagger of Time
	new Vector3f (-52.1f, 135.8f, 75.9f), new Vector3f (-52.0f, 135.9f, 76f), 					//4 The Sewers
	new Vector3f (-88.6f, -14.8f, 4.9f), new Vector3f (-88.5f, -14.7f, 5.1f), 					//5 The Tunnels
	new Vector3f (-71.4f, 9.6f, 44f), new Vector3f (-71.3f, 9.7f, 44.1f), 						//6 The Lower City
	new Vector3f (-317.8f, 329.8f, 96f), new Vector3f (-317.7f, 329.9f, 96.1f), 				//7 The Lower City Rooftops
	new Vector3f (-261.3f, 318.9f, 46.9f), new Vector3f (-261.2f, 319.1f, 47f), 				//8 The Death of Klompa
	new Vector3f (-194f, 328f, 32.6f), new Vector3f (-190f, 329.7f, 33.6f), 					//9 The Eye of the Storm
	new Vector3f (-114f, 336f, 56f), new Vector3f (-110f, 338f, 56.1f), 						//10 The Temple Rooftops
	new Vector3f (-122f, 423f, 107f), new Vector3f (-118f, 424f, 109f), 						//11 The Temple
	new Vector3f (-241.98f, 475f, 86.8f), new Vector3f (-241.9f, 477f, 86.9f), 					//12 The Market District
	new Vector3f (-168f, 512f, 88.9f), new Vector3f (-167.5f, 518f, 93f), 						//13 The Bowery
	new Vector3f (-104f, 548f, 105.9f), new Vector3f (-100f, 553f, 106.1f), 					//14 Death of Mahasti
	new Vector3f (-122f, 500f, 97.9f), new Vector3f (-120f, 505f, 98.1f),						//15 The Upper City
	new Vector3f (-63.5f, 389.7f, 85.2f), new Vector3f (-63.4f, 389.8f, 85.3f), 				//16 The Stone Guardian
	new Vector3f (-3f, 515f, 72f), new Vector3f (-1f, 519f, 75f),								//17 The Royal Workshop
	new Vector3f (60.1f, 477.5f, 80f), new Vector3f (60.2f, 477.6f, 80.1f), 					//18 The King's Road
	new Vector3f (91.7802f, 229.6516f, 70.9877f), new Vector3f (91.7804f, 229.6518f, 70.9879f), //19 The Death of the Twins
	new Vector3f (30.8f, 271.2f, 126f), new Vector3f (30.9f, 271.3f, 126.1f), 					//20 The Elevator
	new Vector3f (13.5f, 204.4f, 184.9999f), new Vector3f (27.4f, 215.4f, 185.0001f), 			//21 The Structure's Mind
	new Vector3f (-28f, 250f, 20.9f), new Vector3f (-26.5f, 255f, 30f),							//22 The Well Of Ancestors	
	new Vector3f (-12.6f, 241.2f, 0.9f), new Vector3f (-12.5f, 241.3f, 1f), 					//23 The Labyrinth
	new Vector3f (-25.5f, 334f, 35.9f), new Vector3f (-25f, 336f, 36.1f), 						//24 The Underground Cave	
	new Vector3f (27f, 316.5f, 99.9f), new Vector3f (29f, 318f, 100.1f), 						//25 The Lower Tower
	new Vector3f (-5f, 316f, 139.9f), new Vector3f (-3f, 317.5f, 140.1f), 						//26 The Middle Tower
	new Vector3f (-8f, 296f, 226.9f), new Vector3f (-7f, 298f, 227f), 							//27 The Upper Tower
	new Vector3f (4.4851f, 240.9438f, 304.2322f), new Vector3f (4.4853f, 240.944f, 304.2324f), 	//28 Death of the Vizier
	new Vector3f (189f, 319.135f, 542f), new Vector3f (193f, 320f, 543f), 						//29 The End
	};
				
	//============= Any% NMG splits ==============
	//An array to store the positions for each split 
	Vector3f [] spAnyNMG = {
	new Vector3f (-404.9f, 113.6f, 61.9f), new Vector3f (-404.8f, 113.7f, 62f), 				//0 Starting Position
	new Vector3f (-271f, 187f, 74f), new Vector3f (-265f, 188f, 75f), 							//1 The Harbor District
	new Vector3f (-93f, 236.2f, 83f), new Vector3f (-88f, 238f, 88f), 							//2 The Palace
	new Vector3f (-35.5f, 232.3f, 146.9f), new Vector3f (-35.4f, 232.4f, 147f), 				//3 The Dagger of Time
	new Vector3f (-52.1f, 135.8f, 75.9f), new Vector3f (-52.0f, 135.9f, 76f), 					//4 The Sewers
	new Vector3f (-88.6f, -14.8f, 4.9f), new Vector3f (-88.5f, -14.7f, 5.1f), 					//5 The Tunnels
	new Vector3f (-71.4f, 9.6f, 44f), new Vector3f (-71.3f, 9.7f, 44.1f), 						//6 The Lower City
	new Vector3f (-317.8f, 329.8f, 96f), new Vector3f (-317.7f, 329.9f, 96.1f), 				//7 The Lower City Rooftops
	new Vector3f (-261.3f, 318.9f, 46.9f), new Vector3f (-261.2f, 319.1f, 47f), 				//8 The Death of Klompa
	new Vector3f (-194f, 328f, 32.6f), new Vector3f (-190f, 329.7f, 33.6f), 					//9 The Eye of the Storm
	new Vector3f (-111.9f, 333.3f, 56f), new Vector3f (-111.7f, 333.4f, 56.1f), 				//10 The Temple Rooftops
	new Vector3f (-134f, 424.9f, 103f), new Vector3f (-133.8f, 425f, 103.1f), 					//11 The Temple
	new Vector3f (-241.98f, 475f, 86.8f), new Vector3f (-241.9f, 477f, 86.9f), 					//12 The Market District
	new Vector3f (-170.6f, 506.7f, 98f), new Vector3f (-170.5f, 506.8f, 98.1f), 				//13 The Bowery
	new Vector3f (-152.6f, 549.8f, 91.9f), new Vector3f (-152.5f, 549.9f, 92f), 				//14 The Brothel
	new Vector3f (-121.4f, 579.1f, 103.9f), new Vector3f (-121.3f, 579.2f, 104f), 				//15 Death of Mahasti
	new Vector3f (-122.9f, 500.4f, 98.1f), new Vector3f (-122.8f, 500.5f, 98.2f), 				//16 The Upper City
	new Vector3f (-63.5f, 389.7f, 85.2f), new Vector3f (-63.4f, 389.8f, 85.3f), 				//17 The Stone Guardian
	new Vector3f (-15.5f, 456.6f, 84f), new Vector3f (-15.4f, 456.7f, 84.1f), 					//18 The Royal Workshop
	new Vector3f (60.1f, 477.5f, 80f), new Vector3f (60.2f, 477.6f, 80.1f), 					//19 The King's Road
	new Vector3f (91.7802f, 229.6516f, 70.9877f), new Vector3f (91.7804f, 229.6518f, 70.9879f), //20 The Death of the Twins
	new Vector3f (30.8f, 271.2f, 126f), new Vector3f (30.9f, 271.3f, 126.1f), 					//21 The Elevator
	new Vector3f (13.5f, 204.4f, 184.9999f), new Vector3f (27.4f, 215.4f, 185.0001f), 			//22 The Structure's Mind
	new Vector3f (7.9f, 246.2f, 104f), new Vector3f (8f, 246.3f, 104.1f), 						//23 The Well Of Ancestors	
	new Vector3f (-12.6f, 241.2f, 0.9f), new Vector3f (-12.5f, 241.3f, 1f), 					//24 The Labyrinth
	new Vector3f (-25.5f, 334f, 35.9f), new Vector3f (-25f, 336f, 36.1f), 						//25 The Underground Cave	
	new Vector3f (27f, 316.5f, 99.9f), new Vector3f (29f, 318f, 100.1f), 						//26 The Lower Tower
	new Vector3f (-5f, 316f, 139.9f), new Vector3f (-3f, 317.5f, 140.1f), 						//27 The Middle Tower
	new Vector3f (-8f, 296f, 226.9f), new Vector3f (-7f, 298f, 227f), 							//28 The Upper Tower
	new Vector3f (4.4851f, 240.9438f, 304.2322f), new Vector3f (4.4853f, 240.944f, 304.2324f), 	//29 Death of the Vizier
	new Vector3f (189f, 319.135f, 542f), new Vector3f (193f, 320f, 543f), 						//30 The End
	};

	//============= AP Normal (Zipful) splits ==============
	//An array to store the positions for each split 
	Vector3f [] spAPNormal = {
	new Vector3f (-404.9f, 113.6f, 61.9f), new Vector3f (-404.8f, 113.7f, 62f), 				//0 Starting Position
	new Vector3f (-271f, 187f, 74f), new Vector3f (-265f, 188f, 75f), 							//1 The Harbor District
	new Vector3f (-93f, 236.2f, 83f), new Vector3f (-88f, 238f, 88f), 							//2 The Palace
	new Vector3f (-35.5f, 232.3f, 146.9f), new Vector3f (-35.4f, 232.4f, 147f), 				//3 The Dagger of Time
	new Vector3f (-14.9972f, -112.8152f, 20.0732f), new Vector3f (-14.9970f, -112.8150f, 20.0734f), //5 Health 1
	new Vector3f (-321f, 324f, 95.5f), new Vector3f (-314f, 330f, 96.5f), 						//5 The Lower City Rooftops
	new Vector3f (-302.0919f, 370.8710f, -0.9788f), new Vector3f (-302.0917f, 370.8712f, -0.9786f), //8 Health 2
	new Vector3f (-250f, 372f, 66.9f), new Vector3f (-240f, 382f, 67.1f), 						//6 The Death of Klompa
	new Vector3f (-122.6f, 419.7f, 109.6994f), new Vector3f (-122.5f, 419.8f, 109.6996f), 		//7 The Temple
	new Vector3f (-187.3369f, 455.9863f, 78.0330f), new Vector3f (-187.3367f, 455.9865f, 78.0332f), //13 Health 3
	new Vector3f (-239f, 465f, 86.8f), new Vector3f (-235f, 473f, 86.9f), 						//8 The Market District
	new Vector3f (-104f, 548f, 105.9f), new Vector3f (-100f, 553f, 106.1f), 					//9 The Death of Mahasti
	new Vector3f (-55.0147f, 395.7608f, 72.0774f), new Vector3f (-55.0145f, 395.761f, 72.0776f),	//19 Health 4
	new Vector3f (60.1f, 477.5f, 80f), new Vector3f (60.2f, 477.6f, 80.1f), 					//11 The King's Road
	new Vector3f (53f, 240f, 71f), new Vector3f (70f, 250f, 71.1f), 							//12 The Death of the Twins
	new Vector3f (-30.1223f, 281.8893f, 104.0796f), new Vector3f (-30.1221f, 281.8895f, 104.0798f), //23 Health 5
	new Vector3f (5f, 243f, 104f), new Vector3f (12f, 265f, 104.1f), 							//13 The Well of Ancestors
	new Vector3f (-25.5f, 334f, 35.9f), new Vector3f (-25f, 336f, 36.1f), 						//14 The Underground Cave
	new Vector3f (-23.9663f, 253.9438f, 183.0634f), new Vector3f (-23.9661f, 253.944f, 183.0636f),	//30 Health 6
	new Vector3f (-8f, 296f, 226.9f), new Vector3f (-7f, 298f, 227f), 							//15 The Upper Tower
	new Vector3f (189f, 319.135f, 542f), new Vector3f (193f, 320f, 543f), 						//16 The End
	};

	//============= AP Zipless splits ==============
	//An array to store the positions for each split 
	Vector3f [] spAPZipless = {
	new Vector3f (-404.9f, 113.6f, 61.9f), new Vector3f (-404.8f, 113.7f, 62f), 				//0 Starting Position
	new Vector3f (-271f, 187f, 74f), new Vector3f (-265f, 188f, 75f), 							//1 The Harbor District
	new Vector3f (-93f, 236.2f, 83f), new Vector3f (-88f, 238f, 88f), 							//2 The Palace
	new Vector3f (-35.5f, 232.3f, 146.9f), new Vector3f (-35.4f, 232.4f, 147f), 				//3 The Dagger of Time
	new Vector3f (-52.1f, 135.8f, 75.9f), new Vector3f (-52.0f, 135.9f, 76f), 					//4 The Sewers
	new Vector3f (-14.9972f, -112.8152f, 20.0732f), new Vector3f (-14.9970f, -112.8150f, 20.0734f), //5 Health 1
	new Vector3f (-71.4f, 9.6f, 44f), new Vector3f (-71.3f, 9.7f, 44.1f), 						//6 The Lower City
	new Vector3f (-317.8f, 329.8f, 96f), new Vector3f (-317.7f, 329.9f, 96.1f), 				//7 The Lower City Rooftops
	new Vector3f (-302.0919f, 370.8710f, -0.9788f), new Vector3f (-302.0917f, 370.8712f, -0.9786f), //8 Health 2
	new Vector3f (-261.3f, 318.9f, 46.9f), new Vector3f (-261.2f, 319.1f, 47f), 				//8 The Death of Klompa
	new Vector3f (-194f, 328f, 32.6f), new Vector3f (-190f, 329.7f, 33.6f), 					//9 The Eye of the Storm
	new Vector3f (-114f, 336f, 56f), new Vector3f (-110f, 338f, 56.1f), 						//10 The Temple Rooftops
	new Vector3f (-122f, 423f, 107f), new Vector3f (-118f, 424f, 109f), 						//11 The Temple
	new Vector3f (-187.3369f, 455.9863f, 78.0330f), new Vector3f (-187.3367f, 455.9865f, 78.0332f), //13 Health 3
	new Vector3f (-241.98f, 475f, 86.8f), new Vector3f (-241.9f, 477f, 86.9f), 					//12 The Market District
	new Vector3f (-168f, 512f, 88.9f), new Vector3f (-167.5f, 518f, 93f), 						//13 The Bowery
	new Vector3f (-104f, 548f, 105.9f), new Vector3f (-100f, 553f, 106.1f), 					//14 Death of Mahasti
	new Vector3f (-122f, 500f, 97.9f), new Vector3f (-120f, 505f, 98.1f),						//15 The Upper City
	new Vector3f (-55.0147f, 395.7608f, 72.0774f), new Vector3f (-55.0145f, 395.761f, 72.0776f),	//19 Health 4
	new Vector3f (-3f, 515f, 72f), new Vector3f (-1f, 519f, 75f),								//17 The Royal Workshop
	new Vector3f (60.1f, 477.5f, 80f), new Vector3f (60.2f, 477.6f, 80.1f), 					//18 The King's Road
	new Vector3f (91.7802f, 229.6516f, 70.9877f), new Vector3f (91.7804f, 229.6518f, 70.9879f), //19 The Death of the Twins
	new Vector3f (-30.1223f, 281.8893f, 104.0796f), new Vector3f (-30.1221f, 281.8895f, 104.0798f), //23 Health 5
	new Vector3f (13.5f, 204.4f, 184.9999f), new Vector3f (27.4f, 215.4f, 185.0001f), 			//21 The Structure's Mind
	new Vector3f (-28f, 250f, 20.9f), new Vector3f (-26.5f, 255f, 30f),							//22 The Well Of Ancestors	
	new Vector3f (-12.6f, 241.2f, 0.9f), new Vector3f (-12.5f, 241.3f, 1f), 					//23 The Labyrinth
	new Vector3f (-25.5f, 334f, 35.9f), new Vector3f (-25f, 336f, 36.1f), 						//24 The Underground Cave	
	new Vector3f (27f, 316.5f, 99.9f), new Vector3f (29f, 318f, 100.1f), 						//25 The Lower Tower
	new Vector3f (-5f, 316f, 139.9f), new Vector3f (-3f, 317.5f, 140.1f), 						//26 The Middle Tower
	new Vector3f (-23.9663f, 253.9438f, 183.0634f), new Vector3f (-23.9661f, 253.944f, 183.0636f),	//30 Health 6
	new Vector3f (-8f, 296f, 226.9f), new Vector3f (-7f, 298f, 227f), 							//27 The Upper Tower
	new Vector3f (4.4851f, 240.9438f, 304.2322f), new Vector3f (4.4853f, 240.944f, 304.2324f), 	//28 Death of the Vizier
	new Vector3f (189f, 319.135f, 542f), new Vector3f (193f, 320f, 543f), 						//29 The End
	}; 

	//============= AP NMG splits ==============
	//An array to store the positions for each split 
	Vector3f [] spAPNMG = {		
	new Vector3f (-404.9f, 113.6f, 61.9f), new Vector3f (-404.8f, 113.7f, 62f), 				//0 Starting Position
	new Vector3f (-271f, 187f, 74f), new Vector3f (-265f, 188f, 75f), 							//1 The Harbor District
	new Vector3f (-93f, 236.2f, 83f), new Vector3f (-88f, 238f, 88f), 							//2 The Palace
	new Vector3f (-35.5f, 232.3f, 146.9f), new Vector3f (-35.4f, 232.4f, 147f), 				//3 The Dagger of Time
	new Vector3f (-52.1f, 135.8f, 75.9f), new Vector3f (-52.0f, 135.9f, 76f), 					//4 The Sewers
	new Vector3f (-14.9972f, -112.8152f, 20.0732f), new Vector3f (-14.9970f, -112.8150f, 20.0734f), //5 Health 1
	new Vector3f (-71.4f, 9.6f, 44f), new Vector3f (-71.3f, 9.7f, 44.1f), 						//6 The Lower City
	new Vector3f (-317.8f, 329.8f, 96f), new Vector3f (-317.7f, 329.9f, 96.1f), 				//7 The Lower City Rooftops
	new Vector3f (-302.0919f, 370.8710f, -0.9788f), new Vector3f (-302.0917f, 370.8712f, -0.9786f), //8 Health 2
	new Vector3f (-261.3f, 318.9f, 46.9f), new Vector3f (-261.2f, 319.1f, 47f), 				//9 The Death of Klompa
	new Vector3f (-194f, 328f, 32.6f), new Vector3f (-190f, 329.7f, 33.6f), 					//10 The Eye of the Storm
	new Vector3f (-111.9f, 333.3f, 56f), new Vector3f (-111.7f, 333.4f, 56.1f), 				//11 The Temple Rooftops
	new Vector3f (-134f, 424.9f, 103f), new Vector3f (-133.8f, 425f, 103.1f), 					//12 The Temple
	new Vector3f (-187.3369f, 455.9863f, 78.0330f), new Vector3f (-187.3367f, 455.9865f, 78.0332f), //13 Health 3
	new Vector3f (-241.98f, 475f, 86.8f), new Vector3f (-241.9f, 477f, 86.9f), 					//14 The Market District
	new Vector3f (-170.6f, 506.7f, 98f), new Vector3f (-170.5f, 506.8f, 98.1f), 				//15 The Bowery
	new Vector3f (-152.6f, 549.8f, 91.9f), new Vector3f (-152.5f, 549.9f, 92f), 				//16 The Brothel
	new Vector3f (-121.4f, 579.1f, 103.9f), new Vector3f (-121.3f, 579.2f, 104f), 				//17 Death of Mahasti
	new Vector3f (-122.9f, 500.4f, 98.1f), new Vector3f (-122.8f, 500.5f, 98.2f), 				//18 The Upper City
	new Vector3f (-55.0147f, 395.7608f, 72.0774f), new Vector3f (-55.0145f, 395.761f, 72.0776f),	//19 Health 4
	new Vector3f (-15.5f, 456.6f, 84f), new Vector3f (-15.4f, 456.7f, 84.1f), 					//20 The Royal Workshop
	new Vector3f (60.1f, 477.5f, 80f), new Vector3f (60.2f, 477.6f, 80.1f), 					//21 The King's Road
	new Vector3f (91.7802f, 229.6516f, 70.9877f), new Vector3f (91.7804f, 229.6518f, 70.9879f), //21 The Death of the Twins
	new Vector3f (-30.1223f, 281.8893f, 104.0796f), new Vector3f (-30.1221f, 281.8895f, 104.0798f), //23 Health 5
	new Vector3f (13.5f, 204.4f, 184.9999f), new Vector3f (27.4f, 215.4f, 185.0001f), 			//24 The Structure's Mind
	new Vector3f (7.9f, 246.2f, 104f), new Vector3f (8f, 246.3f, 104.1f), 						//25 The Well Of Ancestors	
	new Vector3f (-12.6f, 241.2f, 0.9f), new Vector3f (-12.5f, 241.3f, 1f), 					//26 The Labyrinth
	new Vector3f (-25.5f, 334f, 35.9f), new Vector3f (-25f, 336f, 36.1f), 						//27 The Underground Cave	
	new Vector3f (27f, 316.5f, 99.9f), new Vector3f (29f, 318f, 100.1f), 						//28 The Lower Tower
	new Vector3f (-5f, 316f, 139.9f), new Vector3f (-3f, 317.5f, 140.1f), 						//29 The Middle Tower
	new Vector3f (-23.9663f, 253.9438f, 183.0634f), new Vector3f (-23.9661f, 253.944f, 183.0636f),	//30 Health 6
	new Vector3f (-8f, 296f, 226.9f), new Vector3f (-7f, 298f, 227f), 							//31 The Upper Tower
	new Vector3f (4.4851f, 240.9438f, 304.2322f), new Vector3f (4.4853f, 240.944f, 304.2324f), 	//32 Death of the Vizier
	new Vector3f (189f, 319.135f, 542f), new Vector3f (193f, 320f, 543f), 						//33 The End
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
