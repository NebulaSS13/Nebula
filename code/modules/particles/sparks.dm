/particles/fire_sparks
	width = 500
	height = 500
	count = 3000
	spawning = 1
	lifespan = 40
	fade = 20
	position = generator("circle", -10, 10, NORMAL_RAND)
	gravity = list(0, 1)

	friction = 0.25
	drift = generator("sphere", 0, 2)
	gradient = list(0, "yellow", 1, "red")
	color = "yellow"

/particles/drill_sparks
	width = 124
	height = 124
	count = 1600
	spawning = 4
	lifespan = 1.5 SECONDS
	fade = 0.25 SECONDS
	position = generator("circle", -3, 3, NORMAL_RAND)
	gravity = list(0, -1)
	velocity = generator("box", list(-3, 2, 0), list(3, 12, 5), NORMAL_RAND)
	friction = 0.25
	gradient = list(0, COLOR_WHITE, 1, COLOR_ORANGE)
	color_change = 0.125
	color = 0
	transform = list(1,0,0,0, 0,1,0,0, 0,0,1,1/5, 0,0,0,1)

/particles/flare_sparks
	width = 500
	height = 500
	count = 2000
	spawning = 12
	lifespan = 0.75 SECONDS
	fade = 0.95 SECONDS
	position = generator("circle", -2, 2, NORMAL_RAND)
	velocity = generator("circle", -6, 6, NORMAL_RAND)
	friction = 0.15
	gradient = list(0, COLOR_WHITE, 0.4, COLOR_RED)
	color_change = 0.125

/particles/drill_sparks/debris
	friction = 0.25
	gradient = null
	color = COLOR_WHITE
	transform = list(1/2,0,0,0, 0,1/2,0,0, 0,0,1/2,1/5, 0,0,0,1)
	icon = 'icons/effects/particles/rock.dmi'
	icon_state = list("rock1", "rock2", "rock3", "rock4", "rock5")

/obj/particle_emitter/drill_sparks
	particles = new/particles/drill_sparks
	plane = ABOVE_LIGHTING_PLANE

/obj/particle_emitter/drill_sparks/set_dir(dir)
	..()
	var/list/min
	var/list/max
	if(dir == NORTH)
		min = list(-3, 2, -1)
		max = list(3, 12, 0)
	else if(dir == SOUTH)
		min = list(-3, 2, 0)
		max = list(3, 12, 1)
	else if(dir == EAST)
		min = list(1, 3, 0)
		max = list(6, 12, 0)
	else
		min = list(-1, 3, 0)
		max = list(-6, 12, 0)

	particles.velocity = generator("box", min, max, NORMAL_RAND)

/obj/particle_emitter/drill_sparks/debris
	plane = DEFAULT_PLANE
	particles = new/particles/drill_sparks/debris

/obj/particle_emitter/sparks_flare
	plane = ABOVE_LIGHTING_PLANE
	particles = new/particles/flare_sparks
	mouse_opacity = 1

/obj/particle_emitter/sparks_flare/Initialize(mapload, time, _color)
	. = ..()
	filters = filter(type="bloom", size=3, offset = 0.5, alpha = 220)
