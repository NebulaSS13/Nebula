SUBSYSTEM_DEF(jobs)
	name = "Jobs"
	init_order = SS_INIT_JOBS
	flags = SS_NO_FIRE

	var/list/archetype_job_datums =     list()
	var/list/job_lists_by_map_name =    list()
	var/list/titles_to_datums =         list()
	var/list/types_to_datums =          list()
	var/list/primary_job_datums =       list()
	var/list/unassigned_roundstart =    list()
	var/list/positions_by_department =  list()
	var/list/job_icons =                list()
	var/list/must_fill_titles =			list()
	var/list/departments_by_type =      list()
	var/list/departments_by_name =      list()
	var/job_config_file = "config/jobs.txt"

/datum/controller/subsystem/jobs/proc/get_department_by_name(var/dept_name)
	if(!length(departments_by_name))
		var/list/all_depts = decls_repository.get_decls_of_subtype(/decl/department)
		for(var/dtype in all_depts)
			var/decl/department/dept = all_depts[dtype]
			departments_by_name[lowertext(dept.name)] = dept
	. = departments_by_name[lowertext(dept_name)]

/datum/controller/subsystem/jobs/proc/get_department_by_type(var/dept_ref)
	if(!length(departments_by_type))
		departments_by_type = sortTim(decls_repository.get_decls_of_type(/decl/department), /proc/cmp_departments_dsc, TRUE)
	. = departments_by_type[dept_ref]

/datum/controller/subsystem/jobs/Initialize(timeofday)

	// Create main map jobs.
	primary_job_datums.Cut()
	var/list/available_jobs = global.using_map.allowed_jobs.Copy()
	if(global.using_map.default_job_type)
		LAZYDISTINCTADD(available_jobs, global.using_map.default_job_type)
	for(var/jobtype in available_jobs)
		var/datum/job/job = get_by_path(jobtype)
		if(!job)
			job = new jobtype
		primary_job_datums += job

	// Create abstract submap archetype jobs for use in prefs, etc.
	archetype_job_datums.Cut()

	var/list/submap_archetypes = decls_repository.get_decls_of_subtype(/decl/submap_archetype)
	for(var/atype in submap_archetypes)
		var/decl/submap_archetype/arch = submap_archetypes[atype]
		for(var/jobtype in arch.crew_jobs)
			var/datum/job/job = get_by_path(jobtype)
			if(!job && ispath(jobtype, /datum/job/submap))
				// Set this here so that we don't create multiples of the same title
				// before getting to the cache updating proc below.
				types_to_datums[jobtype] = new jobtype(abstract_job = TRUE)
				job = get_by_path(jobtype)
			if(job)
				archetype_job_datums |= job
	submap_archetypes = sortTim(submap_archetypes, /proc/cmp_submap_archetype_asc, TRUE)

	// Load job configuration (is this even used anymore?)
	if(job_config_file && get_config_value(/decl/config/toggle/load_jobs_from_txt))
		var/list/jobEntries = file2list(job_config_file)
		for(var/job in jobEntries)
			if(!job)
				continue
			job = trim(job)
			if(!length(job))
				continue
			var/pos = findtext(job, "=")
			if(pos)
				continue
			var/name = copytext(job, 1, pos)
			var/value = copytext(job, pos + 1)
			if(name && value)
				var/datum/job/J = get_by_title(name)
				if(J)
					J.total_positions = text2num(value)
					J.spawn_positions = text2num(value)
					if((ASSIGNMENT_ROBOT in J.event_categories) || (ASSIGNMENT_COMPUTER in J.event_categories))
						J.total_positions = 0

	if(!length(global.using_map.get_available_skills()))
		log_error("<span class='warning'>Error setting up job skill requirements, no skill datums found!</span>")

	// Update title and path tracking, submap list, etc.
	// Populate/set up map job lists.
	if(length(primary_job_datums))
		primary_job_datums = sortTim(primary_job_datums, /proc/cmp_job_desc)
		job_lists_by_map_name = list("[global.using_map.full_name]" = list("jobs" = primary_job_datums, "default_to_hidden" = FALSE))

	for(var/atype in submap_archetypes)
		var/list/submap_job_datums
		var/decl/submap_archetype/arch = submap_archetypes[atype]
		for(var/jobtype in arch.crew_jobs)
			var/datum/job/job = get_by_path(jobtype)
			if(job)
				LAZYADD(submap_job_datums, job)
		if(LAZYLEN(submap_job_datums))
			submap_job_datums = sortTim(submap_job_datums, /proc/cmp_job_desc)
			job_lists_by_map_name[arch.descriptor] = list("jobs" = submap_job_datums, "default_to_hidden" = arch.default_to_hidden)

	// Update global map blacklists and whitelists.
	for(var/mappath in global.all_maps)
		var/datum/map/M = global.all_maps[mappath]
		M.setup_job_lists()

	// Update valid job titles.
	titles_to_datums = list()
	types_to_datums = list()
	must_fill_titles = list()
	positions_by_department = list()
	for(var/map_name in job_lists_by_map_name)
		var/list/map_data = job_lists_by_map_name[map_name]
		for(var/datum/job/job in map_data["jobs"])
			types_to_datums[job.type] = job
			titles_to_datums[job.title] = job
			for(var/alt_title in job.alt_titles)
				titles_to_datums[alt_title] = job
			if(job.must_fill)
				must_fill_titles += job.title
			if(job.department_types)
				for(var/dept_ref in job.department_types)
					var/decl/department/dept = SSjobs.get_department_by_type(dept_ref)
					if(dept)
						LAZYDISTINCTADD(positions_by_department[dept.type], job.title)

	// Set up syndicate phrases.
	syndicate_code_phrase = generate_code_phrase()
	syndicate_code_response	= generate_code_phrase()

	. = ..()

/datum/controller/subsystem/jobs/proc/guest_jobbans(var/job)
	var/datum/job/j = get_by_title(job)
	if(istype(j) && j.guestbanned)
		return TRUE
	return FALSE


/datum/controller/subsystem/jobs/proc/reset_occupations()
	for(var/mob/new_player/player in global.player_list)
		if((player) && (player.mind))
			player.mind.assigned_job = null
			player.mind.assigned_role = null
			player.mind.assigned_special_role = null
	for(var/datum/job/job in primary_job_datums)
		job.current_positions = 0
	unassigned_roundstart = list()

/datum/controller/subsystem/jobs/proc/get_by_title(var/rank)
	return titles_to_datums[rank]

/datum/controller/subsystem/jobs/proc/get_by_path(var/path)
	RETURN_TYPE(/datum/job)
	return types_to_datums[path]

/datum/controller/subsystem/jobs/proc/get_by_paths(var/paths)
	RETURN_TYPE(/list)
	. = list()
	for(var/path in paths)
		. += types_to_datums[path]

/datum/controller/subsystem/jobs/proc/check_general_join_blockers(var/mob/new_player/joining, var/datum/job/job)
	if(!istype(joining) || !joining.client || !joining.client.prefs)
		return FALSE
	if(!istype(job))
		log_debug("Job assignment error for [joining] - job does not exist or is of the incorrect type.")
		return FALSE
	if(!job.is_position_available())
		to_chat(joining, "<span class='warning'>Unfortunately, that job is no longer available.</span>")
		return FALSE
	if(!get_config_value(/decl/config/toggle/on/enter_allowed))
		to_chat(joining, "<span class='warning'>There is an administrative lock on entering the game!</span>")
		return FALSE
	if(SSticker.mode && SSticker.mode.station_explosion_in_progress)
		to_chat(joining, "<span class='warning'>The [station_name()] is currently exploding. Joining would go poorly.</span>")
		return FALSE
	return TRUE

/datum/controller/subsystem/jobs/proc/check_latejoin_blockers(var/mob/new_player/joining, var/datum/job/job)
	if(!check_general_join_blockers(joining, job))
		return FALSE
	if(job.minimum_character_age && (joining.client.prefs.get_character_age() < job.minimum_character_age))
		to_chat(joining, "<span class='warning'>Your character's in-game age is too low for this job.</span>")
		return FALSE
	if(!job.player_old_enough(joining.client))
		to_chat(joining, "<span class='warning'>Your player age (days since first seen on the server) is too low for this job.</span>")
		return FALSE
	if(GAME_STATE != RUNLEVEL_GAME)
		to_chat(joining, "<span class='warning'>The round is either not ready, or has already finished...</span>")
		return FALSE
	return TRUE

/datum/controller/subsystem/jobs/proc/check_unsafe_spawn(var/mob/living/spawner, var/turf/spawn_turf)
	var/radlevel = SSradiation.get_rads_at_turf(spawn_turf)
	var/airstatus = IsTurfAtmosUnsafe(spawn_turf)
	if(airstatus || radlevel > 0)
		var/reply = alert(spawner, "Warning. Your selected spawn location seems to have unfavorable conditions. \
		You may die shortly after spawning. \
		Spawn anyway? More information: [airstatus] Radiation: [radlevel] Roentgen", "Atmosphere warning", "Abort", "Spawn anyway")
		if(reply == "Abort")
			return FALSE
		else
			// Let the staff know, in case the person complains about dying due to this later. They've been warned.
			log_and_message_admins("User [spawner] spawned at spawn point with dangerous atmosphere.")
	return TRUE

/datum/controller/subsystem/jobs/proc/assign_role(var/mob/new_player/player, var/rank, var/latejoin = 0, var/decl/game_mode/mode = SSticker.mode)
	if(player && player.mind && rank)
		var/datum/job/job = get_by_title(rank)
		if(!job)
			return 0
		if(jobban_isbanned(player, rank))
			return 0
		if(!job.player_old_enough(player.client))
			return 0
		if(job.is_restricted(player.client.prefs))
			return 0
		if(job.title in mode.disabled_jobs)
			return 0

		var/position_limit = job.total_positions
		if(!latejoin)
			position_limit = job.spawn_positions
		if((job.current_positions < position_limit) || position_limit == -1)
			player.mind.assigned_job = job
			player.mind.assigned_role = rank
			player.mind.role_alt_title = job.get_alt_title_for(player.client)
			unassigned_roundstart -= player
			job.current_positions++
			return 1
	return 0

/datum/controller/subsystem/jobs/proc/find_occupation_candidates(datum/job/job, level, flag)
	var/list/candidates = list()
	for(var/mob/new_player/player in unassigned_roundstart)
		if(jobban_isbanned(player, job.title))
			continue
		if(!job.player_old_enough(player.client))
			continue
		if(job.minimum_character_age && (player.client.prefs.get_character_age() < job.minimum_character_age))
			continue
		if(flag && !(flag in player.client.prefs.be_special_role))
			continue
		if(player.client.prefs.CorrectLevel(job,level))
			candidates += player
	return candidates

/datum/controller/subsystem/jobs/proc/give_random_job(var/mob/new_player/player, var/decl/game_mode/mode = SSticker.mode)
	for(var/datum/job/job in shuffle(primary_job_datums))
		if(!job)
			continue
		if(job.minimum_character_age && (player.client.prefs.get_character_age() < job.minimum_character_age))
			continue
		if(istype(job, get_by_title(global.using_map.default_job_title))) // We don't want to give him assistant, that's boring!
			continue
		if(job.is_restricted(player.client.prefs))
			continue
		if(job.not_random_selectable) //If you want a command position, select it!
			continue
		if(jobban_isbanned(player, job.title))
			continue
		if(!job.player_old_enough(player.client))
			continue
		if(job.title in mode.disabled_jobs)
			continue
		if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
			assign_role(player, job.title, mode = mode)
			unassigned_roundstart -= player
			break

///This proc is called before the level loop of divide_occupations() and will try to select a head, ignoring ALL non-head preferences for every level until it locates a head or runs out of levels to check
/datum/controller/subsystem/jobs/proc/fill_head_position(var/decl/game_mode/mode)
	for(var/level = 1 to 3)
		for(var/command_position in must_fill_titles)
			var/datum/job/job = get_by_title(command_position)
			if(!job)	continue
			var/list/candidates = find_occupation_candidates(job, level)
			if(!candidates.len)	continue
			// Build a weighted list, weight by age.
			var/list/weightedCandidates = list()
			for(var/mob/V in candidates)
				// Log-out during round-start? What a bad boy, no head position for you!
				if(!V.client) continue
				var/age = V.client.prefs.get_character_age()
				if(age < job.minimum_character_age) // Nope.
					continue
				switch(age - job.ideal_character_age)
					if(-INFINITY to -10)
						if(age < (job.minimum_character_age+10))
							weightedCandidates[V] = 3 // Still a bit young.
						else
							weightedCandidates[V] = 6 // Better.
					if(-10 to 10)
						weightedCandidates[V] = 10 // Great.
					if(10 to 20)
						weightedCandidates[V] = 6 // Still good.
					if(20 to INFINITY)
						weightedCandidates[V] = 3 // Geezer.
					else
						// If there's ABSOLUTELY NOBODY ELSE
						if(candidates.len == 1) weightedCandidates[V] = 1
			var/mob/new_player/candidate = pickweight(weightedCandidates)
			if(assign_role(candidate, command_position, mode = mode))
				return 1
	return 0

///This proc is called at the start of the level loop of divide_occupations() and will cause head jobs to be checked before any other jobs of the same level
/datum/controller/subsystem/jobs/proc/CheckHeadPositions(var/level, var/decl/game_mode/mode)
	for(var/command_position in must_fill_titles)
		var/datum/job/job = get_by_title(command_position)
		if(!job)	continue
		var/list/candidates = find_occupation_candidates(job, level)
		if(!candidates.len)	continue
		var/mob/new_player/candidate = pick(candidates)
		assign_role(candidate, command_position, mode = mode)

/** Proc divide_occupations
 *  fills var "assigned_role" for all ready players.
 *  This proc must not have any side effect besides of modifying "assigned_role".
 **/
/datum/controller/subsystem/jobs/proc/divide_occupations(decl/game_mode/mode)
	if(global.triai)
		for(var/datum/job/A in primary_job_datums)
			if(A.title == "AI")
				A.spawn_positions = 3
				break
	//Get the players who are ready
	for(var/mob/new_player/player in global.player_list)
		if(player.ready && player.mind && !player.mind.assigned_role)
			unassigned_roundstart += player
	if(unassigned_roundstart.len == 0)	return 0
	//Shuffle players and jobs
	unassigned_roundstart = shuffle(unassigned_roundstart)
	//People who wants to be assistants, sure, go on.
	var/datum/job/assist = new global.using_map.default_job_type ()
	var/list/assistant_candidates = find_occupation_candidates(assist, 3)
	for(var/mob/new_player/player in assistant_candidates)
		assign_role(player, global.using_map.default_job_title, mode = mode)
		assistant_candidates -= player

	//Select one head
	fill_head_position(mode)

	//Other jobs are now checked
	// New job giving system by Donkie
	// This will cause lots of more loops, but since it's only done once it shouldn't really matter much at all.
	// Hopefully this will add more randomness and fairness to job giving.

	// Loop through all levels from high to low
	var/list/shuffledoccupations = shuffle(primary_job_datums)
	for(var/level = 1 to 3)
		//Check the head jobs first each level
		CheckHeadPositions(level, mode)

		// Loop through all unassigned players
		var/list/deferred_jobs = list()
		for(var/mob/new_player/player in unassigned_roundstart)
			// Loop through all jobs
			for(var/datum/job/job in shuffledoccupations) // SHUFFLE ME BABY
				if(job && !mode.disabled_jobs.Find(job.title) )
					if(job.defer_roundstart_spawn)
						deferred_jobs[job] = TRUE
					else if(attempt_role_assignment(player, job, level, mode))
						unassigned_roundstart -= player
						break

		if(LAZYLEN(deferred_jobs))
			for(var/mob/new_player/player in unassigned_roundstart)
				for(var/datum/job/job in deferred_jobs)
					if(attempt_role_assignment(player, job, level, mode))
						unassigned_roundstart -= player
						break
			deferred_jobs.Cut()

	// Hand out random jobs to the people who didn't get any in the last check
	// Also makes sure that they got their preference correct
	for(var/mob/new_player/player in unassigned_roundstart)
		if(player.client.prefs.alternate_option == GET_RANDOM_JOB)
			give_random_job(player, mode)
	// For those who wanted to be assistant if their preferences were filled, here you go.
	for(var/mob/new_player/player in unassigned_roundstart)
		if(player.client.prefs.alternate_option == BE_ASSISTANT)
			var/datum/job/ass = global.using_map.default_job_type
			if((global.using_map.flags & MAP_HAS_BRANCH) && player.client.prefs.branches[initial(ass.title)])
				var/datum/mil_branch/branch = mil_branches.get_branch(player.client.prefs.branches[initial(ass.title)])
				ass = branch.assistant_job
			assign_role(player, initial(ass.title), mode = mode)
	//For ones returning to lobby
	for(var/mob/new_player/player in unassigned_roundstart)
		if(player.client.prefs.alternate_option == RETURN_TO_LOBBY)
			player.ready = 0
			player.show_lobby_menu()
			unassigned_roundstart -= player
	return TRUE

/datum/controller/subsystem/jobs/proc/attempt_role_assignment(var/mob/new_player/player, var/datum/job/job, var/level, var/decl/game_mode/mode)
	if(jobban_isbanned(player, job.title))
		return FALSE
	if(!job.player_old_enough(player.client))
		return FALSE
	if(!player.client.prefs.CorrectLevel(job, level))
		return FALSE
	if(!job.is_position_available())
		return FALSE
	assign_role(player, job.title, mode = mode)
	return TRUE

/decl/loadout_option/proc/is_permitted(mob/living/wearer, datum/job/job)
	if(!istype(wearer))
		return FALSE
	if(allowed_roles && !(job.type in allowed_roles))
		return FALSE
	if(allowed_branches)
		if(!ishuman(wearer))
			return FALSE
		var/mob/living/human/wearer_human = wearer
		if(!wearer_human.char_branch || !(wearer_human.char_branch.type in allowed_branches))
			return FALSE
	if(allowed_skills)
		for(var/required in allowed_skills)
			if(!wearer.skill_check(required, allowed_skills[required]))
				return FALSE
	if(whitelisted && (!(wearer.get_species()?.name in whitelisted)))
		return FALSE
	return TRUE

/datum/controller/subsystem/jobs/proc/equip_custom_loadout(var/mob/living/human/H, var/datum/job/job)

	if(!H || !H.client)
		return

	// Equip custom gear loadout, replacing any job items
	var/list/spawn_in_storage = list()
	if(H.client.prefs.Gear() && job.loadout_allowed)
		for(var/thing in H.client.prefs.Gear())
			var/decl/loadout_option/G = decls_repository.get_decl_by_id_or_var(thing, /decl/loadout_option)
			if(!istype(G))
				continue
			if(!G.is_permitted(H))
				to_chat(H, SPAN_WARNING("Your current species, job, branch, skills or whitelist status does not permit you to spawn with [thing]!"))
				continue
			if(!G.slot || !G.spawn_on_mob(H, H.client.prefs.Gear()[G.uid]))
				spawn_in_storage.Add(G)

	// do accessories last so they don't attach to a suit that will be replaced
	if(H.char_rank && H.char_rank.accessory)
		for(var/accessory_path in H.char_rank.accessory)
			var/list/accessory_data = H.char_rank.accessory[accessory_path]
			if(islist(accessory_data))
				var/amt = accessory_data[1]
				var/list/accessory_args = accessory_data.Copy()
				accessory_args[1] = src
				for(var/i in 1 to amt)
					var/obj/item/accessory = new accessory_path(arglist(accessory_args))
					H.equip_to_slot_or_del(accessory, accessory.get_fallback_slot())
			else
				for(var/i in 1 to (isnull(accessory_data)? 1 : accessory_data))
					var/obj/item/accessory = new accessory_path(src)
					H.equip_to_slot_or_del(accessory, accessory.get_fallback_slot())

	return spawn_in_storage

/datum/controller/subsystem/jobs/proc/equip_job_title(var/mob/living/human/H, var/job_title, var/joined_late = 0)
	if(!H)
		return

	var/datum/job/job = get_by_title(job_title)
	var/list/spawn_in_storage

	if(job)
		if(H.client)
			if(global.using_map.flags & MAP_HAS_BRANCH)
				H.char_branch = mil_branches.get_branch(H.client.prefs.branches[job_title])
			if(global.using_map.flags & MAP_HAS_RANK)
				H.char_rank = mil_branches.get_rank(H.client.prefs.branches[job_title], H.client.prefs.ranks[job_title])

		// Transfers the skill settings for the job to the mob
		H.skillset.obtain_from_client(job, H.client)

		//Equip job items.
		job.equip_job(H, H.mind?.role_alt_title, H.char_branch, H.char_rank)
		job.setup_account(H)
		job.apply_fingerprints(H)
		spawn_in_storage = equip_custom_loadout(H, job)
	else
		to_chat(H, "Your job is [job_title] and the game just can't handle it! Please report this bug to an administrator.")

	H.job = job_title

	if(!joined_late || job.latejoin_at_spawnpoints)
		var/obj/S = job.get_roundstart_spawnpoint()

		if(istype(S, /obj/abstract/landmark/start) && isturf(S.loc))
			H.forceMove(S.loc)
		else
			var/decl/spawnpoint/spawnpoint = job.get_spawnpoint(H.client)
			H.forceMove(DEFAULTPICK(spawnpoint.get_spawn_turfs(H), get_random_spawn_turf(SPAWN_FLAG_JOBS_CAN_SPAWN)))
			spawnpoint.after_join(H)

		// Moving wheelchair if they have one
		if(H.buckled && istype(H.buckled, /obj/structure/bed/chair/wheelchair))
			H.buckled.forceMove(H.loc)
			H.buckled.set_dir(H.dir)

	if(!(ASSIGNMENT_ROBOT in job.event_categories) && !(ASSIGNMENT_COMPUTER in job.event_categories)) //These guys get their emails later.
		var/datum/computer_network/network = get_local_network_at(get_turf(H))
		if(network)
			network.create_account(H, H.real_name, null, H.real_name, null, TRUE)

	// If they're head, give them the account info for their department
	if(H.mind && job.head_position)
		var/remembered_info = ""
		var/datum/money_account/department_account = department_accounts[job.primary_department]

		if(department_account)
			remembered_info += "<b>Your department's account number is:</b> #[department_account.account_number]<br>"
			remembered_info += "<b>Your department's account pin is:</b> [department_account.remote_access_pin]<br>"
			remembered_info += "<b>Your department's account funds are:</b> [department_account.format_value_by_currency(department_account.money)]<br>"

		H.StoreMemory(remembered_info, /decl/memory_options/system)

	var/alt_title = null
	if(!H.mind)
		H.mind_initialize()
	H.mind.assigned_job  = job
	H.mind.assigned_role = job_title
	alt_title = H.mind.role_alt_title

	var/mob/other_mob = job.handle_variant_join(H, alt_title)
	if(other_mob)
		job.post_equip_job_title(other_mob, alt_title || job_title)
		return other_mob

	if(spawn_in_storage)
		for(var/decl/loadout_option/G in spawn_in_storage)
			G.spawn_in_storage_or_drop(H, H.client.prefs.Gear()[G.uid])

	var/article = job.total_positions == 1 ? "the" : "a"
	to_chat(H, "<font size = 3><B>You are [article] [alt_title || job_title].</B></font>")

	var/job_description = job.get_description_blurb()
	if(job_description)
		to_chat(H, SPAN_BOLD("[job_description]"))

	if(job.supervisors)
		to_chat(H, "<b>As [article] [alt_title || job_title] you answer directly to [job.supervisors]. Special circumstances may change this.</b>")

	if(H.has_headset_in_ears())
		to_chat(H, "<b>To speak on your department's radio channel use [H.get_department_radio_prefix()]h. For the use of other channels, examine your headset.</b>")

	if(job.req_admin_notify)
		to_chat(H, "<b>You are playing a job that is important for Game Progression. If you have to disconnect, please notify the admins via adminhelp.</b>")

	if(H.needs_wheelchair())
		equip_wheelchair(H)

	BITSET(H.hud_updateflag, ID_HUD)
	BITSET(H.hud_updateflag, IMPLOYAL_HUD)
	BITSET(H.hud_updateflag, SPECIALROLE_HUD)

	job.post_equip_job_title(H, alt_title || job_title)

	H.client.show_location_blurb(30)

	return H

/datum/controller/subsystem/jobs/proc/titles_by_department(var/dept)
	return positions_by_department[dept] || list()

/datum/controller/subsystem/jobs/proc/spawn_empty_ai()
	for(var/obj/abstract/landmark/start/S in global.landmarks_list)
		if(S.name != "AI")
			continue
		if(locate(/mob/living) in S.loc)
			continue
		empty_playable_ai_cores += new /obj/structure/aicore/deactivated(get_turf(S))
	return 1

/client/proc/show_location_blurb(duration)
	set waitfor = FALSE

	var/location_name = station_name()

	var/obj/effect/overmap/visitable/V = mob.get_owning_overmap_object()
	if(istype(V))
		location_name = V.name

	var/style = "font-family: 'Fixedsys'; -dm-text-outline: 1 black; font-size: 11px;"
	var/area/A = get_area(mob)
	var/text = "[stationdate2text()], [stationtime2text()]\n[location_name], [A.proper_name]"
	text = uppertext(text)

	var/obj/effect/overlay/T = new()
	T.maptext_height = 64
	T.maptext_width = 512
	T.layer = FLOAT_LAYER
	T.plane = HUD_PLANE
	T.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	T.screen_loc = "LEFT+1,BOTTOM+2"

	screen += T
	animate(T, alpha = 255, time = 10)
	for(var/i = 1 to length_char(text) + 1)
		T.maptext = "<span style=\"[style]\">[copytext_char(text, 1, i)] </span>"
		sleep(1)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fade_location_blurb), src, T), duration)

/proc/fade_location_blurb(client/C, obj/T)
	animate(T, alpha = 0, time = 5)
	sleep(5)
	if(C)
		C.screen -= T
	qdel(T)
