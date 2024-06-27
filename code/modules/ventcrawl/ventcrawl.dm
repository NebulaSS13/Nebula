var/global/list/ventcrawl_machinery = list(
	/obj/machinery/atmospherics/unary/vent_scrubber,
	/obj/machinery/atmospherics/unary/vent_pump
	)

// Vent crawling whitelisted items, whoo
/mob/living/var/list/can_enter_vent_with = list(
	/mob,
	/obj/item/implant,
	/obj/item/radio/borg,
	/obj/item/holder,
	/obj/machinery/camera,
	/obj/item/paper
	)

/mob/living
	var/list/image/pipes_shown
	var/is_ventcrawling = FALSE
	var/next_play_vent = 0

/mob/living/proc/can_ventcrawl()
	if(!client)
		return FALSE
	if(!(/mob/living/proc/ventcrawl in verbs))
		to_chat(src, SPAN_WARNING("You don't possess the ability to ventcrawl!"))
		return FALSE
	if(incapacitated())
		to_chat(src, SPAN_WARNING("You cannot ventcrawl in your current state!"))
		return FALSE
	return ventcrawl_carry()

/mob/living/proc/is_allowed_vent_crawl_item(var/obj/item/carried_item)
	if(is_type_in_list(carried_item, can_enter_vent_with) && !get_equipped_slot_for_item(carried_item))
		return TRUE
	return (carried_item in get_internal_organs())

/mob/living/human/is_allowed_vent_crawl_item(var/obj/item/carried_item)
	var/obj/item/organ/internal/stomach = GET_INTERNAL_ORGAN(src, BP_STOMACH)
	if(stomach && (carried_item in stomach.contents))
		return TRUE
	if(carried_item in get_external_organs())
		return TRUE
	var/slot = get_equipped_slot_for_item(carried_item)
	var/static/allowed_inventory_slots = list(slot_w_uniform_str, slot_gloves_str, slot_glasses_str, slot_wear_mask_str, slot_l_ear_str, slot_r_ear_str, slot_belt_str, slot_l_store_str, slot_r_store_str)
	if(slot in allowed_inventory_slots)
		return TRUE
	else if (slot || (carried_item in get_held_items()) || (carried_item in worn_underwear))
		return carried_item.w_class <= ITEM_SIZE_NORMAL
	return ..()

/mob/living/proc/ventcrawl_carry()
	for(var/atom/A in contents)
		if(!is_allowed_vent_crawl_item(A))
			to_chat(src, SPAN_WARNING("You can't carry \the [A] while ventcrawling!"))
			return FALSE
	return TRUE

/mob/living/AltClickOn(var/atom/A)
	if(is_type_in_list(A,ventcrawl_machinery))
		handle_ventcrawl(A)
		return 1
	return ..()

/mob/proc/start_ventcrawl()
	var/atom/pipe
	var/list/pipes = list()
	for(var/obj/machinery/atmospherics/unary/U in range(1))
		if(is_type_in_list(U,ventcrawl_machinery) && Adjacent(U) && U.can_crawl_through())
			pipes |= U
	if(!pipes || !pipes.len)
		to_chat(src, "There are no pipes that you can ventcrawl into within range!")
		return
	if(pipes.len == 1)
		pipe = pipes[1]
	else
		pipe = input("Crawl Through Vent", "Pick a pipe") as null|anything in pipes
	if(!is_physically_disabled() && pipe)
		return pipe

/mob/living/proc/handle_ventcrawl(var/atom/clicked_on)

	if(!can_ventcrawl())
		return

	var/obj/machinery/atmospherics/unary/vent_found = clicked_on
	if(!istype(vent_found) || !vent_found.can_crawl_through() || !Adjacent(vent_found))
		vent_found = null
		for(var/obj/machinery/atmospherics/unary/machine in range(1,src))
			if(!Adjacent(machine))
				continue
			if(!is_type_in_list(machine, ventcrawl_machinery))
				continue
			if(!machine.can_crawl_through())
				continue
			vent_found = machine
			break

	if(!vent_found)
		to_chat(src, "You must be standing on or beside an air vent to enter it.")
		return

	var/datum/pipe_network/network = vent_found.network_in_dir(vent_found.dir)
	if(!network || (!length(network.normal_members) && !length(network.line_members)))
		to_chat(src, "This vent is not connected to anything.")
		return

	to_chat(src, "You begin climbing into the ventilation system...")
	if(vent_found.air_contents && !issilicon(src))
		switch(vent_found.air_contents.temperature)
			if(0 to BODYTEMP_COLD_DAMAGE_LIMIT)
				to_chat(src, SPAN_DANGER("You feel a painful freeze coming from the vent!"))
			if(BODYTEMP_COLD_DAMAGE_LIMIT to T0C)
				to_chat(src, SPAN_WARNING("You feel an icy chill coming from the vent."))
			if(T0C + 40 to BODYTEMP_HEAT_DAMAGE_LIMIT)
				to_chat(src, SPAN_WARNING("You feel a hot wash coming from the vent."))
			if(BODYTEMP_HEAT_DAMAGE_LIMIT to INFINITY)
				to_chat(src, SPAN_DANGER("You feel a searing heat coming from the vent!"))
		switch(vent_found.air_contents.return_pressure())
			if(0 to HAZARD_LOW_PRESSURE)
				to_chat(src, SPAN_DANGER("You feel a rushing draw pulling you into the vent!"))
			if(HAZARD_LOW_PRESSURE to WARNING_LOW_PRESSURE)
				to_chat(src, SPAN_WARNING("You feel a strong drag pulling you into the vent."))
			if(WARNING_HIGH_PRESSURE to HAZARD_HIGH_PRESSURE)
				to_chat(src, SPAN_WARNING("You feel a strong current pushing you away from the vent."))
			if(HAZARD_HIGH_PRESSURE to INFINITY)
				to_chat(src, SPAN_DANGER("You feel a roaring wind pushing you away from the vent!"))

	if(!do_after(src, 45, vent_found, 1, 1) || !can_ventcrawl())
		return

	visible_message("<B>\The [src] scrambles into the ventilation ducts!</B>", "You climb into the ventilation system.")
	forceMove(vent_found)
	add_ventcrawl(vent_found)

/mob/living/proc/add_ventcrawl(obj/machinery/atmospherics/starting_machine)
	is_ventcrawling = TRUE
	//candrop = 0
	var/datum/pipe_network/network = starting_machine.return_network(starting_machine)
	if(!network)
		return
	for(var/datum/pipeline/pipeline in network.line_members)
		for(var/obj/machinery/atmospherics/A in (pipeline.members || pipeline.edges))
			if(!A.pipe_image)
				A.pipe_image = emissive_overlay(icon = A, loc = A.loc, dir = A.dir)
			LAZYDISTINCTADD(pipes_shown, A.pipe_image)
			client.images += A.pipe_image

/mob/living/proc/remove_ventcrawl()
	is_ventcrawling = FALSE
	if(client)
		for(var/image/current_image in pipes_shown)
			client.images -= current_image
		client.eye = src
	LAZYCLEARLIST(pipes_shown)
