// Loom sampled from 'navette de métier à tisser.wav' by Naïma on freesound.org: https://freesound.org/people/Na%C3%AFma/sounds/510266/
/datum/composite_sound/loom_working
	start_sound  = 'sound/items/loomstart.ogg'
	start_length = 20
	mid_length   = 12
	mid_sounds   = list(
		'sound/items/loom1.ogg',
		'sound/items/loom2.ogg',
		'sound/items/loom3.ogg'
	)
	end_sound    = 'sound/items/loomstop.ogg'
	volume       = 40

// Spinning wheel sampled from 'Wooden Spinning Wheel' by Kessir on freesound.org: https://freesound.org/people/kessir/sounds/414554/
/datum/composite_sound/spinning_wheel_working
	start_sound  = 'sound/items/spinningwheelstart.ogg'
	start_length = 33
	mid_length   = 20
	mid_sounds   = list(
		'sound/items/spinningwheel1.ogg',
		'sound/items/spinningwheel2.ogg',
		'sound/items/spinningwheel3.ogg'
	)
	end_sound    = 'sound/items/spinningwheelstop.ogg'
	volume       = 60