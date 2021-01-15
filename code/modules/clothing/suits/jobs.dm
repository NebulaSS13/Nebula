/*
 * Job related
 */

//Botanist
/obj/item/clothing/suit/apron
	name = "apron"
	desc = "A basic blue apron."
	icon = 'icons/clothing/suit/apron.dmi'
	blood_overlay_type = "armor"
	body_parts_covered = 0
	bodytype_restricted = null
	allowed = list (/obj/item/chems/spray/plantbgone,/obj/item/scanner/plant,/obj/item/seeds,/obj/item/chems/glass/bottle,/obj/item/minihoe)

//Captain
/obj/item/clothing/suit/captunic
	name = "captain's parade tunic"
	desc = "Worn by a Captain to show their class."
	icon = 'icons/clothing/suit/cap_tunic.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/captunic/capjacket
	name = "captain's uniform jacket"
	desc = "A less formal jacket for everyday captain use."
	icon = 'icons/clothing/suit/cap_jacket.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	flags_inv = 0

//Chaplain
/obj/item/clothing/suit/chaplain_hoodie
	name = "chaplain hoodie"
	desc = "This suit says to you 'hush'!"
	icon = 'icons/clothing/suit/chaplain.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS

//Chaplain
/obj/item/clothing/suit/nun
	name = "nun robe"
	desc = "Maximum piety in this star system."
	icon = 'icons/clothing/suit/nun.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	flags_inv = HIDESHOES|HIDEJUMPSUIT

//Chef
/obj/item/clothing/suit/chef
	name = "chef's apron"
	desc = "An apron used by a high class chef."
	icon = 'icons/clothing/suit/chef.dmi'
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	allowed = list (/obj/item/knife)

//Chef
/obj/item/clothing/suit/chef/classic
	name = "classic chef's apron"
	desc = "A basic, dull, white chef's apron."
	icon = 'icons/clothing/suit/apron_chef.dmi'
	bodytype_restricted = null
	blood_overlay_type = "armor"
	body_parts_covered = 0

//Detective
/obj/item/clothing/suit/storage/det_trench
	name = "brown trenchcoat"
	desc = "A rugged canvas trenchcoat, designed and created by TX Fabrication Corp. The coat is externally impact resistant - perfect for your next act of autodefenestration!"
	icon = 'icons/clothing/suit/detective_brown.dmi'
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	blood_overlay_type = "coat"
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS
	allowed = list(/obj/item/tank/emergency,/obj/item/flashlight,/obj/item/gun/energy,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/baton,/obj/item/handcuffs,/obj/item/storage/fancy/cigarettes,/obj/item/flame/lighter,/obj/item/taperecorder)
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR
		)
	origin_tech = "{'materials':2, 'engineering':2}"
	matter = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/clothing/suit/storage/det_trench/ft/
	desc = "A rugged canvas trenchcoat, designed and created by TX Fabrication Corp. This one wouldn't block much of anything."
	armor = null

/obj/item/clothing/suit/storage/det_trench/grey
	name = "grey trenchcoat"
	icon = 'icons/clothing/suit/detective_grey.dmi'

//Forensics
/obj/item/clothing/suit/storage/forensics
	name = "jacket"
	desc = "A forensics technician jacket."
	icon = 'icons/clothing/suit/forensic_red.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS
	allowed = list(/obj/item/tank/emergency,/obj/item/flashlight,/obj/item/gun/energy,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/baton,/obj/item/handcuffs,/obj/item/taperecorder)
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR
		)
	origin_tech = "{'materials':2, 'engineering':2}"
	matter = list(/decl/material/solid/metal/silver = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/clothing/suit/storage/forensics/red
	name = "red jacket"
	desc = "A red forensics technician jacket."

/obj/item/clothing/suit/storage/forensics/blue
	name = "blue jacket"
	desc = "A blue forensics technician jacket."
	icon = 'icons/clothing/suit/forensic_blue.dmi'

//Engineering
/obj/item/clothing/suit/storage/hazardvest
	name = "hazard vest"
	desc = "A high-visibility vest used in work zones."
	icon = 'icons/clothing/suit/hazard_vest/orange.dmi'
	blood_overlay_type = "armor"
	bodytype_restricted = null
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
		/obj/item/taperoll/engineering
	)
	body_parts_covered = SLOT_UPPER_BODY

/obj/item/clothing/suit/storage/hazardvest/green
	name = "green hazard vest"
	desc = "A high-visibility vest used in work zones. This one is green!"
	icon = 'icons/clothing/suit/hazard_vest/green.dmi'

//Lawyer
/obj/item/clothing/suit/storage/toggle/suit
	name = "suit jacket"
	desc = "A snappy dress jacket."
	icon = 'icons/clothing/suit/suit_jacket.dmi'
	blood_overlay_type = "coat"
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS

/obj/item/clothing/suit/storage/toggle/suit/blue
	name = "blue suit jacket"
	color = "#00326e"

/obj/item/clothing/suit/storage/toggle/suit/purple
	name = "purple suit jacket"
	color = "#6c316c"

/obj/item/clothing/suit/storage/toggle/suit/black
	name = "black suit jacket"
	color = "#1f1f1f"

//Medical
/obj/item/clothing/suit/storage/toggle/fr_jacket
	name = "first responder jacket"
	desc = "A high-visibility jacket worn by medical first responders."
	icon = 'icons/clothing/suit/responder_jacket.dmi'
	blood_overlay_type = "armor"
	allowed = list(
		/obj/item/stack/medical,
		/obj/item/chems/dropper,
		/obj/item/chems/hypospray,
		/obj/item/chems/syringe,
		/obj/item/scanner/health,
		/obj/item/flashlight,
		/obj/item/radio,
		/obj/item/tank/emergency,
		/obj/item/chems/ivbag
	)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS

/obj/item/clothing/suit/storage/toggle/fr_jacket/ems
	name = "\improper EMS jacket"
	desc = "A dark blue, martian-pattern, EMS jacket. It sports high-visibility reflective stripes and a star of life on the back."
	icon = 'icons/clothing/suit/emt_jacket.dmi'

/obj/item/clothing/suit/storage/medical_chest_rig
	name = "\improper MT chest-rig"
	desc = "A black chest-rig with blue pouches worn by medical first responders, meant to carry their equipment. It has a blue 'Medic' tag on its chest."
	icon = 'icons/clothing/suit/med_chest.dmi'
	blood_overlay_type = "armor"
	allowed = list(
		/obj/item/stack/medical,
		/obj/item/chems/dropper,
		/obj/item/chems/hypospray,
		/obj/item/chems/syringe,
		/obj/item/scanner/health, 
		/obj/item/flashlight,
		/obj/item/radio,
		/obj/item/tank/emergency,
		/obj/item/chems/ivbag,
		/obj/item/clothing/head/hardhat/EMS
	)
	body_parts_covered = SLOT_UPPER_BODY

/obj/item/clothing/suit/surgicalapron
	name = "surgical apron"
	desc = "A sterile blue apron for performing surgery."
	icon = 'icons/clothing/suit/apron_surgery.dmi'
	blood_overlay_type = "armor"
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY
	allowed = list(
		/obj/item/stack/medical,
		/obj/item/chems/dropper,
		/obj/item/chems/hypospray,
		/obj/item/chems/syringe,
		/obj/item/scanner/health,
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
