/obj/item/clothing/suit/jacket/brown/nanotrasen
	name = "\improper NanoTrasen leather jacket"
	desc = "A brown leather coat. The NanoTrasen logo is proudly displayed on the back."
	icon = 'mods/content/corporate/icons/clothing/suit/nt_brown.dmi'

/obj/item/clothing/suit/jacket/leather/nanotrasen
	name = "\improper NanoTrasen black leather jacket"
	desc = "A black leather coat. The NanoTrasen logo is proudly displayed on the back."
	icon = 'mods/content/corporate/icons/clothing/suit/nt_black.dmi'

/obj/item/clothing/suit/mbill
	name = "shipping jacket"
	desc = "A green jacket bearing the logo of Major Bill's Shipping."
	icon = 'mods/content/corporate/icons/clothing/suit/mbill.dmi'
	storage = /datum/storage/pockets/suit

/obj/item/clothing/suit/jacket/winter/dais
	name = "\improper DAIS winter coat"
	icon = 'mods/content/corporate/icons/clothing/suit/dais_coat.dmi'
	hood = /obj/item/clothing/head/winterhood/dais
	siemens_coefficient = 0.5
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR
		)
	desc = "A hooded winter coat colored blue and white and bearing the logo of Deimos Advanced Information Systems."

/obj/item/clothing/head/winterhood/dais
	icon = 'mods/content/corporate/icons/clothing/head/hood_winter_dais.dmi'

//Security
/obj/item/clothing/suit/navyofficer
	name = "security officer's jacket"
	desc = "This jacket is for those special occasions when a security officer actually feels safe."
	icon_state = ICON_STATE_WORLD
	icon = 'mods/content/corporate/icons/clothing/suit/navy/officer.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS

/obj/item/clothing/suit/navywarden
	name = "warden's jacket"
	desc = "Perfectly suited for the warden that wants to leave an impression of style on those who visit the brig."
	icon_state = ICON_STATE_WORLD
	icon = 'mods/content/corporate/icons/clothing/suit/navy/warden.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS

/obj/item/clothing/suit/navyhos
	name = "head of security's jacket"
	desc = "This piece of clothing was specifically designed for asserting superior authority."
	icon_state = ICON_STATE_WORLD
	icon = 'mods/content/corporate/icons/clothing/suit/navy/hos.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS