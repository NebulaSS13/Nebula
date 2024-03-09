/* TO DO
1. Remake godaweful apply_to_map checks. There should be a loop or something I can do there.
2. Make apply_to_map check for nearby doors. If there is a nearby door, check its complexity.
If its complexity is lower than our theme's then
*/

/datum/room
	var/datum/random_room/room_generator = null
	var/x
	var/y
	var/width
	var/height
	var/datum/room_theme/room_theme = null
	var/generate_doors = 1 //do we want to generate doors for this place?

/datum/room/New(var/rt, var/_x, var/_y, var/w, var/h, var/doors)
	var/gen_type
	if(rt)
		room_theme = rt
		gen_type = room_theme.get_a_room_layout()
	if(gen_type)
		room_generator = new gen_type(_x,_y,w,h)
	generate_doors = doors
	x = _x
	y = _y
	width = w
	height = h

/datum/room/Destroy()
	if(room_theme)
		qdel(room_theme)
		room_theme = null
	if(room_generator)
		qdel(room_generator)
		room_generator = null
	return ..()

/datum/room/proc/apply_to_map(var/xorigin,var/yorigin,var/zorigin, var/datum/random_map/map)
	if(room_theme)
		for(var/i = 0, i < width, i++)
			for(var/j = 0, j < height, j++)
				var/truex = xorigin + x + i - 1
				var/truey = yorigin + y + j - 1
				var/tmp_cell
				TRANSLATE_AND_VERIFY_COORD_OTHER_MAP(x+i, y+j, map)
				var/cell = tmp_cell
				room_theme.apply_room_theme(truex,truey,map.map[cell])
				if(generate_doors && room_theme.door_type && !(map.map[cell] == WALL_CHAR || map.map[cell] == ARTIFACT_TURF_CHAR) && (i == 0 || i == width-1 || j == 0 || j == height-1))
					var/isGood = 1
					if(j == 0 || j == height-1) //check horizontally
						TRANSLATE_AND_VERIFY_COORD_OTHER_MAP(x+i-1,y+j, map)
						var/curCell = map.map[tmp_cell]
						if(curCell != WALL_CHAR && curCell != ARTIFACT_TURF_CHAR)
							isGood = 0
						TRANSLATE_AND_VERIFY_COORD_OTHER_MAP(x+i+1,y+j, map)
						curCell = map.map[tmp_cell]
						if(curCell != WALL_CHAR && curCell != ARTIFACT_TURF_CHAR)
							isGood = 0
						TRANSLATE_AND_VERIFY_COORD_OTHER_MAP(x+i,y+j-1, map)
						curCell = map.map[tmp_cell]
						if(curCell == WALL_CHAR || curCell == ARTIFACT_TURF_CHAR)
							isGood = 0
						TRANSLATE_AND_VERIFY_COORD_OTHER_MAP(x+i,y+j+1, map)
						curCell = map.map[tmp_cell]
						if(curCell == WALL_CHAR || curCell == ARTIFACT_TURF_CHAR)
							isGood = 0
					if(i == 0 || i == width-1) //vertical
						isGood = 1 //if it failed above, it might not fail here.
						TRANSLATE_AND_VERIFY_COORD_OTHER_MAP(x+i,y+j-1, map)
						var/curCell = map.map[tmp_cell]
						if(curCell != WALL_CHAR && curCell != ARTIFACT_TURF_CHAR)
							isGood = 0
						TRANSLATE_AND_VERIFY_COORD_OTHER_MAP(x+i,y+j+1, map)
						curCell = map.map[tmp_cell]
						if(curCell != WALL_CHAR && curCell != ARTIFACT_TURF_CHAR)
							isGood = 0
						TRANSLATE_AND_VERIFY_COORD_OTHER_MAP(x+i-1,y+j, map)
						curCell = map.map[tmp_cell]
						if(curCell == WALL_CHAR || curCell == ARTIFACT_TURF_CHAR)
							isGood = 0
						TRANSLATE_AND_VERIFY_COORD_OTHER_MAP(x+i+1,y+j, map)
						curCell = map.map[tmp_cell]
						if(curCell == WALL_CHAR || curCell == ARTIFACT_TURF_CHAR)
							isGood = 0
					if(isGood)
						room_theme.apply_room_door(x+i,y+j,zorigin)
		if(room_theme)
			qdel(room_theme)
			room_theme = null
	if(room_generator)
		room_generator.apply_to_map(xorigin,yorigin,zorigin)

	return 1

/datum/room/proc/add_loot(var/xorigin,var/yorigin,var/zorigin,var/type)
	if(room_generator && room_generator.apply_loot(xorigin,yorigin,zorigin,type))
		return 1
	var/rx = xorigin+x+rand(width-3)
	var/ry = yorigin+y+rand(height-3)
	var/turf/T = locate(rx,ry,zorigin)
	if(!T || T.density)
		return 0
	for(var/obj/o in T)
		return 0
	new type(T)
	return 1