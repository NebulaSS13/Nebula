/obj/machinery/suit_cycler/engineering
	name = "Engineering suit cycler"
	model_text = "Engineering"
	initial_access = list(access_construction)
	available_modifications = list(/decl/item_modifier/space_suit/engineering, /decl/item_modifier/space_suit/atmos)

/obj/machinery/suit_cycler/engineering/alt
	available_modifications = list(
		/decl/item_modifier/space_suit/engineering/alt,
		/decl/item_modifier/space_suit/atmos/alt
	)
	buildable = FALSE

/obj/machinery/suit_cycler/mining
	name = "Mining suit cycler"
	model_text = "Mining"
	initial_access = list(access_mining)
	available_modifications = list(/decl/item_modifier/space_suit/mining)

/obj/machinery/suit_cycler/science
	name = "Excavation suit cycler"
	model_text = "Excavation"
	initial_access = list(access_xenoarch)
	available_modifications = list(/decl/item_modifier/space_suit/science)

/obj/machinery/suit_cycler/security
	name = "Security suit cycler"
	model_text = "Security"
	initial_access = list(access_security)
	available_modifications = list(/decl/item_modifier/space_suit/security, /decl/item_modifier/space_suit/security/alt)

/obj/machinery/suit_cycler/security/alt
	available_modifications = list(/decl/item_modifier/space_suit/security/alt)
	buildable = FALSE

/obj/machinery/suit_cycler/medical
	name = "Medical suit cycler"
	model_text = "Medical"
	initial_access = list(access_medical)
	available_modifications = list(/decl/item_modifier/space_suit/medical)

/obj/machinery/suit_cycler/medical/alt
	available_modifications = list(/decl/item_modifier/space_suit/medical/alt)
	buildable = FALSE

/obj/machinery/suit_cycler/syndicate
	name = "Nonstandard suit cycler"
	model_text = "Nonstandard"
	initial_access = list(access_syndicate)
	available_modifications = list(/decl/item_modifier/space_suit/mercenary)
	can_repair = 1
	buildable = FALSE

/obj/machinery/suit_cycler/pilot
	name = "Pilot suit cycler"
	model_text = "Pilot"
	initial_access = list(access_mining_office)
	available_modifications = list(/decl/item_modifier/space_suit/pilot)
