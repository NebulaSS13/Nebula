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
	/// As above, but used when check_synthetic() is true.
	var/list/emote_sound_synthetic
	/// Volume of sound to play.
	var/emote_volume = 50
	/// As above, but used when check_synthetic() is true.
	var/emote_volume_synthetic = 50

	/// Audible/visual flag
	var/message_type = VISIBLE_MESSAGE
	/// Whether or not this emote -must- have a target.
	var/mandatory_targetted_emote
	/// Can this emote be used while restrained?
	var/check_restraints
	/// falsy, or a range outside which the emote will not work
	var/check_range
	/// Do we need to be awake to emote this?
	var/conscious = TRUE
	/// If >0, restricts emote visibility to viewers within range.
	var/emote_range = 0
	// Time in ds that this emote will block further emote use (spam prevention).
	var/emote_delay = 1 SECOND

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
		emote_string = replace_target_tokens(emote_string, dummy_emote_target)
		emote_string = replace_user_tokens(emote_string, dummy_emote_user)
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
	if(check_synthetic(user) && emote_sound_synthetic)
		return list(
			"sound" = emote_sound_synthetic,
			"vol" =   emote_volume_synthetic
		)
	if(emote_sound)
		return list(
			"sound" = emote_sound,
			"vol" =   emote_volume
		)

/decl/emote/proc/do_emote(var/atom/user, var/extra_params)
	if(ismob(user) && check_restraints)
		var/mob/M = user
		if(M.restrained())
			to_chat(user, SPAN_WARNING("You are restrained and cannot do that."))
			return

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

		if(!target)
			to_chat(user, SPAN_WARNING("You cannot see a '[extra_params]' within range."))

	if(mandatory_targetted_emote && !target)
		to_chat(user, SPAN_WARNING("You can't do that to thin air."))
		return

	var/use_1p = get_emote_message_1p(user, target, extra_params)
	if(use_1p)
		if(target)
			use_1p = replace_target_tokens(use_1p, target)
		use_1p = "<span class='emote'>[capitalize(replace_user_tokens(use_1p, user))]</span>"

	var/use_3p = get_emote_message_3p(user, target, extra_params)
	if(use_3p)
		if(target)
			use_3p = replace_target_tokens(use_3p, target)
		use_3p = "<span class='emote'>[replace_user_tokens(use_3p, user)]</span>"

	var/use_radio = get_radio_message(user)
	if(use_radio)
		if(target)
			use_radio = replace_target_tokens(use_radio, target)
		use_radio = replace_user_tokens(use_radio, user)

	var/use_range = emote_range
	if (!use_range)
		use_range = world.view

	if(ismob(user))
		var/mob/M = user
		if(message_type == AUDIBLE_MESSAGE)
			if(isliving(user))
				var/mob/living/L = user
				if(HAS_STATUS(L, STAT_SILENCE))
					M.visible_message(message = "[user] opens their mouth silently!", self_message = "You cannot say anything!", blind_message = emote_message_impaired, checkghosts = /datum/client_preference/ghost_sight)
					return
				else
					M.audible_message(message = use_3p, self_message = use_1p, deaf_message = emote_message_impaired, hearing_distance = use_range, checkghosts = /datum/client_preference/ghost_sight, radio_message = use_radio)
		else
			M.visible_message(message = use_3p, self_message = use_1p, blind_message = emote_message_impaired, range = use_range, checkghosts = /datum/client_preference/ghost_sight)

	do_extra(user, target)
	do_sound(user)

/decl/emote/proc/replace_target_tokens(var/msg, var/atom/target)
	. = msg
	if(istype(target))
		var/decl/pronouns/target_gender = target.get_pronouns()
		. = replacetext(., "$TARGET_THEM$",  target_gender.him)
		. = replacetext(., "$TARGET_THEIR$", target_gender.his)
		. = replacetext(., "$TARGET_SELF$",  target_gender.self)
		. = replacetext(., "$TARGET$",       "<b>\the [target]</b>")

/decl/emote/proc/replace_user_tokens(var/msg, var/atom/user)
	. = msg
	if(istype(user))
		var/decl/pronouns/user_gender = user.get_pronouns()
		. = replacetext(., "$USER_THEM$",  user_gender.him)
		. = replacetext(., "$USER_THEIR$", user_gender.his)
		. = replacetext(., "$USER_SELF$",  user_gender.self)
		. = replacetext(., "$USER$",       "<b>\the [user]</b>")

/decl/emote/proc/get_radio_message(var/atom/user)
	if(emote_message_radio_synthetic && check_synthetic(user))
		return emote_message_radio_synthetic
	return emote_message_radio

/decl/emote/proc/do_extra(var/atom/user, var/atom/target)
	return

/decl/emote/proc/do_sound(var/atom/user)
	var/use_emote_sound = get_emote_sound(user)
	if(!use_emote_sound)
		return
	var/sound_to_play = use_emote_sound
	if(islist(use_emote_sound))
		sound_to_play = use_emote_sound[user.gender] || use_emote_sound
		sound_to_play = pick(sound_to_play)
	return playsound(user.loc, sound_to_play, 50, 0)

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
