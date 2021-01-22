//Security
/obj/item/clothing/suit/storage/jacket/nt/security
	name = "security jacket"
	desc = "A security guard jacket."
	icon = 'mods/content/military/icons/overwear/security_guard_jacket.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS
	allowed = list(/obj/item/tank/emergency,/obj/item/flashlight,/obj/item/gun/energy,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/baton,/obj/item/handcuffs,/obj/item/taperecorder)
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR
		)

/obj/item/clothing/suit/storage/toggle/labcoat/nt/security/forensic
	name = "forensic coat"
	desc = "A forensic technician coat."
	icon = 'mods/content/military/icons/overwear/security_forensic_coat.dmi'

//Science
/obj/item/clothing/suit/storage/toggle/labcoat/nt
	name = "research labcoat"
	desc = "A suit that protects against minor chemical spills."
	icon = 'mods/content/military/icons/overwear/labcoat.dmi'
	blood_overlay_type = "coat"
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS
	allowed = list(/obj/item/scanner/gas,/obj/item/stack/medical,/obj/item/chems/dropper,/obj/item/chems/syringe,/obj/item/chems/hypospray,/obj/item/scanner/health,/obj/item/flashlight/pen,/obj/item/chems/glass/bottle,/obj/item/chems/glass/beaker,/obj/item/chems/pill,/obj/item/storage/pill_bottle,/obj/item/paper)
	armor = list(
		bio = ARMOR_BIO_RESISTANT
		)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)
	markings_icon = "_marking"

/obj/item/clothing/suit/storage/toggle/labcoat/nt/roboticist
	name = "\improper roboticist labcoat"
	markings_color = COLOR_INDIGO

/obj/item/clothing/suit/storage/toggle/labcoat/nt/chief
	name = "\improper chief research officer's labcoat"
	markings_color = COLOR_GOLD 

//Medical
/obj/item/clothing/suit/storage/toggle/labcoat/nt/medical
	name = "medical labcoat"
	desc = "A suit that protects against minor chemical spills and bloodstains."
	icon = 'mods/content/military/icons/overwear/medical_labcoat.dmi'

/obj/item/clothing/suit/storage/toggle/labcoat/nt/medical/chief
	name = "chief medical officer labcoat"
	icon = 'mods/content/military/icons/overwear/medical_labcoat_chief.dmi'
