// This file is an experiment in changing the way item icons are handled.
// Not really expecting it to work out of the box, so we'll see how it goes
// with a handful of specific items.

// For checking if we have a specific state, for inventory icons and nonhumanoid species.
// Cached cause asking icons is expensive
var/list/icon_state_cache = list()
/proc/check_state_in_icon(var/checkstate, var/checkicon)
	var/list/check = global.icon_state_cache[checkicon]
	if(!check)
		check = list()
		for(var/istate in icon_states(checkicon))
			check[istate] = TRUE
		global.icon_state_cache[checkicon] = check
	. = check[checkstate]

/obj/item
	var/on_mob_icon
	var/on_mob_use_spritesheets  // use spritesheets list for on-mob icon
	var/tmp/has_inventory_icon	// do not set manually

/obj/item/Initialize(ml, material_key)
	. = ..()
	if(on_mob_icon)
		has_inventory_icon = check_state_in_icon(ICON_STATE_INV, icon)
		icon = on_mob_icon
		icon_state = ICON_STATE_WORLD
		update_icon()

/obj/item/hud_layerise()
	..()
	update_world_inventory_state()

/obj/item/reset_plane_and_layer()
	..()
	update_world_inventory_state()

/obj/item/proc/update_world_inventory_state()
	if(on_mob_icon && has_inventory_icon)
		var/last_state = icon_state
		icon_state = get_world_inventory_state()
		if(last_state != icon_state)
			update_icon()

/obj/item/proc/get_world_inventory_state()
	if(!on_mob_icon)
		return
	if(plane == HUD_PLANE && has_inventory_icon)
		return ICON_STATE_INV
	else
		return ICON_STATE_WORLD

/mob/proc/get_bodytype()
	return

/obj/item/proc/experimental_mob_overlay(var/mob/user_mob, var/slot)

	var/bodytype = lowertext(user_mob?.get_bodytype())
	var/useicon =  get_icon_for_bodytype(bodytype)
	if(bodytype != BODYTYPE_HUMANOID && (!bodytype || !check_state_in_icon("[bodytype]-[slot]", useicon)))
		bodytype = lowertext(BODYTYPE_HUMANOID)
		useicon = get_icon_for_bodytype(bodytype)

	var/useiconstate = "[bodytype]-[slot]"
	var/image/I = image(useicon, useiconstate)
	I.color = color
	I.appearance_flags = RESET_COLOR
	. = apply_offsets(user_mob,  bodytype, I, slot)
	. = apply_overlays(user_mob, bodytype, ., slot)

/mob/living/carbon/get_bodytype()
	. = species && species.get_bodytype(src)

/obj/item/proc/get_icon_for_bodytype(var/bodytype)
	. = icon
	if(on_mob_use_spritesheets)
		for(var/btype in sprite_sheets)
			if(lowertext(btype) == bodytype)
				return sprite_sheets[btype]

/obj/item/proc/apply_overlays(var/mob/user_mob, var/bodytype, var/image/overlay, var/slot)
	. = overlay

/obj/item/proc/apply_offsets(var/mob/user_mob, var/bodytype,  var/image/overlay, var/slot)
	if(ishuman(user_mob))
		var/mob/living/carbon/human/H = user_mob
		if(H.species.get_bodytype(H) != bodytype)
			overlay = H.species.get_offset_overlay_image(FALSE, overlay.icon, overlay.icon_state, color, slot)
	. = overlay
