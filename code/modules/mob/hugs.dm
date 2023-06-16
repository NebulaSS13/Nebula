var/global/list/_default_hug_messages = list(
	BP_HEAD = list(
		"$USER$ pats $TARGET$ on the head.",
		"You pat $TARGET$ on the head."
	)
)

/mob/proc/get_hug_zone_messages(var/zone)
	var/decl/bodytype/bodytype = get_bodytype()
	return bodytype?.get_hug_zone_messages(zone) || global._default_hug_messages[zone]

/mob/proc/attempt_hug(var/mob/living/target, var/hug_3p, var/hug_1p)

	if(!istype(target))
		return FALSE

	if(isnull(hug_3p) || isnull(hug_1p))

		if(get_dir(src, target) == target.dir)
			hug_3p = "$USER$ rubs $TARGET$'s back soothingly."
			hug_1p = "You rub $TARGET$'s back soothingly."
		else
			hug_3p = "$USER$ hugs $TARGET$ to make $TARGET_HIM$ feel better."
			hug_1p = "You hug $TARGET$ to make $TARGET_HIM$ feel better."

		var/list/use_hug_messages = target.get_hug_zone_messages(get_target_zone())
		if(length(use_hug_messages) >= 2)
			hug_3p = use_hug_messages[1]
			hug_1p = use_hug_messages[2]

	if(hug_1p && hug_3p)
		var/decl/pronouns/my_pronouns = get_pronouns()
		var/decl/pronouns/target_pronouns = target.get_pronouns()

		hug_3p = replacetext(hug_3p, "$USER$",       "\the [src]")
		hug_3p = replacetext(hug_3p, "$USER_HIM$",   my_pronouns.him)
		hug_3p = replacetext(hug_3p, "$USER_HIS$",   my_pronouns.his)

		hug_3p = replacetext(hug_3p, "$TARGET$",     "\the [target]")
		hug_3p = replacetext(hug_3p, "$TARGET_HIM$", target_pronouns.him)
		hug_3p = replacetext(hug_3p, "$TARGET_HIS$", target_pronouns.his)

		hug_1p = replacetext(hug_1p, "$TARGET$",     "\the [target]")
		hug_1p = replacetext(hug_1p, "$TARGET_HIM$", target_pronouns.him)
		hug_1p = replacetext(hug_1p, "$TARGET_HIS$", target_pronouns.his)

		visible_message(
			SPAN_NOTICE(capitalize(hug_3p)),
			SPAN_NOTICE(capitalize(hug_1p))
		)

		if(src != target)
			update_personal_goal(/datum/goal/achievement/givehug, TRUE)
			target.update_personal_goal(/datum/goal/achievement/gethug, TRUE)

		return TRUE
