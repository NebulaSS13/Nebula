/obj/item/clothing/accessory/solgov
	name = "master solgov accessory"
	icon = 'mods/content/military/icons/accessories/uniform_accessories.dmi'
//	accessory_icons = list(slot_w_uniform_str = 'mods/content/military/icons/accessories/onmob_uniform_accessories.dmi', slot_wear_suit_str = 'mods/content/military/icons/accessories/onmob_uniform_accessories.dmi')
	w_class = ITEM_SIZE_TINY

/*********
ranks - general
*********/

/obj/item/clothing/accessory/solgov/rank
	name = "ranks"
	desc = "Insignia denoting rank of some kind. These appear blank."
	icon_state = "fleetrank"
	on_rolled = list("down" = "none")
	slot = ACCESSORY_SLOT_RANK
	gender = PLURAL
	high_visibility = 1
	sprite_sheets = list()

/obj/item/clothing/accessory/solgov/rank/get_fibers()
	return null

///////////////////////////////////////////////////
//Nanotrasen Survey and Field Operations Division//
///////////////////////////////////////////////////

//Onship "rank"
/obj/item/clothing/accessory/solgov/rank/ntsfod
	name = "ranks (Nanotrasen Employee)"
	desc = "Badge denoting service in NTSFOD"
	icon_state = "ntsfod_enlisted"

//ERT and NT officials "rank"
/obj/item/clothing/accessory/solgov/rank/ntsfod/nt
	name = "ranks (Nanotrasen Official)"
	desc = "Badge denoting Nanotrasen official"
	icon_state = "ntsfod_officer"

//////////////////////
//Federation Armsmen//
//////////////////////
/obj/item/clothing/accessory/solgov/rank/arm
	name = "armsman ranks"
	desc = "Insignia denoting rank of some kind. These appear blank."
	icon_state = "arm_e1"
	on_rolled = list("down" = "none")

//Enlisted ranks//
/obj/item/clothing/accessory/solgov/rank/arm/enlisted
	name = "ranks (E-1 Junior Armsman)"
	desc = "Insignia denoting the rank of Junior Armsman."
	icon_state = "arm_e1"

/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e2
	name = "ranks (E-2 Armsman Basic)"
	desc = "Insignia denoting the rank of Armsman Basic."
	icon_state = "arm_e2"

/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e3
	name = "ranks (E-3 Armsman)"
	desc = "Insignia denoting the rank of Armsman."
	icon_state = "arm_e3"

/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e4
	name = "ranks (E-4 Senior Armsman)"
	desc = "Insignia denoting the rank of Senior Armsman."
	icon_state = "arm_e4"

/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e5
	name = "ranks (E-5 Staff Armsman)"
	desc = "Insignia denoting the rank of Staff Armsman."
	icon_state = "arm_e5"

/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e6
	name = "ranks (E-6 Chief Armsman)"
	desc = "Insignia denoting the rank of Chief Armsman."
	icon_state = "arm_e6"

/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e7
	name = "ranks (E-7 Master Armsman)"
	desc = "Insignia denoting the rank of Master Armsman."
	icon_state = "arm_e7"

/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e8
	name = "ranks (E-8 Chief Master Armsman)"
	desc = "Insignia denoting the rank of Chief Master Armsman."
	icon_state = "arm_e8"

/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e9
	name = "ranks (E-9 Command Master Armsman)"
	desc = "Insignia denoting the rank of Command Master Armsman."
	icon_state = "arm_e9"

/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e10
	name = "ranks (E-10 Command Master Armsman of the Federation)"
	desc = "Insignia denoting the rank of Command Master Armsman of the Federation."
	icon_state = "arm_e10"
//
//Officer ranks//
/obj/item/clothing/accessory/solgov/rank/arm/officer
	name = "ranks (O-1 Cadet)"
	desc = "Insignia denoting the rank of Cadet."
	icon_state = "arm_o1"

/obj/item/clothing/accessory/solgov/rank/arm/officer/o2
	name = "ranks (O-2 Sub-Lieutenant)"
	desc = "Insignia denoting the rank of Sub-Lieutenant."
	icon_state = "arm_o2"

/obj/item/clothing/accessory/solgov/rank/arm/officer/o3
	name = "ranks (O-3 Lieutenant)"
	desc = "Insignia denoting the rank of Lieutenant."
	icon_state = "arm_o3"

/obj/item/clothing/accessory/solgov/rank/arm/officer/o4
	name = "ranks (O-4 Senior Lieutenant)"
	desc = "Insignia denoting the rank of Senior Lieutenant."
	icon_state = "arm_o4"

/obj/item/clothing/accessory/solgov/rank/arm/officer/o5
	name = "ranks (O-5 Sub-Adjutant)"
	desc = "Insignia denoting the rank of Sub-Adjutant."
	icon_state = "arm_o5"

/obj/item/clothing/accessory/solgov/rank/arm/officer/o6
	name = "ranks (O-6 Adjutant)"
	desc = "Insignia denoting the rank of Adjutant."
	icon_state = "arm_o6"

/obj/item/clothing/accessory/solgov/rank/arm/officer/o7
	name = "ranks (O-7 Regiment Commandant)"
	desc = "Insignia denoting the rank of Regiment Commandant."
	icon_state = "arm_o7"

/obj/item/clothing/accessory/solgov/rank/arm/officer/o8
	name = "ranks (O-8 Brigade Commandant)"
	desc = "Insignia denoting the rank of Brigade Commandant."
	icon_state = "arm_o8"

/obj/item/clothing/accessory/solgov/rank/arm/officer/o9
	name = "ranks (O-9 Armsman Commandant)"
	desc = "Insignia denoting the rank of Armsman Commandant."
	icon_state = "arm_o9"

/obj/item/clothing/accessory/solgov/rank/arm/officer/o10
	name = "ranks (O-10 High Commandant of the Federation Armsmen)"
	desc = "Insignia denoting the rank of High Commandant of the Federation Armsmen ."
	icon_state = "arm_o10"
//

//
