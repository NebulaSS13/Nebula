/*
	A sound player/manager for looping 3D sound effects.

	Due to how the BYOND sound engine works a sound datum must be played on a specific channel for updates to work properly.
	If a channel is not assigned it will just result in a new sound effect playing, even if re-using the same datum instance.
	We also use the channel to play a null-sound on Stop(), just in case BYOND clients don't like having a large nuber, albeit stopped, looping sounds.

	As such there is a maximum limit of 1024 sound sources, with further limitations due to some channels already being potentially in use.
	However, multiple sources may share the same sound_id and there is a best-effort attempt to play the closest source where possible.
	The line above is currently a lie. Will probably just have to enforce moderately short sound ranges.
*/

/proc/play_looping_sound(var/atom/source, var/sound_id, var/sound, var/volume, var/range, var/falloff = 1, var/echo, var/frequency, var/prefer_mute, var/datum/client_preference/preference, var/streaming)
	var/decl/sound_player/sound_player = GET_DECL(/decl/sound_player)
	return sound_player.PlayLoopingSound(source, sound_id, sound, volume, range, falloff, echo, frequency, prefer_mute, preference, streaming)

/proc/get_sound_channel(var/datum/sound_token/sound_token)
	var/decl/sound_player/sound_player = GET_DECL(/decl/sound_player)
	return sound_player.PrivGetChannel(sound_token)

/decl/sound_player
	var/list/taken_channels // taken_channels and source_id_uses can be merged into one but would then require a meta-object to store the different values I desire.
	var/list/sound_tokens_by_sound_id

/decl/sound_player/Initialize()
	. = ..()
	taken_channels = list()
	sound_tokens_by_sound_id = list()

//This can be called if either we're doing whole sound setup ourselves or it will be as part of from-file sound setup
/decl/sound_player/proc/PlaySoundDatum(var/atom/source, var/sound_id, var/sound/sound, var/range, var/prefer_mute, var/datum/client_preference/preference, var/streaming)
	var/token_type = isnum(sound.environment) ? /datum/sound_token : /datum/sound_token/static_environment
	return new token_type(source, sound_id, sound, range, prefer_mute, preference, streaming)

/decl/sound_player/proc/PlayLoopingSound(var/atom/source, var/sound_id, var/sound, var/volume, var/range, var/falloff = 1, var/echo, var/frequency, var/prefer_mute, var/datum/client_preference/preference, var/streaming)
	var/sound/S = istype(sound, /sound) ? sound : new(sound)
	S.environment = 0 // Ensures a 3D effect even if x/y offset happens to be 0 the first time it's played
	S.volume  = volume
	S.falloff = falloff
	S.echo = echo
	S.frequency = frequency
	S.repeat = TRUE

	return PlaySoundDatum(source, sound_id, S, range, prefer_mute, preference, streaming)

/decl/sound_player/proc/PrivStopSound(var/datum/sound_token/sound_token)
	var/channel = sound_token.sound.channel
	var/sound_id = sound_token.sound_id

	var/sound_tokens = sound_tokens_by_sound_id[sound_id]
	if(!(sound_token in sound_tokens))
		return
	sound_tokens -= sound_token
	if(length(sound_tokens))
		return

	global.sound_channels.ReleaseChannel(channel)
	taken_channels -= sound_id
	sound_tokens_by_sound_id -= sound_id

/decl/sound_player/proc/PrivGetChannel(var/datum/sound_token/sound_token)
	var/sound_id = sound_token.sound_id

	. = taken_channels[sound_id] // Does this sound_id already have an assigned channel?
	if(!.) // If not, request a new one.
		. = global.sound_channels.RequestChannel(sound_id)
		if(!.) // Oh no, still no channel. Abort
			return
		taken_channels[sound_id] = .

	var/sound_tokens = sound_tokens_by_sound_id[sound_id]
	if(!sound_tokens)
		sound_tokens = list()
		sound_tokens_by_sound_id[sound_id] = sound_tokens
	sound_tokens += sound_token

/*
	Outwardly this is a merely a toke/little helper that a user utilize to adjust sounds as desired (and possible).
	In reality this is where the heavy-lifting happens.
*/
/datum/sound_token
	var/atom/source    // Where the sound originates from
	var/list/listeners // Atoms hearing this sound
	var/range          // How many turfs away the sound will stop playing completely
	var/prefer_mute    // If sound should be muted instead of stopped when mob moves out of range. In the general case this should be avoided because listeners will remain tracked.
	var/sound/sound    // Sound datum, holds most sound relevant data
	var/sound_id       // The associated sound id, used for cleanup
	var/status = 0     // Paused, muted, running? Global for all listeners
	var/listener_status// Paused, muted, running? Specific for the given listener.
	var/base_volume    // Volume of sound before environment effects
	var/const/SOUND_STOPPED = 0x8000

	var/datum/proximity_trigger/square/proxy_listener
	var/list/can_be_heard_from

	var/datum/client_preference/preference

/datum/sound_token/New(var/atom/source, var/sound_id, var/sound/sound, var/range = 4, var/prefer_mute = FALSE, var/datum/client_preference/preference, var/streaming)
	..()
	if(!istype(source))
		CRASH("Invalid sound source: [log_info_line(source)]")
	if(!istype(sound))
		CRASH("Invalid sound: [log_info_line(sound)]")
	if(sound.repeat && !sound_id)
		CRASH("No sound id given")
	if(!PrivIsValidEnvironment(sound.environment))
		CRASH("Invalid sound environment: [log_info_line(sound.environment)]")

	src.prefer_mute = prefer_mute
	src.range       = range
	src.source      = source
	src.sound       = sound
	src.sound_id    = sound_id
	src.preference  = preference
	base_volume = sound.volume

	if(streaming)
		src.status |= SOUND_STREAM

	if(sound.repeat) // Non-looping sounds may not reserve a sound channel due to the risk of not hearing when someone forgets to stop the token
		var/channel = get_sound_channel(src) //Attempt to find a channel
		if(!isnum(channel))
			CRASH("All available sound channels are in active use.")
		sound.channel = channel
	else
		sound.channel = 0

	listeners = list()
	listener_status = list()

	events_repository.register(/decl/observ/destroyed, source, src, TYPE_PROC_REF(/datum, qdel_self))

	if(ismovable(source))
		proxy_listener = new(source, TYPE_PROC_REF(/datum/sound_token, PrivAddListener), TYPE_PROC_REF(/datum/sound_token, PrivLocateListeners), range, proc_owner = src)
		proxy_listener.register_turfs()

/datum/sound_token/Destroy()
	Stop()
	. = ..()

/datum/sound_token/proc/SetVolume(var/new_volume)
	new_volume = clamp(new_volume, 0, 100)
	if(base_volume == new_volume)
		return
	base_volume = new_volume
	PrivUpdateListeners()

/datum/sound_token/proc/Mute()
	PrivUpdateStatus(status|SOUND_MUTE)

/datum/sound_token/proc/Unmute()
	PrivUpdateStatus(status & ~SOUND_MUTE)

/datum/sound_token/proc/Pause()
	PrivUpdateStatus(status|SOUND_PAUSED)

// Normally called Resume but I don't want to give people false hope about being unable to un-stop a sound
/datum/sound_token/proc/Unpause()
	PrivUpdateStatus(status & ~SOUND_PAUSED)

/datum/sound_token/proc/Stop()
	if(status & SOUND_STOPPED)
		return
	status |= SOUND_STOPPED

	var/sound/null_sound = new(channel = sound.channel)
	for(var/listener in listeners)
		PrivRemoveListener(listener, null_sound)
	listeners = null
	listener_status = null

	events_repository.unregister(/decl/observ/destroyed, source, src, TYPE_PROC_REF(/datum, qdel_self))
	QDEL_NULL(proxy_listener)
	source = null

	var/decl/sound_player/sound_player = GET_DECL(/decl/sound_player)
	sound_player.PrivStopSound(src)

/datum/sound_token/proc/PrivLocateListeners(var/list/prior_turfs, var/list/current_turfs)
	if(status & SOUND_STOPPED)
		return

	can_be_heard_from = current_turfs
	var/current_listeners = all_hearers(source, range)
	var/former_listeners = listeners - current_listeners
	var/new_listeners = current_listeners - listeners

	for(var/listener in former_listeners)
		PrivRemoveListener(listener)

	for(var/listener in new_listeners)
		PrivAddListener(listener)

	for(var/listener in current_listeners)
		PrivUpdateListenerLoc(listener)

/datum/sound_token/proc/PrivUpdateStatus(var/new_status)
	// Once stopped, always stopped. Go ask the player to play the sound again.
	if(status & SOUND_STOPPED)
		return
	if(new_status == status)
		return
	status = new_status
	PrivUpdateListeners()

/datum/sound_token/proc/PrivAddListener(var/atom/listener)
	if(QDELETED(listener) || !check_preference(listener))
		return

	if(isvirtualmob(listener))
		var/mob/observer/virtual/v = listener
		if(!(v.abilities & VIRTUAL_ABILITY_HEAR))
			return
		listener = v.host
	if(listener in listeners)
		return

	listeners += listener

	events_repository.register(/decl/observ/moved, listener, src, TYPE_PROC_REF(/datum/sound_token, PrivUpdateListenerLoc))
	events_repository.register(/decl/observ/destroyed, listener, src, TYPE_PROC_REF(/datum/sound_token, PrivRemoveListener))

	PrivUpdateListenerLoc(listener, FALSE)

/datum/sound_token/proc/PrivRemoveListener(var/atom/listener, var/sound/null_sound)
	null_sound = null_sound || new(channel = sound.channel)
	sound_to(listener, null_sound)
	events_repository.unregister(/decl/observ/moved, listener, src, TYPE_PROC_REF(/datum/sound_token, PrivUpdateListenerLoc))
	events_repository.unregister(/decl/observ/destroyed, listener, src, TYPE_PROC_REF(/datum/sound_token, PrivRemoveListener))
	listeners -= listener
	listener_status -= listener

/datum/sound_token/proc/PrivUpdateListenerLoc(var/atom/listener, var/update_sound = TRUE)
	var/turf/source_turf = get_turf(source)
	var/turf/listener_turf = get_turf(listener)

	var/distance = get_dist(source_turf, listener_turf)
	if(!listener_turf || (distance > range) || !(listener_turf in can_be_heard_from))
		if(prefer_mute)
			listener_status[listener] |= SOUND_MUTE
		else
			PrivRemoveListener(listener)
			return
	else if(prefer_mute)
		listener_status[listener] &= ~SOUND_MUTE

	// Getting runtimes with these vars during supply pod generation, possibly
	// hissing air pipes during changeturf? it's entirely unclear at the moment.
	if(istype(source_turf) && istype(listener_turf))
		sound.volume = adjust_volume_for_hearer(base_volume, source_turf, listener)
		sound.x = source_turf.x - listener_turf.x
		sound.z = source_turf.y - listener_turf.y
		sound.y = 1
		// Far as I can tell from testing, sound priority just doesn't work.
		// Sounds happily steal channels from each other no matter what.
		sound.priority = clamp(255 - distance, 0, 255)
		PrivUpdateListener(listener, update_sound)

/datum/sound_token/proc/PrivUpdateListeners()
	for(var/listener in listeners)
		PrivUpdateListener(listener)

/datum/sound_token/proc/PrivUpdateListener(var/atom/listener, var/update_sound = TRUE)
	if(QDELETED(listener) || !check_preference(listener))
		PrivRemoveListener(listener)
		return

	sound.volume = adjust_volume_for_hearer(base_volume, get_turf(source), listener)
	sound.environment = PrivGetEnvironment(listener)
	sound.status = status|listener_status[listener]
	if(update_sound)
		sound.status |= SOUND_UPDATE
	sound_to(listener, sound)

/datum/sound_token/proc/PrivGetEnvironment(var/atom/listener)
	var/area/A = get_area(listener)
	return A && PrivIsValidEnvironment(A.sound_env) ? A.sound_env : sound.environment

/datum/sound_token/proc/PrivIsValidEnvironment(var/environment)
	if(islist(environment) && length(environment) != 23)
		return FALSE
	if(!isnum(environment) || environment < 0 || environment > 25)
		return FALSE
	return TRUE

// Checking if client want to hear it
/datum/sound_token/proc/check_preference(atom/listener)
	if(preference)
		var/mob/M = listener
		if(istype(M))
			if((M.get_preference_value(preference) != PREF_YES))
				return FALSE
	return TRUE

/datum/sound_token/static_environment/PrivGetEnvironment()
	return sound.environment

/obj/sound_test
	var/sound = 'sound/misc/TestLoop1.ogg'

/obj/sound_test/Initialize()
	. = ..()
	play_looping_sound(src, /obj/sound_test, sound, 50, 3)
