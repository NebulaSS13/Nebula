/obj/item/clothing/accessory/solgov
	name = "master solgov accessory"
	w_class = ITEM_SIZE_TINY

/*********
ranks - general
*********/

/obj/item/clothing/accessory/solgov/rank
	name = "ranks"
	desc = "Insignia denoting rank of some kind. These appear blank."
	icon = 'mods/content/military/icons/accessories/ranks_ntsfod.dmi'
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
	icon = 'mods/content/military/icons/accessories/ranks_ntsfod_enlisted.dmi'

//ERT and NT officials "rank"
/obj/item/clothing/accessory/solgov/rank/ntsfod/nt
	name = "ranks (Nanotrasen Official)"
	desc = "Badge denoting Nanotrasen official"
	icon = 'mods/content/military/icons/accessories/ranks_ntsfod_officer.dmi'
	
//////////////////////
//Federation Armsmen//
//////////////////////
/obj/item/clothing/accessory/solgov/rank/arm
	name = "armsman ranks"
	desc = "Insignia denoting rank of some kind. These appear blank."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_e1.dmi'
	on_rolled = list("down" = "none")

//Enlisted ranks//
/obj/item/clothing/accessory/solgov/rank/arm/enlisted
	name = "ranks (E-1 Junior Armsman)"
	desc = "Insignia denoting the rank of Junior Armsman."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_e1.dmi'

/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e2
	name = "ranks (E-2 Armsman Basic)"
	desc = "Insignia denoting the rank of Armsman Basic."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_e2.dmi'

/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e3
	name = "ranks (E-3 Armsman)"
	desc = "Insignia denoting the rank of Armsman."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_e3.dmi'

/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e4
	name = "ranks (E-4 Senior Armsman)"
	desc = "Insignia denoting the rank of Senior Armsman."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_e4.dmi'

/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e5
	name = "ranks (E-5 Staff Armsman)"
	desc = "Insignia denoting the rank of Staff Armsman."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_e5.dmi'

/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e6
	name = "ranks (E-6 Chief Armsman)"
	desc = "Insignia denoting the rank of Chief Armsman."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_e6.dmi'

/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e7
	name = "ranks (E-7 Master Armsman)"
	desc = "Insignia denoting the rank of Master Armsman."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_e7.dmi'

/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e8
	name = "ranks (E-8 Chief Master Armsman)"
	desc = "Insignia denoting the rank of Chief Master Armsman."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_e8.dmi'

/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e9
	name = "ranks (E-9 Command Master Armsman)"
	desc = "Insignia denoting the rank of Command Master Armsman."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_e9.dmi'

/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e10
	name = "ranks (E-10 Command Master Armsman of the Federation)"
	desc = "Insignia denoting the rank of Command Master Armsman of the Federation."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_e10.dmi'
//
//Officer ranks//
/obj/item/clothing/accessory/solgov/rank/arm/officer
	name = "ranks (O-1 Cadet)"
	desc = "Insignia denoting the rank of Cadet."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_o1.dmi'

/obj/item/clothing/accessory/solgov/rank/arm/officer/o2
	name = "ranks (O-2 Sub-Lieutenant)"
	desc = "Insignia denoting the rank of Sub-Lieutenant."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_o2.dmi'

/obj/item/clothing/accessory/solgov/rank/arm/officer/o3
	name = "ranks (O-3 Lieutenant)"
	desc = "Insignia denoting the rank of Lieutenant."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_o3.dmi'

/obj/item/clothing/accessory/solgov/rank/arm/officer/o4
	name = "ranks (O-4 Senior Lieutenant)"
	desc = "Insignia denoting the rank of Senior Lieutenant."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_o4.dmi'

/obj/item/clothing/accessory/solgov/rank/arm/officer/o5
	name = "ranks (O-5 Sub-Adjutant)"
	desc = "Insignia denoting the rank of Sub-Adjutant."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_o5.dmi'

/obj/item/clothing/accessory/solgov/rank/arm/officer/o6
	name = "ranks (O-6 Adjutant)"
	desc = "Insignia denoting the rank of Adjutant."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_o6.dmi'

/obj/item/clothing/accessory/solgov/rank/arm/officer/o7
	name = "ranks (O-7 Regiment Commandant)"
	desc = "Insignia denoting the rank of Regiment Commandant."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_o7.dmi'

/obj/item/clothing/accessory/solgov/rank/arm/officer/o8
	name = "ranks (O-8 Brigade Commandant)"
	desc = "Insignia denoting the rank of Brigade Commandant."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_o8.dmi'

/obj/item/clothing/accessory/solgov/rank/arm/officer/o9
	name = "ranks (O-9 Armsman Commandant)"
	desc = "Insignia denoting the rank of Armsman Commandant."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_o9.dmi'

/obj/item/clothing/accessory/solgov/rank/arm/officer/o10
	name = "ranks (O-10 High Commandant of the Federation Armsmen)"
	desc = "Insignia denoting the rank of High Commandant of the Federation Armsmen ."
	icon = 'mods/content/military/icons/accessories/ranks_armsmen_o10.dmi'
//