SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = SS_INIT_MAPPING
	flags = SS_NO_FIRE

	var/list/map_templates =             list()
	var/list/submaps =                   list()
	var/list/compile_time_map_markers =  list()
	var/list/map_templates_by_category = list()

	var/decl/overmap_event_handler/overmap_event_handler

/datum/controller/subsystem/mapping/Initialize(timeofday)

	// Fetch and track all templates before doing anything that might need one.
	preloadTemplates()

	// Populate overmap.
	if(length(global.using_map.overmap_ids))
		for(var/overmap_id in global.using_map.overmap_ids)
			var/overmap_type = global.using_map.overmap_ids[overmap_id] || /datum/overmap
			new overmap_type(overmap_id)
	// This needs to be non-null even if the overmap isn't created for this map.
	overmap_event_handler = GET_DECL(/decl/overmap_event_handler)

	// Load templates and build away sites.
	for(var/obj/abstract/landmark/map_load_mark/marker as anything in compile_time_map_markers)
		compile_time_map_markers -= marker
		marker.load_template()

	global.using_map.build_away_sites()

	. = ..()

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
	map_templates = SSmapping.map_templates
	map_templates_by_category = SSmapping.map_templates_by_category

/datum/controller/subsystem/mapping/proc/preloadTemplates(path = "maps/templates/") //see master controller setup
	var/list/filelist = flist(path)
	for(var/map in filelist)
		var/datum/map_template/T = new(paths = "[path][map]", rename = "[map]")
		map_templates[T.name] = T
	preloadBlacklistableTemplates()

/datum/controller/subsystem/mapping/proc/includeTemplate(var/datum/map_template/map_template, var/list/banned_maps)
	if(!initial(map_template.id))
		return
	var/datum/map_template/MT = new map_template()
	if(banned_maps)
		for(var/mappath in MT.mappaths)
			if(banned_maps.Find(mappath))
				return
	map_templates[MT.name] = MT
	. = MT

/datum/controller/subsystem/mapping/proc/preloadBlacklistableTemplates()
	// Still supporting bans by filename
	var/list/banned_exoplanet_dmms = generateMapList("config/exoplanet_ruin_blacklist.txt")
	var/list/banned_space_dmms = generateMapList("config/space_ruin_blacklist.txt")
	var/list/banned_away_site_dmms = generateMapList("config/away_site_blacklist.txt")

	if (!banned_exoplanet_dmms || !banned_space_dmms || !banned_away_site_dmms)
		report_progress("One or more map blacklist files are not present in the config directory!")

	var/list/banned_maps = list() + banned_exoplanet_dmms + banned_space_dmms + banned_away_site_dmms

	for(var/item in sortTim(subtypesof(/datum/map_template), /proc/cmp_ruincost_priority))
		var/datum/map_template/MT = includeTemplate(item, banned_maps)
		if(!MT || !length(MT.template_categories))
			continue
		for(var/temple_cat in MT.template_categories) // :3
			LAZYINITLIST(map_templates_by_category[temple_cat])
			LAZYSET(map_templates_by_category[temple_cat], MT.name, MT)

/datum/controller/subsystem/mapping/proc/get_templates_by_category(var/temple_cat) // :33
	return map_templates_by_category[temple_cat]

/datum/controller/subsystem/mapping/proc/get_template_by_type(var/template_type)
	return new template_type // todo: find in cache and return preloaded template
