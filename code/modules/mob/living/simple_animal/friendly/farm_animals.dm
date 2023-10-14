//goat
/mob/living/simple_animal/hostile/retaliate/goat
	name = "goat"
	desc = "Not known for their pleasant disposition."
	icon = 'icons/mob/simple_animal/goat.dmi'
	speak = list("EHEHEHEHEH","eh?")
	speak_emote = list("brays")
	emote_hear = list("brays")
	emote_see = list("shakes its head", "stamps a foot", "glares around")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	faction = "goat"
	health = 40
	natural_weapon = /obj/item/natural_weapon/hooves

	meat_type = /obj/item/chems/food/meat/goat
	meat_amount = 4
	bone_amount = 8
	skin_material = /decl/material/solid/organic/skin/goat
	skin_amount = 8

	ai = /datum/ai/goat

	var/datum/reagents/udder = null

/datum/ai/goat
	expected_type = /mob/living/simple_animal/hostile/retaliate/goat

/datum/ai/goat/do_process(time_elapsed)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/goat/goat = body

	//chance to go crazy and start wacking stuff
	if(!length(goat.enemies) && prob(1))
		goat.Retaliate()

	if(length(goat.enemies) && prob(10))
		goat.enemies = list()
		goat.LoseTarget()
		goat.visible_message(SPAN_NOTICE("\The [goat] calms down."))

	var/obj/effect/vine/SV = locate() in goat.loc
	if(SV)
		if(prob(60))
			goat.visible_message(SPAN_NOTICE("\The [goat] eats the plants."))
			SV.die_off(1)
			var/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/SP = locate() in goat.loc
			if(SP)
				qdel(SP)
		else if(prob(20))
			goat.visible_message(SPAN_NOTICE("\The [goat] chews on the plants."))
		return

	if(!LAZYLEN(goat.grabbed_by))
		var/obj/effect/vine/food = locate(/obj/effect/vine) in oview(5,goat.loc)
		if(food)
			var/step = get_step_to(goat, food, 0)
			goat.Move(step)

/mob/living/simple_animal/hostile/retaliate/goat/Initialize()
	. = ..()
	udder = new(50, src)

/mob/living/simple_animal/hostile/retaliate/goat/Destroy()
	QDEL_NULL(udder)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/goat/handle_regular_status_updates()
	. = ..()
	if(. && stat == CONSCIOUS && udder && prob(5))
		udder.add_reagent(/decl/material/liquid/drink/milk, rand(5, 10))

/mob/living/simple_animal/hostile/retaliate/goat/Retaliate()
	..()
	if(stat == CONSCIOUS && prob(50))
		visible_message("<span class='warning'>\The [src] gets an evil-looking gleam in their eye.</span>")

/mob/living/simple_animal/hostile/retaliate/goat/attackby(var/obj/item/O, var/mob/user)
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
	speak = list("moo?","moo","MOOOOOO")
	speak_emote = list("moos","moos hauntingly")
	emote_hear = list("brays")
	emote_see = list("shakes its head")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	health = 50

	meat_type = /obj/item/chems/food/meat/beef
	meat_amount = 6
	bone_amount = 10
	skin_material = /decl/material/solid/organic/skin/cow
	skin_amount = 10

	var/datum/reagents/udder = null
	var/static/list/responses = list(
		"looks at you imploringly",
		"looks at you pleadingly",
		"looks at you with a resigned expression",
		"seems resigned to its fate"
	)

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

/mob/living/simple_animal/cow/handle_regular_status_updates()
	. = ..()
	if(. && udder && prob(5))
		udder.add_reagent(/decl/material/liquid/drink/milk, rand(5, 10))

/mob/living/simple_animal/cow/default_disarm_interaction(mob/user)
	if(stat != DEAD && !HAS_STATUS(src, STAT_WEAK))
		user.visible_message(SPAN_NOTICE("\The [user] tips over \the [src]."))
		SET_STATUS_MAX(src, STAT_WEAK, 30)
		addtimer(CALLBACK(src, .proc/do_tip_response), rand(20, 50))
		return TRUE
	return ..()

/mob/living/simple_animal/cow/proc/do_tip_response()
	if(stat == CONSCIOUS)
		visible_message("<b>\The [src]</b> [pick(responses)].")

/mob/living/simple_animal/chick
	name = "chick"
	desc = "Adorable! They make such a racket though."
	icon = 'icons/mob/simple_animal/chick.dmi'
	speak = list("Cherp.","Cherp?","Chirrup.","Cheep!")
	speak_emote = list("cheeps")
	emote_hear = list("cheeps")
	emote_see = list("pecks at the ground","flaps its tiny wings")
	speak_chance = 2
	turns_per_move = 2
	health = 1
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GRILLE
	mob_size = MOB_SIZE_MINISCULE

	meat_type = /obj/item/chems/food/meat/chicken
	meat_amount = 1
	bone_amount = 3
	skin_amount = 3
	skin_material = /decl/material/solid/organic/skin/feathers

	var/amount_grown = 0

/mob/living/simple_animal/chick/Initialize()
	. = ..()
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)

/mob/living/simple_animal/chick/Life()
	. = ..()
	if(!.)
		return FALSE
	amount_grown += rand(1,2)
	if(amount_grown >= 100)
		new /mob/living/simple_animal/chicken(src.loc)
		qdel(src)

var/global/const/MAX_CHICKENS = 50
var/global/chicken_count = 0

/mob/living/simple_animal/chicken
	name = "chicken"
	desc = "Hopefully the eggs are good this season."
	icon = 'icons/mob/simple_animal/chicken_white.dmi'
	speak = list("Cluck!","BWAAAAARK BWAK BWAK BWAK!","Bwaak bwak.")
	speak_emote = list("clucks","croons")
	emote_hear = list("clucks")
	emote_see = list("pecks at the ground","flaps its wings viciously")
	speak_chance = 2
	turns_per_move = 3
	health = 10
	pass_flags = PASS_FLAG_TABLE
	mob_size = MOB_SIZE_SMALL

	meat_type = /obj/item/chems/food/meat/chicken
	meat_amount = 2
	skin_material = /decl/material/solid/organic/skin/feathers

	var/eggsleft = 0
	var/body_color

/mob/living/simple_animal/chicken/Initialize()
	. = ..()
	if(!body_color)
		body_color = pick( list("brown","black","white") )
	switch(body_color)
		if("brown")
			icon = 'icons/mob/simple_animal/chicken_brown.dmi'
		if("black")
			icon = 'icons/mob/simple_animal/chicken_black.dmi'
		else
			icon = 'icons/mob/simple_animal/chicken_white.dmi'
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)
	chicken_count += 1

/mob/living/simple_animal/chicken/death(gibbed, deathmessage, show_dead_message)
	..(gibbed, deathmessage, show_dead_message)
	chicken_count -= 1

/mob/living/simple_animal/chicken/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/chems/food/grown)) //feedin' dem chickens
		var/obj/item/chems/food/grown/G = O
		if(G.seed && G.seed.kitchen_tag == "wheat")
			if(!stat && eggsleft < 8)
				user.visible_message("<span class='notice'>[user] feeds [O] to [name]! It clucks happily.</span>","<span class='notice'>You feed [O] to [name]! It clucks happily.</span>")
				qdel(O)
				eggsleft += rand(1, 4)
			else
				to_chat(user, "<span class='notice'>[name] doesn't seem hungry!</span>")
		else
			to_chat(user, "[name] doesn't seem interested in that.")
	else
		..()

/mob/living/simple_animal/chicken/Life()
	. = ..()
	if(!.)
		return FALSE
	if(prob(3) && eggsleft > 0)
		visible_message("[src] [pick("lays an egg.","squats down and croons.","begins making a huge racket.","begins clucking raucously.")]")
		eggsleft--
		var/obj/item/chems/food/egg/E = new(get_turf(src))
		E.pixel_x = rand(-6,6)
		E.pixel_y = rand(-6,6)
		if(chicken_count < MAX_CHICKENS && prob(10))
			E.amount_grown = 1
			START_PROCESSING(SSobj, E)

/obj/item/chems/food/egg
	var/amount_grown = 0

/obj/item/chems/food/egg/Destroy()
	if(amount_grown)
		STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/chems/food/egg/Process()
	if(isturf(loc))
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			visible_message("[src] hatches with a quiet cracking sound.")
			new /mob/living/simple_animal/chick(get_turf(src))
			STOP_PROCESSING(SSobj, src)
			qdel(src)
	else
		return PROCESS_KILL
