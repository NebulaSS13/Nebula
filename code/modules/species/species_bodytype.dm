/decl/bodytype
	var/name = "default"
	var/icon_base
	var/icon_deformed
	var/lip_icon
	var/bandages_icon
	var/bodytype_category = BODYTYPE_OTHER
	var/limb_icon_intensity = 1.5
	var/damage_overlays
	var/damage_mask
	var/blood_mask
	var/vulnerable_location = BP_GROIN //organ tag that can be kicked for increased pain, previously `sexybits_location`.
	var/limb_blend = ICON_ADD
	var/husk_icon =     'icons/mob/human_races/species/default_husk.dmi'
	var/skeletal_icon = 'icons/mob/human_races/species/human/skeleton.dmi'
	var/icon_template = 'icons/mob/human_races/species/template.dmi' // Used for mob icon generation for non-32x32 species.
	var/ignited_icon = 'icons/mob/OnFire.dmi'
	var/associated_gender
	var/icon_cache_uid

	var/uniform_state_modifier

	var/health_hud_intensity = 1
	var/tail                                  // Name of tail state in species effects icon file.
	var/tail_animation                        // If set, the icon to obtain tail animation states from.
	var/tail_blend = ICON_ADD
	var/tail_hair
	var/tail_hair_blend = ICON_ADD
	var/tail_icon = 'icons/effects/species.dmi'
	var/tail_states = 1

	var/pixel_offset_x = 0                    // Used for offsetting large icons.
	var/pixel_offset_y = 0                    // Used for offsetting large icons.
	var/pixel_offset_z = 0                    // Used for offsetting large icons.

	var/antaghud_offset_x = 0                 // As above, but specifically for the antagHUD indicator.
	var/antaghud_offset_y = 0                 // As above, but specifically for the antagHUD indicator.

	var/list/prone_overlay_offset = list(0, 0) // amount to shift overlays when lying

	var/list/hug_messages = list(
		BP_HEAD = list(
			"$USER$ pats $TARGET$ on the head.",
			"You pat $TARGET$ on the head."
		),
		BP_L_HAND = list(
			"$USER$ shakes $TARGET$'s hand.",
			"You shake $TARGET$'s hand."
		),
		BP_R_HAND = list(
			"$USER$ shakes $TARGET$'s hand.",
			"You shake $TARGET$'s hand."
		),
		BP_L_ARM = list(
			"$USER$ pats $TARGET$ on the shoulder.",
			"You pat $TARGET$ on the shoulder."
		),
		BP_R_ARM = list(
			"$USER$ pats $TARGET$ on the shoulder.",
			"You pat $TARGET$ on the shoulder."
		)
	)

/decl/bodytype/Initialize()
	. = ..()
	if(!icon_deformed)
		icon_deformed = icon_base

/decl/bodytype/proc/apply_limb_colouration(var/obj/item/organ/external/E, var/icon/applying)
	return applying

/decl/bodytype/proc/check_dismember_type_override(var/disintegrate)
	return disintegrate

/decl/bodytype/proc/hug(var/mob/living/user, var/mob/living/target, var/hug_3p, var/hug_1p)

	if(!istype(user) || !istype(target))
		return FALSE

	if(isnull(hug_3p) || isnull(hug_1p))

		if(get_dir(user, target) == target.dir)
			hug_3p = "$USER$ rubs $TARGET$'s back soothingly."
			hug_1p = "You rubs $TARGET$'s back soothingly."
		else
			hug_3p = "$USER$ hugs $TARGET$ to make $TARGET_HIM$ feel better."
			hug_1p = "You hug $TARGET$ to make $TARGET_HIM$ feel better."

		var/decl/bodytype/target_bodytype = target.get_bodytype()
		if(istype(target_bodytype))
			if(user.zone_sel?.selecting in target_bodytype.hug_messages)
				var/list/use_hug_messages = target_bodytype.hug_messages[user.zone_sel.selecting]
				hug_3p = use_hug_messages[1]
				hug_1p = use_hug_messages[2]

	if(hug_1p && hug_3p)
		var/decl/pronouns/my_pronouns = user.get_pronouns()
		var/decl/pronouns/target_pronouns = target.get_pronouns()

		hug_3p = replacetext(hug_3p, "$USER$",       "\the [user]")
		hug_3p = replacetext(hug_3p, "$USER_HIM$",   my_pronouns.him)
		hug_3p = replacetext(hug_3p, "$USER_HIS$",   my_pronouns.his)

		hug_3p = replacetext(hug_3p, "$TARGET$",     "\the [target]")
		hug_3p = replacetext(hug_3p, "$TARGET_HIM$", target_pronouns.him)
		hug_3p = replacetext(hug_3p, "$TARGET_HIS$", target_pronouns.his)

		hug_1p = replacetext(hug_1p, "$TARGET$",     "\the [target]")
		hug_1p = replacetext(hug_1p, "$TARGET_HIM$", target_pronouns.him)
		hug_1p = replacetext(hug_1p, "$TARGET_HIS$", target_pronouns.his)

		target.visible_message(
			SPAN_NOTICE(capitalize(hug_3p)),
			SPAN_NOTICE(capitalize(hug_1p))
		)

		if(user != target)
			user.update_personal_goal(/datum/goal/achievement/givehug, TRUE)
			target.update_personal_goal(/datum/goal/achievement/gethug, TRUE)

		return TRUE
