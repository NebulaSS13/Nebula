/turf/exterior
	name = "ground"
	icon = 'icons/turf/exterior/barren.dmi'
	footstep_type = /decl/footsteps/asteroid
	icon_state = "0"
	layer = PLATING_LAYER
	open_turf_type = /turf/exterior/open
	turf_flags = TURF_FLAG_BACKGROUND
	var/diggable = 1
	var/dirt_color = "#7c5e42"
	var/possible_states = 0
	var/icon_edge_layer = -1
	var/icon_edge_states
	var/icon_has_corners = FALSE
	var/list/affecting_heat_sources
	var/obj/effect/overmap/visitable/sector/exoplanet/owner

// Bit faster than return_air() for exoplanet exterior turfs
/turf/exterior/get_air_graphic()
	if(owner)
		return owner.atmosphere?.graphic
	return global.using_map.exterior_atmosphere?.graphic

/turf/exterior/Initialize(mapload, no_update_icon = FALSE)

	color = null

	if(possible_states > 0)
		icon_state = "[rand(0, possible_states)]"
	owner = LAZYACCESS(global.overmap_sectors, "[z]")
	if(!istype(owner))
		owner = null
	else
		//Must be done here, as light data is not fully carried over by ChangeTurf (but overlays are).
		if(owner.planetary_area && istype(loc, world.area))
			ChangeArea(src, owner.planetary_area)

	. = ..(mapload)	// second param is our own, don't pass to children

	var/air_graphic = get_air_graphic()
	if(length(air_graphic))
		add_vis_contents(src, air_graphic)

	if (no_update_icon)
		return

	if (mapload)	// If this is a mapload, then our neighbors will be updating their own icons too -- doing it for them is rude.
		update_icon()
	else
		for (var/turf/T in RANGE_TURFS(src, 1))
			if (T == src)
				continue
			if (TICK_CHECK)	// not CHECK_TICK -- only queue if the server is overloaded
				T.queue_icon_update()
			else
				T.update_icon()

/turf/exterior/is_floor()
	return !density && !is_open()

/turf/exterior/ChangeTurf(var/turf/N, var/tell_universe = TRUE, var/force_lighting_update = FALSE, var/keep_air = FALSE)
	var/last_affecting_heat_sources = affecting_heat_sources
	var/turf/exterior/ext = ..()
	if(istype(ext))
		ext.affecting_heat_sources = last_affecting_heat_sources
	return ext

/turf/exterior/is_plating()
	return !density

/turf/exterior/can_engrave()
	return FALSE

/turf/exterior/Destroy()
	owner = null
	for(var/thing in affecting_heat_sources)
		var/obj/structure/fire_source/heat_source = thing
		LAZYREMOVE(heat_source.affected_exterior_turfs, src)
	affecting_heat_sources = null
	. = ..()

/turf/exterior/return_air()
	var/datum/gas_mixture/gas
	if(owner)
		gas = new
		gas.copy_from(owner.atmosphere)
	else
		gas = global.using_map.get_exterior_atmosphere()

	var/initial_temperature = gas.temperature
	if(weather)
		initial_temperature = weather.adjust_temperature(initial_temperature)
	for(var/thing in affecting_heat_sources)
		if((gas.temperature - initial_temperature) >= 100)
			break
		var/obj/structure/fire_source/heat_source = thing
		gas.temperature = gas.temperature + heat_source.exterior_temperature / max(1, get_dist(src, get_turf(heat_source)))
	return gas

/turf/exterior/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/exterior/attackby(obj/item/C, mob/user)

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
		var/turf/exterior/turf_to_check = get_step(src,direction)
		if(!turf_to_check || turf_to_check.density)
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
			var/turf/exterior/turf_to_check = get_step(src,direction)
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
