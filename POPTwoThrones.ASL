state("POP3"){

//The Prince's coords
	float xPos : 0x00A2A498, 0xC, 0x30;
	float yPos : 0x00A2A498, 0xC, 0x34;
	float zPos : 0x00A2A498, 0xC, 0x38;
	float xCam : 0x928548;
	float yCam : 0x928554;
}

startup{
}

start{
	//Detecting if the game has started on the ramparts.
	if(current.xPos >= -404.9 && current.xPos <= -404.8 && current.yCam <= 0.1082 && current.yCam >= 0.1080 && current.xCam <= 0.832 && current.xCam >= 0.8318)
		return true;
}

reset{
	//Detecting if the game has started on the ramparts.
		if(current.xPos >= -443 && current.xPos <= -442.9 && current.yCam == 0)
			return true;
}

split{

//List of T2T Splits across categories
	
	vars.TheRamparts = (Func <bool>)(() => {
		if(current.xPos >= -271 && current.xPos <= -265 &&
		   current.yPos >= 187	&& current.yPos <= 188  &&
		   current.zPos >= 74	&& current.zPos <= 75)
			return true;
		return false;
	});
	vars.HarbourDistrict = (Func <bool>)(() => {
		if(current.xPos >= -93   && current.xPos <= -88 &&
		   current.yPos >= 236.2 && current.yPos <= 238 &&
		   current.zPos >= 83	 && current.zPos <= 88)
			return true;
		return false;
	});
	vars.ThePalace = (Func <bool>)(() => {
		if(current.xPos >= -35.5 && current.xPos <= -35.4 &&
		   current.yPos >= 232.3 && current.yPos <= 232.4 &&
		   current.zPos >= 146.9 && current.zPos <= 147)
			return true;
		return false;
	});
	vars.TrappedHallway = (Func <bool>)(() => {
		if(current.xPos >= -52.1 && current.xPos <= -52.0 &&
		   current.yPos >= 135.8 && current.yPos <= 135.9 &&
		   current.zPos >= 75.8  && current.zPos <= 76)
			return true;
		return false;
	});
	vars.TheSewerz = (Func <bool>)(() => {
		if(current.xPos >= -100 && current.xPos <= -96 &&
		   current.yPos >= -83  && current.yPos <= -79 &&
		   current.zPos >= 19.9 && current.zPos <= 20)
			return true;
		return false;
	});
	vars.TheSewers = (Func <bool>)(() => {
		if(current.xPos >= -89.0 && current.xPos <= -88.0 &&
		   current.yPos >= -15.2 && current.yPos <= -14.7 &&
		   current.zPos >= 4.9	 && current.zPos <= 5.1)
			return true;
		return false;
	});
	vars.TheFortress = (Func <bool>)(() => {
		if(current.xPos >= -71.4 && current.xPos <= -71.3 &&
		   current.yPos >= 9.6   && current.yPos <= 9.7   &&
		   current.zPos >= 44    && current.zPos <= 44.1)
			return true;
		return false;
	});
	vars.Chariot1 = (Func <bool>)(() => {
		if(current.xPos >= -443.37 && current.xPos <= -443.36 &&
		   current.yPos >= 355.80  && current.yPos <= 355.81  &&
		   current.zPos >= 57.71 && current.zPos <= 57.72)
			return true;
		return false;
	});
	vars.LowerCity = (Func <bool>)(() => {
		if(current.xPos >= -319 && current.xPos <= -316.5 &&
		   current.yPos >= 317  && current.yPos <= 332.6  &&
		   current.zPos >= 95.1 && current.zPos <= 98)
			return true;
		return false;
	});
	vars.ArenaDeload = (Func <bool>)(() => {
		if(current.xPos >= -256.1 && current.xPos <= -251.9  &&
		   current.yPos >= 358    && current.yPos <= 361.5 &&
		   current.zPos >= 53.9     && current.zPos <= 63.3)
			return true;
		return false;
	});
	vars.LowerCityRooftops = (Func <bool>)(() => {
		if(current.xPos >= -261.5 && current.xPos <= -261  &&
		   current.yPos >= 318    && current.yPos <= 319.5 &&
		   current.zPos >= 46     && current.zPos <= 48)
			return true;
		return false;
	});
	vars.LCRooftopZips = (Func <bool>)(() => {
		if(current.xPos >= -246  && current.xPos <= -241.5 &&
		   current.yPos >= 373.5 && current.yPos <= 383.6  &&
		   current.zPos >= 66    && current.zPos <= 69)
			return true;
		return false;
	});
	vars.TheBalconies = (Func <bool>)(() => {
		if(current.xPos >= -194 && current.xPos <= -190  &&
		   current.yPos >= 328  && current.yPos <= 329.7 &&
		   current.zPos >= 32.6 && current.zPos <= 33.6)
			return true;
		return false;
	});
	vars.DarkAlley = (Func <bool>)(() => {
		if(current.xPos >= -114 && current.xPos <= -110 &&
		   current.yPos >= 328  && current.yPos <= 338  &&
		   current.zPos >= 55   && current.zPos <= 59)
			return true;
		return false;
	});
	vars.TheTempleRooftops = (Func <bool>)(() => {
		if(current.xPos >= -122.6 && current.xPos <= -117.7 &&
		   current.yPos >= 421.6  && current.yPos <= 423    &&
		   current.zPos >= 107    && current.zPos <= 108.1)
			return true;
		return false;
	});
	vars.TheTemple = (Func <bool>)(() => {
		if(current.xPos >= -212.2 && current.xPos <= -211.9 &&
		   current.yPos >= 419.0  && current.yPos <= 419.8  &&
		   current.zPos >= 81     && current.zPos <= 82)
			return true;
		return false;
	});
	vars.TheMarketplace= (Func <bool>)(() => {
		if(current.xPos >= -213 && current.xPos <= -207 &&
		   current.yPos >= 484  && current.yPos <= 490  &&
		   current.zPos >= 101  && current.zPos <= 103)
			return true;
		return false;
	});
	vars.MarketDistrict = (Func <bool>)(() => {
		if(current.xPos >= -185.5 && current.xPos <= -175.5 &&
		   current.yPos >= 524    && current.yPos <= 530    &&
		   current.zPos >= 90     && current.zPos <= 92)
			return true;
		return false;
	});
	vars.TheBrothel = (Func <bool>)(() => {
		if(current.xPos >= -152.3 && current.xPos <= -152.0 &&
		   current.yPos >= 549.8  && current.yPos <= 549.9  &&
		   current.zPos >= 91.8   && current.zPos <= 92)
			return true;
		return false;
	});
	vars.ThePlaza = (Func <bool>)(() => {
		if(current.xPos >= -104  && current.xPos <= -100 &&
		   current.yPos >= 548   && current.yPos <= 553  &&
		   current.zPos >= 105.9 && current.zPos <= 106.1)
			return true;
		return false;
	});
	vars.TheUpperCity = (Func <bool>)(() => {
		if(current.xPos >= -124.5 && current.xPos <= -122.5 &&
		   current.yPos >= 500    && current.yPos <= 505    &&
		   current.zPos >= 97     && current.zPos <= 99)
			return true;
		return false;
	});
	vars.CityGarderns = (Func <bool>)(() => {
		if(current.xPos >= -63.5 && current.xPos <= -63.4 &&
		   current.yPos >= 389.7 && current.yPos <= 389.8 &&
		   current.zPos >= 85.2  && current.zPos <= 85.3)
			return true;
		return false;
	});
	vars.ThePromenade = (Func <bool>)(() => {
		if(current.xPos >= -3  && current.xPos <= -1  &&
		   current.yPos >= 515 && current.yPos <= 519 &&
		   current.zPos >= 72  && current.zPos <= 75)
			return true;
		return false;
	});
	vars.RoyalWorkshop = (Func <bool>)(() => {
		if(current.xPos >= 58  && current.xPos <= 62  &&
		   current.yPos >= 470 && current.yPos <= 480 &&
		   current.zPos >= 79  && current.zPos <= 81)
			return true;
		return false;
	});
	vars.KingsRoad = (Func <bool>)(() => {
		if(current.xPos >= 91.9289  && current.xPos <= 91.9290  &&
		   current.yPos >= 230.0479 && current.yPos <= 230.0480 &&
		   current.zPos >= 70.9877  && current.zPos <= 70.9879)
			return true;
		return false;
	});
	vars.KingzRoad = (Func <bool>)(() => {
		if(current.xPos >= 53  && current.xPos <= 70  &&
		   current.yPos >= 240 && current.yPos <= 250 &&
		   current.zPos >= 70 && current.zPos <= 73)
			return true;	
		return false;
	});
	vars.PalaceEntrance = (Func <bool>)(() => {
		if(current.xPos >= 30.8  && current.xPos <= 30.9  &&
		   current.yPos >= 271.2 && current.yPos <= 271.3 &&
		   current.zPos >= 126   && current.zPos <= 126.1)
			return true;	
		return false;
	});
	vars.HangingGardens = (Func <bool>)(() => {
		if(current.xPos >= 26  && current.xPos <= 28  &&
		   current.yPos >= 211 && current.yPos <= 213 &&
		   current.zPos >= 191 && current.zPos <= 193)
			return true;
		return false;
	});
	vars.StructuresMind = (Func <bool>)(() => {
		if(current.xPos >= -34 && current.xPos <= -27 &&
		   current.yPos >= 240 && current.yPos <= 250 &&
		   current.zPos >= 178 && current.zPos <= 180)
			return true;
		return false;
	});
	vars.StructurezMind = (Func <bool>)(() => {
		if(current.xPos >= 5   && current.xPos <= 12  &&
		   current.yPos >= 243 && current.yPos <= 265 &&
		   current.zPos >= 104 && current.zPos <= 104.1)
			return true;	
		return false;
	});
	vars.WellofZipless = (Func <bool>)(() => {
		if(current.xPos >= -28  && current.xPos <= -26.5 &&
		   current.yPos >= 250  && current.yPos <= 255   &&
		   current.zPos >= 20.9 && current.zPos <= 30)
			return true;	
		return false;
	});
	vars.BottomofWell = (Func <bool>)(() => {
		if(current.xPos >= -21.35 && current.xPos <= -21.34 &&
		   current.yPos >= 252.67 && current.yPos <= 252.68 &&
		   current.zPos >= 20.95   && current.zPos <= 20.96)
			return true;
		return false;
	});
	vars.WellofAncestors = (Func <bool>)(() => {
		if(current.xPos >= -12.6 && current.xPos <= -12.5 &&
		   current.yPos >= 241.2 && current.yPos <= 241.3 &&
		   current.zPos >= 0.9   && current.zPos <= 1)
			return true;
		return false;
	});
	vars.CaveDeath = (Func <bool>)(() => {
		if(current.xPos >= 5.99 && current.xPos <= 6.00 &&
		   current.yPos >= 306.96   && current.yPos <= 306.97 &&
		   current.zPos >= 42  && current.zPos <= 42.01)
			return true;	
		return false;
	});
	vars.TheLabyrinth = (Func <bool>)(() => {
		if(current.xPos >= -25.5 && current.xPos <= -23 &&
		   current.yPos >= 325   && current.yPos <= 338 &&
		   current.zPos >= 35.9  && current.zPos <= 36.1)
			return true;	
		return false;
	});
	vars.UndergroundCave = (Func <bool>)(() => {
		if(current.xPos >= -11 && current.xPos <= -9  &&
		   current.yPos >= 327 && current.yPos <= 334 &&
		   current.zPos >= 73  && current.zPos <= 74)
			return true;
		return false;
	});
	vars.UndergroundCaveZipnt = (Func <bool>)(() => {
		if(current.xPos >= 27    && current.xPos <= 29  &&
		   current.yPos >= 316.5 && current.yPos <= 318 &&
		   current.zPos >= 99.9  && current.zPos <= 100.1)
			return true;	
		return false;
	});
	vars.LowerTower = (Func <bool>)(() => {
		if(current.xPos >= -5    && current.xPos <= -3    &&
		   current.yPos >= 316   && current.yPos <= 317.5 &&
		   current.zPos >= 139.9 && current.zPos <= 140.1)
			return true;
		return false;
	});
	vars.MiddleTower = (Func <bool>)(() => {
		if(current.xPos >= -18   && current.xPos <= -12 &&
		   current.yPos >= 303   && current.yPos <= 305 &&
		   current.zPos >= 184.8 && current.zPos <= 185.1)
			return true;
		return false;
	});
	vars.UpperTower = (Func <bool>)(() => {
		if(current.xPos >= -8    && current.xPos <= -7  &&
		   current.yPos >= 296   && current.yPos <= 298 &&
		   current.zPos >= 226.9 && current.zPos <= 227)
			return true;		
		return false;
	});
	vars.TheTerrace = (Func <bool>)(() => {
		if(current.xPos >= -7.2  && current.xPos <= -6.9  &&
		   current.yPos >= 245.6 && current.yPos <= 245.9 &&
		   current.zPos >= 677   && current.zPos <= 679)
			return true;		
		return false;
	});
	vars.MentalRealm = (Func <bool>)(() => {
		if(current.xPos >= 189     && current.xPos <= 193 &&
		   current.yPos >= 319.135 && current.yPos <= 320 &&
		   current.zPos >= 542	   && current.zPos <= 543)
			return true;		
		return false;
	});
	vars.T2TLU1 = (Func <bool>)(() => {
		if(current.xPos >= -14.9972  && current.xPos <= -14.9970  &&
		   current.yPos >= -112.8152 && current.yPos <= -112.8150 &&
		   current.zPos >= 20.0732   && current.zPos <= 20.0734)
			return true;		
		return false;
	});
	vars.T2TLU2 = (Func <bool>)(() => {
		if(current.xPos >= -302.0919 && current.xPos <= -302.0917 &&
		   current.yPos >= 370.8710  && current.yPos <= 370.8712  &&
		   current.zPos >= 52.858 && current.zPos <= 52.8582)
			return true;		
		return false;
	});
	vars.T2TLU3 = (Func <bool>)(() => {
		if(current.xPos >= -187.3369 && current.xPos <= -187.3367 &&
		   current.yPos >= -455.9863 && current.yPos <= 455.9865  &&
		   current.zPos >= 78.0330   && current.zPos <= 78.0332)
			return true;		
		return false;
	});
	vars.T2TLU4 = (Func <bool>)(() => {
		if(current.xPos >= -55.0147 && current.xPos <= -55.0145 &&
		   current.yPos >= 395.7608 && current.yPos <= 395.761  &&
		   current.zPos >= 72.0774  && current.zPos <= 72.0776)
			return true;		
		return false;
	});
	vars.T2TLU5 = (Func <bool>)(() => {
		if(current.xPos >= -30.1223 && current.xPos <= -30.1221 &&
		   current.yPos >= 281.8893 && current.yPos <= 281.8895 &&
		   current.zPos >= 104.0796 && current.zPos <= 104.0798)
			return true;
		return false;
	});
	vars.T2TLU6 = (Func <bool>)(() => {
		if(current.xPos >= -23.9663 && current.xPos <= -23.9661 &&
		   current.yPos >= 253.9438 && current.yPos <= 253.944  &&
		   current.zPos >= 183.0634 && current.zPos <= 183.0636)
			return true;		
		return false;
	});
	
	//Checking Categories
	
	switch(timer.Run.GetExtendedCategoryName())
	{
		case "Any% (Standard)":
			switch (timer.CurrentSplitIndex)
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
			//Finish Chariot 1
			case 4:	
				if(vars.Chariot1())
					return true;	
				break;
			//Arena Deload
			case 5:	
				if(vars.ArenaDeload())
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
			//Well Death
			case 12:	
				if(vars.BottomofWell())
					return true;
				break;
			//Exit Cave Death
			case 13:	
				if(vars.CaveDeath())
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
		
		case "Any% (Zipless)":
			switch (timer.CurrentSplitIndex)
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
		
		case "Any% (No Major Glitches)":
			switch (timer.CurrentSplitIndex)
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
		
		case "All Powers (Standard)":
			switch (timer.CurrentSplitIndex)
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
		
		case "All Powers (Zipless)":
			switch (timer.CurrentSplitIndex)
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
		
		case "All Powers (No Major Glitches)":
			switch (timer.CurrentSplitIndex)
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
