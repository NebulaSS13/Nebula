/mob/living/simple_animal/hostile/aquatic/shark
	name = "shark"
	desc = "A ferocious fish with many, many teeth."
	icon = 'icons/mob/simple_animal/shark.dmi'
	max_health = 150
	natural_weapon = /obj/item/natural_weapon/bite/shark
	faction = "sharks"
	butchery_data = /decl/butchery_data/animal/fish/shark
	ai = /datum/mob_controller/aggressive/aquatic/shark

/obj/item/natural_weapon/bite/shark
	_base_attack_force = 20

/datum/mob_controller/aggressive/aquatic/shark
	break_stuff_probability = 15

/mob/living/simple_animal/hostile/aquatic/shark/huge
	name = "gigacretoxyrhina"
	desc = "That is a lot of shark."
	icon = 'icons/mob/simple_animal/spaceshark.dmi'
	move_intents = list(
		/decl/move_intent/walk/animal,
		/decl/move_intent/run/animal
	)
	mob_size = MOB_SIZE_LARGE
	pixel_x = -16
	max_health = 400
	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/bite/giantshark
	butchery_data = /decl/butchery_data/animal/fish/shark/large
	ai = /datum/mob_controller/aggressive/aquatic/shark/huge

/datum/mob_controller/aggressive/aquatic/shark/huge
	turns_per_wander = 4
	break_stuff_probability = 35
	attack_same_faction = TRUE

/obj/item/natural_weapon/bite/giantshark
	_base_attack_force = 40