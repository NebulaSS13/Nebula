/mob/living/simple_animal/passive/horse
	name                  = "horse"
	real_name             = "horse"
	desc                  = "A hefty four-legged animal traditionally used for hauling goods, recreational riding, and stomping enemy soldiers to death."
	icon                  = 'icons/mob/simple_animal/horse.dmi'
	speak_emote           = list("neighs", "whinnies")
	possession_candidate  = TRUE
	mob_size              = MOB_SIZE_LARGE
	pixel_x               = -6
	default_pixel_x       = -6
	base_animal_type      = /mob/living/simple_animal/passive/horse
	faction               = null
	buckle_pixel_shift    = @'{"x":0,"y":0,"z":16}'
	can_have_rider        = TRUE
	max_rider_size        = MOB_SIZE_MEDIUM
	ai                    = /datum/mob_controller/passive/horse
	color                 = "#806146" // preview color
	draw_visible_overlays = list() // to avoid applying any defaults

/datum/mob_controller/passive/horse
	emote_speech = list("Neigh!","NEIGH!","Neigh?")
	emote_hear   = list("neighs","whinnies")
	emote_see    = list("canters", "scuffs the ground", "shakes its mane", "tosses its head")
	spooked_by_grab = FALSE // todo: tamed vs untamed?

/datum/mob_controller/passive/horse/retaliate(atom/source)
	SHOULD_CALL_PARENT(FALSE)
	return // debug to stop the horse freaking out when mounted

/mob/living/simple_animal/passive/horse/Initialize()
	. = ..()
	color = null // clear preview color
	add_inventory_slot(new /datum/inventory_slot/back/horse)
	equip_to_slot_or_del(new /obj/item/saddle(src), slot_back_str)
	if(!LAZYACCESS(draw_visible_overlays, "base"))
		LAZYSET(draw_visible_overlays, "base", pick(get_possible_horse_colors()))
	update_icon()

/mob/living/simple_animal/passive/horse/add_additional_visible_overlays(list/accumulator)
	if(buckled_mob)
		var/image/horse_front = overlay_image(icon, "[icon_state]-buckled", draw_visible_overlays["base"], RESET_COLOR)
		horse_front.layer = ABOVE_HUMAN_LAYER
		accumulator += horse_front

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
