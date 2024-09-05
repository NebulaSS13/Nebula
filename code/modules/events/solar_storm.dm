/datum/event/solar_storm
	startWhen				= 45
	announceWhen			= 1
	var/const/rad_interval 	= 5  	//Same interval period as radiation storms.
	var/const/temp_incr     = 100
	var/const/fire_loss     = 40
	var/base_solar_gen_rate


/datum/event/solar_storm/setup()
	endWhen = startWhen + rand(30,90) + rand(30,90) //2-6 minute duration

/datum/event/solar_storm/announce()
	command_announcement.Announce("A solar storm has been detected approaching the [location_name()]. Please halt all EVA activites immediately and return inside.", "[location_name()] Sensor Array", zlevels = affecting_z)
	adjust_solar_output(1.5)

/datum/event/solar_storm/proc/adjust_solar_output(var/mult = 1)
	if(isnull(base_solar_gen_rate)) base_solar_gen_rate = solar_gen_rate
	solar_gen_rate = mult * base_solar_gen_rate


/datum/event/solar_storm/start()
	command_announcement.Announce("The solar storm has reached the [location_name()]. Please refain from EVA and remain inside until it has passed.", "[location_name()] Sensor Array", zlevels = affecting_z)
	adjust_solar_output(5)


/datum/event/solar_storm/tick()
	if(activeFor % rad_interval == 0)
		radiate()

/datum/event/solar_storm/proc/radiate()
	// Note: Too complicated to be worth trying to use the radiation system for this.  It's only in space anyway, so we make an exception in this case.
	for(var/mob/living/L in global.living_mob_list_)
		if(L.loc?.atom_flags & ATOM_FLAG_SHIELD_CONTENTS)
			continue
		var/turf/T = get_turf(L)
		if(!T || !isPlayerLevel(T.z))
			continue

		if(!istype(T.loc,/area/space) && !isspaceturf(T))	//Make sure you're in a space area or on a space turf
			continue

		//Apply some heat or burn damage from the sun.
		if(L.increaseBodyTemp(temp_incr))
			continue

		L.take_damage(fire_loss, BURN)

/datum/event/solar_storm/end()
	command_announcement.Announce("The solar storm has passed the [location_name()]. It is now safe to resume EVA activities. ", "[location_name()] Sensor Array", zlevels = affecting_z)
	adjust_solar_output()


//For a false alarm scenario.
/datum/event/solar_storm/syndicate/adjust_solar_output()
	return

/datum/event/solar_storm/syndicate/radiate()
	return
