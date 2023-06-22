/*
Contains helper procs for airflow, called by /connection_group.
*/
/atom/movable/proc/handle_airflow(var/differential, var/list/connecting_turfs, var/repelled)
	if(last_airflow > world.time - vsc.airflow_delay || airflow_speed)
		return FALSE

	// Knock mobs etc over.
	. = handle_airflow_stun(differential)

	// Shove things around.
	if(check_airflow_movable(differential) && length(connecting_turfs))
		//Check for things that are in range of the midpoint turfs.
		var/list/close_turfs
		for(var/turf/connecting_turf as anything in connecting_turfs)
			if(get_dist(src, connecting_turf) < world.view)
				LAZYADD(close_turfs, connecting_turf)
			if(LAZYLEN(close_turfs))
				airflow_dest = pick(close_turfs) //Pick a random midpoint to fly towards.

				if(repelled)
					addtimer(CALLBACK(src, .proc/RepelAirflowDest, differential / 5), 0)
				else
					addtimer(CALLBACK(src, .proc/GotoAirflowDest, differential / 10), 0)

/atom/movable/proc/handle_airflow_stun(var/differential)
	return

/mob/var/tmp/last_airflow_stun = 0
/mob/handle_airflow_stun(var/differential)
	if(differential < vsc.airflow_stun_pressure || stat == DEAD || (status_flags & GODMODE))
		return FALSE
	if(last_airflow_stun > world.time - vsc.airflow_stun_cooldown)
		return FALSE
	if(!(status_flags & CANSTUN) && !(status_flags & CANWEAKEN))
		to_chat(src, SPAN_NOTICE("You stay upright as the air rushes past you."))
		return FALSE
	if(buckled)
		to_chat(src, SPAN_NOTICE("Air suddenly rushes past you!"))
		return FALSE
	if(!lying)
		to_chat(src, SPAN_DANGER("The sudden rush of air knocks you over!"))
	SET_STATUS_MAX(src, STAT_WEAK, 5)
	last_airflow_stun = world.time
	return TRUE

/mob/living/silicon/handle_airflow_stun()
	return FALSE

/mob/living/silicon/handle_airflow()
	return FALSE

/mob/living/carbon/human/handle_airflow_stun()
	if(!slip_chance())
		to_chat(src, SPAN_NOTICE("Air suddenly rushes past you!"))
		return FALSE
	. = ..()

/atom/movable/proc/check_airflow_movable(n)
	return !anchored

/mob/check_airflow_movable(n)
	return (n >= vsc.airflow_heavy_pressure)

/mob/living/silicon/check_airflow_movable()
	return FALSE

/obj/check_airflow_movable(n)
	var/threshold = vsc.airflow_dense_pressure
	switch(w_class)
		if(1, 2)
			threshold = vsc.airflow_lightest_pressure
		if(3)
			threshold = vsc.airflow_light_pressure
		if(4, 5)
			threshold = vsc.airflow_medium_pressure
		if(6)
			threshold = vsc.airflow_heavy_pressure
	if(n < threshold)
		return FALSE
	return ..()

/atom/movable
	var/tmp/turf/airflow_dest
	var/tmp/airflow_speed = 0
	var/tmp/airflow_time = 0
	var/tmp/last_airflow = 0
	var/tmp/airborne_acceleration = 0

/atom/movable/proc/AirflowCanMove(n)
	return 1

/mob/AirflowCanMove(n)
	if(status_flags & GODMODE)
		return 0
	if(buckled)
		return 0
	var/obj/item/shoes = get_equipped_item(slot_shoes_str)
	if(istype(shoes) && (shoes.item_flags & ITEM_FLAG_NOSLIP))
		return 0
	return 1

/atom/movable/Bump(atom/A)
	if(airflow_speed > 0 && airflow_dest)
		if(airborne_acceleration > 1)
			airflow_hit(A)
		else if(istype(src, /mob/living/carbon/human))
			to_chat(src, "<span class='notice'>You are pinned against [A] by airflow!</span>")
			airborne_acceleration = 0
	else
		airflow_speed = 0
		airflow_time = 0
		airborne_acceleration = 0
		. = ..()

/atom/movable/proc/airflow_hit(atom/A)
	airflow_speed = 0
	airflow_dest = null
	airborne_acceleration = 0

/mob/airflow_hit(atom/A)
	visible_message(SPAN_DANGER("\The [src] slams into \the [A]!"), SPAN_DANGER("You slam into \the [A]!"), SPAN_DANGER("You hear a loud slam!"))
	playsound(src.loc, "smash.ogg", 25, 1, -1)
	var/weak_amt = istype(A,/obj/item) ? A:w_class : rand(1,5) //Heheheh
	SET_STATUS_MAX(src, STAT_WEAK, weak_amt)
	. = ..()

/obj/airflow_hit(atom/A)
	visible_message(SPAN_DANGER("\The [src] slams into \the [A]!"), null, SPAN_DANGER("You hear a loud slam!"))
	playsound(src.loc, "smash.ogg", 25, 1, -1)
	. = ..()

/obj/item/airflow_hit(atom/A)
	airflow_speed = 0
	airflow_dest = null

/mob/living/carbon/human/airflow_hit(atom/A)
//	for(var/mob/M in hearers(src))
//		M.show_message("<span class='danger'>[src] slams into [A]!</span>",1,"<span class='danger'>You hear a loud slam!</span>",2)
	playsound(src.loc, "punch", 25, 1, -1)
	if (prob(33))
		loc:add_blood(src)
		bloody_body(src)
	var/b_loss = min(airflow_speed, (airborne_acceleration*2)) * vsc.airflow_damage

	apply_damage(b_loss/3, BRUTE, BP_HEAD, used_weapon = "Airflow")

	apply_damage(b_loss/3, BRUTE, BP_CHEST, used_weapon =  "Airflow")

	apply_damage(b_loss/3, BRUTE, BP_GROIN, used_weapon =  "Airflow")

	if(airflow_speed > 10)
		SET_STATUS_MAX(src, STAT_PARA, round(airflow_speed * vsc.airflow_stun))
		SET_STATUS_MAX(src, STAT_STUN, GET_STATUS(src, STAT_PARA) + 3)
	else
		SET_STATUS_MAX(src, STAT_STUN, round(airflow_speed * vsc.airflow_stun/2))
	. = ..()

/zone/proc/movables()
	. = list()
	for(var/turf/T as anything in contents)
		for(var/atom/movable/A in T)
			if(!A.simulated || A.anchored || istype(A, /obj/effect) || isobserver(A))
				continue
			. += A
