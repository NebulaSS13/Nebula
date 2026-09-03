#define WORLD_ICON_SIZE 32

//This file is just for the necessary /world definition
//Try looking in game/world.dm

/world
	mob = /mob/new_player
	turf = /turf/unsimulated/dark_filler
	area = /area/space
	view = "15x15"
	cache_lifespan = 7
	hub = "Exadv1.spacestation13"
	icon_size = WORLD_ICON_SIZE
	fps = 20
#ifdef FIND_REF_NO_CHECK_TICK
#pragma push
#pragma ignore loop_checks
	loop_checks = FALSE
#pragma pop
#endif
