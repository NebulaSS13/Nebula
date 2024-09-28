/obj/screen/ability/button/spell
	icon = 'mods/gamemodes/wizard/icons/spell_icons.dmi'
	ability_category_tag = "wizard_spells"

/decl/ability_targeting/spell
	effect_radius            = 1

/decl/ability/wizard
	associated_handler_type  = /datum/ability_handler/spells
	abstract_type            = /decl/ability/wizard
	is_supernatural          = TRUE
	target_selector          = /decl/ability_targeting/spell
	overlay_icon             = 'mods/gamemodes/wizard/icons/spell_icons.dmi'
	overlay_icon_state       = "spell"
	max_charge               = 0
	ui_element_type          = /obj/screen/ability/button/spell

	var/requires_wizard_garb = TRUE
	var/vocal_component      = TRUE
	var/invocation_type      = SpI_NONE
	var/invocation_string
	var/sparks_spread
	var/sparks_amt
	var/smoke_spread
	var/smoke_amt
	var/feedback
	// These vars are just defaults and can be overridden by anything that modifies the ability's metadata.
	VAR_PROTECTED/base_max_upgrades = 4
	VAR_PROTECTED/list/base_max_upgrade_levels = list((Sp_SPEED) = 4, (Sp_POWER) = 1)

/decl/ability/wizard/check_equipment(mob/user, list/metadata, silent = FALSE)

	if(!(. = ..()))
		return

	if(requires_wizard_garb)
		var/failure = user.wearing_wizard_garb()
		if(failure)
			if(!silent)
				to_chat(user, SPAN_WARNING(failure))
			return FALSE

	if(vocal_component && user.get_item_blocking_speech())
		if(!silent)
			to_chat(user, SPAN_WARNING("This spell requires a vocal incantation, and your mouth is blocked!"))
		return FALSE

/decl/ability/wizard/show_ability_cast_msg(mob/user, list/targets, list/metadata)
	if(!invocation_string || invocation_type == SpI_NONE)
		return
	switch(invocation_type)
		if(SpI_SHOUT)
			if(prob(50))
				user.say(invocation_string)
			else
				user.say(replacetext(invocation_string," ","`"))
		if(SpI_WHISPER)
			if(prob(50))
				user.whisper(invocation_string)
			else
				user.whisper(replacetext(invocation_string," ","`"))
		if(SpI_EMOTE)
			user.custom_emote(VISIBLE_MESSAGE, invocation_string)

/decl/ability/wizard/finish_casting(mob/user, atom/hit_target, list/metadata)
	..()
	var/turf/location = get_turf(user)
	if(!istype(location))
		return

	if(sparks_spread && sparks_amt)
		spark_at(location, amount = sparks_amt)

	if(smoke_spread && smoke_amt)
		var/datum/effect/effect/system/smoke_spread/smoke
		switch(smoke_spread)
			if(1)
				smoke = new /datum/effect/effect/system/smoke_spread()
			if(2)
				smoke = new /datum/effect/effect/system/smoke_spread/bad()
		if(smoke)
			smoke.set_up(smoke_amt, 0, location)
			smoke.start()

/decl/ability/wizard/get_default_metadata()
	. = ..()
	.["current_upgrade_levels"] = list((Sp_SPEED) = 0, (Sp_POWER) = 0)
	.["max_upgrades"] = base_max_upgrades
	.["max_upgrade_levels"] = base_max_upgrade_levels.Copy()

/decl/ability/wizard/proc/can_improve(upgrade_type, list/metadata)

	// We got a null or false value, why?
	if(!upgrade_type)
		return FALSE

	//too many levels, can't do it
	var/list/current_levels = metadata["current_upgrade_levels"]
	if(metadata["max_upgrades"] <= current_levels[Sp_POWER] + current_levels[Sp_SPEED])
		return FALSE

	// Can we continue upgrading this field?
	var/list/max_levels = metadata["max_upgrade_levels"]
	return current_levels[upgrade_type] < max_levels[upgrade_type]

/decl/ability/wizard/proc/empower_spell(mob/user, list/metadata)
	if(can_improve(Sp_POWER, metadata))
		var/list/current_levels = metadata["current_upgrade_levels"]
		current_levels[Sp_POWER]++
		return TRUE
	return FALSE

/decl/ability/wizard/get_cooldown_time(list/metadata)

	var/list/current_levels = metadata["current_upgrade_levels"]
	if(!length(current_levels))
		return cooldown_time

	var/current_speed = LAZYACCESS(current_levels, Sp_SPEED)
	if(isnull(current_speed))
		return cooldown_time

	var/list/max_levels = metadata["max_upgrade_levels"]
	if(!length(max_levels))
		return cooldown_time

	var/max_speed = LAZYACCESS(max_levels, Sp_SPEED)
	if(isnull(max_speed))
		return cooldown_time

	return ceil(cooldown_time * ((max_speed - current_speed) / max_speed))

/decl/ability/wizard/proc/quicken_spell(mob/user, list/metadata)
	if(!can_improve(Sp_SPEED, metadata))
		return FALSE

	var/list/current_levels = metadata["current_upgrade_levels"]
	current_levels[Sp_SPEED]++

	var/list/max_levels = metadata["max_upgrade_levels"]
	switch(max_levels[Sp_SPEED]-current_levels[Sp_SPEED])
		if(3)
			to_chat(user, SPAN_NOTICE("You have improved [name] into Efficient [name]."))
			metadata["ability_name"] = "Efficient [name]"
		if(2)
			to_chat(user, SPAN_NOTICE("You have improved [name] into Swift [name]."))
			metadata["ability_name"] = "Quickened [name]"
		if(1)
			to_chat(user, SPAN_NOTICE("You have improved [name] into Quickened [name]."))
			metadata["ability_name"] = "Free [name]"
		if(0)
			to_chat(user, SPAN_NOTICE("You have improved [name] into Instant [name]."))
			metadata["ability_name"] = "Instant [name]"
