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

}