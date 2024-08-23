/obj/item/staff/crystal
	name = "wizard's staff"
	icon = 'icons/obj/items/staff_crystal.dmi'

/obj/item/staff/crystal/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing)
	if(overlay)
		var/crystal_state = "[overlay.icon_state]-crystal"
		if(check_state_in_icon(crystal_state, overlay.icon))
			overlay.overlays += overlay_image(overlay.icon, crystal_state, COLOR_WHITE, RESET_COLOR)
	. = ..()

/obj/item/staff/crystal/on_update_icon()
	. = ..()
	var/crystal_state = "[icon_state]-crystal"
	if(check_state_in_icon(icon, crystal_state))
		add_overlay(overlay_image(icon, crystal_state, COLOR_WHITE, RESET_COLOR))

/obj/item/staff/crystal/beacon
	icon = 'icons/obj/items/staff_beacon.dmi'
