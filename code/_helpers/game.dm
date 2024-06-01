//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/proc/is_on_same_plane_or_station(var/z1, var/z2)
	if(z1 == z2)
		return 1
	if(isStationLevel(z1) && isStationLevel(z2))
		return 1
	return 0

/proc/living_observers_present(var/list/zlevels)
	if(LAZYLEN(zlevels))
		for(var/mob/M in global.player_list) //if a tree ticks on the empty zlevel does it really tick
			if(M.stat != DEAD) //(no it doesn't)
				var/turf/T = get_turf(M)
				if(T && (T.z in zlevels))
					return TRUE
	return FALSE

/proc/get_area_name(O) //get area's proper name
	var/area/A = get_area(O)
	return A?.proper_name

/proc/get_area_by_name(N) //get area by its name
	for(var/area/A in global.areas)
		if(A.proper_name == N)
			return A
	return 0

/proc/in_range(atom/source, mob/user)
	if(get_dist(source, user) <= 1)
		return TRUE

	return FALSE //not in range and not telekinetic

// Like view but bypasses luminosity check

/proc/hear(var/range, var/atom/source)

	var/lum = source.luminosity
	source.luminosity = 6

	var/list/heard = view(range, source)
	source.luminosity = lum

	return heard

// These are procs rather than macros so they can be used as predicates, I think(?)
/proc/isSealedLevel(var/level)
	return level in SSmapping.sealed_levels

/proc/isMapLevel(var/level)
	return level in SSmapping.map_levels

/proc/isStationLevel(var/level)
	return level in SSmapping.station_levels

/proc/isNotStationLevel(var/level)
	return !isStationLevel(level)

/proc/isPlayerLevel(var/level)
	return level in SSmapping.player_levels

/proc/isAdminLevel(var/level)
	return level in SSmapping.admin_levels

/proc/isNotAdminLevel(var/level)
	return !isAdminLevel(level)

/proc/isContactLevel(var/level)
	return level in SSmapping.contact_levels

/proc/circlerange(center=usr,radius=3)

	var/turf/centerturf = get_turf(center)
	var/list/turfs = new/list()
	var/rsq = radius * (radius+0.5)

	for(var/atom/T in range(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			turfs += T

	//turfs += centerturf
	return turfs

/proc/circleview(center=usr,radius=3)

	var/turf/centerturf = get_turf(center)
	var/list/atoms = new/list()
	var/rsq = radius * (radius+0.5)

	for(var/atom/A in view(radius, centerturf))
		var/dx = A.x - centerturf.x
		var/dy = A.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			atoms += A

	//turfs += centerturf
	return atoms

/proc/get_dist_euclidian(atom/Loc1, atom/Loc2)
	var/dx = Loc1.x - Loc2.x
	var/dy = Loc1.y - Loc2.y

	var/dist = sqrt(dx**2 + dy**2)

	return dist

/proc/get_dist_bounds(var/target, var/source) // Alternative to get_dist for multi-turf objects
	return CEILING(bounds_dist(target, source)/world.icon_size) + 1

/proc/circlerangeturfs(center=usr,radius=3)
	var/turf/centerturf = get_turf(center)
	. = list()
	if(!centerturf)
		return

	var/rsq = radius * (radius+0.5)

	for(var/turf/T in range(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			. += T

/proc/circleviewturfs(center=usr,radius=3)

	var/turf/centerturf = get_turf(center)
	var/list/turfs = new/list()
	var/rsq = radius * (radius+0.5)

	for(var/turf/T in view(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			turfs += T
	return turfs



//var/debug_mob = 0

// Will recursively loop through an atom's contents and check for mobs, then it will loop through every atom in that atom's contents.
// It will keep doing this until it checks every content possible. This will fix any problems with mobs, that are inside objects,
// being unable to hear people due to being in a box within a bag.

/proc/recursive_content_check(var/atom/O,  var/list/L = list(), var/recursion_limit = 3, var/client_check = 1, var/sight_check = 1, var/include_mobs = 1, var/include_objects = 1)

	if(!recursion_limit)
		return L

	for(var/I in O.contents)

		if(ismob(I))
			if(!sight_check || isInSight(I, O))
				L |= recursive_content_check(I, L, recursion_limit - 1, client_check, sight_check, include_mobs, include_objects)
				if(include_mobs)
					if(client_check)
						var/mob/M = I
						if(M.client)
							L |= M
					else
						L |= I

		else if(istype(I,/obj/))
			if(!sight_check || isInSight(I, O))
				L |= recursive_content_check(I, L, recursion_limit - 1, client_check, sight_check, include_mobs, include_objects)
				if(include_objects)
					L |= I

	return L

// Returns a list of mobs and/or objects in range of R from source. Used in radio and say code.

/proc/get_mobs_or_objects_in_view(var/R, var/atom/source, var/include_mobs = 1, var/include_objects = 1)

	var/turf/T = get_turf(source)
	var/list/hear = list()

	if(!T)
		return hear

	var/list/range = hear(R, T)
	for(var/I in range)
		if(ismob(I))
			hear |= recursive_content_check(I, hear, 3, 1, 0, include_mobs, include_objects)
			if(include_mobs)
				var/mob/M = I
				if(M.client)
					hear += M
		else if(istype(I,/obj/))
			hear |= recursive_content_check(I, hear, 3, 1, 0, include_mobs, include_objects)
			if(include_objects)
				hear += I
	return hear

/proc/get_mobs_and_objs_in_view_fast(var/turf/T, var/range, var/list/mobs, var/list/objs, var/check_ghosts = null)
	var/list/hear = list()
	DVIEW(hear, range, T, INVISIBILITY_MAXIMUM)
	var/list/hearturfs = list()

	for(var/atom/movable/AM in hear)
		if(ismob(AM))
			mobs += AM
			hearturfs += get_turf(AM)
		else if(isobj(AM))
			objs += AM
			hearturfs += get_turf(AM)

	for(var/mob/M in global.player_list)
		if(check_ghosts && M.stat == DEAD && M.get_preference_value(check_ghosts) != PREF_NEARBY)
			mobs |= M
		else if(get_turf(M) in hearturfs)
			mobs |= M

	for(var/obj/O in global.listening_objects)
		if(get_turf(O) in hearturfs)
			objs |= O





/proc/inLineOfSight(X1,Y1,X2,Y2,Z=1,PX1=16.5,PY1=16.5,PX2=16.5,PY2=16.5)
	var/turf/T
	if(X1==X2)
		if(Y1==Y2)
			return 1 //Light cannot be blocked on same tile
		else
			var/s = SIMPLE_SIGN(Y2-Y1)
			Y1+=s
			while(Y1!=Y2)
				T=locate(X1,Y1,Z)
				if(T.opacity)
					return 0
				Y1+=s
	else
		var/m=(32*(Y2-Y1)+(PY2-PY1))/(32*(X2-X1)+(PX2-PX1))
		var/b=(Y1+PY1/32-0.015625)-m*(X1+PX1/32-0.015625) //In tiles
		var/signX = SIMPLE_SIGN(X2-X1)
		var/signY = SIMPLE_SIGN(Y2-Y1)
		if(X1<X2)
			b+=m
		while(X1!=X2 || Y1!=Y2)
			if(round(m*X1+b-Y1))
				Y1+=signY //Line exits tile vertically
			else
				X1+=signX //Line exits tile horizontally
			T=locate(X1,Y1,Z)
			if(T.opacity)
				return 0
	return 1

/proc/isInSight(var/atom/A, var/atom/B)
	var/turf/Aturf = get_turf(A)
	var/turf/Bturf = get_turf(B)

	if(!Aturf || !Bturf)
		return 0

	if(inLineOfSight(Aturf.x,Aturf.y, Bturf.x,Bturf.y,Aturf.z))
		return 1

	else
		return 0

/proc/get_mob_by_key(var/key)
	for(var/mob/M in SSmobs.mob_list)
		if(M.ckey == lowertext(key))
			return M
	return null

/datum/projectile_data
	var/src_x
	var/src_y
	var/time
	var/distance
	var/power_x
	var/power_y
	var/dest_x
	var/dest_y

/datum/projectile_data/New(var/src_x, var/src_y, var/time, var/distance, \
						   var/power_x, var/power_y, var/dest_x, var/dest_y)
	src.src_x = src_x
	src.src_y = src_y
	src.time = time
	src.distance = distance
	src.power_x = power_x
	src.power_y = power_y
	src.dest_x = dest_x
	src.dest_y = dest_y

/proc/MixColors(const/list/colors)
	var/list/reds = list()
	var/list/blues = list()
	var/list/greens = list()
	var/list/weights = list()

	for (var/i = 0, ++i <= colors.len)
		reds.Add(HEX_RED(colors[i]))
		blues.Add(HEX_BLUE(colors[i]))
		greens.Add(HEX_GREEN(colors[i]))
		weights.Add(1)

	var/r = mixOneColor(weights, reds)
	var/g = mixOneColor(weights, greens)
	var/b = mixOneColor(weights, blues)
	return rgb(r,g,b)

/proc/mixOneColor(var/list/weight, var/list/color)
	if (!weight || !color || length(weight)!=length(color))
		return 0

	var/contents = length(weight)
	var/i

	//normalize weights
	var/listsum = 0
	for(i=1; i<=contents; i++)
		listsum += weight[i]
	for(i=1; i<=contents; i++)
		weight[i] /= listsum

	//mix them
	var/mixedcolor = 0
	for(i=1; i<=contents; i++)
		mixedcolor += weight[i]*color[i]
	mixedcolor = round(mixedcolor)

	//until someone writes a formal proof for this algorithm, let's keep this in
//	if(mixedcolor<0x00 || mixedcolor>0xFF)
//		return 0
	//that's not the kind of operation we are running here, nerd
	mixedcolor=min(max(mixedcolor,0),255)

	return mixedcolor

/**
* Gets the highest and lowest pressures from the tiles in cardinal directions
* around us, then checks the difference.
*/
/proc/get_surrounding_pressure_differential(var/turf/loc, atom/originator)
	var/minp = INFINITY
	var/maxp = 0
	var/has_neighbour = FALSE
	var/airblock // zeroed by ATMOS_CANPASS_TURF, declared early as microopt
	for(var/dir in global.cardinal)
		var/turf/neighbour = get_step(loc,dir)
		if(!neighbour)
			continue
		for(var/obj/O in loc)
			if(originator && O == originator)
				continue
			ATMOS_CANPASS_MOVABLE(airblock, O, neighbour)
			. |= airblock
		if(airblock & AIR_BLOCKED)
			continue
		ATMOS_CANPASS_TURF(airblock, neighbour, loc)
		if(airblock & AIR_BLOCKED)
			continue
		var/datum/gas_mixture/environment = neighbour.return_air()
		var/cp = environment ? environment.return_pressure() : 0
		has_neighbour = TRUE
		minp = min(minp, cp)
		maxp = max(maxp, cp)
	return has_neighbour ? abs(minp-maxp) : 0

/proc/convert_k2c(var/temp)
	return ((temp - T0C))

/proc/getCardinalAirInfo(var/turf/loc, var/list/stats=list("temperature"))
	var/list/temps = new/list(4)
	var/statslen = length(stats)
	for(var/dir in global.cardinal)
		var/direction
		switch(dir)
			if(NORTH)
				direction = 1
			if(SOUTH)
				direction = 2
			if(EAST)
				direction = 3
			if(WEST)
				direction = 4
		var/turf/T = get_step(loc,dir)
		var/list/rstats = new /list(statslen)
		var/datum/gas_mixture/environment = T?.return_air()
		if(environment)
			for(var/i= 1 to statslen)
				if(stats[i] == "pressure")
					rstats[i] = environment.return_pressure()
				else
					rstats[i] = environment.vars[stats[i]]
		temps[direction] = rstats
	return temps

/proc/MinutesToTicks(var/minutes)
	return SecondsToTicks(60 * minutes)

/proc/SecondsToTicks(var/seconds)
	return seconds * 10

/proc/round_is_spooky(var/spookiness_threshold = get_config_value(/decl/config/num/cult_ghostwriter_req_cultists))
	var/decl/special_role/cult = GET_DECL(/decl/special_role/cultist)
	return (cult.current_antagonists.len > spookiness_threshold)

/proc/window_flash(var/client_or_usr)
	if (!client_or_usr)
		return
	winset(client_or_usr, "mainwindow", "flash=5")
