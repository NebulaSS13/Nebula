/obj/machinery/holomap
	name = "holomap"
	desc = "A screen that projects a map of the surrounding structure."
	icon = 'icons/obj/machines/stationmap.dmi'
	icon_state = "station_map"
	anchored = TRUE
	density = FALSE
	use_power = POWER_USE_IDLE
	idle_power_usage = 10
	active_power_usage = 500
	light_color = "#64c864"
	uncreated_component_parts = null
	construct_state = /decl/machine_construction/default/panel_closed
	base_type = /obj/machinery/holomap
	layer = ABOVE_WINDOW_LAYER	// Above windows.
	directional_offset = @'{"NORTH":{"y":-32}, "SOUTH":{"y":32}, "EAST":{"x":-32}, "WEST":{"x":32}}'

	var/light_power_on = 1
	var/light_range_on = 2
	var/mob/watching_mob
	var/image/small_station_map
	var/image/floor_markings
	/// z-level on which the station map was initialized.
	var/original_zLevel = 1
	/// set to FALSE when you initialize the station map on a zLevel that has its own icon formatted for use by station holomaps.
	var/bogus = TRUE
	var/datum/station_holomap/holomap_datum

/obj/machinery/holomap/Destroy()
	SSminimap.station_holomaps -= src
	stopWatching()
	QDEL_NULL(holomap_datum)
	return ..()

/obj/machinery/holomap/Initialize()
	if(!loc)
		return INITIALIZE_HINT_QDEL
	holomap_datum = new()
	original_zLevel = loc.z
	bogus = FALSE
	. = ..()
	SSminimap.station_holomaps += src
	if(SSminimap.initialized)
		update_map_data()
	floor_markings = image('icons/obj/machines/stationmap.dmi', "decal_station_map")
	floor_markings.dir = src.dir
	update_icon()

/obj/machinery/holomap/proc/update_map_data()
	if(!SSminimap.holomaps[original_zLevel])
		bogus = TRUE
		holomap_datum.initialize_holomap_bogus()
		update_icon()
		return

	holomap_datum.initialize_holomap(get_turf(src), reinit = TRUE)

	small_station_map = image(icon = SSminimap.holomaps[original_zLevel].holomap_small)
	small_station_map.plane = ABOVE_LIGHTING_PLANE
	small_station_map.layer = ABOVE_LIGHTING_LAYER

	update_icon()

/obj/machinery/holomap/attack_hand(var/mob/user)
	if(user.check_intent(I_FLAG_HARM))
		return ..()
	if(watching_mob && (watching_mob != user))
		to_chat(user, SPAN_WARNING("Someone else is currently watching the holomap."))
		return TRUE
	if(user.loc != loc)
		to_chat(user, SPAN_WARNING("You need to stand in front of \the [src]."))
		return TRUE
	startWatching(user)
	return TRUE

// Let people bump up against it to watch
/obj/machinery/holomap/Bumped(var/atom/movable/AM)
	if(!watching_mob && isliving(AM) && AM.loc == loc)
		startWatching(AM)

// In order to actually get Bumped() we need to block movement.  We're (visually) on a wall, so people
// couldn't really walk into us anyway.  But in reality we are on the turf in front of the wall, so bumping
// against where we seem is actually trying to *exit* our real loc
/obj/machinery/holomap/CheckExit(atom/movable/mover as mob|obj, turf/target as turf)
	if(get_dir(target, loc) == dir) // Opposite of "normal" since we are visually in the next turf over
		return FALSE
	else
		return TRUE

/obj/machinery/holomap/proc/startWatching(var/mob/user)
	if(!isliving(user) || !anchored || !operable() || !user.client)
		return FALSE

	var/datum/global_hud/global_hud = get_global_hud()
	holomap_datum.station_map.loc = global_hud.holomap  // Put the image on the holomap hud
	holomap_datum.station_map.alpha = 0 // Set to transparent so we can fade in
	animate(holomap_datum.station_map, alpha = 255, time = 5, easing = LINEAR_EASING)
	flick("station_map_activate", src)
	user.client.screen |= global_hud.holomap
	user.client.images |= holomap_datum.station_map

	watching_mob = user
	events_repository.register(/decl/observ/moved, watching_mob, src, TYPE_PROC_REF(/obj/machinery/holomap, checkPosition))
	events_repository.register(/decl/observ/destroyed, watching_mob, src, TYPE_PROC_REF(/obj/machinery/holomap, stopWatching))
	update_use_power(POWER_USE_ACTIVE)

	if(bogus)
		to_chat(user, SPAN_WARNING("The holomap failed to initialize. This area of space cannot be mapped."))
	else
		to_chat(user, SPAN_NOTICE("A hologram of your current location appears before your eyes."))

	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/holomap/Process()
	if(!operable())
		stopWatching()
		return PROCESS_KILL

/obj/machinery/holomap/proc/checkPosition()
	if(!watching_mob || (watching_mob.loc != loc) || (dir != watching_mob.dir))
		stopWatching()

/obj/machinery/holomap/proc/stopWatching()
	if(watching_mob)
		if(watching_mob.client)
			animate(holomap_datum.station_map, alpha = 0, time = 5, easing = LINEAR_EASING)
			var/mob/M = watching_mob
			addtimer(CALLBACK(src, PROC_REF(clear_image), M, holomap_datum.station_map), 5, TIMER_CLIENT_TIME)//we give it time to fade out
		events_repository.unregister(/decl/observ/moved, watching_mob, src)
		events_repository.unregister(/decl/observ/destroyed, watching_mob, src)
	watching_mob = null
	update_use_power(POWER_USE_IDLE)
	if(holomap_datum)
		holomap_datum.legend_deselect()

/obj/machinery/holomap/proc/clear_image(mob/M, image/I)
	if (M.client)
		M.client.images -= I

/obj/machinery/holomap/on_update_icon()
	. = ..()
	cut_overlays()
	if(stat & BROKEN)
		icon_state = "station_mapb"
		set_light(0)
	else if((stat & NOPOWER) || !anchored)
		icon_state = "station_map0"
		set_light(0)
	else
		icon_state = "station_map"
		set_light(light_range_on, light_power_on, "#1dbe17")
		// Put the little "map" overlay down where it looks nice
		if(small_station_map)
			add_overlay(small_station_map)
	if(floor_markings)
		floor_markings.dir = src.dir
		floor_markings.pixel_x = -src.pixel_x
		floor_markings.pixel_y = -src.pixel_y
		add_overlay(floor_markings)
	if(panel_open)
		add_overlay("station_map-panel")

/obj/machinery/holomap/explosion_act(severity)
	. = ..()
	if(!QDELETED(src))
		switch(severity)
			if(1)
				qdel(src)
			if(2)
				if(prob(50))
					qdel(src)
				else
					set_broken()
			if(3)
				if(prob(25))
					set_broken()

// Simple datum to keep track of a running holomap. Each machine capable of displaying the holomap will have one.
/datum/station_holomap
	var/image/station_map
	var/image/cursor
	var/list/obj/screen/holomap_legend/legend
	var/list/obj/screen/holomap_text/maptexts
	var/list/obj/screen/holomap_level_select/lbuttons
	var/list/image/levels
	var/list/z_levels
	var/z = -1
	var/displayed_level = 1 //Index of level to display

/datum/station_holomap/Destroy(force)
	QDEL_NULL(station_map)
	QDEL_NULL(cursor)
	QDEL_NULL_LIST(legend)
	QDEL_NULL_LIST(lbuttons)
	QDEL_LIST_ASSOC_VAL(maptexts)
	QDEL_LIST_ASSOC_VAL(levels)
	LAZYCLEARLIST(maptexts)
	LAZYCLEARLIST(levels)
	LAZYCLEARLIST(z_levels)
	. = ..()

/datum/station_holomap/proc/initialize_holomap(turf/T, isAI = null, mob/user = null, reinit = FALSE)
	z = T.z
	if(!cursor || reinit)
		cursor = image('icons/misc/holomap_markers.dmi', "you")
		cursor.layer = HUD_ABOVE_ITEM_LAYER

	if(!LAZYLEN(legend) || reinit)
		QDEL_LIST_ASSOC_VAL(legend)
		legend = list(
			new /obj/screen/holomap_legend(null, null, null, null, null, HOLOMAP_AREACOLOR_COMMAND, "■ Command"),
			new /obj/screen/holomap_legend(null, null, null, null, null, HOLOMAP_AREACOLOR_SECURITY, "■ Security"),
			new /obj/screen/holomap_legend(null, null, null, null, null, HOLOMAP_AREACOLOR_MEDICAL, "■ Medical"),
			new /obj/screen/holomap_legend(null, null, null, null, null, HOLOMAP_AREACOLOR_SCIENCE, "■ Research"),
			new /obj/screen/holomap_legend(null, null, null, null, null, HOLOMAP_AREACOLOR_EXPLORATION, "■ Exploration"),
			new /obj/screen/holomap_legend(null, null, null, null, null, HOLOMAP_AREACOLOR_ENGINEERING, "■ Engineering"),
			new /obj/screen/holomap_legend(null, null, null, null, null, HOLOMAP_AREACOLOR_CARGO, "■ Supply"),
			new /obj/screen/holomap_legend(null, null, null, null, null, HOLOMAP_AREACOLOR_AIRLOCK, "■ Airlock"),
			new /obj/screen/holomap_legend(null, null, null, null, null, HOLOMAP_AREACOLOR_ESCAPE, "■ Escape"),
			new /obj/screen/holomap_legend(null, null, null, null, null, HOLOMAP_AREACOLOR_CREW, "■ Crew"),
			new /obj/screen/holomap_legend/cursor(null, null, null, null, null, HOLOMAP_AREACOLOR_BASE, "You are here")
		)
	if(reinit)
		QDEL_NULL_LIST(lbuttons)
		QDEL_LIST_ASSOC_VAL(maptexts)
		LAZYCLEARLIST(maptexts)
		LAZYCLEARLIST(levels)
		LAZYCLEARLIST(z_levels)

	station_map = image(icon(HOLOMAP_ICON, "stationmap"))
	station_map.layer = UNDER_HUD_LAYER

	//This is where the fun begins
	if(length(global.using_map.overmap_ids))
		var/obj/effect/overmap/visitable/O = global.overmap_sectors["[z]"]

		if(isAI)
			T = get_turf(user.client.eye)
		cursor.pixel_x = (T.x - 6 + (HOLOMAP_ICON_SIZE / 2) - WORLD_CENTER_X) * PIXEL_MULTIPLIER + HOLOMAP_PIXEL_OFFSET_X(z)
		cursor.pixel_y = (T.y - 6 + (HOLOMAP_ICON_SIZE / 2) - WORLD_CENTER_Y) * PIXEL_MULTIPLIER + HOLOMAP_PIXEL_OFFSET_Y(z)

		//For the given z level fetch the related map sector and build the list
		if(istype(O))
			var/z_count = length(O.map_z)
			var/current_z_index = 1
			z_levels = O.map_z.Copy()

			if(z_count > 1)
				if(!LAZYLEN(lbuttons))
					//Add the buttons for switching levels
					LAZYADD(lbuttons, new /obj/screen/holomap_level_select/up(null, null, null, null, null, src))
					LAZYADD(lbuttons, new /obj/screen/holomap_level_select/down(null, null, null, null, null, src))
				lbuttons[1].pixel_y = HOLOMAP_MARGIN - 22
				lbuttons[2].pixel_y = HOLOMAP_MARGIN + 5
				lbuttons[1].pixel_x = 254
				lbuttons[2].pixel_x = 196

			//Each level now has to be built and offset properly. Then stored to be showed later
			for(var/level = 1; level <= z_count; level++)
				if (z == O.map_z[level])
					current_z_index = level

				//Turfs and walls
				var/image/map_image = image(SSminimap.holomaps[O.map_z[level]].holomap_base)

				map_image.color = COLOR_HOLOMAP_HOLOFIER
				map_image.layer = HUD_BASE_LAYER

				map_image.pixel_x = (HOLOMAP_ICON_SIZE / 2) - WORLD_CENTER_X
				map_image.pixel_y = (HOLOMAP_ICON_SIZE / 2) - WORLD_CENTER_Y

				//Store the image for future use
				//LAZYADD(levels, map_image)
				LAZYSET(levels, "[O.map_z[level]]", map_image)

				var/obj/screen/holomap_text/maptext_overlay = new(null)
				maptext_overlay.maptext = STYLE_SMALLFONTS_OUTLINE("<center>LEVEL [level-1]</center>", 7, COLOR_WHITE, COLOR_BLACK)
				maptext_overlay.pixel_x = (HOLOMAP_ICON_SIZE / 2) - (maptext_overlay.maptext_width / 2)
				maptext_overlay.pixel_y = HOLOMAP_MARGIN

				LAZYSET(maptexts, "[O.map_z[level]]", maptext_overlay)

			//Reset to starting zlevel
			set_level(current_z_index)

/datum/station_holomap/proc/set_level(level)
	if(level > z_levels.len)
		return

	displayed_level = level

	station_map.overlays.Cut()
	station_map.vis_contents.Cut()

	if(z == z_levels[displayed_level])
		station_map.overlays += cursor

	station_map.overlays += LAZYACCESS(levels, "[z_levels[displayed_level]]")
	station_map.vis_contents += LAZYACCESS(maptexts, "[z_levels[displayed_level]]")

	//Fix legend position
	var/pixel_y = HOLOMAP_LEGEND_Y
	for(var/obj/screen/holomap_legend/element in legend)
		element.holomap = src
		element.pixel_y = pixel_y //Set adjusted pixel y as it will be needed for area placement
		element.Setup(z_levels[displayed_level])
		if(element.has_areas)
			pixel_y -= 10
			station_map.vis_contents += element

	if(displayed_level > 1)
		station_map.vis_contents += lbuttons[1]

	if(displayed_level < z_levels.len)
		station_map.vis_contents += lbuttons[2]

/datum/station_holomap/proc/legend_select(obj/screen/holomap_legend/L)
	legend_deselect()
	L.Select()

/datum/station_holomap/proc/legend_deselect()
	for(var/obj/screen/holomap_legend/entry in legend)
		entry.Deselect()

/datum/station_holomap/proc/initialize_holomap_bogus()
	station_map = image('icons/480x480.dmi', "stationmap")
	station_map.overlays |= image('icons/effects/64x64.dmi', "notfound", pixel_x = 7 * WORLD_ICON_SIZE, pixel_y = 7 * WORLD_ICON_SIZE)
