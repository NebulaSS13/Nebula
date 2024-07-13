var/global/datum/map/using_map = new USING_MAP_DATUM
var/global/list/all_maps = list()

var/global/const/MAP_HAS_BRANCH = 1	//Branch system for occupations, togglable
var/global/const/MAP_HAS_RANK = 2		//Rank system, also togglable

/hook/startup/proc/initialise_map_list()
	for(var/type in subtypesof(/datum/map))
		var/datum/map/M
		if(type == global.using_map.type)
			M = global.using_map
			M.setup_map()
		else
			M = new type
		if(!M.path)
			log_error("Map '[M]' ([type]) does not have a defined path, not adding to map list!")
		else
			global.all_maps[M.path] = M
	return 1

/datum/map
	var/name = "Unnamed Map"
	var/full_name = "Unnamed Map"
	var/path

	// TODO: move all the lobby stuff onto this handler.
	var/lobby_handler = /decl/lobby_handler
	var/list/allowed_jobs	       //Job datums to use.
	                               //Works a lot better so if we get to a point where three-ish maps are used
	                               //We don't have to C&P ones that are only common between two of them
	                               //That doesn't mean we have to include them with the rest of the jobs though, especially for map specific ones.
	                               //Also including them lets us override already created jobs, letting us keep the datums to a minimum mostly.
	                               //This is probably a lot longer explanation than it needs to be.

	var/station_name  = "BAD Station"
	var/station_short = "Baddy"
	var/dock_name     = "THE PirateBay"
	var/boss_name     = "Captain Roger"
	var/boss_short    = "Cap'"
	var/company_name  = "BadMan"
	var/company_short = "BM"
	var/system_name = "Uncharted System"
	var/ground_noun = "ground"

	var/default_announcement_frequency = "Common"

	// Current game year. Uses current system year + game_year num.
	var/game_year = 288

	/**
	 * Associative list of network URIs to a list with their display name, color, and "req_access formated" needed access list.
	 * EX: list("BIG_BOSS.COM" = list("name" = "Big boss", "color" = "#00ff00", "access" = list(list(access_heads, access_clown))))
	 */
	var/list/map_admin_faxes

	var/map_tech_level = MAP_TECH_LEVEL_SPACE

	var/shuttle_docked_message
	var/shuttle_leaving_dock
	var/shuttle_called_message
	var/shuttle_recall_message
	var/emergency_shuttle_docked_message
	var/emergency_shuttle_leaving_dock
	var/emergency_shuttle_recall_message

	var/list/holodeck_programs = list() // map of string ids to /datum/holodeck_program instances
	var/list/holodeck_supported_programs = list() // map of maps - first level maps from list-of-programs string id (e.g. "BarPrograms") to another map
												  // this is in order to support multiple holodeck program listings for different holodecks
	                                              // second level maps from program friendly display names ("Picnic Area") to program string ids ("picnicarea")
	                                              // as defined in holodeck_programs
	var/list/holodeck_restricted_programs = list() // as above... but EVIL!
	var/list/holodeck_default_program = list() // map of program list string ids to default program string id
	var/list/holodeck_off_program = list() // as above... but for being off i guess

	var/allowed_latejoin_spawns = list(
		/decl/spawnpoint/arrivals
	)
	var/default_spawn = /decl/spawnpoint/arrivals

	var/flags = 0
	var/evac_controller_type = /datum/evacuation_controller
	var/list/overmap_ids // Assoc list of overmap ID to overmap type, leave empty to disable overmap.

	var/pray_reward_type = /obj/item/chems/food/cookie // What reward should be given by admin when a prayer is received?

	// The list of lobby screen images to pick() from.
	var/list/lobby_screens = list('icons/default_lobby.png')
	var/current_lobby_screen
	// The track that will play in the lobby screen.
	var/decl/music_track/lobby_track
	// The list of lobby tracks to pick() from. If left unset will randomly select among all available /music_track subtypes.
	var/list/lobby_tracks = list()

	// A server logo displayed on the taskbar and top-left part of the window. Leave null for the default DM icon.
	var/window_icon

	// Sounds played on roundstart
	var/list/welcome_sound = 'sound/AI/welcome.ogg'
	// Sounds played with end titles (credits)
	var/list/credit_sound = list('sound/music/THUNDERDOME.ogg', 'sound/music/europa/Chronox_-_03_-_In_Orbit.ogg', 'sound/music/europa/asfarasitgets.ogg')
	// Sounds played on server reboot
	var/list/reboot_sound = list('sound/AI/newroundsexy.ogg','sound/misc/apcdestroyed.ogg','sound/misc/bangindonk.ogg')

	var/default_law_type = /datum/ai_laws/asimov  // The default lawset use by synth units, if not overriden by their laws var.
	var/security_state = /decl/security_state/default // The default security state system to use.

	var/id_hud_icons = 'icons/mob/hud.dmi' // Used by the ID HUD (primarily sechud) overlay.

	var/num_exoplanets = 0
	var/force_exoplanet_type // Used to override exoplanet weighting and always pick the same exoplanet.
	//dimensions of planet zlevels, defaults to world size if smaller, INCREASES world size if larger.
	//Due to how maps are generated, must be (2^n+1) e.g. 17,33,65,129 etc. Map will just round up to those if set to anything other.
	var/list/planet_size = list()
	///The amount of z-levels generated for exoplanets. Default is 1. Be careful with this, since exoplanets are already pretty expensive.
	var/planet_depth = 1
	var/away_site_budget = 0

	var/list/loadout_blacklist	//list of types of loadout items that will not be pickable

	//Economy stuff
	var/starting_money = 75000		       // Money in station account
	var/department_money = 5000		       // Money in department accounts
	var/salary_modifier	= 1			       // Multiplier to starting character money
	var/passport_type = /obj/item/passport // Item type to grant people on join.

	var/list/station_departments = list()//Gets filled automatically depending on jobs allowed

	var/default_species = SPECIES_HUMAN

	var/list/available_cultural_info = list(
		TAG_HOMEWORLD = list(/decl/cultural_info/location/other),
		TAG_FACTION =   list(/decl/cultural_info/faction/other),
		TAG_CULTURE =   list(/decl/cultural_info/culture/other),
		TAG_RELIGION =  list(/decl/cultural_info/religion/other)
	)

	var/list/default_cultural_info = list(
		TAG_HOMEWORLD = /decl/cultural_info/location/other,
		TAG_FACTION =   /decl/cultural_info/faction/other,
		TAG_CULTURE =   /decl/cultural_info/culture/other,
		TAG_RELIGION =  /decl/cultural_info/religion/other
	)

	var/access_modify_region = list(
		ACCESS_REGION_SECURITY = list(access_hos, access_change_ids),
		ACCESS_REGION_MEDBAY = list(access_cmo, access_change_ids),
		ACCESS_REGION_RESEARCH = list(access_rd, access_change_ids),
		ACCESS_REGION_ENGINEERING = list(access_ce, access_change_ids),
		ACCESS_REGION_COMMAND = list(access_change_ids),
		ACCESS_REGION_GENERAL = list(access_change_ids),
		ACCESS_REGION_SUPPLY = list(access_change_ids)
	)
	var/secrets_directory

	/// A list of /decl/loadout_category types which will be available for characters made on this map. Uses all categories if null.
	var/list/decl/loadout_category/loadout_categories

	/// A list of survival box types selectable for this map. If null, defaults to all defined decls. At runtime, this is an associative list of decl type -> decl.
	var/list/decl/survival_box_option/survival_box_choices

	// A list of cash spawn options, similar to above.
	var/list/decl/starting_cash_choice/starting_cash_choices

	/// A reagent used to prefill lanterns.
	var/default_liquid_fuel_type = /decl/material/liquid/fuel

	/// Decl list of backpacks available to outfits and in character generation.
	var/list/_available_backpacks
	var/backpacks_setup = FALSE

/datum/map/proc/get_lobby_track(var/exclude)
	var/lobby_track_type
	if(LAZYLEN(lobby_tracks) == 1)
		lobby_track_type = lobby_tracks[1]
	else if(LAZYLEN(lobby_tracks))
		lobby_track_type = pickweight(lobby_tracks - exclude)
	else
		lobby_track_type = pick(decls_repository.get_decl_paths_of_subtype(/decl/music_track) - exclude)
	return GET_DECL(lobby_track_type)

/datum/map/proc/get_available_backpacks()
	if(!backpacks_setup)
		backpacks_setup = TRUE
		if(length(_available_backpacks))
			for(var/backpack_type in _available_backpacks)
				_available_backpacks[backpack_type] = GET_DECL(backpack_type)
			_available_backpacks[/decl/backpack_outfit/nothing] = GET_DECL(/decl/backpack_outfit/nothing)
		else
			_available_backpacks = decls_repository.get_decls_of_subtype(/decl/backpack_outfit)
	return _available_backpacks

/datum/map/proc/setup_map()

	if(!length(loadout_categories))
		loadout_categories = list()
		for(var/decl_type in decls_repository.get_decls_of_type(/decl/loadout_category))
			loadout_categories += decl_type

	for(var/loadout_category in loadout_categories)
		loadout_categories -= loadout_category
		loadout_categories += GET_DECL(loadout_category)

	if(isnull(survival_box_choices)) // an empty list is a valid option here, a null one is not
		survival_box_choices = decls_repository.get_decls_of_subtype(/decl/survival_box_option)
	else if(length(survival_box_choices))
		survival_box_choices = decls_repository.get_decls(survival_box_choices)

	if(isnull(starting_cash_choices))
		starting_cash_choices = decls_repository.get_decls_of_subtype(/decl/starting_cash_choice)
	else if(length(starting_cash_choices))
		starting_cash_choices = decls_repository.get_decls(starting_cash_choices)

	if(secrets_directory)
		secrets_directory = trim(lowertext(secrets_directory))
		if(!length(secrets_directory))
			log_warning("[type] secrets_directory is zero length after trim.")
		if(copytext(secrets_directory, -1) != "/")
			secrets_directory = "[secrets_directory]/"
		if(!fexists(secrets_directory))
			log_warning("[type] secrets_directory does not exist.")
		SSsecrets.load_directories |= secrets_directory

	if(!allowed_jobs)
		allowed_jobs = list()
		for(var/jtype in subtypesof(/datum/job))
			var/datum/job/job = jtype
			if(initial(job.available_by_default))
				allowed_jobs += jtype

	if(ispath(default_job_type, /datum/job))
		var/datum/job/J = default_job_type
		default_job_title = initial(J.title)

	if(default_spawn && !(default_spawn in allowed_latejoin_spawns))
		PRINT_STACK_TRACE("Map datum [type] has default spawn point [default_spawn] not in the allowed spawn list.")

	for(var/spawn_type in allowed_latejoin_spawns)
		allowed_latejoin_spawns -= spawn_type
		allowed_latejoin_spawns += GET_DECL(spawn_type)

	if(!SSmapping.map_levels)
		SSmapping.map_levels = SSmapping.station_levels.Copy()

	if(!LAZYLEN(planet_size))
		planet_size = list(world.maxx, world.maxy)
	if(planet_depth <= 0)
		planet_depth = 1

	game_year = (text2num(time2text(world.realtime, "YYYY")) + game_year)

	setup_admin_faxes()

	lobby_track = get_lobby_track()
	update_titlescreen()
	world.update_status()

///Generates the default admin faxes addresses
/datum/map/proc/setup_admin_faxes()
	LAZYSET(map_admin_faxes, uppertext(replacetext("[boss_name].COM",          " ", "_")), list("name" = "[boss_name]",           "color" = "#006100", "access" = list(access_heads)))
	LAZYSET(map_admin_faxes, uppertext(replacetext("[boss_short]_SUPPLY.COM",  " ", "_")), list("name" = "[boss_short] Supply",   "color" = "#5f4519", "access" = list(access_heads)))
	LAZYSET(map_admin_faxes, uppertext(replacetext("[system_name]_POLICE.GOV", " ", "_")), list("name" = "[system_name] Police",  "color" = "#1f66a0", "access" = list(access_heads)))

/datum/map/proc/setup_job_lists()

	// Populate blacklists for any default-blacklisted species.
	for(var/decl/species/species as anything in decls_repository.get_decls_of_subtype_unassociated(/decl/species))
		if(!species.job_blacklist_by_default)
			continue
		var/found_whitelisted_job = FALSE
		for(var/datum/job/job as anything in SSjobs.primary_job_datums)
			if((species.type in job_to_species_whitelist[job.type]) || (job.type in species_to_job_whitelist[species.type]))
				found_whitelisted_job = TRUE
			else
				LAZYDISTINCTADD(species_to_job_blacklist[species.type], job.type)
				LAZYDISTINCTADD(job_to_species_blacklist[job.type], species.type)

		// If no jobs are available for the main map, mark the species as unavailable to avoid player confusion.
		if(!found_whitelisted_job && src == global.using_map)
			species.spawn_flags &= ~SPECIES_CAN_JOIN
			species.spawn_flags |=  SPECIES_IS_RESTRICTED

/datum/map/proc/send_welcome()
	return

/datum/map/proc/build_away_sites()
#ifdef UNIT_TEST
	report_progress("Unit testing, so not loading away sites")
	return // don't build away sites during unit testing
#else
	report_progress("Loading away sites...")
	var/list/sites_by_spawn_weight = list()
	var/list/away_sites_templates = SSmapping.get_templates_by_category(MAP_TEMPLATE_CATEGORY_AWAYSITE)
	for (var/site_name in away_sites_templates)
		var/datum/map_template/site = away_sites_templates[site_name]

		if((site.template_flags & TEMPLATE_FLAG_SPAWN_GUARANTEED) && site.load_new_z()) // no check for budget, but guaranteed means guaranteed
			report_progress("Loaded guaranteed away site [site]!")
			away_site_budget -= site.get_template_cost()
			continue

		sites_by_spawn_weight[site] = site.get_spawn_weight()
	while (away_site_budget > 0 && sites_by_spawn_weight.len)
		var/datum/map_template/selected_site = pickweight(sites_by_spawn_weight)
		if (!selected_site)
			break
		sites_by_spawn_weight -= selected_site
		var/site_cost = selected_site.get_template_cost()
		if(site_cost > away_site_budget)
			continue
		if (selected_site.load_new_z())
			report_progress("Loaded away site [selected_site]!")
			away_site_budget -= site_cost

	report_progress("Finished loading away sites, remaining budget [away_site_budget], remaining sites [sites_by_spawn_weight.len]")
#endif

/datum/map/proc/build_planets()
#ifdef UNIT_TEST
	report_progress("Unit testing, so not loading planets.")
	return
#else
	report_progress("Instantiating planets...")
	var/list/planets_spawn_weight = list()
	var/list/planets_to_spawn     = list()

	//Fill up our lists of planets to spawn
	generate_planet_spawn_lists(get_all_planet_templates(), planets_spawn_weight, planets_to_spawn)

	//Pick the random planets we want to spawn
	var/datum/map_template/planetoid/forced_planet = ispath(force_exoplanet_type)? SSmapping.get_template_by_type(force_exoplanet_type) : null
	var/random_planets_to_pick                     = max(num_exoplanets - length(planets_to_spawn), 0) //subtract guaranteed planets
	for(var/i = 0, i < random_planets_to_pick, i++)
		planets_to_spawn += forced_planet || pickweight(planets_spawn_weight)

	//Actually spawn the templates
	spawn_planet_templates(planets_to_spawn)

	report_progress("Finished instantiating planets.")
#endif

///Returns an associative list of all the planet templates we get to pick from. The key is the template name, and the value is the template instance.
/datum/map/proc/get_all_planet_templates()
	. = list()
	var/list/exoplanet_templates = SSmapping.get_templates_by_category(MAP_TEMPLATE_CATEGORY_EXOPLANET)
	if(islist(exoplanet_templates))
		. |= exoplanet_templates

	var/list/planets_templates = SSmapping.get_templates_by_category(MAP_TEMPLATE_CATEGORY_PLANET)
	if(islist(planets_templates))
		. |= planets_templates

///Fill up the list of planet_spawn_weight and guaranteed_planets
/datum/map/proc/generate_planet_spawn_lists(var/list/planets_templates, var/list/planets_spawn_weight, var/list/guaranteed_planets)
	for(var/template_name in planets_templates)
		var/datum/map_template/planetoid/E = planets_templates[template_name]
		if((E.template_flags & TEMPLATE_FLAG_SPAWN_GUARANTEED))
			guaranteed_planets += E
		else
			planets_spawn_weight[E] = E.get_spawn_weight()

///Spawns all the templates in the given list, one after the other
/datum/map/proc/spawn_planet_templates(var/list/templates_to_spawn)
	for(var/datum/map_template/planetoid/PT in templates_to_spawn)
		PT.load_new_z()
#ifdef UNIT_TEST
		log_unit_test("Loaded template '[PT]' ([PT.type]) at Z-level [world.maxz] with a tallness of [PT.tallness]")
#endif

// By default transition randomly to another zlevel
/datum/map/proc/get_transit_zlevel(var/current_z_level)
	var/list/candidates = SSmapping.accessible_z_levels.Copy()
	candidates.Remove(num2text(current_z_level))

	if(!candidates.len)
		return current_z_level
	return text2num(pickweight(candidates))

/datum/map/proc/setup_economy()
	news_network.CreateFeedChannel("News Daily", "Minister of Information", 1, 1)
	news_network.CreateFeedChannel("The Gibson Gazette", "Editor Mike Hammers", 1, 1)

	if(!station_account)
		station_account = create_account("[station_name()] Primary Account", "[station_name()]", starting_money, ACCOUNT_TYPE_DEPARTMENT)

	for(var/job in allowed_jobs)
		var/datum/job/J = SSjobs.get_by_path(job)
		var/list/dept = J.department_types
		if(LAZYLEN(dept))
			station_departments |= dept

	for(var/department in station_departments)
		var/decl/department/dept = SSjobs.get_department_by_type(department)
		if(istype(dept))
			department_accounts[department] = create_account("[dept.name] Account", "[dept.name]", department_money, ACCOUNT_TYPE_DEPARTMENT)

	department_accounts["Vendor"] = create_account("Vendor Account", "Vendor", 0, ACCOUNT_TYPE_DEPARTMENT)
	vendor_account = department_accounts["Vendor"]

/datum/map/proc/map_info(var/client/victim)
	to_chat(victim, "<h2>Current map information</h2>")
	to_chat(victim, get_map_info())

/datum/map/proc/get_map_info()
	return "No map information available"

/datum/map/proc/bolt_saferooms()
	return

/datum/map/proc/unbolt_saferooms()
	return

/datum/map/proc/make_maint_all_access(var/radstorm = 0)
	maint_all_access = 1
	priority_announcement.Announce("The maintenance access requirement has been revoked on all maintenance airlocks.", "Attention!")

/datum/map/proc/revoke_maint_all_access(var/radstorm = 0)
	maint_all_access = 0
	priority_announcement.Announce("The maintenance access requirement has been readded on all maintenance airlocks.", "Attention!")

/datum/map/proc/show_titlescreen(client/C)
	set waitfor = FALSE

	winset(C, "lobbybrowser", "is-disabled=false;is-visible=true")

	show_browser(C, current_lobby_screen, "file=titlescreen.gif;display=0")

	if(isnewplayer(C.mob))
		var/mob/new_player/player = C.mob
		show_browser(C, player.get_lobby_browser_html(), "window=lobbybrowser")

/datum/map/proc/hide_titlescreen(client/C)
	if(C.mob) // Check if the client is still connected to something
		// Hide title screen, allowing player to see the map
		winset(C, "lobbybrowser", "is-disabled=true;is-visible=false")

/datum/map/proc/update_titlescreen(new_screen)
	current_lobby_screen = new_screen || pick(lobby_screens)
	refresh_lobby_browsers()

/datum/map/proc/refresh_lobby_browsers()
	for(var/mob/new_player/player in global.player_list)
		show_titlescreen(player.client)
		player.show_lobby_menu()

/datum/map/proc/create_trade_hubs()
	new /datum/trade_hub/singleton

/datum/map/proc/get_radio_chatter_types()
	return

/datum/map/proc/get_universe_end_evac_areas()
	. = list(/area/space)

/datum/map/proc/get_specops_area()
	return

/datum/map/proc/summarize_roundend_for(var/mob/player)
	if(!player)
		return
	if(player.stat != DEAD)
		var/turf/playerTurf = get_turf(player)
		if(SSevac.evacuation_controller && SSevac.evacuation_controller.round_over() && SSevac.evacuation_controller.emergency_evacuation)
			if(isNotAdminLevel(playerTurf.z))
				to_chat(player, SPAN_NEUTRAL("<b>You managed to survive, but were marooned on [station_name()] as [player.real_name]...</b>"))
			else
				to_chat(player, SPAN_GOOD("<b>You managed to survive the events on [station_name()] as [player.real_name].</b>"))
		else if(isAdminLevel(playerTurf.z))
			to_chat(player, SPAN_GOOD("<b>You successfully underwent crew transfer after events on [station_name()] as [player.real_name].</b>"))
		else if(issilicon(player))
			to_chat(player, SPAN_GOOD("<b>You remain operational after the events on [station_name()] as [player.real_name].</b>"))
		else
			to_chat(player, SPAN_NEUTRAL("<b>You got through just another workday on [station_name()] as [player.real_name].</b>"))
	else
		if(isghost(player))
			var/mob/observer/ghost/O = player
			if(!O.started_as_observer)
				to_chat(player, SPAN_BAD("<b>You did not survive the events on [station_name()]...</b>"))
		else
			to_chat(player, SPAN_BAD("<b>You did not survive the events on [station_name()]...</b>"))

/datum/map/proc/create_passport(var/mob/living/human/H)
	if(!passport_type)
		return
	var/obj/item/passport/pass = new passport_type(get_turf(H))
	if(istype(pass))
		pass.set_info(H)
	if(!H.equip_to_slot(pass, slot_in_backpack_str))
		H.put_in_hands(pass)

/datum/map/proc/populate_overmap_events()
	for(var/overmap_id in global.overmaps_by_name)
		SSmapping.overmap_event_handler.create_events(global.overmaps_by_name[overmap_id])

/datum/map/proc/finalize_map_generation()
	return
