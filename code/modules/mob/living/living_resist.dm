/mob/living/proc/escape_buckle()

	if(!buckled)
		return

	var/unbuckle_time
	if(get_equipped_item(slot_handcuffed_str) && istype(buckled, /obj/effect/energy_net))
		var/obj/effect/energy_net/N = buckled
		N.escape_net(src) //super snowflake but is literally used NOWHERE ELSE.-Luke
		return

	if(!restrained())
		if(buckled.can_buckle)
			buckled.user_unbuckle_mob(src)
		else
			to_chat(usr, "<span class='warning'>You can't seem to escape from \the [buckled]!</span>")
		return

	setClickCooldown(100)
	unbuckle_time = max(0, (2 MINUTES) - get_special_resist_time())

	visible_message(
		"<span class='danger'>[src] attempts to unbuckle themself!</span>",
		"<span class='warning'>You attempt to unbuckle yourself. (This will take around [unbuckle_time / (1 SECOND)] second\s and you need to stand still)</span>", range = 2
	)

	if(unbuckle_time && buckled)
		var/stages = 2
		for(var/i = 1 to stages)
			if(!unbuckle_time || do_after(usr, unbuckle_time*0.5, incapacitation_flags = INCAPACITATION_DEFAULT & ~(INCAPACITATION_RESTRAINED | INCAPACITATION_BUCKLED_FULLY)))
				if(!buckled)
					return
				visible_message(
					SPAN_WARNING("\The [src] tries to unbuckle themself."),
					SPAN_WARNING("You try to unbuckle yourself ([i*100/stages]% done)."), range = 2
					)
			else
				if(!buckled)
					return
				visible_message(
					SPAN_WARNING("\The [src] stops trying to unbuckle themself."),
					SPAN_WARNING("You stop trying to unbuckle yourself."), range = 2
					)
				return
		visible_message(
			SPAN_DANGER("\The [src] manages to unbuckle themself!"),
			SPAN_NOTICE("You successfully unbuckle yourself."), range = 2
			)
		buckled.user_unbuckle_mob(src)
		return

/mob/living/proc/resist_grab()
	var/resisting = 0
	for(var/obj/item/grab/grab as anything in grabbed_by)
		resisting++
		grab.handle_resist()
	if(resisting)
		visible_message("<span class='danger'>[src] resists!</span>")

/mob/living/proc/get_restraint_breakout_mod()
	return 1

/mob/living/proc/can_break_restraints()
	var/decl/species/my_species = get_species()
	return my_species?.can_shred(src, 1)

/mob/living/proc/get_special_resist_time()
	return 0

/mob/living/proc/break_restraints(obj/item/restraint, slot)
	visible_message(
		SPAN_DANGER("\The [src] is trying to break \the [restraint]!"),
		SPAN_DANGER("You attempt to break your [restraint]. (This will take around 5 seconds and you need to stand still)")
	)

	if(!do_after(src, 5 SECONDS, incapacitation_flags = INCAPACITATION_DEFAULT & ~INCAPACITATION_RESTRAINED))
		return FALSE

	if(QDELETED(src) || QDELETED(restraint))
		return FALSE

	var/new_restraint = get_equipped_item(slot)
	if((restraint != new_restraint) || buckled)
		return FALSE

	visible_message(
		SPAN_DANGER("\The [src] manages to break \the [restraint]!"),
		SPAN_DANGER("You successfully break your [restraint].")
	)

	try_unequip(restraint)
	qdel(restraint)
	if(buckled && buckled.buckle_require_restraints && !get_restraining_equipment())
		buckled.unbuckle_mob()
