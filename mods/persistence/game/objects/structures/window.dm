/obj/structure/window/Initialize()
	if(!SSpersistence.in_loaded_world)
		return ..()

	set_anchored(anchored)
	set_dir(dir)
	if(is_fulltile())
		layer = FULL_WINDOW_LAYER
	return INITIALIZE_HINT_LATELOAD