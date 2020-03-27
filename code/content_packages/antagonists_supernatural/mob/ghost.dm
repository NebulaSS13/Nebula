/mob/observer/ghost/Initialize()
	. = ..()
	if(GLOB.cult)
		GLOB.cult.add_ghost_magic(src)
