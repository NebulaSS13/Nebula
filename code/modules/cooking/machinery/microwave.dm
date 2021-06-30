/obj/machinery/microwave
	name = "microwave"
	desc = "A Getmore-brand microwave. It's seen better days. Below the oven door, a faded label warns to keep non-food items out, and to beware of choking."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mw"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 2000
	atom_flags = ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_NO_REACT
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	var/operating = FALSE // Is it on?
	var/dirty = 0 // = {0..100} Does it need cleaning?
	var/broken = 0 // ={0,1,2} How broken is it???
	var/list/insertable = list(
		/obj/item/chems/food/snacks,
		/obj/item/holder,
		/obj/item/paper,
		/obj/item/flame/candle,
		/obj/item/stack/material/rods,
		/obj/item/organ/internal/brain
		)
	var/global/max_n_of_items = 20
	var/list/acceptable_containers = list(
		/obj/item/chems/glass,
		/obj/item/chems/food/drinks,
		/obj/item/chems/food/condiment
	)
	var/appliancetype = MICROWAVE
	var/tmp/datum/composite_sound/microwave/soundloop
	var/decl/recipe/recipe

	// These determine if the current cooking process failed, the vars above determine if the microwave is broken
	var/cook_break = FALSE
	var/cook_dirty = FALSE
	var/abort = FALSE
	var/failed = FALSE // pretty much exclusively for sending the fail state across to the UI, using recipe elsewhere is preferred

	var/cook_time = 400
	var/start_time = 0
	var/end_time = 0
	var/cooking_power = 1

/*******************
*   Initialising
********************/

/obj/machinery/microwave/Initialize(mapload)
	. = ..(mapload, 0)
	create_reagents(100)
	soundloop = new(list(src), FALSE)

	RefreshParts()

/*******************
*   Item Adding
********************/

/obj/machinery/microwave/proc/add_item(var/obj/item/W as obj, var/mob/user as mob)
	W.forceMove(src)
	user.visible_message( \
		SPAN_NOTICE("\The [user] has added one of [W] to \the [src]."), \
		SPAN_NOTICE("You add one of [W] to \the [src]."))
	SSnano.update_uis(src)

/obj/machinery/microwave/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(broken > 0)
		if(broken == 2 && isScrewdriver(O)) // If it's broken and they're using a screwdriver
			user.visible_message( \
				SPAN_NOTICE("\The [user] starts to fix part of the microwave."), \
				SPAN_NOTICE("You start to fix part of the microwave.") \
			)
			if (do_after(user, 2 SECONDS))
				user.visible_message( \
					SPAN_NOTICE("\The [user] fixes part of the microwave."), \
					SPAN_NOTICE("You have fixed part of the microwave.") \
				)
				broken = 1 // Fix it a bit
		else if(broken == 1 && isWrench(O)) // If it's broken and they're doing the wrench
			user.visible_message( \
				SPAN_NOTICE("\The [user] starts to fix part of the microwave."), \
				SPAN_NOTICE("You start to fix part of the microwave.") \
			)
			if (do_after(user, 2 SECONDS))
				user.visible_message( \
					SPAN_NOTICE("\The [user] fixes the microwave."), \
					SPAN_NOTICE("You have fixed the microwave.") \
				)
				icon_state = "mw"
				broken = 0 // Fix it!
				dirty = 0 // just to be sure
				atom_flags |= ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_NO_REACT
		else
			to_chat(user, SPAN_WARNING("It's broken!"))
			return TRUE
	if(component_attackby(I, user))
		return TRUE
	if(dirty >= 100) // The microwave is all dirty so can't be used!
		if(istype(O, /obj/item/chems/spray/cleaner) || istype(O, /obj/item/soap) || istype(O, /obj/item/chems/glass/rag)) // If they're trying to clean it then let them
			user.visible_message( \
				SPAN_NOTICE("\The [user] starts to clean the microwave."), \
				SPAN_NOTICE("You start to clean the microwave.") \
			)
			if (do_after(user, 2 SECONDS))
				user.visible_message( \
					SPAN_NOTICE("\The [user] has cleaned the microwave."), \
					SPAN_NOTICE("You have cleaned the microwave.") \
				)
				dirty = 0 // It's clean!
				broken = 0 // just to be sure
				icon_state = "mw"
				atom_flags |= ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_NO_REACT
		else //Otherwise bad luck!!
			to_chat(user, SPAN_WARNING("It's dirty!"))
			return TRUE
		return TRUE
	else if(is_type_in_list(O, acceptable_containers))
		if (!O.reagents)
			return TRUE
		return // Note to the future: reagents are added after this in the container's afterattack().
	else if(istype(O,/obj/item/grab))
		var/obj/item/grab/G = O
		to_chat(user, SPAN_WARNING("This is ridiculous. You can not fit \the [G.affecting] in this [src]."))
		return 1
	else
		if (length(get_contained_external_atoms())>=max_n_of_items)
			to_chat(user, SPAN_WARNING("[src] is full of ingredients, you can't fit any more!"))
			return 1
		if(istype(O, /obj/item/stack))
			var/obj/item/stack/S = O
			if(S.get_amount() > 1)
				new O.type (src)
				S.use(1)
				user.visible_message( \
					SPAN_NOTICE("\The [user] adds \the [O] to \the [src]."), \
					SPAN_NOTICE("You add one of [O] to \the [src]."))
				SSnano.update_uis(src)
				return
			else
				add_item(O, user)
		else
			add_item(O, user)
			return
	. = ..()

/obj/machinery/microwave/AltClick()
	if(!operating)
		cook()

/obj/machinery/microwave/interface_interact(mob/user)
	if(dirty >= 100)
		to_chat(user, SPAN_WARNING("[src] is dirty! You'll need to clean it before using it."))
		return FALSE
	if(broken > 0)
		to_chat(user, SPAN_WARNING("[src] is broken! You'll need to fix it before using it."))
		return FALSE
	ui_interact(user)
	return TRUE

/obj/machinery/microwave/examine(var/mob/user)
	. = ..()
	if(broken > 0)
		to_chat(user, "It's broken!")
	else if(dirty >= 100)
		to_chat(user, "The insides are completely filthy!")
	else if(dirty > 75)
		to_chat(user, "It's covered in stains.")
	else if(dirty > 50)
		to_chat(user, "It's pretty messy.")
	else if(dirty > 25)
		to_chat(user, "It's a bit dirty.")

/*******************
*   Microwave Menu
********************/

/obj/machinery/microwave/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = list()
	data["cooking_items"] = list()
	for(var/obj/O in get_contained_external_atoms())
		data["cooking_items"][O.name]++
	data["cooking_reagents"] = list()
	for(var/decl/material/M in reagents.reagent_volumes)
		data["cooking_reagents"][M.name] = reagents.reagent_volumes[M]
	data["on"] = !!operating
	data["failed"] = failed
	data["start_time"] = start_time
	data["cook_time"] = cook_time
	data["past_half_time"] = REALTIMEOFDAY >= (start_time + cook_time/2)
	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "microwave.tmpl", capitalize(name), 300, 300)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		ui.open()

/***********************************
*   Microwave Menu Handling/Cooking
************************************/

/obj/machinery/microwave/proc/cook()
	cook_break = FALSE
	cook_dirty = FALSE

	if(stat & (NOPOWER|BROKEN))
		return

	if (!reagents.total_volume && !(locate(/obj) in get_contained_external_atoms())) //dry run
		start()
		return

	recipe = select_recipe(src, appliance = appliancetype)

	if (reagents.total_volume && prob(50)) // 50% chance a liquid recipe gets messy
		dirty += Ceiling(reagents.total_volume / 10)

	if (!recipe)
		failed = TRUE
		cook_time = update_cook_time()
		dirty += 5
		if (prob(max(10, dirty*5)))
			// It's dirty enough to mess up the microwave
			cook_dirty = TRUE
		else if (has_extra_item())
			// Something's in the microwave that shouldn't be! Time to break!
			cook_break = TRUE
	else
		failed = FALSE
		cook_time = update_cook_time(round(recipe.time * 2))

	start()

/obj/machinery/microwave/proc/update_cook_time(var/ct = 200)
	return (ct / cooking_power)

/obj/machinery/microwave/proc/finish_cooking()
	if(!recipe)
		return
	var/result = recipe.result
	var/list/cooked_items = list()
	while(recipe)
		cooked_items += recipe.make_food(src)
		recipe = select_recipe(src, appliancetype)
		if (!recipe || (recipe.result != result))
			break

	//Any leftover reagents are divided amongst the foods
	var/total = reagents.total_volume
	for (var/obj/item/chems/food/snacks/S in cooked_items)
		reagents.trans_to_holder(S.reagents, total/cooked_items.len)
		S.cook()
		S.forceMove(loc) // since eject only ejects ingredients!

	eject(message = FALSE) //clear out anything left

	return

/obj/machinery/microwave/Process() // What you see here are the remains of proc/wzhzhzh, 2010 - 2019. RIP.
	if (stat & (NOPOWER|BROKEN))
		stop()
		return

	use_power_oneoff(active_power_usage)

	if(REALTIMEOFDAY > end_time)
		stop()

/obj/machinery/microwave/proc/half_time_process()
	if (stat & (NOPOWER|BROKEN))
		return

	playsound(src, 'sound/machines/click.ogg', 20, 1)

	if(failed)
		visible_message(SPAN_WARNING("\The [src] begins to leak an acrid smoke..."))

	SSnano.update_uis(src)

/obj/machinery/microwave/proc/has_extra_item()
	for (var/obj/O in get_contained_external_atoms())
		if ( \
				!istype(O,/obj/item/chems/food) && \
				!istype(O, /obj/item/grown) \
			)
			return TRUE
	return FALSE

/obj/machinery/microwave/proc/start()
	start_time = REALTIMEOFDAY
	end_time = cook_time + start_time
	operating = TRUE

	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	addtimer(CALLBACK(src, .proc/half_time_process), cook_time / 2)
	visible_message(SPAN_NOTICE("The microwave turns on."), SPAN_NOTICE("You hear a microwave."))

	if(cook_dirty)
		playsound(loc, 'sound/effects/splat.ogg', 50, 1) // Play a splat sound
		icon_state = "mwbloody1" // Make it look dirty!!
	else
		icon_state = "mw1"

	set_light(1, 1.5)
	soundloop.start()
	SSnano.update_uis(src)

/obj/machinery/microwave/proc/stop()
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	after_finish_loop()

	operating = FALSE // Turn it off again aferwards
	if(cook_dirty || cook_break)
		atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER //So you can't add condiments
	if(cook_dirty)
		visible_message(SPAN_WARNING("The insides of the microwave get covered in muck!"))
		dirty = 100 // Make it dirty so it can't be used util cleaned
		icon_state = "mwbloody0" // Make it look dirty too
	else if(cook_break)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(2, global.alldirs, src)
		icon_state = "mwb" // Make it look all busted up and shit
		visible_message(SPAN_WARNING("The microwave sprays out a shower of sparks - it's broken!")) //Let them know they're stupid
		broken = 2 // Make it broken so it can't be used until fixed
	else
		icon_state = "mw"

	cook_dirty = FALSE
	cook_break = FALSE

	if(failed)
		fail()
		failed = FALSE
	else if(!failed && !abort)
		finish_cooking()

	abort = FALSE
	SSnano.update_uis(src)

/obj/machinery/microwave/proc/fail()
	var/obj/item/chems/food/snacks/badrecipe/ffuu = new(src)
	var/amount = 0

	var/list/ingredients = get_contained_external_atoms()

	// Kill + delete mobs in mob holders
	for (var/obj/item/holder/H in ingredients)
		for (var/mob/living/M in H.contents)
			M.death()
			qdel(M)

	for (var/obj/O in ingredients)
		amount++
		if (O.reagents && O.reagents.primary_reagent)
			amount += REAGENT_VOLUME(O.reagents, O.reagents.primary_reagent)
		qdel(O)
	reagents.clear_reagents()
	SSnano.update_uis(src)
	ffuu.reagents.add_reagent(/decl/material/solid/carbon, amount)
	ffuu.reagents.add_reagent(/decl/material/liquid/bromide, amount/10)

	if(!abort)
		visible_message(SPAN_DANGER("\The [src] belches out foul-smelling smoke!"))
		var/datum/effect/effect/system/smoke_spread/bad/smoke = new /datum/effect/effect/system/smoke_spread/bad
		smoke.attach(src)
		smoke.set_up(10, 0, get_turf(src), 300)
		smoke.start()

	return ffuu

/obj/machinery/microwave/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)
	if(dirty >= 100)
		to_chat(usr, SPAN_WARNING("\The [name] is dirty! You'll need to clean it before using it."))
		return TOPIC_NOACTION

	if(broken > 0)
		to_chat(usr, SPAN_WARNING("\The [name] is broken! You'll need to fix it before using it."))
		return TOPIC_NOACTION

	if(operating)
		if(href_list["abort"])
			abort = TRUE
			stop()
		return TOPIC_REFRESH

	if(href_list["cook"])
		cook()
		return TOPIC_REFRESH
	else if(href_list["eject_all"])
		if(length(get_contained_external_atoms()))
			eject(user, TRUE)
			return TOPIC_REFRESH
		return TOPIC_HANDLED
	else if(href_list["ejectr"])
		for (var/material_type in reagents.reagent_volumes)
			var/decl/material/M = GET_DECL(material_type)
			if(M.name == href_list["ejectr"])
				eject_reagent(M, user)
				return TOPIC_REFRESH
	else if(href_list["ejecti"])
		for (var/obj/O in get_contained_external_atoms())
			if(O.name == href_list["ejecti"])
				eject(user, FALSE, O)
				return TOPIC_REFRESH

/obj/machinery/microwave/proc/eject_reagent(var/material_type, var/mob/user)
	var/decl/material/M = GET_DECL(material_type)
	var/obj/item/chems/held_container = user.get_active_hand()
	if(!istype(held_container))
		to_chat(user, SPAN_WARNING("You need to be holding a valid container to empty [M.name]!"))
		return
	if(!reagents.reagent_volumes[material_type])
		SSnano.update_uis(src)
		return // should not happen, must be a UI glitch or href hacking
	var/amount_to_move = min(REAGENTS_FREE_SPACE(held_container.reagents), REAGENT_VOLUME(reagents, material_type))
	if(amount_to_move <= 0)
		to_chat(user, SPAN_WARNING("[held_container] is full!"))
		return
	to_chat(user, SPAN_NOTICE("You empty [amount_to_move] units of [M.name] into [held_container]."))
	reagents.trans_type_to(held_container, material_type, amount_to_move)
	SSnano.update_uis(src)

/obj/machinery/microwave/proc/eject(var/mob/user, var/message = TRUE, var/obj/EJ = null)
	if (EJ)
		EJ.forceMove(loc)
	else
		for (var/atom/movable/A in get_contained_external_atoms())
			A.forceMove(loc)
		if (reagents.total_volume)
			dirty += round(reagents.total_volume / 10)
			reagents.clear_reagents()
		if (user && message)
			to_chat(user, SPAN_NOTICE("You dispose of the microwave contents."))
	SSnano.update_uis(src)

/obj/machinery/microwave/proc/after_finish_loop()
	set_light(0)
	soundloop.stop(src)
	update_icon()

/obj/machinery/microwave/RefreshParts()
	..()
	var/bin_rating = 0 // 2
	var/cap_rating = 0 // 3
	var/las_rating = 0 // 1

	bin_rating = total_component_rating_of_type(/obj/item/stock_parts/matter_bin)
	cap_rating = total_component_rating_of_type(/obj/item/stock_parts/capacitor)
	las_rating = total_component_rating_of_type(/obj/item/stock_parts/micro_laser)

	active_power_usage = initial(active_power_usage) - (cap_rating * 25)
	max_n_of_items = initial(max_n_of_items) + Floor(bin_rating)
	cooking_power = initial(cooking_power) + (las_rating / 3)

