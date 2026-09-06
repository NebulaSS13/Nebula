/datum/storage/pockets
	storage_slots = 3
	max_w_class = ITEM_SIZE_SMALL

/datum/storage/pockets/pouches
	storage_slots = 4 //to accomodate it being slotless

/datum/storage/pockets/pouches/New()
	max_storage_space = storage_slots * BASE_STORAGE_COST(max_w_class)
	..()

/datum/storage/pockets/knifeharness
	storage_slots = 2
	max_w_class = ITEM_SIZE_NORMAL //for knives
	can_hold = list(
		/obj/item/tool/axe/hatchet,
		/obj/item/knife,
	)

/datum/storage/pockets/webbing
	storage_slots = 4

/datum/storage/pockets/vest
	storage_slots = 5

/datum/storage/pockets/bandolier
	storage_slots = 10
	max_w_class = ITEM_SIZE_NORMAL
	can_hold = list(
		/obj/item/ammo_casing,
		/obj/item/grenade,
		/obj/item/knife,
		/obj/item/star,
		/obj/item/rcd_ammo,
		/obj/item/chems/syringe,
		/obj/item/chems/hypospray,
		/obj/item/chems/hypospray/autoinjector,
		/obj/item/chems/inhaler,
		/obj/item/syringe_cartridge,
		/obj/item/plastique,
		/obj/item/clothing/mask/smokable,
		/obj/item/screwdriver,
		/obj/item/multitool,
		/obj/item/magnetic_ammo,
		/obj/item/ammo_magazine,
		/obj/item/chems/glass/beaker/vial,
		/obj/item/paper,
		/obj/item/pen,
		/obj/item/photo,
		/obj/item/marshalling_wand,
		/obj/item/chems/pill,
		/obj/item/pill_bottle
	)

/datum/storage/pockets/bandolier/crafted
	storage_slots = 5
	max_w_class = ITEM_SIZE_SMALL
	can_hold = list(/obj/item)

/datum/storage/pockets/suit
	storage_slots = 2
	max_w_class = ITEM_SIZE_SMALL
