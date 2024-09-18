/datum/computer_file/program/merchant/tradeship
	read_access = list()

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

/decl/species/monkey
	force_background_info = list(
		/decl/background_category/heritage =   /decl/background_detail/heritage/hidden/monkey,
		/decl/background_category/faction =   /decl/background_detail/faction/other
	)

/decl/species/golem
	force_background_info = list(
		/decl/background_category/heritage =   /decl/background_detail/heritage/hidden/cultist,
		/decl/background_category/faction =   /decl/background_detail/faction/other
	)

/decl/species/grafadreka
	force_background_info = list(
		/decl/background_category/heritage   = /decl/background_detail/heritage/grafadreka,
		/decl/background_category/citizenship = /decl/background_detail/citizenship/grafadreka,
		/decl/background_category/faction   = /decl/background_detail/faction/grafadreka,
		/decl/background_category/religion  = /decl/background_detail/religion/grafadreka
	)
