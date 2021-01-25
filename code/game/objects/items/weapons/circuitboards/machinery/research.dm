/obj/item/stock_parts/circuitboard/destructive_analyzer
	name = "circuitboard (destructive analyzer)"
	build_path = /obj/machinery/destructive_analyzer
	board_type = "machine"
	origin_tech = "{'magnets':2,'engineering':2,'programming':2}"
	req_components = list(
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stock_parts/micro_laser = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/autolathe
	name = "circuitboard (autolathe)"
	build_path = /obj/machinery/fabricator
	board_type = "machine"
	origin_tech = "{'engineering':2,'programming':2}"
	req_components = list(
							/obj/item/stock_parts/matter_bin = 3,
							/obj/item/stock_parts/manipulator = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/autolathe/micro
	name = "circuitboard (microlathe)"
	build_path = /obj/machinery/fabricator/micro
	origin_tech = "{'engineering':1,'programming':1}"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1
	)
/obj/item/stock_parts/circuitboard/autolathe/book
	name = "circuitboard (autobinder)"
	build_path = /obj/machinery/fabricator/book
	origin_tech = "{'engineering':1,'programming':1}"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/manipulator = 1
	)
/obj/item/stock_parts/circuitboard/replicator
	name = "circuitboard (replicator)"
	build_path = /obj/machinery/fabricator/replicator
	board_type = "machine"
	origin_tech = "{'engineering':3,'programming':2,'biotech':2}"
	req_components = list(
							/obj/item/stock_parts/matter_bin = 3,
							/obj/item/stock_parts/manipulator = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/protolathe
	name = "circuitboard (protolathe)"
	build_path = /obj/machinery/fabricator/protolathe
	board_type = "machine"
	origin_tech = "{'engineering':2,'programming':2}"
	req_components = list(
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/chems/glass/beaker = 2)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/circuit_imprinter
	name = "circuitboard (circuit imprinter)"
	build_path = /obj/machinery/fabricator/imprinter
	board_type = "machine"
	origin_tech = "{'engineering':2,'programming':2}"
	req_components = list(
							/obj/item/stock_parts/matter_bin = 1,
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/chems/glass/beaker = 2)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/mechfab
	name = "circuitboard (industrial fabricator)"
	build_path = /obj/machinery/fabricator/industrial
	board_type = "machine"
	origin_tech = "{'programming':3,'engineering':3}"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/roboticsfab
	name = "circuitboard (robotics fabricator)"
	build_path = /obj/machinery/fabricator/robotics
	board_type = "machine"
	origin_tech = "{'programming':3,'engineering':3}"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/textilesfab
	name = "circuitboard (textiles fabricator)"
	build_path = /obj/machinery/fabricator/textile
	board_type = "machine"
	origin_tech = "{'programming':3,'engineering':3}"
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
	name = "circuitboard (suspension generator)"
	build_path = /obj/machinery/suspension_gen
	board_type = "machine"
	origin_tech = "{'programming':4,'engineering':3,'magnets':4}"
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
	name = "circuitboard (artifact harvester)"
	build_path = /obj/machinery/artifact_harvester
	board_type = "machine"
	origin_tech = "{'programming':4,'engineering':3}"
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
	name = "circuitboard (artifact analyser)"
	build_path = /obj/machinery/artifact_analyser
	board_type = "machine"
	origin_tech = "{'programming':4,'engineering':3}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/micro_laser = 2)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/artifact_scanner
	name = "circuitboard (artifact scanpad)"
	build_path = /obj/machinery/artifact_scanpad
	board_type = "machine"
	origin_tech = "{'programming':2,'engineering':2,'magnets':2}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/micro_laser = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/cryopod
	name = "circuitboard (cryo pod)"
	build_path = /obj/machinery/cryopod
	board_type = "machine"
	origin_tech = "{'programming':6,'engineering':6,'wormholes':6}"
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
	name = "circuitboard (merchant pad)"
	build_path = /obj/machinery/merchant_pad
	board_type = "machine"
	origin_tech = "{'programming':6,'wormholes':6,'esoteric':1}"
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