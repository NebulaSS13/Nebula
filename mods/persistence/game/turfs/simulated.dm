/turf/simulated/before_save()
	..()
	if(fire && fire.firelevel > 0)
		is_on_fire = fire.firelevel
	else
		is_on_fire = 0
	if(zone)
		c_copy_air()
	saved_decals = list()
	for(var/image/I in decals)
		var/datum/wrapper/decal/decal = new (I, src)
		saved_decals.Add(decal)

/turf/simulated/after_save()
	..()
	for(var/decal in saved_decals)
		qdel(decal)
	saved_decals = null