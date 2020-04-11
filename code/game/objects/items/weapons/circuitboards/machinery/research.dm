/obj/item/stock_parts/circuitboard/rdserver
	name = T_BOARD("R&D server")
	build_path = /obj/machinery/r_n_d/server
	board_type = "machine"
	origin_tech = "{'" + TECH_DATA + "':3}"
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/stock_parts/scanning_module = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/destructive_analyzer
	name = T_BOARD("destructive analyzer")
	build_path = /obj/machinery/r_n_d/destructive_analyzer
	board_type = "machine"
	origin_tech = "{'" + TECH_MAGNET + "':2,'" + TECH_ENGINEERING + "':2,'" + TECH_DATA + "':2}"
	req_components = list(
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stock_parts/micro_laser = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/autolathe
	name = T_BOARD("autolathe")
	build_path = /obj/machinery/fabricator
	board_type = "machine"
	origin_tech = "{'" + TECH_ENGINEERING + "':2,'" + TECH_DATA + "':2}"
	req_components = list(
							/obj/item/stock_parts/matter_bin = 3,
							/obj/item/stock_parts/manipulator = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/autolathe/micro
	name = T_BOARD("microlathe")
	build_path = /obj/machinery/fabricator/micro
	origin_tech = "{'" + TECH_ENGINEERING + "':1,'" + TECH_DATA + "':1}"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1
	)
/obj/item/stock_parts/circuitboard/autolathe/book
	name = T_BOARD("autobinder")
	build_path = /obj/machinery/fabricator/book
	origin_tech = "{'" + TECH_ENGINEERING + "':1,'" + TECH_DATA + "':1}"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1
	)
/obj/item/stock_parts/circuitboard/replicator
	name = T_BOARD("replicator")
	build_path = /obj/machinery/fabricator/replicator
	board_type = "machine"
	origin_tech = "{'" + TECH_ENGINEERING + "':3,'" + TECH_DATA + "':2,'" + TECH_BIO + "':2}"
	req_components = list(
							/obj/item/stock_parts/matter_bin = 3,
							/obj/item/stock_parts/manipulator = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/protolathe
	name = T_BOARD("protolathe")
	build_path = /obj/machinery/r_n_d/protolathe
	board_type = "machine"
	origin_tech = "{'" + TECH_ENGINEERING + "':2,'" + TECH_DATA + "':2}"
	req_components = list(
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/chems/glass/beaker = 2)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/circuit_imprinter
	name = T_BOARD("circuit imprinter")
	build_path = /obj/machinery/r_n_d/circuit_imprinter
	board_type = "machine"
	origin_tech = "{'" + TECH_ENGINEERING + "':2,'" + TECH_DATA + "':2}"
	req_components = list(
							/obj/item/stock_parts/matter_bin = 1,
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/chems/glass/beaker = 2)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/mechfab
	name = "Circuit board (Exosuit Fabricator)"
	build_path = /obj/machinery/robotics_fabricator
	board_type = "machine"
	origin_tech = "{'" + TECH_DATA + "':3,'" + TECH_ENGINEERING + "':3}"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/suspension_gen
	name = T_BOARD("suspension generator")
	build_path = /obj/machinery/suspension_gen
	board_type = "machine"
	origin_tech = "{'" + TECH_DATA + "':4,'" + TECH_ENGINEERING + "':3,'" + TECH_MAGNET + "':4}"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/battery/buildable/stock = 1,
		/obj/item/cell/high = 1,
		/obj/item/stock_parts/access_lock/buildable = 1
	)

/obj/item/stock_parts/circuitboard/artifact_harvester
	name = T_BOARD("artifact harvester")
	build_path = /obj/machinery/artifact_harvester
	board_type = "machine"
	origin_tech = "{'" + TECH_DATA + "':4,'" + TECH_ENGINEERING + "':3}"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/artifact_analyser
	name = T_BOARD("artifact analyser")
	build_path = /obj/machinery/artifact_analyser
	board_type = "machine"
	origin_tech = "{'" + TECH_DATA + "':4,'" + TECH_ENGINEERING + "':3}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/micro_laser = 2)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/artifact_scanner
	name = T_BOARD("artifact scanpad")
	build_path = /obj/machinery/artifact_scanpad
	board_type = "machine"
	origin_tech = "{'" + TECH_DATA + "':2,'" + TECH_ENGINEERING + "':2,'" + TECH_MAGNET + "':2}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/cryopod
	name = T_BOARD("cryo pod")
	build_path = /obj/machinery/cryopod
	board_type = "machine"
	origin_tech = "{'" + TECH_DATA + "':6,'" + TECH_ENGINEERING + "':6,'" + TECH_BLUESPACE + "':6}"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 4,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/subspace/crystal = 1
		)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)
	buildtype_select = TRUE

/obj/item/stock_parts/circuitboard/cryopod/get_buildable_types()
	return typesof(/obj/machinery/cryopod)

/obj/item/stock_parts/circuitboard/merchant_pad
	name = T_BOARD("merchant pad")
	build_path = /obj/machinery/merchant_pad
	board_type = "machine"
	origin_tech = "{'" + TECH_DATA + "':6,'" + TECH_BLUESPACE + "':6,'" + TECH_ESOTERIC + "':1}"
	req_components = list(/obj/item/stack/cable_coil = 15)
	req_components = list(
		/obj/item/stock_parts/subspace/amplifier = 1,
		/obj/item/stock_parts/subspace/ansible = 1,
		/obj/item/stock_parts/subspace/crystal = 1,
		/obj/item/stock_parts/subspace/transmitter = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1,
	)