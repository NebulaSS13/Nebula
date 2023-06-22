/mob/living/slime/Life()
	. = ..()
	if(. && stat != DEAD)
		handle_turf_contents()
		handle_local_conditions()
		if(feeding_on)
			slime_feed()
		ingested.metabolize()

/mob/living/slime/updatehealth()
	. = ..()
	if(stat != DEAD && health <= 0)
		death()

/mob/living/slime/fluid_act(datum/reagents/fluids)
	. = ..()
	if(stat == DEAD)
		var/obj/effect/fluid/F = locate() in loc
		if(F && F.reagents?.total_volume >= FLUID_SHALLOW)
			F.reagents.add_reagent(/decl/material/liquid/slimejelly, (is_adult ? rand(30, 40) : rand(10, 30)))
			visible_message(SPAN_DANGER("\The [src] melts away...")) // Slimes are water soluble.
			qdel(src)

/mob/living/slime/proc/handle_local_conditions()
	var/datum/gas_mixture/environment = loc?.return_air()
	adjust_body_temperature(bodytemperature, (environment?.temperature || T0C), 1)
	if(bodytemperature <= die_temperature)
		adjustToxLoss(200)
		death()
	else if(bodytemperature <= hurt_temperature)
		adjustToxLoss(30)
		updatehealth()

/mob/living/slime/proc/adjust_body_temperature(current, loc_temp, boost)
	var/delta = abs(current-loc_temp)
	var/change = (delta / (delta > 50 ? 5 : 10)) * boost
	if(current > loc_temp)
		change = -(change)
	bodytemperature += (min(loc_temp, current + change) - current)

/mob/living/slime/handle_regular_status_updates()
	. = ..()
	if(stat != DEAD)
		set_stat(CONSCIOUS)
		if(prob(30))
			adjustOxyLoss(-1)
			adjustToxLoss(-1)
			adjustFireLoss(-1)
			adjustCloneLoss(-1)
			adjustBruteLoss(-1)

/mob/living/slime/proc/handle_turf_contents()
	// If we're standing on top of a dead mob or small items, we can
	// ingest it (or just melt it a little if we're too small)
	// Also helps to keep our cell tidy!
	if(!length(loc?.contents))
		return
	var/has_eaten_mob = locate(/mob) in contents
	var/last_contents_length = length(contents)
	for(var/atom/movable/AM in loc)
		if(AM == src || !AM.simulated)
			continue
		if(isliving(AM) && !AM.anchored && !has_eaten_mob && !isslime(AM))
			var/mob/living/M = AM
			if(M.stat == DEAD)
				if(M.mob_size <= (is_adult ? MOB_SIZE_LARGE : MOB_SIZE_SMALL))
					M.forceMove(src)
				else
					adjust_nutrition(M.eaten_by_slime(src))
				break
		else if(istype(AM, /obj/effect/decal/cleanable))
			if(!istype(AM, /obj/effect/decal/cleanable/dirt))
				adjust_nutrition(rand(2,3))
			qdel(AM)
		else if(istype(AM, /obj/item) && !AM.anchored)
			var/obj/item/thing = AM
			if(istype(thing, /obj/item/remains) || (thing.w_class <= (is_adult ? ITEM_SIZE_LARGE : ITEM_SIZE_SMALL) && prob(5)))
				AM.forceMove(src)
				break
	if(length(contents) != last_contents_length)
		queue_icon_update()

/mob/living/slime/handle_nutrition_and_hydration()

	adjust_nutrition(-(0.1 + 0.05 * is_adult))

	// Digest whatever we've got floating around in our goop.
	if(length(contents))
		var/last_contents_length = length(contents)
		for(var/atom/movable/AM in contents)
			if(ismob(AM))
				var/mob/hurk = AM
				if(hurk.mob_size > (is_adult ? MOB_SIZE_LARGE : MOB_SIZE_SMALL))
					AM.dropInto(loc)
				else if(isliving(AM))
					var/mob/living/M = AM
					adjust_nutrition(M.eaten_by_slime(src))
					queue_icon_update()
				break

			if(istype(AM, /obj/item/remains))
				if(prob(5))
					adjust_nutrition(rand(2,3))
					qdel(AM)
					break
				continue

			if(istype(AM, /obj/item))
				var/obj/item/thing = AM
				if(prob(5) || thing.w_class > (is_adult ? ITEM_SIZE_LARGE : ITEM_SIZE_SMALL))
					thing.dropInto(loc)
					break
				continue

			AM.dropInto(loc)
			break

		if(length(contents) != last_contents_length)
			queue_icon_update()

	// Update starvation and nutrition.
	if(nutrition <= 0)
		adjustToxLoss(2)
		if (client && prob(5))
			to_chat(src, SPAN_DANGER("You are starving!"))
	else if(nutrition >= get_grow_nutrition() && amount_grown < SLIME_EVOLUTION_THRESHOLD)
		adjust_nutrition(-20)
		amount_grown++

	..()

/mob/living/slime/get_max_nutrition() // Can't go above it
	. = is_adult ? 1200 : 1000

/mob/living/slime/proc/get_grow_nutrition() // Above it we grow, below it we can eat
	. = is_adult ? 1000 : 800

/mob/living/slime/proc/get_hunger_nutrition() // Below it we will always eat
	. = is_adult ? 600 : 500

/mob/living/slime/proc/get_starve_nutrition() // Below it we will eat before everything else
	. = is_adult ? 300 : 200

/mob/living/slime/slip(var/slipped_on, stun_duration = 8) //Can't slip something without legs.
	return FALSE
