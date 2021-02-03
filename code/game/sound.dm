/proc/playsound(atom/source, soundin, vol as num, vary, extrarange as num, falloff, is_global, frequency, is_ambiance = 0,  ignore_walls = TRUE, zrange = 2, override_env, envdry, envwet)
	if(isarea(source))
		error("[source] is an area and is trying to make the sound: [soundin]")
		return

	soundin = get_sfx(soundin) // same sound for everyone
	frequency = vary && isnull(frequency) ? get_rand_frequency() : frequency // Same frequency for everybody

	var/turf/turf_source = get_turf(source)
	var/maxdistance = (world.view + extrarange) * 2

 	// Looping through the player list has the added bonus of working for mobs inside containers
	var/list/listeners = GLOB.player_list
	if(!ignore_walls) //these sounds don't carry through walls
		listeners = listeners & hearers(maxdistance, turf_source)

	for(var/P in listeners)
		var/mob/M = P
		if(!M || !M.client)
			continue

		if(get_dist(M, turf_source) <= maxdistance)
			var/turf/T = get_turf(M)

			if(T && (T.z == turf_source.z || (zrange && AreConnectedZLevels(T.z, turf_source.z) && abs(T.z - turf_source.z) <= zrange)) && (!is_ambiance || M.get_preference_value(/datum/client_preference/play_ambiance) == GLOB.PREF_YES))
				M.playsound_local(turf_source, soundin, vol, vary, frequency, falloff, is_global, extrarange, override_env, envdry, envwet)

var/const/FALLOFF_SOUNDS = 0.5

//Applies mob-specific and environment specific adjustments to volume value given
/proc/adjust_volume_for_hearer(var/volume, var/turf/turf_source, var/atom/listener)
	if(ismob(listener))
		var/mob/M = listener
		if(M.ear_deaf)
			return 0
		volume *= M.get_sound_volume_multiplier()

	var/turf/T = get_turf(listener)
	var/datum/gas_mixture/hearer_env = T?.return_air()
	var/datum/gas_mixture/source_env = turf_source?.return_air()

	if(!hearer_env || !source_env)
		return 0

	var/pressure_factor = 1.0
	if (hearer_env && source_env)
		var/pressure = min(hearer_env.return_pressure(), source_env.return_pressure())
		if (pressure < ONE_ATMOSPHERE)
			pressure_factor = max((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
	else //in space
		pressure_factor = 0

	if (get_dist(T, turf_source) <= 1)
		pressure_factor = max(pressure_factor, 0.15)	//hearing through contact

	volume *= pressure_factor

	if(istype(T,/turf/simulated) && istype(turf_source,/turf/simulated))
		var/turf/simulated/sim_source = turf_source
		var/turf/simulated/sim_destination = T
		if(sim_destination.zone != sim_source.zone)
			volume -= 30
	return volume

/mob/proc/playsound_local(var/turf/turf_source, soundin, vol as num, vary, frequency, falloff, is_global, extrarange, override_env, envdry, envwet)
	if(!src.client || ear_deaf > 0)
		return

	var/sound/S = soundin
	if(!istype(S))
		soundin = get_sfx(soundin)
		S = sound(soundin)
		S.wait = 0 //No queue
		S.channel = 0 //Any channel
		S.volume = vol
		S.environment = -1
		if(frequency)
			S.frequency = frequency
		else if (vary)
			S.frequency = get_rand_frequency()

	var/turf/T = get_turf(src)
	if(!is_global)
		S.volume = adjust_volume_for_hearer(S.volume, turf_source, src)
	// 3D sounds, the technology is here!

	if(isturf(turf_source))
		//sound volume falloff with distance
		var/distance = get_dist(T, turf_source)

		S.volume -= max(distance - (world.view + extrarange), 0) * 2 //multiplicative falloff to add on top of natural audio falloff.

		if (S.volume <= 0)
			return //no volume means no sound

		var/dx = turf_source.x - T.x // Hearing from the right/left
		S.x = dx
		var/dz = turf_source.y - T.y // Hearing from infront/behind
		S.z = dz
		var/dy = (turf_source.z - T.z) * ZSOUND_DISTANCE_PER_Z // Hearing from above/below. There is ceiling in 2d spessmans.
		S.y = (dy < 0) ? dy - 1 : dy + 1 //We want to make sure there's *always* at least one extra unit of distance. This helps normalize sound that's emitting from the turf you're on.
		S.falloff = (falloff ? falloff : FALLOFF_SOUNDS)

		if(!override_env)
			envdry = abs(turf_source.z - T.z) * ZSOUND_DRYLOSS_PER_Z

	if(!is_global)

		if(istype(src,/mob/living/))
			var/mob/living/carbon/M = src
			if (istype(M) && M.hallucination_power > 50 && LAZYACCESS(M.chem_effects, CE_MIND) < 1)
				S.environment = PSYCHOTIC
			else if (M.drugged)
				S.environment = DRUGGED
			else if (M.drowsyness)
				S.environment = DIZZY
			else if (M.confused)
				S.environment = DIZZY
			else if (M.stat == UNCONSCIOUS)
				S.environment = UNDERWATER
			else if (T?.is_flooded(M.lying))
				S.environment = UNDERWATER
			else
				var/area/A = get_area(src)
				S.environment = A.sound_env

		else
			var/area/A = get_area(src)
			S.environment = A.sound_env

	var/list/echo_list = new(18)
	echo_list[ECHO_DIRECT] = envdry
	echo_list[ECHO_ROOM] = envwet
	S.echo = echo_list

	sound_to(src, S)

/client/proc/playtitlemusic()
	if(get_preference_value(/datum/client_preference/play_lobby_music) == GLOB.PREF_YES)
		GLOB.using_map.lobby_track.play_to(src)

/proc/get_rand_frequency()
	return rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

/proc/get_sfx(soundin)
	if(istext(soundin))
		switch(soundin)
			if ("shatter") soundin = pick(GLOB.shatter_sound)
			if ("explosion") soundin = pick(GLOB.explosion_sound)
			if ("sparks") soundin = pick(GLOB.spark_sound)
			if ("rustle") soundin = pick(GLOB.rustle_sound)
			if ("punch") soundin = pick(GLOB.punch_sound)
			if ("light_strike") soundin = pick(GLOB.light_strike_sound)
			if ("clownstep") soundin = pick(GLOB.clown_sound)
			if ("swing_hit") soundin = pick(GLOB.swing_hit_sound)
			if ("hiss") soundin = pick(GLOB.hiss_sound)
			if ("pageturn") soundin = pick(GLOB.page_sound)
			if ("fracture") soundin = pick(GLOB.fracture_sound)
			if ("light_bic") soundin = pick(GLOB.lighter_sound)
			if ("keyboard") soundin = pick(GLOB.keyboard_sound)
			if ("keystroke") soundin = pick(GLOB.keystroke_sound)
			if ("switch") soundin = pick(GLOB.switch_sound)
			if ("button") soundin = pick(GLOB.button_sound)
			if ("chop") soundin = pick(GLOB.chop_sound)
			if ("glasscrack") soundin = pick(GLOB.glasscrack_sound)
	return soundin
