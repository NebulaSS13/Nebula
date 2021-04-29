/datum/computer_file/program/merchant/tradeship
	required_access = list()

/obj/machinery/computer/modular/preset/merchant/tradeship
	default_software = list(
		/datum/computer_file/program/merchant/tradeship,
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor
	)

/obj/item/stack/tile/floor/five
	amount = 5

/obj/item/stack/cable_coil/single/yellow
	color = COLOR_AMBER

/obj/item/stack/cable_coil/random/three
	amount = 3
