/particles/debris
	width = 124
	height = 124
	count = 16
	spawning = 999999 //spawn all instantly
	lifespan = 0.75 SECONDS
	fade = 0.35 SECONDS
	position = generator("box", list(-10, -10), list(10, 10), NORMAL_RAND)
	velocity = generator("circle", -15, 15, NORMAL_RAND)
	friction = 0.225
	gravity = list(0, -1)
	icon = 'icons/effects/particles/rock.dmi'
	icon_state = list("rock1", "rock2", "rock3", "rock4", "rock5")
	rotation = generator("num", 0, 360, NORMAL_RAND)

/atom/movable/particle_holder/burst/Initialize(mapload, time)
	. = ..()
	//Burst emitters turn off after 1 tick
	addtimer(CALLBACK(src, .proc/toggle, FALSE), 1, TIMER_CLIENT_TIME)

/atom/movable/particle_holder/burst/rocks
	particles = new/particles/debris
