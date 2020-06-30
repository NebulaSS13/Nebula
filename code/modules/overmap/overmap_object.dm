/obj/effect/overmap
	name = "map object"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "object"

	var/known = 1				 //shows up on nav computers automatically
	var/scannable				 //if set to TRUE will show up on ship sensors for detailed scans, and will ping when detected by scanners.

	var/requires_contact = FALSE //whether or not the effect must be identified by ship sensors before being seen.
	var/instant_contact  = FALSE //do we instantly identify ourselves to any ship in sensors range?
	var/halted = FALSE
	var/sensor_visibility = 10	 //how likely it is to increase identification process each scan.

	var/vessel_mass = 10000             // metric tonnes, very rough number, affects acceleration provided by engines
	var/vessel_size = SHIP_SIZE_LARGE	// arbitrary number, affects how likely are we to evade meteors
	var/max_speed = 1/(1 SECOND)        // "speed of light" for the ship, in turfs/tick.
	var/min_speed = 1/(2 MINUTES)       // Below this, we round speed to 0 to avoid math errors.

	var/list/speed = list(0,0)          // speed in x,y direction
	var/list/position = list(0,0)       // position within a tile.
	var/last_burn = 0                   // worldtime when ship last acceleated
	var/burn_delay = 1 SECOND           // how often ship can do burns

	var/datum/extension/overmap_movement/movement //Movement handler.
	var/movement_handler_type //The type, for setting extensions.

//Overlay of how this object should look on other skyboxes
/obj/effect/overmap/proc/get_skybox_representation()
	return

/obj/effect/overmap/proc/get_scan_data(mob/user)
	return desc

/obj/effect/overmap/Initialize()
	. = ..()
	if(!GLOB.using_map.use_overmap)
		return INITIALIZE_HINT_QDEL

	if(known)
		layer = ABOVE_LIGHTING_LAYER
		plane = EFFECTS_ABOVE_LIGHTING_PLANE
		for(var/obj/machinery/computer/ship/helm/H in SSmachines.machinery)
			H.get_known_sectors()

	if(requires_contact)
		invisibility = INVISIBILITY_OVERMAP // Effects that require identification have their images cast to the client via sensors.
	update_icon()
	if(movement_handler_type)
		set_extension(src, movement_handler_type)
		movement = get_extension(src, movement_handler_type)

/obj/effect/overmap/Crossed(var/obj/effect/overmap/visitable/other)
	if(istype(other))
		for(var/obj/effect/overmap/visitable/O in loc)
			SSskybox.rebuild_skyboxes(O.map_z)

/obj/effect/overmap/Uncrossed(var/obj/effect/overmap/visitable/other)
	if(istype(other))
		SSskybox.rebuild_skyboxes(other.map_z)
		for(var/obj/effect/overmap/visitable/O in loc)
			SSskybox.rebuild_skyboxes(O.map_z)

/obj/effect/overmap/on_update_icon()
	filters = filter(type="drop_shadow", color = color + "F0", size = 2, offset = 1,x = 0, y = 0)

/obj/effect/overmap/proc/handle_wraparound()
	var/nx = x
	var/ny = y
	var/low_edge = 1
	var/high_edge = GLOB.using_map.overmap_size - 1

	if((dir & WEST) && x == low_edge)
		nx = high_edge
	else if((dir & EAST) && x == high_edge)
		nx = low_edge
	if((dir & SOUTH)  && y == low_edge)
		ny = high_edge
	else if((dir & NORTH) && y == high_edge)
		ny = low_edge
	if((x == nx) && (y == ny))
		return //we're not flying off anywhere

	var/turf/T = locate(nx,ny,z)
	if(T)
		forceMove(T)

/obj/effect/overmap/proc/is_still()
	return !MOVING(speed[1], min_speed) && !MOVING(speed[2], min_speed)
