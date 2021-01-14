/obj/item/rig/ert
	name = "emergency response command hardsuit control module"
	desc = "A hardsuit used by many corporate and governmental emergency response forces. Has blue highlights. Armoured and space ready."
	suit_type = "emergency response command"
	icon = 'mods/content/corporate/icons/rigs/commander/rig.dmi'

	chest =  /obj/item/clothing/suit/space/rig/ert
	helmet = /obj/item/clothing/head/helmet/space/rig/ert
	boots =  /obj/item/clothing/shoes/magboots/rig/ert
	gloves = /obj/item/clothing/gloves/rig/ert

	req_access = list(access_cent_specops)

	armor = list(
		melee = ARMOR_MELEE_MAJOR, 
		bullet = ARMOR_BALLISTIC_RESISTANT, 
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_MINOR, 
		bomb = ARMOR_BOMB_PADDED, 
		bio = ARMOR_BIO_SHIELDED, 
		rad = ARMOR_RAD_SHIELDED
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
		/obj/item/storage/briefcase/inflatable,
		/obj/item/baton,
		/obj/item/gun,
		/obj/item/storage/firstaid,
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
	light_overlay = "helmet_light_dual"
	camera = /obj/machinery/camera/network/ert
	icon = 'mods/content/corporate/icons/rigs/commander/helmet.dmi'
/obj/item/clothing/suit/space/rig/ert
	icon = 'mods/content/corporate/icons/rigs/commander/chest.dmi'
/obj/item/clothing/shoes/magboots/rig/ert
	icon = 'mods/content/corporate/icons/rigs/commander/boots.dmi'
/obj/item/clothing/gloves/rig/ert
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_NOCUFFS
	icon = 'mods/content/corporate/icons/rigs/commander/gloves.dmi'

/obj/item/rig/ert/engineer
	name = "emergency response engineering hardsuit control module"
	desc = "A hardsuit used by many corporate and governmental emergency response forces. Has orange highlights. Armoured and space ready."
	suit_type = "emergency response engineer"
	icon = 'mods/content/corporate/icons/rigs/engineer/rig.dmi'

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
	icon = 'mods/content/corporate/icons/rigs/engineer/helmet.dmi'
/obj/item/clothing/suit/space/rig/ert/engineer
	icon = 'mods/content/corporate/icons/rigs/engineer/chest.dmi'
/obj/item/clothing/shoes/magboots/rig/ert/engineer
	icon = 'mods/content/corporate/icons/rigs/engineer/boots.dmi'
/obj/item/clothing/gloves/rig/ert/engineer
	icon = 'mods/content/corporate/icons/rigs/engineer/gloves.dmi'
	siemens_coefficient = 0

/obj/item/rig/ert/janitor
	name = "emergency response sanitation hardsuit control module"
	desc = "A hardsuit used by many corporate and governmental emergency response forces. Has purple highlights. Armoured and space ready."
	suit_type = "emergency response sanitation"
	icon = 'mods/content/corporate/icons/rigs/janitor/rig.dmi'

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
	icon = 'mods/content/corporate/icons/rigs/janitor/helmet.dmi'
/obj/item/clothing/suit/space/rig/ert/janitor
	icon = 'mods/content/corporate/icons/rigs/janitor/chest.dmi'
/obj/item/clothing/shoes/magboots/rig/ert/janitor
	icon = 'mods/content/corporate/icons/rigs/janitor/boots.dmi'
/obj/item/clothing/gloves/rig/ert/janitor
	icon = 'mods/content/corporate/icons/rigs/janitor/gloves.dmi'

/obj/item/rig/ert/medical
	name = "emergency response medical hardsuit control module"
	desc = "A hardsuit used by many corporate and governmental emergency response forces. Has white highlights. Armoured and space ready."
	suit_type = "emergency response medic"
	icon = 'mods/content/corporate/icons/rigs/medic/rig.dmi'

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
	icon = 'mods/content/corporate/icons/rigs/medic/helmet.dmi'
/obj/item/clothing/suit/space/rig/ert/medical
	icon = 'mods/content/corporate/icons/rigs/medic/chest.dmi'
/obj/item/clothing/shoes/magboots/rig/ert/medical
	icon = 'mods/content/corporate/icons/rigs/medic/boots.dmi'
/obj/item/clothing/gloves/rig/ert/medical
	icon = 'mods/content/corporate/icons/rigs/medic/gloves.dmi'

/obj/item/rig/ert/security
	name = "emergency response security hardsuit control module"
	desc = "A hardsuit used by many corporate and governmental emergency response forces. Has red highlights. Armoured and space ready."
	suit_type = "emergency response security"
	icon = 'mods/content/corporate/icons/rigs/security/rig.dmi'
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
	icon = 'mods/content/corporate/icons/rigs/security/helmet.dmi'
/obj/item/clothing/suit/space/rig/ert/security
	icon = 'mods/content/corporate/icons/rigs/security/chest.dmi'
/obj/item/clothing/shoes/magboots/rig/ert/security
	icon = 'mods/content/corporate/icons/rigs/security/boots.dmi'
/obj/item/clothing/gloves/rig/ert/security
	icon = 'mods/content/corporate/icons/rigs/security/gloves.dmi'

/obj/item/rig/ert/assetprotection
	name = "heavy emergency response suit control module"
	desc = "A heavy, modified version of a common emergency response hardsuit. Has blood red highlights.  Armoured and space ready."
	suit_type = "heavy emergency response"
	icon = 'mods/content/corporate/icons/rigs/asset_protection/rig.dmi'
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH, 
		bullet = ARMOR_BALLISTIC_RESISTANT, 
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_MINOR, 
		bomb = ARMOR_BOMB_PADDED, 
		bio = ARMOR_BIO_SHIELDED, 
		rad = ARMOR_RAD_SHIELDED
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
	icon = 'mods/content/corporate/icons/rigs/asset_protection/helmet.dmi'
/obj/item/clothing/suit/space/rig/ert/assetprotection
	icon = 'mods/content/corporate/icons/rigs/asset_protection/chest.dmi'
/obj/item/clothing/shoes/magboots/rig/ert/assetprotection
	icon = 'mods/content/corporate/icons/rigs/asset_protection/boots.dmi'
/obj/item/clothing/gloves/rig/ert/assetprotection
	icon = 'mods/content/corporate/icons/rigs/asset_protection/gloves.dmi'
	siemens_coefficient = 0
