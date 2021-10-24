#define ZLEVEL_STATION BITFLAG(0)
#define ZLEVEL_ADMIN   BITFLAG(1)
#define ZLEVEL_CONTACT BITFLAG(2)
#define ZLEVEL_PLAYER  BITFLAG(3)
#define ZLEVEL_SEALED  BITFLAG(4)

var/global/list/levels_by_z =  list()
var/global/list/levels_by_id = list()

/obj/level_data
	simulated = FALSE
	var/my_z
	var/level_id
	var/base_turf
	var/list/connects_to
	var/level_flags


INITIALIZE_IMMEDIATE(/obj/level_data)
/obj/level_data/Initialize()
	. = ..()
	my_z = z
	forceMove(null)
	if(global.levels_by_z["[my_z]"])
		PRINT_STACK_TRACE("Duplicate level data created for z[z].")
	global.levels_by_z["[my_z]"] = src
	if(!level_id)
		level_id = "leveldata_[my_z]_[sequential_id(/obj/level_data)]"
	if(level_id in global.levels_by_id)
		PRINT_STACK_TRACE("Duplicate level_id '[level_id]' for z[my_z].")
	else
		global.levels_by_id[level_id] = src

	if(base_turf)
		global.using_map.base_turf_by_z["[my_z]"] = base_turf

	if(level_flags & ZLEVEL_STATION)
		global.using_map.station_levels |= my_z
	if(level_flags & ZLEVEL_ADMIN)
		global.using_map.admin_levels   |= my_z
	if(level_flags & ZLEVEL_CONTACT)
		global.using_map.contact_levels |= my_z
	if(level_flags & ZLEVEL_PLAYER)
		global.using_map.player_levels  |= my_z
	if(level_flags & ZLEVEL_SEALED)
		global.using_map.sealed_levels  |= my_z

/obj/level_data/Destroy(var/force)
	if(force)
		new type(locate(round(world.maxx/2), round(world.maxy/2), my_z))
		return ..()
	return QDEL_HINT_LETMELIVE

/obj/level_data/proc/find_connected_levels(var/list/found)
	for(var/other_id in connects_to)
		var/obj/level_data/neighbor = global.levels_by_id[other_id] 
		neighbor.add_connected_levels(found)

/obj/level_data/proc/add_connected_levels(var/list/found)
	. = found
	if((my_z in found))
		return
	LAZYADD(found, my_z)
	if(!length(connects_to))
		return
	for(var/other_id in connects_to)
		var/obj/level_data/neighbor = global.levels_by_id[other_id] 
		neighbor.add_connected_levels(found)

// Mappable subtypes.
/obj/level_data/main_level
	name = "Main Station Level"
	level_flags = (ZLEVEL_STATION|ZLEVEL_CONTACT|ZLEVEL_PLAYER)

/obj/level_data/admin_level
	name = "Admin Level"
	level_flags = (ZLEVEL_ADMIN|ZLEVEL_SEALED)

/obj/level_data/player_level
	name = "Player Level"
	level_flags = (ZLEVEL_CONTACT|ZLEVEL_PLAYER)

#undef ZLEVEL_STATION
#undef ZLEVEL_ADMIN
#undef ZLEVEL_CONTACT
#undef ZLEVEL_PLAYER
#undef ZLEVEL_SEALED
