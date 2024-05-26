///An internal template to generate randomized planet fauna that's adapted to where it was generated to spawn on.
/datum/generated_fauna_template
	var/list/min_gases
	var/list/max_gases
	var/body_temp_low  = T0C
	var/body_temp_high = T0C + 60
	var/body_temp_init = T0C + 30
	var/heat_damage_per_tick
	///The type of mob to spawn
	var/spawn_type

/datum/generated_fauna_template/New(var/fauna_type, var/atmos_temp, var/list/min_gas, var/list/max_gas)
	var/min_body_temp     = atmos_temp - 20
	var/max_body_temp     = atmos_temp + 30
	var/initial_body_temp = (max_body_temp + min_body_temp)/2
	spawn_type     = fauna_type
	min_gases      = min_gas?.Copy()
	max_gases      = max_gas?.Copy()
	body_temp_low  = min_body_temp
	body_temp_high = max_body_temp
	body_temp_init = initial_body_temp

/datum/generated_fauna_template/proc/try_spawn(var/turf/T, var/datum/planetoid_data/P = null)
	var/mob/living/simple_animal/A = new spawn_type(T)
	A.minbodytemp = body_temp_low
	A.maxbodytemp = body_temp_high
	A.bodytemperature = body_temp_init
	A.heat_damage_per_tick = heat_damage_per_tick
	if(A.min_gas)
		A.min_gas = min_gases?.Copy()
	if(A.max_gas)
		A.max_gas = max_gases?.Copy()

	//Need to always fetch the species name, since it can change at any time
	var/overridden_name = LAZYACCESS(P?.fauna?.species_names, spawn_type) //#TODO: Really need some kind of centralized species repo
	if(overridden_name)
		A.fully_replace_character_name(overridden_name)
	else
		A.fully_replace_character_name("alien creature")
		if(isanimal(A))
			A.verbs |= /mob/living/simple_animal/proc/name_species

	for(var/datum/exoplanet_theme/theme in P?.themes)
		theme.adapt_animal(P, A)
	return A

//#TODO: Make some kind of stand-alone fauna manager instead?
/datum/fauna_generator
	///Weighted list of fauna that can possibly spawn.
	var/list/fauna_types
	///Weighted list of megafauna that can possibly spawn.
	var/list/megafauna_types
	///Spawn info cached for each fauna types. Basically a cached entry for each critter that tells us what to change on them after spawn.
	var/list/fauna_templates
	///Spawn info cached for each megafauna types. Basically a cached entry for each critter that tells us what to change on them after spawn.
	var/list/megafauna_templates

	///List of fauna/megafauna types to respawn after they died.
	var/tmp/list/respawn_queue

	///List of fauna refs to those that are alive currently and tied to this generator.
	var/list/live_fauna
	///List of megafauna refs to those that are alive currently and tied to this generator.
	var/list/live_megafauna

	///Maximum amount of live fauna at one time
	var/max_fauna_alive = 10
	///Maximum amount of mega fauna at one time
	var/max_megafauna_alive = 1

	///Amount of animal alive below which we'll try to respawn animals. This value starts at max_alive, and goes down each times we empty the respawn queue by half
	var/repopulate_fauna_threshold
	///Amount of live megafauna below which respawning will occur
	var/repopulate_megafauna_threshold

	///Realtime of day when we last repopulated
	var/tmp/time_last_repop
	///Realtime interval between checks for repopulation
	var/repopulation_interval = 5 MINUTES
	///List of named species for this planet. Handles custom species names that can be attributed to animal via xenobio stuff.
	var/list/species_names //#TODO: move somewhere more sensible? This definitely should be in some repository of some kind, and not on each individual planets?

	///Id of the level we operate on
	var/level_data_id

/datum/fauna_generator/New(var/level_id)
	. = ..()
	level_data_id = level_id
	repopulate_fauna_threshold     = max_fauna_alive
	repopulate_megafauna_threshold = max_megafauna_alive

/datum/fauna_generator/Destroy(force)
	LAZYCLEARLIST(live_fauna)
	. = ..()

/datum/fauna_generator/proc/apply_theme(var/datum/exoplanet_theme/theme)
	LAZYDISTINCTADD(fauna_types,     theme.get_extra_fauna())
	LAZYDISTINCTADD(megafauna_types, theme.get_extra_megafauna())

/datum/fauna_generator/proc/register_fauna(var/mob/living/A)
	if(A in live_fauna)
		return
	events_repository.register(/decl/observ/destroyed, A, src, TYPE_PROC_REF(/datum/fauna_generator, on_fauna_death))
	events_repository.register(/decl/observ/death,     A, src, TYPE_PROC_REF(/datum/fauna_generator, on_fauna_death))
	LAZYADD(live_fauna, A)

/datum/fauna_generator/proc/on_fauna_death(var/mob/living/A)
	unregister_fauna(A)
	LAZYADD(respawn_queue, A.type)

/datum/fauna_generator/proc/unregister_fauna(var/mob/living/A)
	if(!(A in live_fauna))
		return
	events_repository.unregister(/decl/observ/destroyed, A, src, TYPE_PROC_REF(/datum/fauna_generator, on_fauna_death))
	events_repository.unregister(/decl/observ/death,     A, src, TYPE_PROC_REF(/datum/fauna_generator, on_fauna_death))
	LAZYREMOVE(live_fauna, A)

/datum/fauna_generator/proc/generate_fauna(var/datum/gas_mixture/atmosphere, var/list/breath_gases = list(), var/list/toxic_gases = list())
	var/list/generated_gases = generate_breathable_gases(atmosphere, breath_gases, toxic_gases)

	for(var/afauna in fauna_types | megafauna_types)
		if(afauna in fauna_types)
			LAZYSET(fauna_templates, afauna, generate_template(afauna, atmosphere.temperature, generated_gases[1], generated_gases[2]))
		else
			LAZYSET(megafauna_templates, afauna, generate_template(afauna, atmosphere.temperature, generated_gases[1], generated_gases[2]))

/datum/fauna_generator/proc/generate_breathable_gases(var/datum/gas_mixture/atmosphere, var/list/breath_gases, var/list/toxic_gases)
	//Set up gases for living things
	var/list/all_gasses = decls_repository.get_decl_paths_of_subtype(/decl/material/gas)
	if(!length(breath_gases))
		var/list/goodgases = all_gasses.Copy()
		var/gasnum = min(rand(1,3), goodgases.len)
		for(var/i = 1 to gasnum)
			var/gas = pick(goodgases)
			breath_gases[gas] = round(0.4*goodgases[gas], 0.1)
			goodgases -= gas

	if(!length(toxic_gases))
		var/list/badgases = all_gasses.Copy()
		badgases -= atmosphere.gas
		toxic_gases = list(pick(badgases))
	for(var/agas in toxic_gases)
		toxic_gases[agas] = 5

	return list(breath_gases, toxic_gases)

/datum/fauna_generator/proc/generate_template(var/spawn_type, var/atmos_temp, var/list/min_gas, var/list/max_gas)
	return new /datum/generated_fauna_template(spawn_type, atmos_temp, min_gas, max_gas)

/datum/fauna_generator/proc/try_respawn_from_queue()
	. = LAZYACCESS(respawn_queue, 1)
	if(.)
		respawn_queue = respawn_queue.Copy(2) //Clear first entry

/datum/fauna_generator/proc/pick_fauna_to_respawn()
	. = LAZYACCESS(respawn_queue & fauna_types, 1)
	if(.)
		respawn_queue = respawn_queue.Copy(2) //Clear first entry
	else
		//Grab from our fauna list if we don't have anything set to respawn
		. = pickweight(fauna_types)

/datum/fauna_generator/proc/pick_megafauna_to_respawn()
	. = LAZYACCESS(respawn_queue & megafauna_types, 1)
	if(.)
		respawn_queue = respawn_queue.Copy(2) //Clear first entry
	else
		//Grab from our fauna list if we don't have anything set to respawn
		. = pickweight(megafauna_types)

/datum/fauna_generator/proc/try_spawn_fauna(var/turf/T, var/force = FALSE)
	if(!LAZYLEN(fauna_types))
		log_warning("Tried spawning fauna at ([T.x], [T.y], [T.z]) but the fauna_types list is empty!")
		return
	if(!force && LAZYLEN(live_fauna) >= max_fauna_alive)
		return
	var/spawning = pick_fauna_to_respawn()
	var/datum/generated_fauna_template/Tmpl = fauna_templates[spawning]
	var/datum/planetoid_data/P              = SSmapping.planetoid_data_by_z[T.z]
	. = Tmpl.try_spawn(T, P)

	//Add to tracking
	register_fauna(.)

/datum/fauna_generator/proc/try_spawn_megafauna(var/turf/T, var/force = FALSE)
	if(!LAZYLEN(megafauna_types))
		log_warning("Tried spawning megafauna at ([T.x], [T.y], [T.z]) but the megafauna_types list is empty!")
		return
	if(!force && LAZYLEN(live_megafauna) >= max_megafauna_alive)
		return
	var/spawning = pick_megafauna_to_respawn()
	var/datum/generated_fauna_template/Tmpl = megafauna_templates[spawning]
	var/datum/planetoid_data/P              = SSmapping.planetoid_data_by_z[T.z]
	. = Tmpl.try_spawn(T, P)

	//Add to tracking
	register_fauna(.)

//#TODO: move to subsystem/manager
/datum/fauna_generator/Process()
	if(time_last_repop < (time_last_repop + repopulation_interval))
		return //Wait a bit before repopulating
	if(LAZYLEN(respawn_queue) > 0)
		handle_repopulation()

/datum/fauna_generator/proc/handle_repopulation()
	var/datum/level_data/LD = SSmapping.levels_by_id[level_data_id]
	var/area/spawn_area = LD.get_base_area_instance()

	for(var/i = 1 to round(repopulate_megafauna_threshold - length(live_megafauna)))
		if(prob(90))
			continue
		var/turf/T = pick_area_turf(spawn_area, list(/proc/not_turf_contains_dense_objects, /proc/turf_is_simulated))
		try_spawn_megafauna(T)

	for(var/i = 1 to round(repopulate_fauna_threshold - length(live_fauna)))
		if(prob(90))
			continue
		var/turf/T = pick_area_turf(spawn_area, list(/proc/not_turf_contains_dense_objects, /proc/turf_is_simulated))
		try_spawn_fauna(T)

	time_last_repop = REALTIMEOFDAY
	//Half the repop threshold each times we empty the respawn list
	if(LAZYLEN(respawn_queue) <= 0)
		repopulate_megafauna_threshold = round(repopulate_megafauna_threshold / 2)
		repopulate_fauna_threshold     = round(repopulate_fauna_threshold / 2)

//#TOOD: Move this somewhere sensible.
/datum/fauna_generator/proc/rename_species(var/species_type, var/newname, var/force = FALSE)
	if(LAZYACCESS(species_names, species_type) && !force)
		return FALSE
	LAZYSET(species_names, species_type, newname)
	log_and_message_admins("renamed [species_type] to [newname]")
	for(var/mob/living/simple_animal/A in live_fauna)
		if(istype(A, species_type))
			A.fully_replace_character_name(newname)
			A.verbs -= /mob/living/simple_animal/proc/name_species 	//#FIXME: This really should be handled by the animals themselves...
	return TRUE

//#TOOD: Move this somewhere sensible.
/datum/fauna_generator/proc/pick_species_name_prefix()
	return pick(
		"nol",
		"shan",
		"can",
		"fel",
		"xor",
	)

//#TOOD: Move this somewhere sensible.
/datum/fauna_generator/proc/pick_species_name_middle()
	return pick(
		"a",
		"e",
		"o",
		"t",
		"ar",
	)

//#TOOD: Move this somewhere sensible.
/datum/fauna_generator/proc/pick_species_name_suffix()
	return pick(
		"ian",
		"oid",
		"ac",
		"ese",
		"inian",
		"rd",
	)

//#TOOD: Move this somewhere sensible.
/datum/fauna_generator/proc/get_random_species_name()
	return "[pick_species_name_prefix()][pick_species_name_middle()][pick_species_name_suffix()]"