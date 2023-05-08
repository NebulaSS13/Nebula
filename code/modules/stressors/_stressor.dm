/*
 * STRESSOR SYSTEM
 * ===
 * This little blob of code is intended to represent a slew of minor health and wellbeing
 * conditions that aren't otherwise covered by the sim. Generally it should be used to
 * represent things that are too specific, niche or minor to really give a mechanical
 * impact - you had a nutritious meal, you are lying on a comfortable bed, you've been
 * shot at, your blood sugar is low. All these things (stressor datums) are summed up
 * and give a value between -1 (maximum good) to 1 (maximum bad), which is then used in
 * several places related to health recovery (wound regen, shock recovery, blood regen).
 *
 * The hoped-for outcome for this system is that it will encourage people to pursue RP
 * actions (like eating food from the chef instead of vendor trash), and discourage them
 * from doing RP actions that are somewhat nonsensical (like leaving surgery and immediately
 * running straight back into combat).
 *
 * General dos and don'ts:
 * - Don't use this for things that are better represented as mechanical status effects.
 * - Don't use stress as a multiplier in places that would be better served by a more
 *   fleshed-out, specific system.
 * - Don't go overboard with the impact of stress. It should be mild, not crippling.
 * - Likewise don't make a crazy buff based on your stress level or lack thereof.
 */

/datum/stressor
	/// A name string, used solely for input().
	var/name
	/// A short string shown in Check Stressors.
	var/desc
	/// A message shown when the stressor begins.
	var/on_addition_message
	/// A message shown when the stressor expires.
	var/on_removal_message
	/// Amount that this stressor will contribute to stress.
	var/stress_value = 0
	/// A list of stressor IDs that will prevent this stressor being added if present.
	var/list/incompatible_with_stressors
	/// A list of stressor IDs that will be hidden/not counted while this stressor is present.
	var/list/suppress_stressors

/datum/stressor/ManagedInstanceInitialize()
	for(var/stressor_id in incompatible_with_stressors)
		incompatible_with_stressors += SSmanaged_instances.get(stressor_id, cache_category = /datum/stressor)
		incompatible_with_stressors -= stressor_id
	for(var/stressor_id in suppress_stressors)
		suppress_stressors += SSmanaged_instances.get(stressor_id, cache_category = /datum/stressor)
		suppress_stressors -= stressor_id

/datum/stressor/Destroy(force)
	if(force) // This will cause a hard del in the managed instance cache.
		return ..()
	return QDEL_HINT_LETMELIVE

/datum/stressor/proc/tick(var/mob/living/owner)
	var/expiry = LAZYACCESS(owner.stressors, src)
	if(expiry != STRESSOR_DURATION_INDEFINITE && world.time >= expiry)
		remove_from(owner)
		return 0
	return stress_value

/datum/stressor/proc/remove_from(var/mob/living/owner)
	SHOULD_CALL_PARENT(TRUE)
	if(on_removal_message)
		to_chat(owner, on_removal_message)
	LAZYREMOVE(owner.stressors, src)
	owner.update_stress()

/datum/stressor/proc/refresh(var/mob/living/owner, var/duration)
	SHOULD_CALL_PARENT(TRUE)
	if(!istype(owner) || !isnum(duration) || LAZYACCESS(owner.stressors, src) == duration)
		return
	LAZYINITLIST(owner.stressors)
	if(duration == STRESSOR_DURATION_INDEFINITE)
		owner.stressors[src] = STRESSOR_DURATION_INDEFINITE
	else
		owner.stressors[src] = max(owner.stressors[src], (world.time + duration))
	owner.update_stress()

/datum/stressor/proc/add_to(var/mob/living/owner, var/duration)
	SHOULD_CALL_PARENT(TRUE)
	if(on_addition_message)
		to_chat(owner, on_addition_message)
	for(var/stressor in suppress_stressors)
		LAZYREMOVE(owner.stressors, stressor)
	if(duration == STRESSOR_DURATION_INDEFINITE)
		LAZYSET(owner.stressors, src, STRESSOR_DURATION_INDEFINITE)
	else
		LAZYSET(owner.stressors, src, (world.time + duration))
	owner.update_stress()
