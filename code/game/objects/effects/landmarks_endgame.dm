var/global/list/endgame_exits = list()
var/global/list/endgame_safespawns = list()

/obj/abstract/landmark/endgame
	delete_me = TRUE

/obj/abstract/landmark/endgame/safe_spawn/Initialize()
	global.endgame_safespawns |= get_turf(src)
	. = ..()

/obj/abstract/landmark/endgame/exit/Initialize()
	global.endgame_exits |= get_turf(src)
	. = ..()
