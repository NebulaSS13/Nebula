//Playing a random sound
/datum/hallucination/imagined_sound/proc/get_imagined_sounds()
	var/static/list/sounds = list(
		'sound/machines/airlock.ogg',
		'sound/effects/explosionfar.ogg',
		'sound/machines/windowdoor.ogg',
		'sound/machines/twobeep.ogg'
	)
	return sounds

/datum/hallucination/imagined_sound/start()
	. = ..()
	var/turf/holder_turf = get_turf(holder)
	if(holder_turf)
		holder_turf = locate(holder_turf.x + rand(6,11), holder_turf.y + rand(6,11), holder_turf.z)
		if(holder_turf)
			holder.playsound_local(holder_turf, pick(get_imagined_sounds()) ,70)

/datum/hallucination/imagined_sound/tools/get_imagined_sounds()
	var/static/list/imagined_sounds = list(
		'sound/items/Ratchet.ogg',
		'sound/items/Welder.ogg',
		'sound/items/Crowbar.ogg',
		'sound/items/Screwdriver.ogg'
	)
	return imagined_sounds

/datum/hallucination/imagined_sound/danger
	min_power = 30

/datum/hallucination/imagined_sound/danger/get_imagined_sounds()
	var/static/list/imagined_sounds = list(
		'sound/effects/Explosion1.ogg',
		'sound/effects/Explosion2.ogg',
		'sound/effects/Glassbr1.ogg',
		'sound/effects/Glassbr2.ogg',
		'sound/effects/Glassbr3.ogg',
		'sound/weapons/smash.ogg'
	)
	return imagined_sounds

/datum/hallucination/imagined_sound/spooky
	min_power = 50

/datum/hallucination/imagined_sound/spooky/get_imagined_sounds()
	var/static/list/imagined_sounds = list(
		'sound/effects/ghost.ogg',
		'sound/effects/ghost2.ogg',
		'sound/effects/Heart Beat.ogg',
		'sound/effects/screech.ogg',
		'sound/hallucinations/behind_you1.ogg',
		'sound/hallucinations/behind_you2.ogg',
		'sound/hallucinations/far_noise.ogg',
		'sound/hallucinations/growl1.ogg',
		'sound/hallucinations/growl2.ogg',
		'sound/hallucinations/growl3.ogg',
		'sound/hallucinations/im_here1.ogg',
		'sound/hallucinations/im_here2.ogg',
		'sound/hallucinations/i_see_you1.ogg',
		'sound/hallucinations/i_see_you2.ogg',
		'sound/hallucinations/look_up1.ogg',
		'sound/hallucinations/look_up2.ogg',
		'sound/hallucinations/over_here1.ogg',
		'sound/hallucinations/over_here2.ogg',
		'sound/hallucinations/over_here3.ogg',
		'sound/hallucinations/turn_around1.ogg',
		'sound/hallucinations/turn_around2.ogg',
		'sound/hallucinations/veryfar_noise.ogg',
		'sound/hallucinations/wail.ogg'
	)
	return imagined_sounds
