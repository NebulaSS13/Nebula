// Subtype for tracking timer etc. No actual behavior associated with these.
/datum/mob_modifier
	var/mob/living/owner
	var/decl/mob_modifier/archetype
	var/expire_time = MOB_MODIFIER_INDEFINITE
	var/weakref/source

/datum/mob_modifier/New(decl/mob_modifier/_archetype, mob/living/_owner, datum/_source)
	archetype = istype(_archetype) ? _archetype : GET_DECL(_archetype)
	owner = _owner
	source = weakref(_source)

/datum/mob_modifier/Destroy(force)
	owner = null
	return ..()

// returns TRUE if the owner needs to run an update on mob modifiers following this run.
/datum/mob_modifier/proc/on_modifier_mob_life()
	SHOULD_CALL_PARENT(TRUE)
	. = FALSE
	// We should not exist without an owner.
	if(!istype(owner))
		qdel(src)
		return TRUE
	// Count down our timer, if necessary.
	if(expire_time != MOB_MODIFIER_INDEFINITE)
		. = TRUE
		if(world.time >= expire_time)
			on_modifier_expiry()

/datum/mob_modifier/proc/on_modifier_removed(skip_update = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	if(!istype(owner))
		return FALSE
	var/list/modifiers = LAZYACCESS(owner._mob_modifiers, archetype)
	if(!length(modifiers))
		return FALSE
	modifiers -= src
	// If this was our last modifier, clear the list.
	if(!length(modifiers))
		LAZYREMOVE(owner._mob_modifiers, archetype)
	archetype.on_modifier_datum_removed(owner, src)
	if(!skip_update)
		owner.refresh_hud_element(HUD_MODIFIERS)
		if(archetype.mob_overlay_icon || archetype.mob_overlay_state)
			owner.queue_icon_update()
	qdel(src)
	return TRUE

/datum/mob_modifier/proc/on_modifier_added(skip_update = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	if(!istype(owner))
		return FALSE
	var/list/modifiers = LAZYACCESS(owner._mob_modifiers, archetype)
	if(!modifiers)
		modifiers = list()
		LAZYSET(owner._mob_modifiers, archetype, modifiers)
	if(src in modifiers)
		return FALSE
	modifiers += src
	archetype.on_modifier_datum_added(owner, src)
	if(!skip_update)
		owner.refresh_hud_element(HUD_MODIFIERS)
		if(archetype.mob_overlay_icon || archetype.mob_overlay_state)
			owner.queue_icon_update()
	return TRUE

/datum/mob_modifier/proc/on_modifier_expiry()
	SHOULD_CALL_PARENT(TRUE)
	archetype.on_modifier_datum_expiry(owner, src)
	return on_modifier_removed()

/datum/mob_modifier/proc/on_modifier_click(params)
	SHOULD_CALL_PARENT(TRUE)
	archetype.on_modifier_datum_click(owner, src, params)
