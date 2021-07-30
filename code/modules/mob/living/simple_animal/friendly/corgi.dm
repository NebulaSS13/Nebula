//Corgi
/mob/living/simple_animal/corgi
	name = "\improper corgi"
	real_name = "corgi"
	desc = "It's a corgi."
	icon_state = "corgi"
	icon_living = "corgi"
	icon_dead = "corgi_dead"
	speak = list("YAP", "Woof!", "Bark!", "AUUUUUU")
	speak_emote = list("barks", "woofs")
	emote_hear = list("barks", "woofs", "yaps","pants")
	emote_see = list("shakes its head", "shivers")
	speak_chance = 1
	turns_per_move = 10
	response_disarm = "bops"
	see_in_dark = 5
	mob_size = MOB_SIZE_SMALL
	possession_candidate = 1
	holder_type = /obj/item/holder/corgi
	pass_flags = PASS_FLAG_TABLE

	meat_type = /obj/item/chems/food/meat/corgi
	meat_amount = 3
	skin_material = /decl/material/solid/skin/fur/orange

/mob/living/simple_animal/corgi/Initialize()
	if(isnull(hat_offsets))
		hat_offsets = list(
			"[NORTH]" = list( 1, -8),
			"[SOUTH]" = list( 1, -8),
			"[EAST]" =  list( 7, -8),
			"[WEST]" =  list(-7, -8)
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
	if(!resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 5)
			turns_since_scan = 0
			if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
				movement_target = null
				stop_automated_movement = 0
			if( !movement_target || !(movement_target.loc in oview(src, 3)) )
				movement_target = null
				stop_automated_movement = 0
				for(var/obj/item/chems/food/S in oview(src,3))
					if(isturf(S.loc) || ishuman(S.loc))
						movement_target = S
						break
			if(movement_target)
				stop_automated_movement = 1
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

					if(isturf(movement_target.loc) )
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

/obj/item/chems/food/meat/corgi
	name = "Corgi meat"
	desc = "Tastes like... well you know..."

/mob/living/simple_animal/corgi/attackby(var/obj/item/O, var/mob/user)  //Marker -Agouri
	if(istype(O, /obj/item/newspaper))
		if(!stat)
			for(var/mob/M in viewers(user, null))
				if ((M.client && !( M.blinded )))
					M.show_message("<span class='notice'>[user] baps [name] on the nose with the rolled up [O]</span>")
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
	icon_state = "puppy"
	icon_living = "puppy"
	icon_dead = "puppy_dead"
	meat_amount = 1
	skin_amount = 3
	bone_amount = 3

/mob/living/simple_animal/corgi/puppy/Initialize()
	if(isnull(hat_offsets))
		hat_offsets = list(
			"[NORTH]" = list( 0, -12),
			"[SOUTH]" = list( 0, -12),
			"[EAST]" =  list( 5, -14),
			"[WEST]" =  list(-5, -14)
		)
	..()
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
	icon_state = "lisa"
	icon_living = "lisa"
	icon_dead = "lisa_dead"
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
	if(!resting && !buckled)
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

/mob/living/simple_animal/corgi/harvest_skin()
	. = ..()
	. += new/obj/item/corgi_hide(get_turf(src))

/obj/item/corgi_hide
	name = "corgi hide"
	desc = "The by-product of corgi farming."
	icon = 'icons/obj/items/sheet_hide.dmi'
	icon_state = "sheet-corgi"