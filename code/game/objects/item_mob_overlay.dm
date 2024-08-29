// This is a temporary workaround for the slot => bodypart
// changes. In the long term this should be removed after
// all the `slot_l/r_hand-foo` states are renamed to just
// `l/r_hand-foo`. TODO: check if this is still here in 2025.
var/global/list/bodypart_to_slot_lookup_table = list(
	BP_L_HAND = "slot_l_hand",
	BP_R_HAND = "slot_r_hand"
)

/obj/item/proc/reconsider_single_icon(var/update_icon)
	use_single_icon = check_state_in_icon(ICON_STATE_INV, icon) || check_state_in_icon(ICON_STATE_WORLD, icon)
	if(use_single_icon)
		has_inventory_icon = check_state_in_icon(ICON_STATE_INV, icon)
		icon_state = get_world_inventory_state()
		. = TRUE
	else
		has_inventory_icon = FALSE
	if(. || update_icon)
		update_icon()

// For checking if we have a specific state, for inventory icons and nonhumanoid species.
// Cached cause asking icons is expensive. This is still expensive, so avoid using it if
// you can reasonably expect the icon_state to exist beforehand, or if you can cache the
// value somewhere (as done below with use_single_icon in /obj/item/Initialize()).
var/global/list/icon_state_cache = list()
/proc/check_state_in_icon(var/checkstate, var/checkicon)
	// isicon() is apparently quite expensive so short-circuit out early if we can.
	if(!istext(checkstate) || isnull(checkicon) || !(isfile(checkicon) || isicon(checkicon)))
		return FALSE
	var/checkkey = "\ref[checkicon]"
	var/list/check = global.icon_state_cache[checkkey]
	if(!check)
		check = list()
		for(var/istate in icon_states(checkicon))
			check[istate] = TRUE
		global.icon_state_cache[checkkey] = check
	. = check[checkstate]

/obj/item/proc/update_world_inventory_state()
	if(use_single_icon && has_inventory_icon)
		var/last_state = icon_state
		icon_state = get_world_inventory_state()
		if(last_state != icon_state)
			update_icon()

/obj/item/proc/get_world_inventory_state()
	if(use_single_icon)
		if(plane == HUD_PLANE && has_inventory_icon)
			return ICON_STATE_INV
		return ICON_STATE_WORLD

/obj/item/hud_layerise()
	..()
	update_world_inventory_state()

/obj/item/reset_plane_and_layer()
	..()
	update_world_inventory_state()

/obj/item/proc/get_mob_overlay(mob/user_mob, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_adjustment = FALSE)

	var/is_not_held_slot = !(slot in global.all_hand_slots)
	if(!draw_on_mob_when_equipped && is_not_held_slot)
		return new /image

	var/state_modifier = user_mob?.get_overlay_state_modifier()

	if(!use_single_icon)
		var/mob_state = "[item_state || icon_state][state_modifier]"
		var/mob_icon = global.default_onmob_icons[slot]
		var/decl/bodytype/root_bodytype = user_mob?.get_bodytype()
		if(istype(root_bodytype))
			var/use_slot = (bodypart in root_bodytype.equip_adjust) ? bodypart : slot
			return root_bodytype.get_offset_overlay_image(user_mob, mob_icon, mob_state, color, use_slot)
		return overlay_image(mob_icon, mob_state, color, RESET_COLOR)

	var/bodytype  = user_mob?.get_bodytype_category() || BODYTYPE_HUMANOID
	var/useicon   = get_icon_for_bodytype(bodytype)
	var/use_state = "[bodytype]-[slot]"
	if(state_modifier)
		use_state = "[use_state][state_modifier]"

	if(bodytype != BODYTYPE_HUMANOID && !check_state_in_icon(use_state, useicon) && use_fallback_if_icon_missing)

		var/fallback = is_not_held_slot && get_fallback_slot(slot)
		if(fallback && fallback != slot)
			if(state_modifier)
				if(check_state_in_icon("[bodytype]-[fallback][state_modifier]", useicon))
					slot = fallback
			else if(check_state_in_icon("[bodytype]-[fallback]", useicon))
				slot = fallback
		else
			bodytype = BODYTYPE_HUMANOID
			useicon = get_icon_for_bodytype(bodytype)

		if(state_modifier)
			use_state = "[bodytype]-[slot][state_modifier]"
			if(!check_state_in_icon(use_state, useicon))
				use_state = "[bodytype]-[slot]"
		else
			use_state = "[bodytype]-[slot]"

	if(!check_state_in_icon(use_state, useicon) && global.bodypart_to_slot_lookup_table[slot])

		var/lookup_slot = global.bodypart_to_slot_lookup_table[slot]
		if(state_modifier)
			use_state = "[bodytype]-[lookup_slot][state_modifier]"
			if(!check_state_in_icon(use_state, useicon))
				use_state = "[bodytype]-[lookup_slot]"
		else
			use_state = "[bodytype]-[lookup_slot]"

	if(!check_state_in_icon(use_state, useicon))
		var/fallback = use_fallback_if_icon_missing && is_not_held_slot && get_fallback_slot(slot)
		if(!fallback)
			return new /image
		slot = fallback
		if(state_modifier)
			use_state = "[bodytype]-[slot][state_modifier]"
			if(!check_state_in_icon(use_state, useicon))
				use_state = "[bodytype]-[slot]"
		else
			use_state = "[bodytype]-[slot]"

	if(!check_state_in_icon(use_state, useicon))
		return new /image

	var/image/I = image(useicon, use_state)
	I.color = color
	I.appearance_flags = RESET_COLOR

	. = skip_adjustment ? I : adjust_mob_overlay(user_mob, bodytype, I, slot, bodypart, use_fallback_if_icon_missing)

/obj/item/proc/get_fallback_slot(var/slot)
	return

/obj/item/proc/get_icon_for_bodytype(var/bodytype)
	. = LAZYACCESS(sprite_sheets, bodytype) || icon

// Ensure ..() is called only at the end of this proc, and that `overlay` is mutated rather than replaced.
// This is necessary to ensure that all the overlays are generated and tracked prior to being passed to
// the bodytype offset proc, which can scrub icon/icon_state information as part of the offset process.
/obj/item/proc/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)

	if(!draw_on_mob_when_equipped && !(slot in global.all_hand_slots))
		return overlay

	var/decl/bodytype/root_bodytype = user_mob?.get_bodytype()
	if(root_bodytype && root_bodytype.bodytype_category != bodytype)
		var/list/overlays_to_offset = overlay.overlays
		overlay = root_bodytype.get_offset_overlay_image(user_mob, overlay.icon, overlay.icon_state, color, (bodypart || slot))
		for(var/thing in overlays_to_offset)
			var/image/I = thing // Technically an appearance but don't think we can cast to those
			var/image/adjusted_overlay = root_bodytype.get_offset_overlay_image(user_mob, I.icon, I.icon_state, I.color, (bodypart || slot))
			adjusted_overlay.appearance_flags = I.appearance_flags
			adjusted_overlay.plane =            I.plane
			adjusted_overlay.layer =            I.layer
			overlay.overlays += adjusted_overlay

	if(overlay)
		if(is_held_twohanded())
			var/wielded_state = "[overlay.icon_state]-wielded"
			if(check_state_in_icon(wielded_state, overlay.icon))
				overlay.icon_state = wielded_state
		apply_additional_mob_overlays(user_mob, bodytype, overlay, slot, bodypart, use_fallback_if_icon_missing)

	return overlay

/obj/item/proc/apply_additional_mob_overlays(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	return

//Special proc belts use to compose their icon
/obj/item/proc/get_on_belt_overlay()
	if(check_state_in_icon("on_belt", icon))
		var/image/res = image(icon, "on_belt")
		res.color = color
		return res
