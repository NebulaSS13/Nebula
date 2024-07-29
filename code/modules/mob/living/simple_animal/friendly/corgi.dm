//Corgi
/mob/living/simple_animal/corgi
	name = "corgi"
	real_name = "corgi"
	desc = "It's a corgi."
	icon = 'icons/mob/simple_animal/corgi.dmi'
	speak_emote  = list("barks", "woofs")
	response_disarm = "bops"
	see_in_dark = 5
	mob_size = MOB_SIZE_SMALL
	possession_candidate = 1
	holder_type = /obj/item/holder/corgi
	pass_flags = PASS_FLAG_TABLE
	base_animal_type = /mob/living/simple_animal/corgi
	can_buckle = TRUE
	butchery_data = /decl/butchery_data/animal/corgi
	ai = /datum/mob_controller/corgi

/datum/mob_controller/corgi
	emote_speech = list("YAP", "Woof!", "Bark!", "AUUUUUU")
	emote_hear   = list("barks", "woofs", "yaps","pants")
	emote_see    = list("shakes its head", "shivers")
	speak_chance = 0.25
	turns_per_wander = 20

/datum/mob_controller/corgi/proc/dance()
	set waitfor = FALSE
	if(QDELETED(body) || body.client)
		return
	var/decl/pronouns/pronouns = body.get_pronouns()
	body.custom_emote(VISIBLE_MESSAGE, pick("dances around.","chases [pronouns.his] tail."))
	for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2))
		body.set_dir(i)
		sleep(1)
		if(QDELETED(body) || body.client)
			return

/mob/living/simple_animal/corgi/get_bodytype()
	return GET_DECL(/decl/bodytype/quadruped/animal/corgi)

/decl/bodytype/quadruped/animal/corgi/Initialize()
	equip_adjust = list(
		slot_head_str = list(
			"[NORTH]" = list( 1, -8),
			"[SOUTH]" = list( 1, -8),
			"[EAST]" =  list( 7, -8),
			"[WEST]" =  list(-7, -8)
		)
	)
	. = ..()

//IAN! SQUEEEEEEEEE~
/mob/living/simple_animal/corgi/Ian
	name = "Ian"
	real_name = "Ian"	//Intended to hold the name without altering it.
	gender = MALE
	desc = "It's a corgi."
	ai = /datum/mob_controller/corgi/ian

/datum/mob_controller/corgi/ian
	var/turns_since_scan = 0
	var/obj/movement_target

/datum/mob_controller/corgi/ian/proc/go_get_lunch()
	set waitfor = FALSE

	if(!movement_target || !body || body.stat)
		return

	stop_wandering()
	step_to(body, movement_target,1)
	sleep(3)
	if(!movement_target || !body || body.stat)
		return

	step_to(body, movement_target,1)
	sleep(3)
	if(!movement_target || !body || body.stat)
		return

	step_to(body, movement_target,1)
	if(!movement_target || !body || body.stat)
		return

	if (movement_target.loc.x < body.x)
		body.set_dir(WEST)
	else if (movement_target.loc.x > body.x)
		body.set_dir(EAST)
	else if (movement_target.loc.y < body.y)
		body.set_dir(SOUTH)
	else if (movement_target.loc.y > body.y)
		body.set_dir(NORTH)
	else
		body.set_dir(SOUTH)
	if(isturf(movement_target.loc) && body.Adjacent(movement_target))
		body.UnarmedAttack(movement_target)
	else if(ishuman(movement_target.loc) && prob(20))
		body.custom_emote(VISIBLE_MESSAGE, "stares at the [movement_target] that [movement_target.loc] has with sad puppy eyes.")

/datum/mob_controller/corgi/ian/do_process(time_elapsed)

	if(!(. = ..()) || body.stat || body.current_posture?.prone || body.buckled)
		return

	//Feeding, chasing food, FOOOOODDDD
	turns_since_scan++
	if(turns_since_scan > 10)
		turns_since_scan = 0
		if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
			movement_target = null
			resume_wandering()
		if( !movement_target || !(movement_target.loc in oview(body, 3)) )
			movement_target = null
			resume_wandering()
			for(var/obj/item/food/S in oview(body, 3))
				if(isturf(S.loc) || ishuman(S.loc))
					movement_target = S
					break
		if(movement_target)
			go_get_lunch()
			return

	if(prob(1))
		dance()

/mob/living/simple_animal/corgi/attackby(var/obj/item/O, var/mob/user)  //Marker -Agouri
	if(istype(O, /obj/item/newspaper))
		if(!stat)
			visible_message(SPAN_NOTICE("\The [user] baps \the [src] on the nose with the rolled-up [O.name]!"))
			spawn(0)
				for(var/i in list(1,2,4,8,4,2,1,2))
					set_dir(i)
					sleep(1)
	else
		..()

/mob/living/simple_animal/corgi/puppy
	name = "\improper corgi puppy"
	real_name = "corgi"
	desc = "It's a corgi puppy."
	icon = 'icons/mob/simple_animal/puppy.dmi'
	can_buckle = FALSE
	butchery_data = /decl/butchery_data/animal/corgi/puppy

/mob/living/simple_animal/corgi/puppy/get_bodytype()
	return GET_DECL(/decl/bodytype/quadruped/animal/puppy)

/decl/bodytype/quadruped/animal/puppy/Initialize()
	equip_adjust = list(
		slot_head_str = list(
			"[NORTH]" = list( 0, -12),
			"[SOUTH]" = list( 0, -12),
			"[EAST]" =  list( 5, -14),
			"[WEST]" =  list(-5, -14)
		)
	)
	. = ..()

/mob/living/simple_animal/corgi/puppy/Initialize()
	. = ..()
	gender = pick(MALE, FEMALE)

//pupplies cannot wear anything.
/mob/living/simple_animal/corgi/puppy/OnTopic(mob/user, href_list)
	if(href_list["remove_inv"] || href_list["add_inv"])
		to_chat(user, "<span class='warning'>You can't fit this on [src]</span>")
		return TOPIC_HANDLED
	return ..()

//LISA! SQUEEEEEEEEE~
/mob/living/simple_animal/corgi/Lisa
	name = "Lisa"
	real_name = "Lisa"
	gender = FEMALE
	desc = "It's a corgi with a cute pink bow."
	icon = 'icons/mob/simple_animal/corgi_lisa.dmi'
	ai = /datum/mob_controller/corgi/lisa

/datum/mob_controller/corgi/lisa
	var/puppies = 0
	var/turns_since_scan = 0

/datum/mob_controller/corgi/lisa/do_process(time_elapsed)

	if(!(. = ..()) || body.stat || body.current_posture?.prone || body.buckled)
		return

	turns_since_scan++
	if(turns_since_scan > 30)
		turns_since_scan = 0
		var/alone = 1
		var/mob/living/ian
		for(var/mob/M in oviewers(7, body))
			if(istype(M, /mob/living/simple_animal/corgi/Ian))
				if(M.client)
					alone = 0
					break
				else
					ian = M
			else
				alone = 0
				break
		if(alone && ian && puppies < 4)
			if(body.near_camera() || ian.near_camera())
				return
			new /mob/living/simple_animal/corgi/puppy(body.loc)
			puppies++

	if(prob(1))
		dance()

//Lisa already has a cute bow!
/mob/living/simple_animal/corgi/Lisa/OnTopic(mob/user, href_list)
	if(href_list["remove_inv"] || href_list["add_inv"])
		to_chat(user, "<span class='warning'>[src] already has a cute bow!</span>")
		return TOPIC_HANDLED
	return ..()
