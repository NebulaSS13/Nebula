/datum/persistence/world_handle
	var/serializer/sql/serializer = new()

/datum/persistence/world_handle/proc/get_default_turf(var/z)
	for(var/default_turf in GLOB.using_map.default_z_turfs)
		if(GLOB.using_map.default_z_turfs[default_turf] == z)
			return default_turf
	return /turf/space

/datum/persistence/world_handle/proc/SaveWorld()
	// Collect the z-levels we're saving and get the turfs!
	to_world_log("Saving [LAZYLEN(SSmapping.saved_levels)] z-levels. World size max ([world.maxx],[world.maxy])")
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
		// This will save all the turfs/world.
		var/index = 1
		for(var/z in SSmapping.saved_levels)
			var/default_turf = get_default_turf(z)
			for(var/x in 1 to world.maxx)
				for(var/y in 1 to world.maxy)
					// Get the thing to serialize and serialize it.
					var/turf/T = locate(x,y,z)
					// This if statement, while complex, checks to see if we should save this turf.
					// Turfs not saved become their default_turf after deserialization.
					if(!T || istype(T, default_turf))
						if(!T.contents || !length(T.contents))
							continue
						var/should_skip = TRUE
						for(var/atom/movable/AM in T.contents)
							if(AM.simulated && AM.should_save)
								should_skip = FALSE
								break // We found a thing that's worth saving.
						if(should_skip)
							continue // Skip this tile. Not worth saving.
					serializer.Serialize(T)

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

		// Save all players.
		for(var/mob/living/T in world)
			serializer.Serialize(T)
			CHECK_TICK
		serializer.Commit()

		// Save multiz levels
		// var/datum/wrapper/multiz/multiz = new()
		// multiz.get_connected_zlevels()
		// serializer.Serialize(multiz)
		// serializer.Commit()

		// // Save overmap data.
		// if(GLOB.using_map.use_overmap)
		// 	var/z = GLOB.using_map.overmap_z
		// 	for(var/x in 1 to GLOB.using_map.overmap_size)
		// 		for(var/y in 1 to GLOB.using_map.overmap_size)
		// 			var/turf/T = locate(x,y,z)
		// 			if(!T)
		// 				continue
		// 			serializer.Serialize(T)
		// 			CHECK_TICK
		// 	serializer.Commit()

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

/datum/persistence/world_handle/proc/LoadWorld()
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
		var/turfs_loaded = 0
		for(var/TKEY in serializer.resolver.things)
			var/datum/persistence/load_cache/thing/T = serializer.resolver.things[TKEY]
			if(!T.x || !T.y || !T.z)
				continue // This isn't a turf. We can skip it.
			serializer.DeserializeDatum(T)
			turfs_loaded++
			CHECK_TICK
		to_world_log("Load complete! Took [(world.timeofday-start)/10]s to load [length(serializer.resolver.things)] things. Loaded [turfs_loaded] turfs.")

		// now for the connected z-level hacks.
		query = dbcon.NewQuery("SELECT `id` FROM `thing` WHERE `type`='[/datum/wrapper/multiz]';")
		query.Execute()
		if(query.NextRow())
			var/datum/wrapper/multiz/z = serializer.QueryAndDeserializeDatum(query.item[1])
			for(var/index in 1 to length(z.saved_z_levels))
				z_levels[index] = z.saved_z_levels[index]

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

/hook/roundstart/proc/retally_all_power()
	for(var/area/A)
		try
			A.retally_power()
			CHECK_TICK
		catch
			continue