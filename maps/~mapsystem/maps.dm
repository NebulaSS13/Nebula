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

	var/list/station_levels = list() // Z-levels the station exists on
	var/list/admin_levels = list()   // Z-levels for admin functionality (Centcom, shuttle transit, etc)
	var/list/contact_levels = list() // Z-levels that can be contacted from the station, for eg announcements
	var/list/player_levels = list()  // Z-levels a character can typically reach
	var/list/sealed_levels = list()  // Z-levels that don't allow random transit at edge
	var/list/empty_levels = null     // Empty Z-levels that may be used for various things (currently used by FTL jump)

	var/list/map_levels              // Z-levels available to various consoles, such as the crew monitor. Defaults to station_levels if unset.

	var/list/base_turf_by_z = list() // Custom base turf by Z-level. Defaults to world.turf for unlisted Z-levels
	var/list/usable_email_tlds = list("freemail.net")

	var/base_floor_type = /turf/simulated/floor/airless // The turf type used when generating floors between Z-levels at startup.
	var/base_floor_area                                 // Replacement area, if a base_floor_type is generated. Leave blank to skip.

	//This list contains the z-level numbers which can be accessed via space travel and the percentile chances to get there.
	var/list/accessible_z_levels = list()

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

	// Current game year. Uses current system year + game_year num.
	var/game_year = 288

	var/map_admin_faxes = list()

	var/shuttle_docked_message
	var/shuttle_leaving_dock
	var/shuttle_called_message
	var/shuttle_recall_message
	var/emergency_shuttle_docked_message
	var/emergency_shuttle_leaving_dock
	var/emergency_shuttle_recall_message

	var/list/station_networks = list() 		// Camera networks that will show up on the console.

	var/list/holodeck_programs = list() // map of string ids to /datum/holodeck_program instances
	var/list/holodeck_supported_programs = list() // map of maps - first level maps from list-of-programs string id (e.g. "BarPrograms") to another map
												  // this is in order to support multiple holodeck program listings for different holodecks
	                                              // second level maps from program friendly display names ("Picnic Area") to program string ids ("picnicarea")
	                                              // as defined in holodeck_programs
	var/list/holodeck_restricted_programs = list() // as above... but EVIL!

	var/allowed_spawns = list(
		/decl/spawnpoint/arrivals,
		/decl/spawnpoint/gateway,
		/decl/spawnpoint/cryo,
		/decl/spawnpoint/cyborg
	)
	var/default_spawn = /decl/spawnpoint/arrivals

	var/flags = 0
	var/evac_controller_type = /datum/evacuation_controller
	var/use_overmap = 0		//If overmap should be used (including overmap space travel override)
	var/overmap_size = 20		//Dimensions of overmap zlevel if overmap is used.
	var/overmap_z = 0		//If 0 will generate overmap zlevel on init. Otherwise will populate the zlevel provided.
	var/overmap_event_areas = 0 //How many event "clouds" will be generated
	var/pray_reward_type = /obj/item/chems/food/cookie // What reward should be given by admin when a prayer is received?
	var/list/map_markers_to_load

	// The list of lobby screen images to pick() from.
	var/list/lobby_screens = list('icons/default_lobby.png')
	var/current_lobby_screen
	// The track that will play in the lobby screen.
	var/decl/music_track/lobby_track
	// The list of lobby tracks to pick() from. If left unset will randomly select among all available /music_track subtypes.
	var/list/lobby_tracks = list()

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
	//dimensions of planet zlevels, defaults to world size if smaller, INCREASES world size if larger.
	//Due to how maps are generated, must be (2^n+1) e.g. 17,33,65,129 etc. Map will just round up to those if set to anything other.
	var/list/planet_size = list()
	var/away_site_budget = 0

	var/list/loadout_blacklist	//list of types of loadout items that will not be pickable

	//Economy stuff
	var/starting_money = 75000		       // Money in station account
	var/department_money = 5000		       // Money in department accounts
	var/salary_modifier	= 1			       // Multiplier to starting character money
	var/passport_type = /obj/item/passport // Item type to grant people on join.

	var/list/station_departments = list()//Gets filled automatically depending on jobs allowed

	var/default_species = SPECIES_HUMAN
	var/default_bodytype = BODYTYPE_HUMANOID

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

/datum/map/New()

	if(default_spawn && !(default_spawn in allowed_spawns))
		PRINT_STACK_TRACE("Map datum [type] has default spawn point [default_spawn] not in the allowed spawn list.")
	for(var/spawn_type in allowed_spawns)
		allowed_spawns -= spawn_type
		allowed_spawns += GET_DECL(spawn_type)

	if(!map_levels)
		map_levels = station_levels.Copy()

	if(!allowed_jobs)
		allowed_jobs = list()
		for(var/jtype in subtypesof(/datum/job))
			var/datum/job/job = jtype
			if(initial(job.available_by_default))
				allowed_jobs += jtype

	if(!LAZYLEN(planet_size))
		planet_size = list(world.maxx, world.maxy)

	game_year = (text2num(time2text(world.realtime, "YYYY")) + game_year)

	if(ispath(default_job_type, /datum/job))
		var/datum/job/J = default_job_type
		default_job_title = initial(J.title)

/datum/map/proc/get_lobby_track(var/exclude)
	var/lobby_track_type
	if(LAZYLEN(lobby_tracks) == 1)
		lobby_track_type = lobby_tracks[1]
	else if(LAZYLEN(lobby_tracks))
		lobby_track_type = pickweight(lobby_tracks - exclude)
	else
		lobby_track_type = pick(subtypesof(/decl/music_track) - exclude)
	return GET_DECL(lobby_track_type)

/datum/map/proc/setup_map()
	lobby_track = get_lobby_track()
	update_titlescreen()
	world.update_status()

/datum/map/proc/setup_job_lists()
	return

/datum/map/proc/send_welcome()
	return

/datum/map/proc/perform_map_generation()
	return

/datum/map/proc/build_away_sites()
#ifdef UNIT_TEST
	report_progress("Unit testing, so not loading away sites")
	return // don't build away sites during unit testing
#else
	report_progress("Loading away sites...")
	var/list/sites_by_spawn_weight = list()
	for (var/site_name in SSmapping.away_sites_templates)
		var/datum/map_template/ruin/away_site/site = SSmapping.away_sites_templates[site_name]

		if((site.template_flags & TEMPLATE_FLAG_SPAWN_GUARANTEED) && site.load_new_z()) // no check for budget, but guaranteed means guaranteed
			report_progress("Loaded guaranteed away site [site]!")
			away_site_budget -= site.cost
			continue

		sites_by_spawn_weight[site] = site.spawn_weight
	while (away_site_budget > 0 && sites_by_spawn_weight.len)
		var/datum/map_template/ruin/away_site/selected_site = pickweight(sites_by_spawn_weight)
		if (!selected_site)
			break
		sites_by_spawn_weight -= selected_site
		if(selected_site.cost > away_site_budget)
			continue
		if (selected_site.load_new_z())
			report_progress("Loaded away site [selected_site]!")
			away_site_budget -= selected_site.cost
	report_progress("Finished loading away sites, remaining budget [away_site_budget], remaining sites [sites_by_spawn_weight.len]")
#endif

/datum/map/proc/build_exoplanets()
	if(!use_overmap)
		return
	if(LAZYLEN(planet_size))
		if(world.maxx < planet_size[1])
			world.maxx = planet_size[1]
		if(world.maxy < planet_size[2])
			world.maxy = planet_size[2]
	for(var/i = 0, i < num_exoplanets, i++)
		var/exoplanet_type = pick(subtypesof(/obj/effect/overmap/visitable/sector/exoplanet))
		INCREMENT_WORLD_Z_SIZE
		var/obj/effect/overmap/visitable/sector/exoplanet/new_planet = new exoplanet_type(null, world.maxz)
		new_planet.build_level(planet_size[1], planet_size[2])

// Used to apply various post-compile procedural effects to the map.
/datum/map/proc/refresh_mining_turfs(var/zlevel)

	set background = 1
	set waitfor = 0

	for(var/thing in mining_floors["[zlevel]"])
		var/turf/simulated/floor/asteroid/M = thing
		if(istype(M))
			M.updateMineralOverlays()

/datum/map/proc/get_network_access(var/network)
	return 0

// By default transition randomly to another zlevel
/datum/map/proc/get_transit_zlevel(var/current_z_level)
	var/list/candidates = global.using_map.accessible_z_levels.Copy()
	candidates.Remove(num2text(current_z_level))

	if(!candidates.len)
		return current_z_level
	return text2num(pickweight(candidates))

/datum/map/proc/get_empty_zlevel()
	if(empty_levels == null)
		INCREMENT_WORLD_Z_SIZE
		empty_levels = list(world.maxz)
	return pick(empty_levels)


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

// Access check is of the type requires one. These have been carefully selected to avoid allowing the janitor to see channels he shouldn't
// This list needs to be purged but people insist on adding more cruft to the radio.
/datum/map/proc/default_internal_channels()
	return list(
		num2text(PUB_FREQ)   = list(),
		num2text(AI_FREQ)    = list(access_synth),
		num2text(ENT_FREQ)   = list(),
		num2text(ERT_FREQ)   = list(access_cent_specops),
		num2text(COMM_FREQ)  = list(access_bridge),
		num2text(ENG_FREQ)   = list(access_engine_equip, access_atmospherics),
		num2text(MED_FREQ)   = list(access_medical_equip),
		num2text(MED_I_FREQ) = list(access_medical_equip),
		num2text(SEC_FREQ)   = list(access_security),
		num2text(SEC_I_FREQ) = list(access_security),
		num2text(SCI_FREQ)   = list(access_tox,access_robotics,access_xenobiology),
		num2text(SUP_FREQ)   = list(access_cargo),
		num2text(SRV_FREQ)   = list(access_janitor, access_hydroponics),
	)

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
				to_chat(player, "<font color='blue'><b>You managed to survive, but were marooned on [station_name()] as [player.real_name]...</b></font>")
			else
				to_chat(player, "<font color='green'><b>You managed to survive the events on [station_name()] as [player.real_name].</b></font>")
		else if(isAdminLevel(playerTurf.z))
			to_chat(player, "<font color='green'><b>You successfully underwent crew transfer after events on [station_name()] as [player.real_name].</b></font>")
		else if(issilicon(player))
			to_chat(player, "<font color='green'><b>You remain operational after the events on [station_name()] as [player.real_name].</b></font>")
		else
			to_chat(player, "<font color='blue'><b>You got through just another workday on [station_name()] as [player.real_name].</b></font>")
	else
		if(isghost(player))
			var/mob/observer/ghost/O = player
			if(!O.started_as_observer)
				to_chat(player, "<font color='red'><b>You did not survive the events on [station_name()]...</b></font>")
		else
			to_chat(player, "<font color='red'><b>You did not survive the events on [station_name()]...</b></font>")

/datum/map/proc/create_passport(var/mob/living/carbon/human/H)
	if(!passport_type)
		return
	var/obj/item/passport/pass = new passport_type(get_turf(H))
	if(istype(pass))
		pass.set_info(H)
	if(!H.equip_to_slot(pass, slot_in_backpack_str))
		H.put_in_hands(pass)

