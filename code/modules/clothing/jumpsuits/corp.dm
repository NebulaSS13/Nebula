/*
 * Corporate
*/

/obj/item/clothing/jumpsuit/corporate
	name = "\improper NanoTrasen assistant uniform"
	icon = 'icons/clothing/jumpsuits/corp/corp_nanotrasen.dmi'
	desc = "A NanoTrasen-branded jumpsuit in fetching ocean grey."

/obj/item/clothing/jumpsuit/corporate/techass
	name = "\improper NanoTrasen technical assistant's uniform"
	desc = "A NanoTrasen-branded jumpsuit in fetching ocean grey with engineering yellow accents."
	icon = 'icons/clothing/jumpsuits/corp/corp_nanotrasentech.dmi'

/obj/item/clothing/jumpsuit/corporate/veymed
	name = "\improper Vey-Medical uniform"
	icon = 'icons/clothing/jumpsuits/corp/corp_nanotrasen.dmi'
	desc = "A uniform belonging to Vey-Medical, a Skrellian biomedical Trans-Stellar."
	armor = list(
		ARMOR_BIO = ARMOR_BIO_MINOR
	)

/obj/item/clothing/jumpsuit/corporate/centauri
	name = "\improper Centauri Provisions jumpsuit"
	icon = 'icons/clothing/jumpsuits/corp/corp_centauri.dmi'
	desc = "A jumpsuit belonging to Centauri Provisions, a Trans-Stellar best known for its food and drink products."

/obj/item/clothing/jumpsuit/corporate/grayson
	name = "\improper Grayson overalls"
	icon = 'icons/clothing/jumpsuits/corp/corp_grayson.dmi'
	desc = "A set of overalls belonging to Grayson Manufactories, a mining Trans-Stellar."

/obj/item/clothing/jumpsuit/corporate/kaleidoscope
	name = "\improper Kaleidoscope uniform"
	icon = 'icons/clothing/jumpsuits/corp/corp_kaleid.dmi'
	desc = "A science uniform belonging to Kaleidoscope Cosmetics, a cosmetic and gene-modification trans-stellar."
	armor = list(
		ARMOR_BIO = ARMOR_BIO_MINOR
	)

/obj/item/clothing/jumpsuit/corporate/mbill_flight
	name = "\improper Major Bill's flight suit"
	icon = 'icons/clothing/jumpsuits/corp/corp_mbillflight.dmi'
	desc = "A faux-surplus pilot's suit belonging to Major Bill's Transportation, a shipping megacorporation."

/obj/item/clothing/jumpsuit/corporate/wulf
	name = "\improper Wulf jumpsuit"
	icon = 'icons/clothing/jumpsuits/corp/corp_wulf.dmi'
	desc = "A jumpsuit belonging to Wulf Aeronautics, a ship-building and propulsion systems Trans-Stellar."

/obj/item/clothing/jumpsuit/corporate/xion
	name = "\improper Xion jumpsuit"
	icon = 'icons/clothing/jumpsuits/corp/corp_xion.dmi'
	desc = "A jumpsuit belonging to Xion Manufacturing, an industrial equipment Trans-Stellar."


/obj/item/clothing/jumpsuit/corporate/zenghu
	name = "\improper Zeng-Hu jumpsuit"
	icon = 'icons/clothing/jumpsuits/corp/corp_zenghu.dmi'
	desc = "A jumpsuit belonging to Zeng-Hu Pharmaceuticals, a Trans-Stellar in the business of exactly what you'd expect..."
	armor = list(
		ARMOR_BIO = ARMOR_BIO_MINOR
	)

/obj/item/clothing/costume/hedberg //Not in loadout
	name = "\improper Hedberg law enforcement uniform"
	icon = 'icons/clothing/jumpsuits/corp/corp_hedberg.dmi'
	desc = "A sturdy civilian law enforcement uniform belonging to the Hedberg-Hammarstrom private security corporation."
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_SMALL
		) //Equivalent to security jumpsuit
	siemens_coefficient = 0.9

/obj/item/clothing/costume/hedbergtech //Not in loadout
	name = "\improper Hedberg technician uniform"
	icon = 'icons/clothing/jumpsuits/corp/corp_hedbergtech.dmi'
	desc = "A technician's uniform belonging to the Hedberg-Hammarstrom private security corporation. It is lightly shielded against radiation."
	armor = list(
		ARMOR_RAD = ARMOR_RAD_MINOR
	) // Equivalent to engineer's jumpsuit.
