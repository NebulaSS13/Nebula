/datum/job/cynosure/survivalist
	title = "Survivalist"
	department_types = list(/decl/department/planetside)
	selection_color = "#6085a8"
	total_positions = 3
	spawn_positions = 3
	supervisors = "your conscience"
	economic_power = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/outfit/job/survivalist
	description = "There are a few small groups of people living in the wilderness of Sif, and they occasionally venture to the Cynosure to trade, ask for help, or just have someone to talk to."
	latejoin_at_spawnpoints = TRUE
	create_record = FALSE
	available_by_default = FALSE
	allowed_ranks = null
	allowed_branches = null
	account_allowed = FALSE
	announced = FALSE
	alt_titles = list(/decl/alt_title/crash_survivor)
/*
	var/const/SPAWN_DAMAGE_MULT = 0.15
	var/const/TOTAL_INJURIES = 3
	var/static/list/pod_templates = list(
		/datum/map_template/sif/plains/Epod,
		/datum/map_template/sif/plains/Epod2,
		///datum/map_template/sif/wilderness/deep/Epod3, // Don't use this one, it has spiders.
		/datum/map_template/sif/wilderness/normal/Epod4
	)
*/

/decl/alt_title/crash_survivor
	name = "Crash Survivor"
	desc = "Crashing in the wilderness of Sif's anomalous region is not a recommended holiday activity."
	outfit = /decl/outfit/job/survivalist/crash_survivor

/datum/job/cynosure/survivalist/get_outfit(mob/living/human/H, alt_title, datum/mil_branch/branch, datum/mil_rank/grade)
	if(H.species?.uid == /decl/species/vox::uid)
		return GET_DECL(/decl/outfit/vox/survivor)
	return ..()

/*
/datum/job/cynosure/survivalist/equip_job(mob/living/human/H, alt_title, datum/mil_branch/branch, datum/mil_rank/grade)
	. = ..()
	if(.)

		if(alt_title == /decl/alt_title/crash_survivor::name)

			// Spawn some kit for getting out of the pod, if they don't have it already.
			var/turf/T = get_turf(H)

			var/obj/item/toolbox/mechanical/toolbox
			for(var/turf/neighbor in RANGE_TURFS(T, 1))
				toolbox = locate(/obj/item/toolbox/mechanical) in neighbor
				if(toolbox)
					break

			if(!toolbox)
				toolbox = new(T)
			if(!(locate(/obj/item/tool/xeno/hand) in toolbox))
				new /obj/item/tool/xeno/hand(toolbox)
			if(!(locate(/obj/item/gps) in toolbox))
				new /obj/item/gps(toolbox)
			toolbox.name = "emergency toolbox"
			toolbox.desc = "A heavy toolbox stocked with tools for getting out of a crashed pod, as well as a GPS to aid with recovery."
			toolbox.storage.make_exact_fit()

			// Clear the mark so it isn't available for other spawns.
			for(var/obj/abstract/landmark/crashed_pod/pod_landmark in T)
				qdel(pod_landmark)

			// Smack them around from the landing.
			apply_post_spawn_damage(H)

/datum/job/cynosure/survivalist/proc/apply_post_spawn_damage(var/mob/living/human/H)
	set waitfor = FALSE
	sleep(1) // let init and setup finish
	// beat them up a little
	for(var/injuries in 1 to TOTAL_INJURIES)
		var/deal_brute = rand(0, round(H.species.total_health * SPAWN_DAMAGE_MULT))
		H.take_overall_damage(deal_brute, round(H.species.total_health * SPAWN_DAMAGE_MULT) - deal_brute, "Crash Trauma")
	// remove any bleeding/internal bleeding, don't be too unfair
	for(var/obj/item/organ/external/E in H.get_external_organs())
		E.status &= ~ORGAN_ARTERY_CUT
		E.clamp_organ()
		E.update_damages()

/* TODO rewrite for our level system

/datum/job/survivalist/get_latejoin_spawn_locations(var/mob/spawning, var/rank)
	var/alt_title = spawning?.client?.prefs?.GetPlayerAltTitle(job_master.GetJob(rank))
	if(alt_title == /decl/alt_title/crash_survivor::name)
		return get_spawn_locations(spawning, rank)
	return ..()

/datum/job/survivalist/proc/get_existing_spawn_points()
	for(var/obj/abstract/landmark/crashed_pod/sloc in landmarks_list)
		if(!(locate(/mob/living) in sloc.loc))
			LAZYADD(., get_turf(sloc))

/datum/job/survivalist/get_spawn_locations(var/mob/spawning, var/rank)

	var/alt_title = spawning?.client?.prefs?.GetPlayerAltTitle(job_master.GetJob(rank))
	if(!spawning || alt_title != /decl/alt_title/crash_survivor::name)
		return ..()

	var/list/existing_points = get_existing_spawn_points()
	// Create a point if none are available.
	if(!length(existing_points))
		// Boilerplate from mapping.dm
		var/specific_sanity = 100
		var/datum/map_template/chosen_template = pick(pod_templates)
		chosen_template = new chosen_template
		while(specific_sanity > 0)
			specific_sanity--
			var/width_border = TRANSITIONEDGE + SUBMAP_MAP_EDGE_PAD + round(chosen_template.width / 2)
			var/height_border = TRANSITIONEDGE + SUBMAP_MAP_EDGE_PAD + round(chosen_template.height / 2)
			var/turf/T = locate(rand(width_border, world.maxx - width_border), rand(height_border, world.maxy - height_border), Z_LEVEL_SURFACE_WILD)
			var/valid = TRUE
			for(var/turf/check in chosen_template.get_affected_turfs(T,TRUE))
				var/area/new_area = get_area(check)
				if(!(istype(new_area, /area/surface/outside/wilderness)))
					valid = FALSE // Probably overlapping something important.
					break
			if(!valid)
				continue
			chosen_template.load(T, centered = TRUE)
			admin_notice("Crash survivor placed \"[chosen_template.name]\" at ([T.x], [T.y], [T.z])\n", R_DEBUG)
			break

		// Rebuild the spawn point list now that one has been spawned.
		existing_points = get_existing_spawn_points()

	return existing_points
*/
*/

/obj/abstract/landmark/crashed_pod
	name = "Crash Survivor Spawn"
	delete_me = FALSE
