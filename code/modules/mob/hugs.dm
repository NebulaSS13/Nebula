var/global/list/_default_hug_messages = list(
	BP_HEAD = list(
		"$USER$ pats $TARGET$ on the head.",
		"You pat $TARGET$ on the head."
	)
)

/mob/proc/get_hug_zone_messages(var/zone)
	var/decl/bodytype/bodytype = get_bodytype()
	return bodytype?.get_hug_zone_messages(zone) || bodytype?.default_hug_message || global._default_hug_messages[zone]

/mob/proc/get_default_3p_hug_message(mob/living/target)
	if(target && get_dir(src, target) == target.dir)
		return "$USER$ rubs $TARGET$'s back soothingly."
	return "$USER$ hugs $TARGET$ to make $TARGET_THEM$ feel better."

/mob/proc/get_default_1p_hug_message(mob/living/target)
	if(target && get_dir(src, target) == target.dir)
		return "You rub $TARGET$'s back soothingly."
	return "You hug $TARGET$ to make $TARGET_THEM$ feel better."

/mob/proc/attempt_hug(var/mob/living/target, var/hug_3p, var/hug_1p)

	if(!istype(target))
		return FALSE

	var/list/use_hug_messages = target.get_hug_zone_messages(get_target_zone())
	if(length(use_hug_messages) >= 2)
		hug_3p = use_hug_messages[1]
		hug_1p = use_hug_messages[2]

	if(isnull(hug_3p) || isnull(hug_1p))
		hug_1p = get_default_1p_hug_message(target)
		hug_3p = get_default_3p_hug_message(target)

	if(!hug_1p || !hug_3p)
		return FALSE

	hug_3p = emote_replace_user_tokens(hug_3p, src)
	hug_3p = emote_replace_target_tokens(hug_3p, target)
	hug_1p = emote_replace_target_tokens(hug_1p, target)
	visible_message(
		SPAN_NOTICE(capitalize(hug_3p)),
		SPAN_NOTICE(capitalize(hug_1p))
	)

	playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

	if(src != target)
		update_personal_goal(/datum/goal/achievement/givehug, TRUE)
		target.update_personal_goal(/datum/goal/achievement/gethug, TRUE)

	return TRUE
