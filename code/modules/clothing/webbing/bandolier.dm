/obj/item/clothing/webbing/bandolier
	name = "bandolier"
	desc = "A lightweight synthethic bandolier with straps for holding ammunition or other small objects."
	icon = 'icons/obj/items/bandolier.dmi'
	slots = 10
	max_w_class = ITEM_SIZE_NORMAL

/obj/item/clothing/webbing/bandolier/Initialize()
	. = ..()
	hold.can_hold = list(
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
		/obj/item/storage/pill_bottle
	)
