/turf/exterior
	name = "ground"
	icon = 'icons/turf/exterior/barren.dmi'
	footstep_type = /decl/footsteps/asteroid
	icon_state = "0"
	layer = PLATING_LAYER
	open_turf_type = /turf/exterior/open
	turf_flags = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH
	zone_membership_candidate = TRUE
	var/base_color
	var/diggable = 1
	var/dirt_color = "#7c5e42"
	var/possible_states = 0
	var/icon_edge_layer = -1
	var/icon_edge_states
	var/icon_has_corners = FALSE
	///If this turf is on a level that belongs to a planetoid, this is a reference to that planetoid.
	var/datum/planetoid_data/owner
	///Overrides the level's strata for this turf.
	var/strata_override
	var/decl/material/material

/turf/exterior/Initialize(mapload, no_update_icon = FALSE)

	if(base_color)
		color = base_color
	else
		color = null

	if(possible_states > 0)
		icon_state = "[rand(0, possible_states)]"

	//Grab owner and set base area if we don't have a valid area
	owner = LAZYACCESS(SSmapping.planetoid_data_by_z, z)
	if(!istype(owner))
		owner = null
	else if(istype(loc, world.area))
		//Must be done here, as light data is not fully carried over by ChangeTurf (but overlays are).
		//If on the surface level, and the planet defines a surface area, prioritize it.
		var/datum/level_data/L = SSmapping.levels_by_z[z]
		if(L.level_id == owner.surface_level_id && owner.surface_area)
			ChangeArea(src, owner.surface_area)
		//Otherwise fall back to the level_data's base_area
		else if(L.base_area)
			ChangeArea(src, L.get_base_area_instance())

	. = ..(mapload)	// second param is our own, don't pass to children

	if (no_update_icon)
		return

	// If this is a mapload, then our neighbors will be updating their own icons too -- doing it for them is rude.
	if(mapload)
		update_icon()
	else
		for(var/direction in global.alldirs)
			var/turf/target_turf = get_step_resolving_mimic(src, direction)
			if(istype(target_turf))
				if(TICK_CHECK) // not CHECK_TICK -- only queue if the server is overloaded
					target_turf.queue_icon_update()
				else
					target_turf.update_icon()

/turf/exterior/is_floor()
	return !density && !is_open()

/turf/exterior/is_plating()
	return !density

/turf/exterior/can_engrave()
	return FALSE

/turf/exterior/Destroy()
	owner = null
	. = ..()

/turf/exterior/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/exterior/attackby(obj/item/C, mob/user)
	//#TODO: Add some way to dig to lower levels?
	if(diggable && IS_SHOVEL(C))
		if(C.do_tool_interaction(TOOL_SHOVEL, user, src, 5 SECONDS))
			new /obj/structure/pit(src)
			diggable = FALSE
		else
			to_chat(user, SPAN_NOTICE("You stop shoveling."))
		return TRUE

	if(istype(C, /obj/item/stack/tile))
		var/obj/item/stack/tile/T = C
		T.try_build_turf(user, src)
		return TRUE

	. = ..()

/turf/exterior/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	if(!istype(src, get_base_turf_by_area(src)) && (severity == 1 || (severity == 2 && prob(40))))
		ChangeTurf(get_base_turf_by_area(src))

/turf/exterior/on_update_icon()
	. = ..() // Recalc AO and flooding overlay.
	cut_overlays()
	if(LAZYLEN(decals))
		add_overlay(decals)

	if(icon_edge_layer < 0)
		return

	var/neighbors = 0
	for(var/direction in global.cardinal)
		var/turf/exterior/turf_to_check = get_step_resolving_mimic(src, direction)
		if(!istype(turf_to_check) || turf_to_check.density)
			continue
		if(istype(turf_to_check, type))
			neighbors |= direction
			continue
		if(!istype(turf_to_check) || icon_edge_layer > turf_to_check.icon_edge_layer)
			var/image/I = image(icon, "edge[direction][icon_edge_states > 0 ? rand(0, icon_edge_states) : ""]")
			I.layer = layer + icon_edge_layer
			switch(direction)
				if(NORTH)
					I.pixel_y += world.icon_size
				if(SOUTH)
					I.pixel_y -= world.icon_size
				if(EAST)
					I.pixel_x += world.icon_size
				if(WEST)
					I.pixel_x -= world.icon_size
			add_overlay(I)

	if(icon_has_corners)
		for(var/direction in global.cornerdirs)
			var/turf/exterior/turf_to_check = get_step_resolving_mimic(src, direction)
			if(!isturf(turf_to_check) || turf_to_check.density || istype(turf_to_check, type))
				continue

			if(!istype(turf_to_check) || icon_edge_layer > turf_to_check.icon_edge_layer)
				var/draw_state
				var/res = (neighbors & direction)
				if(res == 0)
					draw_state = "edge[direction]"
				else if(res == direction)
					draw_state = "corner[direction]"
				if(draw_state && check_state_in_icon(draw_state, icon))
					var/image/I = image(icon, draw_state)
					I.layer = layer + icon_edge_layer
					if(direction & NORTH)
						I.pixel_y += world.icon_size
					else if(direction & SOUTH)
						I.pixel_y -= world.icon_size
					if(direction & EAST)
						I.pixel_x += world.icon_size
					else if(direction & WEST)
						I.pixel_x -= world.icon_size
					add_overlay(I)

/turf/exterior/on_defilement()
	..()
	if(density)
		ChangeTurf(/turf/simulated/wall/cult)
	else
		ChangeTurf(/turf/simulated/floor/cult)
