/obj/machinery/suit_cycler/engineering
	name = "engineering suit cycler"
	model_text = "Engineering"
	initial_access = list(access_construction)
	available_modifications = list(
		/decl/item_modifier/space_suit/engineering,
		/decl/item_modifier/space_suit/atmos
	)

/obj/machinery/suit_cycler/engineering/prepared
	buildable = FALSE
	helmet = /obj/item/clothing/head/helmet/space/void/engineering
	suit = /obj/item/clothing/suit/space/void/engineering
	boots = /obj/item/clothing/shoes/magboots

/obj/machinery/suit_cycler/engineering/prepared/atmospheric
	helmet = /obj/item/clothing/head/helmet/space/void/atmos
	suit = /obj/item/clothing/suit/space/void/atmos

/obj/machinery/suit_cycler/engineering/alt
	available_modifications = list(
		/decl/item_modifier/space_suit/engineering/alt,
		/decl/item_modifier/space_suit/atmos/alt
	)
	buildable = FALSE

/obj/machinery/suit_cycler/mining
	name = "mining suit cycler"
	model_text = "Mining"
	initial_access = list(access_mining)
	available_modifications = list(
		/decl/item_modifier/space_suit/mining
	)

/obj/machinery/suit_cycler/science
	name = "excavation suit cycler"
	model_text = "Excavation"
	initial_access = list(access_xenoarch)
	available_modifications = list(
		/decl/item_modifier/space_suit/science
	)

/obj/machinery/suit_cycler/security
	name = "security suit cycler"
	model_text = "Security"
	initial_access = list(access_security)
	available_modifications = list(
		/decl/item_modifier/space_suit/security,
		/decl/item_modifier/space_suit/security/alt
	)

/obj/machinery/suit_cycler/security/prepared
	buildable = FALSE
	helmet = /obj/item/clothing/head/helmet/space/void/security
	suit = /obj/item/clothing/suit/space/void/security
	boots = /obj/item/clothing/shoes/magboots

/obj/machinery/suit_cycler/security/alt
	available_modifications = list(
		/decl/item_modifier/space_suit/security/alt
	)
	buildable = FALSE

/obj/machinery/suit_cycler/medical
	name = "medical suit cycler"
	model_text = "Medical"
	initial_access = list(access_medical)
	available_modifications = list(
		/decl/item_modifier/space_suit/medical
	)

/obj/machinery/suit_cycler/medical/prepared
	buildable = FALSE
	helmet = /obj/item/clothing/head/helmet/space/void/medical/alt
	suit = /obj/item/clothing/suit/space/void/medical/alt
	boots = /obj/item/clothing/shoes/magboots

/obj/machinery/suit_cycler/medical/alt
	available_modifications = list(
		/decl/item_modifier/space_suit/medical/alt
	)
	buildable = FALSE

/obj/machinery/suit_cycler/nonstandard
	name = "nonstandard suit cycler"
	model_text = "Nonstandard"
	available_modifications = list(
		/decl/item_modifier/space_suit/mercenary
	)
	can_repair = TRUE
	buildable = FALSE

/obj/machinery/suit_cycler/nonstandard/raider
	initial_access = list(access_raider)

/obj/machinery/suit_cycler/nonstandard/mercenary
	initial_access = list(access_mercenary)

/obj/machinery/suit_cycler/pilot
	name = "pilot suit cycler"
	model_text = "Pilot"
	initial_access = list(access_mining_office)
	available_modifications = list(
		/decl/item_modifier/space_suit/pilot
	)

/obj/machinery/suit_cycler/generic
	name = "generic suit cycler"
	model_text = "Generic"
	req_access = list()
	initial_access = list()
	locked = FALSE

/obj/machinery/suit_cycler/generic/prepared
	buildable = FALSE
	helmet = /obj/item/clothing/head/helmet/space
	suit = /obj/item/clothing/suit/space
