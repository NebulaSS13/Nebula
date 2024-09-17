// TODO: extend this to cover buckled structures
/datum/extension/resistable
	base_type = /datum/extension/resistable
	expected_type = /obj/item

/datum/extension/resistable/proc/get_restraint_escape_time(mob/living/user)
	return 2 MINUTES

/datum/extension/resistable/proc/user_try_escape(mob/living/user, slot)

	set waitfor = FALSE

	var/obj/item/restraint = holder
	if(!istype(user) || QDELETED(user) || QDELETED(restraint) || restraint.loc != user || user.buckled)
		return FALSE

	// Don't want to do a lot of logic gating here.
	if(user.can_break_restraints())
		return user.break_restraints(restraint)

	var/breakouttime = get_restraint_escape_time(user)
	breakouttime = max(5, breakouttime * user.get_restraint_breakout_mod())
	user.setClickCooldown(breakouttime)

	user.visible_message(
		SPAN_DANGER("\The [user] attempts to remove \the [restraint]!"),
		SPAN_DANGER("You attempt to remove \the [restraint] (This will take around [ceil(breakouttime / (1 SECOND))] second\s and you need to stand still)."),
		range = 2
	)

	var/static/resist_stages = 4
	for(var/i = 1 to resist_stages)
		if(!do_after(user, breakouttime*0.25, incapacitation_flags = (INCAPACITATION_DEFAULT & ~INCAPACITATION_RESTRAINED)))
			user.visible_message(
				SPAN_WARNING("\The [user] stops fiddling with \the [restraint]."),
				SPAN_WARNING("You stop trying to slip free of \the [restraint]."),
				range = 2
			)
			return FALSE

		var/new_restraint = user.get_equipped_item(slot)
		if((restraint != new_restraint) || user.buckled)
			return FALSE
		user.visible_message(
			SPAN_WARNING("\The [user] fiddles with \the [restraint]."),
			SPAN_WARNING("You try to slip free of \the [restraint] ([i*100/resist_stages]% done)."),
			range = 2
		)

	if (restraint.can_take_damage() && restraint.current_health > 0) // Improvised restraint can break because their health is > 0
		restraint.take_damage(restraint.get_max_health() / 2)
		if (QDELETED(restraint) || restraint.current_health < 1)
			var/decl/pronouns/pronouns = restraint.get_pronouns()
			user.visible_message(
				SPAN_DANGER("\The [user] manages to remove \the [restraint], breaking [pronouns.him]!"),
				SPAN_NOTICE("You successfully remove \the [restraint], breaking [pronouns.him]!"),
				range = 2
			)
			QDEL_NULL(restraint)
			if(user.buckled && user.buckled.buckle_require_restraints)
				user.buckled.unbuckle_mob()
			user.update_equipment_overlay(slot)
			return
	user.visible_message(
		SPAN_WARNING("\The [user] manages to remove \the [restraint]!"),
		SPAN_NOTICE("You successfully remove \the [restraint]!"),
		range = 2
	)
	user.drop_from_inventory(restraint)

// Specific item subtypes/logic below.
/datum/extension/resistable/handcuffs
	expected_type = /obj/item/handcuffs

/datum/extension/resistable/handcuffs/get_restraint_escape_time(mob/living/user)
	var/obj/item/handcuffs/cuffs = holder
	. = cuffs.breakouttime
	if(istype(user?.get_equipped_item(slot_gloves_str), /obj/item/clothing/gloves/rig))
		. = round(.*0.5)

/datum/extension/resistable/straightjacket
	expected_type = /obj/item/clothing/suit/straight_jacket

/datum/extension/resistable/straightjacket/get_restraint_escape_time(mob/living/user)
	return 5 MINUTES
