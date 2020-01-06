#if !defined(using_map_DATUM)
	#include "tradeship_unit_testing.dm"

	#include "../../code/datums/music_tracks/businessend.dm"
	#include "../../code/datums/music_tracks/salutjohn.dm"

	#include "tradeship_areas.dm"
	#include "tradeship_jobs.dm"
	#include "tradeship_lobby.dm"
	#include "tradeship_shuttles.dm"
	#include "tradeship_overmap.dm"
	#include "tradeship_overrides.dm"
	#include "tradeship_loadouts.dm"
	#include "tradeship-1.dmm"
	#include "tradeship-2.dmm"

	#define using_map_DATUM /datum/map/tradeship

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Tradeship

#endif

/turf/simulated/floor
	name = "bare deck"

/turf/simulated/floor/tiled
	name = "deck"

/decl/flooring/tiling
	name = "deck"

/turf/simulated/wall/r_wall/hull
	color = COLOR_DARK_BROWN

/obj/machinery/door/airlock/hatch/autoname

/obj/machinery/door/airlock/hatch/autoname/Initialize()
	. = ..()
	var/area/A = get_area(src)
	SetName("hatch ([A.name])")

/obj/machinery/door/airlock/hatch/autoname/general
	stripe_color = COLOR_CIVIE_GREEN

/obj/machinery/door/airlock/hatch/autoname/maintenance
	stripe_color = COLOR_AMBER

/obj/machinery/door/airlock/hatch/autoname/command
	stripe_color = COLOR_COMMAND_BLUE

/obj/machinery/door/airlock/hatch/autoname/engineering
	stripe_color = COLOR_AMBER


//wild capitalism
/datum/computer_file/program/merchant
	required_access = null