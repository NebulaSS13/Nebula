//////////////////////////////////////////////////////////////////////
// Geyser Steam Particle Emitter
//////////////////////////////////////////////////////////////////////

///Particle emitter that emits a ~64 pixels by ~192 pixels high column of steam while active.
/particles/geyser_steam
	icon_state = "smallsmoke"
	icon       = 'icons/effects/effects.dmi'
	width      = WORLD_ICON_SIZE * 2 //Particles expand a bit as they climb, so need a bit of space on the width
	height     = WORLD_ICON_SIZE * 6 //Needs to be really tall, because particles stop being drawn outside of the canvas.
	count      = 64
	spawning   = 5
	lifespan   = generator("num", 1 SECOND, 2.5 SECONDS, LINEAR_RAND)
	fade       = 3 SECONDS
	fadein     = 0.25 SECONDS
	grow       = 0.1
	velocity   = generator("vector", list(0, 0), list(0, 0.2))
	position   = generator("circle", -6, 6, NORMAL_RAND)
	gravity    = list(0, 0.40)
	scale      = generator("vector", list(0.3, 0.3), list(1,1), NORMAL_RAND)
	rotation   = generator("num", -45, 45)
	spin       = generator("num", -20, 20)