/obj/machinery/suit_cycler/Initialize()
	LAZYDISTINCTADD(available_bodytypes, BODYTYPE_AVIAN)
	. = ..()

//mining

/obj/item/clothing/suit/space/void/mining/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/neoavians/icons/clothing/spacesuit/void/mining/suit.dmi')

/obj/item/clothing/head/helmet/space/void/mining/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/neoavians/icons/clothing/spacesuit/void/mining/helmet.dmi')

//excavation

/obj/item/clothing/suit/space/void/excavation/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/neoavians/icons/clothing/spacesuit/void/mining/suit.dmi')

/obj/item/clothing/head/helmet/space/void/excavation/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/neoavians/icons/clothing/spacesuit/void/mining/helmet.dmi')

//engineering

/obj/item/clothing/head/helmet/space/void/engineering/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/neoavians/icons/clothing/spacesuit/void/engineering/helmet.dmi')

/obj/item/clothing/suit/space/void/engineering/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/neoavians/icons/clothing/spacesuit/void/engineering/suit.dmi')

/obj/item/clothing/head/helmet/space/void/atmos/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/neoavians/icons/clothing/spacesuit/void/atmos/helmet.dmi')

/obj/item/clothing/suit/space/void/atmos/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/neoavians/icons/clothing/spacesuit/void/atmos/suit.dmi')

//medical

/obj/item/clothing/suit/space/void/medical/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/neoavians/icons/clothing/spacesuit/void/medical/suit.dmi')

/obj/item/clothing/head/helmet/space/void/medical/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/neoavians/icons/clothing/spacesuit/void/medical/helmet.dmi')

//security

/obj/item/clothing/head/helmet/space/void/security/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/neoavians/icons/clothing/spacesuit/void/sec/helmet.dmi')

/obj/item/clothing/suit/space/void/security/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/neoavians/icons/clothing/spacesuit/void/sec/suit.dmi')

//salvage

/obj/item/clothing/head/helmet/space/void/engineering/salvage/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/neoavians/icons/clothing/spacesuit/void/salvage/helmet.dmi')

/obj/item/clothing/suit/space/void/engineering/salvage/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/neoavians/icons/clothing/spacesuit/void/salvage/suit.dmi')

//pilot
/obj/item/clothing/head/helmet/space/void/expedition/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/neoavians/icons/clothing/spacesuit/void/pilot/helmet.dmi')

/obj/item/clothing/suit/space/void/expedition/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/neoavians/icons/clothing/spacesuit/void/pilot/suit.dmi')

//merc
/obj/item/clothing/head/helmet/space/void/merc/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/neoavians/icons/clothing/spacesuit/void/merc/helmet.dmi')

/obj/item/clothing/suit/space/void/merc/Initialize()
	. = ..()
	LAZYSET(sprite_sheets, BODYTYPE_AVIAN, 'mods/species/neoavians/icons/clothing/spacesuit/void/merc/suit.dmi')