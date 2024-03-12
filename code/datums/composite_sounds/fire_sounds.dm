// Fire crackles were originally sourced from freesound.org and cut
// up/faded in Audacity but I have lost the original source link. :(
/datum/composite_sound/fire_crackles
	start_sound = 'sound/ambience/firecrackle01.ogg'
	start_length = 10
	mid_sounds = list(
		'sound/ambience/firecrackle02.ogg',
		'sound/ambience/firecrackle03.ogg',
		'sound/ambience/firecrackle04.ogg',
		'sound/ambience/firecrackle05.ogg'
	)
	mid_length = 10
	end_sound = 'sound/ambience/firecrackle06.ogg'
	volume = 10

/datum/composite_sound/grill
	start_sound = 'sound/machines/kitchen/grill/grill-start.ogg'
	start_length = 10
	mid_sounds = list('sound/machines/kitchen/grill/grill-mid1.ogg'=10)
	mid_length = 40
	end_sound = 'sound/machines/kitchen/grill/grill-stop.ogg'
	volume = 50
