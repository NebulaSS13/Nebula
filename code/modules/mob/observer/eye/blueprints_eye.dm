#define MAX_AREA_SIZE 300

/mob/observer/eye/blueprints

	var/list/selected_turfs // Associative list of turfs -> boolean validity that the player has selected for new area creation.
	var/list/selection_images
	var/turf/last_selected_turf
	var/image/last_selected_image

	// On what Z-levels this can be used to modify or create areas.
	var/list/valid_z_levels

	// Displayed to the user to allow them to see what area they're hovering over.
	var/obj/effect/overlay/area_name_effect
	var/area_prefix

	// Displayed to the user on failed area creation.
	var/list/errors

/mob/observer/eye/blueprints/Initialize(var/mapload, var/list/valid_zls, var/area_p)
	. = ..(mapload)

	valid_z_levels = valid_zls.Copy()
	area_prefix = area_p

	area_name_effect = new()

	area_name_effect.maptext_height = 64
	area_name_effect.maptext_width = 128
	area_name_effect.layer = FLOAT_LAYER
	area_name_effect.plane = HUD_PLANE
	area_name_effect.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	area_name_effect.screen_loc = "LEFT+1,BOTTOM+2"

	last_selected_image = image('icons/effects/blueprints.dmi', "selected")
	last_selected_image.layer = OBSERVER_LAYER
	last_selected_image.plane = OBSERVER_PLANE
	last_selected_image.appearance_flags = NO_CLIENT_COLOR | RESET_COLOR

/mob/observer/eye/blueprints/Destroy()
	. = ..()
	QDEL_NULL(area_name_effect)
	LAZYCLEARLIST(errors)
	LAZYCLEARLIST(selected_turfs)
	LAZYCLEARLIST(selection_images)
	LAZYCLEARLIST(valid_z_levels)
	last_selected_turf = null

/mob/observer/eye/blueprints/release(var/mob/user)
	if(owner && owner.client && user == owner)
		owner.client.images.Cut()
	. = ..()

/mob/observer/eye/blueprints/proc/create_area()
	var/area_name = sanitize_safe(input("New area name:","Area Creation", ""), MAX_NAME_LEN)
	if(!area_name || !length(area_name))
		return
	if(length(area_name) > MAX_NAME_LEN)
		to_chat(owner, SPAN_WARNING("That name is too long!"))
		return

	if(!check_selection_validity())
		to_chat(owner, SPAN_WARNING("Could not mark area: [english_list(errors)]!"))
		return

	var/area/A = new
	A.SetName(area_name)
	for(var/turf/T in selected_turfs)
		ChangeArea(T, A)
	finalize_area(A)
	remove_selection() // Reset the selection for clarity.

/mob/observer/eye/blueprints/proc/finalize_area(area/A)
	A.power_equip = FALSE
	A.power_light = FALSE
	A.power_environ = FALSE
	A.always_unpowered = FALSE
	return A

/mob/observer/eye/blueprints/proc/remove_area()
	var/area/A = get_area(src)
	if(!check_modification_validity())
		return
	if(A.apc)
		to_chat(owner, SPAN_WARNING("You must remove the APC from this area before you can remove it from the blueprints!"))
		return
	to_chat(owner, SPAN_NOTICE("You scrub [A.proper_name] off the blueprints."))
	log_and_message_admins("deleted area [A.proper_name] via station blueprints.")
	var/turf/our_turf = get_turf(src)
	var/datum/level_data/our_level_data = SSmapping.levels_by_z[our_turf.z]
	var/area/base_area = our_level_data.get_base_area_instance()
	for(var/turf/T in A.contents)
		ChangeArea(T, base_area)
	if(!(locate(/turf) in A))
		qdel(A) // uh oh, is this safe?

/mob/observer/eye/blueprints/proc/edit_area()
	var/area/A = get_area(src)
	if(!check_modification_validity())
		return
	var/prevname = replacetext(A.name, "\improper ", "the ")
	var/new_area_name = sanitize_safe(input("Edit area name:","Area Editing", prevname), MAX_NAME_LEN)
	if(!new_area_name || !LAZYLEN(new_area_name) || new_area_name==prevname)
		return
	if(length(new_area_name) > MAX_NAME_LEN)
		to_chat(owner, SPAN_WARNING("Text too long."))
		return
	new_area_name = replacetext(new_area_name, regex(@"^the "), "\improper ")

	A.SetName(new_area_name)
	to_chat(owner, SPAN_NOTICE("You set the area '[prevname]' title to '[new_area_name]'."))

/mob/observer/eye/blueprints/ClickOn(var/atom/A, var/list/params)
	params = params2list(params)

	if(!canClick())
		return
	if(params["left"])
		update_selected_turfs(get_turf(A), params)

/mob/observer/eye/blueprints/proc/update_selected_turfs(var/turf/next_selected_turf, var/list/params)
	if(!next_selected_turf)
		return

	if(!last_selected_turf) // The player has only placed down one corner of the block.
		last_selected_turf = next_selected_turf
		last_selected_image.loc = last_selected_turf
		owner.client.images |= last_selected_image // Add an indicator for the first selected turf.
		return

	if(last_selected_turf.z != next_selected_turf.z) // No multi-Z areas. Contiguity checks this as well, but this is cheaper.
		return

	var/list/new_selection = block(last_selected_turf, next_selected_turf)

	if(params["shift"])		   // Shift click to remove areas from the selection.
		LAZYREMOVE(selected_turfs, new_selection)
	else
		LAZYDISTINCTADD(selected_turfs, new_selection)

	last_selected_image.loc = null // Remove the last selected turf indicator image.

	check_selection_validity()
	update_images()
	last_selected_turf = null

// Completes all the necessary checks for creating new areas, starting at the turf level before checking contiguity.
/mob/observer/eye/blueprints/proc/check_selection_validity()
	. = TRUE
	LAZYCLEARLIST(errors)

	if(!LAZYLEN(selected_turfs)) // Sanity check
		LAZYDISTINCTADD(errors, "no turfs are selected")
		return FALSE

	if(LAZYLEN(selected_turfs) > MAX_AREA_SIZE)
		LAZYDISTINCTADD(errors, "selection exceeds max size")
		return FALSE

	for(var/turf/T in selected_turfs)
		var/turf_valid = check_turf_validity(T)
		. = min(., turf_valid)
		LAZYSET(selected_turfs, T, turf_valid)

	if(!.) return // Skip checking contiguity if there's other errors with individual turfs.
	. = check_contiguity()

/mob/observer/eye/blueprints/proc/check_turf_validity(var/turf/T)
	. = TRUE
	if(!T)
		return FALSE
	if(!(T.z in valid_z_levels))
		LAZYDISTINCTADD(errors, "selection isn't marked on the blueprints")
		. = FALSE
	var/area/A = T.loc
	if(!A) // Safety check
		LAZYDISTINCTADD(errors, "selection overlaps unknown location")
		return FALSE
	if(!(A.area_flags & AREA_FLAG_IS_BACKGROUND)) // Cannot create new areas over old ones.
		LAZYDISTINCTADD(errors, "selection overlaps other area")
		. = FALSE
	var/datum/level_data/our_level_data = SSmapping.levels_by_z[T.z]
	if(istype(T, (A.base_turf ? A.base_turf : our_level_data.base_turf)))
		LAZYDISTINCTADD(errors, "selection is exposed to the outside")
		. = FALSE

/mob/observer/eye/blueprints/proc/check_contiguity()
	var/turf/start_turf = SAFEPICK(selected_turfs)
	if(!start_turf)
		LAZYDISTINCTADD(errors, "no turfs were selected")
		return FALSE
	var/list/pending_turfs = list(start_turf)
	var/list/checked_turfs = list()

	while(pending_turfs.len)
		if(LAZYLEN(checked_turfs) > MAX_AREA_SIZE)
			LAZYDISTINCTADD(errors, "selection exceeds max size")
			break
		var/turf/T = pending_turfs[1]
		pending_turfs -= T
		for(var/dir in global.cardinal)	// Floodfill to find all turfs contiguous with the randomly chosen start_turf.
			var/turf/NT = get_step(T, dir)
			if(!isturf(NT) || !(NT in selected_turfs) || (NT in pending_turfs) || (NT in checked_turfs))
				continue
			pending_turfs += NT

		checked_turfs += T

	var/list/noncontiguous_turfs = (selected_turfs.Copy() - checked_turfs)

	if(LAZYLEN(noncontiguous_turfs)) // If turfs still remain in noncontiguous_turfs, then the selection has unconnected parts.
		LAZYDISTINCTADD(errors, "selection must be contiguous")
		return FALSE

	return TRUE

// For checks independent of the selection.
/mob/observer/eye/blueprints/proc/check_modification_validity()
	. = TRUE
	var/area/A = get_area(src)
	if(!(A.z in valid_z_levels))
		to_chat(owner, SPAN_WARNING("The markings on this are entirely irrelevant to your whereabouts!"))
		return FALSE
	if(A in SSshuttle.shuttle_areas)
		to_chat(owner, SPAN_WARNING("This segment of the blueprints looks far too complex. Best not touch it!"))
		return FALSE
	if(!A || (A.area_flags & AREA_FLAG_IS_BACKGROUND))
		to_chat(owner, SPAN_WARNING("This area is not marked on the blueprints!"))
		return FALSE

/mob/observer/eye/blueprints/proc/remove_selection()
	LAZYCLEARLIST(selected_turfs)
	update_images()

/mob/observer/eye/blueprints/proc/update_images()
	if(!owner || !owner.client)
		return

	if(LAZYLEN(selection_images))
		owner.client.images -= selection_images
	LAZYCLEARLIST(selection_images)

	if(LAZYLEN(selected_turfs))
		for(var/turf/T in selected_turfs)
			var/selection_icon_state = selected_turfs[T] ? "valid" : "invalid"
			var/image/I = image('icons/effects/blueprints.dmi', T, selection_icon_state)
			I.plane = OBSERVER_PLANE
			I.layer = OBSERVER_LAYER
			I.appearance_flags = NO_CLIENT_COLOR | RESET_COLOR
			LAZYADD(selection_images, I)

	if(LAZYLEN(selection_images))
		owner.client.images += selection_images

/mob/observer/eye/blueprints/setLoc(var/turf/T)
	. = ..()
	if(.)
		var/style = "font-family: 'Fixedsys'; -dm-text-outline: 1 black; font-size: 11px;"
		var/area/A = get_area(src)
		if(!A)
			return
		area_name_effect.maptext = "<span style=\"[style]\">[area_prefix], [A.proper_name]</span>"

/mob/observer/eye/blueprints/apply_visual(var/mob/M)
	. = ..()
	if(!.) return

	M.overlay_fullscreen("blueprints", /obj/screen/fullscreen/blueprints)
	M.client.screen += area_name_effect
	M.add_client_color(/datum/client_color/achromatopsia)

/mob/observer/eye/blueprints/remove_visual(var/mob/M)
	. = ..()
	if(!.) return

	M.clear_fullscreen("blueprints", 0)
	M.client.screen -= area_name_effect
	M.remove_client_color(/datum/client_color/achromatopsia)

/mob/observer/eye/blueprints/additional_sight_flags()
	return SEE_TURFS|BLIND

// Shuttle blueprints eye
/mob/observer/eye/blueprints/shuttle
	var/shuttle_name

/mob/observer/eye/blueprints/shuttle/Initialize(mapload, list/valid_zls, area_prefix, shuttle_name)
	. = ..()
	src.shuttle_name = shuttle_name

/mob/observer/eye/blueprints/shuttle/check_modification_validity()
	. = TRUE
	var/area/A = get_area(src)
	if(!(A.z in valid_z_levels))
		to_chat(owner, SPAN_WARNING("The markings on this are entirely irrelevant to your whereabouts!"))
		return FALSE
	var/datum/shuttle/our_shuttle = SSshuttle.shuttles[shuttle_name]
	if(!(A in our_shuttle.shuttle_area))
		to_chat(owner, SPAN_WARNING("That's not a part of the [our_shuttle.display_name]!"))
		return FALSE
	if(!A || (A.area_flags & AREA_FLAG_IS_BACKGROUND))
		to_chat(owner, SPAN_WARNING("This area is not marked on the blueprints!"))
		return FALSE

/mob/observer/eye/blueprints/shuttle/remove_area()
	var/area/A = get_area(src)
	if(!check_modification_validity())
		return
	if(A.apc)
		to_chat(owner, SPAN_WARNING("You must remove the APC from this area before you can remove it from the blueprints!"))
		return
	var/datum/shuttle/our_shuttle = SSshuttle.shuttles[shuttle_name]
	to_chat(owner, SPAN_NOTICE("You scrub [A.proper_name] off the blueprints."))
	log_and_message_admins("deleted area [A.proper_name] from [our_shuttle.display_name] via shuttle blueprints.")
	var/turf/our_turf = get_turf(src)
	var/datum/level_data/our_level_data = SSmapping.levels_by_z[our_turf.z]
	var/area/base_area = our_level_data.get_base_area_instance()
	for(var/turf/T in A.contents)
		ChangeArea(T, base_area)
	if(!(locate(/turf) in A))
		qdel(A) // uh oh, is this safe?

/mob/observer/eye/blueprints/shuttle/finalize_area(area/A)
	A = ..(A)
	var/datum/shuttle/our_shuttle = SSshuttle.shuttles[shuttle_name]
	our_shuttle.shuttle_area += A
	SSshuttle.shuttle_areas += A
	events_repository.register(/decl/observ/destroyed, A, our_shuttle, /datum/shuttle/proc/remove_shuttle_area)
	return A

#undef MAX_AREA_SIZE