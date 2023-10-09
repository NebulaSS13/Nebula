/mob/living
	var/list/_damage_values
	var/list/_damage_type_mapping

/mob/living/proc/resolve_damage_handler(var/damage_type)
	RETURN_TYPE(/decl/damage_handler)
	if(!(damage_type in _damage_values))
		return // We don't handle this damage type.
	. = LAZYACCESS(_damage_type_mapping, damage_type) || damage_type
	if(.)
		. = GET_DECL(.)

/mob/living/proc/get_lethal_damage_types()
	var/static/list/lethal_damage_types = list(
		BRUTE,
		BURN
	)
	return lethal_damage_types

/mob/living/proc/get_handled_damage_types()
	var/static/list/mob_damage_types = list(
		BRUTE,
		BURN
	)
	return mob_damage_types

/mob/living/proc/setup_damage_types()
	var/list/handled_damage_types = get_handled_damage_types()
	for(var/primary_type in handled_damage_types)
		LAZYSET(_damage_values, primary_type, 0)
		var/validate_type = handled_damage_types[primary_type]
		if(validate_type)
			if(validate_type != primary_type)
				LAZYSET(_damage_type_mapping, primary_type, validate_type)
		else
			validate_type = primary_type
		var/decl/damage_handler/damage_handler_data = GET_DECL(validate_type)
		if(!istype(src, damage_handler_data.expected_type))
			PRINT_STACK_TRACE("Damage handler [validate_type] validation got unexpected type [damage_handler_data.expected_type].")

/mob/living/proc/get_damage(var/damage_type)
	if(damage_type)
		var/decl/damage_handler/damage_type_data = resolve_damage_handler(damage_type)
		return damage_type_data?.get_damage_for_mob(src)
	var/decl/species/my_species = get_species()
	if(my_species && isSynthetic())
		return my_species.total_health - current_health
	return 0

/mob/living/heal_damage(var/damage, var/damage_type = BRUTE, var/def_zone = null, var/damage_flags = 0, skip_update_health = FALSE)
	if(damage < 0)
		return take_damage(abs(damage), damage_type, def_zone, damage_flags, skip_update_health = skip_update_health)
	return resolve_damage_handler(damage_type)?.heal_mob_damage(src, damage, skip_update_health = skip_update_health)

/mob/living/proc/clear_all_damage()
	for(var/damage_type in _damage_values)
		clear_damage(damage_type)

/mob/living/proc/clear_damage(var/damage_type, skip_update_health = FALSE)
	return set_damage(0, damage_type, skip_update_health = skip_update_health) // TODO

/mob/living/proc/set_damage(var/damage, var/damage_type, skip_update_health = FALSE)
	return resolve_damage_handler(damage_type)?.set_mob_damage(src, damage, skip_update_health = skip_update_health)

// TODO: check if organ_rel_size[zone] should be used
/mob/living/proc/get_dispersed_damage_zones()
	for(var/obj/item/organ/organ in get_external_organs())
		LAZYSET(., organ.organ_tag, organ.w_class)

/mob/living/take_damage(damage, damage_type = BRUTE, def_zone, damage_flags = 0, used_weapon, armor_pen, silent = FALSE, override_droplimb, skip_update_health = FALSE)

	if((status_flags & GODMODE) || !damage || !damage_type)
		return FALSE

	if(damage < 0)
		return heal_damage(abs(damage), damage_type, def_zone, damage_flags)

	// Dispersed damage recurses using our available target zones.
	// We assume that the damage handlers know what to do with the zones when supplied.
	if(damage_flags & DAM_DISPERSED)
		var/tally = 0
		var/list/dispersed_damage_zones = get_dispersed_damage_zones()
		// Sum our overall size.
		for(var/zone in dispersed_damage_zones)
			tally += dispersed_damage_zones[zone]
		// Recursively call the proc on valid zones with the weighted damage value.
		for(var/zone in dispersed_damage_zones)
			. = .(damage * dispersed_damage_zones[zone]/tally, def_zone = zone)
			return
	else if(isnull(def_zone))
		def_zone = ran_zone()

	// Modify based on armour, if a bodypart is supplied.
	// No bodypart indicates this should bypass armour.
	if(!isnull(def_zone))
		var/list/after_armor = modify_damage_by_armor(def_zone, damage, damage_type, damage_flags, src, armor_pen, silent)
		damage = after_armor[1]
		damage_type = after_armor[2]
		damage_flags = after_armor[3]

	// Modify based on mob (such as species malus)
	// This does not care about def_zone being supplied.
	damage = round(damage * get_damage_modifier(damage_type))

	if(!damage)
		return FALSE

	var/decl/damage_handler/damage_type_instance = resolve_damage_handler(damage_type)
	if(damage_type_instance?.apply_damage_to_mob(src, damage, def_zone, damage_flags, used_weapon, silent))
		if(!skip_update_health)
			update_health()
		return TRUE
	return FALSE

/mob/living/proc/get_damage_modifier(var/damage_type)
	var/decl/species/my_species = get_species()
	return my_species ? my_species.get_damage_modifier(src, damage_type) : 1

// Special procs; not handled by damage system above.
// Primarily used by humans.
/mob/proc/get_brain_damage()
	return 0

/mob/living/proc/adjust_brain_damage(var/amount)
	return

/mob/living/proc/set_brain_damage(var/amount)
	return