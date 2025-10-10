/decl/modular_map_generator/aqueduct
	name = "Aqueducts"
	grid_cell_size = 9
	cell_templates = list(
		/datum/map_template/modular/aqueduct/chamber/large,
		/datum/map_template/modular/aqueduct/chamber/small_n,
		/datum/map_template/modular/aqueduct/chamber/small_s,
		/datum/map_template/modular/aqueduct/chamber/small_e,
		/datum/map_template/modular/aqueduct/chamber/small_w,
		/datum/map_template/modular/aqueduct/chamber/vertical,
		/datum/map_template/modular/aqueduct/chamber/horizontal,
		/datum/map_template/modular/aqueduct/junction,
		/datum/map_template/modular/aqueduct/ne,
		/datum/map_template/modular/aqueduct/nw,
		/datum/map_template/modular/aqueduct/se,
		/datum/map_template/modular/aqueduct/sw,
		/datum/map_template/modular/aqueduct/vertical,
		/datum/map_template/modular/aqueduct/horizontal,
		/datum/map_template/modular/aqueduct/esw,
		/datum/map_template/modular/aqueduct/swn,
		/datum/map_template/modular/aqueduct/wne,
		/datum/map_template/modular/aqueduct/nes,
		/datum/map_template/modular/aqueduct/end/n,
		/datum/map_template/modular/aqueduct/end/s,
		/datum/map_template/modular/aqueduct/end/w,
		/datum/map_template/modular/aqueduct/end/e,
		/datum/map_template/modular/aqueduct/water/junction,
		/datum/map_template/modular/aqueduct/water/ne,
		/datum/map_template/modular/aqueduct/water/nw,
		/datum/map_template/modular/aqueduct/water/se,
		/datum/map_template/modular/aqueduct/water/sw,
		/datum/map_template/modular/aqueduct/water/horizontal,
		/datum/map_template/modular/aqueduct/water/vertical,
		/datum/map_template/modular/aqueduct/water/esw,
		/datum/map_template/modular/aqueduct/water/swn,
		/datum/map_template/modular/aqueduct/water/wne,
		/datum/map_template/modular/aqueduct/water/nes,
		/datum/map_template/modular/aqueduct/water/end/n,
		/datum/map_template/modular/aqueduct/water/end/s,
		/datum/map_template/modular/aqueduct/water/end/e,
		/datum/map_template/modular/aqueduct/water/end/w,
		/datum/map_template/modular/aqueduct/bridge/vertical,
		/datum/map_template/modular/aqueduct/bridge/vertical_w,
		/datum/map_template/modular/aqueduct/bridge/vertical_e,
		/datum/map_template/modular/aqueduct/bridge/horizontal,
		/datum/map_template/modular/aqueduct/bridge/horizontal_n,
		/datum/map_template/modular/aqueduct/bridge/horizontal_s
	)
	post_run_generators = list(
		/datum/random_map/noise/aqueducts
	)

/datum/random_map/noise/aqueducts
	descriptor = "aqueducts (modular map)"
	smoothing_iterations = 3
	target_turf_type = /turf/unsimulated/mask

/datum/random_map/noise/aqueducts/get_appropriate_path(var/value)
	var/val = min(9,max(0,round((value/cell_range)*10)))
	switch(val)
		if(6)
			return /turf/wall/natural/clay
		if(7 to 9)
			return /turf/wall/natural/dirt
	return /turf/wall/natural/basalt

/datum/map_template/modular/aqueduct
	abstract_type = /datum/map_template/modular/aqueduct
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS
	connection_flag = MCF_HALL
	cell_width = 1
	cell_height = 1

/datum/map_template/modular/aqueduct/junction
	name = "Aqueduct - Passage Junction"
	mappaths = list("maps/modular_maps/aqueduct/passage_junction.dmm")
	connection_flag = MCF_HALL_BEND

/datum/map_template/modular/aqueduct/junction/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_HALL | MCF_BRIDGE | MCF_ROOM)),
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_HALL | MCF_BRIDGE | MCF_ROOM)),
		new /datum/mm_connection("EAST", 0, 0, (MCF_HALL | MCF_BRIDGE | MCF_ROOM)),
		new /datum/mm_connection("WEST", 0, 0, (MCF_HALL | MCF_BRIDGE | MCF_ROOM)),
	)
	..()

/datum/map_template/modular/aqueduct/ne
	name = "Aqueduct - Passage NE"
	mappaths = list("maps/modular_maps/aqueduct/passage_ne.dmm")
	connection_flag = MCF_HALL_BEND

/datum/map_template/modular/aqueduct/ne/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_HALL | MCF_BRIDGE | MCF_ROOM)),
		new /datum/mm_connection("EAST", 0, 0, (MCF_HALL | MCF_BRIDGE | MCF_ROOM)),
	)
	..()

/datum/map_template/modular/aqueduct/nw
	name = "Aqueduct - Passage NW"
	mappaths = list("maps/modular_maps/aqueduct/passage_nw.dmm")
	connection_flag = MCF_HALL_BEND

/datum/map_template/modular/aqueduct/nw/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_HALL | MCF_BRIDGE | MCF_ROOM)),
		new /datum/mm_connection("WEST", 0, 0, (MCF_HALL | MCF_BRIDGE | MCF_ROOM)),
	)
	..()

/datum/map_template/modular/aqueduct/se
	name = "Aqueduct - Passage SE"
	mappaths = list("maps/modular_maps/aqueduct/passage_se.dmm")
	connection_flag = MCF_HALL_BEND

/datum/map_template/modular/aqueduct/se/New()
	cell_connections = list(
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_HALL | MCF_BRIDGE | MCF_ROOM)),
		new /datum/mm_connection("EAST", 0, 0, (MCF_HALL | MCF_BRIDGE | MCF_ROOM)),
	)
	..()

/datum/map_template/modular/aqueduct/sw
	name = "Aqueduct - Passage SW"
	mappaths = list("maps/modular_maps/aqueduct/passage_sw.dmm")
	connection_flag = MCF_HALL_BEND

/datum/map_template/modular/aqueduct/sw/New()
	cell_connections = list(
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_HALL | MCF_BRIDGE | MCF_ROOM)),
		new /datum/mm_connection("WEST", 0, 0, (MCF_HALL | MCF_BRIDGE | MCF_ROOM)),
	)
	..()

/datum/map_template/modular/aqueduct/vertical
	name = "Aqueduct - Passage Vertical"
	mappaths = list("maps/modular_maps/aqueduct/passage_vertical.dmm")

/datum/map_template/modular/aqueduct/vertical/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_ROOM | MCF_BRIDGE)),
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_ROOM | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/horizontal
	name = "Aqueduct - Passage Horizontal"
	mappaths = list("maps/modular_maps/aqueduct/passage_horizontal.dmm")

/datum/map_template/modular/aqueduct/horizontal/New()
	cell_connections = list(
		new /datum/mm_connection("EAST", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_ROOM | MCF_BRIDGE)),
		new /datum/mm_connection("WEST", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_ROOM | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/esw
	name = "Aqueduct - Passage ESW"
	mappaths = list("maps/modular_maps/aqueduct/passage_esw.dmm")
	connection_flag = MCF_HALL_BEND

/datum/map_template/modular/aqueduct/esw/New()
	cell_connections = list(
		new /datum/mm_connection("EAST", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE | MCF_ROOM)),
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE | MCF_ROOM)),
		new /datum/mm_connection("WEST", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE | MCF_ROOM)),
	)
	..()

/datum/map_template/modular/aqueduct/swn
	name = "Aqueduct - Passage SWN"
	mappaths = list("maps/modular_maps/aqueduct/passage_swn.dmm")
	connection_flag = MCF_HALL_BEND

/datum/map_template/modular/aqueduct/swn/New()
	cell_connections = list(
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE | MCF_ROOM)),
		new /datum/mm_connection("WEST", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE | MCF_ROOM)),
		new /datum/mm_connection("NORTH", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE | MCF_ROOM)),
	)
	..()

/datum/map_template/modular/aqueduct/wne
	name = "Aqueduct - Passage WNE"
	mappaths = list("maps/modular_maps/aqueduct/passage_wne.dmm")
	connection_flag = MCF_HALL_BEND

/datum/map_template/modular/aqueduct/wne/New()
	cell_connections = list(
		new /datum/mm_connection("WEST", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE | MCF_ROOM)),
		new /datum/mm_connection("NORTH", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE | MCF_ROOM)),
		new /datum/mm_connection("EAST", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE | MCF_ROOM)),
	)
	..()

/datum/map_template/modular/aqueduct/nes
	name = "Aqueduct - Passage NES"
	mappaths = list("maps/modular_maps/aqueduct/passage_nes.dmm")
	connection_flag = MCF_HALL_BEND

/datum/map_template/modular/aqueduct/nes/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE | MCF_ROOM)),
		new /datum/mm_connection("EAST", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE | MCF_ROOM)),
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE | MCF_ROOM)),
	)
	..()

/datum/map_template/modular/aqueduct/end
	abstract_type = /datum/map_template/modular/aqueduct/end

/datum/map_template/modular/aqueduct/end/n
	name = "Aqueduct - Passage End N"
	mappaths = list("maps/modular_maps/aqueduct/passage_end_n.dmm")
	cell_connections = list(
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE | MCF_ROOM)),
	)

/datum/map_template/modular/aqueduct/end/n/New()
	..()

/datum/map_template/modular/aqueduct/end/s
	name = "Aqueduct - Passage End S"
	mappaths = list("maps/modular_maps/aqueduct/passage_end_s.dmm")

/datum/map_template/modular/aqueduct/end/s/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE | MCF_ROOM)),
	)
	..()

/datum/map_template/modular/aqueduct/end/w
	name = "Aqueduct - Passage End W"
	mappaths = list("maps/modular_maps/aqueduct/passage_end_w.dmm")

/datum/map_template/modular/aqueduct/end/w/New()
	cell_connections = list(
		new /datum/mm_connection("EAST", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE | MCF_ROOM)),
	)
	..()

/datum/map_template/modular/aqueduct/end/e
	name = "Aqueduct - Passage End E"
	mappaths = list("maps/modular_maps/aqueduct/passage_end_e.dmm")

/datum/map_template/modular/aqueduct/end/e/New()
	cell_connections = list(
		new /datum/mm_connection("WEST", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE | MCF_ROOM)),
	)
	..()

/datum/map_template/modular/aqueduct/chamber
	abstract_type = /datum/map_template/modular/aqueduct/chamber
	connection_flag = MCF_ROOM

/datum/map_template/modular/aqueduct/chamber/large
	name = "Aqueduct - Large Chamber"
	mappaths = list("maps/modular_maps/aqueduct/chamber_large.dmm")
	cell_width = 3
	cell_height = 3

/datum/map_template/modular/aqueduct/chamber/large/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 1, 2, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE)),
		new /datum/mm_connection("SOUTH", 1, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE)),
		new /datum/mm_connection("EAST", 2, 1, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE)),
		new /datum/mm_connection("WEST", 0, 1, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/chamber/horizontal
	name = "Aqueduct - Horizontal Chamber"
	mappaths = list("maps/modular_maps/aqueduct/chamber_horizontal.dmm")
	cell_width = 2

/datum/map_template/modular/aqueduct/chamber/horizontal/New()
	cell_connections = list(
		new /datum/mm_connection("EAST", 1, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE)),
		new /datum/mm_connection("WEST", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/chamber/vertical
	name = "Aqueduct - Vertical Chamber"
	mappaths = list("maps/modular_maps/aqueduct/chamber_vertical.dmm")
	cell_height = 2

/datum/map_template/modular/aqueduct/chamber/vertical/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 1, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE)),
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/chamber/small_n
	name = "Aqueduct - Small Chamber N"
	mappaths = list("maps/modular_maps/aqueduct/chamber_small_n.dmm")

/datum/map_template/modular/aqueduct/chamber/small_n/New()
	cell_connections = list(
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/chamber/small_s
	name = "Aqueduct - Small Chamber S"
	mappaths = list("maps/modular_maps/aqueduct/chamber_small_s.dmm")

/datum/map_template/modular/aqueduct/chamber/small_s/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/chamber/small_e
	name = "Aqueduct - Small Chamber E"
	mappaths = list("maps/modular_maps/aqueduct/chamber_small_e.dmm")

/datum/map_template/modular/aqueduct/chamber/small_e/New()
	cell_connections = list(
		new /datum/mm_connection("WEST", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/chamber/small_w
	name = "Aqueduct - Small Chamber W"
	mappaths = list("maps/modular_maps/aqueduct/chamber_small_w.dmm")

/datum/map_template/modular/aqueduct/chamber/small_w/New()
	cell_connections = list(
		new /datum/mm_connection("EAST", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/bridge
	abstract_type = /datum/map_template/modular/aqueduct/bridge
	connection_flag = MCF_BRIDGE

/datum/map_template/modular/aqueduct/bridge/vertical
	name = "Aqueduct - Bridge Vertical"
	mappaths = list("maps/modular_maps/aqueduct/bridge_vertical_full.dmm")

/datum/map_template/modular/aqueduct/bridge/vertical/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_ROOM | MCF_BRIDGE)),
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_ROOM | MCF_BRIDGE)),
		new /datum/mm_connection("EAST", 0, 0, (MCF_AQUEDUCT)),
		new /datum/mm_connection("WEST", 0, 0, (MCF_AQUEDUCT)),
	)
	..()

/datum/map_template/modular/aqueduct/bridge/vertical_e
	name = "Aqueduct - Bridge Vertical E"
	mappaths = list("maps/modular_maps/aqueduct/bridge_vertical_e.dmm")

/datum/map_template/modular/aqueduct/bridge/vertical_e/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_ROOM | MCF_BRIDGE)),
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_ROOM | MCF_BRIDGE)),
		new /datum/mm_connection("EAST", 0, 0, (MCF_AQUEDUCT)),
	)
	..()

/datum/map_template/modular/aqueduct/bridge/vertical_w
	name = "Aqueduct - Bridge Vertical W"
	mappaths = list("maps/modular_maps/aqueduct/bridge_vertical_w.dmm")

/datum/map_template/modular/aqueduct/bridge/vertical_w/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_ROOM | MCF_BRIDGE)),
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_ROOM | MCF_BRIDGE)),
		new /datum/mm_connection("WEST", 0, 0, (MCF_AQUEDUCT)),
	)
	..()

/datum/map_template/modular/aqueduct/bridge/horizontal
	name = "Aqueduct - Bridge Horizontal"
	mappaths = list("maps/modular_maps/aqueduct/bridge_horizontal_full.dmm")

/datum/map_template/modular/aqueduct/bridge/horizontal/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_AQUEDUCT)),
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_AQUEDUCT)),
		new /datum/mm_connection("EAST", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_ROOM | MCF_BRIDGE)),
		new /datum/mm_connection("WEST", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_ROOM | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/bridge/horizontal_n
	name = "Aqueduct - Bridge Horizontal N"
	mappaths = list("maps/modular_maps/aqueduct/bridge_horizontal_n.dmm")

/datum/map_template/modular/aqueduct/bridge/horizontal_n/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_AQUEDUCT)),
		new /datum/mm_connection("EAST", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_ROOM | MCF_BRIDGE)),
		new /datum/mm_connection("WEST", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_ROOM | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/bridge/horizontal_s
	name = "Aqueduct - Bridge Horizontal S"
	mappaths = list("maps/modular_maps/aqueduct/bridge_horizontal_s.dmm")

/datum/map_template/modular/aqueduct/bridge/horizontal_s/New()
	cell_connections = list(
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_AQUEDUCT)),
		new /datum/mm_connection("EAST", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_ROOM | MCF_BRIDGE)),
		new /datum/mm_connection("WEST", 0, 0, (MCF_HALL | MCF_HALL_BEND | MCF_ROOM | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/water
	abstract_type = /datum/map_template/modular/aqueduct/water
	connection_flag = MCF_AQUEDUCT

/datum/map_template/modular/aqueduct/water/junction
	name = "Aqueduct - Water Junction"
	mappaths = list("maps/modular_maps/aqueduct/aqueduct_junction.dmm")

/datum/map_template/modular/aqueduct/water/junction/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
		new /datum/mm_connection("EAST", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
		new /datum/mm_connection("WEST", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/water/ne
	name = "Aqueduct - Water NE"
	mappaths = list("maps/modular_maps/aqueduct/aqueduct_ne.dmm")

/datum/map_template/modular/aqueduct/water/ne/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
		new /datum/mm_connection("EAST", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/water/nw
	name = "Aqueduct - Water NW"
	mappaths = list("maps/modular_maps/aqueduct/aqueduct_nw.dmm")

/datum/map_template/modular/aqueduct/water/nw/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
		new /datum/mm_connection("WEST", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/water/se
	name = "Aqueduct - Water SE"
	mappaths = list("maps/modular_maps/aqueduct/aqueduct_se.dmm")

/datum/map_template/modular/aqueduct/water/se/New()
	cell_connections = list(
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
		new /datum/mm_connection("EAST", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/water/sw
	name = "Aqueduct - Water SW"
	mappaths = list("maps/modular_maps/aqueduct/aqueduct_sw.dmm")

/datum/map_template/modular/aqueduct/water/sw/New()
	cell_connections = list(
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
		new /datum/mm_connection("WEST", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/water/horizontal
	name = "Aqueduct - Water Horizontal"
	mappaths = list("maps/modular_maps/aqueduct/aqueduct_horizontal.dmm")

/datum/map_template/modular/aqueduct/water/horizontal/New()
	cell_connections = list(
		new /datum/mm_connection("EAST", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
		new /datum/mm_connection("WEST", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/water/vertical
	name = "Aqueduct - Water Vertical"
	mappaths = list("maps/modular_maps/aqueduct/aqueduct_vertical.dmm")

/datum/map_template/modular/aqueduct/water/vertical/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/water/esw
	name = "Aqueduct - Water ESW"
	mappaths = list("maps/modular_maps/aqueduct/aqueduct_esw.dmm")

/datum/map_template/modular/aqueduct/water/esw/New()
	cell_connections = list(
		new /datum/mm_connection("EAST", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
		new /datum/mm_connection("WEST", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/water/swn
	name = "Aqueduct - Water SWN"
	mappaths = list("maps/modular_maps/aqueduct/aqueduct_swn.dmm")

/datum/map_template/modular/aqueduct/water/swn/New()
	cell_connections = list(
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
		new /datum/mm_connection("WEST", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
		new /datum/mm_connection("NORTH", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/water/wne
	name = "Aqueduct - Water WNE"
	mappaths = list("maps/modular_maps/aqueduct/aqueduct_wne.dmm")

/datum/map_template/modular/aqueduct/water/wne/New()
	cell_connections = list(
		new /datum/mm_connection("WEST", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
		new /datum/mm_connection("NORTH", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
		new /datum/mm_connection("EAST", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/water/nes
	name = "Aqueduct - Water NES"
	mappaths = list("maps/modular_maps/aqueduct/aqueduct_nes.dmm")

/datum/map_template/modular/aqueduct/water/nes/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
		new /datum/mm_connection("EAST", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/water/end
	abstract_type = /datum/map_template/modular/aqueduct/water/end

/datum/map_template/modular/aqueduct/water/end/n
	name = "Aqueduct - Water End N"
	mappaths = list("maps/modular_maps/aqueduct/aqueduct_end_n.dmm")

/datum/map_template/modular/aqueduct/water/end/n/New()
	cell_connections = list(
		new /datum/mm_connection("SOUTH", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/water/end/s
	name = "Aqueduct - Water End S"
	mappaths = list("maps/modular_maps/aqueduct/aqueduct_end_s.dmm")

/datum/map_template/modular/aqueduct/water/end/s/New()
	cell_connections = list(
		new /datum/mm_connection("NORTH", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/water/end/e
	name = "Aqueduct - Water End E"
	mappaths = list("maps/modular_maps/aqueduct/aqueduct_end_e.dmm")

/datum/map_template/modular/aqueduct/water/end/e/New()
	cell_connections = list(
		new /datum/mm_connection("WEST", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
	)
	..()

/datum/map_template/modular/aqueduct/water/end/w
	name = "Aqueduct - Water End W"
	mappaths = list("maps/modular_maps/aqueduct/aqueduct_end_w.dmm")

/datum/map_template/modular/aqueduct/water/end/w/New()
	cell_connections = list(
		new /datum/mm_connection("EAST", 0, 0, (MCF_AQUEDUCT | MCF_BRIDGE)),
	)
	..()
