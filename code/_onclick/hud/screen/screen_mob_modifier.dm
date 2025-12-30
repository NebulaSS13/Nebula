/obj/screen/mob_modifiers
	screen_loc = "CENTER,TOP"
	icon_state = "blank"
	requires_ui_style = FALSE

	// Disable these due to vis_contents behaving oddly with them.
	use_supplied_ui_color = FALSE
	use_supplied_ui_alpha = FALSE

	// TODO: consider pooling these.
	var/list/elements
	var/const/modifier_size = 18

/obj/screen/mob_modifiers/Initialize(mapload, mob/_owner, decl/ui_style/ui_style, ui_color, ui_alpha, ui_cat)
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/screen/mob_modifiers/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	QDEL_NULL_LIST(elements)
	return ..()

/obj/screen/mob_modifiers/Process()
	if(QDELETED(src))
		return PROCESS_KILL
	var/mob/living/owner = owner_ref?.resolve()
	if(!istype(owner))
		return PROCESS_KILL
	for(var/obj/screen/mob_modifier/element in elements)
		var/expire_time = MOB_MODIFIER_INDEFINITE
		for(var/datum/mob_modifier/modifier in LAZYACCESS(owner._mob_modifiers, element.archetype))
			if(modifier.expire_time == MOB_MODIFIER_INDEFINITE)
				expire_time = MOB_MODIFIER_INDEFINITE
				break
			expire_time = max(expire_time, modifier.expire_time)
		if(istype(element))
			element.update_maptext(expire_time == MOB_MODIFIER_INDEFINITE ? MOB_MODIFIER_INDEFINITE : (expire_time - world.time))

/obj/screen/mob_modifiers/on_update_icon()

	if(QDELETED(src))
		return

	var/mob/living/owner = owner_ref?.resolve()
	if(!istype(owner) || !istype(owner.hud_used))
		return

	var/list/seen_archetypes
	var/list/elements_to_keep
	var/list/elements_to_add
	var/list/elements_to_remove

	// Track deltas for keeping/removing existing elements.
	for(var/obj/screen/mob_modifier/element in elements)
		var/list/modifiers = LAZYACCESS(owner._mob_modifiers, element.archetype)
		if(length(modifiers))
			LAZYADD(elements_to_keep, element)
		else
			LAZYADD(elements_to_remove, element)
		LAZYDISTINCTADD(seen_archetypes, element.archetype)

	var/decl/ui_style/ui_style = owner.hud_used.get_ui_style_data()
	var/ui_color               = owner.hud_used.get_ui_color()
	var/ui_alpha               = owner.hud_used.get_ui_alpha()

	// Create elements for new modifiers.
	for(var/decl/mob_modifier/archetype in owner._mob_modifiers)
		if(archetype in seen_archetypes)
			continue
		var/obj/screen/mob_modifier/element = new(null, owner, ui_style, ui_color, ui_alpha, HUD_MODIFIERS)
		element.archetype = archetype
		element.holder = src
		element.pixel_y = 32
		element.alpha = 0
		element.update_icon()
		LAZYADD(elements_to_add, element)

	// Fade out and delete expired markers.
	if(LAZYLEN(elements_to_remove))
		LAZYREMOVE(elements, elements_to_remove)
		for(var/obj/screen/mob_modifier/element in elements_to_remove)
			animate(element, alpha = 0, pixel_y = 32, time = 5)
			QDEL_IN(element, 5)

	// Add our new records.
	if(LAZYLEN(elements_to_add))
		LAZYADD(elements, elements_to_add)
		add_vis_contents(elements_to_add)

	// Adjust positions and fade in new elements.
	if(length(elements))
		var/offset_x = -(((length(elements)-1) * modifier_size) / 2)
		for(var/obj/screen/element in elements)
			if(element in elements_to_add)
				pixel_x = offset_x
			animate(element, alpha = 255, pixel_x = offset_x, pixel_y = 0, time = 5)
			offset_x += modifier_size

/obj/screen/mob_modifier
	alpha             = 0
	screen_loc        = null // not handled via screen loc, but via vis contents of the holder object.
	maptext_x         = -8
	maptext_y         = -3
	icon_state        = "modifier_base"
	// these must be enabled
	use_supplied_ui_alpha = TRUE
	use_supplied_ui_color = TRUE
	var/decl/mob_modifier/archetype
	var/obj/screen/mob_modifiers/holder

/obj/screen/mob_modifier/Destroy()
	if(holder)
		LAZYREMOVE(holder.elements, src)
		holder.remove_vis_contents(src)
		holder = null
	return ..()

/obj/screen/mob_modifier/rebuild_screen_overlays()
	. = ..()
	if(archetype)
		add_overlay(overlay_image(archetype.hud_icon, archetype.hud_icon_state, COLOR_WHITE, RESET_COLOR))

/obj/screen/mob_modifier/proc/update_maptext(duration)
	if(archetype.hide_expiry)
		maptext = null
		return

	if(duration == MOB_MODIFIER_INDEFINITE)
		if(archetype.show_indefinite_duration)
			maptext = STYLE_SMALLFONTS_OUTLINE("<center>∞</center>", 12, COLOR_WHITE, COLOR_BLACK)
		else
			maptext = null
	else if(duration <= 0)
		maptext = STYLE_SMALLFONTS_OUTLINE("<center>0</center>", 7, COLOR_WHITE, COLOR_BLACK)
	else
		maptext = STYLE_SMALLFONTS_OUTLINE("<center>[ticks2shortreadable(duration) || 0]</center>", 7, COLOR_WHITE, COLOR_BLACK)

/obj/screen/mob_modifier/handle_click(mob/user, params)
	if((. = ..()))
		var/mob/living/owner = owner_ref?.resolve()
		if(istype(owner) && archetype)
			var/list/modifiers = LAZYACCESS(owner._mob_modifiers, archetype)
			for(var/datum/mob_modifier/modifier in modifiers)
				modifier.on_modifier_click(params)
				return

/obj/screen/mob_modifier/MouseEntered(location, control, params)
	if(archetype && (archetype.name || archetype.desc))
		openToolTip(user = usr, tip_src = src, params = params, title = archetype.name, content = archetype.desc)
	..()

/obj/screen/mob_modifier/MouseDown()
	closeToolTip(usr)
	..()

/obj/screen/mob_modifier/MouseExited()
	closeToolTip(usr)
	..()
