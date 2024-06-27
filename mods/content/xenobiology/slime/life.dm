/mob/living/slime/handle_environment(datum/gas_mixture/environment)
	. = ..()

	if(environment)
		var/delta = abs(bodytemperature - environment.temperature)
		var/change = (delta / (delta > 50 ? 5 : 10))
		if(bodytemperature > environment.temperature)
			change = -(change)
		bodytemperature += (min(environment.temperature, bodytemperature + change) - bodytemperature)
	if(bodytemperature <= die_temperature)
		take_damage(200, TOX)
	else if(bodytemperature <= hurt_temperature)
		take_damage(30, TOX)

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
	. = ..()
	if(feeding_on)
		slime_feed()
	ingested.metabolize()

/mob/living/slime/fluid_act(datum/reagents/fluids)
	. = ..()
	if(!QDELETED(src) && fluids?.total_volume >= FLUID_SHALLOW && stat == DEAD)
		var/turf/T = get_turf(src)
		if(T)
			T.add_to_reagents(/decl/material/liquid/slimejelly, (is_adult ? rand(30, 40) : rand(10, 30)))
		visible_message(SPAN_DANGER("\The [src] melts away...")) // Slimes are water soluble.
		qdel(src)

/mob/living/slime/get_hunger_factor()
	return (0.1 + 0.05 * is_adult)

/mob/living/slime/get_thirst_factor()
	return 0

/mob/living/slime/fluid_act(datum/reagents/fluids)
	. = ..()
	if(stat == DEAD && fluids?.total_volume && REAGENT_VOLUME(fluids, /decl/material/liquid/water) >= FLUID_SHALLOW)
		fluids.add_reagent(/decl/material/liquid/slimejelly, (is_adult ? rand(30, 40) : rand(10, 30)))
		visible_message(SPAN_DANGER("\The [src] melts away...")) // Slimes are water soluble.
		qdel(src)

/mob/living/slime/handle_living_non_stasis_processes()
	. = ..()
	if(!.)
		return FALSE
	set_stat(CONSCIOUS)
	if(prob(30))
		heal_damage(OXY, 1, do_update_health = FALSE)
		heal_damage(TOX, 1, do_update_health = FALSE)
		heal_damage(BURN, 1, do_update_health = FALSE)
		heal_damage(CLONE, 1, do_update_health = FALSE)
		heal_damage(BRUTE, 1)

/mob/living/slime/handle_nutrition_and_hydration()
	. = ..()
	if(feeding_on)
		slime_feed()
	ingested.metabolize()

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
		take_damage(2, TOX)
		if (client && prob(5))
			to_chat(src, SPAN_DANGER("You are starving!"))
	else if(nutrition >= get_grow_nutrition() && amount_grown < SLIME_EVOLUTION_THRESHOLD)
		adjust_nutrition(-20)
		amount_grown++

	..()

/mob/living/slime/get_satiated_nutrition() // Can't go above it
	. = is_adult ? 1150 : 950

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
