/datum/event/radiation_storm
	var/const/enterBelt		= 30
	var/const/radIntervall 	= 5	// Enough time between enter/leave belt for 10 hits, as per original implementation
	var/const/leaveBelt		= 80
	var/const/revokeAccess	= 165 //Hopefully long enough for radiation levels to dissipate.
	startWhen				= 2
	announceWhen			= 1
	endWhen					= revokeAccess
	has_skybox_image		= TRUE
	var/postStartTicks 		= 0

/datum/event/radiation_storm/syndicate
	has_skybox_image = FALSE

/datum/event/radiation_storm/get_skybox_image()
	if(prob(75)) // Sometimes, give no skybox image, to avoid metagaming it
		var/image/res = overlay_image('icons/skybox/radbox.dmi', "beam", null, RESET_COLOR)
		res.alpha = rand(40,80)
		return res

/datum/event/radiation_storm/announce()
	global.using_map.radiation_detected_announcement(affecting_z = affecting_z)

/datum/event/radiation_storm/start()
	..()
	global.using_map.make_maint_all_access(1)

/datum/event/radiation_storm/tick()
	if(activeFor == enterBelt)
		command_announcement.Announce("The [location_name()] has entered the radiation belt. Please remain in a sheltered area until the all clear is given.", "[location_name()] Sensor Array", zlevels = affecting_z)
		radiate()

	if(activeFor >= enterBelt && activeFor <= leaveBelt)
		postStartTicks++

	if(postStartTicks == radIntervall)
		postStartTicks = 0
		radiate()

	else if(activeFor == leaveBelt)
		command_announcement.Announce("The [location_name()] has passed the radiation belt. Please allow for up to one minute while radiation levels dissipate, and report to the infirmary if you experience any unusual symptoms. Maintenance will return to normal access parameters shortly.", "[location_name()] Sensor Array", zlevels = affecting_z)

/datum/event/radiation_storm/proc/radiate()
	var/radiation_level = rand(15, 35)
	for(var/z in affecting_z)
		SSradiation.z_radiate(locate(1, 1, z), radiation_level, 1)

	for(var/mob/living/M in global.living_mob_list_)
		var/area/A = get_area(M)
		if(!A)
			continue
		if(A.area_flags & AREA_FLAG_RAD_SHIELDED)
			continue
		if(!M.can_have_genetic_conditions())
			continue
		if(prob(5 * (1 - M.get_blocked_ratio(null, IRRADIATE, damage_flags = DAM_DISPERSED, armor_pen = radiation_level))))
			if(prob(75))
				M.add_genetic_condition(pick(decls_repository.get_decls_of_type(/decl/genetic_condition/disability)))
			else
				M.add_genetic_condition(pick(decls_repository.get_decls_of_type(/decl/genetic_condition/superpower)))


/datum/event/radiation_storm/end()
	global.using_map.revoke_maint_all_access(1)

/datum/event/radiation_storm/syndicate/radiate()
	return
