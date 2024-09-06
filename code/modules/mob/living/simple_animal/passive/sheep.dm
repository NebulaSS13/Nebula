/datum/mob_controller/passive/sheep
	emote_hear         = list("bleats")
	emote_see          = list("shakes its head", "stamps a hoof", "looks around quickly")
	emote_speech       = list("Baa?", "Baa!", "BAA!")
	speak_chance       = 0.25
	turns_per_wander   = 10

/decl/bodytype/quadruped/animal/sheep
	uid = "bodytype_animal_deer"

/mob/living/simple_animal/passive/sheep
	name        = "sheep"
	real_name   = "sheep"
	desc        = "A kind of wooly animal that grazes in herds, often raised for their meat and fleeces."
	icon        = 'icons/mob/simple_animal/sheep.dmi'
	speak_emote = list("bleats")
	faction     = "sheep"

/mob/living/simple_animal/passive/sheep/Initialize()
	. = ..()
	set_extension(src, /datum/extension/shearable)
	update_icon()

/mob/living/simple_animal/passive/sheep/get_bodytype()
	return GET_DECL(/decl/bodytype/quadruped/animal/sheep)

/mob/living/simple_animal/passive/sheep/refresh_visible_overlays()
	var/list/body_overlays = list(overlay_image(icon, icon_state, COLOR_WHITE, RESET_COLOR))
	var/datum/extension/shearable/shearable = get_extension(src, /datum/extension/shearable)
	if(world.time >= shearable?.has_fleece)
		var/fleece_state = "[icon_state]-fleece"
		if(check_state_in_icon(fleece_state, icon))
			body_overlays += overlay_image(icon, fleece_state, shearable.fleece_material.color, RESET_COLOR)
	set_current_mob_overlay(HO_SKIN_LAYER, body_overlays)
	. = ..()

/mob/living/simple_animal/passive/sheep/set_gender(new_gender, update_body)
	. = ..()
	if(name == initial(name))
		switch(gender)
			if(MALE)
				SetName("ram")
			if(FEMALE)
				SetName("ewe")
			else
				SetName("sheep")
