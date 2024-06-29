//Corgi
/mob/living/simple_animal/corgi
	name = "corgi"
	real_name = "corgi"
	desc = "It's a corgi."
	icon = 'icons/mob/simple_animal/corgi.dmi'
	speak_emote  = list("barks", "woofs")
	emote_speech = list("YAP", "Woof!", "Bark!", "AUUUUUU")
	emote_hear   = list("barks", "woofs", "yaps","pants")
	emote_see    = list("shakes its head", "shivers")
	speak_chance = 0.5
	turns_per_wander = 10
	response_disarm = "bops"
	see_in_dark = 5
	mob_size = MOB_SIZE_SMALL
	possession_candidate = 1
	holder_type = /obj/item/holder/corgi
	pass_flags = PASS_FLAG_TABLE
	base_animal_type = /mob/living/simple_animal/corgi
	can_buckle = TRUE
	butchery_data = /decl/butchery_data/animal/corgi

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
	var/turns_since_scan = 0
	var/obj/movement_target

/mob/living/simple_animal/corgi/Ian/do_delayed_life_action()
	..()
	//Feeding, chasing food, FOOOOODDDD
	if(!current_posture.prone && !buckled)
		turns_since_scan++
		if(turns_since_scan > 5)
			turns_since_scan = 0
			if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
				movement_target = null
				stop_wandering = FALSE
			if( !movement_target || !(movement_target.loc in oview(src, 3)) )
				movement_target = null
				stop_wandering = FALSE
				for(var/obj/item/chems/food/S in oview(src,3))
					if(isturf(S.loc) || ishuman(S.loc))
						movement_target = S
						break
			if(movement_target)
				stop_wandering = TRUE
				step_to(src,movement_target,1)
				sleep(3)
				step_to(src,movement_target,1)
				sleep(3)
				step_to(src,movement_target,1)

				if(movement_target)		//Not redundant due to sleeps, Item can be gone in 6 decisecomds
					if (movement_target.loc.x < src.x)
						set_dir(WEST)
					else if (movement_target.loc.x > src.x)
						set_dir(EAST)
					else if (movement_target.loc.y < src.y)
						set_dir(SOUTH)
					else if (movement_target.loc.y > src.y)
						set_dir(NORTH)
					else
						set_dir(SOUTH)

					if(isturf(movement_target.loc) && Adjacent(movement_target))
						UnarmedAttack(movement_target)
					else if(ishuman(movement_target.loc) && prob(20))
						visible_emote("stares at the [movement_target] that [movement_target.loc] has with sad puppy eyes.")

		if(prob(1))
			visible_emote(pick("dances around.","chases their tail."))
			for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2))
				set_dir(i)
				sleep(1)
				if(QDELETED(src) || client)
					return

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
	var/turns_since_scan = 0
	var/puppies = 0

//Lisa already has a cute bow!
/mob/living/simple_animal/corgi/Lisa/OnTopic(mob/user, href_list)
	if(href_list["remove_inv"] || href_list["add_inv"])
		to_chat(user, "<span class='warning'>[src] already has a cute bow!</span>")
		return TOPIC_HANDLED
	return ..()

/mob/living/simple_animal/corgi/Lisa/do_delayed_life_action()
	..()
	if(!current_posture.prone && !buckled)
		turns_since_scan++
		if(turns_since_scan > 15)
			turns_since_scan = 0
			var/alone = 1
			var/ian = 0
			for(var/mob/M in oviewers(7, src))
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
				if(near_camera(src) || near_camera(ian))
					return
				new /mob/living/simple_animal/corgi/puppy(loc)

		if(prob(1))
			visible_emote(pick("dances around","chases her tail"))
			for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2))
				set_dir(i)
				sleep(1)
				if(QDELETED(src) || client)
					return
