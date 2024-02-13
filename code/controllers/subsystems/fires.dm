SUBSYSTEM_DEF(fires)
	name = "Fires"
	priority = SS_PRIORITY_FIRES
	wait = 2 SECONDS
	flags = SS_NO_INIT

	var/list/burning_fires = list()
	var/list/processing_fires
	var/list/burning_turfs

/datum/controller/subsystem/fires/stat_entry()
	..("F:[burning_fires.len] T:[burning_turfs.len]")

/datum/controller/subsystem/fires/fire(resumed = 0)

	if(!resumed)
		processing_fires = burning_fires.Copy()
		burning_turfs = list()

	var/atom/current_fire
	while(processing_fires.len)
		current_fire = processing_fires[processing_fires.len]
		processing_fires.len--
		if(QDELETED(current_fire) || current_fire.fire_intensity <= 0)
			continue
		var/fire_product = current_fire.process_fire()
		if(fire_product > 0 && !QDELETED(current_fire) && current_fire.fire_intensity >= FIRE_SPREAD_THRESHOLD)
			var/turf/burning_turf = current_fire.loc
			if(istype(burning_turf))
				burning_turfs[burning_turf] = max(burning_turfs[burning_turf], current_fire.fire_intensity)
		if(MC_TICK_CHECK)
			return

	var/fire_intensity
	var/turf/current_turf
	while(burning_turfs.len)

		current_turf = burning_turfs[burning_turfs.len]
		fire_intensity = burning_turfs[current_turf]
		burning_turfs.len--

		var/initial_spread_prob = fire_intensity * FIRE_TURF_SPREAD_MULTIPLIER * FIRE_SPREAD_CONSTANT
		if(!prob(initial_spread_prob))
			continue

		var/list/spread_to_atoms = current_turf.get_contained_external_atoms()
		for(var/spread_dir in global.cardinal)
			var/turf/spreading = get_step(current_turf, spread_dir)
			if(spreading)
				spread_to_atoms |= spreading
				spread_to_atoms |= spreading.get_contained_external_atoms()

		var/spread_prob = fire_intensity * FIRE_SPREAD_CONSTANT
		var/list/spread_to_turf = list()
		while(length(spread_to_atoms))
			var/atom/spread_to = pick_n_take(spread_to_atoms)
			if(!istype(spread_to) || !spread_to.is_flammable() || spread_to.is_on_fire() || !spread_to.Adjacent(current_turf))
				continue
			if(!prob(spread_prob))
				break
			spread_to.ignite_fire()
			var/turf/spreading_to_turf = get_turf(spread_to)
			if(!burning_turfs[spreading_to_turf])
				spread_to_turf[spreading_to_turf] = TRUE

		for(var/spreading_to_turf in spread_to_turf)
			new /obj/effect/fire/ember(current_turf, spreading_to_turf)

		if(MC_TICK_CHECK)
			return
