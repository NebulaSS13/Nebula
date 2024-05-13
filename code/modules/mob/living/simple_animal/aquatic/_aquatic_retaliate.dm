/mob/living/simple_animal/hostile/retaliate/aquatic
	abstract_type = /mob/living/simple_animal/hostile/retaliate/aquatic
	icon = 'icons/mob/simple_animal/fish_content.dmi'
	turns_per_move = 5
	natural_weapon = /obj/item/natural_weapon/bite
	speed = 4
	mob_size = MOB_SIZE_MEDIUM
	emote_see = list("gnashes")
	base_animal_type = /mob/living/simple_animal/aquatic // used for language, ignore actual type
	is_aquatic = TRUE
	butchery_data = /decl/butchery_data/animal/fish
	holder_type = /obj/item/holder
