/datum/mob_controller/passive/hunter/cat
	emote_speech     = list("Meow!","Esp!","Purr!","HSSSSS")
	emote_hear       = list("meows","mews")
	emote_see        = list("shakes their head", "shivers")
	speak_chance     = 0.25
	turns_per_wander = 10

/datum/mob_controller/passive/hunter/cat/try_attack_prey(mob/living/prey)
	var/mob/living/simple_animal/passive/mouse/mouse = prey
	if(istype(mouse))
		mouse.splat()
		return
	return ..()

/datum/mob_controller/passive/hunter/cat/consume_prey(mob/living/prey)
	next_hunt = world.time + rand(1 SECONDS, 10 SECONDS)

/datum/mob_controller/passive/hunter/cat/can_hunt(mob/living/victim)
	return istype(victim, /mob/living/simple_animal/passive/mouse) && !victim.stat

/datum/mob_controller/passive/hunter/cat/update_targets()
	. = ..()
	if(!flee_target)
		for(var/mob/living/simple_animal/passive/mouse/snack in oview(body, 5))
			if(snack.stat != DEAD && prob(15))
				body.custom_emote(AUDIBLE_MESSAGE, pick("hisses and spits!", "mrowls fiercely!", "eyes [snack] hungrily."))
			break

/datum/mob_controller/passive/hunter/cat/do_process()

	if(!(. = ..()))
		return

	if(!hunt_target && !flee_target && prob(1)) //spooky
		var/mob/observer/ghost/spook = locate() in range(body, 5)
		if(spook)
			var/turf/T = spook.loc
			var/list/visible = list()
			for(var/obj/O in T.contents)
				if(!O.invisibility && O.name)
					visible += O
			if(visible.len)
				var/atom/A = pick(visible)
				body.custom_emote(VISIBLE_MESSAGE, "suddenly stops and stares at something unseen[istype(A) ? " near [A]":""].")

//Cat
/mob/living/simple_animal/passive/cat
	name = "cat"
	desc = "A domesticated, feline pet. Has a tendency to adopt crewmembers."
	icon = 'icons/mob/simple_animal/cat_calico.dmi'
	speak_emote  = list("purrs", "meows")
	see_in_dark = 6
	minbodytemp = 223		//Below -50 Degrees Celsius
	maxbodytemp = 323	//Above 50 Degrees Celsius
	holder_type = /obj/item/holder
	mob_size = MOB_SIZE_SMALL
	possession_candidate = 1
	pass_flags = PASS_FLAG_TABLE
	butchery_data = /decl/butchery_data/animal/cat
	base_animal_type = /mob/living/simple_animal/passive/cat
	ai = /datum/mob_controller/passive/hunter/cat
	var/turns_since_scan = 0
	var/mob/living/simple_animal/passive/mouse/movement_target
	var/mob/flee_target

/mob/living/simple_animal/passive/cat/get_bodytype()
	return GET_DECL(/decl/bodytype/quadruped/animal/cat)

/decl/bodytype/quadruped/animal/cat
	uid = "bodytype_animal_cat"

/decl/bodytype/quadruped/animal/cat/Initialize()
	equip_adjust = list(
		slot_head_str = list(
			"[NORTH]" = list( 1,  -9),
			"[SOUTH]" = list( 1, -12),
			"[EAST]" =  list( 7, -10),
			"[WEST]" =  list(-7, -10)
		)
	)
	. = ..()

//Basic friend AI
/mob/living/simple_animal/passive/cat/fluff
	ai = /datum/mob_controller/passive/hunter/cat/friendly

/datum/mob_controller/passive/hunter/cat/friendly
	var/befriend_job = null
	var/atom/movement_target

/datum/mob_controller/passive/hunter/cat/friendly/add_friend(mob/friend)
	if(length(get_friends()) > 1 || !ishuman(friend))
		return FALSE
	var/mob/living/human/human_friend = friend
	if(befriend_job && human_friend.job != befriend_job)
		return FALSE
	return ..()

/datum/mob_controller/passive/hunter/cat/friendly/do_process()

	if(!(. = ..()))
		return

	// Get our friend.
	var/list/friends = get_friends()
	var/mob/living/human/friend
	if(LAZYLEN(friends))
		var/weakref/friend_ref = friends[1]
		friend = friend_ref.resolve()

	if(body.stat || hunt_target || flee_target || QDELETED(friend))
		return

	var/follow_dist = 4
	if (friend.stat >= DEAD || friend.is_asystole()) //danger
		follow_dist = 1
	else if (friend.stat || friend.current_health <= 50) //danger or just sleeping
		follow_dist = 2
	var/near_dist = max(follow_dist - 2, 1)
	var/current_dist = get_dist(body, friend)

	if (movement_target != friend)
		if (current_dist > follow_dist && (friend in oview(body)))
			//stop existing movement
			body.stop_automove()
			turns_since_scan = 0

			//walk to friend
			stop_wandering()
			movement_target = friend
			body.start_automove(movement_target, metadata = new /datum/automove_metadata(_acceptable_distance = near_dist))

	//already following and close enough, stop
	else if (current_dist <= near_dist)
		body.stop_automove()
		movement_target = null
		resume_wandering()
		if (prob(10))
			body.say("Meow!")

	if (get_dist(body, friend) <= 1)
		if (friend.stat >= DEAD || friend.is_asystole())
			if (prob((friend.stat < DEAD)? 25 : 7.5))
				var/verb = pick("meows", "mews", "mrowls")
				body.custom_emote(AUDIBLE_MESSAGE, pick("[verb] in distress.", "[verb] anxiously."))
		else if (prob(5))
			body.custom_emote(
				VISIBLE_MESSAGE,
				pick("nuzzles [friend].","brushes against [friend].","rubs against [friend].","purrs.")
			)
	else if (friend.current_health <= 50 && prob(5))
		var/verb = pick("meows", "mews", "mrowls")
		body.custom_emote(AUDIBLE_MESSAGE, "[verb] anxiously.")

/mob/living/simple_animal/passive/cat/fluff/verb/become_friends()
	set name = "Become Friends"
	set category = "IC"
	set src in view(1)

	if(!istype(ai))
		return

	var/list/friends = ai?.get_friends()
	if(!LAZYLEN(friends))
		return

	var/weakref/current_friend = friends[1]
	var/mob/friend = current_friend?.resolve()

	if(!friend)
		var/mob/living/human/H = usr
		if(istype(H))
			. = ai?.add_friend(usr)
	else if(usr == friend)
		. = 1 //already friends, but show success anyways

	if(.)
		set_dir(get_dir(src, friend))
		visible_emote(pick("nuzzles [friend].",
						   "brushes against [friend].",
						   "rubs against [friend].",
						   "purrs."))
	else
		to_chat(usr, "<span class='notice'>[src] ignores you.</span>")
	return

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/passive/cat/fluff/runtime
	name = "Runtime"
	desc = "Her fur has the look and feel of velvet, and her tail quivers occasionally."
	gender = FEMALE
	icon = 'icons/mob/simple_animal/cat_black.dmi'
	butchery_data = /decl/butchery_data/animal/cat/black
	holder_type = /obj/item/holder/runtime

/obj/item/holder/runtime
	origin_tech = @'{"programming":1,"biotech":1}'

/mob/living/simple_animal/passive/cat/kitten
	name = "kitten"
	desc = "D'aaawwww"
	icon = 'icons/mob/simple_animal/kitten.dmi'
	gender = NEUTER
	butchery_data = /decl/butchery_data/animal/cat/kitten

/mob/living/simple_animal/passive/cat/kitten/get_bodytype()
	return GET_DECL(/decl/bodytype/quadruped/animal/kitten)

/decl/bodytype/quadruped/animal/kitten
	uid = "bodytype_animal_kitten"

/decl/bodytype/quadruped/animal/kitten/Initialize()
	equip_adjust = list(
		slot_head_str = list(
			"[NORTH]" = list( 1, -14),
			"[SOUTH]" = list( 1, -14),
			"[EAST]" =  list( 5, -14),
			"[WEST]" =  list(-5, -14)
		)
	)
	. = ..()

/mob/living/simple_animal/passive/cat/kitten/Initialize()
	. = ..()
	gender = pick(MALE, FEMALE)

/mob/living/simple_animal/passive/cat/fluff/ran
	name = "Runtime"
	desc = "Under no circumstances is this feline allowed inside the atmospherics system."
	gender = FEMALE
	holder_type = /obj/item/holder/runtime
