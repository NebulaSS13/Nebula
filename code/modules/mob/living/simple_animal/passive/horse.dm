/mob/living/simple_animal/passive/horse
	name                 = "horse"
	real_name            = "horse"
	desc                 = "A hefty four-legged animal traditionally used for hauling goods, recreational riding, and stomping enemy soldiers to death."
	icon                 = 'icons/mob/simple_animal/horse.dmi'
	speak_emote          = list("neighs", "whinnies")
	possession_candidate = TRUE
	mob_size             = MOB_SIZE_LARGE
	pixel_x              = -6
	default_pixel_x      = -6
	base_animal_type     = /mob/living/simple_animal/passive/horse
	faction              = null
	buckle_pixel_shift   = @"{'x':0,'y':0,'z':16}"
	can_have_rider       = TRUE
	max_rider_size       = MOB_SIZE_MEDIUM
	ai                   = /datum/mob_controller/passive/horse

	var/honse_color // Replace this with "base" state when simple animal stuff is merged.

/datum/mob_controller/passive/horse
	emote_speech = list("Neigh!","NEIGH!","Neigh?")
	emote_hear   = list("neighs","whinnies")
	emote_see    = list("canters", "scuffs the ground", "shakes its mane", "tosses its head")

/datum/mob_controller/passive/horse/retaliate(atom/source)
	SHOULD_CALL_PARENT(FALSE)
	return // debug to stop the horse freaking out when mounted

/mob/living/simple_animal/passive/horse/Initialize()
	. = ..()
	add_inventory_slot(new /datum/inventory_slot/back/horse)
	equip_to_slot_or_del(new /obj/item/saddle(src), slot_back_str)
	if(!honse_color)
		honse_color = pick(get_possible_horse_colors())
	update_icon()

/mob/living/simple_animal/passive/horse/refresh_visible_overlays()
	var/list/current_overlays = list(overlay_image(icon, icon_state, honse_color, RESET_COLOR))
	if(buckled_mob)
		var/image/horse_front = overlay_image(icon, "[icon_state]-buckled", honse_color, RESET_COLOR)
		horse_front.layer = ABOVE_HUMAN_LAYER
		current_overlays += horse_front
	set_current_mob_overlay(HO_SKIN_LAYER, current_overlays, redraw_mob = FALSE) // We're almost certainly redrawing in ..() anyway
	. = ..()

/mob/living/simple_animal/passive/horse/get_bodytype()
	return GET_DECL(/decl/bodytype/quadruped/animal/horse)

/mob/living/simple_animal/passive/horse/proc/get_possible_horse_colors()
	var/static/list/honse_colors = list(
		"#856b48",
		"#806146",
		"#845c46"
	)
	return honse_colors

/decl/bodytype/quadruped/animal/horse
	name = "horse"
	bodytype_category = "equine body"
	uid = "bodytype_horse"

/datum/inventory_slot/back/horse
	requires_organ_tag = null

/mob/living/simple_animal/passive/horse/small
	icon = 'icons/mob/simple_animal/horse_small.dmi'
