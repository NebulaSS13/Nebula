/obj/item/stock_parts/circuitboard/holodeck_control
	name = "circuitboard (holodeck control console)"
	build_path = /obj/machinery/computer/holodeck_control
	origin_tech = @'{"programming":2,"wormholes":2}'
	buildtype_select = TRUE
	var/last_to_emag
	var/linkedholodeck_area
	var/list/supported_programs
	var/list/restricted_programs

/obj/item/stock_parts/circuitboard/holodeck_control/get_buildable_types()
	return typesof(/obj/machinery/computer/holodeck_control)

/obj/item/stock_parts/circuitboard/holodeck_control/construct(var/obj/machinery/computer/holodeck_control/HC)
	if (..(HC))
		HC.supported_programs	= supported_programs.Copy()
		HC.restricted_programs	= restricted_programs.Copy()
		if(linkedholodeck_area)
			HC.linkedholodeck	= locate(linkedholodeck_area)
		if(last_to_emag)
			HC.last_to_emag		= last_to_emag
			HC.emagged 			= 1
			HC.safety_disabled	= 1

/obj/item/stock_parts/circuitboard/holodeck_control/deconstruct(var/obj/machinery/computer/holodeck_control/HC)
	if (..(HC))
		linkedholodeck_area		= HC.linkedholodeck_area
		supported_programs		= HC.supported_programs.Copy()
		restricted_programs 	= HC.restricted_programs.Copy()
		last_to_emag			= HC.last_to_emag
		HC.emergencyShutdown()
