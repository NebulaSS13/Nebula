//Holocarp

/mob/living/simple_animal/hostile/carp/holodeck
	icon = 'icons/mob/simple_animal/holocarp.dmi'
	alpha = 127
	butchery_data = null
	worthless = TRUE

/mob/living/simple_animal/hostile/carp/holodeck/carp_randomify()
	return

/mob/living/simple_animal/hostile/carp/holodeck/on_update_icon()
	SHOULD_CALL_PARENT(FALSE)
	return

/mob/living/simple_animal/hostile/carp/holodeck/Initialize()
	. = ..()
	set_light(2) //hologram lighting

/mob/living/simple_animal/hostile/carp/holodeck/proc/set_safety(var/safe)
	if (safe)
		faction = MOB_FACTION_NEUTRAL
		natural_weapon.set_base_attack_force(0)
		environment_smash = 0
		ai?.try_destroy_surroundings = FALSE
	else
		faction = "carp"
		natural_weapon.set_base_attack_force(natural_weapon.get_initial_base_attack_force())

/mob/living/simple_animal/hostile/carp/holodeck/gib(do_gibs = TRUE)
	SHOULD_CALL_PARENT(FALSE)
	if(stat != DEAD)
		death(gibbed = TRUE)
	if(stat == DEAD)
		qdel(src)
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/carp/holodeck/get_death_message(gibbed)
	return "fades away..."

/mob/living/simple_animal/hostile/carp/holodeck/get_self_death_message(gibbed)
	return "You have been destroyed."

/mob/living/simple_animal/hostile/carp/holodeck/death(gibbed)
	. = ..()
	if(. && !gibbed)
		gib()

// Non-dangerous holocarp
/mob/living/simple_animal/hostile/carp/holodeck/fake
	faction = null
	natural_weapon = /obj/item/natural_weapon/bite/fake
	environment_smash = 0
	ai = /datum/mob_controller/aggressive/carp/fake

/obj/item/natural_weapon/bite/fake
	_base_attack_force = 0

/datum/mob_controller/aggressive/carp/fake
	try_destroy_surroundings = FALSE