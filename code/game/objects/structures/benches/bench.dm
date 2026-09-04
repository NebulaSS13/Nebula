// These are benches with backs. For backless benches that can't be buckled to, check for /obj/structure/table/bench.
/obj/structure/chair/bench
	name = "bench"
	desc = "A simple slatted bench."
	icon = 'icons/obj/structures/furniture/bench.dmi'
	icon_state = ICON_STATE_WORLD + "_preview"
	color = WOOD_COLOR_GENERIC
	initial_padding_material = null
	material = /decl/material/solid/organic/wood/oak
	obj_flags = 0
	anchored = TRUE
	/// A bitfield of connected neighbors.
	var/neighbors = 0

/obj/structure/chair/bench/should_have_alpha_mask()
	if(!simulated || !isturf(loc))
		return FALSE
	var/obj/structure/chair/bench/south_neighbor = locate() in get_step(loc, SOUTH)
	if(can_visually_connect_to(south_neighbor)) // if we're connected to a south neighbor don't add an alpha mask
		return TRUE
	return TRUE

// TODO: make this use the generic structure smoothing system?
/obj/structure/chair/bench/can_visually_connect_to(var/obj/structure/chair/bench/other)
	return istype(other) && other.dir == dir && other.icon == icon && other.material == material

/obj/structure/chair/bench/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/chair/bench/LateInitialize(mapload)
	..()
	if(mapload)
		recalculate_connections()
	else
		update_neighbors()

/obj/structure/chair/bench/Destroy()
	var/oldloc = loc
	. = ..()
	update_neighbors(oldloc)

/obj/structure/chair/bench/set_dir()
	var/olddir = dir
	. = ..()
	if(.)
		update_neighbors(update_dir = olddir, skip_icon_update = TRUE)
		update_neighbors(update_dir = dir)

/obj/structure/chair/bench/Move()
	var/oldloc = loc
	. = ..()
	if(.)
		update_neighbors(oldloc, skip_icon_update = TRUE)
		update_neighbors(loc)

/obj/structure/chair/bench/proc/update_neighbors(update_loc = loc, update_dir = dir, skip_icon_update)
	if(!skip_icon_update)
		recalculate_connections()
	if(!isturf(update_loc))
		return
	for(var/stepdir in list(turn(update_dir, -90), turn(update_dir, 90)))
		for(var/obj/structure/chair/bench/other in get_step(update_loc, stepdir))
			other.recalculate_connections()

// TODO: Make this use base structure smoothing eventually? Somehow?
/obj/structure/chair/bench/proc/recalculate_connections()
	neighbors = 0
	if(!isturf(loc))
		neighbors = 0
	else
		for(var/checkdir in list(turn(dir, -90), turn(dir,  90)))
			var/turf/check_turf = get_step(loc, checkdir)
			for(var/obj/structure/chair/bench/other in check_turf)
				// TODO: Make this use normal structure smoothing helpers.
				if(other.dir == dir && other.icon == icon && other.material == material)
					neighbors |= checkdir
					break
	update_icon()

/obj/structure/chair/bench/get_base_icon()
	. = ..()
	var/left_dir  = turn(dir, -90)
	var/right_dir = turn(dir,  90)
	if(neighbors & left_dir)
		if(neighbors & right_dir)
			. += "_middle"
		else
			. += "_right"
	else if(neighbors & right_dir)
		. += "_left"
	else
		. += "_standing"

/obj/structure/chair/bench/get_material_icon()
	return material?.bench_icon || initial(icon)

/obj/structure/chair/bench/mahogany
	color = WOOD_COLOR_RICH
	material = /decl/material/solid/organic/wood/mahogany

/obj/structure/chair/bench/ebony
	color = WOOD_COLOR_BLACK
	material = /decl/material/solid/organic/wood/ebony
