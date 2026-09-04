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
	// TODO: add /obj/structure/flora here and in goat/ResolveUnarmedAttack()
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
		body.set_intent(I_FLAG_HELP)
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
	set_extension(src, /datum/extension/milkable/goat)

/mob/living/simple_animal/hostile/goat/ResolveUnarmedAttack(var/atom/A)
	var/was_food = FALSE
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
		return TRUE
	return ..()

/mob/living/simple_animal/cow
	name = "cow"
	desc = "Known for their milk, just don't tip them over."
	icon = 'icons/mob/simple_animal/cow.dmi'
	speak_emote  = list("moos","moos hauntingly")
	ai = /datum/mob_controller/cow
	see_in_dark = 6
	max_health = 50
	butchery_data = /decl/butchery_data/animal/ruminant/cow
	// When cows can accept food items: /obj/item/food/hay
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
	set_extension(src, /datum/extension/milkable)

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
	var/decl/skill/examine_skill = SKILL_BOTANY // for maps that change the default skills, or for alien eggs that need science/medical/anatomy instead
	var/examine_difficulty = SKILL_ADEPT

/mob/living/simple_animal/chick/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(!user.skill_check(examine_skill, examine_difficulty))
		var/decl/skill/examine_skill_decl = GET_DECL(examine_skill)
		. += SPAN_SUBTLE("If you knew more about [lowertext(examine_skill_decl.name)], you could learn additional information about this.")
		return
	switch(amount_grown)
		if(0 to 20)
			. += SPAN_NOTICE("It's still young.")
		if(20 to 40)
			. += SPAN_NOTICE("It's starting to grow in its adult feathers.")
		if(40 to 80)
			. += SPAN_NOTICE("It's grown in almost all its adult feathers.")
		if(80 to 100)
			. += SPAN_NOTICE("It's almost fully grown.")

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
		if(prob(50)) // should take around 4 or 5 minutes to grow up, give or take
			amount_grown += rand(1, 2)
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

/mob/living/simple_animal/fowl/chicken/attackby(var/obj/item/used_item, var/mob/user)
	if(!istype(used_item, /obj/item/food))
		return ..()
	var/obj/item/food/G = used_item //feedin' dem chickens
	if(findtext(G.get_grown_tag(), "wheat")) // includes chopped, crushed, dried etc.
		if(!stat && eggsleft < 4)
			user.visible_message(SPAN_NOTICE("[user] feeds \the [used_item] to \the [src]! It clucks happily."), SPAN_NOTICE("You feed \the [used_item] to \the [src]! It clucks happily."), SPAN_NOTICE("You hear clucking."))
			qdel(used_item)
			eggsleft += rand(1, 2)
		else
			to_chat(user, SPAN_NOTICE("\The [src] doesn't seem hungry!"))
	else
		to_chat(user, "\The [src] doesn't seem interested in that.")
	return TRUE

/mob/living/simple_animal/fowl/chicken/handle_living_non_stasis_processes()
	if((. = ..()) && prob(1) && eggsleft > 0)
		visible_message("[src] [pick("lays an egg.","squats down and croons.","begins making a huge racket.","begins clucking raucously.")]")
		eggsleft--
		var/obj/item/food/egg/E = new(get_turf(src))
		E.pixel_x = rand(-6,6)
		E.pixel_y = rand(-6,6)
		if(chicken_count < MAX_CHICKENS && prob(30))
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
	var/decl/skill/examine_skill = SKILL_BOTANY // for maps that change the default skills, or for alien eggs that need science/medical/anatomy instead
	var/examine_difficulty = SKILL_ADEPT

/obj/item/food/egg/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(isnull(examine_difficulty) || !ispath(examine_skill))
		return
	if(!user.skill_check(examine_skill, examine_difficulty))
		var/decl/skill/examine_skill_decl = GET_DECL(examine_skill)
		. += SPAN_SUBTLE("If you knew more about [lowertext(examine_skill_decl.name)], you could learn additional information about this.")
		return
	if(distance > 1)
		. += SPAN_SUBTLE("You're too far away to learn anything about this.")
		return
	if(!user.get_held_slot_for_item(src))
		. += SPAN_NOTICE("You need to be holding \the [src] to examine it closer.")
		return
	// need a lit candle or lantern to check
	var/too_hot = FALSE
	var/obj/item/candle // not necessarily an actual candle, just a light source that won't fry the egg
	for(var/obj/item/I in user.get_held_items())
		if(I.light_power && I.light_range) // we have a light! todo: minimum power?
			if(I.get_heat() >= /obj/item/flame/fuelled/lighter::lit_heat) // lighters are too hot!
				too_hot = TRUE
			candle = I
			if(!too_hot)
				break
	if(too_hot)
		. += SPAN_WARNING("You can't use \the [candle] to examine \the [src], that would fry it!")
		return
	else if(!candle)
		. += SPAN_NOTICE("You need to be holding a light source to examine this closer.")
		return
	switch(amount_grown)
		if(0)
			. += SPAN_NOTICE("\The [src] is unfertilized.")
		if(10 to 80)
			. += SPAN_NOTICE("There's something growing inside \the [src].")
		if(80 to 100)
			. += SPAN_NOTICE("\The [src] is about to hatch!")

/obj/item/food/egg/Destroy()
	if(amount_grown)
		STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/food/egg/Process()
	if(isturf(loc))
		if(prob(50))
			amount_grown++
		if(amount_grown >= 100)
			visible_message("[src] hatches with a quiet cracking sound.")
			new /mob/living/simple_animal/chick(get_turf(src))
			STOP_PROCESSING(SSobj, src)
			qdel(src)
	else
		return PROCESS_KILL
