/mob/living/simple_animal/hostile/carp/pike
	name = "space pike"
	desc = "A bigger, angrier cousin of the space carp."
	icon = 'icons/mob/simple_animal/spaceshark.dmi'
	move_intents = list(
		/decl/move_intent/walk/animal_fast,
		/decl/move_intent/run/animal_fast
	)
	base_movement_delay = 1
	mob_size = MOB_SIZE_LARGE
	offset_overhead_text_x = 16
	pixel_x = -16
	max_health = 150
	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/bite/pike
	butchery_data = /decl/butchery_data/animal/fish/space_carp/pike
	ai = /datum/mob_controller/aggressive/carp/pike
	ability_handlers = list(/datum/ability_handler/predator)

/datum/mob_controller/aggressive/carp/pike
	turns_per_wander = 4
	break_stuff_probability = 55
	ai_flags = AI_FLAG_NO_PULLED_WANDER | AI_FLAG_WANDERS | AI_FLAG_ESCAPE_BUCKLES | AI_FLAG_AGGRESSIVE | AI_FLAG_DESTROYER | AI_FLAG_ATTACKS_ENEMIES

/obj/item/natural_weapon/bite/pike
	_base_attack_force = 25

/mob/living/simple_animal/hostile/carp/pike/carp_randomify()
	return
