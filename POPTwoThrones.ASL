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
	//Detecting if the game has started on the boat.
	if(current.xPos >= -404.9 && current.xPos <= -404.8 && current.yCam <= 0.1082 && current.yCam >= 0.1080 && current.xCam <= 0.832 && current.xCam >= 0.8318)
		return true;
}

reset{
	//Detecting if the game has started on the boat.
		if(current.xPos >= -443 && current.xPos <= -442.9 && current.yCam == 0)
			return true;
}

split{
	
	switch(timer.Run.GetExtendedCategoryName())
	{
		case "Any% (Normal)":
			switch (timer.CurrentSplitIndex)
			{
			//The Harbor District
			case 0:
				if(current.xPos >= -271			&& current.yPos >= 187			&& current.zPos >= 74			&& current.xPos <= -265			&& current.yPos <= 188			&& current.zPos <= 75)
					return true;
				break;
			//The Palace
			case 1:	
				if(current.xPos >= -93			&& current.yPos >= 236.2		&& current.zPos >= 83			&& current.xPos <= -88			&& current.yPos <= 238			&& current.zPos <= 88)
					return true;	
				break;
			//The Dagger of Time
			case 2:	
				if(current.xPos >= -35.5		&& current.yPos >= 232.3		&& current.zPos >= 146.9		&& current.xPos <= -35.4		&& current.yPos <= 232.4		&& current.zPos <= 147)
					return true;	
				break;
			//The Tunnels
			case 3:	
				if(current.xPos >= -100			&& current.yPos >= -83			&& current.zPos >= 19.9			&& current.xPos <= -96			&& current.yPos <= -79			&& current.zPos <= 20)
					return true;	
				break;
			//The Lower City Rooftops
			case 4:	
				if(current.xPos >= -319			&& current.yPos >= 317			&& current.zPos >= 95.1			&& current.xPos <= -316.5		&& current.yPos <= 332.6		&& current.zPos <= 98)
					return true;	
				break;
			//The Death of Klompa
			case 5:	
				if(current.xPos >= -246			&& current.yPos >= 373.5		&& current.zPos >= 66			&& current.xPos <= -241.5		&& current.yPos <= 383.6		&& current.zPos <= 69)
					return true;	
				break;
			//The Temple
			case 6:	
				if(current.xPos >= -122.6		&& current.yPos >= 421.6		&& current.zPos >= 107			&& current.xPos <= -117.7		&& current.yPos <= 423			&& current.zPos <= 108.1)
					return true;	
				break;
			//The Market District
			case 7:	
				if(current.xPos >= -213			&& current.yPos >= 484			&& current.zPos >= 101			&& current.xPos <= -207			&& current.yPos <= 490			&& current.zPos <= 103)
					return true;	
				break;
			//The Death of Mahasti
			case 8:	
				if(current.xPos >= -104			&& current.yPos >= 548			&& current.zPos >= 105.9		&& current.xPos <= -100			&& current.yPos <= 553			&& current.zPos <= 106.1)
					return true;	
				break;
			//The Stone Guardian
			case 9:	
				if(current.xPos >= -63.5		&& current.yPos >= 389.7		&& current.zPos >= 85.2			&& current.xPos <= -63.4		&& current.yPos <= 389.8		&& current.zPos <= 85.3)
					return true;	
				break;
			//The King's Road
			case 10:	
				if(current.xPos >= 58			&& current.yPos >= 470			&& current.zPos >= 79			&& current.xPos <= 62			&& current.yPos <= 480			&& current.zPos <= 81)
					return true;	
				break;
			//The Death of the Twins
			case 11:	
				if(current.xPos >= 53			&& current.yPos >= 240			&& current.zPos >= 70			&& current.xPos <= 70			&& current.yPos <= 250			&& current.zPos <= 73)
					return true;	
				break;
			//The Well of Ancestors
			case 12:	
				if(current.xPos >= 5			&& current.yPos >= 243			&& current.zPos >= 104			&& current.xPos <= 12			&& current.yPos <= 265			&& current.zPos <= 104.1)
					return true;	
				break;
			//The Underground Cave
			case 13:	
				if(current.xPos >= -25.5		&& current.yPos >= 332			&& current.zPos >= 35.9			&& current.xPos <= -23			&& current.yPos <= 338			&& current.zPos <= 36.1)
					return true;	
				break;
			//The Upper Tower
			case 14:	
				if(current.xPos >= -8			&& current.yPos >= 296			&& current.zPos >= 226.9		&& current.xPos <= -7			&& current.yPos <= 298			&& current.zPos <= 227)
					return true;	
				break;
			//The End
			case 15:	
				if(current.xPos >= 189			&& current.yPos >= 319.135		&& current.zPos >= 542			&& current.xPos <= 193			&& current.yPos <= 320			&& current.zPos <= 543)
					return true;	
				break;
		}
		break;
		
		case "Any% (Zipless)":
			switch (timer.CurrentSplitIndex)
			{
			//The Harbor District
			case 0:
				if(current.xPos >= -271			&& current.yPos >= 187			&& current.zPos >= 74			&& current.xPos <= -265			&& current.yPos <= 188			&& current.zPos <= 75)
					return true;
				break;
			//The Palace
			case 1:	
				if(current.xPos >= -93			&& current.yPos >= 236.2		&& current.zPos >= 83			&& current.xPos <= -88			&& current.yPos <= 238			&& current.zPos <= 88)
					return true;	
				break;
			//The Dagger of Time
			case 2:	
				if(current.xPos >= -35.5		&& current.yPos >= 232.3		&& current.zPos >= 146.9		&& current.xPos <= -35.4		&& current.yPos <= 232.4		&& current.zPos <= 147)
					return true;	
				break;
			//The Sewers
			case 3:
				if(current.xPos >= -52.1		&& current.yPos >= 135.8		&& current.zPos >= 75.9			&& current.xPos <= -52.0		&& current.yPos <= 135.9		&& current.zPos <= 76)
					return true;
				break;
			//The Tunnels
			case 4:
				if(current.xPos >= -88.6		&& current.yPos >= -14.8		&& current.zPos >= 4.9			&& current.xPos <= -88.5		&& current.yPos <= -14.7		&& current.zPos <= 5.1)
					return true;
				break;
			//The Lower City
			case 5:
				if(current.xPos >= -71.4		&& current.yPos >= 9.6			&& current.zPos >= 44			&& current.xPos <= -71.3		&& current.yPos <= 9.7			&& current.zPos <= 44.1)
					return true;
				break;
			//The Lower City Rooftops
			case 6:
				if(current.xPos >= -319			&& current.yPos >= 317			&& current.zPos >= 95.1			&& current.xPos <= -316.5		&& current.yPos <= 332.6		&& current.zPos <= 98)
					return true;
				break;
			//The Death of Klompa
			case 7:
				if(current.xPos >= -261.5		&& current.yPos >= 318			&& current.zPos >= 46			&& current.xPos <= -261			&& current.yPos <= 319.5		&& current.zPos <= 48)
					return true;
				break;
			//The Eye of the Storm
			case 8:
				if(current.xPos >= -194			&& current.yPos >= 328			&& current.zPos >= 32.6			&& current.xPos <= -190			&& current.yPos <= 329.7		&& current.zPos <= 33.6)
					return true;
				break;
			//The Temple Rooftops
			case 9:
				if(current.xPos >= -114			&& current.yPos >= 328			&& current.zPos >= 55			&& current.xPos <= -110			&& current.yPos <= 338			&& current.zPos <= 59)
					return true;
				break;
			//The Temple
			case 10:
				if(current.xPos >= -122.6		&& current.yPos >= 421.6		&& current.zPos >= 107			&& current.xPos <= -117.7		&& current.yPos <= 423			&& current.zPos <= 108.1)
					return true;
				break;
			//The Market District
			case 11:
				if(current.xPos >= -213			&& current.yPos >= 484			&& current.zPos >= 101			&& current.xPos <= -207			&& current.yPos <= 490			&& current.zPos <= 103)
					return true;
				break;
			//The Bowery
			case 12:
				if(current.xPos >= -185.5		&& current.yPos >= 524			&& current.zPos >= 90			&& current.xPos <= -175.5		&& current.yPos <= 530			&& current.zPos <= 92)
					return true;
				break;
			//The Death of Mahasti
			case 13:
				if(current.xPos >= -104			&& current.yPos >= 548			&& current.zPos >= 104			&& current.xPos <= -100			&& current.yPos <= 553.9		&& current.zPos <= 106.1)
					return true;
				break;
			//The Upper City
			case 14:
				if(current.xPos >= -124.5		&& current.yPos >= 500			&& current.zPos >= 97			&& current.xPos <= -122.5		&& current.yPos <= 505			&& current.zPos <= 99)
					return true;
				break;
			//The Stone Guardian
			case 15:
				if(current.xPos >= -63.5		&& current.yPos >= 389.7		&& current.zPos >= 85.2			&& current.xPos <= -63.4		&& current.yPos <= 389.8		&& current.zPos <= 85.3)
					return true;
				break;
			//The Royal Workshop
			case 16:
				if(current.xPos >= -3			&& current.yPos >= 515			&& current.zPos >= 72			&& current.xPos <= -1			&& current.yPos <= 519			&& current.zPos <= 75)
					return true;
				break;
			//The King's Road
			case 17:
				if(current.xPos >= 58			&& current.yPos >= 470			&& current.zPos >= 79			&& current.xPos <= 62			&& current.yPos <= 480			&& current.zPos <= 81)
					return true;
				break;
			//The Death of the Twins
			case 18:
				if(current.xPos >= 91.7802		&& current.yPos >= 229.6516		&& current.zPos >= 70.9877		&& current.xPos <= 91.7804		&& current.yPos <= 229.6518		&& current.zPos <= 70.9879)
					return true;
				break;
			//The Elevator
			case 19:
				if(current.xPos >= 30.8			&& current.yPos >= 271.2		&& current.zPos >= 126			&& current.xPos <= 30.9			&& current.yPos <= 271.3		&& current.zPos <= 126.1)
					return true;
				break;
			//The Structure's Mind
			case 20:
				if(current.xPos >= 13.5			&& current.yPos >= 204.4		&& current.zPos >= 184.9999		&& current.xPos <= 27.4			&& current.yPos <= 215.4		&& current.zPos <= 185.0001)
					return true;
				break;
			//The Well of Ancestors
			case 21:
				if(current.xPos >= -28			&& current.yPos >= 250			&& current.zPos >= 20.9			&& current.xPos <= -26.5		&& current.yPos <= 255			&& current.zPos <= 30)
					return true;
				break;
			//The Labyrinth
			case 22:
				if(current.xPos >= -12.6		&& current.yPos >= 241.2		&& current.zPos >= 0.9			&& current.xPos <= -12.5		&& current.yPos <= 241.3		&& current.zPos <= 1)
					return true;
				break;
			//The Underground Cave
			case 23:
				if(current.xPos >= -25.5		&& current.yPos >= 332			&& current.zPos >= 35.9			&& current.xPos <= -23			&& current.yPos <= 338			&& current.zPos <= 36.1)
					return true;
				break;
			//The Lower Tower
			case 24:
				if(current.xPos >= 27			&& current.yPos >= 316.5		&& current.zPos >= 99.9			&& current.xPos <= 29			&& current.yPos <= 318			&& current.zPos <= 100.1)
					return true;
				break;
			//The Middle Tower
			case 25:
				if(current.xPos >= -5			&& current.yPos >= 316			&& current.zPos >= 139.9		&& current.xPos <= -3			&& current.yPos <= 317.5		&& current.zPos <= 140.1)
					return true;
				break;
			//The Upper Tower
			case 26:
				if(current.xPos >= -8			&& current.yPos >= 296			&& current.zPos >= 226.9		&& current.xPos <= -7			&& current.yPos <= 298			&& current.zPos <= 227)
					return true;
				break;
			//The Death of the Vizier
			case 27:
				if(current.xPos >= -7.2			&& current.yPos >= 245.6		&& current.zPos >= 677			&& current.xPos <= -6.9			&& current.yPos <= 245.9		&& current.zPos <= 679)
					return true;
				break;
			//The End
			case 28:	
				if(current.xPos >= 189			&& current.yPos >= 319.135		&& current.zPos >= 542			&& current.xPos <= 193			&& current.yPos <= 320			&& current.zPos <= 543)
					return true;	
				break;
		}
		break;
		
		case "Any% (No Major Glitches)":
			switch (timer.CurrentSplitIndex)
			{
			//The Harbor District
			case 0:
				if(current.xPos >= -271			&& current.yPos >= 187			&& current.zPos >= 74			&& current.xPos <= -265			&& current.yPos <= 188			&& current.zPos <= 75)
					return true;
				break;
			//The Palace
			case 1:	
				if(current.xPos >= -93			&& current.yPos >= 236.2		&& current.zPos >= 83			&& current.xPos <= -88			&& current.yPos <= 238			&& current.zPos <= 88)
					return true;	
				break;
			//The Dagger of Time
			case 2:	
				if(current.xPos >= -35.5		&& current.yPos >= 232.3		&& current.zPos >= 146.9		&& current.xPos <= -35.4		&& current.yPos <= 232.4		&& current.zPos <= 147)
					return true;	
				break;
			//The Sewers
			case 3:
				if(current.xPos >= -52.1		&& current.yPos >= 135.8		&& current.zPos >= 75.9			&& current.xPos <= -52.0		&& current.yPos <= 135.9		&& current.zPos <= 76)
					return true;
				break;
			//The Tunnels
			case 4:
				if(current.xPos >= -88.6		&& current.yPos >= -14.8		&& current.zPos >= 4.9			&& current.xPos <= -88.5		&& current.yPos <= -14.7		&& current.zPos <= 5.1)
					return true;
				break;
			//The Lower City
			case 5:
				if(current.xPos >= -71.4		&& current.yPos >= 9.6			&& current.zPos >= 44			&& current.xPos <= -71.3		&& current.yPos <= 9.7			&& current.zPos <= 44.1)
					return true;
				break;
			//The Lower City Rooftops
			case 6:
				if(current.xPos >= -319			&& current.yPos >= 317			&& current.zPos >= 95.1			&& current.xPos <= -316.5		&& current.yPos <= 332.6		&& current.zPos <= 98)
					return true;
				break;
			//The Death of Klompa
			case 7:
				if(current.xPos >= -261.5		&& current.yPos >= 318			&& current.zPos >= 46			&& current.xPos <= -261			&& current.yPos <= 319.5		&& current.zPos <= 48)
					return true;
				break;
			//The Eye of the Storm
			case 8:
				if(current.xPos >= -194			&& current.yPos >= 328			&& current.zPos >= 32.6			&& current.xPos <= -190			&& current.yPos <= 329.7		&& current.zPos <= 33.6)
					return true;
				break;
			//The Temple Rooftops
			case 9:
				if(current.xPos >= -114			&& current.yPos >= 328			&& current.zPos >= 55			&& current.xPos <= -110			&& current.yPos <= 338			&& current.zPos <= 59)
					return true;
				break;
			//The Temple
			case 10:
				if(current.xPos >= -122.6		&& current.yPos >= 421.6		&& current.zPos >= 107			&& current.xPos <= -117.7		&& current.yPos <= 423			&& current.zPos <= 108.1)
					return true;
				break;
			//The Market District
			case 11:
				if(current.xPos >= -213			&& current.yPos >= 484			&& current.zPos >= 101			&& current.xPos <= -207			&& current.yPos <= 490			&& current.zPos <= 103)
					return true;
				break;
			//The Bowery
			case 12:
				if(current.xPos >= -185.5		&& current.yPos >= 524			&& current.zPos >= 90			&& current.xPos <= -175.5		&& current.yPos <= 530			&& current.zPos <= 92)
					return true;
				break;
			//The Brothel
			case 13:
				if(current.xPos >= -152.6		&& current.yPos >= 549.8		&& current.zPos >= 91.9			&& current.xPos <= -152.5		&& current.yPos <= 549.9		&& current.zPos <= 92)
					return true;
				break;
			//The Death of Mahasti
			case 14:
				if(current.xPos >= -104			&& current.yPos >= 548			&& current.zPos >= 104			&& current.xPos <= -100			&& current.yPos <= 553.9		&& current.zPos <= 106.1)
					return true;
				break;
			//The Upper City
			case 15:
				if(current.xPos >= -124.5		&& current.yPos >= 500			&& current.zPos >= 97			&& current.xPos <= -122.5		&& current.yPos <= 505			&& current.zPos <= 99)
					return true;
				break;
			//The Stone Guardian
			case 16:
				if(current.xPos >= -63.5		&& current.yPos >= 389.7		&& current.zPos >= 85.2			&& current.xPos <= -63.4		&& current.yPos <= 389.8		&& current.zPos <= 85.3)
					return true;
				break;
			//The Royal Workshop
			case 17:
				if(current.xPos >= -3			&& current.yPos >= 515			&& current.zPos >= 72			&& current.xPos <= -1			&& current.yPos <= 519			&& current.zPos <= 75)
					return true;
				break;
			//The King's Road
			case 18:
				if(current.xPos >= 58			&& current.yPos >= 470			&& current.zPos >= 79			&& current.xPos <= 62			&& current.yPos <= 480			&& current.zPos <= 81)
					return true;
				break;
			//The Death of the Twins
			case 19:
				if(current.xPos >= 91.7802		&& current.yPos >= 229.6516		&& current.zPos >= 70.9877		&& current.xPos <= 91.7804		&& current.yPos <= 229.6518		&& current.zPos <= 70.9879)
					return true;
				break;
			//The Elevator
			case 20:
				if(current.xPos >= 30.8			&& current.yPos >= 271.2		&& current.zPos >= 126			&& current.xPos <= 30.9			&& current.yPos <= 271.3		&& current.zPos <= 126.1)
					return true;
				break;
			//The Structure's Mind
			case 21:
				if(current.xPos >= 13.5			&& current.yPos >= 204.4		&& current.zPos >= 184.9999		&& current.xPos <= 27.4			&& current.yPos <= 215.4		&& current.zPos <= 185.0001)
					return true;
				break;
			//The Well of Ancestors
			case 22:
				if(current.xPos >= -28			&& current.yPos >= 250			&& current.zPos >= 20.9			&& current.xPos <= -26.5		&& current.yPos <= 255			&& current.zPos <= 30)
					return true;
				break;
			//The Labyrinth
			case 23:
				if(current.xPos >= -12.6		&& current.yPos >= 241.2		&& current.zPos >= 0.9			&& current.xPos <= -12.5		&& current.yPos <= 241.3		&& current.zPos <= 1)
					return true;
				break;
			//The Underground Cave
			case 24:
				if(current.xPos >= -25.5		&& current.yPos >= 332			&& current.zPos >= 35.9			&& current.xPos <= -23			&& current.yPos <= 338			&& current.zPos <= 36.1)
					return true;
				break;
			//The Lower Tower
			case 25:
				if(current.xPos >= 27			&& current.yPos >= 316.5		&& current.zPos >= 99.9			&& current.xPos <= 29			&& current.yPos <= 318			&& current.zPos <= 100.1)
					return true;
				break;
			//The Middle Tower
			case 26:
				if(current.xPos >= -5			&& current.yPos >= 316			&& current.zPos >= 139.9		&& current.xPos <= -3			&& current.yPos <= 317.5		&& current.zPos <= 140.1)
					return true;
				break;
			//The Upper Tower
			case 27:
				if(current.xPos >= -8			&& current.yPos >= 296			&& current.zPos >= 226.9		&& current.xPos <= -7			&& current.yPos <= 298			&& current.zPos <= 227)
					return true;
				break;
			//The Death of the Vizier
			case 28:
				if(current.xPos >= -4.485		&& current.yPos >= 240.943		&& current.zPos >= 304.232		&& current.xPos <= -4.487		&& current.yPos <= 240.945		&& current.zPos <= 304.234)
					return true;
				break;
			//The End
			case 29:	
				if(current.xPos >= 189			&& current.yPos >= 319.135		&& current.zPos >= 542			&& current.xPos <= 193			&& current.yPos <= 320			&& current.zPos <= 543)
					return true;	
				break;
		}
		break;
		
		case "All Powers (Normal)":
			switch (timer.CurrentSplitIndex)
			{
			//The Harbor District
			case 0:
				if(current.xPos >= -271			&& current.yPos >= 187			&& current.zPos >= 74			&& current.xPos <= -265			&& current.yPos <= 188			&& current.zPos <= 75)
					return true;
				break;
			//The Palace
			case 1:	
				if(current.xPos >= -93			&& current.yPos >= 236.2		&& current.zPos >= 83			&& current.xPos <= -88			&& current.yPos <= 238			&& current.zPos <= 88)
					return true;	
				break;
			//The Dagger of Time
			case 2:	
				if(current.xPos >= -35.5		&& current.yPos >= 232.3		&& current.zPos >= 146.9		&& current.xPos <= -35.4		&& current.yPos <= 232.4		&& current.zPos <= 147)
					return true;	
				break;
			//Life Upgrade 1
			case 3:	
				if(current.xPos >= -14.9972		&& current.yPos >= -112.8152	&& current.zPos >= 20.0732		&& current.xPos <= -14.9970		&& current.yPos <= -112.8150	&& current.zPos <= 20.0734)
					return true;	
				break;
			//The Lower City Rooftops
			case 4:	
				if(current.xPos >= -319			&& current.yPos >= 317			&& current.zPos >= 95.1			&& current.xPos <= -316.5		&& current.yPos <= 332.6		&& current.zPos <= 98)
					return true;	
				break;
			//Life Upgrade 2
			case 5:	
				if(current.xPos >= -302.0919	&& current.yPos >= 370.8710		&& current.zPos >= 52.858		&& current.xPos <= -302.0917	&& current.yPos <= 370.8712		&& current.zPos <= 52.8582)
					return true;	
				break;	
			//The Death of Klompa
			case 6:	
				if(current.xPos >= -246			&& current.yPos >= 373.5		&& current.zPos >= 66			&& current.xPos <= -241.5		&& current.yPos <= 383.6		&& current.zPos <= 69)
					return true;	
				break;
			//The Temple
			case 7:	
				if(current.xPos >= -122.6		&& current.yPos >= 421.6		&& current.zPos >= 107			&& current.xPos <= -117.7		&& current.yPos <= 423			&& current.zPos <= 108.1)
					return true;	
				break;
			//Life Upgrade 3
			case 8:	
				if(current.xPos >= -187.3369	&& current.yPos >= -455.9863	&& current.zPos >= 78.0330		&& current.xPos <= -187.3367	&& current.yPos <= 455.9865		&& current.zPos <= 78.0332)
					return true;	
				break;
			//The Market District
			case 9:	
				if(current.xPos >= -213			&& current.yPos >= 484			&& current.zPos >= 101			&& current.xPos <= -207			&& current.yPos <= 490			&& current.zPos <= 103)
					return true;	
				break;
			//The Death of Mahasti
			case 10:	
				if(current.xPos >= -104			&& current.yPos >= 548			&& current.zPos >= 105.9		&& current.xPos <= -100			&& current.yPos <= 553			&& current.zPos <= 106.1)
					return true;	
				break;
			//Life Upgrade 4
			case 11:	
				if(current.xPos >= -55.0147		&& current.yPos >= 395.7608		&& current.zPos >= 72.0774		&& current.xPos <= -55.0145		&& current.yPos <= 395.761		&& current.zPos <= 72.0776)
					return true;	
				break;
			//The King's Road
			case 12:	
				if(current.xPos >= 58			&& current.yPos >= 470			&& current.zPos >= 79			&& current.xPos <= 62			&& current.yPos <= 480			&& current.zPos <= 81)
					return true;	
				break;
			//The Death of the Twins
			case 13:	
				if(current.xPos >= 53			&& current.yPos >= 240			&& current.zPos >= 70			&& current.xPos <= 70			&& current.yPos <= 250			&& current.zPos <= 73)
					return true;	
				break;
			//Life Upgrade 5
			case 14:	
				if(current.xPos >= -30.1223		&& current.yPos >= 281.8893		&& current.zPos >= 104.0796		&& current.xPos <= -30.1221		&& current.yPos <= 281.8895		&& current.zPos <= 104.0798)
					return true;	
				break;
			//The Well of Ancestors
			case 15:	
				if(current.xPos >= 5			&& current.yPos >= 243			&& current.zPos >= 104			&& current.xPos <= 12			&& current.yPos <= 265			&& current.zPos <= 104.1)
					return true;	
				break;
			//The Underground Cave
			case 16:	
				if(current.xPos >= -25.5		&& current.yPos >= 332			&& current.zPos >= 35.9			&& current.xPos <= -23			&& current.yPos <= 338			&& current.zPos <= 36.1)
					return true;	
				break;
			//Life Upgrade 6
			case 17:	
				if(current.xPos >= -23.9663		&& current.yPos >= 253.9438		&& current.zPos >= 183.0634		&& current.xPos <= -23.9661		&& current.yPos <= 253.944		&& current.zPos <= 183.0636)
					return true;	
				break;
			//The Upper Tower
			case 18:	
				if(current.xPos >= -8			&& current.yPos >= 296			&& current.zPos >= 226.9		&& current.xPos <= -7			&& current.yPos <= 298			&& current.zPos <= 227)
					return true;	
				break;
			//The End
			case 19:	
				if(current.xPos >= 189			&& current.yPos >= 319.135		&& current.zPos >= 542			&& current.xPos <= 193			&& current.yPos <= 320			&& current.zPos <= 543)
					return true;	
				break;
		}
		break;
		
		case "All Powers (Zipless)":
			switch (timer.CurrentSplitIndex)
			{
			//The Harbor District
			case 0:
				if(current.xPos >= -271			&& current.yPos >= 187			&& current.zPos >= 74			&& current.xPos <= -265			&& current.yPos <= 188			&& current.zPos <= 75)
					return true;
				break;
			//The Palace
			case 1:	
				if(current.xPos >= -93			&& current.yPos >= 236.2		&& current.zPos >= 83			&& current.xPos <= -88			&& current.yPos <= 238			&& current.zPos <= 88)
					return true;	
				break;
			//The Dagger of Time
			case 2:	
				if(current.xPos >= -35.5		&& current.yPos >= 232.3		&& current.zPos >= 146.9		&& current.xPos <= -35.4		&& current.yPos <= 232.4		&& current.zPos <= 147)
					return true;	
				break;
			//The Sewers
			case 3:
				if(current.xPos >= -52.1		&& current.yPos >= 135.8		&& current.zPos >= 75.9			&& current.xPos <= -52.0		&& current.yPos <= 135.9		&& current.zPos <= 76)
					return true;
				break;
			//Life Upgrade 1
			case 4:	
				if(current.xPos >= -14.9972		&& current.yPos >= -112.8152	&& current.zPos >= 20.0732		&& current.xPos <= -14.9970		&& current.yPos <= -112.8150	&& current.zPos <= 20.0734)
					return true;	
				break;
			//The Lower City
			case 5:
				if(current.xPos >= -71.4		&& current.yPos >= 9.6			&& current.zPos >= 44			&& current.xPos <= -71.3		&& current.yPos <= 9.7			&& current.zPos <= 44.1)
					return true;
				break;
			//The Lower City Rooftops
			case 6:
				if(current.xPos >= -319			&& current.yPos >= 317			&& current.zPos >= 95.1			&& current.xPos <= -316.5		&& current.yPos <= 332.6		&& current.zPos <= 98)
					return true;
				break;
			//Life Upgrade 2
			case 7:	
				if(current.xPos >= -302.0919	&& current.yPos >= 370.8710		&& current.zPos >= 52.858		&& current.xPos <= -302.0917	&& current.yPos <= 370.8712		&& current.zPos <= 52.8582)
					return true;	
				break;	
			//The Death of Klompa
			case 8:
				if(current.xPos >= -261.5		&& current.yPos >= 318			&& current.zPos >= 46			&& current.xPos <= -261			&& current.yPos <= 319.5		&& current.zPos <= 48)
					return true;
				break;
			//The Eye of the Storm
			case 9:
				if(current.xPos >= -194			&& current.yPos >= 328			&& current.zPos >= 32.6			&& current.xPos <= -190			&& current.yPos <= 329.7		&& current.zPos <= 33.6)
					return true;
				break;
			//The Temple Rooftops
			case 10:
				if(current.xPos >= -114			&& current.yPos >= 328			&& current.zPos >= 55			&& current.xPos <= -110			&& current.yPos <= 338			&& current.zPos <= 59)
					return true;
				break;
			//The Temple
			case 11:
				if(current.xPos >= -122.6		&& current.yPos >= 421.6		&& current.zPos >= 107			&& current.xPos <= -117.7		&& current.yPos <= 423			&& current.zPos <= 108.1)
					return true;
				break;
			//Life Upgrade 3
			case 12:	
				if(current.xPos >= -187.3369	&& current.yPos >= -455.9863	&& current.zPos >= 78.0330		&& current.xPos <= -187.3367	&& current.yPos <= 455.9865		&& current.zPos <= 78.0332)
					return true;	
				break;
			//The Market District
			case 13:
				if(current.xPos >= -213			&& current.yPos >= 484			&& current.zPos >= 101			&& current.xPos <= -207			&& current.yPos <= 490			&& current.zPos <= 103)
					return true;
				break;
			//The Bowery
			case 14:
				if(current.xPos >= -185.5		&& current.yPos >= 524			&& current.zPos >= 90			&& current.xPos <= -175.5		&& current.yPos <= 530			&& current.zPos <= 92)
					return true;
				break;
			//The Death of Mahasti
			case 15:
				if(current.xPos >= -104			&& current.yPos >= 548			&& current.zPos >= 104			&& current.xPos <= -100			&& current.yPos <= 553.9		&& current.zPos <= 106.1)
					return true;
				break;
			//The Upper City
			case 16:
				if(current.xPos >= -124.5		&& current.yPos >= 500			&& current.zPos >= 97			&& current.xPos <= -122.5		&& current.yPos <= 505			&& current.zPos <= 99)
					return true;
				break;
			//Life Upgrade 4
			case 17:	
				if(current.xPos >= -55.0147		&& current.yPos >= 395.7608		&& current.zPos >= 72.0774		&& current.xPos <= -55.0145		&& current.yPos <= 395.761		&& current.zPos <= 72.0776)
					return true;	
				break;
			//The Royal Workshop
			case 18:
				if(current.xPos >= -3			&& current.yPos >= 515			&& current.zPos >= 72			&& current.xPos <= -1			&& current.yPos <= 519			&& current.zPos <= 75)
					return true;
				break;
			//The King's Road
			case 19:
				if(current.xPos >= 58			&& current.yPos >= 470			&& current.zPos >= 79			&& current.xPos <= 62			&& current.yPos <= 480			&& current.zPos <= 81)
					return true;
				break;
			//The Death of the Twins
			case 20:
				if(current.xPos >= 91.7802		&& current.yPos >= 229.6516		&& current.zPos >= 70.9877		&& current.xPos <= 91.7804		&& current.yPos <= 229.6518		&& current.zPos <= 70.9879)
					return true;
				break;
			//Life Upgrade 5
			case 21:	
				if(current.xPos >= -30.1223		&& current.yPos >= 281.8893		&& current.zPos >= 104.0796		&& current.xPos <= -30.1221		&& current.yPos <= 281.8895		&& current.zPos <= 104.0798)
					return true;	
				break;
			//The Structure's Mind
			case 22:
				if(current.xPos >= 13.5			&& current.yPos >= 204.4		&& current.zPos >= 184.9999		&& current.xPos <= 27.4			&& current.yPos <= 215.4		&& current.zPos <= 185.0001)
					return true;
				break;
			//The Well of Ancestors
			case 23:
				if(current.xPos >= -28			&& current.yPos >= 250			&& current.zPos >= 20.9			&& current.xPos <= -26.5		&& current.yPos <= 255			&& current.zPos <= 30)
					return true;
				break;
			//The Labyrinth
			case 24:
				if(current.xPos >= -12.6		&& current.yPos >= 241.2		&& current.zPos >= 0.9			&& current.xPos <= -12.5		&& current.yPos <= 241.3		&& current.zPos <= 1)
					return true;
				break;
			//The Underground Cave
			case 25:
				if(current.xPos >= -25.5		&& current.yPos >= 332			&& current.zPos >= 35.9			&& current.xPos <= -23			&& current.yPos <= 338			&& current.zPos <= 36.1)
					return true;
				break;
			//The Lower Tower
			case 26:
				if(current.xPos >= 27			&& current.yPos >= 316.5		&& current.zPos >= 99.9			&& current.xPos <= 29			&& current.yPos <= 318			&& current.zPos <= 100.1)
					return true;
				break;
			//The Middle Tower
			case 27:
				if(current.xPos >= -5			&& current.yPos >= 316			&& current.zPos >= 139.9		&& current.xPos <= -3			&& current.yPos <= 317.5		&& current.zPos <= 140.1)
					return true;
				break;
			//Life Upgrade 6
			case 28:	
				if(current.xPos >= -23.9663		&& current.yPos >= 253.9438		&& current.zPos >= 183.0634		&& current.xPos <= -23.9661		&& current.yPos <= 253.944		&& current.zPos <= 183.0636)
					return true;	
				break;
			//The Upper Tower
			case 29:
				if(current.xPos >= -8			&& current.yPos >= 296			&& current.zPos >= 226.9		&& current.xPos <= -7			&& current.yPos <= 298			&& current.zPos <= 227)
					return true;
				break;
			//The Death of the Vizier
			case 30:
				if(current.xPos >= -7.2			&& current.yPos >= 245.6		&& current.zPos >= 677			&& current.xPos <= -6.9			&& current.yPos <= 245.9		&& current.zPos <= 679)
					return true;
				break;
			//The End
			case 31:	
				if(current.xPos >= 189			&& current.yPos >= 319.135		&& current.zPos >= 542			&& current.xPos <= 193			&& current.yPos <= 320			&& current.zPos <= 543)
					return true;	
				break;
		}
		break;
		
		case "All Powers (No Major Glitches)":
			switch (timer.CurrentSplitIndex)
			{
			//The Harbor District
			case 0:
				if(current.xPos >= -271			&& current.yPos >= 187			&& current.zPos >= 74			&& current.xPos <= -265			&& current.yPos <= 188			&& current.zPos <= 75)
					return true;
				break;
			//The Palace
			case 1:	
				if(current.xPos >= -93			&& current.yPos >= 236.2		&& current.zPos >= 83			&& current.xPos <= -88			&& current.yPos <= 238			&& current.zPos <= 88)
					return true;	
				break;
			//The Dagger of Time
			case 2:	
				if(current.xPos >= -35.5		&& current.yPos >= 232.3		&& current.zPos >= 146.9		&& current.xPos <= -35.4		&& current.yPos <= 232.4		&& current.zPos <= 147)
					return true;	
				break;
			//The Sewers
			case 3:
				if(current.xPos >= -52.1		&& current.yPos >= 135.8		&& current.zPos >= 75.9			&& current.xPos <= -52.0		&& current.yPos <= 135.9		&& current.zPos <= 76)
					return true;
				break;
			//Life Upgrade 1
			case 4:	
				if(current.xPos >= -14.9972		&& current.yPos >= -112.8152	&& current.zPos >= 20.0732		&& current.xPos <= -14.9970		&& current.yPos <= -112.8150	&& current.zPos <= 20.0734)
					return true;	
				break;
			//The Lower City
			case 5:
				if(current.xPos >= -71.4		&& current.yPos >= 9.6			&& current.zPos >= 44			&& current.xPos <= -71.3		&& current.yPos <= 9.7			&& current.zPos <= 44.1)
					return true;
				break;
			//The Lower City Rooftops
			case 6:
				if(current.xPos >= -319			&& current.yPos >= 317			&& current.zPos >= 95.1			&& current.xPos <= -316.5		&& current.yPos <= 332.6		&& current.zPos <= 98)
					return true;
				break;
			//Life Upgrade 2
			case 7:	
				if(current.xPos >= -302.0919	&& current.yPos >= 370.8710		&& current.zPos >= 52.858		&& current.xPos <= -302.0917	&& current.yPos <= 370.8712		&& current.zPos <= 52.8582)
					return true;	
				break;	
			//The Death of Klompa
			case 8:
				if(current.xPos >= -261.5		&& current.yPos >= 318			&& current.zPos >= 46			&& current.xPos <= -261			&& current.yPos <= 319.5		&& current.zPos <= 48)
					return true;
				break;
			//The Eye of the Storm
			case 9:
				if(current.xPos >= -194			&& current.yPos >= 328			&& current.zPos >= 32.6			&& current.xPos <= -190			&& current.yPos <= 329.7		&& current.zPos <= 33.6)
					return true;
				break;
			//The Temple Rooftops
			case 10:
				if(current.xPos >= -114			&& current.yPos >= 328			&& current.zPos >= 55			&& current.xPos <= -110			&& current.yPos <= 338			&& current.zPos <= 59)
					return true;
				break;
			//The Temple
			case 11:
				if(current.xPos >= -122.6		&& current.yPos >= 421.6		&& current.zPos >= 107			&& current.xPos <= -117.7		&& current.yPos <= 423			&& current.zPos <= 108.1)
					return true;
				break;
			//Life Upgrade 3
			case 12:	
				if(current.xPos >= -187.3369	&& current.yPos >= -455.9863	&& current.zPos >= 78.0330		&& current.xPos <= -187.3367	&& current.yPos <= 455.9865		&& current.zPos <= 78.0332)
					return true;	
				break;
			//The Market District
			case 13:
				if(current.xPos >= -213			&& current.yPos >= 484			&& current.zPos >= 101			&& current.xPos <= -207			&& current.yPos <= 490			&& current.zPos <= 103)
					return true;
				break;
			//The Bowery
			case 14:
				if(current.xPos >= -185.5		&& current.yPos >= 524			&& current.zPos >= 90			&& current.xPos <= -175.5		&& current.yPos <= 530			&& current.zPos <= 92)
					return true;
				break;
			//The Brothel
			case 15:
				if(current.xPos >= -152.6		&& current.yPos >= 549.8		&& current.zPos >= 91.9			&& current.xPos <= -152.5		&& current.yPos <= 549.9		&& current.zPos <= 92)
					return true;
				break;
			//The Death of Mahasti
			case 16:
				if(current.xPos >= -104			&& current.yPos >= 548			&& current.zPos >= 104			&& current.xPos <= -100			&& current.yPos <= 553.9		&& current.zPos <= 106.1)
					return true;
				break;
			//The Upper City
			case 17:
				if(current.xPos >= -124.5		&& current.yPos >= 500			&& current.zPos >= 97			&& current.xPos <= -122.5		&& current.yPos <= 505			&& current.zPos <= 99)
					return true;
				break;
			//Life Upgrade 4
			case 18:	
				if(current.xPos >= -55.0147		&& current.yPos >= 395.7608		&& current.zPos >= 72.0774		&& current.xPos <= -55.0145		&& current.yPos <= 395.761		&& current.zPos <= 72.0776)
					return true;	
				break;
			//The Royal Workshop
			case 19:
				if(current.xPos >= -3			&& current.yPos >= 515			&& current.zPos >= 72			&& current.xPos <= -1			&& current.yPos <= 519			&& current.zPos <= 75)
					return true;
				break;
			//The King's Road
			case 20:
				if(current.xPos >= 58			&& current.yPos >= 470			&& current.zPos >= 79			&& current.xPos <= 62			&& current.yPos <= 480			&& current.zPos <= 81)
					return true;
				break;
			//The Death of the Twins
			case 21:
				if(current.xPos >= 91.7802		&& current.yPos >= 229.6516		&& current.zPos >= 70.9877		&& current.xPos <= 91.7804		&& current.yPos <= 229.6518		&& current.zPos <= 70.9879)
					return true;
				break;
			//Life Upgrade 5
			case 22:	
				if(current.xPos >= -30.1223		&& current.yPos >= 281.8893		&& current.zPos >= 104.0796		&& current.xPos <= -30.1221		&& current.yPos <= 281.8895		&& current.zPos <= 104.0798)
					return true;	
				break;
			//The Structure's Mind
			case 23:
				if(current.xPos >= 13.5			&& current.yPos >= 204.4		&& current.zPos >= 184.9999		&& current.xPos <= 27.4			&& current.yPos <= 215.4		&& current.zPos <= 185.0001)
					return true;
				break;
			//The Well of Ancestors
			case 24:
				if(current.xPos >= -28			&& current.yPos >= 250			&& current.zPos >= 20.9			&& current.xPos <= -26.5		&& current.yPos <= 255			&& current.zPos <= 30)
					return true;
				break;
			//The Labyrinth
			case 25:
				if(current.xPos >= -12.6		&& current.yPos >= 241.2		&& current.zPos >= 0.9			&& current.xPos <= -12.5		&& current.yPos <= 241.3		&& current.zPos <= 1)
					return true;
				break;
			//The Underground Cave
			case 26:
				if(current.xPos >= -25.5		&& current.yPos >= 332			&& current.zPos >= 35.9			&& current.xPos <= -23			&& current.yPos <= 338			&& current.zPos <= 36.1)
					return true;
				break;
			//The Lower Tower
			case 27:
				if(current.xPos >= 27			&& current.yPos >= 316.5		&& current.zPos >= 99.9			&& current.xPos <= 29			&& current.yPos <= 318			&& current.zPos <= 100.1)
					return true;
				break;
			//The Middle Tower
			case 28:
				if(current.xPos >= -5			&& current.yPos >= 316			&& current.zPos >= 139.9		&& current.xPos <= -3			&& current.yPos <= 317.5		&& current.zPos <= 140.1)
					return true;
				break;
			//Life Upgrade 6
			case 29:	
				if(current.xPos >= -23.9663		&& current.yPos >= 253.9438		&& current.zPos >= 183.0634		&& current.xPos <= -23.9661		&& current.yPos <= 253.944		&& current.zPos <= 183.0636)
					return true;	
				break;
			//The Upper Tower
			case 30:
				if(current.xPos >= -8			&& current.yPos >= 296			&& current.zPos >= 226.9		&& current.xPos <= -7			&& current.yPos <= 298			&& current.zPos <= 227)
					return true;
				break;
			//The Death of the Vizier
			case 31:
				if(current.xPos >= -4.485		&& current.yPos >= 240.943		&& current.zPos >= 304.232		&& current.xPos <= -4.487		&& current.yPos <= 240.945		&& current.zPos <= 304.234)
					return true;
				break;
			//The End
			case 32:	
				if(current.xPos >= 189			&& current.yPos >= 319.135		&& current.zPos >= 542			&& current.xPos <= 193			&& current.yPos <= 320			&& current.zPos <= 543)
					return true;	
				break;
		}
		break;
	}	
}