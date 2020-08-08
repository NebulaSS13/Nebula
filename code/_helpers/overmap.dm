/proc/get_dir_from_angle(var/angle)
	var/direction
	switch(angle)
		if(0)
			direction = NORTH
		if(90)
			direction = EAST
		if(180)
			direction = SOUTH
		if(270)
			direction = WEST
		if(0 to 89)
			direction = NORTHEAST
		if(91 to 179)
			direction = SOUTHEAST
		if(181 to 269)
			direction = SOUTHWEST
		if(271 to 359)
			direction = NORTHWEST

	return direction