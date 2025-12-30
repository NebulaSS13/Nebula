// Extension that handles intercepting click actions and casts spells/power as appropriate.
/datum/extension/abilities
	base_type = /datum/extension/abilities
	expected_type = /mob
	var/list/ability_handlers

/datum/extension/abilities/Destroy()
	// Can't use QDEL_NULL_LIST() due to circular calls.
	for(var/datum/ability_handler/handler in ability_handlers)
		handler.master = null
		qdel(handler)
	ability_handlers = null
	return ..()

/datum/extension/abilities/proc/update()
	if(!LAZYLEN(ability_handlers))
		remove_extension(holder, base_type)

/// Using an empty hand on itelf (attack_empty_hand())
/datum/extension/abilities/proc/do_self_invocation()
	if(isliving(holder) && LAZYLEN(ability_handlers))
		for(var/datum/ability_handler/handler in ability_handlers)
			if(handler.can_do_self_invocation(holder) && handler.do_self_invocation(holder))
				return TRUE
	return FALSE

/// Clicking a grab on the currently grabbed mob.
/datum/extension/abilities/proc/do_grabbed_invocation(atom/target)
	if(isliving(holder) && istype(target) && LAZYLEN(ability_handlers) && !istype(target, /obj/screen))
		for(var/datum/ability_handler/handler in ability_handlers)
			if(handler.can_do_grabbed_invocation(holder, target) && handler.do_grabbed_invocation(holder, target))
				return TRUE
	return FALSE

/// Clicking an adjacent target (UnarmedAttack())
/datum/extension/abilities/proc/do_melee_invocation(atom/target)
	if(isliving(holder) && istype(target) && LAZYLEN(ability_handlers) && !istype(target, /obj/screen))
		for(var/datum/ability_handler/handler in ability_handlers)
			if(handler.can_do_melee_invocation(holder, target) && handler.do_melee_invocation(holder, target))
				return TRUE
	return FALSE

/// Clicking a distant target (RangedAttack())
/datum/extension/abilities/proc/do_ranged_invocation(atom/target)
	if(isliving(holder) && istype(target) && LAZYLEN(ability_handlers) && !istype(target, /obj/screen))
		for(var/datum/ability_handler/handler in ability_handlers)
			if(handler.can_do_ranged_invocation(holder, target) && handler.do_ranged_invocation(holder, target))
				return TRUE
	return FALSE

/// Updates UI etc. on login
/datum/extension/abilities/proc/refresh_login()
	if(LAZYLEN(ability_handlers))
		for(var/datum/ability_handler/handler in ability_handlers)
			handler.refresh_login()

/datum/extension/abilities/proc/refresh_element_positioning()
	var/row = 0
	for(var/datum/ability_handler/handler in ability_handlers)
		if(length(handler.screen_elements))
			row += handler.refresh_element_positioning(row)
