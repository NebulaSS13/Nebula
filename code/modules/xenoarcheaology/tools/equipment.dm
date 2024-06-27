/obj/item/clothing/suit/bio_suit/anomaly
	name = "anomaly suit"
	desc = "A suit that protects against exotic alien energies and biological contamination."
	anomaly_shielding = 0.7
	icon = 'icons/clothing/suits/biosuit/anomaly.dmi'

/obj/item/clothing/head/bio_hood/anomaly
	name = "anomaly hood"
	desc = "A hood that protects the head and face from exotic alien energies and biological contamination."
	icon = 'icons/clothing/head/biosuit/anomaly.dmi'
	anomaly_shielding = 0.3

/obj/item/clothing/suit/space/void/excavation
	name = "excavation voidsuit"
	desc = "A specially shielded voidsuit that insulates against some exotic alien energies, as well as the more mundane dangers of excavation."
	icon = 'icons/clothing/spacesuit/void/excavation/suit.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_SHIELDED
	)
	anomaly_shielding = 0.6
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/stack/flag,
		/obj/item/excavation,
		/obj/item/tool,
		/obj/item/scanner/breath,
		/obj/item/measuring_tape,
		/obj/item/ano_scanner,
		/obj/item/depth_scanner,
		/obj/item/core_sampler,
		/obj/item/gps,
		/obj/item/pinpointer/radio,
		/obj/item/radio/beacon,
		/obj/item/bag/fossils
	)

/obj/item/clothing/head/helmet/space/void/excavation
	name = "excavation voidsuit helmet"
	desc = "A sophisticated voidsuit helmet, capable of protecting the wearer from many exotic alien energies."
	icon = 'icons/clothing/spacesuit/void/excavation/helmet.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_SHIELDED
	)
	anomaly_shielding = 0.2

/obj/item/clothing/suit/space/void/excavation/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/excavation

/obj/item/belt/archaeology
	name = "excavation gear-belt"
	desc = "Can hold various excavation gear."
	icon = 'icons/clothing/belt/gearbelt.dmi'
	icon_state = ICON_STATE_WORLD
	item_state = ACCESSORY_SLOT_UTILITY
	storage = /datum/storage/belt/archaeology
	material = /decl/material/solid/organic/leather/synth
