/decl/modular_map_generator/debug
	name = "Debug Maze"
	grid_cell_size = 5
	level_data_type = /datum/level_data/space
	cell_templates = list(
		/datum/map_template/modular/debug/hall_vert,
		/datum/map_template/modular/debug/hall_hori,
		/datum/map_template/modular/debug/junction,
		/datum/map_template/modular/debug/room_10_10,
		/datum/map_template/modular/debug/corner_sw,
		/datum/map_template/modular/debug/corner_se,
		/datum/map_template/modular/debug/corner_nw,
		/datum/map_template/modular/debug/corner_ne,
		/datum/map_template/modular/debug/hall_end_n,
		/datum/map_template/modular/debug/hall_end_s,
		/datum/map_template/modular/debug/hall_end_e,
		/datum/map_template/modular/debug/hall_end_w,
		/datum/map_template/modular/debug/hall_nes,
		/datum/map_template/modular/debug/hall_esw,
		/datum/map_template/modular/debug/hall_swn,
		/datum/map_template/modular/debug/hall_wne
	)

/datum/map_template/modular/debug
	abstract_type = /datum/map_template/modular/debug
	connection_flag = MCF_HALL

/datum/map_template/modular/debug/corner_sw
	name = "Debug Modular Map South-to-West Hall"
	mappaths = list("maps/modular_maps/debug/debug_hall_corner_sw.dmm")

/datum/map_template/modular/debug/corner_sw/New()
	cell_connections = list(
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_ROOM | MCF_HALL)),
		new /datum/mm_connection("WEST",  0, 0, (MCF_ROOM | MCF_HALL))
	)
	..()

/datum/map_template/modular/debug/hall_nes
	name = "Debug Modular Map North-East-South Junction"
	mappaths = list("maps/modular_maps/debug/debug_hall_nes.dmm")
	connection_flag = MCF_HALL

/datum/map_template/modular/debug/hall_nes/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_ROOM | MCF_HALL)),
		new /datum/mm_connection("EAST",  0, 0, (MCF_ROOM | MCF_HALL)),
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_ROOM | MCF_HALL))
	)
	..()

/datum/map_template/modular/debug/hall_esw
	name = "Debug Modular Map East-South-West Junction"
	mappaths = list("maps/modular_maps/debug/debug_hall_esw.dmm")
	connection_flag = MCF_HALL

/datum/map_template/modular/debug/hall_esw/New()
	cell_connections = list(
		new /datum/mm_connection("EAST",  0, 0, (MCF_ROOM | MCF_HALL)),
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_ROOM | MCF_HALL)),
		new /datum/mm_connection("WEST",  0, 0, (MCF_ROOM | MCF_HALL))
	)
	..()

/datum/map_template/modular/debug/hall_swn
	name = "Debug Modular Map South-West-North Junction"
	mappaths = list("maps/modular_maps/debug/debug_hall_swn.dmm")
	connection_flag = MCF_HALL

/datum/map_template/modular/debug/hall_swn/New()
	cell_connections = list(
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_ROOM | MCF_HALL)),
		new /datum/mm_connection("WEST",  0, 0, (MCF_ROOM | MCF_HALL)),
		new /datum/mm_connection("NORTH", 0, 0, (MCF_ROOM | MCF_HALL))
	)
	..()

/datum/map_template/modular/debug/hall_wne
	name = "Debug Modular Map West-North-East Junction"
	mappaths = list("maps/modular_maps/debug/debug_hall_wne.dmm")
	connection_flag = MCF_HALL

/datum/map_template/modular/debug/hall_wne/New()
	cell_connections = list(
		new /datum/mm_connection("WEST",  0, 0, (MCF_ROOM | MCF_HALL)),
		new /datum/mm_connection("NORTH", 0, 0, (MCF_ROOM | MCF_HALL)),
		new /datum/mm_connection("EAST",  0, 0, (MCF_ROOM | MCF_HALL))
	)
	..()

/datum/map_template/modular/debug/corner_se
	name = "Debug Modular Map South-to-East Hall"
	mappaths = list("maps/modular_maps/debug/debug_hall_corner_se.dmm")
	connection_flag = MCF_HALL

/datum/map_template/modular/debug/corner_se/New()
	cell_connections = list(
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_ROOM | MCF_HALL)),
		new /datum/mm_connection("EAST",  0, 0, (MCF_ROOM | MCF_HALL))
	)
	..()

/datum/map_template/modular/debug/corner_nw
	name = "Debug Modular Map North-to-West Hall"
	mappaths = list("maps/modular_maps/debug/debug_hall_corner_nw.dmm")
	connection_flag = MCF_HALL

/datum/map_template/modular/debug/corner_nw/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_ROOM | MCF_HALL)),
		new /datum/mm_connection("WEST",  0, 0, (MCF_ROOM | MCF_HALL))
	)
	..()

/datum/map_template/modular/debug/corner_ne
	name = "Debug Modular Map North-to-East Hall"
	mappaths = list("maps/modular_maps/debug/debug_hall_corner_ne.dmm")
	connection_flag = MCF_HALL

/datum/map_template/modular/debug/corner_ne/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_ROOM | MCF_HALL)),
		new /datum/mm_connection("EAST",  0, 0, (MCF_ROOM | MCF_HALL))
	)
	..()

/datum/map_template/modular/debug/hall_vert
	name = "Debug Modular Map Vertical Hallway"
	mappaths = list("maps/modular_maps/debug/debug_hall_vert.dmm")
	connection_flag = MCF_HALL

/datum/map_template/modular/debug/hall_vert/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_ROOM | MCF_HALL)),
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_ROOM | MCF_HALL))
	)
	..()

/datum/map_template/modular/debug/hall_hori
	name = "Debug Modular Map Horizontal Hallway"
	mappaths = list("maps/modular_maps/debug/debug_hall_hori.dmm")
	connection_flag = MCF_HALL

/datum/map_template/modular/debug/hall_hori/New()
	cell_connections = list(
		new /datum/mm_connection("WEST", 0, 0, (MCF_ROOM | MCF_HALL)),
		new /datum/mm_connection("EAST", 0, 0, (MCF_ROOM | MCF_HALL))
	)
	..()

/datum/map_template/modular/debug/junction
	name = "Debug Modular Map Junction"
	mappaths = list("maps/modular_maps/debug/debug_hall_junction.dmm")
	connection_flag = MCF_ROOM

/datum/map_template/modular/debug/junction/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_HALL | MCF_ROOM)),
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_HALL | MCF_ROOM)),
		new /datum/mm_connection("EAST",  0, 0, (MCF_HALL | MCF_ROOM)),
		new /datum/mm_connection("WEST",  0, 0, (MCF_HALL | MCF_ROOM))
	)
	..()

/datum/map_template/modular/debug/room_10_10
	name = "Debug Modular Map 10x10 Room"
	mappaths = list("maps/modular_maps/debug/debug_room_10_10.dmm")
	connection_flag = MCF_ROOM
	cell_width  = 2
	cell_height = 2

/datum/map_template/modular/debug/room_10_10/New()
	cell_connections = list(
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_HALL)),
		new /datum/mm_connection("WEST",  0, 0, (MCF_HALL)),
		new /datum/mm_connection("NORTH", 0, 1, (MCF_HALL)),
		new /datum/mm_connection("WEST",  0, 1, (MCF_HALL)),
		new /datum/mm_connection("SOUTH", 1, 0, (MCF_HALL)),
		new /datum/mm_connection("EAST",  1, 0, (MCF_HALL)),
		new /datum/mm_connection("NORTH", 1, 1, (MCF_HALL)),
		new /datum/mm_connection("EAST",  1, 1, (MCF_HALL))
	)
	..()

/datum/map_template/modular/debug/hall_end_n
	name = "Debug Modular Map North Hall End"
	mappaths = list("maps/modular_maps/debug/debug_hall_end_n.dmm")

/datum/map_template/modular/debug/hall_end_n/New()
	cell_connections = list(
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_HALL | MCF_ROOM))
	)
	..()

/datum/map_template/modular/debug/hall_end_s
	name = "Debug Modular Map South Hall End"
	mappaths = list("maps/modular_maps/debug/debug_hall_end_s.dmm")

/datum/map_template/modular/debug/hall_end_s/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_HALL | MCF_ROOM))
	)
	..()

/datum/map_template/modular/debug/hall_end_e
	name = "Debug Modular Map East Hall End"
	mappaths = list("maps/modular_maps/debug/debug_hall_end_e.dmm")

/datum/map_template/modular/debug/hall_end_e/New()
	cell_connections = list(
		new /datum/mm_connection("WEST", 0, 0, (MCF_HALL | MCF_ROOM))
	)
	..()

/datum/map_template/modular/debug/hall_end_w
	name = "Debug Modular Map West Hall End"
	mappaths = list("maps/modular_maps/debug/debug_hall_end_w.dmm")

/datum/map_template/modular/debug/hall_end_w/New()
	cell_connections = list(
		new /datum/mm_connection("EAST", 0, 0, (MCF_HALL | MCF_ROOM))
	)
	..()
