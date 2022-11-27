SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = SS_INIT_MAPPING
	flags = SS_NO_FIRE

	var/list/map_templates =             list()
	var/list/submaps =                   list()
	var/list/map_templates_by_category = list()
	var/list/map_templates_by_type =     list()
	var/list/banned_maps =               list()

	// Listing .dmm filenames in the file at this location will blacklist any templates that include them from being used.
	// Maps must be the full file path to be properly included. ex. "maps/random_ruins/away_sites/example.dmm"
	var/banned_dmm_location = "config/banned_map_paths.json"

	var/decl/overmap_event_handler/overmap_event_handler

/datum/controller/subsystem/mapping/Initialize(timeofday)

	// Load our banned map list, if we have one.
	if(banned_dmm_location && fexists(banned_dmm_location))
		banned_maps = cached_json_decode(safe_file2text(banned_dmm_location))

	// Fetch and track all templates before doing anything that might need one.
	for(var/datum/map_template/MT as anything in get_all_template_instances())
		register_map_template(MT)

	// Populate overmap.
	if(length(global.using_map.overmap_ids))
		for(var/overmap_id in global.using_map.overmap_ids)
			var/overmap_type = global.using_map.overmap_ids[overmap_id] || /datum/overmap
			new overmap_type(overmap_id)
	// This needs to be non-null even if the overmap isn't created for this map.
	overmap_event_handler = GET_DECL(/decl/overmap_event_handler)

	// Build away sites.
	global.using_map.build_away_sites()

	. = ..()

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
	map_templates =             SSmapping.map_templates
	map_templates_by_category = SSmapping.map_templates_by_category
	map_templates_by_type =     SSmapping.map_templates_by_type

/datum/controller/subsystem/mapping/proc/register_map_template(var/datum/map_template/map_template)
	if(!validate_map_template(map_template) || !map_template.preload())
		return FALSE
	map_templates[map_template.name] = map_template
	for(var/temple_cat in map_template.template_categories) // :3
		LAZYINITLIST(map_templates_by_category[temple_cat])
		LAZYSET(map_templates_by_category[temple_cat], map_template.name, map_template)
	return TRUE

/datum/controller/subsystem/mapping/proc/validate_map_template(var/datum/map_template/map_template)
	if(!istype(map_template))
		PRINT_STACK_TRACE("Null or incorrectly typed map template attempted validation.")
		return FALSE
	if(length(banned_maps) && length(map_template.mappaths))
		for(var/mappath in map_template.mappaths)
			if(mappath in banned_maps)
				return FALSE
	if(!isnull(map_templates[map_template.name]))
		PRINT_STACK_TRACE("Duplicate map name '[map_template.name]' on type [map_template.type]!")
		return FALSE
	return TRUE
	
/datum/controller/subsystem/mapping/proc/get_all_template_instances()
	. = list()
	for(var/template_type in subtypesof(/datum/map_template))
		var/datum/map_template/template = template_type
		if(initial(template.template_parent_type) != template_type && initial(template.name))
			. += new template_type(type) // send name as a param to catch people doing illegal ad hoc creation

/datum/controller/subsystem/mapping/proc/get_template(var/template_name)
	return map_templates[template_name]

/datum/controller/subsystem/mapping/proc/get_templates_by_category(var/temple_cat) // :33
	return map_templates_by_category[temple_cat]
