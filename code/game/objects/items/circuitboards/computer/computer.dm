/obj/item/stock_parts/circuitboard/message_monitor
	name = "circuitboard (message monitor console)"
	build_path = /obj/machinery/computer/message_monitor
	origin_tech = @'{"programming":3}'

/obj/item/stock_parts/circuitboard/aiupload
	name = "circuitboard (AI upload console)"
	build_path = /obj/machinery/computer/upload/ai
	origin_tech = @'{"programming":4}'

/obj/item/stock_parts/circuitboard/borgupload
	name = "circuitboard (cyborg upload console)"
	build_path = /obj/machinery/computer/upload/robot
	origin_tech = @'{"programming":4}'

/obj/item/stock_parts/circuitboard/teleporter
	name = "circuitboard (teleporter control console)"
	build_path = /obj/machinery/computer/teleporter
	origin_tech = @'{"programming":2,"wormholes":4}'

/obj/item/stock_parts/circuitboard/atmos_alert
	name = "circuitboard (atmospheric alert console)"
	build_path = /obj/machinery/computer/atmos_alert

/obj/item/stock_parts/circuitboard/robotics
	name = "circuitboard (robotics control console)"
	build_path = /obj/machinery/computer/robotics
	origin_tech = @'{"programming":3}'

/obj/item/stock_parts/circuitboard/drone_control
	name = "circuitboard (drone control console)"
	build_path = /obj/machinery/computer/drone_control
	origin_tech = @'{"programming":3}'

/obj/item/stock_parts/circuitboard/arcade/battle
	name = "circuitboard (battle arcade machine)"
	build_path = /obj/machinery/computer/arcade/battle
	origin_tech = @'{"programming":1}'

/obj/item/stock_parts/circuitboard/arcade/orion_trail
	name = "circuitboard (orion trail arcade machine)"
	build_path = /obj/machinery/computer/arcade/orion_trail
	origin_tech = @'{"programming":1}'

/obj/item/stock_parts/circuitboard/turbine_control
	name = "circuitboard (turbine control console)"
	build_path = /obj/machinery/computer/turbine_computer

/obj/item/stock_parts/circuitboard/solar_control
	name = "circuitboard (solar control console)"
	build_path = /obj/machinery/power/solar_control
	origin_tech = @'{"programming":2,"powerstorage":2}'

/obj/item/stock_parts/circuitboard/prisoner
	name = "circuitboard (prisoner management console)"
	build_path = /obj/machinery/computer/prisoner

/obj/item/stock_parts/circuitboard/operating
	name = "circuitboard (patient monitoring console)"
	build_path = /obj/machinery/computer/operating
	origin_tech = @'{"programming":2,"biotech":2}'

/obj/item/stock_parts/circuitboard/helm
	name = "circuitboard (helm control console)"
	build_path = /obj/machinery/computer/ship/helm

/obj/item/stock_parts/circuitboard/comms
	name = "circuitboard (comms control console)"
	build_path = /obj/machinery/computer/ship/comms

/obj/item/stock_parts/circuitboard/ftl
	name = "circuitboard (FTL control console)"
	build_path = /obj/machinery/computer/ship/ftl

/obj/item/stock_parts/circuitboard/engine
	name = "circuitboard (engine control console)"
	build_path = /obj/machinery/computer/ship/engines

/obj/item/stock_parts/circuitboard/nav
	name = "circuitboard (navigation console)"
	build_path = /obj/machinery/computer/ship/navigation

/obj/item/stock_parts/circuitboard/nav/tele
	name = "circuitboard (navigation telescreen)"
	build_path = /obj/machinery/computer/ship/navigation/telescreen

/obj/item/stock_parts/circuitboard/sensors
	name = "circuitboard (sensors console)"
	build_path = /obj/machinery/computer/ship/sensors

/obj/item/stock_parts/circuitboard/design_console
	name = "circuitboard (design database console)"
	build_path = /obj/machinery/computer/design_console
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable   = 1,
		/obj/item/stock_parts/item_holder/disk_reader/buildable = 1,
	)

/obj/item/stock_parts/circuitboard/central_atmos
	name = "circuitboard (central atmospherics computer)"
	build_path = /obj/machinery/computer/central_atmos
	origin_tech = @'{"programming":2}'

/obj/item/stock_parts/circuitboard/area_atmos
	name = "circuitboard (air control console)"
	build_path = /obj/machinery/computer/area_atmos
	origin_tech = @'{"programming":2}'

/obj/item/stock_parts/circuitboard/area_atmos/area
	name = "circuitboard (area air control console)"
	build_path = /obj/machinery/computer/area_atmos/area

/obj/item/stock_parts/circuitboard/area_atmos/tag
	name = "circuitboard (wireless scrubber control console)"
	build_path = /obj/machinery/computer/area_atmos/tag

/obj/item/stock_parts/circuitboard/account_database
	name = "circuitboard (accounts uplink terminal)"
	build_path = /obj/machinery/computer/account_database

/obj/item/stock_parts/circuitboard/guestpass
	name = "circuitboard (guest pass terminal)"
	build_path = /obj/machinery/computer/guestpass
