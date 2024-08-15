//goat
/mob/living/simple_animal/hostile/goat
	name = "goat"
	desc = "Not known for their pleasant disposition."
	icon = 'icons/mob/simple_animal/goat.dmi'
	speak_emote  = list("brays")

	see_in_dark = 6
	faction = "goat"
	max_health = 40
	natural_weapon = /obj/item/natural_weapon/hooves
	butchery_data = /decl/butchery_data/animal/ruminant/goat
	ai = /datum/mob_controller/aggressive/goat
	var/datum/reagents/udder = null

/datum/mob_controller/aggressive/goat
	expected_type = /mob/living/simple_animal/hostile/goat
	emote_speech = list("EHEHEHEHEH","eh?")
	emote_hear   = list("brays")
	emote_see    = list("shakes its head", "stamps a foot", "glares around")
	speak_chance = 0.25
	turns_per_wander = 10
	only_attack_enemies = TRUE

/datum/mob_controller/aggressive/goat/retaliate(atom/source)
	..()
	if(body?.stat == CONSCIOUS && prob(50))
		var/decl/pronouns/pronouns = body.get_pronouns()
		body.visible_message(SPAN_DANGER("\The [body] gets an evil-looking gleam in [pronouns.his] eye."))

/datum/mob_controller/aggressive/goat/proc/find_edible_atom(list/targets)
	// TODO: add /obj/structure/flora here and in goat/UnarmedAttack()
	var/atom/maybe_food = locate(/obj/effect/vine) in targets
	if(!istype(maybe_food))
		for(var/obj/machinery/portable_atmospherics/hydroponics/tray in targets)
			if(tray.seed)
				maybe_food = tray
				break
	if(istype(maybe_food))
		if(get_dist(body, maybe_food) > 1 || body.Adjacent(maybe_food))
			return maybe_food

/datum/mob_controller/aggressive/goat/do_process(time_elapsed)

	if(!(. = ..()) || body.stat)
		return

	//chance to go crazy and start wacking stuff
	var/list/enemies = get_enemies()
	if(!LAZYLEN(enemies) && prob(0.5))
		retaliate()

	if(LAZYLEN(enemies) && prob(5))
		clear_enemies()
		lose_target()
		body.visible_message(SPAN_NOTICE("\The [body] calms down."))

	if(get_target())
		return

	var/atom/food = find_edible_atom(view(1, body.loc))
	if(istype(food))
		body.stop_automove()
		body.a_intent = I_HELP
		body.ClickOn(food)
	else if(!LAZYLEN(body.grabbed_by))
		food = find_edible_atom(oview(5, body.loc))
		if(istype(food))
			body.start_automove(food)
		else
			body.stop_automove()
	else
		body.stop_automove()

/mob/living/simple_animal/hostile/goat/Initialize()
	. = ..()
	udder = new(50, src)

/mob/living/simple_animal/hostile/goat/UnarmedAttack(var/atom/A, var/proximity)
	var/was_food = FALSE
	if(proximity)
		if(prob(30))
			if(istype(A, /obj/effect/vine))
				var/obj/effect/vine/SV = A
				SV.die_off(1)
				was_food = TRUE
			else if(istype(A, /obj/machinery/portable_atmospherics/hydroponics))
				var/obj/machinery/portable_atmospherics/hydroponics/tray = A
				if(tray.seed)
					was_food = TRUE
					tray.die()
					if(!QDELETED(tray))
						tray.remove_dead(silent = TRUE) // this will qdel invisible trays
		if(was_food)
			visible_message(SPAN_NOTICE("\The [src] eats \the [A]."))

	return was_food ? TRUE :..()

/mob/living/simple_animal/hostile/goat/Destroy()
	QDEL_NULL(udder)
	. = ..()

/mob/living/simple_animal/hostile/goat/handle_living_non_stasis_processes()
	if((. = ..()) && stat == CONSCIOUS && udder && prob(5))
		udder.add_reagent(/decl/material/liquid/drink/milk, rand(5, 10))

/mob/living/simple_animal/hostile/goat/attackby(var/obj/item/O, var/mob/user)
	var/obj/item/chems/glass/G = O
	if(stat == CONSCIOUS && istype(G) && ATOM_IS_OPEN_CONTAINER(G))
		user.visible_message("<span class='notice'>[user] milks [src] using \the [O].</span>")
		var/transfered = udder.trans_type_to(G, /decl/material/liquid/drink/milk, rand(5,10))
		if(G.reagents.total_volume >= G.volume)
			to_chat(user, "<span class='warning'>\The [O] is full.</span>")
		if(!transfered)
			to_chat(user, "<span class='warning'>The udder is dry. Wait a bit longer...</span>")
	else
		..()

//cow
/mob/living/simple_animal/cow
	name = "cow"
	desc = "Known for their milk, just don't tip them over."
	icon = 'icons/mob/simple_animal/cow.dmi'
	speak_emote  = list("moos","moos hauntingly")
	ai = /datum/mob_controller/cow
	see_in_dark = 6
	max_health = 50
	butchery_data = /decl/butchery_data/animal/ruminant/cow

	var/datum/reagents/udder = null
	var/static/list/responses = list(
		"looks at you imploringly",
		"looks at you pleadingly",
		"looks at you with a resigned expression",
		"seems resigned to its fate"
	)

/datum/mob_controller/cow
	emote_speech = list("moo?","moo","MOOOOOO")
	emote_hear   = list("brays")
	emote_see    = list("shakes its head")
	speak_chance = 0.25
	turns_per_wander = 10

/mob/living/simple_animal/cow/Initialize()
	. = ..()
	udder = new(50, src)

/mob/living/simple_animal/cow/Destroy()
	QDEL_NULL(udder)
	. = ..()

/mob/living/simple_animal/cow/attackby(var/obj/item/O, var/mob/user)
	var/obj/item/chems/glass/G = O
	if(stat == CONSCIOUS && istype(G) && ATOM_IS_OPEN_CONTAINER(G))
		if(G.reagents.total_volume >= G.volume)
			to_chat(user, SPAN_WARNING("\The [O] is full."))
			return TRUE
		if(!udder.total_volume)
			to_chat(user, SPAN_WARNING("The udder is dry. Wait a bit longer."))
			return TRUE
		user.visible_message(SPAN_NOTICE("\The [user] milks \the [src] using \the [O]."))
		udder.trans_type_to(G, /decl/material/liquid/drink/milk, rand(5,10))
		if(G.reagents.total_volume >= G.volume)
			to_chat(user, SPAN_NOTICE("\The [O] is full."))
		return TRUE
	. = ..()

/mob/living/simple_animal/cow/handle_living_non_stasis_processes()
	if((. = ..()) && udder && prob(5))
		udder.add_reagent(/decl/material/liquid/drink/milk, rand(5, 10))

/mob/living/simple_animal/cow/default_disarm_interaction(mob/user)
	if(stat != DEAD && !HAS_STATUS(src, STAT_WEAK))
		user.visible_message(SPAN_NOTICE("\The [user] tips over \the [src]."))
		SET_STATUS_MAX(src, STAT_WEAK, 30)
		addtimer(CALLBACK(src, PROC_REF(do_tip_response)), rand(20, 50))
		return TRUE
	return ..()

/mob/living/simple_animal/cow/proc/do_tip_response()
	if(stat == CONSCIOUS)
		visible_message("<b>\The [src]</b> [pick(responses)].")

/mob/living/simple_animal/chick
	name = "chick"
	desc = "Adorable! They make such a racket though."
	icon = 'icons/mob/simple_animal/chick.dmi'
	speak_emote  = list("cheeps")
	max_health = 1
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GRILLE
	mob_size = MOB_SIZE_MINISCULE
	butchery_data = /decl/butchery_data/animal/small/fowl/chicken/chick
	ai = /datum/mob_controller/chick
	holder_type = /obj/item/holder
	var/amount_grown = 0

/datum/mob_controller/chick
	emote_speech = list("Cherp.","Cherp?","Chirrup.","Cheep!")
	emote_hear   = list("cheeps")
	emote_see    = list("pecks at the ground","flaps its tiny wings")
	speak_chance = 0.5
	turns_per_wander = 4

/mob/living/simple_animal/chick/Initialize()
	. = ..()
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)

/mob/living/simple_animal/chick/handle_living_non_stasis_processes()
	if((. = ..()))
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			new /mob/living/simple_animal/fowl/chicken(src.loc)
			qdel(src)

/mob/living/simple_animal/fowl
	max_health = 10
	pass_flags = PASS_FLAG_TABLE
	mob_size = MOB_SIZE_SMALL
	butchery_data = /decl/butchery_data/animal/small/fowl
	ai = /datum/mob_controller/fowl
	abstract_type = /mob/living/simple_animal/fowl
	var/body_color

/datum/mob_controller/fowl
	speak_chance = 1
	turns_per_wander = 6

/mob/living/simple_animal/fowl/Initialize()
	if(!default_pixel_x)
		default_pixel_x = rand(-6, 6)
	if(!default_pixel_y)
		default_pixel_y = rand(0, 10)
	. = ..()

var/global/const/MAX_CHICKENS = 50
var/global/chicken_count = 0
/mob/living/simple_animal/fowl/chicken
	name = "chicken"
	desc = "Hopefully the eggs are good this season."
	icon = 'icons/mob/simple_animal/chicken_white.dmi'
	speak_emote  = list("clucks","croons")
	butchery_data = /decl/butchery_data/animal/small/fowl/chicken
	ai = /datum/mob_controller/fowl/chicken
	holder_type = /obj/item/holder
	var/eggsleft = 0

/datum/mob_controller/fowl/chicken
	emote_speech = list("Cluck!","BWAAAAARK BWAK BWAK BWAK!","Bwaak bwak.")
	emote_hear   = list("clucks")
	emote_see    = list("pecks at the ground","flaps its wings viciously")

/mob/living/simple_animal/fowl/chicken/Initialize()
	. = ..()
	if(!body_color)
		body_color = pick("brown", "black", "white")
		update_icon()
	global.chicken_count += 1

/mob/living/simple_animal/fowl/chicken/on_update_icon()
	. = ..()
	switch(body_color)
		if("brown")
			icon = 'icons/mob/simple_animal/chicken_brown.dmi'
		if("black")
			icon = 'icons/mob/simple_animal/chicken_black.dmi'
		else
			icon = 'icons/mob/simple_animal/chicken_white.dmi'

/mob/living/simple_animal/fowl/chicken/death(gibbed)
	. = ..()
	if(.)
		global.chicken_count -= 1

/mob/living/simple_animal/fowl/chicken/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/food)) //feedin' dem chickens
		var/obj/item/food/G = O
		if(findtext(G.get_grown_tag(), "wheat")) // includes chopped, crushed, dried etc.
			if(!stat && eggsleft < 8)
				user.visible_message(SPAN_NOTICE("[user] feeds \the [O] to \the [src]! It clucks happily."), SPAN_NOTICE("You feed \the [O] to \the [src]! It clucks happily."), SPAN_NOTICE("You hear clucking."))
				qdel(O)
				eggsleft += rand(1, 4)
			else
				to_chat(user, SPAN_NOTICE("\The [src] doesn't seem hungry!"))
		else
			to_chat(user, "\The [src] doesn't seem interested in that.")
	else
		..()

/mob/living/simple_animal/fowl/chicken/handle_living_non_stasis_processes()
	if((. = ..()) && prob(3) && eggsleft > 0)
		visible_message("[src] [pick("lays an egg.","squats down and croons.","begins making a huge racket.","begins clucking raucously.")]")
		eggsleft--
		var/obj/item/food/egg/E = new(get_turf(src))
		E.pixel_x = rand(-6,6)
		E.pixel_y = rand(-6,6)
		if(chicken_count < MAX_CHICKENS && prob(10))
			E.amount_grown = 1
			START_PROCESSING(SSobj, E)

/mob/living/simple_animal/fowl/duck
	name = "duck"
	desc = "It's a duck. Quack."
	icon = 'icons/mob/simple_animal/duck_white.dmi'
	speak_emote  = list("quacks")
	butchery_data = /decl/butchery_data/animal/small/fowl/duck
	ai = /datum/mob_controller/fowl/duck

/datum/mob_controller/fowl/duck
	emote_speech = list("Wak!","Wak wak wak!","Wak wak.")
	emote_hear   = list("quacks")
	emote_see    = list("preens itself", "waggles its tail")

/mob/living/simple_animal/fowl/duck/Initialize()
	. = ..()
	if(!body_color)
		body_color = pick("brown", "mallard", "white")
		update_icon()

/mob/living/simple_animal/fowl/duck/on_update_icon()
	. = ..()
	switch(body_color)
		if("brown")
			icon = 'icons/mob/simple_animal/duck_brown.dmi'
		if("mallard")
			icon = 'icons/mob/simple_animal/duck_mallard.dmi'
		else
			icon = 'icons/mob/simple_animal/duck_white.dmi'

/obj/item/food/egg
	var/amount_grown = 0

/obj/item/food/egg/Destroy()
	if(amount_grown)
		STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/food/egg/Process()
	if(isturf(loc))
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			visible_message("[src] hatches with a quiet cracking sound.")
			new /mob/living/simple_animal/chick(get_turf(src))
			STOP_PROCESSING(SSobj, src)
			qdel(src)
	else
		return PROCESS_KILL
