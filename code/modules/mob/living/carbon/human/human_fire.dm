/mob/living/carbon/human/update_fire(var/update_icons=1)
	if(is_on_fire())
		var/image/standing = overlay_image(get_bodytype().get_ignited_icon(src) || 'icons/mob/OnFire.dmi', "Standing", RESET_COLOR)
		set_current_mob_overlay(HO_FIRE_LAYER, standing, update_icons)
	else
		set_current_mob_overlay(HO_FIRE_LAYER, null, update_icons)
