/obj/item/rig/ert
	name = "emergency response command hardsuit control module"
	desc = "A hardsuit used by many corporate and governmental emergency response forces. Has blue highlights. Armoured and space ready."
	suit_type = "emergency response command"
	icon = 'icons/clothing/rigs/ert/commander/rig.dmi'

	chest =  /obj/item/clothing/suit/space/rig/ert
	helmet = /obj/item/clothing/head/helmet/space/rig/ert
	boots =  /obj/item/clothing/shoes/magboots/rig/ert
	gloves = /obj/item/clothing/gloves/rig/ert

	req_access = list(access_cent_specops)

	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_MAJOR,
		ARMOR_BULLET = ARMOR_BALLISTIC_RESISTANT,
		ARMOR_LASER = ARMOR_LASER_MAJOR,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_SHIELDED
	)
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/handcuffs,
		/obj/item/t_scanner,
		/obj/item/rcd,
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/multitool,
		/obj/item/radio,
		/obj/item/scanner/gas,
		/obj/item/briefcase/inflatable,
		/obj/item/baton,
		/obj/item/gun,
		/obj/item/firstaid,
		/obj/item/chems/hypospray,
		/obj/item/roller
	)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/cooling_unit
	)

/obj/item/clothing/head/helmet/space/rig/ert
	camera = /obj/machinery/camera/network/ert
	icon = 'icons/clothing/rigs/ert/commander/helmet.dmi'
/obj/item/clothing/suit/space/rig/ert
	icon = 'icons/clothing/rigs/ert/commander/chest.dmi'
/obj/item/clothing/shoes/magboots/rig/ert
	icon = 'icons/clothing/rigs/ert/commander/boots.dmi'
/obj/item/clothing/gloves/rig/ert
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_NOCUFFS
	icon = 'icons/clothing/rigs/ert/commander/gloves.dmi'

/obj/item/rig/ert/engineer
	name = "emergency response engineering hardsuit control module"
	desc = "A hardsuit used by many corporate and governmental emergency response forces. Has orange highlights. Armoured and space ready."
	suit_type = "emergency response engineer"
	icon = 'icons/clothing/rigs/ert/engineer/rig.dmi'

	chest =  /obj/item/clothing/suit/space/rig/ert/engineer
	helmet = /obj/item/clothing/head/helmet/space/rig/ert/engineer
	boots =  /obj/item/clothing/shoes/magboots/rig/ert/engineer
	gloves = /obj/item/clothing/gloves/rig/ert/engineer

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/clothing/head/helmet/space/rig/ert/engineer
	icon = 'icons/clothing/rigs/ert/engineer/helmet.dmi'
/obj/item/clothing/suit/space/rig/ert/engineer
	icon = 'icons/clothing/rigs/ert/engineer/chest.dmi'
/obj/item/clothing/shoes/magboots/rig/ert/engineer
	icon = 'icons/clothing/rigs/ert/engineer/boots.dmi'
/obj/item/clothing/gloves/rig/ert/engineer
	icon = 'icons/clothing/rigs/ert/engineer/gloves.dmi'
	siemens_coefficient = 0

/obj/item/rig/ert/janitor
	name = "emergency response sanitation hardsuit control module"
	desc = "A hardsuit used by many corporate and governmental emergency response forces. Has purple highlights. Armoured and space ready."
	suit_type = "emergency response sanitation"
	icon = 'icons/clothing/rigs/ert/janitor/rig.dmi'

	chest =  /obj/item/clothing/suit/space/rig/ert/janitor
	helmet = /obj/item/clothing/head/helmet/space/rig/ert/janitor
	boots =  /obj/item/clothing/shoes/magboots/rig/ert/janitor
	gloves = /obj/item/clothing/gloves/rig/ert/janitor

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/fabricator/wf_sign,
		/obj/item/rig_module/grenade_launcher/cleaner,
		/obj/item/rig_module/device/decompiler,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/clothing/head/helmet/space/rig/ert/janitor
	icon = 'icons/clothing/rigs/ert/janitor/helmet.dmi'
/obj/item/clothing/suit/space/rig/ert/janitor
	icon = 'icons/clothing/rigs/ert/janitor/chest.dmi'
/obj/item/clothing/shoes/magboots/rig/ert/janitor
	icon = 'icons/clothing/rigs/ert/janitor/boots.dmi'
/obj/item/clothing/gloves/rig/ert/janitor
	icon = 'icons/clothing/rigs/ert/janitor/gloves.dmi'

/obj/item/rig/ert/medical
	name = "emergency response medical hardsuit control module"
	desc = "A hardsuit used by many corporate and governmental emergency response forces. Has white highlights. Armoured and space ready."
	suit_type = "emergency response medic"
	icon = 'icons/clothing/rigs/ert/medic/rig.dmi'

	chest =  /obj/item/clothing/suit/space/rig/ert/medical
	helmet = /obj/item/clothing/head/helmet/space/rig/ert/medical
	boots =  /obj/item/clothing/shoes/magboots/rig/ert/medical
	gloves = /obj/item/clothing/gloves/rig/ert/medical

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/clothing/head/helmet/space/rig/ert/medical
	icon = 'icons/clothing/rigs/ert/medic/helmet.dmi'
/obj/item/clothing/suit/space/rig/ert/medical
	icon = 'icons/clothing/rigs/ert/medic/chest.dmi'
/obj/item/clothing/shoes/magboots/rig/ert/medical
	icon = 'icons/clothing/rigs/ert/medic/boots.dmi'
/obj/item/clothing/gloves/rig/ert/medical
	icon = 'icons/clothing/rigs/ert/medic/gloves.dmi'

/obj/item/rig/ert/security
	name = "emergency response security hardsuit control module"
	desc = "A hardsuit used by many corporate and governmental emergency response forces. Has red highlights. Armoured and space ready."
	suit_type = "emergency response security"
	icon = 'icons/clothing/rigs/ert/security/rig.dmi'
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/cooling_unit
		)

	chest =  /obj/item/clothing/suit/space/rig/ert/security
	helmet = /obj/item/clothing/head/helmet/space/rig/ert/security
	boots =  /obj/item/clothing/shoes/magboots/rig/ert/security
	gloves = /obj/item/clothing/gloves/rig/ert/security

/obj/item/clothing/head/helmet/space/rig/ert/security
	icon = 'icons/clothing/rigs/ert/security/helmet.dmi'
/obj/item/clothing/suit/space/rig/ert/security
	icon = 'icons/clothing/rigs/ert/security/chest.dmi'
/obj/item/clothing/shoes/magboots/rig/ert/security
	icon = 'icons/clothing/rigs/ert/security/boots.dmi'
/obj/item/clothing/gloves/rig/ert/security
	icon = 'icons/clothing/rigs/ert/security/gloves.dmi'

/obj/item/rig/ert/assetprotection
	name = "heavy emergency response suit control module"
	desc = "A heavy, modified version of a common emergency response hardsuit. Has blood red highlights.  Armoured and space ready."
	suit_type = "heavy emergency response"
	icon = 'icons/clothing/rigs/ert/asset_protection/rig.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_VERY_HIGH,
		ARMOR_BULLET = ARMOR_BALLISTIC_RESISTANT,
		ARMOR_LASER = ARMOR_LASER_MAJOR,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_SHIELDED
		)

	chest =  /obj/item/clothing/suit/space/rig/ert/assetprotection
	helmet = /obj/item/clothing/head/helmet/space/rig/ert/assetprotection
	boots =  /obj/item/clothing/shoes/magboots/rig/ert/assetprotection
	gloves = /obj/item/clothing/gloves/rig/ert/assetprotection

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/clothing/head/helmet/space/rig/ert/assetprotection
	icon = 'icons/clothing/rigs/ert/asset_protection/helmet.dmi'
/obj/item/clothing/suit/space/rig/ert/assetprotection
	icon = 'icons/clothing/rigs/ert/asset_protection/chest.dmi'
/obj/item/clothing/shoes/magboots/rig/ert/assetprotection
	icon = 'icons/clothing/rigs/ert/asset_protection/boots.dmi'
/obj/item/clothing/gloves/rig/ert/assetprotection
	icon = 'icons/clothing/rigs/ert/asset_protection/gloves.dmi'
	siemens_coefficient = 0
