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
