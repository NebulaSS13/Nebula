/proc/instantiate_serialized_data(load_z, requestor, list/instance_map, entries_decay_at, entry_decay_weight)

	var/list/nested_instances = list()
	var/list/instanced_areas  = list()
	var/list/created_data     = list()

	LAZYINITLIST(instance_map)

	to_world_log("Finalising load of [length(instance_map)] instance\s for level '[requestor]'.")
	for(var/uid in instance_map)

		var/list/instance_data = instance_map[uid]
		try

			var/raw_load_path = instance_data[nameof(/datum::type)]
			var/load_path = ispath(raw_load_path, /datum) ? raw_load_path : text2path(raw_load_path)
			if(!ispath(load_path, /datum))
				error("[requestor]: attempted to load persistent instance with invalid or non-/datum type '[raw_load_path]'")
				continue

			var/datum/created_instance

			// Instance is a /datum.
			// Just pass the data in and assume the datum type knows what to do with it.
			if(!ispath(load_path, /atom) && ispath(load_path, /datum))
				created_instance = new load_path(instance_data)
				created_data += created_instance
			else
				var/list/spawn_data = instance_data[nameof(/atom/movable::loc)]
				if(spawn_data)

					if(isnull(spawn_data) || length(spawn_data) < 3)
						error("[requestor]: attempted to load persistent instance with malformed loc.")
						continue

					// Instance has a world coordinate.
					if(islist(spawn_data))
						var/turf/spawn_loc = locate(spawn_data[1], spawn_data[2], isnull(load_z) ? spawn_data[3] : load_z)
						if(!istype(spawn_loc))
							error("[requestor]: attempted to load persistent instance but could not find spawn loc.")
							continue
						if(ispath(load_path, /turf))
							if(spawn_loc.type == load_path)
								created_instance = spawn_loc
							else
								created_instance = spawn_loc.ChangeTurf(load_path)

						// TODO: Areas will need bespoke handling for non-subtype-related persistence (blueprint renaming etc).
						else if(ispath(load_path, /area))
							var/area/area = instanced_areas[load_path]
							if(!area)
								area = new load_path(null)
								instanced_areas[load_path] = area
							ChangeArea(spawn_loc, area)

						else if(ispath(load_path, /atom))
							created_instance = new load_path(spawn_loc)
							spawn_loc._contents_were_modified = TRUE // ensure
						else
							error("[requestor]: attempted to instantiate unimplemented path '[load_path]'.")
							continue

					// Instance is inside another instance; implies/requires /atom/movable
					else if(istext(spawn_data))
						if(!ispath(load_path, /atom/movable))
							error("[requestor]: tried to spawn non-movable [load_path] inside an instance.")
							continue
						created_instance = new load_path
						nested_instances[created_instance] = spawn_data

					else
						error("[requestor]: attempted to load persistent instance with malformed loc.")
						continue

				else
					// Should we just go ahead and do this to create atoms in nullspace?
					// Would we ever want to track an atom in nullspace via level persistence?
					error("[requestor]: attempted to load non-/datum persistent instance with no spawn loc.")

			if(istype(created_instance))
				LAZYSET(., uid, created_instance)
				if(isatom(created_instance))
					var/atom/atom = created_instance
					atom.__deserialization_payload = instance_data
					SSatoms.deserialized_atoms[uid] = atom
				if(!isnull(entries_decay_at) && !isnull(entry_decay_weight))
					created_instance.HandlePersistentDecay(entries_decay_at, entry_decay_weight)

		catch(var/exception/E)
			log_error("Exception during persistent instance load - [islist(instance_data) ? json_encode(instance_data) : "no instance data"]: [EXCEPTION_TEXT(E)]")

	// Atoms use SSatoms for this, datums don't go through SSatoms so need to do it here.
	for(var/datum/instance in created_data)
		instance.DeserializePostInit(.)

	// Resolve any loc references to instances.
	for(var/atom/movable/atom as anything in nested_instances)
		var/nested_atom_id = nested_instances[atom]
		var/atom/nested_atom = .[nested_atom_id]
		if(!istype(nested_atom))
			error("[requestor]: could not resolve instance ref [nested_atom_id] to instance.")
			continue
		atom.forceMove(nested_atom)
		nested_atom.contents_were_modified()

	// Now that everything is loaded and placed, clear out anything that should not be present on the turfs we've loaded.
	for(var/uid in SSatoms.deserialized_atoms)
		var/turf/turf = SSatoms.deserialized_atoms[uid]
		if(!istype(turf))
			continue
		for(var/atom/thing in turf)
			if(!thing.simulated)
				continue
			if(!isnull(thing.__deserialization_payload))
				continue
			qdel(thing)

	to_world_log("[requestor] loaded [length(.)] persistent instance\s.")

/proc/apply_serde_message_decay(_message, _age, _decay_weight, _decay_at)
	var/static/list/decayed_chars = list(".",",","-","'","\\","/","\"",":",";")
	if(_age < _decay_at || isnull(_message))
		return _message
	. = ""
	for(var/i = 1 to length(_message))
		var/char = copytext(_message, i, i + 1)
		if(prob(round(_age * _decay_weight)))
			if(prob(99))
				. += pick(decayed_chars)
		else
			. += char
