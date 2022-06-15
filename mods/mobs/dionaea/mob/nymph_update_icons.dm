/mob/living/carbon/alien/diona/update_inv_head()
	update_icon()

/mob/living/carbon/alien/diona/on_update_icon()
	..()
	icon_state = ICON_STATE_WORLD
	if(stat == DEAD)
		icon_state += "-dead"
	else if(lying || stat == UNCONSCIOUS)
		icon_state += "-sleeping"
	else

		add_overlay(emissive_overlay(icon = icon, icon_state = "[icon_state]-eyes"))
		z_flags |= ZMM_MANGLE_PLANES
		if(flower_color)
			var/image/flower = image(icon = icon, icon_state = "flower_back")
			var/image/I = image(icon = icon, icon_state = "flower_fore")
			I.color = flower_color
			flower.overlays += I
			add_overlay(flower)

	var/obj/item/hat = get_equipped_item(slot_head_str)
	if(hat)
		var/image/I = hat?.get_mob_overlay(src, slot_head_str)
		if(I)
			I.pixel_y = -8
			add_overlay(I)
