
/obj/item/grooming
	abstract_type = /obj/item/grooming
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC

	var/message_target_other_generic = "$USER$ grooms $TARGET$ with $TOOL$."
	var/message_target_self_generic  = "$USER$ grooms $USER_SELF$ with $TOOL$."
	var/message_target_other         = "$USER$ grooms $TARGET$'s $DESCRIPTOR$ with $TOOL$."
	var/message_target_self          = "$USER$ grooms $USER_HIS$ $DESCRIPTOR$ with $TOOL$."
	var/message_target_other_partial = "$USER$ just sort of runs $TOOL$ over $TARGET$'s $DESCRIPTOR$."
	var/message_target_self_partial  = "$USER$ just sort of runs $TOOL$ over $USER_HIS$ $DESCRIPTOR$."
	var/message_target_other_missing = "$TARGET$'s $LIMB$ has nothing to groom!"
	var/message_target_self_missing  = "Your $LIMB$ has nothing to groom!"
	var/grooming_flags               = GROOMABLE_NONE

/obj/item/grooming/Initialize()
	. = ..()
	update_icon()

/obj/item/grooming/proc/replace_message_tokens(message, mob/living/user, mob/living/target, obj/item/tool, limb, descriptor)
	var/decl/pronouns/user_pronouns   = user.get_pronouns()
	var/decl/pronouns/target_pronouns = target.get_pronouns()
	. = message
	. = replacetext(., "$USER$",        "\the [user]")
	. = replacetext(., "$USER_HIS$",    user_pronouns.his)
	. = replacetext(., "$USER_HIM$",    user_pronouns.him)
	. = replacetext(., "$USER_SELF$",   user_pronouns.self)
	. = replacetext(., "$TARGET$",      "\the [target]")
	. = replacetext(., "$TARGET_HIS$",  target_pronouns.his)
	. = replacetext(., "$TARGET_HIM$",  target_pronouns.him)
	. = replacetext(., "$TARGET_SELF$", target_pronouns.self)
	. = replacetext(., "$TOOL$",        "\the [tool]")
	. = replacetext(., "$DESCRIPTOR$",  descriptor)
	. = replacetext(., "$LIMB$",        limb)
	. = capitalize(.)

/obj/item/grooming/proc/try_groom(mob/living/user, mob/living/target)

	if(!istype(user) || !istype(target) || user.incapacitated() || user.a_intent == I_HURT)
		return FALSE

	if(!length(target.get_external_organs()))
		return target.handle_general_grooming(user, src)

	var/zone = user.get_target_zone()
	if(!zone)
		return FALSE

	var/target_self = user == target
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(target, zone)
	if(!affecting)
		to_chat(user, SPAN_WARNING("[target_self ? "You are" : "\The [target] [target.get_pronouns().is]"] missing [target_self ? "your" : target.get_pronouns().his] [parse_zone(zone)]."))
		return TRUE

	var/obj/item/blocking = target.bodypart_is_covered(zone)
	if(blocking)
		to_chat(user, "\The [blocking] [blocking.get_pronouns().is] in the way!")
		return TRUE

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	// return type is assoc list ie. list("success" = GROOMING_RESULT_PARTIAL, "descriptor" = "hair")
	var/list/grooming_results = affecting.get_grooming_results(src)
	var/show_message
	switch(LAZYACCESS(grooming_results, "success"))
		if(GROOMING_RESULT_PARTIAL)
			show_message = target_self ? message_target_self_partial : message_target_other_partial
		if(GROOMING_RESULT_SUCCESS)
			show_message = target_self ? message_target_self : message_target_other
		else
			show_message = target_self ? message_target_self_missing : message_target_other_missing
	visible_message(SPAN_NOTICE(replace_message_tokens(show_message, user, target, src, parse_zone(zone), LAZYACCESS(grooming_results, "descriptor") || "marking")))
	target.add_stressor(/datum/stressor/well_groomed, 5 MINUTES)
	return TRUE

/obj/item/grooming/attack_self(mob/user)
	if(try_groom(user, user))
		return TRUE
	return ..()

/obj/item/grooming/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(try_groom(user, target))
		return TRUE
	return ..()
