/obj/structure/closet/secure_closet/engineering_chief
	name = "chief engineer's locker"
	closet_appearance = /decl/closet_appearance/secure_closet/engineering/ce
	req_access = list(access_ce)

/obj/structure/closet/secure_closet/engineering_chief/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/clothing/accessory/storage/vest/brown = 70, /obj/item/clothing/accessory/storage = 30)),
		new/datum/atom_creator/weighted(list(/obj/item/storage/backpack/industrial, /obj/item/storage/backpack/satchel/eng)),
		new/datum/atom_creator/simple(/obj/item/storage/backpack/dufflebag/eng, 50),
		/obj/item/blueprints,
		/obj/item/clothing/under/chief_engineer,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/gloves/insulated,
		/obj/item/clothing/shoes/color/brown,
		/obj/item/radio/headset/heads/ce,
		/obj/item/storage/toolbox/mechanical,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/multitool,
		/obj/item/flash,
		/obj/item/taperoll/engineering,
		/obj/item/crowbar/brace_jack
	)

/obj/structure/closet/secure_closet/engineering_electrical
	name = "electrical supplies"
	req_access = list(access_engine_equip)
	closet_appearance = /decl/closet_appearance/secure_closet/engineering/electrical

/obj/structure/closet/secure_closet/engineering_electrical/WillContain()
	return list(
		/obj/item/clothing/gloves/insulated = 3,
		/obj/item/storage/toolbox/electrical = 3,
		/obj/item/storage/toolbox/repairs = 3,
		/obj/item/stock_parts/circuitboard/apc = 3,
		/obj/item/multitool = 3
	)

/obj/structure/closet/secure_closet/engineering_welding
	name = "welding supplies"
	req_access = list(access_construction)
	closet_appearance = /decl/closet_appearance/secure_closet/engineering/welding

/obj/structure/closet/secure_closet/engineering_welding/WillContain()
	return list(
		/obj/item/clothing/head/welding = 3,
		/obj/item/weldingtool/largetank = 3,
		/obj/item/weldpack = 3,
		/obj/item/clothing/glasses/welding = 3,
		/obj/item/welder_tank = 6
	)

/obj/structure/closet/secure_closet/engineering_personal
	name = "engineer's locker"
	req_access = list(access_engine_equip)
	closet_appearance = /decl/closet_appearance/secure_closet/engineering

/obj/structure/closet/secure_closet/engineering_personal/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/clothing/accessory/storage/vest/brown = 70, /obj/item/clothing/accessory/storage = 30)),
		new/datum/atom_creator/weighted(list(/obj/item/storage/backpack/industrial, /obj/item/storage/backpack/satchel/eng)),
		new/datum/atom_creator/simple(/obj/item/storage/backpack/dufflebag/eng, 50),
		/obj/item/storage/toolbox/mechanical,
		/obj/item/radio/headset/headset_eng,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/glasses/meson,
		/obj/item/taperoll/engineering
	)

/obj/structure/closet/secure_closet/atmos_personal
	name = "technician's locker"
	req_access = list(access_atmospherics)
	closet_appearance = /decl/closet_appearance/secure_closet/engineering/atmos

/obj/structure/closet/secure_closet/atmos_personal/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/clothing/accessory/storage/vest/brown = 70, /obj/item/clothing/accessory/storage = 30)),
		new/datum/atom_creator/weighted(list(/obj/item/storage/backpack/industrial, /obj/item/storage/backpack/satchel/eng)),
		new/datum/atom_creator/simple(/obj/item/storage/backpack/dufflebag/eng, 50),
		/obj/item/clothing/suit/fire,
		/obj/item/flashlight,
		/obj/item/extinguisher,
		/obj/item/radio/headset/headset_eng,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/taperoll/atmos
	)
