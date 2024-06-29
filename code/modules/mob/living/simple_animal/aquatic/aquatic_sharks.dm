/mob/living/simple_animal/hostile/aquatic/shark
	name = "shark"
	desc = "A ferocious fish with many, many teeth."
	icon = 'icons/mob/simple_animal/shark.dmi'
	max_health = 150
	natural_weapon = /obj/item/natural_weapon/bite/shark
	break_stuff_probability = 15
	faction = "sharks"
	butchery_data = /decl/butchery_data/animal/fish/shark

/obj/item/natural_weapon/bite/shark
	force = 20

/mob/living/simple_animal/hostile/aquatic/shark/huge
	name = "gigacretoxyrhina"
	desc = "That is a lot of shark."
	icon = 'icons/mob/simple_animal/spaceshark.dmi'
	move_intents = list(
		/decl/move_intent/walk/animal,
		/decl/move_intent/run/animal
	)
	turns_per_wander = 2
	attack_same = 1
	mob_size = MOB_SIZE_LARGE
	pixel_x = -16
	max_health = 400
	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/bite/giantshark
	break_stuff_probability = 35
	butchery_data = /decl/butchery_data/animal/fish/shark/large

/obj/item/natural_weapon/bite/giantshark
	force = 40