// Generic damage proc (slimes and monkeys).
/atom/proc/attack_generic(mob/user)
	return 0

/*
	Humans:
	Adds an exception for gloves, to allow special glove types like the ninja ones.

	Otherwise pretty standard.
*/
/mob/living/carbon/human/UnarmedAttack(var/atom/A, var/proximity)

	if(!..())
		return

	// Special glove functions:
	// If the gloves do anything, have them return 1 to stop
	// normal attack_hand() here.
	var/obj/item/clothing/gloves/G = gloves // not typecast specifically enough in defines
	if(istype(G) && G.Touch(A,1))
		return

	A.attack_hand(src)

/atom/proc/attack_hand(mob/user)
	. = FALSE

/mob/proc/attack_empty_hand()
	return

/mob/living/carbon/human/RestrainedClickOn(var/atom/A)
	return

/mob/living/CtrlClickOn(var/atom/A)
	. = ..()
	if(!. && a_intent == I_GRAB && length(available_maneuvers))
		. = perform_maneuver(prepared_maneuver || available_maneuvers[1], A)

/mob/living/carbon/human/RangedAttack(var/atom/A, var/params)
	//Climbing up open spaces
	if((istype(A, /turf/simulated/floor) || istype(A, /turf/unsimulated/floor) || istype(A, /obj/structure/lattice) || istype(A, /obj/structure/catwalk)) && isturf(loc) && bound_overlay && !is_physically_disabled()) //Climbing through openspace
		return climb_up(A)

	if(gloves)
		var/obj/item/clothing/gloves/G = gloves
		if(istype(G) && G.Touch(A,0)) // for magic gloves
			return TRUE

	. = ..()

/mob/living/RestrainedClickOn(var/atom/A)
	return

/*
	Aliens
*/

/mob/living/carbon/alien/RestrainedClickOn(var/atom/A)
	return

/mob/living/carbon/alien/UnarmedAttack(var/atom/A, var/proximity)

	if(!..())
		return 0

	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	A.attack_generic(src,rand(5,6),"bites")

/*
	New Players:
	Have no reason to click on anything at all.
*/
/mob/new_player/ClickOn()
	return

/*
	Animals
*/
/mob/living/simple_animal/UnarmedAttack(var/atom/A, var/proximity)

	if(!..())
		return
	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(A,/mob/living))
		if(!istype(natural_weapon) || a_intent == I_HELP)
			custom_emote(1,"[friendly] [A]!")
			return
		if(ckey)
			admin_attack_log(src, A, "Has attacked its victim.", "Has been attacked by its attacker.")
	if(a_intent == I_HELP)
		A.attack_animal(src)
	else
		A.attackby(get_natural_weapon(), src)

// Attack hand but for simple animals
/atom/proc/attack_animal(mob/user)
	return attack_hand(user)