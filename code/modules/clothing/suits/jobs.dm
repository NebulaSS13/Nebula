/*
 * Job related
 */

//Botanist
/obj/item/clothing/suit/apron
	name = "apron"
	desc = "A basic blue apron."
	icon = 'icons/clothing/suits/apron.dmi'
	blood_overlay_type = "armor"
	body_parts_covered = 0
	bodytype_equip_flags = null
	allowed = list (
		/obj/item/chems/spray/plantbgone,
		/obj/item/scanner/plant,
		/obj/item/seeds,
		/obj/item/chems/glass/bottle,
		/obj/item/tool/hoe/mini
	)

/obj/item/clothing/suit/apron/colourable
	desc = "A basic apron, good for protecting your clothes."
	icon = 'icons/clothing/suits/apron_colourable.dmi'
	color = null
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC

//Captain
//Chaplain
/obj/item/clothing/suit/chaplain_hoodie
	name = "chaplain hoodie"
	desc = "This suit says to you 'hush'!"
	icon = 'icons/clothing/suits/chaplain.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS

//Chaplain
/obj/item/clothing/suit/nun
	name = "nun robe"
	desc = "Maximum piety in this star system."
	icon = 'icons/clothing/suits/nun.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	flags_inv = HIDESHOES|HIDEJUMPSUIT

//Chef
/obj/item/clothing/suit/chef
	name = "chef's apron"
	desc = "An apron used by a high class chef."
	icon = 'icons/clothing/suits/chef.dmi'
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	allowed = list (/obj/item/knife)

//Chef
/obj/item/clothing/suit/chef/classic
	name = "classic chef's apron"
	desc = "A basic, dull, white chef's apron."
	icon = 'icons/clothing/suits/apron_chef.dmi'
	bodytype_equip_flags = null
	blood_overlay_type = "armor"
	body_parts_covered = 0

//Detective
/obj/item/clothing/suit/det_trench
	name = "brown trenchcoat"
	desc = "A rugged canvas trenchcoat, designed and created by TX Fabrication Corp. This one wouldn't block much of anything."
	icon = 'icons/clothing/suits/detective_brown.dmi'
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	blood_overlay_type = "coat"
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS
	allowed = list(
		/obj/item/tank/emergency,
		/obj/item/flashlight,
		/obj/item/gun/energy,
		/obj/item/gun/projectile,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/baton,
		/obj/item/handcuffs,
		/obj/item/box/fancy/cigarettes,
		/obj/item/flame/fuelled/lighter,
		/obj/item/taperecorder
	)
	protects_against_weather = TRUE
	storage = /datum/storage/pockets/suit

/obj/item/clothing/suit/det_trench/grey
	name = "grey trenchcoat"
	icon = 'icons/clothing/suits/detective_grey.dmi'

/obj/item/clothing/suit/det_trench/reinforced
	name = "reinforced trenchcoat"
	desc = "A rugged canvas trenchcoat, designed and created by TX Fabrication Corp. The coat is externally impact resistant - perfect for your next act of autodefenestration!"
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_SMALL,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR
		)
	origin_tech = @'{"materials":2, "engineering":2}'
	matter = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT)

//Forensics
/obj/item/clothing/suit/forensics
	name = "jacket"
	desc = "A forensics technician jacket."
	icon = 'icons/clothing/suits/forensic_red.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS
	allowed = list(/obj/item/tank/emergency,/obj/item/flashlight,/obj/item/gun/energy,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/baton,/obj/item/handcuffs,/obj/item/taperecorder)
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_SMALL,
		ARMOR_BULLET = ARMOR_BALLISTIC_MINOR,
		ARMOR_LASER = ARMOR_LASER_MINOR,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR
		)
	origin_tech = @'{"materials":2, "engineering":2}'
	matter = list(/decl/material/solid/metal/silver = MATTER_AMOUNT_REINFORCEMENT)
	storage = /datum/storage/pockets/suit

/obj/item/clothing/suit/forensics/red
	name = "red jacket"
	desc = "A red forensics technician jacket."

/obj/item/clothing/suit/forensics/blue
	name = "blue jacket"
	desc = "A blue forensics technician jacket."
	icon = 'icons/clothing/suits/forensic_blue.dmi'

//Engineering
/obj/item/clothing/suit/hazardvest
	name = "hazard vest"
	desc = "A high-visibility vest used in work zones."
	icon = 'icons/clothing/suits/hazard_vest/orange.dmi'
	blood_overlay_type = "armor"
	bodytype_equip_flags = null
	allowed = list (
		/obj/item/scanner/gas,
		/obj/item/flashlight,
		/obj/item/multitool,
		/obj/item/radio,
		/obj/item/t_scanner,
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/tank/emergency,
		/obj/item/clothing/mask/gas,
		/obj/item/stack/tape_roll/barricade_tape/engineering
	)
	body_parts_covered = SLOT_UPPER_BODY

/obj/item/clothing/suit/hazardvest/green
	name = "green hazard vest"
	desc = "A high-visibility vest used in work zones. This one is green!"
	icon = 'icons/clothing/suits/hazard_vest/green.dmi'

/obj/item/clothing/suit/medical_chest_rig
	name = "\improper MT chest-rig"
	desc = "A black chest-rig with blue pouches worn by medical first responders, meant to carry their equipment. It has a blue 'Medic' tag on its chest."
	icon = 'icons/clothing/suits/med_chest.dmi'
	blood_overlay_type = "armor"
	allowed = list(
		/obj/item/stack/medical,
		/obj/item/chems/dropper,
		/obj/item/chems/hypospray,
		/obj/item/chems/inhaler,
		/obj/item/chems/syringe,
		/obj/item/scanner/health,
		/obj/item/scanner/breath,
		/obj/item/flashlight,
		/obj/item/radio,
		/obj/item/tank/emergency,
		/obj/item/chems/ivbag,
		/obj/item/clothing/head/hardhat/ems
	)
	body_parts_covered = SLOT_UPPER_BODY
	storage = /datum/storage/pockets/suit

/obj/item/clothing/suit/surgicalapron
	name = "surgical apron"
	desc = "A sterile blue apron for performing surgery."
	icon = 'icons/clothing/suits/apron_surgery.dmi'
	blood_overlay_type = "armor"
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY
	allowed = list(
		/obj/item/stack/medical,
		/obj/item/chems/dropper,
		/obj/item/chems/hypospray,
		/obj/item/chems/inhaler,
		/obj/item/chems/syringe,
		/obj/item/scanner/health,
		/obj/item/scanner/breath,
		/obj/item/flashlight,
		/obj/item/radio,
		/obj/item/tank/emergency,
		/obj/item/scalpel,
		/obj/item/retractor,
		/obj/item/hemostat,
		/obj/item/cautery,
		/obj/item/bonegel,
		/obj/item/sutures
	)
