//Hearing someone being shot twice
/datum/hallucination/gunfire
	duration = 15
	min_power = 30
	var/gunshot
	var/turf/origin
	var/static/list/gunshot_sounds = list(
		'sound/weapons/gunshot/gunshot_strong.ogg',
		'sound/weapons/gunshot/gunshot2.ogg',
		'sound/weapons/gunshot/shotgun.ogg',
		'sound/weapons/gunshot/gunshot.ogg',
		'sound/weapons/Taser.ogg'
	)

/datum/hallucination/gunfire/start()
	. = ..()
	gunshot = pick(gunshot_sounds)
	var/turf/holder_turf = get_turf(holder)
	if(isturf(holder_turf))
		origin = locate(holder_turf.x + rand(4,8), holder_turf.y + rand(4,8), holder_turf.z)
		if(origin)
			holder.playsound_local(origin, gunshot, 50)

/datum/hallucination/gunfire/end()
	. = ..()
	if(holder && origin)
		holder.playsound_local(origin, gunshot, 50)

/datum/hallucination/gunfire/Destroy()
	origin = null
	return ..()