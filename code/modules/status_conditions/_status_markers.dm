/obj/status_marker
	name = ""
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	simulated = FALSE
	alpha = 0
	plane = DEFAULT_PLANE
	layer = POINTER_LAYER
	vis_flags = VIS_INHERIT_ID

/obj/status_marker/Initialize(var/ml, var/decl/status_condition/status)

	. = ..()

	if(!istype(status))
		return INITIALIZE_HINT_QDEL
	icon = status.status_marker_icon
	icon_state = status.status_marker_state

	// Throwing these in here in the hopes of preventing the markers showing up in right click.
	name = ""
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	verbs.Cut()

/datum/status_marker_holder
	var/list/markers
	var/image/mob_image
	var/list/markers_personal
	var/image/mob_image_personal

/datum/status_marker_holder/proc/clear_markers()
	for(var/marker as anything in markers)
		animate(markers[marker], pixel_z = 12, alpha = 0, time = 3)
	for(var/marker as anything in markers_personal)
		animate(markers_personal[marker], pixel_z = 12, alpha = 0, time = 3)

/datum/status_marker_holder/New(var/mob/owner)

	..()

	if(!istype(owner))
		PRINT_STACK_TRACE("Status marker holder created with an invalid owner: [owner || "NULL"].")
		return

	mob_image = new /image
	mob_image.loc = owner
	mob_image.appearance_flags |= (RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM|KEEP_APART)
	mob_image.plane = DEFAULT_PLANE
	mob_image.layer = POINTER_LAYER

	animate(mob_image, pixel_z =  1, time = 3, easing = (SINE_EASING | EASE_OUT), loop = -1)
	animate(           pixel_z = -1, time = 6, easing =  SINE_EASING,             loop = -1)
	animate(           pixel_z =  0, time = 3, easing = (SINE_EASING | EASE_IN),  loop = -1)

	mob_image_personal = new /image
	mob_image_personal.loc = owner
	mob_image_personal.appearance_flags |= (RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM|KEEP_APART)
	mob_image_personal.plane = DEFAULT_PLANE
	mob_image_personal.layer = POINTER_LAYER

	animate(mob_image_personal, pixel_z =  1, time = 3, easing = (SINE_EASING | EASE_OUT), loop = -1)
	animate(           pixel_z = -1, time = 6, easing =  SINE_EASING,             loop = -1)
	animate(           pixel_z =  0, time = 3, easing = (SINE_EASING | EASE_IN),  loop = -1)

	var/list/all_status = decls_repository.get_decls_of_subtype(/decl/status_condition)
	for(var/status_type in all_status)
		var/decl/status_condition/status = all_status[status_type]
		if(status.status_marker_icon && status.status_marker_state)

			var/obj/status_marker/marker = new(null, status)
			mob_image.add_vis_contents(marker)
			LAZYSET(markers, status, marker)

			marker = new(null, status)
			mob_image_personal.add_vis_contents(marker)
			LAZYSET(markers_personal, status, marker)

	global.status_marker_holders += src
	for(var/client/C)
		if(C.mob && C.get_preference_value(/datum/client_preference/show_status_markers) == PREF_SHOW)
			if(C.mob.status_markers == src)
				C.images |= mob_image_personal
			else
				C.images |= mob_image

/datum/status_marker_holder/Destroy()
	for(var/client/C)
		C.images -= mob_image
		C.images -= mob_image_personal
	global.status_marker_holders -= src
	if(mob_image)
		mob_image.clear_vis_contents()
		mob_image = null
	if(mob_image_personal)
		mob_image_personal.clear_vis_contents()
		mob_image_personal = null
	for(var/key in markers)
		qdel(markers[key])
	markers = null
	for(var/key in markers_personal)
		qdel(markers_personal[key])
	markers_personal = null
	. = ..()

/datum/status_marker_holder/proc/apply_offsets(var/mob/owner, var/list/markers_to_check, var/check_show_status = TRUE)
	var/list/visible_markers
	for(var/decl/status_condition/stat as anything in markers_to_check)
		if(HAS_STATUS(owner, stat.type) && (!check_show_status || stat.show_status(owner)))
			LAZYADD(visible_markers, markers_to_check[stat])
		else
			var/obj/marker = markers_to_check[stat]
			if(marker.alpha != 0 || marker.pixel_z != 12)
				animate(markers_to_check[stat], pixel_z = 12, alpha = 0, time = 3)
	if(length(visible_markers))
		var/x_offset = 12 - round(((length(visible_markers)-1) * 5))
		var/y_offset = (world.icon_size - 4)
		var/decl/bodytype/bodytype = owner.get_bodytype()
		if(bodytype)
			x_offset += bodytype.antaghud_offset_x
			y_offset += bodytype.antaghud_offset_y
		for(var/i = 1 to length(visible_markers))
			var/obj/marker = visible_markers[i]
			var/new_x_offset = x_offset + ((i-1) * 10)
			if(marker.pixel_w != new_x_offset || marker.pixel_z != y_offset || marker.alpha != 255)
				if(marker.alpha == 0) // Avoid animating them popping over from the bottom left on initial appearance.
					marker.pixel_w = new_x_offset
				animate(marker, pixel_w = new_x_offset, alpha = 255, pixel_z = y_offset, time = 3)

/datum/status_marker_holder/proc/refresh_markers(var/mob/owner)
	if(!istype(owner) || QDELETED(owner))
		clear_markers()
	else
		apply_offsets(owner, markers, TRUE)
		apply_offsets(owner, markers_personal, FALSE)
