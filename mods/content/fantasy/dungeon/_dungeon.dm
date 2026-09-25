/decl/modular_map_generator/dungeon
	name = "Dungeon"
	grid_cell_size = 4
	cell_templates = list(
		/datum/map_template/modular/dungeon/barracks,
		/datum/map_template/modular/dungeon/butchery,
		/datum/map_template/modular/dungeon/hall,
		/datum/map_template/modular/dungeon/foundry,
		/datum/map_template/modular/dungeon/kitchen,
		/datum/map_template/modular/dungeon/library,
		/datum/map_template/modular/dungeon/pool_small,
		/datum/map_template/modular/dungeon/pool,
		/datum/map_template/modular/dungeon/smithy,
		/datum/map_template/modular/dungeon/surgery,
		/datum/map_template/modular/dungeon/workshop,
		/datum/map_template/modular/dungeon/spider_nest,
		/datum/map_template/modular/dungeon/hallway/vertical_aqueduct,
		/datum/map_template/modular/dungeon/hallway/horizontal_aqueduct,
		/datum/map_template/modular/dungeon/hallway/vertical_hallway,
		/datum/map_template/modular/dungeon/hallway/horizontal_hallway,
		/datum/map_template/modular/dungeon/hallway/end/north,
		/datum/map_template/modular/dungeon/hallway/end/south,
		/datum/map_template/modular/dungeon/hallway/end/east,
		/datum/map_template/modular/dungeon/hallway/end/west
	)

/decl/modular_map_generator/dungeon/get_initial_template()
	return (locate(/datum/map_template/modular/dungeon/hall) in cell_templates) || ..()

/datum/map_template/modular/dungeon
	abstract_type = /datum/map_template/modular/dungeon
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS
	connection_flag = MCF_ROOM

/datum/map_template/modular/dungeon/barracks
	name     = "dungeon barracks"
	mappaths = list("maps/shaded_hills/dungeon_gen/submaps/dungeon/dungeon_barracks.dmm")
	cell_width = 5
	cell_height = 4

/datum/map_template/modular/dungeon/barracks/New()
	cell_connections = list(
		new /datum/mm_connection("WEST", 0, 3, (MCF_HALL)),
		new /datum/mm_connection("EAST", 4, 3, (MCF_HALL))
	)
	..()

/datum/map_template/modular/dungeon/butchery
	name     = "dungeon butchery"
	mappaths = list("maps/shaded_hills/dungeon_gen/submaps/dungeon/dungeon_butchery.dmm")
	cell_width = 2
	cell_height = 2

/datum/map_template/modular/dungeon/butchery/New()
	cell_connections = list(
		new /datum/mm_connection("EAST", 1, 0, (MCF_HALL))
	)
	..()

/datum/map_template/modular/dungeon/hall
	name     = "dungeon feasting hall"
	mappaths = list("maps/shaded_hills/dungeon_gen/submaps/dungeon/dungeon_feasting_hall.dmm")
	cell_width = 3
	cell_height = 5

/datum/map_template/modular/dungeon/hall/New()
	cell_connections = list(
		new /datum/mm_connection("SOUTH", 1, 0, (MCF_HALL)),
		new /datum/mm_connection("WEST", 0, 3, (MCF_HALL)),
		new /datum/mm_connection("WEST", 0, 1, (MCF_HALL)),
		new /datum/mm_connection("EAST", 2, 1, (MCF_HALL)),
		new /datum/mm_connection("EAST", 2, 3, (MCF_HALL)),
		new /datum/mm_connection("NORTH", 1, 4, (MCF_HALL))
	)
	..()

/datum/map_template/modular/dungeon/foundry
	name     = "dungeon foundry"
	mappaths = list("maps/shaded_hills/dungeon_gen/submaps/dungeon/dungeon_foundry.dmm")
	cell_width = 3
	cell_height = 3

/datum/map_template/modular/dungeon/foundry/New()
	cell_connections = list(
		new /datum/mm_connection("SOUTH", 1, 0, (MCF_HALL))
	)
	..()

/datum/map_template/modular/dungeon/kitchen
	name     = "dungeon kitchen"
	mappaths = list("maps/shaded_hills/dungeon_gen/submaps/dungeon/dungeon_kitchen.dmm")
	cell_width = 3
	cell_height = 2

/datum/map_template/modular/dungeon/kitchen/New()
	cell_connections = list(
		new /datum/mm_connection("EAST", 2, 1, (MCF_HALL))
	)
	..()

/datum/map_template/modular/dungeon/library
	name     = "dungeon library"
	mappaths = list("maps/shaded_hills/dungeon_gen/submaps/dungeon/dungeon_library.dmm")
	cell_width = 3
	cell_height = 5

/datum/map_template/modular/dungeon/library/New()
	cell_connections = list(
		new /datum/mm_connection("WEST", 0, 0, (MCF_HALL)),
		new /datum/mm_connection("SOUTH", 1, 0, (MCF_HALL)),
		new /datum/mm_connection("NORTH", 1, 4, (MCF_HALL))
	)
	..()

/datum/map_template/modular/dungeon/pool_small
	name     = "dungeon small pool"
	mappaths = list("maps/shaded_hills/dungeon_gen/submaps/dungeon/dungeon_pool_small.dmm")
	cell_width = 2
	cell_height = 2

/datum/map_template/modular/dungeon/pool_small/New()
	cell_connections = list(
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_HALL)),
		new /datum/mm_connection("NORTH", 1, 1, (MCF_HALL))
	)
	..()

/datum/map_template/modular/dungeon/pool
	name     = "dungeon pool"
	mappaths = list("maps/shaded_hills/dungeon_gen/submaps/dungeon/dungeon_pool.dmm")
	cell_width = 3
	cell_height = 3

/datum/map_template/modular/dungeon/pool/New()
	cell_connections = list(
		new /datum/mm_connection("WEST", 0, 1, (MCF_HALL)),
		new /datum/mm_connection("SOUTH", 1, 0, (MCF_HALL)),
		new /datum/mm_connection("NORTH", 1, 2, (MCF_HALL)),
		new /datum/mm_connection("EAST", 2, 1, (MCF_HALL))
	)
	..()

/datum/map_template/modular/dungeon/smithy
	name     = "dungeon smithy"
	mappaths = list("maps/shaded_hills/dungeon_gen/submaps/dungeon/dungeon_smithy.dmm")
	cell_width = 2
	cell_height = 2

/datum/map_template/modular/dungeon/smithy/New()
	cell_connections = list(
		new /datum/mm_connection("WEST", 0, 1, (MCF_HALL)),
		new /datum/mm_connection("EAST", 1, 0, (MCF_HALL))
	)
	..()

/datum/map_template/modular/dungeon/surgery
	name     = "dungeon surgery"
	mappaths = list("maps/shaded_hills/dungeon_gen/submaps/dungeon/dungeon_surgery.dmm")
	cell_width = 3
	cell_height = 2

/datum/map_template/modular/dungeon/surgery/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 1, 1, (MCF_HALL))
	)
	..()

/datum/map_template/modular/dungeon/workshop
	name     = "dungeon workshop"
	mappaths = list("maps/shaded_hills/dungeon_gen/submaps/dungeon/dungeon_workshop.dmm")
	cell_width = 2
	cell_height = 3

/datum/map_template/modular/dungeon/workshop/New()
	cell_connections = list(
		new /datum/mm_connection("WEST", 0, 1, (MCF_HALL)),
		new /datum/mm_connection("EAST", 2, 1, (MCF_HALL))
	)
	..()

/datum/map_template/modular/dungeon/spider_nest
	name     = "dungeon spider nest"
	mappaths = list("maps/shaded_hills/dungeon_gen/submaps/dungeon/dungeon_spider_nest.dmm")
	cell_width = 3
	cell_height = 3

/datum/map_template/modular/dungeon/spider_nest/New()
	cell_connections = list(
		new /datum/mm_connection("WEST", 0, 1, (MCF_HALL))
	)
	..()

/datum/map_template/modular/dungeon/hallway
	abstract_type  = /datum/map_template/modular/dungeon/hallway
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS | TEMPLATE_FLAG_ALLOW_DUPLICATES | TEMPLATE_FLAG_GENERIC_REPEATABLE
	connection_flag = MCF_HALL

/datum/map_template/modular/dungeon/hallway/vertical_aqueduct
	name     = "dungeon vertical aqueduct"
	mappaths = list("maps/shaded_hills/dungeon_gen/submaps/dungeon/dungeon_vertical_aqueduct.dmm")
	cell_width = 1
	cell_height = 2

/datum/map_template/modular/dungeon/hallway/vertical_aqueduct/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 1, (MCF_ROOM | MCF_HALL)),
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_ROOM | MCF_HALL))
	)
	..()

/datum/map_template/modular/dungeon/hallway/horizontal_aqueduct
	name     = "dungeon horizontal aqueduct"
	mappaths = list("maps/shaded_hills/dungeon_gen/submaps/dungeon/dungeon_horizontal_aqueduct.dmm")
	cell_width = 2
	cell_height = 1

/datum/map_template/modular/dungeon/hallway/horizontal_aqueduct/New()
	cell_connections = list(
		new /datum/mm_connection("EAST", 1, 0, (MCF_ROOM | MCF_HALL)),
		new /datum/mm_connection("WEST", 0, 0, (MCF_ROOM | MCF_HALL))
	)
	..()

/datum/map_template/modular/dungeon/hallway/vertical_hallway
	name     = "dungeon vertical hallway"
	mappaths = list("maps/shaded_hills/dungeon_gen/submaps/dungeon/dungeon_vertical_hallway.dmm")
	cell_width = 1
	cell_height = 2

/datum/map_template/modular/dungeon/hallway/vertical_hallway/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 1, (MCF_ROOM | MCF_HALL)),
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_ROOM | MCF_HALL))
	)
	..()

/datum/map_template/modular/dungeon/hallway/horizontal_hallway
	name     = "dungeon horizontal hallway"
	mappaths = list("maps/shaded_hills/dungeon_gen/submaps/dungeon/dungeon_horizontal_hallway.dmm")
	cell_width = 2
	cell_height = 1

/datum/map_template/modular/dungeon/hallway/horizontal_hallway/New()
	cell_connections = list(
		new /datum/mm_connection("EAST", 1, 0, (MCF_ROOM | MCF_HALL)),
		new /datum/mm_connection("WEST", 0, 0, (MCF_ROOM | MCF_HALL))
	)
	..()

/datum/map_template/modular/dungeon/hallway/end
	abstract_type = /datum/map_template/modular/dungeon/hallway/end
	cell_width = 1
	cell_height = 1

/datum/map_template/modular/dungeon/hallway/end/north
	name     = "dungeon north hallway end"
	mappaths = list("maps/shaded_hills/dungeon_gen/submaps/dungeon/dungeon_term_n.dmm")

/datum/map_template/modular/dungeon/hallway/end/north/New()
	cell_connections = list(
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_HALL | MCF_ROOM))
	)
	..()

/datum/map_template/modular/dungeon/hallway/end/south
	name     = "dungeon south hallway end"
	mappaths = list("maps/shaded_hills/dungeon_gen/submaps/dungeon/dungeon_term_s.dmm")

/datum/map_template/modular/dungeon/hallway/end/south/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_HALL | MCF_ROOM))
	)
	..()

/datum/map_template/modular/dungeon/hallway/end/east
	name     = "dungeon east hallway end"
	mappaths = list("maps/shaded_hills/dungeon_gen/submaps/dungeon/dungeon_term_e.dmm")

/datum/map_template/modular/dungeon/hallway/end/east/New()
	cell_connections = list(
		new /datum/mm_connection("WEST", 0, 0, (MCF_HALL | MCF_ROOM))
	)
	..()

/datum/map_template/modular/dungeon/hallway/end/west
	name     = "dungeon west hallway end"
	mappaths = list("maps/shaded_hills/dungeon_gen/submaps/dungeon/dungeon_term_w.dmm")

/datum/map_template/modular/dungeon/hallway/end/west/New()
	cell_connections = list(
		new /datum/mm_connection("EAST", 0, 0, (MCF_HALL | MCF_ROOM))
	)
	..()
