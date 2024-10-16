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
	holding_species.process_hive(src)
	create_hive_products()

/datum/extension/insect_hive/proc/handle_item_interaction(mob/user, obj/item/item)
	return FALSE

/datum/extension/insect_hive/proc/drop_nest(atom/drop_loc)
	return

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

/datum/extension/insect_hive/proc/try_hand_harvest(mob/user)
	return FALSE

/datum/extension/insect_hive/proc/try_tool_harvest(mob/user, obj/item/tool)
	return FALSE

/datum/extension/insect_hive/proc/swarm_destroyed(obj/effect/insect_swarm/swarm)
	LAZYREMOVE(swarms, swarm)

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
		reserve += frame.reagents?.total_volume
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
		if(!frame.reagents?.total_volume)
			continue
		var/consume = min(amt, frame.reagents.total_volume)
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
		return

	if(!swarm_at_hive()) // nobody home to do the work
		return

	// Naturally build up enough material for a new frame (or repairs).
	if(!has_material(20))
		add_material(1)

	// Damaged hives cannot produce combs or honey.
	if(current_health < 100)
		if(consume_material(5))
			adjust_health(rand(3,5))
		return

	if(!has_reserves(20))
		return

	var/list/holder_contents = hive.get_contained_external_atoms()
	for(var/obj/item/hive_frame/frame in holder_contents)
		if(frame.reagents?.total_volume >= frame.reagents?.maximum_volume)
			continue
		var/fill_cost = min(frame.reagents.total_volume, REAGENTS_FREE_SPACE(frame.reagents))
		if(consume_material(5) && consume_reserves(fill_cost))
			holding_species.fill_hive_frame(frame)
			return

	var/obj/item/native_frame = holding_species.native_frame_type
	var/native_frame_size = initial(native_frame.w_class)
	var/space_left = hive.storage.max_storage_space
	for(var/obj/item/thing in hive.get_stored_inventory())
		space_left -= thing.w_class
		if(space_left < native_frame_size)
			return

	// Put a timer check on this to avoid a hive filling up with combs the moment you take 2 frames out.
	if(world.time > (frame_last_removed + 2 MINUTES) && space_left >= native_frame_size && consume_material(20))
		// Frames start empty, and will be filled next run.
		// Native 'frames' (combs) are bigger than crafted ones and aren't reusable.
		new native_frame(holder, holding_species.produce_material)
		hive.storage.update_ui_after_item_insertion()

/datum/extension/insect_hive/proc/get_total_swarm_intensity()
	. = 0
	for(var/obj/effect/insect_swarm/swarm as anything in swarms)
		. += swarm.swarm_intensity
