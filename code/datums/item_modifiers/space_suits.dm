/decl/item_modifier/space_suit/engineering
	name = "Engineering"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "engineering voidsuit helmet",
			SETUP_ONMOB_ICON = 'icons/clothing/spacesuit/void/engineering/helmet.dmi'
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "engineering voidsuit",
			SETUP_ONMOB_ICON = 'icons/clothing/spacesuit/void/engineering/suit.dmi'
		)
	)

/decl/item_modifier/space_suit/engineering/alt
	name = "Engineering, Alt"

/decl/item_modifier/space_suit/engineering/alt/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_ONMOB_ICON] = 'icons/clothing/spacesuit/void/engineering_alt/helmet.dmi'

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_ONMOB_ICON] = 'icons/clothing/spacesuit/void/engineering_alt/suit.dmi'

/decl/item_modifier/space_suit/mining
	name = "Mining"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "mining voidsuit helmet",
			SETUP_ONMOB_ICON = 'icons/clothing/spacesuit/void/mining/helmet.dmi'
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "mining voidsuit",
			SETUP_ONMOB_ICON = 'icons/clothing/spacesuit/void/mining/suit.dmi'
		)
	)

/decl/item_modifier/space_suit/science
	name = "Science"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "excavation voidsuit helmet",
			SETUP_ONMOB_ICON = 'icons/clothing/spacesuit/void/excavation/helmet.dmi'
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "excavation voidsuit",
			SETUP_ONMOB_ICON = 'icons/clothing/spacesuit/void/excavation/suit.dmi'
		)
	)

/decl/item_modifier/space_suit/medical
	name = "Medical"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "medical voidsuit helmet",
			SETUP_ONMOB_ICON = 'icons/clothing/spacesuit/void/medical/helmet.dmi'
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "medical voidsuit",
			SETUP_ONMOB_ICON = 'icons/clothing/spacesuit/void/medical/suit.dmi'
		)
	)

/decl/item_modifier/space_suit/medical/alt
	name = "Medical, Alt"

/decl/item_modifier/space_suit/medical/alt/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_ONMOB_ICON] = 'icons/clothing/spacesuit/void/medical_alt/helmet.dmi'

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_ONMOB_ICON] = 'icons/clothing/spacesuit/void/medical_alt/suit.dmi'

/decl/item_modifier/space_suit/security
	name = "Security"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "security voidsuit helmet",
			SETUP_ONMOB_ICON = 'icons/clothing/spacesuit/void/sec/helmet.dmi'
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "security voidsuit",
			SETUP_ONMOB_ICON = 'icons/clothing/spacesuit/void/sec/suit.dmi'
		)
	)

/decl/item_modifier/space_suit/security/alt
	name = "Security, Alt"

/decl/item_modifier/space_suit/security/alt/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_ONMOB_ICON] = 'icons/clothing/spacesuit/void/sec_alt/helmet.dmi'

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_ONMOB_ICON] = 'icons/clothing/spacesuit/void/sec_alt/suit.dmi'

/decl/item_modifier/space_suit/atmos
	name = "Atmos"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "atmospherics voidsuit helmet",
			SETUP_ONMOB_ICON = 'icons/clothing/spacesuit/void/atmos/helmet.dmi'
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "atmospherics voidsuit",
			SETUP_ONMOB_ICON = 'icons/clothing/spacesuit/void/atmos/suit.dmi'
		)
	)

/decl/item_modifier/space_suit/atmos/alt
	name = "Atmos, Alt"

/decl/item_modifier/space_suit/atmos/alt/Initialize()
	. = ..()
	var/helmet_setup = type_setups[/obj/item/clothing/head/helmet/space]
	helmet_setup[SETUP_ONMOB_ICON] = 'icons/clothing/spacesuit/void/atmos_alt/helmet.dmi'

	var/suit_setup = type_setups[/obj/item/clothing/suit/space/void]
	suit_setup[SETUP_ONMOB_ICON] = 'icons/clothing/spacesuit/void/atmos_alt/suit.dmi'

/decl/item_modifier/space_suit/mercenary
	name = "Mercenary"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "blood-red voidsuit helmet",
			SETUP_ONMOB_ICON = 'icons/clothing/spacesuit/void/merc/helmet.dmi'
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "blood-red voidsuit",
			SETUP_ONMOB_ICON = 'icons/clothing/spacesuit/void/merc/suit.dmi'
		)
	)

/decl/item_modifier/space_suit/mercenary/emag
	name = "^%###^%$"

/decl/item_modifier/space_suit/pilot
	name = "Pilot"
	type_setups = list(
		/obj/item/clothing/head/helmet/space = list(
			SETUP_NAME = "pilot voidsuit helmet",
			SETUP_ONMOB_ICON = 'icons/clothing/spacesuit/void/pilot/helmet.dmi'
		),
		/obj/item/clothing/suit/space/void = list(
			SETUP_NAME = "pilot voidsuit",
			SETUP_ONMOB_ICON = 'icons/clothing/spacesuit/void/pilot/suit.dmi'
		)
	)
