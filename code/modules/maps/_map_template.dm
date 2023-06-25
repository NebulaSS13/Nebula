/datum/map_template
	///Name for differentiating templates
	var/name = "Default Template Name"
	///The width of the template's levels. Size is preloaded from template during template registration.
	var/tmp/width = 0
	///The height of the template's levels. Size is preloaded from template during template registration.
	var/tmp/height = 0
	///The amount of template levels. Size is preloaded from template during template registration.
	var/tmp/tallness = 0
	///Path to the map files to load for this template.
	var/list/mappaths = null
	///Amount of times this template was loaded at runtime.
	var/tmp/loaded = 0 // Times loaded this round
	///Shuttles in this template's levels that need to be initialized with SSshuttle.
	var/list/shuttles_to_initialise = list()
	///Sub-templates to spawn on this template if any. Ruins and sites and etc..
	var/list/subtemplates_to_spawn
	///Percent of chances to end up onto a level from this template by spacewalking between space z-levels.
	var/accessibility_weight = 0
	///Flags for defining special properties of this template.
	var/template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES
	///Will modify tag vars so that duplicate templates are handled properly. May have compatibility issues with legacy maps (esp. with ferry shuttles).
	var/modify_tag_vars = TRUE
	///List of strings to store the templates under for mass retrieval.
	var/list/template_categories
	///If this is equal to current type, the datum is abstract and should not be created.
	var/template_parent_type = /datum/map_template
	///The initial type of level_data to instantiate new z-level with initially. (Is replaced by whatever is in the map file.) If null, will use default.
	var/level_data_type

/datum/map_template/New(var/created_ad_hoc)
	if(created_ad_hoc != SSmapping.type)
		PRINT_STACK_TRACE("Ad hoc map template created ([type])!")

/datum/map_template/proc/preload()
	if(length(mappaths))
		preload_size()
	return TRUE

/datum/map_template/proc/get_spawn_weight()
	return 0

/datum/map_template/proc/get_template_cost()
	return 0

/datum/map_template/proc/get_ruin_tags()
	return 0

/datum/map_template/proc/preload_size()
	var/list/bounds = list(1.#INF, 1.#INF, 1.#INF, -1.#INF, -1.#INF, -1.#INF)
	var/z_offset = 1 // needed to calculate z-bounds correctly
	for (var/mappath in mappaths)
		var/datum/map_load_metadata/M = maploader.load_map(file(mappath), 1, 1, z_offset, cropMap=FALSE, measureOnly=TRUE, no_changeturf=TRUE, clear_contents=(template_flags & TEMPLATE_FLAG_CLEAR_CONTENTS), level_data_type=src.level_data_type)
		if(M)
			extend_bounds_if_needed(bounds, M.bounds)
			z_offset++
		else
			return FALSE
	width = bounds[MAP_MAXX] - bounds[MAP_MINX] + 1
	height = bounds[MAP_MAXY] - bounds[MAP_MINX] + 1
	tallness = bounds[MAP_MAXZ] - bounds[MAP_MINZ] + 1
	return TRUE

/datum/map_template/proc/init_atoms(var/list/atoms)
	if (SSatoms.atom_init_stage == INITIALIZATION_INSSATOMS)
		return // let proper initialisation handle it later

	var/list/turf/turfs = list()
	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/obj/machinery/machines = list()
	var/list/obj/structure/cable/cables = list()

	for(var/atom/A in atoms)
		if(isturf(A))
			turfs += A
		if(istype(A, /obj/structure/cable))
			cables += A
		if(istype(A, /obj/machinery/atmospherics))
			atmos_machines += A
		if(istype(A, /obj/machinery))
			machines += A
		if(istype(A, /obj/abstract/landmark/map_load_mark))
			LAZYADD(subtemplates_to_spawn, A)

	var/notsuspended
	if(!SSmachines.suspended)
		SSmachines.suspend()
		notsuspended = TRUE

	SSatoms.InitializeAtoms() // The atoms should have been getting queued there. This flushes the queue.

	SSmachines.setup_powernets_for_cables(cables)
	SSmachines.setup_atmos_machinery(atmos_machines)
	if(notsuspended)
		SSmachines.wake()

	for (var/obj/machinery/machine as anything in machines)
		machine.power_change()

	for (var/turf/T as anything in turfs)
		if(template_flags & TEMPLATE_FLAG_NO_RUINS)
			T.turf_flags |= TURF_FLAG_NORUINS
		if(template_flags & TEMPLATE_FLAG_NO_RADS)
			qdel(SSradiation.sources_assoc[T])
		if(istype(T,/turf/simulated))
			var/turf/simulated/sim = T
			sim.update_air_properties()

/datum/map_template/proc/pre_init_shuttles()
	. = SSshuttle.block_queue
	SSshuttle.block_queue = TRUE

/datum/map_template/proc/init_shuttles(var/pre_init_state, var/map_hash, var/list/initialized_areas_by_type)
	for (var/shuttle_type in shuttles_to_initialise)
		LAZYSET(SSshuttle.shuttles_to_initialize, shuttle_type, map_hash) // queue up for init.
	if(map_hash)
		SSshuttle.map_hash_to_areas[map_hash] = initialized_areas_by_type
		for(var/area/A in initialized_areas_by_type)
			A.saved_map_hash = map_hash
			events_repository.register(/decl/observ/destroyed, A, src, .proc/cleanup_lateloaded_area)
	SSshuttle.block_queue = pre_init_state
	SSshuttle.clear_init_queue() // We will flush the queue unless there were other blockers, in which case they will do it.

/datum/map_template/proc/cleanup_lateloaded_area(area/destroyed_area)
	events_repository.unregister(/decl/observ/destroyed, destroyed_area, src, .proc/cleanup_lateloaded_area)
	if(destroyed_area.saved_map_hash)
		SSshuttle.map_hash_to_areas[destroyed_area.saved_map_hash] -= destroyed_area

///Handle loading a single map path its bottom left corner starting at x,y,z.
/// Returns a /datum/map_load_metadata if loading was successful.
/// Meant to be overridden for handling extra per-map file processing.
/datum/map_template/proc/load_single_path(var/mappath, var/x, var/y, var/z, var/list/bounds, var/list/initialized_areas_by_type, var/no_changeturf, var/cropMap)
	var/datum/map_load_metadata/M = maploader.load_map(
		dmm_file                  = file(mappath),
		x_offset                  = x,
		y_offset                  = y,
		z_offset                  = z,
		cropMap                   = cropMap,
		no_changeturf             = no_changeturf,
		initialized_areas_by_type = initialized_areas_by_type,
		clear_contents            = (template_flags & TEMPLATE_FLAG_CLEAR_CONTENTS),
		level_data_type           = src.level_data_type
	)
	if(!M)
		PRINT_STACK_TRACE("Template '[src]' failed to load map '[mappath]' at ([x], [y], [z]).")
	else if(bounds)
		extend_bounds_if_needed(bounds, M.bounds)
	return M

///Load the template onto a freshly created z-level.
/// * If centered is TRUE, the template's center will be aligned to the world's center. Otherwise, the template will load at pos 1,1.
/datum/map_template/proc/load_new_z(no_changeturf = TRUE, centered = TRUE)
	//When we're set to centered we're aligning the center of the template to the center of the map
	var/x = max(round((world.maxx - width)  / 2), 1)
	var/y = max(round((world.maxy - height) / 2), 1)
	if(!centered)
		x = 1
		y = 1

	var/list/bounds = list(1.#INF, 1.#INF, 1.#INF, -1.#INF, -1.#INF, -1.#INF)
	var/list/atoms_to_initialise = list()
	var/shuttle_state = pre_init_shuttles()
	var/map_hash = modify_tag_vars && "[sequential_id("map_id")]"
	ASSERT(isnull(global._preloader.current_map_hash)) // Recursive maploading is possible, but not from this block: recursive loads should be triggered in Initialize, from init_atoms below.
	global._preloader.current_map_hash = map_hash

	var/initialized_areas_by_type = list()
	for (var/mappath in mappaths)
		var/datum/map_load_metadata/M = load_single_path(mappath, x, y, world.maxz + 1, bounds, initialized_areas_by_type, no_changeturf, FALSE)
		if (M)
			atoms_to_initialise += M.atoms_to_initialise
		else
			//Abort if loading failed
			global._preloader.current_map_hash = null //Clear current map hash to prevent problems if we load something else later and cause false positives
			CRASH("Failed to load '[src]''s '[mappath]' map file!")

	global._preloader.current_map_hash = null

	//initialize things that are normally initialized after map load
	init_atoms(atoms_to_initialise)
	init_shuttles(shuttle_state, map_hash, initialized_areas_by_type)
	after_load()
	for(var/z_index = bounds[MAP_MINZ] to bounds[MAP_MAXZ])
		var/datum/level_data/level = SSmapping.levels_by_z[z_index]
		level.after_template_load(src)
		if(SSlighting.initialized)
			SSlighting.InitializeZlev(z_index)
	log_game("Z-level [name] loaded at [x],[y],[world.maxz]")
	loaded++

	return WORLD_CENTER_TURF(world.maxz)

/datum/map_template/proc/load(turf/T, centered=FALSE)
	if(centered)
		T = locate(T.x - (round(width/2) - 1), T.y - (round(height/2) - 1), T.z)
	if(!T)
		CRASH("Can't load '[src]' (size: [width]x[height]) onto a null turf! Current world size ([WORLD_SIZE_TO_STRING]).")
	if(!IS_WITHIN_WORLD((T.x + (width - 1)), (T.y + (height - 1))))
		CRASH("Couldn't fit the entire template '[src]' (size: [width]x[height]) between lower left corner ([T.x], [T.y])[centered?"(WORLD CENTER)":""] and upper right corner ([T.x + width], [T.y + height]) in current world size ([WORLD_SIZE_TO_STRING]).")

	var/list/atoms_to_initialise = list()
	var/shuttle_state = pre_init_shuttles()

	var/map_hash = modify_tag_vars && "[sequential_id("map_id")]"
	ASSERT(isnull(global._preloader.current_map_hash))
	global._preloader.current_map_hash = map_hash

	var/initialized_areas_by_type = list()
	for (var/mappath in mappaths)
		var/datum/map_load_metadata/M = load_single_path(mappath, T.x, T.y, T.z, null, initialized_areas_by_type, FALSE, TRUE)
		if (M)
			atoms_to_initialise += M.atoms_to_initialise
		else
			//Abort if loading failed
			global._preloader.current_map_hash = null //Clear current map hash to prevent problems if we load something else later and cause false positives
			CRASH("Failed to load '[src]''s '[mappath]' map file!")

	global._preloader.current_map_hash = null

	//initialize things that are normally initialized after map load
	init_atoms(atoms_to_initialise)
	init_shuttles(shuttle_state, map_hash, initialized_areas_by_type)
	after_load()
	if (SSlighting.initialized)
		SSlighting.InitializeTurfs(atoms_to_initialise)	// Hopefully no turfs get placed on new coords by SSatoms.

	log_game("[name] loaded at at [T.x],[T.y],[T.z]")
	loaded++

	return TRUE

/datum/map_template/proc/after_load()
	for(var/obj/abstract/landmark/map_load_mark/mark as anything in subtemplates_to_spawn)
		subtemplates_to_spawn -= mark
		mark.load_subtemplate()
		if(!QDELETED(mark))
			qdel(mark)
	subtemplates_to_spawn = null

/datum/map_template/proc/extend_bounds_if_needed(var/list/existing_bounds, var/list/new_bounds)
	var/list/bounds_to_combine = existing_bounds
	for (var/min_bound in list(MAP_MINX, MAP_MINY, MAP_MINZ))
		bounds_to_combine[min_bound] = min(existing_bounds[min_bound], new_bounds[min_bound])
	for (var/max_bound in list(MAP_MAXX, MAP_MAXY, MAP_MAXZ))
		bounds_to_combine[max_bound] = max(existing_bounds[max_bound], new_bounds[max_bound])
	return bounds_to_combine

/datum/map_template/proc/get_affected_turfs(turf/T, centered = FALSE)
	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - round(width/2), placement.y - round(height/2), placement.z)
		if(corner)
			placement = corner
	return block(placement, locate(placement.x+width-1, placement.y+height-1, placement.z))

///Returns whether a given map template is generated at runtime. Mainly used by unit tests.
/datum/map_template/proc/is_runtime_generated()
	return FALSE

//for your ever biggening badminnery kevinz000
//? - Cyberboss
/proc/load_new_z_level(var/file, var/name)
	var/datum/map_template/template = new(file, name)
	template.load_new_z()
