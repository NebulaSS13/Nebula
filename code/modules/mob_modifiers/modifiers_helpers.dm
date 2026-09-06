
/mob/living
	// A modifier is a generalised effect on the mob, positive or negative, like buckling, healing or a curse.
	var/list/_mob_modifiers

/mob/living/proc/handle_mob_modifiers()
	SHOULD_CALL_PARENT(TRUE)
	for(var/decl/mob_modifier/archetype as anything in _mob_modifiers)
		if(archetype.on_modifier_datum_mob_life(src, _mob_modifiers[archetype]))
			. = TRUE
	if(.)
		refresh_hud_element(HUD_MODIFIERS)

/mob/living/clear_mob_modifiers()
	for(var/archetype as anything in _mob_modifiers)
		for(var/datum/mob_modifier/modifier in _mob_modifiers[archetype])
			modifier.on_modifier_removed()

/mob/living/remove_mob_modifier(decl/mob_modifier/archetype, datum/source, skip_update = FALSE)

	if(ispath(archetype))
		archetype = GET_DECL(archetype)
	if(!istype(archetype))
		return FALSE

	// If we have no data, we can't clear it.
	var/list/modifiers = LAZYACCESS(_mob_modifiers, archetype)
	if(!length(modifiers))
		return FALSE

	// Source datum means we only remove an modifier that matches the source.
	for(var/datum/mob_modifier/modifier as anything in modifiers)
		if(!source || modifier.source?.resolve() == source)
			modifier.on_modifier_removed()
			. = TRUE
			if(source)
				return

	// We didn't find one to remove. Tragic.
	return FALSE

// If source is not provided, we only care that we have SOMETHING providing this modifier.
/mob/living/has_mob_modifier(decl/mob_modifier/archetype, datum/source)
	if(ispath(archetype))
		archetype = GET_DECL(archetype)
	if(!istype(archetype))
		return FALSE
	var/list/modifiers = LAZYACCESS(_mob_modifiers, archetype)
	if(!length(modifiers))
		return FALSE
	if(!source) // We don't care about specifics.
		return TRUE
	for(var/datum/mob_modifier/modifier in modifiers)
		if(modifier.source?.resolve() == source)
			return TRUE
	return FALSE

/mob/living/add_mob_modifier(decl/mob_modifier/archetype, duration = MOB_MODIFIER_INDEFINITE, datum/source, skip_update = FALSE)
	if(ispath(archetype))
		archetype = GET_DECL(archetype)
	if(!istype(archetype) || !istype(source))
		return FALSE

	var/list/modifiers = LAZYACCESS(_mob_modifiers, archetype)
	var/datum/mob_modifier/modifier
	for(var/datum/mob_modifier/existing_modifier in modifiers)
		if(existing_modifier.source?.resolve() == source)
			modifier = existing_modifier
			break

	if(!istype(modifier))
		modifier = new archetype.modifier_type(archetype, src, source)
	if(duration != MOB_MODIFIER_INDEFINITE)
		modifier.expire_time = world.time + duration
	else
		modifier.expire_time = MOB_MODIFIER_INDEFINITE
	modifier.on_modifier_added(skip_update)
	return TRUE
