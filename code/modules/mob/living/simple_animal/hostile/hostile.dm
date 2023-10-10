/mob/living/simple_animal/hostile
	faction = "hostile"
	stop_automated_movement_when_pulled = 0
	a_intent = I_HURT
	response_help_3p = "$USER$ pokes $TARGET$."
	response_help_1p = "You poke $TARGET$."
	response_disarm =  "shoves"
	response_harm =    "strikes"

	var/stance = HOSTILE_STANCE_IDLE	//Used to determine behavior
	var/mob/living/target_mob
	var/attack_same = 0
	var/ranged = 0
	var/rapid = 0
	var/sa_accuracy = 85 //base chance to hit out of 100
	var/projectiletype
	var/projectilesound
	var/casingtype
	var/fire_desc = "fires" //"X fire_desc at Y!"
	var/ranged_range = 6 //tiles of range for ranged attackers to attack
	var/move_to_delay = 4 //delay for the automated movement.
	var/attack_delay = DEFAULT_ATTACK_COOLDOWN
	var/list/friends = list()
	var/break_stuff_probability = 10
	var/destroy_surroundings = 1

	var/stop_automation = FALSE //stops AI procs from running

	var/can_pry = TRUE
	var/pry_time = 7 SECONDS //time it takes for mob to pry open a door
	var/pry_desc = "prying" //"X begins pry_desc the door!"

	//hostile mobs will bash through these in order with their natural weapon
	var/list/valid_obstacles_by_priority = list(/obj/structure/window,
												/obj/structure/closet,
												/obj/machinery/door/window,
												/obj/structure/table,
												/obj/structure/grille,
												/obj/structure/barricade,
												/obj/structure/wall_frame,
												/obj/structure/railing)

/mob/living/simple_animal/hostile/Destroy()
	LAZYCLEARLIST(friends)
	target_mob = null
	return ..()

/mob/living/simple_animal/hostile/can_act()
	return !stop_automation && ..()

/mob/living/simple_animal/hostile/proc/kick_stance()
	if(target_mob)
		stance = HOSTILE_STANCE_ATTACK
	else
		stance = HOSTILE_STANCE_IDLE

/mob/living/simple_animal/hostile/proc/FindTarget()
	if(!can_act())
		return null
	if(!faction) //No faction, no reason to attack anybody.
		return null
	stop_automated_movement = 0
	for(var/atom/A in ListTargets(10))
		var/atom/F = Found(A)
		if(F)
			face_atom(F)
			return F

		if(ValidTarget(A))
			stance = HOSTILE_STANCE_ATTACK
			face_atom(A)
			return A

/mob/living/simple_animal/hostile/proc/ValidTarget(var/atom/A)
	if(A == src)
		return FALSE

	if(ismob(A))
		var/mob/M = A
		if(M.faction == src.faction && !attack_same)
			return FALSE
		else if(weakref(M) in friends)
			return FALSE
		if(M.stat)
			return FALSE

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if (H.is_cloaked())
				return FALSE

	return TRUE

/mob/living/simple_animal/hostile/proc/Found(var/atom/A)
	return

/mob/living/simple_animal/hostile/proc/MoveToTarget()
	if(!can_act())
		return
	if(HAS_STATUS(src, STAT_CONFUSE))
		walk_to(src, pick(orange(2, src)), 1, move_to_delay)
		return
	stop_automated_movement = 1
	if(QDELETED(target_mob) || SA_attackable(target_mob))
		stance = HOSTILE_STANCE_IDLE
	if(target_mob in ListTargets(10))
		if(ranged)
			if(get_dist(src, target_mob) <= ranged_range)
				OpenFire(target_mob)
			else
				walk_to(src, target_mob, 1, move_to_delay)
		else
			stance = HOSTILE_STANCE_ATTACKING
			walk_to(src, target_mob, 1, move_to_delay)

/mob/living/simple_animal/hostile/proc/AttackTarget()
	stop_automated_movement = 1
	if(!target_mob || SA_attackable(target_mob))
		LoseTarget()
		return 0
	if(!(target_mob in ListTargets(10)))
		LostTarget()
		return 0
	if (ishuman(target_mob))
		var/mob/living/carbon/human/H = target_mob
		if (H.is_cloaked())
			LoseTarget()
			return 0
	if(next_move >= world.time)
		return 0
	if(get_dist(src, target_mob) <= 1)	//Attacking
		AttackingTarget()
		return 1

/mob/living/simple_animal/hostile/proc/AttackingTarget()

	if(buckled_mob == target_mob && (!faction || buckled_mob.faction != faction))

		visible_message(SPAN_DANGER("\The [src] attempts to unseat \the [buckled_mob]!"))
		set_dir(pick(global.cardinal))
		setClickCooldown(attack_delay)

		if(prob(33))
			unbuckle_mob()
			if(buckled_mob != target_mob && !QDELETED(target_mob))
				to_chat(target_mob, SPAN_DANGER("You are thrown off \the [src]!"))
				SET_STATUS_MAX(target_mob, STAT_WEAK, 3)

		return target_mob

	face_atom(target_mob)
	setClickCooldown(attack_delay)
	if(!Adjacent(target_mob))
		return
	if(isliving(target_mob))
		if(!prob(get_accuracy()))
			visible_message("<span class='notice'>\The [src] misses its attack on \the [target_mob]!</span>")
			return
		var/mob/living/L = target_mob
		var/attacking_with = get_natural_weapon()
		if(attacking_with)
			L.attackby(attacking_with, src)
		return L

/mob/living/simple_animal/hostile/proc/LoseTarget()
	stance = HOSTILE_STANCE_IDLE
	target_mob = null
	walk(src, 0)

/mob/living/simple_animal/hostile/proc/LostTarget()
	stance = HOSTILE_STANCE_IDLE
	walk(src, 0)

/mob/living/simple_animal/hostile/proc/ListTargets(var/dist = 7)
	return hearers(src, dist)-src

/mob/living/simple_animal/hostile/proc/get_accuracy()
	return clamp(sa_accuracy - melee_accuracy_mods(), 0, 100)

/mob/living/simple_animal/hostile/death(gibbed, deathmessage, show_dead_message)
	..(gibbed, deathmessage, show_dead_message)
	walk(src, 0)

/mob/living/simple_animal/hostile/Life()
	. = ..()
	if(!.)
		walk(src, 0)

/mob/living/simple_animal/hostile/do_delayed_life_action()
	..()
	if(!can_act())
		walk(src, 0)
		kick_stance()
		return 0

	if(isturf(src.loc) && !src.buckled)
		switch(stance)
			if(HOSTILE_STANCE_IDLE)
				target_mob = FindTarget()

			if(HOSTILE_STANCE_ATTACK)
				face_atom(target_mob)
				if(destroy_surroundings)
					DestroySurroundings()
				MoveToTarget()

			if(HOSTILE_STANCE_ATTACKING)
				face_atom(target_mob)
				if(destroy_surroundings)
					DestroySurroundings()
				AttackTarget()
			if(HOSTILE_STANCE_INSIDE) //we aren't inside something so just switch
				stance = HOSTILE_STANCE_IDLE
	else
		if(stance != HOSTILE_STANCE_INSIDE)
			stance = HOSTILE_STANCE_INSIDE
			walk(src,0)
			target_mob = null

/mob/living/simple_animal/hostile/attackby(var/obj/item/O, var/mob/user)
	var/oldhealth = health
	. = ..()
	if(health < oldhealth && !incapacitated(INCAPACITATION_KNOCKOUT))
		target_mob = user
		MoveToTarget()

/mob/living/simple_animal/hostile/default_hurt_interaction(mob/user)
	. = ..()
	if(. && !incapacitated(INCAPACITATION_KNOCKOUT))
		target_mob = user
		MoveToTarget()

/mob/living/simple_animal/hostile/bullet_act(var/obj/item/projectile/Proj)
	var/oldhealth = health
	. = ..()
	if(isliving(Proj.firer) && !target_mob && health < oldhealth && !incapacitated(INCAPACITATION_KNOCKOUT))
		target_mob = Proj.firer
		MoveToTarget()

/mob/living/simple_animal/hostile/proc/OpenFire(target_mob)
	var/target = target_mob
	visible_message("<span class='danger'>\The [src] [fire_desc] at \the [target]!</span>", 1)

	if(rapid)
		var/datum/callback/shoot_cb = CALLBACK(src, .proc/shoot_wrapper, target, loc, src)
		addtimer(shoot_cb, 1)
		addtimer(shoot_cb, 4)
		addtimer(shoot_cb, 6)
	else
		Shoot(target, src.loc, src)
		if(casingtype)
			new casingtype

	stance = HOSTILE_STANCE_IDLE
	target_mob = null
	return

/mob/living/simple_animal/hostile/proc/shoot_wrapper(target, location, user)
	Shoot(target, location, user)
	if (casingtype)
		new casingtype(loc)

/mob/living/simple_animal/hostile/proc/Shoot(var/target, var/start, var/user, var/bullet = 0)
	if(target == start)
		return

	var/obj/item/projectile/A = new projectiletype(get_turf(user))
	playsound(user, projectilesound, 100, 1)
	if(!A)	return
	var/def_zone = get_exposed_defense_zone(target)
	A.launch(target, def_zone)

/mob/living/simple_animal/hostile/proc/DestroySurroundings() //courtesy of Lohikar
	if(!can_act())
		return
	if(prob(break_stuff_probability) && !Adjacent(target_mob))
		face_atom(target_mob)
		var/turf/targ = get_step_towards(src, target_mob)
		if(!targ)
			return

		var/obj/effect/shield/S = locate(/obj/effect/shield) in targ
		if(S && S.gen && S.gen.check_flag(MODEFLAG_NONHUMANS))
			var/attacking_with = get_natural_weapon()
			if(attacking_with)
				S.attackby(attacking_with, src)
			return

		for(var/type in valid_obstacles_by_priority)
			var/obj/obstacle = locate(type) in targ
			if(obstacle)
				face_atom(obstacle)
				var/attacking_with = get_natural_weapon()
				if(attacking_with)
					obstacle.attackby(attacking_with, src)
				return

		if(can_pry)
			for(var/obj/machinery/door/obstacle in targ)
				if(obstacle.density)
					if(!obstacle.can_open(1))
						return
					face_atom(obstacle)
					var/pry_time_holder = (obstacle.pry_mod * pry_time)
					pry_door(src, pry_time_holder, obstacle)
					return

/mob/living/simple_animal/hostile/proc/pry_door(var/mob/user, var/delay, var/obj/machinery/door/pesky_door)
	visible_message("<span class='warning'>\The [user] begins [pry_desc] at \the [pesky_door]!</span>")
	stop_automation = TRUE
	if(do_after(user, delay, pesky_door))
		pesky_door.open(1)
		stop_automation = FALSE
	else
		visible_message("<span class='notice'>\The [user] is interrupted.</span>")
		stop_automation = FALSE
