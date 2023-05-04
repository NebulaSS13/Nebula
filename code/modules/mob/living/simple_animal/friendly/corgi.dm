//Corgi
/mob/living/simple_animal/corgi
	name = "corgi"
	real_name = "corgi"
	desc = "It's a corgi."
	icon = 'icons/mob/simple_animal/corgi.dmi'
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
	base_animal_type = /mob/living/simple_animal/corgi

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

/mob/living/simple_animal/corgi/harvest_skin()
	. = ..()
	. += new/obj/item/corgi_hide(get_turf(src))

/obj/item/corgi_hide
	name = "corgi hide"
	desc = "The by-product of corgi farming."
	icon = 'icons/obj/items/sheet_hide.dmi'
	icon_state = "sheet-corgi"
	material = /decl/material/solid/skin/fur/orange

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
				for(var/obj/item/chems/food/food_target in oview(src,3))
					if(isturf(food_target.loc) || ishuman(food_target.loc))
						movement_target = food_target
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
			dance(18)

/mob/living/simple_animal/corgi/proc/dance(ticks)
	set waitfor = FALSE
	visible_emote(pick("dances around.","chases their tail."))
	var/static/list/routine = list(NORTH,SOUTH,EAST,WEST,EAST,SOUTH) // repeats
	var/step_count = length(routine)
	for(var/i in 0 to ticks)
		set_dir(routine[1 + (i % step_count)])
		sleep(1)
		if(QDELETED(src) || client) // stop dancing if we don't exist or are player controlled
			return

/obj/item/chems/food/meat/corgi
	name = "corgi meat"
	desc = "Tastes like... well, you know..."

/mob/living/simple_animal/corgi/attackby(obj/item/attacking_object, mob/user)
	if(istype(attacking_object, /obj/item/newspaper))
		if(!stat)
			user.visible_message(SPAN_NOTICE("[user] baps [src] on the nose with \the [attacking_object]."), SPAN_NOTICE("You bap [src] on the nose with \the [attacking_object]."))
			INVOKE_ASYNC(src, .proc/dance)
			return TRUE
	return ..()

/mob/living/simple_animal/corgi/puppy
	name = "\improper corgi puppy"
	real_name = "corgi"
	desc = "It's a corgi puppy."
	icon = 'icons/mob/simple_animal/puppy.dmi'
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
	if(!resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 15)
			turns_since_scan = 0
			var/alone = TRUE
			var/ian = null
			for(var/mob/living/potential_witness in oviewers(7, src))
				if(istype(potential_witness, /mob/living/simple_animal/corgi/Ian))
					if(potential_witness.client)
						alone = FALSE
						break
					else
						ian = potential_witness
				else
					alone = FALSE
					break
			if(alone && ian && puppies < 4)
				if(near_camera(src) || near_camera(ian))
					return
				new /mob/living/simple_animal/corgi/puppy(loc)

		if(prob(1))
			INVOKE_ASYNC(src, .proc/dance)
