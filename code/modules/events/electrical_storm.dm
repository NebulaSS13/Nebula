/datum/event/electrical_storm
	announceWhen = 0		// Warn them shortly before it begins.
	startWhen = 30
	endWhen = 60			// Set in start()
	has_skybox_image = TRUE
	var/list/valid_apcs		// Shuffled list of valid APCs.
	var/static/lightning_color
	var/last_bounce //track the last time we bounced around whatever overmap effect we're affecting.
	var/bounce_delay = 10 SECONDS // this is divided by severity, so a intense storm means you're going *flying*.
	var/static/lightning_sounds = list(
		'sound/effects/thunder/thunder1.ogg',
		'sound/effects/thunder/thunder2.ogg',
		'sound/effects/thunder/thunder3.ogg',
		'sound/effects/thunder/thunder4.ogg',
		'sound/effects/thunder/thunder5.ogg',
		'sound/effects/thunder/thunder6.ogg',
		'sound/effects/thunder/thunder7.ogg',
		'sound/effects/thunder/thunder8.ogg',
		'sound/effects/thunder/thunder9.ogg',
		'sound/effects/thunder/thunder10.ogg'
		)


/datum/event/electrical_storm/get_skybox_image()
	if(!lightning_color)
		lightning_color = pick("#ffd98c", "#ebc7ff", "#bdfcff", "#bdd2ff", "#b0ffca", "#ff8178", "#ad74cc")
	var/image/res = overlay_image('icons/skybox/electrobox.dmi', "lightning", lightning_color, RESET_COLOR)
	res.blend_mode = BLEND_ADD
	return res

/datum/event/electrical_storm/announce()
	..()
	switch(severity)
		if(EVENT_LEVEL_MUNDANE)
			command_announcement.Announce("A minor electrical storm has been detected near the [location_name()]. Please watch out for possible electrical discharges.", "[location_name()] Sensor Array", zlevels = affecting_z)
		if(EVENT_LEVEL_MODERATE)
			command_announcement.Announce("The [location_name()] is about to pass through an electrical storm. Please secure sensitive electrical equipment until the storm passes.", "[location_name()] Sensor Array", new_sound = global.using_map.electrical_storm_moderate_sound, zlevels = affecting_z)
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce("Alert. A strong electrical storm has been detected in proximity of the [location_name()]. It is recommended to immediately secure sensitive electrical equipment until the storm passes.", "[location_name()] Sensor Array", new_sound = global.using_map.electrical_storm_major_sound, zlevels = affecting_z)

/datum/event/electrical_storm/start()
	..()
	endWhen = (severity * 60) + startWhen

/datum/event/electrical_storm/tick()

	..()

	//See if shields can stop it first
	var/overmap_only = TRUE
	var/list/overmap_sectors = list()
	if(!length(affecting_z))
		return

	for(var/i in affecting_z)
		var/obj/effect/overmap/visitable/sector = global.overmap_sectors[num2text(i)]
		if(istype(sector))
			overmap_sectors |= sector
		else
			overmap_only = FALSE
			break

	var/list/shields = list()
	if(overmap_only)
		for(var/obj/effect/overmap/visitable/sector as anything in overmap_sectors)
			var/list/sector_shields = sector.get_linked_machines_of_type(/obj/machinery/shield_generator)
			if(length(sector_shields))
				shields |= sector_shields
	else
		for(var/obj/machinery/shield_generator/G in SSmachines.machinery)
			if(G.z in affecting_z)
				shields |= G

	for(var/obj/machinery/shield_generator/G as anything in shields)
		if(!(G.running) || !G.check_flag(MODEFLAG_EM))
			shields -= G

	var/shielded = FALSE
	if(length(shields))
		var/obj/machinery/shield_generator/shield_gen = pick(shields)
		//Minor breaches aren't enough to let through frying amounts of power
		if(shield_gen.take_shield_damage(30 * severity, SHIELD_DAMTYPE_EM) <= SHIELD_BREACHED_MINOR)
			shielded = TRUE

	valid_apcs = list()
	for(var/obj/machinery/power/apc/A as anything in global.all_apcs)
		if(!A.is_critical && (A.z in affecting_z))
			valid_apcs.Add(A)

	if(length(valid_apcs) < 2)
		log_debug("Insufficient APCs found for electrical storm event! This is likely a bug.")
	else
		var/list/picked_apcs = list()
		for(var/i=0, i< severity*2, i++) // up to 2/4/6 APCs per tick depending on severity
			picked_apcs |= pick(valid_apcs)

		for(var/obj/machinery/power/apc/T as anything in picked_apcs)
			// Main breaker is turned off. Consider this APC protected.
			if(!T.operating || T.failure_timer)
				continue

			if(!shielded) //If there's a shield doing it's thing, we don't bother to  actually mess with anything. We still make a racket, though.
				spark_at(get_turf(T), amount = 4, cardinal_only = TRUE) //always spark a little if we're affected.
				// Decent chance to overload lighting circuit.
				if(prob(3 * severity))
					T.overload_lighting()

				// Relatively small chance to emag the apc as apc_damage event does.
				if(prob(0.2 * severity))
					T.emagged = 1
					T.update_icon()

				if(T.is_critical)
					T.energy_fail(10 * severity)
					continue
				else
					T.energy_fail(10 * severity * rand(severity * 2, severity * 4))

				// Very tiny chance to completely break the APC. Has a check to ensure we don't break critical APCs such as the Engine room, or AI core. Does not occur on Mundane severity.
				if(prob((0.2 * severity) - 0.2))
					T.set_broken()

			for(var/mob/living/human/H in T.area)
				to_chat(H, SPAN_WARNING("You feel the hairs on the back of your neck standing up!"))
				if(prob(25))
					if(H.eyecheck() == FLASH_PROTECTION_NONE)
						H.flash_eyes()
						to_chat(H, SPAN_DANGER("You're briefly blinded by an electrical discharge!"))

			playsound(T.loc, pick(lightning_sounds), 100, 1, world.view * 4, frequency = get_rand_frequency())

	//If we are affecting a movable overmap object, bounce it around a little. This will either increase the speed the ship is moving at, or change the heading. It is more likely to increase the speed.
	var/obj/effect/overmap/visitable/ship/S
	for(var/obj/effect/overmap/visitable/ship/V in SSshuttle.ships) //Find the overmap object.
		for(var/Z in V.map_z)
			if(Z in affecting_z)
				S = V

	if(S && last_bounce <= world.time && !shielded)
		var/acceleration = rand(1,10) * severity
		var/actual_accel = clamp(acceleration, KM_OVERMAP_RATE, 0)
		if(prob(50)) //Small chance to fuck the heading up.
			S.set_dir(rand(1,8))

		var/ax = 0
		if (S.dir & EAST)
			ax = actual_accel
		else if (S.dir & WEST)
			ax = -actual_accel

		var/ay = 0
		if (S.dir & NORTH)
			ay = actual_accel
		else if (S.dir & SOUTH)
			ay = -actual_accel

		if (ax || ay)
			S.adjust_speed(ax, ay)

		last_bounce = world.time + (bounce_delay / severity)
		for(var/mob/living/human/H in global.living_mob_list_) //Affect mobs, skip synthetics.
			if(!(H.z in affecting_z) || isnull(H) || QDELETED(H))
				continue
			to_chat(H, SPAN_WARNING("You're shaken about as the storm disrupts the ship's course!"))
			shake_camera(H, 2, 1)

/datum/event/electrical_storm/end()
	..()
	command_announcement.Announce("The [location_name()] has cleared the electrical storm. Please repair any electrical overloads.", "Electrical Storm Alert", zlevels = affecting_z)
