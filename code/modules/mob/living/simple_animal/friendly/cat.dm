/datum/mob_controller/hunter/cat
	emote_speech     = list("Meow!","Esp!","Purr!","HSSSSS")
	emote_hear       = list("meows","mews")
	emote_see        = list("shakes their head", "shivers")
	speak_chance     = 0.25
	turns_per_wander = 10

/datum/mob_controller/hunter/cat/melee_attack_target(atom/target)
	var/mob/living/simple_animal/passive/mouse/mouse = target
	if(istype(mouse))
		mouse.splat()
		return
	return ..()

/datum/mob_controller/hunter/cat/wants_to_hunt(mob/living/prey)
	return istype(prey, /mob/living/simple_animal/passive/mouse)

/datum/mob_controller/hunter/cat/do_process()
	if(!(. = ..()))
		return

	var/mob/living/simple_animal/passive/mouse/snack = get_target()
	if(!snack && !get_flee_target() && prob(1)) //spooky
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
	else if(istype(snack) && snack.stat != DEAD && prob(15))
		body.custom_emote(AUDIBLE_MESSAGE, pick("hisses and spits!", "mrowls fiercely!", "eyes [snack] hungrily."))

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
	possession_candidate = TRUE
	pass_flags = PASS_FLAG_TABLE
	butchery_data = /decl/butchery_data/animal/cat
	base_animal_type = /mob/living/simple_animal/passive/cat
	ai = /datum/mob_controller/hunter/cat

/mob/living/simple_animal/passive/cat/get_bodytype()
	return GET_DECL(/decl/bodytype/quadruped/animal/cat)

/decl/bodytype/quadruped/animal/cat
	uid = "bodytype_animal_cat"

/decl/bodytype/quadruped/animal/cat/Initialize()
	_equip_adjust = list(
		(slot_head_str) = list(
			"[NORTH]" = list( 1,  -9),
			"[SOUTH]" = list( 1, -12),
			"[EAST]"  = list( 7, -10),
			"[WEST]"  = list(-7, -10)
		)
	)
	. = ..()

//Basic friend AI
/mob/living/simple_animal/passive/cat/fluff
	ai = /datum/mob_controller/hunter/cat/friendly

/mob/living/simple_animal/passive/cat/fluff/is_tagging_suitable()
	return FALSE

/datum/mob_controller/hunter/cat/friendly
	var/befriend_job = null

/datum/mob_controller/hunter/cat/friendly/handle_friendly_proximity(mob/living/friend, friend_is_hurt)
	if (prob(10))
		body.say("Meow!")
	if(get_dist(body, friend) <= 1)
		if (friend.stat >= DEAD || friend.is_asystole())
			if (prob((friend.stat < DEAD)? 25 : 7.5))
				var/sad_verb = pick("meows", "mews", "mrowls")
				body.custom_emote(AUDIBLE_MESSAGE, pick("[sad_verb] in distress.", "[sad_verb] anxiously."))
		else if (prob(5))
			body.custom_emote(
				VISIBLE_MESSAGE,
				pick("nuzzles [friend].","brushes against [friend].","rubs against [friend].","purrs.")
			)
	else if (friend_is_hurt && prob(5))
		var/sad_verb = pick("meows", "mews", "mrowls")
		body.custom_emote(AUDIBLE_MESSAGE, "[sad_verb] anxiously.")

/datum/mob_controller/hunter/cat/friendly/add_friend(mob/friend)
	if(length(get_friends()) > 1 || !ishuman(friend))
		return FALSE
	var/mob/living/human/human_friend = friend
	if(befriend_job && human_friend.job != befriend_job)
		return FALSE
	return ..()

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
	_equip_adjust = list(
		(slot_head_str) = list(
			"[NORTH]" = list( 1, -14),
			"[SOUTH]" = list( 1, -14),
			"[EAST]"  = list( 5, -14),
			"[WEST]"  = list(-5, -14)
		)
	)
	. = ..()

/mob/living/simple_animal/passive/cat/kitten/Initialize()
	. = ..()
	set_gender(pick(MALE, FEMALE))

/mob/living/simple_animal/passive/cat/fluff/ran
	name = "Runtime"
	desc = "Under no circumstances is this feline allowed inside the atmospherics system."
	gender = FEMALE
	holder_type = /obj/item/holder/runtime

/mob/living/simple_animal/passive/cat/fluff/felix
	name = "Felix"
	desc = "A very oddly-behaved, malnourished cat. Their scratched name tag reads 'Felix'."
