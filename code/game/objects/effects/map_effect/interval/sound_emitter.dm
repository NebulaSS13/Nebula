/obj/abstract/map_effect/interval/sound_emitter
// Plays a sound at its location every so often.
	name = "sound emitter"
	icon_state = "sound_emitter"
	/// How loud the sound is. 0 is silent, and 100 is loudest. Please be reasonable with the volume. Note that things like vacuum may affect the volume heard by other mobs.
	var/sound_volume = 50
	/// If the sound will sound somewhat different each time. If a specific frequency is desired, sound_frequency must also be set.
	var/sound_frequency_variance = TRUE
	/// Set to make sounds heard from farther away than normal.
	var/sound_extra_range = 0
	/// Within the 'fallout distance', the sound stays at the same volume, otherwise it attenuates. Higher numbers make the sound fade out more slowly with distance.
	var/sound_fallout = 0
	/// If true, sounds will not be distorted due to the current area's 'sound environment'. It DOES NOT make the sound have a constant volume or z-level wide range, despite the misleading name.
	var/sound_global = FALSE
	/// Sets a specific custom frequency. sound_frequency_variance must be true as well. If sound_frequency is null, but sound_frequency_variance is true, a semi-random frequency will be chosen to the sound each time.
	var/sound_frequency = null
	/// Whether or not clients with the ambience preference disabled will hear this sound.
	var/sound_is_ambience = TRUE
	/// If false, walls will completely muffle the sound.
	var/sound_ignore_walls = TRUE

/obj/abstract/map_effect/interval/sound_emitter/proc/get_sounds_to_play()
	return

/obj/abstract/map_effect/interval/sound_emitter/trigger_map_effect()
	playsound(
		src,
		pick(get_sounds_to_play()),
		sound_volume,
		sound_frequency_variance,
		sound_extra_range,
		sound_fallout,
		sound_global,
		sound_frequency,
		sound_is_ambience,
		sound_ignore_walls
	)
	..()

/obj/abstract/map_effect/interval/sound_emitter/footsteps_wood
	interval_lower_bound = 5 SECONDS
	interval_upper_bound = 30 SECONDS

/obj/abstract/map_effect/interval/sound_emitter/footsteps_wood/get_sounds_to_play()
	var/static/list/sounds_to_play = list(
		'sound/effects/footstep/wood1.ogg',
		'sound/effects/footstep/wood5.ogg',
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor5.ogg'
	)
	return sounds_to_play
