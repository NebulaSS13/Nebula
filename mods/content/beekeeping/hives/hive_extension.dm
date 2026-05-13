/datum/extension/insect_hive
	base_type = /datum/extension/insect_hive
	expected_type = /obj/structure
	flags = EXTENSION_FLAG_IMMEDIATE
	/// The species of insect that made this hive.
	var/decl/insect_species/holding_species
	/// References to our current swarm effects gathering for the hive.
	var/list/swarms
	var/current_health = 100
	var/material = 10
	var/raw_reserves = 0
	/// Tracker for the last world.time that a frame was removed.
	var/frame_last_removed = 0
	/// Tracker for time that smoke will wear off.
	var/smoked_until = 0

/datum/extension/insect_hive/New(datum/holder, _species_decl)
	..()
	holding_species = istype(_species_decl, /decl/insect_species) ? _species_decl : GET_DECL(_species_decl)
	if(!istype(holding_species))
		CRASH("Insect hive extension instantiated with invalid insect species: '[_species_decl]'.")
	START_PROCESSING(SSprocessing, src)

/datum/extension/insect_hive/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	if(length(swarms))
		for(var/obj/effect/insect_swarm/swarm as anything in swarms)
			swarm.owner = null
		swarms = null
	var/atom/movable/hive = holder
	if(istype(hive) && !QDELETED(hive))
		hive.queue_icon_update()
	return ..()

/datum/extension/insect_hive/Process()
	if(world.time < smoked_until)
		return
	holding_species.process_hive(src)
	create_hive_products()

/datum/extension/insect_hive/proc/handle_item_interaction(mob/user, obj/item/item)
	return FALSE

/datum/extension/insect_hive/proc/drop_nest(atom/drop_loc)
	if(!isatom(drop_loc))
		return
	// handle some kind of physical hive dropping here
	remove_extension(holder, /datum/extension/insect_hive)
	if(!QDELETED(src))
		qdel(src)

/datum/extension/insect_hive/proc/get_nest_condition()
	switch(current_health)
		if(0, 10)
			return "dying"
		if(10, 30)
			return "struggling"
		if(30, 60)
			return "sickly"
		if(60, 90)
			return null
	return "thriving"

/datum/extension/insect_hive/proc/get_nest_name()
	return holding_species?.nest_name

/datum/extension/insect_hive/proc/examined(mob/user, show_detail)
	var/nest_descriptor = get_nest_condition()
	if(nest_descriptor)
		to_chat(user, SPAN_NOTICE("It contains \a [nest_descriptor] [get_nest_name()]."))
	else
		to_chat(user, SPAN_NOTICE("It contains \a [get_nest_name()]."))

/datum/extension/insect_hive/proc/frame_removed(obj/item/frame)
	frame_last_removed = world.time
	if(world.time >= smoked_until && length(swarms) > 0)
		if(isatom(holder))
			var/atom/hive = holder
			hive.visible_message(SPAN_DANGER("The buzzing from \the [holder] intensifies."))
		for(var/obj/effect/insect_swarm/swarm as anything in swarms)
			swarm.swarm_agitation = min(100, swarm.swarm_agitation + SWARM_AGITATION_PER_FRAME)

/datum/extension/insect_hive/proc/try_hand_harvest(mob/user, obj/item/structure)
	if(istype(structure) && !structure.storage)
		var/obj/item/hive_frame/frame = locate() in structure
		if(frame)
			frame.dropInto(get_turf(structure))
			if(istype(user))
				user.put_in_hands(frame)
			return TRUE
	return FALSE

/datum/extension/insect_hive/proc/try_tool_harvest(mob/user, obj/item/tool)
	return FALSE

/datum/extension/insect_hive/proc/swarm_destroyed(obj/effect/insect_swarm/swarm)
	return

/datum/extension/insect_hive/proc/swarm_at_hive()
	for(var/atom/movable/swarm as anything in swarms)
		if(get_turf(swarm) == get_turf(holder))
			return swarm

/datum/extension/insect_hive/proc/has_material(amt)
	return amt <= material

/datum/extension/insect_hive/proc/consume_material(amt)
	if(has_material(amt))
		material = clamp(material-amt, 0, 100)
		return TRUE
	return FALSE

/datum/extension/insect_hive/proc/add_material(amt)
	material = clamp(material+amt, 0, 100)
	return TRUE

/datum/extension/insect_hive/proc/add_reserves(amt)
	raw_reserves = clamp(raw_reserves+amt, 0, 100)
	return TRUE

/datum/extension/insect_hive/proc/has_reserves(amt, raw_reserves_only = TRUE)
	if(raw_reserves >= amt)
		return TRUE
	if(raw_reserves_only)
		return FALSE
	var/reserve = 0
	for(var/obj/item/frame in holder)
		reserve += REAGENT_TOTAL_VOLUME(frame.reagents)
		if(reserve >= amt)
			return TRUE
	return FALSE

/datum/extension/insect_hive/proc/consume_reserves(amt, raw_reserves_only = TRUE)
	if(!has_reserves(amt, raw_reserves_only))
		return FALSE
	if(raw_reserves >= amt)
		raw_reserves -= amt
		return TRUE
	if(raw_reserves_only)
		return FALSE
	amt -= raw_reserves
	raw_reserves = 0
	for(var/obj/item/frame in holder)
		if(!REAGENT_TOTAL_VOLUME(frame.reagents))
			continue
		var/consume = min(amt, REAGENT_TOTAL_VOLUME(frame.reagents))
		frame.reagents.remove_any(consume)
		amt -= consume
		if(amt <= 0)
			return TRUE
	return FALSE

/datum/extension/insect_hive/proc/adjust_health(amt)
	current_health = clamp(current_health + amt, 0, 100)
	if(current_health <= 0)
		var/atom/movable/hive = holder
		hive.visible_message(SPAN_DANGER("\The [holding_species.nest_name] sags and collapses."))
		remove_extension(holder, base_type)

/datum/extension/insect_hive/proc/create_hive_products()

	var/atom/movable/hive = holder
	if(!istype(hive) || !holding_species)
		return TRUE

	if(!swarm_at_hive()) // nobody home to do the work
		return TRUE

	// Naturally build up enough material for a new frame (or repairs).
	if(!has_material(FRAME_MATERIAL_COST))
		add_material(1)

	// Damaged hives cannot produce combs or honey.
	if(current_health < 100)
		if(consume_material(HIVE_REPAIR_MATERIAL_COST))
			adjust_health(rand(3,5))
		return TRUE

	if(!has_reserves(FRAME_RESERVE_COST))
		return TRUE

	var/list/holder_contents = hive.get_contained_external_atoms()
	for(var/obj/item/hive_frame/frame in holder_contents)
		if(!frame.reagents || (REAGENT_TOTAL_VOLUME(frame.reagents) >= REAGENT_MAXIMUM_VOLUME(frame.reagents)))
			continue
		var/fill_cost = REAGENTS_FREE_SPACE(frame.reagents)
		if(has_material(FRAME_FILL_MATERIAL_COST) && has_reserves(fill_cost))
			consume_material(FRAME_FILL_MATERIAL_COST)
			consume_reserves(fill_cost)
			holding_species.fill_hive_frame(frame)
			return TRUE

	var/obj/item/native_frame = holding_species.native_frame_type
	var/native_frame_size = initial(native_frame.w_class)
	var/space_left = hive.storage.max_storage_space
	for(var/obj/item/thing in hive.get_stored_inventory())
		space_left -= thing.w_class
		if(space_left < native_frame_size)
			return

	// Put a timer check on this to avoid a hive filling up with combs the moment you take 2 frames out.
	if(world.time > (frame_last_removed + 2 MINUTES) && space_left >= native_frame_size && consume_material(FRAME_MATERIAL_COST))
		// Frames start empty, and will be filled next run.
		// Native 'frames' (combs) are bigger than crafted ones and aren't reusable.
		new native_frame(holder, holding_species.produce_material)
		hive.storage.update_ui_after_item_insertion()

/datum/extension/insect_hive/proc/get_total_swarm_intensity()
	. = 0
	for(var/obj/effect/insect_swarm/swarm as anything in swarms)
		. += swarm.swarm_intensity

/datum/extension/insect_hive/proc/smoked_by(mob/user, atom/source, smoke_time = 1 MINUTE)
	smoked_until = max(smoked_until, world.time + smoke_time)
	// this is a little weird due to telekinetic bee smoking but so it goes
	for(var/obj/effect/insect_swarm/swarm as anything in swarms)
		swarm.was_smoked(max(0, smoked_until-world.time))
	return TRUE
