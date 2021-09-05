/obj/machinery/suit_cycler/Initialize()
	. = ..()
	available_bodytypes += BODYTYPE_RESOMI

//mining

/obj/item/clothing/suit/space/void/mining/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/spacesuit/void/mining/suit.dmi'
	. = ..()

/obj/item/clothing/head/helmet/space/void/mining/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/spacesuit/void/mining/helmet.dmi'
	. = ..()

//engineering

/obj/item/clothing/head/helmet/space/void/engineering/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/spacesuit/void/engineering/helmet.dmi'
	. = ..()

/obj/item/clothing/suit/space/void/engineering/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/spacesuit/void/engineering/suit.dmi'
	. = ..()

/obj/item/clothing/head/helmet/space/void/atmos/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/spacesuit/void/atmos/helmet.dmi'
	. = ..()

/obj/item/clothing/suit/space/void/atmos/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/spacesuit/void/atmos/suit.dmi'
	. = ..()

//medical

/obj/item/clothing/suit/space/void/medical/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/spacesuit/void/medical/suit.dmi'
	. = ..()

/obj/item/clothing/head/helmet/space/void/medical/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/spacesuit/void/medical/helmet.dmi'
	. = ..()

//security

/obj/item/clothing/head/helmet/space/void/security/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/spacesuit/void/sec/helmet.dmi'
	. = ..()

/obj/item/clothing/suit/space/void/security/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/spacesuit/void/sec/suit.dmi'
	. = ..()

//salvage

/obj/item/clothing/head/helmet/space/void/engineering/salvage/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/spacesuit/void/salvage/helmet.dmi'
	. = ..()

/obj/item/clothing/suit/space/void/engineering/salvage/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/spacesuit/void/salvage/suit.dmi'
	. = ..()

//pilot
/obj/item/clothing/head/helmet/space/void/pilot/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/spacesuit/void/pilot/helmet.dmi'
	. = ..()

/obj/item/clothing/suit/space/void/pilot/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/spacesuit/void/pilot/suit.dmi'
	. = ..()

//merc
/obj/item/clothing/head/helmet/space/void/merc/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/spacesuit/void/merc/helmet.dmi'
	. = ..()

/obj/item/clothing/suit/space/void/merc/Initialize()
	LAZYINITLIST(sprite_sheets)
	sprite_sheets[BODYTYPE_RESOMI] = 'mods/species/resomi/icons/clothing/exp/spacesuit/void/merc/suit.dmi'
	. = ..()
