/mob/living/simple_animal/aquatic/fish/large/lantern
	name = "lantern fish"
	desc = "An oily, glowing fish. They are sometimes caught in cave rivers, and are rumoured to have cousins in the deep ocean."
	icon = 'icons/mob/simple_animal/fish_lantern.dmi'
	butchery_data = /decl/butchery_data/animal/fish/oily
	holder_type = /obj/item/holder/lanternfish
	var/glow_color = COLOR_LIME
	var/glow_power = 0.5
	var/glow_range = 2

/mob/living/simple_animal/aquatic/fish/large/lantern/Initialize()
	. = ..()
	set_light(glow_range, glow_power, glow_color)
	refresh_visible_overlays()

/mob/living/simple_animal/aquatic/fish/large/lantern/add_additional_visible_overlays(list/accumulator)
	var/glow_state = "[icon_state]-glow"
	if(check_state_in_icon(glow_state, icon))
		accumulator += emissive_overlay(icon, glow_state, color = light_color, flags = RESET_COLOR)

/obj/item/holder/lanternfish/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing)
	if(overlay && (slot in global.all_hand_slots))
		var/glow_state = "[overlay.icon_state]-glow"
		if(check_state_in_icon(glow_state, overlay.icon))
			overlay.overlays += emissive_overlay(overlay.icon, glow_state, color = light_color, flags = RESET_COLOR)
	return ..()
