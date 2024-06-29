/mob/living/simple_animal/hostile/retaliate/aquatic
	abstract_type = /mob/living/simple_animal/hostile/retaliate/aquatic
	icon = 'icons/mob/simple_animal/fish_content.dmi'
	natural_weapon = /obj/item/natural_weapon/bite
	mob_size = MOB_SIZE_MEDIUM
	emote_see = list("gnashes")
	base_animal_type = /mob/living/simple_animal/aquatic // used for language, ignore actual type
	is_aquatic = TRUE
	butchery_data = /decl/butchery_data/animal/fish
	holder_type = /obj/item/holder
	turns_per_wander = 5
