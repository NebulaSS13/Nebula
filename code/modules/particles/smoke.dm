/particles/smoke
	width = 500
	height = 1000
	count = 3000
	spawning = 5
	lifespan = 40
	fade = 40
	velocity = generator("box", list(-1, 2), list(1, 2), NORMAL_RAND)
	gravity = list(0, 1)

	friction = 0.1
	drift = generator("vector", list(-0.2, -0.3), list(0.2, 0.3))
	color = "white"

/obj/particle_emitter/smoke
	layer = FIRE_LAYER
	particles = new/particles/smoke

/obj/particle_emitter/smoke/Initialize(mapload, time, _color)
	. = ..()
	filters = filter(type="blur", size=1.5)
