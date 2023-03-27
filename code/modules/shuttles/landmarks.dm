var/global/list/shuttle_landmarks = list()

//making this separate from /obj/abstract/landmark until that mess can be dealt with
/obj/effect/shuttle_landmark
	name = "Nav Point"
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	anchored = 1
	unacidable = 1
	simulated = 0
	invisibility = 101

	var/landmark_tag
	//ID of the controller on the dock side
	var/datum/computer/file/embedded_program/docking/docking_controller
	//Docking cues for shuttles with multiple docking controllers. Format: shuttle type -> string cue. On the shuttle, set docking_cues as well.
	var/list/special_dock_targets

	//when the shuttle leaves this landmark, it will leave behind the base area
	//also used to determine if the shuttle can arrive here without obstruction
	var/area/base_area
	//Will also leave this type of turf behind if set, if the turfs do not have prev_type set.
	var/turf/base_turf
	//Type path of a shuttle to which this landmark is restricted, null for generic waypoint.
	var/shuttle_restricted
	var/overmap_id = OVERMAP_ID_SPACE
	var/flags = 0

/obj/effect/shuttle_landmark/Destroy()
	global.shuttle_landmarks -= src
	. = ..()

/obj/effect/shuttle_landmark/Initialize()
	. = ..()
	global.shuttle_landmarks += src
	if(docking_controller)
		. = INITIALIZE_HINT_LATELOAD

	if(flags & SLANDMARK_FLAG_AUTOSET)
		base_area = get_area(src)
		var/turf/T = get_turf(src)
		if(T)
			base_turf = T.type
	else if(ispath(base_area) || !base_area)
		base_area = locate(base_area || world.area)

	SetName(name + " ([x],[y])")
	SSshuttle.register_landmark(landmark_tag, src)

/obj/effect/shuttle_landmark/LateInitialize()
	if(!docking_controller)
		return
	var/docking_tag = docking_controller
	docking_controller = SSshuttle.docking_registry[docking_tag]
	if(!istype(docking_controller))
		log_error("Could not find docking controller for shuttle waypoint '[name]', docking tag was '[docking_tag]'.")

	var/obj/effect/overmap/visitable/location = global.overmap_sectors[num2text(z)]
	if(location && location.docking_codes)
		docking_controller.docking_codes = location.docking_codes

/obj/effect/shuttle_landmark/modify_mapped_vars(map_hash)
	..()
	ADJUST_TAG_VAR(landmark_tag, map_hash)
	if(docking_controller)
		ADJUST_TAG_VAR(docking_controller, map_hash)

/obj/effect/shuttle_landmark/forceMove()
	var/obj/effect/overmap/visitable/map_origin = global.overmap_sectors[num2text(z)]
	. = ..()
	var/obj/effect/overmap/visitable/map_destination = global.overmap_sectors[num2text(z)]
	if(map_origin != map_destination)
		if(map_origin)
			map_origin.remove_landmark(src, shuttle_restricted)
		if(map_destination)
			map_destination.add_landmark(src, shuttle_restricted)

//Called when the landmark is added to an overmap sector.
/obj/effect/shuttle_landmark/proc/sector_set(var/obj/effect/overmap/visitable/O, shuttle_restricted_type)
	shuttle_restricted = shuttle_restricted_type

/obj/effect/shuttle_landmark/proc/is_valid(var/datum/shuttle/shuttle)
	if(shuttle.current_location == src)
		return FALSE
	for(var/area/A in shuttle.shuttle_area)
		var/list/translation = get_turf_translation(get_turf(shuttle.current_location), get_turf(src), A.contents)
		if(check_collision(base_area, list_values(translation)))
			return FALSE
	var/conn = SSmapping.get_connected_levels(z)
	for(var/w in (z - shuttle.multiz) to z)
		if(!(w in conn))
			return FALSE
	return TRUE

/obj/effect/shuttle_landmark/proc/cannot_depart(datum/shuttle/shuttle)
	return FALSE

/obj/effect/shuttle_landmark/proc/shuttle_arrived(datum/shuttle/shuttle)

/obj/effect/shuttle_landmark/proc/shuttle_departed(datum/shuttle/shuttle)

// Used to trigger effects prior to the shuttle's actual landing
/obj/effect/shuttle_landmark/proc/landmark_selected(datum/shuttle/shuttle)

/obj/effect/shuttle_landmark/proc/landmark_deselected(datum/shuttle/shuttle)

/proc/check_collision(area/target_area, list/target_turfs)
	for(var/target_turf in target_turfs)
		var/turf/target = target_turf
		if(!target)
			return TRUE //collides with edge of map
		if(target.loc != target_area)
			return TRUE //collides with another area
		if(target.density)
			return TRUE //dense turf
	return FALSE

//Self-naming/numbering ones.
/obj/effect/shuttle_landmark/automatic
	name = "Navpoint"
	landmark_tag = "navpoint"
	flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/automatic/Initialize()
	landmark_tag += "-[x]-[y]-[z]-[random_id("landmarks",1,9999)]"
	return ..()

/obj/effect/shuttle_landmark/automatic/sector_set(var/obj/effect/overmap/visitable/O)
	..()
	SetName("[initial(name)] ([x],[y])")

//Subtype that calls explosion on init to clear space for shuttles
/obj/effect/shuttle_landmark/automatic/clearing
	name = "clearing"
	var/radius = 10

/obj/effect/shuttle_landmark/automatic/clearing/Initialize(var/ml, var/supplied_radius)
	..()
	if(!isnull(supplied_radius))
		radius = supplied_radius
	return INITIALIZE_HINT_LATELOAD

/obj/effect/shuttle_landmark/automatic/clearing/LateInitialize()
	..()
	for(var/turf/T in range(radius, src))
		if(T.density)
			T.ChangeTurf(get_base_turf_by_area(T))
		T.turf_flags |= TURF_FLAG_NORUINS

//Used for custom landing locations. Self deletes after a shuttle leaves.
/obj/effect/shuttle_landmark/temporary
	name = "Landing Point"
	landmark_tag = "landing"
	flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/temporary/Initialize(var/mapload, var/secure = TRUE)
	landmark_tag += "-[random_id("landmarks",1,9999)]"
	if(!secure)
		flags |= (SLANDMARK_FLAG_DISCONNECTED | SLANDMARK_FLAG_ZERO_G)
	. = ..()

/obj/effect/shuttle_landmark/temporary/Destroy()
	SSshuttle.unregister_landmark(landmark_tag)
	return ..()

/obj/effect/shuttle_landmark/temporary/landmark_deselected(datum/shuttle/shuttle)
	if(shuttle.moving_status != SHUTTLE_INTRANSIT && shuttle.current_location != src)
		qdel(src)

/obj/effect/shuttle_landmark/temporary/shuttle_departed(datum/shuttle/shuttle)
	qdel(src)

/obj/item/spaceflare
	name = "long-range flare"
	desc = "Burst transmitter used to broadcast all needed information for shuttle navigation systems. Has a flare attached for marking the spot where you probably shouldn't be standing."
	icon = 'icons/obj/items/device/long_range_flare.dmi'
	icon_state = "bluflare"
	light_color = "#3728ff"
	material = /decl/material/solid/plastic
	var/active

/obj/item/spaceflare/attack_self(var/mob/user)
	if(!active)
		visible_message("<span class='notice'>[user] pulls the cord, activating the [src].</span>")
		activate()

/obj/item/spaceflare/proc/activate()
	if(active)
		return
	var/turf/T = get_turf(src)
	var/mob/M = loc
	if(istype(M) && !M.try_unequip(src, T))
		return

	active = 1
	anchored = 1

	var/obj/effect/shuttle_landmark/automatic/mark = new(T)
	mark.SetName("Beacon signal ([T.x],[T.y])")
	T.hotspot_expose(1500, 5)
	update_icon()

/obj/item/spaceflare/on_update_icon()
	. = ..()
	if(active)
		icon_state = "bluflare_on"
		set_light(6, 2, "#85d1ff")