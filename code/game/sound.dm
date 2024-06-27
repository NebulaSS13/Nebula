/proc/playsound(atom/source, soundin, vol as num, vary, extrarange as num, falloff, is_global, frequency, is_ambiance = 0,  ignore_walls = TRUE, zrange = 2, override_env, envdry, envwet)
	if(isarea(source))
		error("[source] is an area and is trying to make the sound: [soundin]")
		return

	soundin = get_sfx(soundin) // same sound for everyone
	frequency = vary && isnull(frequency) ? get_rand_frequency() : frequency // Same frequency for everybody

	var/turf/turf_source = get_turf(source)
	var/maxdistance = (world.view + extrarange) * 2

 	// Looping through the player list has the added bonus of working for mobs inside containers
	var/list/listeners = global.player_list
	if(!ignore_walls) //these sounds don't carry through walls
		listeners = listeners & hearers(maxdistance, turf_source)

	for(var/P in listeners)
		var/mob/M = P
		if(!M || !M.client)
			continue

		if(get_dist(M, turf_source) <= maxdistance)
			var/turf/T = get_turf(M)

			if(T && (T.z == turf_source.z || (zrange && SSmapping.are_connected_levels(T.z, turf_source.z) && abs(T.z - turf_source.z) <= zrange)) && (!is_ambiance || M.get_preference_value(/datum/client_preference/play_ambiance) == PREF_YES))
				M.playsound_local(turf_source, soundin, vol, vary, frequency, falloff, is_global, extrarange, override_env, envdry, envwet)

var/global/const/FALLOFF_SOUNDS = 0.5

//Applies mob-specific and environment specific adjustments to volume value given
/proc/adjust_volume_for_hearer(var/volume, var/turf/turf_source, var/atom/listener)
	if(ismob(listener))
		var/mob/M = listener
		if(GET_STATUS(M, STAT_DEAF))
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

	if(!turf_source.blocks_air && T.zone != turf_source.zone)
		volume = round(volume * 0.7) // quick and dirty volume reduction from ZAS flood fill
	return volume

/mob/proc/playsound_local(var/turf/turf_source, soundin, vol as num, vary, frequency, falloff, is_global, extrarange, override_env, envdry, envwet)
	if(!src.client || is_deaf())
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

		if(isliving(src))
			var/mob/living/M = src
			if (istype(M) && M.hallucination_power > 50 && GET_CHEMICAL_EFFECT(M, CE_MIND) < 1)
				S.environment = PSYCHOTIC
			else if (HAS_STATUS(M, STAT_DRUGGY))
				S.environment = DRUGGED
			else if(HAS_STATUS(M, STAT_DROWSY))
				S.environment = DIZZY
			else if (HAS_STATUS(M, STAT_CONFUSE))
				S.environment = DIZZY
			else if (M.stat == UNCONSCIOUS)
				S.environment = UNDERWATER
			else if (T?.is_flooded(M.current_posture.prone))
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
	if(get_preference_value(/datum/client_preference/play_lobby_music) == PREF_YES && global.using_map.lobby_track)
		global.using_map.lobby_track.play_to(src)

/proc/get_rand_frequency()
	return rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

/proc/get_sfx(soundin)
	if(istext(soundin))
		switch(soundin)
			if ("shatter") soundin = pick(global.shatter_sound)
			if ("explosion") soundin = pick(global.explosion_sound)
			if ("sparks") soundin = pick(global.spark_sound)
			if ("rustle") soundin = pick(global.rustle_sound)
			if ("punch") soundin = pick(global.punch_sound)
			if ("light_strike") soundin = pick(global.light_strike_sound)
			if ("clownstep") soundin = pick(global.clown_sound)
			if ("swing_hit") soundin = pick(global.swing_hit_sound)
			if ("hiss") soundin = pick(global.hiss_sound)
			if ("pageturn") soundin = pick(global.page_sound)
			if ("fracture") soundin = pick(global.fracture_sound)
			if ("light_bic") soundin = pick(global.lighter_sound)
			if ("keyboard") soundin = pick(global.keyboard_sound)
			if ("keystroke") soundin = pick(global.keystroke_sound)
			if ("switch") soundin = pick(global.switch_sound)
			if ("button") soundin = pick(global.button_sound)
			if ("chop") soundin = pick(global.chop_sound)
			if ("glasscrack") soundin = pick(global.glasscrack_sound)
			if ("tray_hit") soundin = pick(global.tray_hit_sound)
	return soundin


///Volume to play DTMF key sounds at. They're pretty loud, so 15 is fine.
#define VOL_DTMF_KEY 15

/**
	Plays a DTMF tone (Telephone key press sound) for any valid telephone key.
	* `source`: The atom that's producing the sound.
	* `key`: The character of the key pressed.
	* `user`: The mob actually pressing the key.
	* `user_only`: Whether the sound should be only heard by the user mob. (Sent to the user's client only)
	* Returns FALSE if the key is invalid, TRUE if the key was valid and we played a sound.
 */
/proc/play_dtmf_key_sound(atom/source, key, mob/user, user_only = FALSE)
	//NOTE: File paths are all in here inside a big switch, so they're cached into the rsc!
	var/sound_path
	switch(lowertext(key))
		if("0")
			sound_path = 'sound/machines/phone/key-0.ogg'
		if("1")
			sound_path = 'sound/machines/phone/key-1.ogg'
		if("2", "a", "b", "c")
			sound_path = 'sound/machines/phone/key-2.ogg'
		if("3", "d", "e", "f")
			sound_path = 'sound/machines/phone/key-3.ogg'
		if("4", "g", "h", "i")
			sound_path = 'sound/machines/phone/key-4.ogg'
		if("5", "j", "k", "l")
			sound_path = 'sound/machines/phone/key-5.ogg'
		if("6", "m", "n", "o")
			sound_path = 'sound/machines/phone/key-6.ogg'
		if("7", "p", "q", "r", "s")
			sound_path = 'sound/machines/phone/key-7.ogg'
		if("8", "t", "u", "v")
			sound_path = 'sound/machines/phone/key-8.ogg'
		if("9", "w", "x", "y", "z")
			sound_path = 'sound/machines/phone/key-9.ogg'
		if("*", "⚹") //Asterisk and actual phone keypad star char for completeness
			sound_path = 'sound/machines/phone/key-star.ogg'
		if("#", "⌗") //hash symbol and actual phone keypad square char for completeness
			sound_path = 'sound/machines/phone/key-square.ogg'
		else
			return FALSE

	if(user_only)
		sound_to(user, sound(sound_path, volume = VOL_DTMF_KEY))
	else
		playsound(source, sound_path, VOL_DTMF_KEY, FALSE, 0, 2, envdry = 50, envwet = 10) //tone down the reverbs on this cause it sounds really weird
	return TRUE

#undef VOL_DTMF_KEY