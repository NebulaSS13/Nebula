//Skrell Baseline Suit
/obj/item/rig/skrell
	name = "skrellian recon hardsuit control module"
	desc = "A powerful recon hardsuit with integrated power supply and atmosphere. Its impressive design perfectly tailors to the user's body."
	icon = 'mods/species/bayliens/skrell/icons/rigs/standard/rig.dmi'
	suit_type = "recon hardsuit"
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_RIFLE,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_BOMB = ARMOR_BOMB_RESISTANT,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_SHIELDED
	)
	online_slowdown = 0
	offline_slowdown = 1
	equipment_overlay_icon = null
	air_supply = /obj/item/tank/skrell
	cell = /obj/item/cell/skrell
	chest = /obj/item/clothing/suit/space/rig/skrell
	helmet = /obj/item/clothing/head/helmet/space/rig/skrell
	boots = /obj/item/clothing/shoes/magboots/rig/skrell
	gloves = /obj/item/clothing/gloves/rig/skrell
	allowed = list(
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit
	)
	update_visible_name = TRUE
	initial_modules = list(
		/obj/item/rig_module/vision,
		/obj/item/rig_module/chem_dispenser,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/clustertool/skrell,
		/obj/item/rig_module/cooling_unit
		)
//	req_access = list("ACCESS_SKRELLSCOUT")

/obj/item/clothing/head/helmet/space/rig/skrell
	icon = 'mods/species/bayliens/skrell/icons/rigs/standard/helmet.dmi'
/obj/item/clothing/suit/space/rig/skrell
	icon = 'mods/species/bayliens/skrell/icons/rigs/standard/chest.dmi'
/obj/item/clothing/shoes/magboots/rig/skrell
	icon = 'mods/species/bayliens/skrell/icons/rigs/standard/boots.dmi'
/obj/item/clothing/gloves/rig/skrell
	icon = 'mods/species/bayliens/skrell/icons/rigs/standard/gloves.dmi'
	siemens_coefficient = 0

//Skrell Engineering Suit
/obj/item/rig/skrell/eng
	name = "skrellian engineering hardsuit"
	desc = "A highly sophisticated, cutting-edge engineering hardsuit with an integrated power supply and atmosphere. Its impressive design is resistant yet extremely lightweight, perfectly tailoring itself to the user's body"
	icon = 'mods/species/bayliens/skrell/icons/rigs/engineering/rig.dmi'
	suit_type = "engineering hardsuit"
	chest = /obj/item/clothing/suit/space/rig/skrell/eng
	helmet = /obj/item/clothing/head/helmet/space/rig/skrell/eng
	boots = /obj/item/clothing/shoes/magboots/rig/skrell/eng
	gloves = /obj/item/clothing/gloves/rig/skrell/eng
	initial_modules = list(
		/obj/item/rig_module/vision,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/clustertool/skrell,
		/obj/item/rig_module/device/cable_coil/skrell,
		/obj/item/rig_module/device/multitool/skrell,
		/obj/item/rig_module/device/welder/skrell,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/cooling_unit
	)

/obj/item/clothing/head/helmet/space/rig/skrell/eng
	icon = 'mods/species/bayliens/skrell/icons/rigs/engineering/helmet.dmi'
/obj/item/clothing/suit/space/rig/skrell/eng
	icon = 'mods/species/bayliens/skrell/icons/rigs/engineering/chest.dmi'
/obj/item/clothing/shoes/magboots/rig/skrell/eng
	icon = 'mods/species/bayliens/skrell/icons/rigs/engineering/boots.dmi'
/obj/item/clothing/gloves/rig/skrell/eng
	icon = 'mods/species/bayliens/skrell/icons/rigs/engineering/gloves.dmi'


//Skrell Medical Suit
/obj/item/rig/skrell/med
	name = "skrellian medical hardsuit"
	desc = "A highly sophisticated, cutting-edge medical hardsuit with an integrated power supply and atmosphere. Its impressive design is resistant yet extremely lightweight, perfectly tailoring itself to the user's body"
	icon = 'mods/species/bayliens/skrell/icons/rigs/medical/rig.dmi'
	initial_modules = list(
		/obj/item/rig_module/vision,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/clustertool/skrell,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/device/defib,
		/obj/item/rig_module/vision/medhud,
		/obj/item/rig_module/cooling_unit
	)
	chest = /obj/item/clothing/suit/space/rig/skrell/med
	helmet = /obj/item/clothing/head/helmet/space/rig/skrell/med
	boots = /obj/item/clothing/shoes/magboots/rig/skrell/med
	gloves = /obj/item/clothing/gloves/rig/skrell/med

/obj/item/clothing/head/helmet/space/rig/skrell/med
	icon = 'mods/species/bayliens/skrell/icons/rigs/medical/helmet.dmi'
/obj/item/clothing/suit/space/rig/skrell/med
	icon = 'mods/species/bayliens/skrell/icons/rigs/medical/chest.dmi'
/obj/item/clothing/shoes/magboots/rig/skrell/med
	icon = 'mods/species/bayliens/skrell/icons/rigs/medical/boots.dmi'
/obj/item/clothing/gloves/rig/skrell/med
	icon = 'mods/species/bayliens/skrell/icons/rigs/medical/gloves.dmi'

//Skrell Combat Suit
/obj/item/rig/skrell/sec
	name = "skrellian combat hardsuit"
	desc = "A highly sophisticated, cutting-edge combat hardsuit with an integrated power supply and atmosphere. Its impressive design is resistant yet extremely lightweight, perfectly tailoring itself to the user's body"
	icon = 'mods/species/bayliens/skrell/icons/rigs/combat/rig.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_MAJOR,
		ARMOR_BULLET = ARMOR_BALLISTIC_AP,
		ARMOR_LASER = ARMOR_LASER_RIFLES,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_BOMB = ARMOR_BOMB_RESISTANT,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_SHIELDED
	)
	initial_modules = list(
		/obj/item/rig_module/vision,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/clustertool/skrell,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/cooling_unit
	)
	chest = /obj/item/clothing/suit/space/rig/skrell/sec
	helmet = /obj/item/clothing/head/helmet/space/rig/skrell/sec
	boots = /obj/item/clothing/shoes/magboots/rig/skrell/sec
	gloves = /obj/item/clothing/gloves/rig/skrell/sec

/obj/item/clothing/head/helmet/space/rig/skrell/sec
	icon = 'mods/species/bayliens/skrell/icons/rigs/combat/helmet.dmi'
/obj/item/clothing/suit/space/rig/skrell/sec
	icon = 'mods/species/bayliens/skrell/icons/rigs/combat/chest.dmi'
/obj/item/clothing/shoes/magboots/rig/skrell/sec
	icon = 'mods/species/bayliens/skrell/icons/rigs/combat/boots.dmi'
/obj/item/clothing/gloves/rig/skrell/sec
	icon = 'mods/species/bayliens/skrell/icons/rigs/combat/gloves.dmi'

//Skrell Command Suit
/obj/item/rig/skrell/cmd
	name = "skrellian command hardsuit"
	desc = "A highly sophisticated, cutting-edge hardsuit with an integrated power supply and atmosphere. Its impressive design is resistant yet extremely lightweight, perfectly tailoring itself to the user's body. Property of the Qrii'Vuxix"
	icon = 'mods/species/bayliens/skrell/icons/rigs/command/rig.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_MAJOR,
		ARMOR_BULLET = ARMOR_BALLISTIC_AP,
		ARMOR_LASER = ARMOR_LASER_RIFLES,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_BOMB = ARMOR_BOMB_RESISTANT,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_SHIELDED
	)
	initial_modules = list(
		/obj/item/rig_module/vision,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/clustertool/skrell,
		/obj/item/rig_module/device/flash/advanced,
		/obj/item/rig_module/cooling_unit
	)
	chest = /obj/item/clothing/suit/space/rig/skrell/cmd
	helmet = /obj/item/clothing/head/helmet/space/rig/skrell/cmd
	boots = /obj/item/clothing/shoes/magboots/rig/skrell/cmd
	gloves = /obj/item/clothing/gloves/rig/skrell/cmd

/obj/item/clothing/head/helmet/space/rig/skrell/cmd
	icon = 'mods/species/bayliens/skrell/icons/rigs/command/helmet.dmi'
/obj/item/clothing/suit/space/rig/skrell/cmd
	icon = 'mods/species/bayliens/skrell/icons/rigs/command/chest.dmi'
/obj/item/clothing/shoes/magboots/rig/skrell/cmd
	icon = 'mods/species/bayliens/skrell/icons/rigs/command/boots.dmi'
/obj/item/clothing/gloves/rig/skrell/cmd
	icon = 'mods/species/bayliens/skrell/icons/rigs/command/gloves.dmi'

/obj/item/rig_module/device/clustertool/skrell
	name = "skrellian clustertool"
	desc = "A complex assembly of self-guiding, modular heads capable of performing most manual tasks."
	interface_name = "modular clustertool"
	interface_desc = "A complex assembly of self-guiding, modular heads capable of performing most manual tasks."
	icon = 'mods/species/bayliens/skrell/icons/gear/gear_rig.dmi'
	icon_state = "clustertool"
	engage_string = "Select Mode"
	device = /obj/item/clustertool
	usable = TRUE
	selectable = TRUE

/obj/item/rig_module/device/clustertool/skrell/get_tool_quality(archetype)
	return device?.get_tool_quality(archetype)

/obj/item/rig_module/device/clustertool/skrell/get_tool_speed(archetype)
	return device?.get_tool_speed(archetype)


/obj/item/rig_module/device/multitool/skrell
	name = "skrellian integrated multitool"
	desc = "A limited-sentience integrated multitool capable of interfacing with any number of systems."
	interface_name = "multitool"
	interface_desc = "A limited-sentience integrated multitool capable of interfacing with any number of systems."
	device = /obj/item/multitool/
	icon = 'mods/species/bayliens/skrell/icons/gear/gear_rig.dmi'
	icon_state = "multitool"
	usable = FALSE
	selectable = TRUE

/obj/item/rig_module/device/multitool/skrell/get_tool_quality(archetype)
	return device?.get_tool_quality(archetype)

/obj/item/rig_module/device/multitool/skrell/get_tool_speed(archetype)
	return device?.get_tool_speed(archetype)

/obj/item/rig_module/device/cable_coil/skrell
	name = "skrellian cable extruder"
	desc = "A cable nanofabricator of Skrellian design."
	interface_name = "cable fabricator"
	interface_desc = "A cable nanofabricator of Skrellian design."
	device = /obj/item/stack/cable_coil/fabricator
	icon = 'mods/species/bayliens/skrell/icons/gear/gear_rig.dmi'
	icon_state = "cablecoil"
	usable = FALSE
	selectable = TRUE

/obj/item/rig_module/device/welder/skrell
	name = "skrellian welding arm"
	desc = "An electrical cutting torch of Skrellian design."
	interface_name = "welding arm"
	interface_desc = "An electrical cutting torch of Skrellian design."
	icon = 'mods/species/bayliens/skrell/icons/gear/gear_rig.dmi'
	icon_state = "welder1"
	engage_string = "Toggle Welder"
	device = /obj/item/weldingtool/electric/
	usable = TRUE
	selectable = TRUE