/obj/abstract/submap_landmark
	icon              = 'icons/misc/mark.dmi'
	invisibility      = INVISIBILITY_MAXIMUM
	anchored          = TRUE
	simulated         = FALSE
	density           = FALSE
	opacity           = FALSE
	abstract_type     = /obj/abstract/submap_landmark
	is_spawnable_type = FALSE

/obj/abstract/submap_landmark/joinable_submap
	icon_state = "x4"
	var/archetype
	var/submap_datum_type = /datum/submap

/obj/abstract/submap_landmark/joinable_submap/Initialize(var/mapload)
	. = ..(mapload)
	if(!SSmapping.submaps[name] && ispath(archetype, /decl/submap_archetype))
		var/datum/submap/submap = new submap_datum_type(z)
		submap.name = name
		submap.setup_submap(GET_DECL(archetype))
	else
		if(SSmapping.submaps[name])
			to_world_log( "Submap error - mapped landmark is duplicate of existing.")
		else
			to_world_log( "Submap error - mapped landmark had invalid archetype.")
	return INITIALIZE_HINT_QDEL

var/global/list/submap_spawnpoints_by_z = list()
INITIALIZE_IMMEDIATE(/obj/abstract/submap_landmark/spawnpoint)
/obj/abstract/submap_landmark/spawnpoint
	movable_flags = MOVABLE_FLAG_ALWAYS_SHUTTLEMOVE
	icon_state = "x3"

/obj/abstract/submap_landmark/spawnpoint/Initialize()
	. = ..()
	LAZYADD(global.submap_spawnpoints_by_z[num2text(z)], src)

/obj/abstract/submap_landmark/spawnpoint/Destroy()
	LAZYREMOVE(global.submap_spawnpoints_by_z[num2text(z)], src)
	. = ..()

/obj/abstract/submap_landmark/spawnpoint/survivor
	name = "Survivor"
