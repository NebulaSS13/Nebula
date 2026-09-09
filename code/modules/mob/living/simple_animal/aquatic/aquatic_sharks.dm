/mob/living/simple_animal/hostile/aquatic/shark
	name = "shark"
	desc = "A ferocious fish with many, many teeth."
	icon = 'icons/mob/simple_animal/shark.dmi'
	max_health = 150
	natural_weapon = /obj/item/natural_weapon/bite/shark
	faction = "sharks"
	butchery_data = /decl/butchery_data/animal/fish/shark
	ai = /datum/mob_controller/aggressive/aquatic/shark
	ability_handlers = list(/datum/ability_handler/predator)

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
	ai_flags = AI_FLAG_NO_PULLED_WANDER | AI_FLAG_WANDERS | AI_FLAG_ESCAPE_BUCKLES | AI_FLAG_AGGRESSIVE | AI_FLAG_DESTROYER | AI_FLAG_ATTACKS_ENEMIES

/obj/item/natural_weapon/bite/giantshark
	_base_attack_force = 40