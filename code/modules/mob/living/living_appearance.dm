/mob/living
	var/list/mob_overlays[TOTAL_OVER_LAYERS]
	var/list/mob_underlays[TOTAL_UNDER_LAYERS]

/mob/living/update_icon()
	..()
	compile_overlays()

/mob/living/on_update_icon()
	SHOULD_CALL_PARENT(TRUE)
	..()
	cut_overlays()
	if(auras)
		for(var/obj/aura/aura as anything in auras)
			var/image/A = new()
			A.appearance = aura
			add_overlay(A)
	try_refresh_visible_overlays()

/mob/living/proc/get_skin_colour()
	return

/mob/living/proc/get_eye_colour()
	return

/mob/living/proc/get_lip_colour()
	return

/mob/living/proc/get_hairstyle()
	return

/mob/living/proc/get_facial_hairstyle()
	return

/mob/living/proc/get_hair_colour()
	return

/mob/living/proc/get_facial_hair_colour()
	return

/mob/living/proc/set_skin_colour(var/new_color)
	return get_skin_colour() != new_color

/mob/living/proc/set_eye_colour(var/new_color)
	return get_eye_colour() != new_color

/mob/living/proc/set_lip_colour(var/new_color)
	return get_lip_colour() != new_color

/mob/living/proc/set_facial_hair_colour(var/new_color, var/skip_update = FALSE)
	return get_facial_hair_colour() != new_color

/mob/living/proc/set_hair_colour(var/new_color, var/skip_update = FALSE)
	return get_hair_colour() != new_color

/mob/living/proc/set_hairstyle(var/new_hairstyle)
	return new_hairstyle && get_hairstyle() != new_hairstyle && ispath(new_hairstyle, /decl/sprite_accessory/hair)

/mob/living/proc/set_facial_hairstyle(var/new_facial_hairstyle)
	return new_facial_hairstyle && get_facial_hairstyle() != new_facial_hairstyle && ispath(new_facial_hairstyle, /decl/sprite_accessory/facial_hair)

/mob/living/get_all_current_mob_overlays()
	return mob_overlays

/mob/living/set_current_mob_overlay(var/overlay_layer, var/image/overlay, var/redraw_mob = TRUE)
	mob_overlays[overlay_layer] = overlay
	..()

/mob/living/get_current_mob_overlay(var/overlay_layer)
	return mob_overlays[overlay_layer]

/mob/living/get_all_current_mob_underlays()
	return mob_underlays

/mob/living/set_current_mob_underlay(var/underlay_layer, var/image/underlay, var/redraw_mob = TRUE)
	mob_underlays[underlay_layer] = underlay
	..()

/mob/living/get_current_mob_underlay(var/underlay_layer)
	return mob_underlays[underlay_layer]
