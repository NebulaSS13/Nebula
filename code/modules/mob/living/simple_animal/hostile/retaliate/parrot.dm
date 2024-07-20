/* Parrots!
 * Contains
 * 		Defines
 *		Inventory (headset stuff)
 *		Attack responces
 *		AI
 *		Procs / Verbs (usable by players)
 *		Poly
 */

/*
 * Defines
 */

//Only a maximum of one action and one intent should be active at any given time.
//Actions
#define PARROT_PERCH 1		//Sitting/sleeping, not moving
#define PARROT_SWOOP 2		//Moving towards or away from a target
#define PARROT_WANDER 4		//Moving without a specific target in mind

//Intents
#define PARROT_STEAL 8		//Flying towards a target to steal it/from it
#define PARROT_ATTACK 16	//Flying towards a target to attack it
#define PARROT_RETURN 32	//Flying towards its perch
#define PARROT_FLEE 64		//Flying away from its attacker

/mob/living/simple_animal/hostile/parrot
	name = "parrot"
	desc = "A large, colourful tropical bird native to Earth, known for its strong beak and ability to mimic speech."
	icon = 'icons/mob/simple_animal/parrot.dmi'
	pass_flags = PASS_FLAG_TABLE
	mob_size = MOB_SIZE_SMALL
	speak_emote  = list("squawks","says","yells")
	natural_weapon = /obj/item/natural_weapon/beak
	response_harm = "swats"
	universal_speak = TRUE
	butchery_data = /decl/butchery_data/animal/bird/parrot
	ai = /datum/mob_controller/aggressive/parrot

	var/parrot_state = PARROT_WANDER // Hunt for a perch when created
	var/parrot_sleep_max = 25        // The time the parrot sits while perched before looking around. Mosly a way to avoid the parrot's AI in life() being run every single tick.
	var/parrot_sleep_dur = 25        // Same as above, this is the var that physically counts down
	var/parrot_been_shot = 0         // Parrots get a speed bonus after being shot. This will deincrement every Life() and at 0 the parrot will return to regular speed.
	//The thing the parrot is currently interested in. This gets used for items the parrot wants to pick up, mobs it wants to steal from,
	//mobs it wants to attack or mobs that have attacked it
	var/atom/movable/parrot_interest = null

	//Parrots will generally sit on their pertch unless something catches their eye.
	//These vars store their preffered perch and if they dont have one, what they can use as a perch
	var/obj/parrot_perch = null
	var/static/list/desired_perches = list(
		/obj/structure/bed/chair,
		/obj/structure/table,
		/obj/machinery/constructable_frame/computerframe,
		/obj/structure/displaycase,
		/obj/structure/filing_cabinet,
		/obj/machinery/teleport,
		/obj/machinery/computer,
		/obj/machinery/nuclearbomb,
		/obj/machinery/particle_accelerator,
		/obj/machinery/recharge_station,
		/obj/machinery/smartfridge,
		/obj/machinery/suit_cycler,
		/obj/structure/showcase,
		/obj/structure/fountain
	)

	//Parrots are kleptomaniacs. This variable ... stores the item a parrot is holding.
	var/obj/item/held_item

	var/simple_parrot = FALSE //simple parrots ignore all the cool stuff that occupies bulk of this file
	var/relax_chance = 75 //we're only little and we know it
	var/parrot_isize = ITEM_SIZE_SMALL
	var/impatience = 5 //we lose this much from relax_chance each time we calm down
	var/icon_set = "parrot"

/datum/mob_controller/aggressive/parrot
	turns_per_wander    = 10
	emote_speech        = list("Hi","Hello!","Cracker?")
	emote_hear          = list("squawks","bawks")
	emote_see           = list("flutters its wings")
	do_wander           = FALSE
	speak_chance        = 0.5
	only_attack_enemies = TRUE
	expected_type       = /mob/living/simple_animal/hostile/parrot

/*
 * AI - Not really intelligent, but I'm calling it AI anyway.
 */
/datum/mob_controller/aggressive/parrot/do_process()

	if(!(. = ..()) || body.stat || !istype(body, /mob/living/simple_animal/hostile/parrot))
		return

	var/mob/living/simple_animal/hostile/parrot/parrot = body
	if(!isturf(parrot.loc))
		return // Let's not bother in nullspace

	if(LAZYLEN(get_enemies()) && prob(parrot.relax_chance))
		parrot.give_up()

	if(parrot.simple_parrot)
		return FALSE

//-----SLEEPING
	if(parrot.parrot_state == PARROT_PERCH)
		if(parrot.parrot_perch && parrot.parrot_perch.loc != parrot.loc) //Make sure someone hasnt moved our perch on us
			if(parrot.parrot_perch in view(parrot))
				parrot.parrot_state = PARROT_SWOOP | PARROT_RETURN
			else
				parrot.parrot_state = PARROT_WANDER
			parrot.update_icon()
			return

		if(--parrot.parrot_sleep_dur) //Zzz
			return

		else
			//This way we only call the stuff below once every [sleep_max] ticks.
			parrot.parrot_sleep_dur = parrot.parrot_sleep_max
			//Search for item to steal
			parrot.parrot_interest = parrot.search_for_item()
			if(parrot.parrot_interest)
				parrot.visible_emote("looks in [parrot.parrot_interest]'s direction and takes flight")
				parrot.parrot_state = PARROT_SWOOP | PARROT_STEAL
				parrot.update_icon()

//-----WANDERING - This is basically a 'I dont know what to do yet' state
	else if(parrot.parrot_state == PARROT_WANDER)
		//Stop movement, we'll set it later
		parrot.stop_automove()
		parrot.parrot_interest = null

		//Wander around aimlessly. This will help keep the loops from searches down
		//and possibly move the mob into a new are in view of something they can use
		if(prob(90))
			parrot.SelfMove(pick(global.cardinal))
			return

		if(!parrot.held_item && !parrot.parrot_perch) //If we've got nothing to do, look for something to do.
			var/atom/movable/AM = parrot.search_for_perch_and_item() //This handles checking through lists so we know it's either a perch or stealable item
			if(AM)
				if((isitem(AM) && parrot.can_pick_up(AM)) || isliving(AM))	//If stealable item
					parrot.parrot_interest = AM
					parrot.visible_emote("turns and flies towards [parrot.parrot_interest]")
					parrot.parrot_state = PARROT_SWOOP | PARROT_STEAL
					return
				else	//Else it's a perch
					parrot.parrot_perch = AM
					parrot.parrot_state = PARROT_SWOOP | PARROT_RETURN
					return
			return

		if(parrot.parrot_interest && (parrot.parrot_interest in view(parrot)))
			parrot.parrot_state = PARROT_SWOOP | PARROT_STEAL
			return

		if(parrot.parrot_perch && (parrot.parrot_perch in view(parrot)))
			parrot.parrot_state = PARROT_SWOOP | PARROT_RETURN
			return

		else //Have an item but no perch? Find one!
			parrot.parrot_perch = parrot.search_for_perch()
			if(parrot.parrot_perch)
				parrot.parrot_state = PARROT_SWOOP | PARROT_RETURN
				return
//-----STEALING
	else if(parrot.parrot_state == (PARROT_SWOOP | PARROT_STEAL))
		parrot.stop_automove()
		if(!parrot.parrot_interest || parrot.held_item)
			parrot.parrot_state = PARROT_SWOOP | PARROT_RETURN
			return

		if(!(parrot.parrot_interest in view(parrot)))
			parrot.parrot_state = PARROT_SWOOP | PARROT_RETURN
			return

		if(in_range(parrot, parrot.parrot_interest))

			if(isliving(parrot.parrot_interest))
				parrot.steal_from_mob()

			if(isitem(parrot.parrot_interest) && parrot.can_pick_up(parrot.parrot_interest))//This should ensure that we only grab the item we want, and make sure it's not already collected on our perch, a correct size, and not bolted to the floor
				if(!parrot.parrot_perch || parrot.parrot_interest.loc != parrot.parrot_perch.loc)
					parrot.held_item = parrot.parrot_interest
					parrot.parrot_interest.forceMove(parrot)
					parrot.visible_message("[parrot] grabs the [parrot.held_item]!", "<span class='notice'>You grab the [parrot.held_item]!</span>", "You hear the sounds of wings flapping furiously.")

			parrot.parrot_interest = null
			parrot.parrot_state = PARROT_SWOOP | PARROT_RETURN
			return

		parrot.set_moving_slowly()
		parrot.start_automove(parrot.parrot_interest)
		return

//-----RETURNING TO PERCH
	else if(parrot.parrot_state == (PARROT_SWOOP | PARROT_RETURN))
		parrot.stop_automove()
		if(!parrot.parrot_perch || !isturf(parrot.parrot_perch.loc)) //Make sure the perch exists and somehow isnt inside of something else.
			parrot.parrot_perch = null
			parrot.parrot_state = PARROT_WANDER
			return

		if(in_range(parrot, parrot.parrot_perch))
			parrot.forceMove(parrot.parrot_perch.loc)
			parrot.drop_held_item()
			parrot.parrot_state = PARROT_PERCH
			parrot.update_icon()
			return

		parrot.set_moving_slowly()
		parrot.start_automove(parrot.parrot_perch)
		return

//-----FLEEING
	else if(parrot.parrot_state == (PARROT_SWOOP | PARROT_FLEE))
		parrot.stop_automove()
		parrot.give_up()
		if(!parrot.parrot_interest || !isliving(parrot.parrot_interest)) //Sanity
			parrot.parrot_state = PARROT_WANDER

		var/static/datum/automove_metadata/_parrot_flee_automove_metadata = new(
			_move_delay = 2,
			_acceptable_distance = 7,
			_avoid_target = TRUE
		)
		parrot.set_moving_quickly()
		parrot.start_automove(parrot.parrot_interest, metadata = _parrot_flee_automove_metadata)
		parrot.parrot_been_shot--
		return

//-----ATTACKING
	else if(parrot.parrot_state == (PARROT_SWOOP | PARROT_ATTACK))

		//If we're attacking a nothing, an object, a turf or a ghost for some stupid reason, switch to wander
		if(!parrot.parrot_interest || !isliving(parrot.parrot_interest))
			parrot.parrot_interest = null
			parrot.parrot_state = PARROT_WANDER
			return

		var/mob/living/L = parrot.parrot_interest

		//If the mob is close enough to interact with
		if(in_range(parrot, parrot.parrot_interest))

			//If the mob we've been chasing/attacking dies or falls into crit, check for loot!
			if(L.stat)
				parrot.parrot_interest = null
				if(!parrot.held_item)
					parrot.held_item = parrot.steal_from_ground()
					if(!parrot.held_item)
						parrot.held_item = parrot.steal_from_mob() //Apparently it's possible for dead mobs to hang onto items in certain circumstances.
				if(parrot.parrot_perch in view(parrot)) //If we have a home nearby, go to it, otherwise find a new home
					parrot.parrot_state = PARROT_SWOOP | PARROT_RETURN
				else
					parrot.parrot_state = PARROT_WANDER
				return

			//Time for the hurt to begin!
			parrot.UnarmedAttack(L)
			return

		//Otherwise, fly towards the mob!
		else
			parrot.set_moving_quickly()
			parrot.start_automove(parrot.parrot_interest)
		return

//-----STATE MISHAP
	else //This should not happen. If it does lets reset everything and try again
		parrot.stop_automove()
		parrot.parrot_interest = null
		parrot.parrot_perch = null
		parrot.drop_held_item()
		parrot.parrot_state = PARROT_WANDER
		return

/mob/living/simple_animal/hostile/parrot/Initialize()
	. = ..()

	parrot_sleep_dur = parrot_sleep_max //In case someone decides to change the max without changing the duration var

	verbs |= /mob/living/simple_animal/hostile/parrot/proc/steal_from_ground
	verbs |= /mob/living/simple_animal/hostile/parrot/proc/steal_from_mob
	verbs |= /mob/living/simple_animal/hostile/parrot/verb/drop_held_item_player
	verbs |= /mob/living/simple_animal/hostile/parrot/proc/perch_player

	update_icon()

/mob/living/simple_animal/hostile/parrot/Destroy()
	parrot_interest = null
	parrot_perch = null
	if(held_item)
		held_item.dropInto(loc)
		held_item = null
	return ..()

/mob/living/simple_animal/hostile/parrot/death(gibbed)
	var/oldloc = loc
	. = ..()
	if(. && held_item)
		if(oldloc)
			held_item.dropInto(oldloc)
			held_item = null
		else
			QDEL_NULL(held_item)

/mob/living/simple_animal/hostile/parrot/Stat()
	. = ..()
	stat("Held Item", held_item)

/*
 * Attack responces
 */
//Humans, monkeys, aliens
/mob/living/simple_animal/hostile/parrot/default_hurt_interaction(mob/user)
	. = ..()
	if(!client && !simple_parrot && !stat)
		if(parrot_state == PARROT_PERCH)
			parrot_sleep_dur = parrot_sleep_max //Reset it's sleep timer if it was perched
		parrot_interest = user
		parrot_state = PARROT_SWOOP //The parrot just got hit, it WILL move, now to pick a direction..
		if(isliving(user))
			var/mob/living/M = user
			if(M.current_health < 50) //Weakened mob? Fight back!
				parrot_state |= PARROT_ATTACK
				return
		parrot_state |= PARROT_FLEE		//Otherwise, fly like a bat out of hell!
		drop_held_item(0)
		update_icon()

//Mobs with objects
/mob/living/simple_animal/hostile/parrot/attackby(var/obj/item/O, var/mob/user)
	..()
	if(!stat && !client && !istype(O, /obj/item/stack/medical))
		if(O.get_attack_force(user))
			if(parrot_state == PARROT_PERCH)
				parrot_sleep_dur = parrot_sleep_max //Reset it's sleep timer if it was perched
			parrot_interest = user
			parrot_state = PARROT_SWOOP | PARROT_FLEE
			drop_held_item(0)
			update_icon()

//Bullets
/mob/living/simple_animal/hostile/parrot/bullet_act(var/obj/item/projectile/Proj)
	..()
	if(!stat && !client)
		if(parrot_state == PARROT_PERCH)
			parrot_sleep_dur = parrot_sleep_max //Reset it's sleep timer if it was perched
		parrot_interest = null
		parrot_state = PARROT_WANDER //OWFUCK, Been shot! RUN LIKE HELL!
		parrot_been_shot += 5
		drop_held_item(0)
		update_icon()

/mob/living/simple_animal/hostile/parrot/proc/search_for_item()
	for(var/atom/movable/AM in view(src))
		//Skip items we already stole or are wearing or are too big
		if(parrot_perch && AM.loc == parrot_perch.loc || AM.loc == src)
			continue

		if(isitem(AM) && can_pick_up(AM))
			return AM

		if(ismob(AM))
			var/mob/M = AM
			for(var/hand_slot in M.get_held_item_slots())
				var/datum/inventory_slot/inv_slot = M.get_inventory_slot_datum(hand_slot)
				var/held = inv_slot.get_equipped_item()
				if(held && can_pick_up(held))
					return M

/mob/living/simple_animal/hostile/parrot/proc/search_for_perch()
	for(var/obj/O in view(src))
		for(var/path in desired_perches)
			if(istype(O, path))
				return O
	return null

//This proc was made to save on doing two 'in view' loops seperatly
/mob/living/simple_animal/hostile/parrot/proc/search_for_perch_and_item()
	for(var/atom/movable/AM in view(src))
		for(var/perch_path in desired_perches)
			if(istype(AM, perch_path))
				return AM

		//Skip items we already stole or are wearing or are too big
		if(parrot_perch && AM.loc == parrot_perch.loc || AM.loc == src)
			continue

		if(isitem(AM) && can_pick_up(AM))
			return AM

		if(ismob(AM))
			var/mob/M = AM
			for(var/hand_slot in M.get_held_item_slots())
				var/datum/inventory_slot/inv_slot = M.get_inventory_slot_datum(hand_slot)
				var/held = inv_slot?.get_equipped_item()
				if(held && can_pick_up(held))
					return M

/mob/living/simple_animal/hostile/parrot/proc/give_up()
	if(!istype(ai) || !LAZYLEN(ai.get_enemies()))
		return
	ai.clear_enemies()
	ai.lose_target()
	visible_message(SPAN_NOTICE("\The [src] seems to calm down."))
	relax_chance -= impatience

/*
 * Verbs - These are actually procs, but can be used as verbs by player-controlled parrots.
 */
/mob/living/simple_animal/hostile/parrot/proc/steal_from_ground()
	set name = "Steal from ground"
	set category = "Parrot"
	set desc = "Grabs a nearby item."

	if(stat)
		return -1

	if(held_item)
		to_chat(src, "<span class='warning'>You are already holding the [held_item]</span>")
		return 1

	for(var/obj/item/I in view(1,src))
		//Make sure we're not already holding it and it's small enough
		if(I.loc != src && can_pick_up(I))

			//If we have a perch and the item is sitting on it, continue
			if(!client && parrot_perch && I.loc == parrot_perch.loc)
				continue

			held_item = I
			I.forceMove(src)
			visible_message("[src] grabs the [held_item]!", "<span class='notice'>You grab the [held_item]!</span>", "You hear the sounds of wings flapping furiously.")
			return held_item

	to_chat(src, "<span class='warning'>There is nothing of interest to take.</span>")
	return 0

/mob/living/simple_animal/hostile/parrot/proc/steal_from_mob()
	set name = "Steal from mob"
	set category = "Parrot"
	set desc = "Steals an item right out of a person's hand!"

	if(stat)
		return -1

	if(held_item)
		to_chat(src, "<span class='warning'>You are already holding the [held_item]</span>")
		return 1

	var/obj/item/stolen_item = null
	for(var/mob/living/target in view(1,src))
		for(var/obj/item/thing in target.get_held_items())
			if(can_pick_up(thing))
				stolen_item = thing
				break
		if(stolen_item && target.try_unequip(stolen_item, src))
			held_item = stolen_item
			visible_message("[src] grabs the [held_item] out of [target]'s hand!", "<span class='warning'>You snag the [held_item] out of [target]'s hand!</span>", "You hear the sounds of wings flapping furiously.")
			return held_item

	to_chat(src, "<span class='warning'>There is nothing of interest to take.</span>")
	return 0

/mob/living/simple_animal/hostile/parrot/verb/drop_held_item_player()
	set name = "Drop held item"
	set category = "Parrot"
	set desc = "Drop the item you're holding."

	if(stat)
		return

	src.drop_held_item()

	return

/mob/living/simple_animal/hostile/parrot/proc/drop_held_item(var/drop_gently = 1)
	set name = "Drop held item"
	set category = "Parrot"
	set desc = "Drop the item you're holding."

	if(stat)
		return -1

	if(!held_item)
		to_chat(usr, "<span class='warning'>You have nothing to drop!</span>")
		return 0

	if(!drop_gently)
		if(istype(held_item, /obj/item/grenade))
			var/obj/item/grenade/G = held_item
			G.dropInto(loc)
			G.detonate()
			to_chat(src, "You let go of the [held_item]!")
			held_item = null
			return 1

	to_chat(src, "You drop the [held_item].")

	held_item.dropInto(loc)
	held_item = null
	return 1

/mob/living/simple_animal/hostile/parrot/proc/perch_player()
	set name = "Sit"
	set category = "Parrot"
	set desc = "Sit on a nice comfy perch."

	if(stat || !client)
		return

	for(var/atom/movable/AM in view(src,1))
		for(var/perch_path in desired_perches)
			if(istype(AM, perch_path))
				forceMove(AM.loc)
				update_icon()
				return
	to_chat(src, SPAN_WARNING("There is no perch nearby to sit on."))

/mob/living/simple_animal/hostile/parrot/proc/can_pick_up(obj/item/I)
	. = (Adjacent(I) && I.w_class <= parrot_isize && !I.anchored)

/*
 * Sub-types
 */
/mob/living/simple_animal/hostile/parrot/Poly
	name = "Poly"
	desc = "Poly the Parrot. An expert on quantum cracker theory."
	ai = /datum/mob_controller/aggressive/parrot/poly

/datum/mob_controller/aggressive/parrot/poly
	emote_speech = list("Poly wanna cracker!", "Check the singlo, you chucklefucks!","Wire the solars, you lazy bums!","WHO TOOK THE DAMN HARDSUITS?","OH GOD ITS FREE CALL THE SHUTTLE!")
