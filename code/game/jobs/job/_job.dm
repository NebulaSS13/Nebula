/datum/job
	var/title                                 // The name of the job
	var/list/software_on_spawn = list()       // Defines the software files that spawn on tablets and labtops
	var/list/department_types = list()        // What departments the job is in.
	var/autoset_department = TRUE             // If department list is empty, use map default.
	var/primary_department                    // A jobs primary deparment, defualts to the first in the department refs list if not set. Important for heads, the department they are head of needs to be this one.
	var/total_positions = 0                   // How many players can be this job
	var/spawn_positions = 0                   // How many players can spawn in as this job
	var/current_positions = 0                 // How many players have this job
	var/availablity_chance = 100              // Percentage chance job is available each round
	var/guestbanned = FALSE                   // If set to 1 this job will be unavalible to guests
	var/must_fill = FALSE                     // If set to 1 this job will be have priority over other job preferences. Do not recommend on jobs with more than one position.
	var/not_random_selectable = FALSE         // If set to 1 this job will not be selected when a player asks for a random job.
	var/description                           // If set, returns a static description. To add dynamic text, override get_description_blurb, call parent aka . = ..() and then . += "extra text" on the line after that.
	var/list/event_categories                 // A set of tags used to check jobs for suitability for things like random event selection.
	var/skip_loadout_preview = FALSE          // Whether or not the job should render loadout items in char preview.
	var/supervisors = null                    // Supervisors, who this person answers to directly
	var/selection_color = "#515151"         // Selection screen color
	var/list/alt_titles                       // List of alternate titles, if any and any potential alt. outfits as assoc values.
	var/req_admin_notify                      // If this is set to 1, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/minimal_player_age = 0                // If you have use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/head_position = 0                     // Is this position Command?
	var/minimum_character_age                 // List of species = age, if species is not here, it's auto-pass
	var/ideal_character_age = 30              // Preferred character age when populate job at roundstart.
	var/create_record = 1                     // Do we announce/make records for people who spawn on this job?
	var/is_semi_antagonist = FALSE            // Whether or not this job is given semi-antagonist status.
	var/account_allowed = 1                   // Does this job type come with a station account?
	var/economic_power = 2                    // With how much does this job modify the initial account amount?
	var/is_holy = FALSE                       // Can this role perform blessings?
	var/outfit_type                           // The outfit the employee will be dressed in, if any
	var/loadout_allowed = TRUE                // Whether or not loadout equipment is allowed and to be created when joining.
	var/list/allowed_branches                 // For maps using branches and ranks, also expandable for other purposes
	var/list/allowed_ranks                    // Ditto
	var/announced = TRUE                      // If their arrival is announced on radio
	var/latejoin_at_spawnpoints               // If this job should use roundstart spawnpoints for latejoin (offstation jobs etc)
	var/forced_spawnpoint                     // If set to a spawnpoint name, will use that spawn point for joining as this job.
	var/hud_icon                              // icon used for Sec HUD overlay

	// A list of string IDs for keys to grant on join.
	var/list/lock_keys = list()

	//Job access. The use of minimal_access or access is determined by a config setting: jobs_have_minimal_access
	var/list/minimal_access = list()          // Useful for servers which prefer to only have access given to the places a job absolutely needs (Larger server population)
	var/list/access = list()                  // Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)

	//Minimum skills allowed for the job. List should contain skill (as in /decl/hierarchy/skill path), with values which are numbers.
	var/min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT
	)
	var/max_skill = list()                    //Maximum skills allowed for the job.
	var/skill_points = 16                     //The number of unassigned skill points the job comes with (on top of the minimum skills).
	var/no_skill_buffs = FALSE                //Whether skills can be buffed by age/species modifiers.
	var/available_by_default = TRUE

	var/list/possible_goals
	var/min_goals = 1
	var/max_goals = 3

	var/defer_roundstart_spawn = FALSE        // If true, the job will be put off until all other jobs have been populated.
	var/list/species_branch_rank_cache_ = list()

	var/required_language

	var/no_warn_unsafe                        // If true, we don't prompt the user to confirm on spawning if the environment is unsafe.

/datum/job/New()

	if(type == /datum/job && global.using_map.default_job_type == type)
		title = "Debug Job"
		hud_icon = "hudblank"
		outfit_type = /decl/hierarchy/outfit/job/generic/scientist
		autoset_department = TRUE

	if(!length(department_types) && autoset_department)
		department_types = list(global.using_map.default_department_type)
	if(isnull(primary_department) && length(department_types))
		primary_department = department_types[1]

	if(prob(100-availablity_chance))	//Close positions, blah blah.
		total_positions = 0
		spawn_positions = 0

	if(!hud_icon)
		hud_icon = "hud[ckey(title)]"

	..()

/datum/job/dd_SortValue()
	return title

/datum/job/proc/equip_job(var/mob/living/human/H, var/alt_title, var/datum/mil_branch/branch, var/datum/mil_rank/grade)
	H.add_language(/decl/language/human/common)
	if (required_language)
		H.add_language(required_language)
		H.set_default_language(required_language)
	else
		H.set_default_language(/decl/language/human/common)

	var/decl/hierarchy/outfit/outfit = get_outfit(H, alt_title, branch, grade)
	if(outfit)
		. = outfit.equip_outfit(H, alt_title || title, job = src, rank = grade)

	if(length(lock_keys) == 1)
		var/lock_key = lock_keys[1]
		var/obj/item/key/new_key = new(get_turf(H), lock_keys[lock_key] || /decl/material/solid/metal/iron, lock_key)
		H.put_in_hands_or_store_or_drop(new_key)
	else if(length(lock_keys))
		var/obj/item/keyring/keyring
		for(var/lock_key in lock_keys)
			if(!keyring)
				keyring = new(get_turf(H))
				H.put_in_hands_or_store_or_drop(keyring)
			var/obj/item/key/new_key = new(get_turf(H), lock_keys[lock_key] || /decl/material/solid/metal/iron, lock_key)
			keyring.storage?.handle_item_insertion(null, new_key)

/datum/job/proc/get_outfit(var/mob/living/human/H, var/alt_title, var/datum/mil_branch/branch, var/datum/mil_rank/grade)
	if(alt_title && alt_titles)
		. = alt_titles[alt_title]
	if(allowed_branches && branch)
		. = allowed_branches[branch.type] || .
	if(allowed_ranks && grade)
		. = allowed_ranks[grade.type] || .
	. = . || outfit_type
	. = outfit_by_type(.)

/datum/job/proc/create_cash_on_hand(var/mob/living/human/H, var/datum/money_account/M)
	if(!istype(M) || !H.client?.prefs?.starting_cash_choice)
		return 0
	for(var/obj/item/thing in H.client.prefs.starting_cash_choice.get_cash_objects(H, M))
		. += thing.get_base_value()
		H.equip_to_storage_or_put_in_hands(thing)

/datum/job/proc/get_total_starting_money(var/mob/living/human/H)
	. = 4 * rand(75, 100) * economic_power
	// Get an average economic power for our cultures.
	var/culture_mod =   0
	var/culture_count = 0
	for(var/token in H.cultural_info)
		var/decl/cultural_info/culture = H.get_cultural_value(token)
		if(culture && !isnull(culture.economic_power))
			culture_count++
			culture_mod += culture.economic_power
	if(culture_count)
		culture_mod /= culture_count
	. *= culture_mod
	// Apply other mods.
	. *= global.using_map.salary_modifier
	. *= 1 + 2 * H.get_skill_value(SKILL_FINANCE)/(SKILL_MAX - SKILL_MIN)
	. = round(.)

/datum/job/proc/setup_account(var/mob/living/human/H)
	if(!account_allowed || (H.mind && H.mind.initial_account))
		return

	// Calculate our pay and apply all relevant modifiers.
	var/money_amount = get_total_starting_money(H)
	if(money_amount <= 0)
		return // You are too poor for an account.

	//give them an account in the station database
	var/datum/money_account/M = create_account("[H.real_name]'s account", H.real_name, money_amount)
	var/cash_on_hand = create_cash_on_hand(H, M)
	// Store their financial info.
	if(H.mind)
		var/remembered_info = ""
		remembered_info += "<b>Your account number is:</b> #[M.account_number]<br>"
		remembered_info += "<b>Your account pin is:</b> [M.remote_access_pin]<br>"
		remembered_info += "<b>Your account funds are:</b> [M.format_value_by_currency(M.money)]<br>"
		if(M.transaction_log.len)
			var/datum/transaction/T = M.transaction_log[1]
			remembered_info += "<b>Your account was created:</b> [T.time], [T.date] at [T.get_source_name()]<br>"
		if(cash_on_hand > 0)
			var/decl/currency/cur = GET_DECL(global.using_map.default_currency)
			remembered_info += "<b>Your cash on hand is:</b> [cur.format_value(cash_on_hand)]<br>"
		H.StoreMemory(remembered_info, /decl/memory_options/system)
		H.mind.initial_account = M
		for(var/obj/item/card/id/I in H.GetIdCards())
			if(!I.associated_account_number)
				I.associated_account_number = M.account_number
				break

// overrideable separately so AIs/borgs can have cardborg hats without unneccessary new()/qdel()
/datum/job/proc/equip_preview(mob/living/human/H, var/alt_title, var/datum/mil_branch/branch, var/datum/mil_rank/grade, var/additional_skips)
	var/decl/hierarchy/outfit/outfit = get_outfit(H, alt_title, branch, grade)
	if(!outfit)
		return FALSE
	. = outfit.equip_outfit(H, alt_title || title, equip_adjustments = (OUTFIT_ADJUSTMENT_SKIP_POST_EQUIP|OUTFIT_ADJUSTMENT_SKIP_ID_PDA|additional_skips), job = src, rank = grade)

/datum/job/proc/get_access()
	if(minimal_access.len && get_config_value(/decl/config/toggle/on/jobs_have_minimal_access))
		return minimal_access?.Copy()
	return access?.Copy()

//If the configuration option is set to require players to be logged as old enough to play certain jobs, then this proc checks that they are, otherwise it just returns 1
/datum/job/proc/player_old_enough(client/C)
	return (available_in_days(C) == 0) //Available in 0 days = available right now = player is old enough to play.

/datum/job/proc/available_in_days(client/C)
	if(C && get_config_value(/decl/config/num/use_age_restriction_for_jobs) && isnull(C.holder) && isnum(C.player_age) && isnum(minimal_player_age))
		return max(0, minimal_player_age - C.player_age)
	return 0

/datum/job/proc/apply_fingerprints(var/mob/living/human/target)
	if(!istype(target))
		return 0
	for(var/obj/item/item in target.contents)
		apply_fingerprints_to_item(target, item)
	return 1

/datum/job/proc/apply_fingerprints_to_item(var/mob/living/human/holder, var/obj/item/item)
	item.add_fingerprint(holder,1)
	if(item.contents.len)
		for(var/obj/item/sub_item in item.contents)
			apply_fingerprints_to_item(holder, sub_item)

/datum/job/proc/is_position_available()
	return (current_positions < total_positions) || (total_positions == -1)

/datum/job/proc/has_alt_title(var/mob/H, var/supplied_title, var/desired_title)
	return (supplied_title == desired_title) || (H.mind && H.mind.role_alt_title == desired_title)

/datum/job/proc/is_restricted(var/datum/preferences/prefs, var/feedback)

	if(!isnull(allowed_branches) && (!prefs.branches[title] || !is_branch_allowed(prefs.branches[title])))
		to_chat(feedback, "<span class='boldannounce'>Wrong branch of service for [title]. Valid branches are: [get_branches()].</span>")
		return TRUE

	if(!isnull(allowed_ranks) && (!prefs.ranks[title] || !is_rank_allowed(prefs.branches[title], prefs.ranks[title])))
		to_chat(feedback, "<span class='boldannounce'>Wrong rank for [title]. Valid ranks in [prefs.branches[title]] are: [get_ranks(prefs.branches[title])].</span>")
		return TRUE

	var/decl/species/S = get_species_by_key(prefs.species)
	if(!is_species_allowed(S))
		to_chat(feedback, "<span class='boldannounce'>Restricted species, [S], for [title].</span>")
		return TRUE

	if(LAZYACCESS(minimum_character_age, S.get_root_species_name()) && (prefs.get_character_age() < minimum_character_age[S.get_root_species_name()]))
		to_chat(feedback, "<span class='boldannounce'>Not old enough. Minimum character age is [minimum_character_age[S.get_root_species_name()]].</span>")
		return TRUE

	if(!S.check_background(src, prefs))
		to_chat(feedback, "<span class='boldannounce'>Incompatible background for [title].</span>")
		return TRUE

	var/special_blocker = check_special_blockers(prefs)
	if(special_blocker)
		to_chat(feedback, "<span class='boldannounce'>Your current preferences are not appropriate for [title] due to: '[special_blocker]'.</span>")
		return TRUE

	return FALSE

/datum/job/proc/get_join_link(var/client/caller, var/href_string, var/show_invalid_jobs)
	if(is_available(caller))
		if(is_restricted(caller.prefs))
			if(show_invalid_jobs)
				return "<tr bgcolor='[selection_color]'><td style='padding-left:2px;padding-right:2px;'><a style='text-decoration: line-through' href='[href_string]'>[title]</a></td><td style='padding-left:2px;padding-right:2px;''><center>[current_positions]</center></td><td style='padding-left:2px;padding-right:2px;'><center>Active: [get_active_count()]</center></td></tr>"
		else
			return "<tr bgcolor='[selection_color]'><td style='padding-left:2px;padding-right:2px;'><a href='[href_string]'>[title]</a></td><td style='padding-left:2px;padding-right:2px;'><center>[current_positions]</center></td><td style='padding-left:2px;padding-right:2px;'><center>Active: [get_active_count()]</center></td></tr>"
	return ""

// Only players with the job assigned and AFK for less than 10 minutes count as active
/datum/job/proc/check_is_active(var/mob/M)
	return (M.mind && M.client && M.mind.assigned_role == title && M.client.inactivity <= 10 * 60 * 10)

/datum/job/proc/get_active_count()
	var/active = 0
	for(var/mob/M in global.player_list)
		if(check_is_active(M))
			active++
	return active

/datum/job/proc/is_species_allowed(var/decl/species/S)
	if(global.using_map.is_species_job_restricted(S, src))
		return FALSE
	// We also make sure that there is at least one valid branch-rank combo for the species.
	if(!allowed_branches || !global.using_map || !(global.using_map.flags & MAP_HAS_BRANCH))
		return TRUE
	return LAZYLEN(get_branch_rank(S))

// Don't use if the map doesn't use branches but jobs do.
/datum/job/proc/get_branch_rank(var/decl/species/S)
	. = species_branch_rank_cache_[S]
	if(.)
		return

	species_branch_rank_cache_[S] = list()
	. = species_branch_rank_cache_[S]

	var/spawn_branches = mil_branches.spawn_branches(S)
	for(var/branch_type in allowed_branches)
		var/datum/mil_branch/branch = mil_branches.get_branch_by_type(branch_type)
		if(branch.name in spawn_branches)
			if(!allowed_ranks || !(global.using_map.flags & MAP_HAS_RANK))
				LAZYADD(., branch.name)
				continue // Screw this rank stuff, we're good.
			var/spawn_ranks = branch.spawn_ranks(S)
			for(var/rank_type in allowed_ranks)
				var/datum/mil_rank/rank = rank_type
				if(initial(rank.name) in spawn_ranks)
					LAZYADD(.[branch.name], initial(rank.name))

/**
 *  Check if members of the given branch are allowed in the job
 *
 *  This proc should only be used after the global branch list has been initialized.
 *
 *  branch_name - String key for the branch to check
 */
/datum/job/proc/is_branch_allowed(var/branch_name)
	if(!allowed_branches || !global.using_map || !(global.using_map.flags & MAP_HAS_BRANCH))
		return 1
	if(branch_name == "None")
		return 0

	var/datum/mil_branch/branch = mil_branches.get_branch(branch_name)

	if(!branch)
		PRINT_STACK_TRACE("unknown branch \"[branch_name]\" passed to is_branch_allowed()")
		return 0

	if(is_type_in_list(branch, allowed_branches))
		return 1
	else
		return 0

/**
 *  Check if people with given rank are allowed in this job
 *
 *  This proc should only be used after the global branch list has been initialized.
 *
 *  branch_name - String key for the branch to which the rank belongs
 *  rank_name - String key for the rank itself
 */
/datum/job/proc/is_rank_allowed(var/branch_name, var/rank_name)
	if(!allowed_ranks || !global.using_map || !(global.using_map.flags & MAP_HAS_RANK))
		return 1
	if(branch_name == "None" || rank_name == "None")
		return 0

	var/datum/mil_rank/rank = mil_branches.get_rank(branch_name, rank_name)

	if(!rank)
		PRINT_STACK_TRACE("unknown rank \"[rank_name]\" in branch \"[branch_name]\" passed to is_rank_allowed()")
		return 0

	if(is_type_in_list(rank, allowed_ranks))
		return 1
	else
		return 0

//Returns human-readable list of branches this job allows.
/datum/job/proc/get_branches()
	var/list/res = list()
	for(var/T in allowed_branches)
		var/datum/mil_branch/B = mil_branches.get_branch_by_type(T)
		res += B.name
	return english_list(res)

//Same as above but ranks
/datum/job/proc/get_ranks(branch)
	var/list/res = list()
	var/datum/mil_branch/B = mil_branches.get_branch(branch)
	for(var/T in allowed_ranks)
		var/datum/mil_rank/R = T
		if(B && !(initial(R.name) in B.ranks))
			continue
		res |= initial(R.name)
	return english_list(res)

/datum/job/proc/get_description_blurb()
	return description

/datum/job/proc/get_job_icon()
	if(!SSjobs.job_icons[title])
		var/mob/living/human/dummy/mannequin/mannequin = get_mannequin("#job_icon")
		if(mannequin)
			var/decl/species/mannequin_species = get_species_by_key(global.using_map.default_species)
			if(!is_species_allowed(mannequin_species))
				// Don't just default to the first species allowed, pick one at random.
				for(var/other_species in shuffle(get_playable_species()))
					var/decl/species/other_species_decl = get_species_by_key(other_species)
					if(is_species_allowed(other_species_decl))
						mannequin_species = other_species_decl
						break
			if(!is_species_allowed(mannequin_species))
				PRINT_STACK_TRACE("No allowed species allowed for job [title] ([type]), falling back to default!")
			mannequin.change_species(mannequin_species.name)
			dress_mannequin(mannequin)
			mannequin.set_dir(SOUTH)
			var/icon/preview_icon = getFlatIcon(mannequin)
			preview_icon.Scale(preview_icon.Width() * 2, preview_icon.Height() * 2) // Scaling here to prevent blurring in the browser.
			SSjobs.job_icons[title] = preview_icon
	return SSjobs.job_icons[title]

/datum/job/proc/get_unavailable_reasons(var/client/caller)
	var/list/reasons = list()
	if(jobban_isbanned(caller, title))
		reasons["You are jobbanned."] = TRUE
	if(is_semi_antagonist && jobban_isbanned(caller, /decl/special_role/provocateur))
		reasons["You are semi-antagonist banned."] = TRUE
	if(!player_old_enough(caller))
		reasons["Your player age is too low."] = TRUE
	if(!is_position_available())
		reasons["There are no positions left."] = TRUE
	if(!isnull(allowed_branches) && (!caller.prefs.branches[title] || !is_branch_allowed(caller.prefs.branches[title])))
		reasons["Your branch of service does not allow it."] = TRUE
	else if(!isnull(allowed_ranks) && (!caller.prefs.ranks[title] || !is_rank_allowed(caller.prefs.branches[title], caller.prefs.ranks[title])))
		reasons["Your rank choice does not allow it."] = TRUE
	var/decl/species/S = get_species_by_key(caller.prefs.species)
	if(S)
		if(!is_species_allowed(S))
			reasons["Your species choice does not allow it."] = TRUE
		if(!S.check_background(src, caller.prefs))
			reasons["Your background choices do not allow it."] = TRUE
		var/special_blocker = check_special_blockers(caller.prefs)
		if(special_blocker)
			reasons["Your preferences do not allow it: '[special_blocker]'."] = TRUE
		return TRUE
	if(LAZYLEN(reasons))
		. = reasons

/datum/job/proc/dress_mannequin(var/mob/living/human/dummy/mannequin/mannequin)
	if(mannequin)
		mannequin.delete_inventory(TRUE)
		equip_preview(mannequin, additional_skips = OUTFIT_ADJUSTMENT_SKIP_BACKPACK)

/datum/job/proc/is_available(var/client/caller)
	if(!is_position_available())
		return FALSE
	if(jobban_isbanned(caller, title))
		return FALSE
	if(is_semi_antagonist && jobban_isbanned(caller, /decl/special_role/provocateur))
		return FALSE
	if(!player_old_enough(caller))
		return FALSE
	return TRUE

/datum/job/proc/make_position_available()
	total_positions++

/datum/job/proc/get_roundstart_spawnpoint()
	var/list/loc_list = list()
	for(var/obj/abstract/landmark/start/sloc in global.landmarks_list)
		if(sloc.name != title)	continue
		if(locate(/mob/living) in sloc.loc)	continue
		loc_list += sloc
	if(loc_list.len)
		return pick(loc_list)
	else
		return locate("start*[title]") // use old stype

/**
 *  Return appropriate /decl/spawnpoint for given client
 *
 *  Spawnpoint will be the one set in preferences for the client, unless the
 *  preference is not set, or the preference is not appropriate for the rank, in
 *  which case a fallback will be selected.
 */
/datum/job/proc/get_spawnpoint(var/client/C)

	if(!C)
		CRASH("Null client passed to get_spawnpoint_for() proc!")

	var/mob/H = C.mob

	var/spawntype = forced_spawnpoint || C.prefs.spawnpoint || global.using_map.default_spawn
	var/decl/spawnpoint/spawnpos = GET_DECL(spawntype)
	if(spawnpos && !spawnpos.check_job_spawning(src))
		if(H)
			to_chat(H, SPAN_WARNING("Your chosen spawnpoint ([spawnpos.name]) is unavailable for your chosen job ([title]). Spawning you at another spawn point instead."))
		spawnpos = null
	if(!spawnpos)
		// Step through all spawnpoints and pick first appropriate for job
		for(var/decl/spawnpoint/candidate as anything in global.using_map.allowed_latejoin_spawns)
			if(candidate?.check_job_spawning(src))
				spawnpos = candidate
				break
	return spawnpos

/datum/job/proc/post_equip_job_title(var/mob/person, var/alt_title, var/rank)
	if(is_semi_antagonist && person.mind)
		var/decl/special_role/provocateur/provocateurs = GET_DECL(/decl/special_role/provocateur)
		provocateurs.add_antagonist(person.mind)

/datum/job/proc/get_alt_title_for(var/client/C)
	return C.prefs.GetPlayerAltTitle(src)

/datum/job/proc/clear_slot()
	if(current_positions > 0)
		current_positions -= 1
		return TRUE
	return FALSE

/datum/job/proc/handle_variant_join(var/mob/living/human/H, var/alt_title)
	return

/datum/job/proc/check_special_blockers(var/datum/preferences/prefs)
	return

/datum/job/proc/do_spawn_special(var/mob/living/character, var/mob/new_player/new_player_mob, var/latejoin = FALSE)
	return FALSE

/datum/job/proc/get_occupations_tab_sort_score()
	. = (0.1 * head_position)
	if(primary_department)
		var/decl/department/dept = GET_DECL(primary_department)
		. += dept.display_priority
