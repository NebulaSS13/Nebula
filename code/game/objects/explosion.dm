//TODO: Flash range does nothing currently
/proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1, z_transfer = UP|DOWN)
	if(get_config_value(/decl/config/toggle/use_iterative_explosions))
		. = explosion_iter(epicenter, (devastation_range * 2 + heavy_impact_range + light_impact_range), z_transfer)
	else
		. = explosion_basic(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog, z_transfer)

/proc/explosion_basic(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1, z_transfer = UP|DOWN)
	set waitfor = FALSE

	epicenter = get_turf(epicenter)
	if(!epicenter)
		return

	var/start_time = REALTIMEOFDAY
	// Handles recursive propagation of explosions.
	if(z_transfer)
		var/multi_z_scalar = 0.35
		var/adj_dev   = max(0, (multi_z_scalar * devastation_range))
		var/adj_heavy = max(0, (multi_z_scalar * heavy_impact_range))
		var/adj_light = max(0, (multi_z_scalar * light_impact_range))
		var/adj_flash = max(0, (multi_z_scalar * flash_range))
		if(adj_dev > 0 || adj_heavy > 0)
			if((z_transfer & UP) && HasAbove(epicenter.z))
				explosion_basic(GetAbove(epicenter), adj_dev, adj_heavy, adj_light, adj_flash, 0, UP)
			if((z_transfer & DOWN) && HasBelow(epicenter.z))
				explosion_basic(GetBelow(epicenter), adj_dev, adj_heavy, adj_light, adj_flash, 0, DOWN)

	var/max_range = max(devastation_range, heavy_impact_range, light_impact_range, flash_range)

	// Play sounds; we want sounds to be different depending on distance so we will manually do it ourselves.
	// Stereo users will also hear the direction of the explosion!
	// Calculate far explosion sound range. Only allow the sound effect for heavy/devastating explosions.
	// 3/7/14 will calculate to 80 + 35
	var/far_dist = 0
	far_dist += heavy_impact_range * 5
	far_dist += devastation_range * 20
	var/frequency = get_rand_frequency()
	for(var/mob/M in global.player_list)
		if(M.z == epicenter.z)
			var/turf/M_turf = get_turf(M)
			var/dist = get_dist(M_turf, epicenter)
			// If inside the blast radius + world.view - 2
			if(dist <= round(max_range + world.view - 2, 1))
				M.playsound_local(epicenter, get_sfx("explosion"), 100, 1, frequency, falloff = 5) // get_sfx() is so that everyone gets the same sound
			else if(dist <= far_dist)
				var/far_volume = clamp(far_dist, 30, 50) // Volume is based on explosion size and dist
				far_volume += (dist <= far_dist * 0.5 ? 50 : 0) // add 50 volume if the mob is pretty close to the explosion
				M.playsound_local(epicenter, 'sound/effects/explosionfar.ogg', far_volume, 1, frequency, falloff = 5)

	if(adminlog)
		log_and_message_admins("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]) (<A HREF='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[epicenter.x];Y=[epicenter.y];Z=[epicenter.z]'>JMP</a>)")

	var/approximate_intensity = (devastation_range * 3) + (heavy_impact_range * 2) + light_impact_range
	// Large enough explosion. For performance reasons, powernets will be rebuilt manually
	if(!defer_powernet_rebuild && (approximate_intensity > 25))
		defer_powernet_rebuild = 1

	if(heavy_impact_range > 1)
		var/datum/effect/system/explosion/E = new/datum/effect/system/explosion()
		E.set_up(epicenter)
		E.start()

	var/x0 = epicenter.x
	var/y0 = epicenter.y
	var/z0 = epicenter.z
	for(var/turf/T as anything in RANGE_TURFS(epicenter, max_range))
		var/dist = sqrt((T.x - x0)**2 + (T.y - y0)**2)
		if(dist < devastation_range)
			dist = 1
		else if(dist < heavy_impact_range)
			dist = 2
		else if(dist < light_impact_range)
			dist = 3
		else
			continue

		var/throw_dist = 9/dist
		T.explosion_act(dist)
		if(!T)
			T = locate(x0,y0,z0)
		if(T)
			var/throw_target = get_edge_target_turf(T, get_dir(epicenter,T))
			for(var/atom_movable in T.contents)
				var/atom/movable/AM = atom_movable
				if(AM && AM.simulated && !T.protects_atom(AM))
					AM.explosion_act(dist)
					if(!QDELETED(AM) && !AM.anchored && isturf(AM.loc))
						addtimer(CALLBACK(AM, TYPE_PROC_REF(/atom/movable, throw_at), throw_target, throw_dist, throw_dist), 0)

	var/took = (REALTIMEOFDAY-start_time)/10
	if(Debug2)
		to_world_log("## DEBUG: Explosion([x0],[y0],[z0])(d[devastation_range],h[heavy_impact_range],l[light_impact_range]): Took [took] seconds.")
	return 1

#define EXPLFX_BOTH 3
#define EXPLFX_SOUND 2
#define EXPLFX_SHAKE 1
#define EXPLFX_NONE 0

// All the vars used on the turf should be on unsimulated turfs too, we just don't care about those generally.
#define SEARCH_DIR(dir) \
	search_direction = dir;\
	search_turf = get_step(current_turf, search_direction);\
	if (isturf(search_turf)) {\
		turf_queue += search_turf;\
		dir_queue += search_direction;\
		power_queue += current_power;\
	}

/proc/explosion_iter(turf/epicenter, power, z_transfer)
	set waitfor = FALSE
	if(power <= 0)
		return
	epicenter = get_turf(epicenter)
	if(!epicenter)
		return
	message_admins("Explosion with size ([power]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z])")
	log_game("Explosion with size ([power]) in area [epicenter.loc.name] ")
	log_debug("iexpl: Beginning discovery phase.")
	var/time = REALTIMEOFDAY
	var/list/act_turfs = list()
	act_turfs[epicenter] = power

	power -= epicenter.explosion_resistance
	for (var/obj/O in epicenter)
		if (O.explosion_resistance)
			power -= O.explosion_resistance

	if (power >= get_config_value(/decl/config/num/iterative_explosives_z_threshold))
		var/explo_mult = get_config_value(/decl/config/num/iterative_explosives_z_multiplier)
		if ((z_transfer & UP) && HasAbove(epicenter.z))
			explosion_iter(GetAbove(epicenter), power * explo_mult, UP)
		if ((z_transfer & DOWN) && HasBelow(epicenter.z))
			explosion_iter(GetBelow(epicenter), power * explo_mult, DOWN)

	// These three lists must always be the same length.
	var/list/turf_queue = list(epicenter, epicenter, epicenter, epicenter)
	var/list/dir_queue = list(NORTH, SOUTH, EAST, WEST)
	var/list/power_queue = list(power, power, power, power)

	var/turf/current_turf
	var/turf/search_turf
	var/origin_direction
	var/search_direction
	var/current_power
	var/index = 1
	while (index <= turf_queue.len)
		current_turf = turf_queue[index]
		origin_direction = dir_queue[index]
		current_power = power_queue[index]
		++index

		if (!istype(current_turf) || current_power <= 0)
			CHECK_TICK
			continue

		if (act_turfs[current_turf] >= current_power && current_turf != epicenter)
			CHECK_TICK
			continue

		act_turfs[current_turf] = current_power
		current_power -= current_turf.explosion_resistance

		// Attempt to shortcut on empty tiles: if a turf only has a LO on it, we don't need to check object resistance. Some turfs might not have LOs, so we need to check it actually has one.
		if (current_turf.contents.len > !!current_turf.lighting_overlay)
			for (var/thing in current_turf)
				var/atom/movable/AM = thing
				if (AM.simulated && AM.explosion_resistance)
					current_power -= AM.explosion_resistance

		if (current_power <= 0)
			CHECK_TICK
			continue

		SEARCH_DIR(origin_direction)
		SEARCH_DIR(turn(origin_direction, 90))
		SEARCH_DIR(turn(origin_direction, -90))

		CHECK_TICK

	log_debug("iexpl: Discovery completed in [(REALTIMEOFDAY-time)/10] seconds.")
	log_debug("iexpl: Beginning SFX phase.")
	time = REALTIMEOFDAY

	var/volume = 10 + (power * 20)

	var/frequency = get_rand_frequency()
	var/close_dist = round(power + world.view - 2, 1)

	var/sound/explosion_sound = sound(get_sfx("explosion"))

	for (var/thing in global.player_list)
		var/mob/M = thing
		var/reception = EXPLFX_BOTH
		var/turf/T = isturf(M.loc) ? M.loc : get_turf(M)

		if (!T)
			CHECK_TICK
			continue

		if (!LEVELS_ARE_Z_CONNECTED(T.z, epicenter.z))
			CHECK_TICK
			continue

		if (T.type == /turf/space)	// Equality is faster than istype.
			reception = EXPLFX_NONE

			for (var/turf/THING as anything in RANGE_TURFS(M, 1))
				reception |= EXPLFX_SHAKE
				break

			if (!reception)
				CHECK_TICK
				continue

		var/dist = get_dist(M, epicenter) || 1
		if ((reception & EXPLFX_SOUND) && !HAS_STATUS(M, STAT_DEAF))
			if (dist <= close_dist)
				M.playsound_local(epicenter, explosion_sound, min(100, volume), 1, frequency, falloff = 5)
				//You hear a far explosion if you're outside the blast radius. Small bombs shouldn't be heard all over the station.
			else
				volume = M.playsound_local(epicenter, 'sound/effects/explosionfar.ogg', volume, 1, frequency, falloff = 1000)

		if ((reception & EXPLFX_SHAKE) && volume > 0)
			shake_camera(M, min(30, max(2,(power*2) / dist)), min(3.5, ((power/3) / dist)),0.05)
			//Maximum duration is 3 seconds, and max strength is 3.5
			//Becuse values higher than those just get really silly

		CHECK_TICK

	log_debug("iexpl: SFX phase completed in [(REALTIMEOFDAY-time)/10] seconds.")
	log_debug("iexpl: Beginning application phase.")
	time = REALTIMEOFDAY

	var/turf_tally = 0
	var/movable_tally = 0
	for (var/thing in act_turfs)
		var/turf/T = thing
		if (act_turfs[T] <= 0)
			CHECK_TICK
			continue

		var/severity = 4 - round(max(min( 3, ((act_turfs[T] - T.explosion_resistance) / (max(3,(power/3)))) ) ,1), 1)
		//sanity			effective power on tile				divided by either 3 or one third the total explosion power
		//															One third because there are three power levels and I
		//															want each one to take up a third of the crater
		var/throw_target = get_edge_target_turf(T, get_dir(epicenter,T))
		var/throw_dist = 9/severity
		if (T.simulated)
			T.explosion_act(severity)
		if (T.contents.len > !!T.lighting_overlay)
			for (var/subthing in T)
				var/atom/movable/AM = subthing
				if (AM.simulated)
					AM.explosion_act(severity)
					if(!QDELETED(AM) && !AM.anchored)
						addtimer(CALLBACK(AM, TYPE_PROC_REF(/atom/movable, throw_at), throw_target, throw_dist, throw_dist), 0)
				movable_tally++
				CHECK_TICK
		else
			CHECK_TICK
	turf_tally++
	log_debug("iexpl: Application completed in [(REALTIMEOFDAY-time)/10] seconds; processed [turf_tally] turfs and [movable_tally] movables.")

#undef SEARCH_DIR
#undef EXPLFX_BOTH
#undef EXPLFX_SOUND
#undef EXPLFX_SHAKE
#undef EXPLFX_NONE
