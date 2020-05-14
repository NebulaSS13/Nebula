SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = SS_INIT_EARLY
	flags = SS_NO_FIRE

	var/in_loaded_world 	= 	FALSE	// Whether or not we're in a world that was loaded.

	var/list/saved_areas	= 	list()
	var/list/saved_levels 	= 	list()	// Saved levels are saved entirely and optimized with get_default_turf()

	var/serializer/sql/serializer = new() // The serializer impl for actually saving.

/datum/controller/subsystem/persistence/Initialize()
	. = ..()
	saved_levels = GLOB.using_map.saved_levels

/datum/controller/subsystem/persistence/proc/get_default_turf(var/z)
	for(var/default_turf in GLOB.using_map.default_z_turfs)
		if(GLOB.using_map.default_z_turfs[default_turf] == z)
			return default_turf
	return /turf/space

/datum/controller/subsystem/persistence/proc/SaveWorld()
	// Collect the z-levels we're saving and get the turfs!
	to_world_log("Saving [LAZYLEN(SSpersistence.saved_levels)] z-levels. World size max ([world.maxx],[world.maxy])")
	var/start = world.timeofday
	try
		//
		// 	PREPARATION SECTIONS
		//
		var/reallow = 0
		if(config.enter_allowed) reallow = 1
		config.enter_allowed = 0
		// Prepare atmosphere for saving.
		SSair.can_fire = FALSE
		if (SSair.state != SS_IDLE)
			report_progress("ZAS Rebuild initiated. Waiting for current air tick to complete before continuing.")
		while (SSair.state != SS_IDLE)
			stoplag()

		// Prepare all atmospheres to save.
		for(var/datum/pipe_network/net in SSmachines.pipenets)
			for(var/datum/pipeline/line in net.line_members)
				line.temporarily_store_air()
		while (SSair.zones.len)
			var/zone/zone = SSair.zones[SSair.zones.len]
			SSair.zones.len--
			zone.c_invalidate()

		// Wipe the previous save.
		serializer.WipeSave()

		//
		// 	ACTUAL SAVING SECTION
		//
		// This will prepare z_level translations.
		var/list/z_transform = list()
		var/new_z_index = 1
		// First we find the highest non-dynamic z_level.
		for(var/z in GLOB.using_map.station_levels)
			if(z in saved_levels)
				new_z_index = max(new_z_index, z)

		// Now we go through our saved levels and remap all of those.
		for(var/z in saved_levels)
			var/datum/persistence/load_cache/z_level/z_level = new()
			z_level.default_turf = get_default_turf(z)
			z_level.index = z
			if(z in GLOB.using_map.station_levels)
				z_level.dynamic = FALSE
				z_level.new_index = z
			else
				new_z_index++
				z_level.dynamic = TRUE
				z_level.new_index = new_z_index
			z_transform["[z]"] = z_level

		// Go through all of our saved areas and save those, too.
		for(var/area/A in saved_areas)
			for(var/turf/T in A)
				if("[T.z]" in z_transform)
					continue
				// Turf exists in an area outside of saved_levels.
				// In this case, we'll remap.
				var/datum/persistence/load_cache/z_level/z_level = new()
				z_level.default_turf = get_default_turf(T.z)
				z_level.index = T.z
				z_level.dynamic = TRUE
				if("[T.z]" in map_sectors)
					var/obj/effect/overmap = map_sectors["[T.z]"]
					z_level.metadata = "[overmap.x],[overmap.y]"
				new_z_index++
				z_level.new_index = new_z_index
				z_transform["[T.z]"] = z_level

		// Now to go through for all *characters*. Characters are annoying because they could be anywhere.
		new_z_index++
		var/lost_character_z = new_z_index // Special z_level for lost bois.
		for(var/mob/living in world)
			if(!living.z) // TODO: Fix this. Some mobs are allowed to be in nullspace. Like stackmobs.
				continue
			if(!living.ckey)
				continue // Not a player character
			if("[living.z]" in z_transform)
				continue // Not a lost boi.
			// Lost boi.
			var/datum/persistence/load_cache/z_level/z_level = new()
			z_level.dynamic = TRUE
			z_level.index = living.z
			z_level.new_index = lost_character_z
			z_level.default_turf = /turf/space
			z_transform["[living.z]"] = z_level

		// Now we rebuild our z_level metadata list into the serializer for it to remap everything for us.
		for(var/z in z_transform)
			var/datum/persistence/load_cache/z_level/z_level = z_transform[z]
			serializer.z_map["[z_level.index]"] = z_level.new_index
		serializer.z_index = new_z_index

		// This will save all the turfs/world.
		var/index = 1
		for(var/z in saved_levels)
			var/default_turf = get_default_turf(z)
			for(var/x in 1 to world.maxx)
				for(var/y in 1 to world.maxy)
					// Get the thing to serialize and serialize it.
					var/turf/T = locate(x,y,z)
					// This if statement, while complex, checks to see if we should save this turf.
					// Turfs not saved become their default_turf after deserialization.
					if(!istype(T) || istype(T, default_turf))
						if(!istype(T) || !T.contents || !length(T.contents))
							continue
						var/should_skip = TRUE
						for(var/atom/movable/AM in T.contents)
							if(AM.simulated && AM.should_save)
								should_skip = FALSE
								break // We found a thing that's worth saving.
						if(should_skip)
							continue // Skip this tile. Not worth saving.
					serializer.Serialize(T, null, z)

					// Don't save every single tile.
					// Batch them up to save time.
					if(index % 128 == 0)
						serializer.Commit()
						index = 1
					else
						index++

					// Prevent the whole game from locking up.
					CHECK_TICK
			serializer.Commit() // cleanup leftovers.

		// Insert our z-level remaps.
		var/list/z_inserts = list()
		var/z_insert_index = 1
		for(var/z in z_transform)
			var/datum/persistence/load_cache/z_level/z_level = z_transform[z]
			z_inserts += "([z_insert_index],[z_level.new_index],[z_level.dynamic],'[z_level.default_turf]','[z_level.metadata]')"
			z_insert_index++
		var/DBQuery/query = dbcon.NewQuery("INSERT INTO `z_level` (`id`,`z`,`dynamic`,`default_turf`,`metadata`) VALUES[jointext(z_inserts, ",")]")
		query.Execute()
		if(query.ErrorMsg())
			to_world_log("Z_LEVEL SERIALIZATION FAILED: [query.ErrorMsg()].")

		// Save all players.
		for(var/mob/living/T in world)
			serializer.Serialize(T)
			CHECK_TICK
		serializer.Commit()

		//
		//	CLEANUP SECTION
		//
		// Clear the refmaps/do other cleanup to end the save.
		serializer.Clear()
		// Reboot air subsystem.
		SSair.reboot()
		// Let people back in
		if(reallow) config.enter_allowed = 1
	catch (var/exception/e)
		to_world_log("Save failed on line [e.line], file [e.file] with message: '[e]'.")
	to_world("Save complete! Took [(world.timeofday-start)/10]s to save world.")

/datum/controller/subsystem/persistence/proc/LoadWorld()
	try
		// Loads all data in as part of a version.
		establish_db_connection()
		if(!dbcon.IsConnected())
			return

		var/DBQuery/query = dbcon.NewQuery("SELECT COUNT(*) FROM `thing`;")
		query.Execute()
		if(query.NextRow())
			// total_entries = text2num(query.item[1])
			to_world_log("Loading [query.item[1]] things from world save.")

		// We start by loading the cache. This will load everything from SQL into an object structure
		// and is much faster than live-querying for information.
		serializer.resolver.load_cache()

		// Begin deserializing the world.
		var/start = world.timeofday

		// Start with rebuilding the z-levels.
		//var/last_index = world.maxz
		for(var/datum/persistence/load_cache/z_level/z_level in serializer.resolver.z_levels)
			if(z_level.dynamic)
				INCREMENT_WORLD_Z_SIZE
				z_level.new_index = world.maxz
				if(z_level.default_turf && !ispath(z_level.default_turf, /turf/space))
					for(var/turf/T in block(locate(1, 1, z_level.new_index), locate(world.maxx, world.maxy, z_level.new_index)))
						T.ChangeTurf(z_level.default_turf)
			else
				z_level.new_index = z_level.index
			to_world_log("Mapping Save Z ([z_level.index]) to World Z ([z_level.new_index])")
			serializer.z_map["[z_level.index]"] = z_level.new_index
		to_world_log("Z-Levels loaded!")

		// This is a sort-of hack. We're going to go back and edit all of the thing_references to their new Z from the z_levels we just modified.
		for(var/thing_id in serializer.resolver.things)
			var/datum/persistence/load_cache/thing/thing = serializer.resolver.things[thing_id]
			thing.z = serializer.z_map["[thing.z]"]
		to_world_log("Dynamic z-levels populated!")

		// Now we're going to load the actual data from the save.
		var/turfs_loaded = 0
		for(var/TKEY in serializer.resolver.things)
			var/datum/persistence/load_cache/thing/T = serializer.resolver.things[TKEY]
			if(!T.x || !T.y || !T.z)
				continue // This isn't a turf. We can skip it.
			serializer.DeserializeDatum(T)
			turfs_loaded++
			CHECK_TICK
		to_world_log("Load complete! Took [(world.timeofday-start)/10]s to load [length(serializer.resolver.things)] things. Loaded [turfs_loaded] turfs.")

		// Cleanup the cache. It uses a *lot* of memory.
		for(var/id in serializer.reverse_map)
			var/datum/T = serializer.reverse_map[id]
			T.after_deserialize()
		for(var/id in serializer.reverse_list_map)
			var/list/_list = serializer.reverse_list_map[id]
			for(var/element in _list)
				var/datum/T = element
				if(istype(T, /datum))
					T.after_deserialize()
				try
					var/datum/TE = _list[element]
					if(istype(TE, /datum))
						TE.after_deserialize()
				catch // Ignore/eat error. This is just testing for dicts.

		serializer.resolver.clear_cache()
		serializer.Clear()

		// Tell the atoms subsystem to not populate parts.
		if(turfs_loaded)
			SSatoms.adjust_init_arguments = TRUE
	catch(var/exception/e)
		to_world_log("Load failed on line [e.line], file [e.file] with message: '[e]'.")

/datum/controller/subsystem/persistence/proc/RegisterLevel(var/z)


/hook/roundstart/proc/retally_all_power()
	for(var/area/A)
		try
			A.retally_power()
			CHECK_TICK
		catch
			continue