/mob/living/simple_animal/hostile/aquatic
	icon = 'icons/mob/simple_animal/fish_content.dmi'
	meat_type = /obj/item/chems/food/fish
	turns_per_move = 5
	natural_weapon = /obj/item/natural_weapon/bite
	speed = 4
	mob_size = MOB_SIZE_MEDIUM
	emote_see = list("gnashes")
	base_animal_type = /mob/living/simple_animal/aquatic // used for language, ignore actual type
	is_aquatic = TRUE

	meat_type = /obj/item/chems/food/fish
	meat_amount = 3
	bone_amount = 5
	skin_amount = 5
	bone_material = /decl/material/solid/bone/fish
	skin_material = /decl/material/solid/skin/fish
