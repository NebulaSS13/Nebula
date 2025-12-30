// Stubs; see living_status.dm
/mob/proc/handle_status_conditions()
	SHOULD_CALL_PARENT(TRUE)

/mob/proc/clear_status_conditions()
	return

/mob/proc/set_status_condition(var/condition, var/amount)
	return

/mob/proc/clear_mob_modifiers()
	return FALSE

/mob/proc/remove_mob_modifier(decl/mob_modifier/archetype, datum/source, skip_update = FALSE)
	return FALSE

/mob/proc/has_mob_modifier(decl/mob_modifier/archetype, datum/source)
	return FALSE

/mob/proc/add_mob_modifier(decl/mob_modifier/archetype, duration = MOB_MODIFIER_INDEFINITE, datum/source, skip_update = FALSE)
	return FALSE

/mob/proc/mob_modifiers_block_attack(...)
	return FALSE // see living_defense.dm
