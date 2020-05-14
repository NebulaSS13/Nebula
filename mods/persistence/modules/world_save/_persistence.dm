/datum/map
	// A list of turfs and their default turfs for serialization optimization.
	var/list/default_z_turfs = list()

/datum/proc/after_save()

/datum/proc/before_save()

/datum/proc/should_save()
	return should_save

/datum/proc/after_deserialize()

/datum
	var/should_save = TRUE

/turf
	var/is_on_fire = FALSE
	var/list/saved_decals

/obj/fire
	should_save = FALSE

/obj/effect/fake_fire
	should_save = FALSE

/obj/effect/expl_particles
	should_save = FALSE

/obj/effect/explosion
	should_save = FALSE

/datum/effect/system/explosion
	should_save = FALSE

/atom/movable/lighting_overlay
	should_save = FALSE

/atom/movable/openspace/multiplier
	should_save = FALSE

/obj/effect/floor_decal
	should_save = TRUE

/obj/effect
	should_save = FALSE

/mob/observer
	should_save = FALSE

/obj/after_deserialize()
	..()
	queue_icon_update()

/obj/machinery/embedded_controller
	var/saved_memory
/obj/machinery/embedded_controller/before_save()
	..()
	saved_memory = program.memory
/obj/machinery/embedded_controller/after_deserialize()
	..()
	if(saved_memory)
		program.memory = saved_memory

/turf/unsimulated/map
	should_save = FALSE

/obj/effect/overmap/
	should_save = FALSE

/obj/effect/overmap/visitable/before_save()
	should_save = FALSE
	for(var/z in map_z)
		if(z in SSpersistence.saved_levels)
			should_save = TRUE
	start_x = x
	start_y = x
	..()

/datum/computer_file/report/after_deserialize()
	..()
	for(var/datum/report_field/field in fields)
		field.owner = src

/obj/item/storage/after_deserialize()
	..()
	startswith = 0

/obj/item/tank/after_deserialize()
	..()
	starting_pressure = 0

/obj/item/extinguisher/after_deserialize()
	..()
	starting_water = 0

/obj/structure/cable/after_deserialize()
	..()
	var/turf/T = src.loc			// hide if turf is not intact
	if(level==1) hide(!T.is_plating())

/atom/movable/lighting_overlay/after_deserialize()
	..()
	loc = null
	qdel(src)

/obj/item/tankassemblyproxy
	should_save = FALSE

/datum/proc/get_saved_vars()
	return GLOB.saved_vars[type] || get_default_vars()

/datum/proc/get_default_vars()
	var/savedlist = list()
	for(var/v in vars)
		if(issaved(vars[v]) && !(v in GLOB.blacklisted_vars))
			LAZYADD(savedlist, v)
	return savedlist

/area/proc/get_turf_coords()
	var/list/coord_list = list()
	for(var/turf/T in contents)
		coord_list.Add("[T.x],[T.y],[T.z]")
	return coord_list
