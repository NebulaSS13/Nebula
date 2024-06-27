/mob/living/human/process_resist()

	//drop && roll
	if(on_fire && !buckled)
		fire_stacks -= 1.2
		SET_STATUS_MAX(src, STAT_WEAK, 3)
		spin(32,2)
		visible_message(
			"<span class='danger'>[src] rolls on the floor, trying to put themselves out!</span>",
			"<span class='notice'>You stop, drop, and roll!</span>"
			)
		sleep(30)
		if(fire_stacks <= 0)
			visible_message(
				"<span class='danger'>[src] has successfully extinguished themselves!</span>",
				"<span class='notice'>You extinguish yourself.</span>"
				)
			ExtinguishMob()
		return TRUE

	if(istype(buckled, /obj/effect/vine))
		var/obj/effect/vine/V = buckled
		spawn() V.manual_unbuckle(src)
		return TRUE

	if(..())
		return TRUE

	if(get_equipped_item(slot_handcuffed_str))
		spawn() escape_handcuffs()

/mob/living/human/proc/escape_handcuffs()
	//This line represent a significant buff to grabs...
	// We don't have to check the click cooldown because /mob/living/verb/resist() has done it for us, we can simply set the delay
	setClickCooldown(100)

	if(can_break_cuffs()) //Don't want to do a lot of logic gating here.
		break_handcuffs()
		return

	var/obj/item/handcuffs/cuffs = get_equipped_item(slot_handcuffed_str)

	//A default in case you are somehow cuffed with something that isn't an obj/item/handcuffs type
	var/breakouttime = istype(cuffs) ? cuffs.breakouttime : 2 MINUTES

	var/mob/living/human/H = src
	if(istype(H) && istype(H.get_equipped_item(slot_gloves_str), /obj/item/clothing/gloves/rig))
		breakouttime /= 2

	breakouttime = max(5, breakouttime * get_cuff_breakout_mod())

	visible_message(
		"<span class='danger'>\The [src] attempts to remove \the [cuffs]!</span>",
		"<span class='warning'>You attempt to remove \the [cuffs] (This will take around [breakouttime / (1 SECOND)] second\s and you need to stand still).</span>", range = 2
		)

	var/stages = 4
	for(var/i = 1 to stages)
		if(do_after(src, breakouttime*0.25, incapacitation_flags = INCAPACITATION_DEFAULT & ~INCAPACITATION_RESTRAINED))
			cuffs = get_equipped_item(slot_handcuffed_str)
			if(!cuffs || buckled)
				return
			visible_message(
				SPAN_WARNING("\The [src] fiddles with \the [cuffs]."),
				SPAN_WARNING("You try to slip free of \the [cuffs] ([i*100/stages]% done)."), range = 2
				)
		else
			cuffs = get_equipped_item(slot_handcuffed_str)
			if(!cuffs || buckled)
				return
			visible_message(
				SPAN_WARNING("\The [src] stops fiddling with \the [cuffs]."),
				SPAN_WARNING("You stop trying to slip free of \the [cuffs]."), range = 2
				)
			return
		if(!cuffs || buckled)
			return
	if (cuffs.can_take_damage() && cuffs.current_health > 0) // Improvised cuffs can break because their health is > 0
		var/cuffs_name = "\the [cuffs]"
		cuffs.take_damage(cuffs.get_max_health() / 2)
		if (QDELETED(cuffs) || cuffs.current_health < 1)
			visible_message(
				SPAN_DANGER("\The [src] manages to remove [cuffs_name], breaking them!"),
				SPAN_NOTICE("You successfully remove [cuffs_name], breaking them!"), range = 2
				)
			QDEL_NULL(cuffs)
			if(buckled && buckled.buckle_require_restraints)
				buckled.unbuckle_mob()
			update_equipment_overlay(slot_handcuffed_str)
			return
	visible_message(
		SPAN_WARNING("\The [src] manages to remove \the [cuffs]!"),
		SPAN_NOTICE("You successfully remove \the [cuffs]!"), range = 2
		)
	drop_from_inventory(cuffs)
	return

/mob/living/human/proc/break_handcuffs()
	var/obj/item/cuffs = get_equipped_item(slot_handcuffed_str)
	visible_message(
		"<span class='danger'>[src] is trying to break \the [cuffs]!</span>",
		"<span class='warning'>You attempt to break your [cuffs]. (This will take around 5 seconds and you need to stand still)</span>"
		)

	if(do_after(src, 5 SECONDS, incapacitation_flags = INCAPACITATION_DEFAULT & ~INCAPACITATION_RESTRAINED))
		cuffs = get_equipped_item(slot_handcuffed_str)
		if(!cuffs || buckled)
			return

		visible_message(
			"<span class='danger'>[src] manages to break \the [cuffs]!</span>",
			"<span class='warning'>You successfully break your [cuffs].</span>"
		)

		try_unequip(cuffs)
		qdel(cuffs)
		if(buckled && buckled.buckle_require_restraints)
			buckled.unbuckle_mob()
