/datum/build_mode/areas
	name = "Area Editor"
	icon_state = "buildmode10"
	click_interactions = list(
		/decl/build_mode_interaction/areas/set_turf_area,
		/decl/build_mode_interaction/areas/copy_turf_area,
		/decl/build_mode_interaction/areas/copy_turf_area/alt
	)

	var/static/list/distinct_colors = list(
		"#e6194b",
		"#3cb44b",
		"#ffe119",
		"#4363d8",
		"#f58231",
		"#42d4f4",
		"#f032e6",
		"#fabebe",
		"#469990",
		"#e6beff",
		"#9a6324",
		"#fffac8",
		"#800000",
		"#aaffc3",
		"#000075",
		"#a9a9a9",
		"#ffffff",
		"#000000"
	)
	var/area/selected_area
	var/list/vision_images = list()

/datum/build_mode/areas/Destroy()
	UnselectArea()
	Unselected()
	. = ..()


/datum/build_mode/areas/Configurate()
	var/mode = alert("Pick or Create an area.", "Build Mode: Areas", "Pick", "Create", "Cancel")
	if (mode == "Pick")
		var/area/path = select_subpath((selected_area?.type || /area/space), /area)
		if (path)
			for (var/area/R in global.areas)
				if (R.type == path)
					SelectArea(R)
					to_chat(user, "Picked area [selected_area.proper_name]")
					break
	else if (mode == "Create")
		var/new_name = input("New area name:", "Build Mode: Areas") as text|null
		if (!new_name)
			return
		var/area/new_area = new
		new_area.SetName(new_name)
		new_area.power_equip = 0
		new_area.power_light = 0
		new_area.power_environ = 0
		new_area.always_unpowered = 0
		SelectArea(new_area)
		user.client.debug_variables(selected_area)
		to_chat(user, "Created area [new_area.proper_name]")

/datum/build_mode/areas/TimerEvent()
	user.client.images -= vision_images
	vision_images = list()

	var/used_colors = 0
	var/list/max_colors = length(distinct_colors)
	var/list/vision_colors = list()
	for (var/turf/T in range(user?.client?.view || world.view, user))
		var/image/I = new('icons/turf/overlays.dmi', T, "whiteOverlay")
		var/ref = "\ref[T.loc]"
		if (!vision_colors[ref])
			if (++used_colors > max_colors)
				vision_colors[ref] = "#" + copytext(md5(ref), 1, 7)
			else
				vision_colors[ref] = distinct_colors[used_colors]
		I.color = vision_colors[ref]
		I.plane = ABOVE_LIGHTING_PLANE
		I.layer = ABOVE_LIGHTING_LAYER
		I.appearance_flags = RESET_COLOR|RESET_ALPHA|RESET_TRANSFORM|NO_CLIENT_COLOR|KEEP_APART
		vision_images.Add(I)
	user.client.images += vision_images

/datum/build_mode/areas/Unselected()
	user.client.images -= vision_images
	vision_images = list()

/datum/build_mode/areas/proc/SelectArea(var/area/A)
	if(!A || A == selected_area)
		return
	UnselectArea()
	selected_area = A
	events_repository.register(/decl/observ/destroyed, selected_area, src, PROC_REF(UnselectArea))

/datum/build_mode/areas/proc/UnselectArea()
	if(!selected_area)
		return
	events_repository.unregister(/decl/observ/destroyed, selected_area, src, PROC_REF(UnselectArea))

	var/has_turf = FALSE
	for(var/turf/T in selected_area)
		has_turf = TRUE
		break
	if(!has_turf)
		qdel(selected_area)
	selected_area = null

/decl/build_mode_interaction/areas
	abstract_type = /decl/build_mode_interaction/areas

/decl/build_mode_interaction/areas/set_turf_area
	description    = "Set turf area."
	trigger_params = list("left")

/decl/build_mode_interaction/areas/set_turf_area/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)
	var/turf/T = get_turf(A)
	var/datum/build_mode/areas/area_mode = build_mode
	if(!istype(T) || !istype(area_mode))
		return FALSE
	if (area_mode.selected_area)
		ChangeArea(T, area_mode.selected_area)
		to_chat(build_mode.user, SPAN_NOTICE("Set area of turf [T.name] to [area_mode.selected_area.proper_name]"))
		return TRUE
	to_chat(build_mode.user, SPAN_WARNING("Pick or create an area first"))
	return FALSE

/decl/build_mode_interaction/areas/copy_turf_area
	description    = "Copy turf area."
	trigger_params = list("left", "ctrl")

/decl/build_mode_interaction/areas/copy_turf_area/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)
	var/datum/build_mode/areas/area_mode = build_mode
	if(istype(area_mode))
		area_mode.selected_area = get_area(A)
		if(area_mode.selected_area)
			to_chat(build_mode.user, SPAN_NOTICE("Picked area [area_mode.selected_area.proper_name]"))
		else
			to_chat(build_mode.user, SPAN_NOTICE("Cleared selected area."))
		return TRUE
	return FALSE

/decl/build_mode_interaction/areas/copy_turf_area/alt
	trigger_params = list("middle")

/decl/build_mode_interaction/areas/list_or_create_area
	description    = "List or create area."
	trigger_params = list("right")

/decl/build_mode_interaction/areas/list_or_create_area/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)
	var/datum/build_mode/areas/area_mode = build_mode
	if(istype(area_mode))
		area_mode.Configurate()
		return TRUE
	return FALSE
