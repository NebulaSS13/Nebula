/mob/living/simple_animal/hostile/aquatic
	abstract_type = /mob/living/simple_animal/hostile/aquatic
	icon = 'icons/mob/simple_animal/fish_content.dmi'
	natural_weapon = /obj/item/natural_weapon/bite
	mob_size = MOB_SIZE_MEDIUM
	base_animal_type = /mob/living/simple_animal/aquatic // used for language, ignore actual type
	is_aquatic = TRUE
	butchery_data = /decl/butchery_data/animal/fish
	holder_type = /obj/item/holder
	ai = /datum/mob_controller/aggressive/aquatic

/datum/mob_controller/aggressive/aquatic
	turns_per_wander = 10
	emote_see = list("gnashes")

