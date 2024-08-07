/mob/living/simple_animal/alien/diona/UnarmedAttack(var/atom/A)

	if(incapacitated())
		return ..()

	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(loc, /obj/structure/diona_gestalt))
		var/obj/structure/diona_gestalt/gestalt = loc
		return gestalt.handle_member_click(src, A)

	if(istype(A, /obj/machinery/portable_atmospherics/hydroponics))
		return handle_tray_interaction(A)

	// This is super hacky. Not sure if I will leave this in for a final merge.
	// Reporting back from the future: keeping this because trying to refactor
	// seed storage to handle this cleanly would be a pain in the ass and I
	// don't want to touch that pile.

	if(istype(A, /obj/machinery/seed_storage))
		visible_message(SPAN_DANGER("\The [src] headbutts \the [A]!"))
		var/obj/machinery/seed_storage/G = A
		if(LAZYLEN(G.piles))
			var/datum/seed_pile/pile = pick(G.piles)
			var/obj/item/seeds/S = pick(pile.seeds)
			if(S)
				pile.amount -= 1
				pile.seeds  -= S
				if(pile.amount <= 0 || LAZYLEN(pile.seeds) <= 0)
					G.piles -= pile
					qdel(pile)
				S.forceMove(get_turf(G))
				G.visible_message(SPAN_NOTICE("\A [S] falls out!"))
		return TRUE
		// End superhacky stuff.

	if(ismob(A))
		if(src != A && !gestalt_with(A))
			visible_message(SPAN_NOTICE("\The [src] butts its head into \the [A]."))
		return TRUE
	return ..()

/mob/living/simple_animal/alien/diona/proc/handle_tray_interaction(var/obj/machinery/portable_atmospherics/hydroponics/tray)

	if(incapacitated())
		return FALSE

	if(!tray.seed)
		var/obj/item/seeds/seeds = get_active_held_item()
		if(istype(seeds))
			if(try_unequip(seeds))
				tray.plant_seed(src, seeds)
				return TRUE
			return FALSE

	if(tray.dead)
		if(tray.remove_dead(src, silent = TRUE))
			add_to_reagents(/decl/material/liquid/nutriment/glucose, rand(10,20))
			visible_message(SPAN_NOTICE("<b>\The [src]</b> chews up the dead plant, clearing \the [tray] out."), SPAN_NOTICE("You devour the dead plant, clearing \the [tray]."))
			return TRUE
		return FALSE

	if(tray.harvest)
		if(tray.harvest(src))
			visible_message(SPAN_NOTICE("<b>\The [src]</b> harvests from \the [tray]."), SPAN_NOTICE("You harvest the contents of \the [tray]."))
			return TRUE
		return FALSE

	if(tray.weedlevel || tray.pestlevel)
		add_to_reagents(/decl/material/liquid/nutriment/glucose, (tray.weedlevel + tray.pestlevel))
		tray.weedlevel = 0
		tray.pestlevel = 0
		visible_message(SPAN_NOTICE("<b>\The [src]</b> begins rooting through \the [tray], ripping out pests and weeds, and eating them noisily."),SPAN_NOTICE("You begin rooting through \the [tray], ripping out pests and weeds, and eating them noisily."))
		return TRUE

	if(tray.nutrilevel < 10)
		var/nutrition_cost = (10-tray.nutrilevel) * 5
		if(nutrition >= nutrition_cost)
			visible_message(SPAN_NOTICE("<b>\The [src]</b> secretes a trickle of green liquid, refilling [tray]."),SPAN_NOTICE("You secrete some nutrients into \the [tray]."))
			tray.nutrilevel = 10
			adjust_nutrition(-((10-tray.nutrilevel) * 5))
		else
			to_chat(src, SPAN_NOTICE("You haven't eaten enough to refill \the [tray]'s nutrients."))
		return TRUE

	if(tray.waterlevel < 100)
		var/nutrition_cost = floor((100-tray.nutrilevel)/10) * 5
		if(nutrition >= nutrition_cost)
			visible_message(SPAN_NOTICE("<b>\The [src]</b> secretes a trickle of clear liquid, refilling [tray]."),SPAN_NOTICE("You secrete some water into \the [tray]."))
			tray.waterlevel = 100
		else
			to_chat(src, SPAN_NOTICE("You haven't eaten enough to refill \the [tray]'s water."))
		return TRUE

	visible_message(SPAN_NOTICE("<b>\The [src]</b> rolls around in \the [tray] for a bit."),SPAN_NOTICE("You roll around in \the [tray] for a bit."))
	return TRUE
