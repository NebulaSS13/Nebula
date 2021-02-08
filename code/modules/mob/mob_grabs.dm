// Casting stubs for grabs, check /mob/living for full definition.
/mob/proc/apply_damage(var/damage = 0,var/damagetype = BRUTE, var/def_zone = null, var/damage_flags = 0, var/used_weapon = null, var/armor_pen, var/silent = FALSE)
	return
/mob/proc/get_blocked_ratio(def_zone, damage_type, damage_flags, armor_pen, damage)
	return
/mob/proc/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	return
/mob/proc/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	return
// See /mob/living/carbon/human for this one.
/mob/proc/get_organ(var/zone)
	return
// End grab casting stubs.
/mob/proc/get_internal_organ(var/organ_tag)
	return
/mob/proc/get_internal_organs()
	return

/mob/can_be_grabbed(var/mob/grabber, var/target_zone)
	if(!grabber.can_pull_mobs)
		to_chat(grabber, SPAN_WARNING("\The [src] won't budge!"))
		return FALSE
	. = ..() && !buckled
	if(.)
		if((grabber.mob_size < grabber.mob_size) && grabber.can_pull_mobs != MOB_PULL_LARGER)
			to_chat(grabber, SPAN_WARNING("You are too small to move \the [src]!"))
			return FALSE
		if((grabber.mob_size == mob_size) && grabber.can_pull_mobs == MOB_PULL_SMALLER)
			to_chat(grabber, SPAN_WARNING("\The [src] is too large for you to move!"))
			return FALSE
		if(iscarbon(grabber))
			last_handled_by_mob = weakref(grabber)

/mob/proc/handle_grab_damage()
	set waitfor = 0

/mob/proc/handle_grabs_after_move()
	set waitfor = 0

/mob/proc/add_grab(var/obj/item/grab/grab)
	return FALSE

/mob/proc/ProcessGrabs()
	return

/mob/proc/get_active_grabs()
	. = list()
	for(var/obj/item/grab/grab in contents)
		. += grab
