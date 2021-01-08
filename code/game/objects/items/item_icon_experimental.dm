// This file is an experiment in changing the way item icons are handled.
// Not really expecting it to work out of the box, so we'll see how it goes
// with a handful of specific items.

// For checking if we have a specific state, for inventory icons and nonhumanoid species.
// Cached cause asking icons is expensive
var/list/icon_state_cache = list()
/proc/check_state_in_icon(var/checkstate, var/checkicon)
	if(!checkstate || !istext(checkstate) || !isicon(checkicon))
		return FALSE
	var/list/check = global.icon_state_cache[checkicon]
	if(!check)
		check = list()
		for(var/istate in icon_states(checkicon))
			check[istate] = TRUE
		global.icon_state_cache[checkicon] = check
	. = check[checkstate]

/obj/item
	var/on_mob_use_spritesheets  // use spritesheets list for on-mob icon
	var/tmp/has_inventory_icon	// do not set manually
	var/tmp/use_single_icon

/obj/item/Initialize(ml, material_key)
	. = ..()
	if(check_state_in_icon(ICON_STATE_INV, icon) || check_state_in_icon(ICON_STATE_WORLD, icon))
		use_single_icon = TRUE
		has_inventory_icon = check_state_in_icon(ICON_STATE_INV, icon)
		icon_state = ICON_STATE_WORLD
		update_icon()

/obj/item/hud_layerise()
	..()
	update_world_inventory_state()

/obj/item/reset_plane_and_layer()
	..()
	update_world_inventory_state()

/obj/item/proc/update_world_inventory_state()
	if(use_single_icon && has_inventory_icon)
		var/last_state = icon_state
		icon_state = get_world_inventory_state()
		if(last_state != icon_state)
			update_icon()

/obj/item/proc/get_world_inventory_state()
	if(!use_single_icon)
		return
	if(plane == HUD_PLANE && has_inventory_icon)
		return ICON_STATE_INV
	else
		return ICON_STATE_WORLD

/mob/proc/get_bodytype()
	return

// This is a temporary workaround for the slot => bodypart 
// changes. In the long term this should be removed after 
// all the `slot_l/r_hand-foo` states are renamed to just 
// `l/r_hand-foo`. TODO: check if this is still here in 2025.
var/list/bodypart_to_slot_lookup_table = list(
	BP_L_HAND = "slot_l_hand",
	BP_R_HAND = "slot_r_hand"
)

/obj/item/proc/experimental_mob_overlay(var/mob/user_mob, var/slot, var/bodypart)

	var/bodytype = lowertext(user_mob?.get_bodytype())
	var/useicon =  get_icon_for_bodytype(bodytype)
	if(bodytype != BODYTYPE_HUMANOID && (!bodytype || !check_state_in_icon("[bodytype]-[slot]", useicon)))
		bodytype = lowertext(BODYTYPE_HUMANOID)
		useicon = get_icon_for_bodytype(bodytype)

	// See comment above.
	var/use_state = "[bodytype]-[slot]"
	if(!check_state_in_icon(use_state, useicon) && global.bodypart_to_slot_lookup_table[slot])
		use_state = "[bodytype]-[global.bodypart_to_slot_lookup_table[slot]]"

	if(!check_state_in_icon(use_state, useicon))
		return new /image

	var/image/I = image(useicon, use_state)
	I.color = color
	I.appearance_flags = RESET_COLOR
	. = apply_offsets(user_mob,  bodytype, I, slot, bodypart)
	. = apply_overlays(user_mob, bodytype, ., slot)

/mob/living/carbon/get_bodytype()
	. = species && species.get_bodytype(src)

/obj/item/proc/get_icon_for_bodytype(var/bodytype)
	. = (on_mob_use_spritesheets && sprite_sheets[lowertext(bodytype)]) || icon

/obj/item/proc/apply_overlays(var/mob/user_mob, var/bodytype, var/image/overlay, var/slot)
	. = overlay

/obj/item/proc/apply_offsets(var/mob/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(ishuman(user_mob))
		var/mob/living/carbon/human/H = user_mob
		if(lowertext(H.species.get_bodytype(H)) != bodytype) 
			overlay = H.species.get_offset_overlay_image(FALSE, overlay.icon, overlay.icon_state, color, bodypart || slot)
	. = overlay

//Special proc belts use to compose their icon
/obj/item/proc/get_on_belt_overlay()
	if(check_state_in_icon("on_belt", icon))
		var/image/res = image(icon, "on_belt")
		res.color = color
		return res
