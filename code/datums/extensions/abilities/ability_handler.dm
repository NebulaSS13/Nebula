/datum/ability_handler
	abstract_type = /datum/ability_handler
	var/mob/owner
	var/list/ability_items
	var/datum/extension/abilities/master

/datum/ability_handler/New(_master)
	master = _master
	if(!istype(master))
		CRASH("Ability handler received invalid master!")
	owner = master.holder
	if(!istype(owner))
		CRASH("Ability handler received invalid owner!")
	..()

/datum/ability_handler/Destroy()
	QDEL_NULL_LIST(ability_items)
	if(master)
		LAZYREMOVE(master.ability_handlers, src)
		master.update()
		master = null
	owner = null
	return ..()

/datum/ability_handler/proc/cancel()
	if(LAZYLEN(ability_items))
		for(var/thing in ability_items)
			owner?.drop_from_inventory(thing)
			qdel(thing)
		ability_items = null

/// Individual ability methods/disciplines (psioncs, etc.) so that mobs can have multiple.
/datum/ability_handler/proc/refresh_login()
	return

/datum/ability_handler/proc/can_do_self_invocation(mob/user)
	return FALSE

/datum/ability_handler/proc/do_self_invocation(mob/user)
	return FALSE

/datum/ability_handler/proc/can_do_grabbed_invocation(mob/user, atom/target)
	return FALSE

/datum/ability_handler/proc/do_grabbed_invocation(mob/user, atom/target)
	return FALSE

/datum/ability_handler/proc/can_do_melee_invocation(mob/user, atom/target)
	return FALSE

/datum/ability_handler/proc/do_melee_invocation(mob/user, atom/target)
	return FALSE

/datum/ability_handler/proc/can_do_ranged_invocation(mob/user, atom/target)
	return FALSE

/datum/ability_handler/proc/do_ranged_invocation(mob/user, atom/target)
	return FALSE
