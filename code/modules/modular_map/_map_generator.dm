// This decl is used for general structure for generating mazes/dungeons from a set of premapped templates.
// The actual meat of the generator logic is in map_run.dm.
// Example implementation in maps/modular_maps/debug/_debug.dm or maps/modular_maps/aqueduct/_aqueduct.dm

/decl/modular_map_generator
	abstract_type = /decl/modular_map_generator
	/// Human-readable identifier.
	var/name
	/// A level data type to pass to the new-z proc if needed.
	var/level_data_type = /datum/level_data/empty
	/// Datum type to use for run behavior/data tracking.
	var/map_run_type = /datum/mm_run
	/// Turfs per cell - functionally the grid size of the modular map.
	var/grid_cell_size
	/// Flag to avoid regenerating the template list unnecessarily.
	var/templates_are_setup = FALSE
	/// A list of template types that are available to this map generator.
	var/list/cell_templates
	/// A cache of template instances by their connection category for use in template selection.
	var/list/templates_by_category = list()
	/// A maximum number of templates forming a given path. <= 0 indicates no max.
	var/max_generation = 0 //8
	/// A minimum number of templates forming a given path. <= 0 indicates no max.
	var/min_generation = 0 //5
	/// Bool for placing map markers on each placed cell.
	var/place_debug_markers = TRUE
	/// List of random map datum types to run on the level after generating and applying.
	var/list/post_run_generators
	/// Horizontal gutter for placement on the actual map.
	var/border_x = 8
	/// Vertical gutter for placement on the actual map.
	var/border_y = 8
	// Whether or not the final grid can have trailing connections.
	var/do_trim_trailing_connections = FALSE
	// Number of cells with trailing connections after which to apply the trim multiplier.
	var/trailing_connection_trim_threshold = 1 // 50
	// Amount of cells with trailing connections to prune each run.
	var/trailing_connection_trim_multiplier = 1 // 0.65

	/// Maps without at least one path of this length or more will fail to validate.
	var/min_path_length = 0 //50
	/// Assoc list of template type to cell coordinate to place instead of a random initial template
	var/list/mandatory_templates

/decl/modular_map_generator/proc/validate_template(template_type, datum/map_template/modular/template)
	if(!istype(template))
		PRINT_STACK_TRACE("Map generator [type] has template type [template_type] with no instance on SSmapping.")
		return FALSE
	. = TRUE
	if(!template.connection_flag)
		PRINT_STACK_TRACE("Map generator [type] has template [template.type] with unset connection_flag.")
		. = FALSE
	if(!length(template.cell_connections))
		PRINT_STACK_TRACE("Map generator [type] has template [template.type] with empty cell_connections.")
		. = FALSE

// Separate to Initialize() due to SSmapping dependency.
/decl/modular_map_generator/proc/setup_templates()
	if(templates_are_setup || !SSmapping.initialized)
		return

	// Build our full template list
	var/list/template_instances = list()
	for(var/template_type in cell_templates)
		var/datum/map_template/modular/template = SSmapping.map_templates_by_type[template_type]
		if(validate_template(template_type, template))
			template_instances |= template
			LAZYDISTINCTADD(templates_by_category[num2text(template.connection_flag)], template)
	cell_templates = template_instances

	// Build our mandatory template list.
	for(var/template_type in mandatory_templates)
		if(!ispath(template_type))
			continue
		var/datum/map_template/modular/template = SSmapping.map_templates_by_type[template_type]
		if(validate_template(template_type,template))
			mandatory_templates[template] = mandatory_templates[template_type]
			mandatory_templates -= template_type

	templates_are_setup = TRUE

/decl/modular_map_generator/validate()
	. = ..()
	setup_templates()

	if(!name)
		. += "no name set"
	if(!length(cell_templates))
		. += "no templates to place"
	if(!templates_by_category[num2text(MCF_ROOM)])
		. += "no rooms to place"
	if(!templates_by_category[num2text(MCF_HALL)])
		. += "no hallways to place"
	if(!isnum(grid_cell_size) || grid_cell_size < 0)
		. += "invalid grid cell size ([grid_cell_size || "NULL"])"
	if(!level_data_type)
		. += "no level data type set"

	if(length(mandatory_templates))
		for(var/index in mandatory_templates)
			if(!istype(index, /datum/map_template/modular))
				. += "non-instance or non-typed key in mandatory template list: [index]"
			var/list/coord = mandatory_templates[index]
			if(!islist(coord) || length(coord) < 2 || !isnum(coord[1]) || !isnum(coord[2]))
				. += "invalid or malformed coordinates for [index] in mandatory template list"

	var/list/initial_templates = get_initial_templates()
	if(!length(initial_templates))
		. += "no initial templates returned to get_initial_templates()"

/decl/modular_map_generator/proc/get_initial_template()
	return pick(templates_by_category[num2text(MCF_ROOM)])

/decl/modular_map_generator/proc/get_initial_templates(datum/mm_run/run)
	if(islist(mandatory_templates))
		return mandatory_templates
	var/mx = run?.g_mx || 0
	var/my = run?.g_my || 0
	// Place a random room template at a random central-ish coordinate.
	var/initial_template = get_initial_template()
	var/x = round(rand(mx * 0.3, mx * 0.6))
	var/y = round(rand(my * 0.3, my * 0.6))
	log_debug("Placing random initial template [initial_template] at [x],[y] (map template: [istype(initial_template, /datum/map_template)], modular template: [istype(initial_template, /datum/map_template/modular)])")
	return list((initial_template) = list(x, y))

/decl/modular_map_generator/proc/generate(target_z)

	set waitfor = FALSE

	if(!SSmapping.initialized)
		to_chat(usr, SPAN_WARNING("Please wait until SSmapping initialization so template setup can complete."))
		return TRUE

	setup_templates()

	var/datum/mm_run/run = new map_run_type(
		src,
		floor((world.maxx - (border_x*2)) / grid_cell_size),
		floor((world.maxy - (border_y*2)) / grid_cell_size),
		target_z || world.maxz+1
	)
	if(!run.generate_initial_map())
		return FALSE
	if(!run.perform_map_cleanup())
		return FALSE
	if(!run.finalize_run())
		return FALSE
	return TRUE

