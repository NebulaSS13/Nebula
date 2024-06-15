/proc/emote_replace_target_tokens(var/msg, var/atom/target)
	. = msg
	if(istype(target))
		var/decl/pronouns/target_gender = target.get_pronouns()
		. = replacetext(., "$TARGET_S$",     target_gender.s)
		. = replacetext(., "$TARGET_THEY$",  target_gender.he)
		. = replacetext(., "$TARGET_THEM$",  target_gender.him)
		. = replacetext(., "$TARGET_THEIR$", target_gender.his)
		. = replacetext(., "$TARGET_SELF$",  target_gender.self)
		. = replacetext(., "$TARGET$",       "<b>\the [target]</b>")

/proc/emote_replace_user_tokens(var/msg, var/atom/user)
	. = msg
	if(istype(user))
		var/decl/pronouns/user_gender = user.get_pronouns()
		. = replacetext(., "$USER_S$",     user_gender.s)
		. = replacetext(., "$USER_THEY$",  user_gender.he)
		. = replacetext(., "$USER_THEM$",  user_gender.him)
		. = replacetext(., "$USER_THEIR$", user_gender.his)
		. = replacetext(., "$USER_SELF$",  user_gender.self)
		. = replacetext(., "$USER$",       "<b>\the [user]</b>")

// Note about emote messages:
// - $USER$ / $TARGET$ will be replaced with the relevant name, in bold.
// - $USER_THEM$ / $TARGET_THEM$ / $USER_THEIR$ / $TARGET_THEIR$ will be replaced with a
//   gender-appropriate version of the same.
// - Impaired messages do not do any substitutions.

var/global/list/_emotes_by_key

/proc/get_emote_by_key(var/key)
	if(!global._emotes_by_key)
		decls_repository.get_decls_of_type(/decl/emote) // _emotes_by_key will be updated in emote Initialize()
	return global._emotes_by_key[key]

/decl/emote
	abstract_type = /decl/emote
	/// Command to use emote ie. '*[key]'
	var/key
	/// First person message ('You do a flip!')
	var/emote_message_1p
	/// Third person message ('Urist McShitter does a flip!')
	var/emote_message_3p
	/// First person message for robits.
	var/emote_message_synthetic_1p
	/// Third person message for robits.
	var/emote_message_synthetic_3p

	/// 'You do a flip at Urist McTarget!'
	var/emote_message_1p_target
	/// 'Urist McShitter does a flip at Urist McTarget!'
	var/emote_message_3p_target
	/// First person targeted message for robits.
	var/emote_message_synthetic_1p_target
	/// Third person targeted message for robits.
	var/emote_message_synthetic_3p_target

	/// A message to send over the radio if one picks up this emote.
	var/emote_message_radio
	/// As above, but for synthetics.
	var/emote_message_radio_synthetic

	/// A message to show if the emote is audible and the user is muzzled.
	var/emote_message_muffled
	/// Deaf/blind message ('You hear someone flipping out.', 'You see someone opening and closing their mouth')
	var/emote_message_impaired

	/// Two-dimensional array: first is list of genders, associated to a list of the sound effects to use.
	var/list/emote_sound = null
	/// If set to a string, will ask the bodytype of the user four a sound effect using the string.
	var/bodytype_emote_sound
	/// Volume of sound to play.
	var/emote_volume = 50
	/// As above, but used when check_synthetic() is true.
	var/emote_volume_synthetic = 50

	/// This sound will be passed to the entire connected z-chunk if set.
	var/broadcast_sound
	/// As above, but for broadcast.
	var/bodytype_broadcast_sound
	/// Volume for broadcast sound.
	var/broadcast_volume = 15
	/// How far does the sound broadcast.
	var/broadcast_distance

	/// Audible/visual flag
	var/message_type = VISIBLE_MESSAGE
	/// Whether or not this emote -must- have a target.
	var/mandatory_targetted_emote
	/// Can this emote be used while restrained?
	var/check_restraints
	/// falsy, or a range outside which the emote will not work
	var/check_range
	/// For emotes with physical effecets.
	var/check_adjacent
	/// Do we need to be awake to emote this?
	var/conscious = TRUE
	/// If >0, restricts emote visibility to viewers within range.
	var/emote_range = 0
	/// Time in ds that this emote will block further emote use (spam prevention).
	var/emote_delay = 1 SECOND

	/// How long will we be on cooldown for this emote.
	var/emote_cooldown
	/// Assoc list of weakref to mob to next emote.
	var/list/emote_cooldowns = list()

/decl/emote/Initialize()
	. = ..()
	if(key)
		LAZYSET(global._emotes_by_key, key, src)

/decl/emote/validate()
	. = ..()
	var/list/all_emotes = decls_repository.get_decls_of_type(/decl/emote)
	for(var/emote_type in all_emotes)
		var/decl/emote/emote = all_emotes[emote_type]
		if(emote == src)
			continue
		if(key == emote.key)
			. += "non-unique key, overlaps with [emote.type]"

// validate() is never called outside of unit testing, but
// this feels foul to have in non-unit test main code.
#ifdef UNIT_TEST
	var/static/obj/dummy_emote_target = new
	dummy_emote_target.name = "\proper Barry's hat"
	var/static/mob/dummy_emote_user = new
	dummy_emote_user.name = "\proper Barry"
	dummy_emote_user.set_gender(MALE)
	// This should catch misspelled tokens, TARGET_HIM etc as well as leftover TARGET and USER.
	var/static/list/tokens = list("$", "TARGET", "USER")
	var/all_strings = list(
		"emote_message_1p"                  = emote_message_1p,
		"emote_message_3p"                  = emote_message_3p,
		"emote_message_synthetic_1p"        = emote_message_synthetic_1p,
		"emote_message_synthetic_3p"        = emote_message_synthetic_3p,
		"emote_message_1p_target"           = emote_message_1p_target,
		"emote_message_3p_target"           = emote_message_3p_target,
		"emote_message_synthetic_1p_target" = emote_message_synthetic_1p_target,
		"emote_message_synthetic_3p_target" = emote_message_synthetic_3p_target
	)
	for(var/string_key in all_strings)
		var/emote_string = all_strings[string_key]
		if(!length(emote_string))
			continue
		emote_string = emote_replace_target_tokens(emote_string, dummy_emote_target)
		emote_string = emote_replace_user_tokens(emote_string, dummy_emote_user)
		emote_string = uppertext(emote_string)
		for(var/token in tokens)
			if(findtext(emote_string, token))
				. += "malformed emote token [token] in [string_key]"
#endif

/decl/emote/proc/get_emote_message_1p(var/atom/user, var/atom/target, var/extra_params)
	if(target)
		if(emote_message_synthetic_1p_target && check_synthetic(user))
			return emote_message_synthetic_1p_target
		return emote_message_1p_target
	if(emote_message_synthetic_1p && check_synthetic(user))
		return emote_message_synthetic_1p
	return emote_message_1p

/decl/emote/proc/get_emote_message_3p(var/atom/user, var/atom/target, var/extra_params)
	if(target)
		if(emote_message_synthetic_3p_target && check_synthetic(user))
			return emote_message_synthetic_3p_target
		return emote_message_3p_target
	if(emote_message_synthetic_3p && check_synthetic(user))
		return emote_message_synthetic_3p
	return emote_message_3p

/decl/emote/proc/get_emote_sound(var/atom/user)

	var/use_emote_sound = emote_sound
	if(bodytype_emote_sound && ismob(user))
		var/mob/user_mob = user
		var/bodytype_sounds = user_mob?.get_bodytype()?.emote_sounds[bodytype_emote_sound]
		if(length(bodytype_sounds))
			use_emote_sound = pick(bodytype_sounds)

	if(use_emote_sound)
		. = list(
			"sound" = use_emote_sound,
			"vol" =   check_synthetic(user) ? emote_volume_synthetic : emote_volume
		)

	var/use_broadcast_sound = broadcast_sound
	if(bodytype_broadcast_sound && ismob(user))
		var/mob/user_mob = user
		var/bodytype_sounds = user_mob?.get_bodytype()?.broadcast_emote_sounds[bodytype_broadcast_sound]
		if(length(bodytype_sounds))
			use_broadcast_sound = pick(bodytype_sounds)

	if(use_broadcast_sound)
		LAZYINITLIST(.)
		LAZYSET(., "broadcast", use_broadcast_sound)

/decl/emote/proc/finalize_target(atom/user, atom/target)
	return istype(target) && (!check_adjacent || target.Adjacent(user))

/decl/emote/proc/do_emote(var/atom/user, var/extra_params)

	if(ismob(user) && check_restraints)
		var/mob/M = user
		if(M.restrained())
			to_chat(user, SPAN_WARNING("You are restrained and cannot do that."))
			return FALSE

	if(emote_cooldown)
		var/user_ref = "\ref[user]"
		var/next_emote = emote_cooldowns[user_ref]
		if(world.time < next_emote)
			to_chat(user, SPAN_WARNING("You cannot use this emote again for another [round((next_emote - world.time)/(1 SECOND))] second\s."))
			return FALSE
		emote_cooldowns[user_ref] = (world.time + emote_cooldown)

	var/atom/target
	if(can_target() && extra_params)
		var/target_dist
		extra_params = trim(lowertext(extra_params))
		for(var/atom/thing in view((isnull(check_range) ? world.view : check_range), user))

			if(!isturf(thing.loc))
				continue

			var/new_target_dist = get_dist(thing, user)
			if(!isnull(target_dist) && target_dist > new_target_dist)
				continue

			if(findtext(lowertext(thing.name), extra_params))
				target_dist = new_target_dist
				target = thing

		if(!finalize_target(user, target))
			to_chat(user, SPAN_WARNING("You cannot see a '[extra_params]' within range."))

	if(mandatory_targetted_emote && !target)
		to_chat(user, SPAN_WARNING("You can't do that to thin air."))
		return FALSE

	var/use_1p = get_emote_message_1p(user, target, extra_params)
	if(use_1p)
		if(target)
			use_1p = emote_replace_target_tokens(use_1p, target)
		use_1p = "<span class='emote'>[capitalize(emote_replace_user_tokens(use_1p, user))]</span>"

	var/use_3p = get_emote_message_3p(user, target, extra_params)
	if(use_3p)
		if(target)
			use_3p = emote_replace_target_tokens(use_3p, target)
		use_3p = "<span class='emote'>[emote_replace_user_tokens(use_3p, user)]</span>"

	var/use_radio = get_radio_message(user)
	if(use_radio)
		if(target)
			use_radio = emote_replace_target_tokens(use_radio, target)
		use_radio = emote_replace_user_tokens(use_radio, user)

	var/use_range = emote_range
	if (!use_range)
		use_range = world.view

	if(ismob(user))
		var/mob/M = user
		if(message_type == AUDIBLE_MESSAGE)
			if(isliving(user))
				var/mob/living/L = user
				if(HAS_STATUS(L, STAT_SILENCE))
					M.visible_message(message = "[user] opens their mouth silently!", self_message = "You cannot say anything!", blind_message = emote_message_impaired, check_ghosts = /datum/client_preference/ghost_sight)
					return FALSE
				M.audible_message(message = use_3p, self_message = use_1p, deaf_message = emote_message_impaired, hearing_distance = use_range, check_ghosts = /datum/client_preference/ghost_sight, radio_message = use_radio)
		else
			M.visible_message(message = use_3p, self_message = use_1p, blind_message = emote_message_impaired, range = use_range, check_ghosts = /datum/client_preference/ghost_sight)

	do_extra(user, target)
	do_sound(user)
	return TRUE

/decl/emote/proc/get_radio_message(var/atom/user)
	if(emote_message_radio_synthetic && check_synthetic(user))
		return emote_message_radio_synthetic
	return emote_message_radio

/decl/emote/proc/do_extra(var/atom/user, var/atom/target)
	return

/decl/emote/proc/do_sound(var/atom/user)

	var/turf/user_turf = get_turf(user)
	if(!istype(user_turf))
		return

	var/list/use_sound = get_emote_sound(user)
	if(!islist(use_sound) || length(use_sound) < 2)
		return

	var/sound_to_play = use_sound["sound"]
	if(sound_to_play)
		if(islist(sound_to_play))
			if(sound_to_play[user.gender])
				sound_to_play = sound_to_play[user.gender]
			if(islist(sound_to_play) && length(sound_to_play))
				sound_to_play = pick(sound_to_play)
		if(sound_to_play)
			playsound(user.loc, sound_to_play, use_sound["vol"], 0)

	var/sound_to_broadcast = use_sound["broadcast"]
	if(!sound_to_broadcast)
		return

	// We can't always use GetConnectedZlevels() here because it includes horizontally connected z-levels, which don't work well with our distance checking.
	var/list/affected_levels
	if(isnull(broadcast_distance))
		affected_levels = SSmapping.get_connected_levels(user_turf.z)
	else
		affected_levels = list(user_turf.z)
		// Climb to the top of the stack.
		var/turf/checking = user_turf
		while(checking && HasAbove(checking.z))
			checking = GetAbove(checking)
			affected_levels += checking.z
		// Fall to the bottom of the stack.
		checking = user_turf
		while(checking && HasBelow(checking.z))
			checking = GetBelow(checking)
			affected_levels += checking.z

	var/list/close_listeners = hearers(world.view, user_turf)
	for(var/listener in player_list)
		var/turf/T = get_turf(listener)
		if(!istype(T) || !(T.z in affected_levels) || (listener in close_listeners))
			continue
		var/turf/reference_point = locate(T.x, T.y, user_turf.z)
		if(!reference_point)
			continue
		var/direction = get_dir(reference_point, user_turf)
		if(!direction)
			continue
		if(!isnull(broadcast_distance) && get_dist(reference_point, user_turf) > broadcast_distance)
			continue
		broadcast_emote_to(sound_to_broadcast, listener, user_turf.z, direction)

/decl/emote/proc/broadcast_emote_to(var/send_sound, var/mob/target, var/origin_z, var/direction)
	var/turf/sound_origin = get_turf(target)
	target.playsound_local(get_step(sound_origin, direction) || sound_origin, send_sound, broadcast_volume)
	return TRUE

/decl/emote/proc/mob_can_use(mob/living/user, assume_available = FALSE)
	return istype(user) && user.stat != DEAD && (assume_available || (type in user.get_default_emotes()))

/decl/emote/proc/can_target()
	return (emote_message_1p_target || emote_message_3p_target)

/decl/emote/dd_SortValue()
	return key

/decl/emote/proc/check_synthetic(var/mob/living/user)
	. = istype(user) && user.isSynthetic()
	if(!. && message_type == AUDIBLE_MESSAGE && user.should_have_organ(BP_LUNGS))
		var/obj/item/organ/internal/lungs/L = GET_INTERNAL_ORGAN(user, BP_LUNGS)
		if(BP_IS_PROSTHETIC(L))
			. = TRUE
