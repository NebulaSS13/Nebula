/datum/mob_controller/passive/sheep
	emote_hear         = list("bleats")
	emote_see          = list("shakes its head", "stamps a hoof", "looks around quickly")
	emote_speech       = list("Baa?", "Baa!", "BAA!")
	speak_chance       = 0.25
	turns_per_wander   = 10

/decl/bodytype/quadruped/animal/sheep
	uid = "bodytype_animal_sheep"

/mob/living/simple_animal/passive/sheep
	name          = "sheep"
	real_name     = "sheep"
	desc          = "A kind of wooly animal that grazes in herds, often raised for their meat and fleeces."
	icon          = 'icons/mob/simple_animal/sheep.dmi'
	speak_emote   = list("bleats")
	faction       = "sheep"
	butchery_data = /decl/butchery_data/animal/ruminant/sheep
	ai            = /datum/mob_controller/passive/sheep

/mob/living/simple_animal/passive/sheep/Initialize()
	. = ..()
	set_extension(src, /datum/extension/shearable)
	update_icon()

/mob/living/simple_animal/passive/sheep/get_bodytype()
	return GET_DECL(/decl/bodytype/quadruped/animal/sheep)

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
