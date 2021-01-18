
/datum/fabricator_recipe/textiles/armor
	category = "Armor"
	path = /obj/item/clothing/suit/armor/warden

/datum/fabricator_recipe/textiles/armor/hos
	path = /obj/item/clothing/suit/armor/hos
	
/datum/fabricator_recipe/textiles/armor/jensen
	path = /obj/item/clothing/suit/armor/hos/jensen

// Plate carrier plates

/datum/fabricator_recipe/textiles/armor/plate
	category = "Armor - Insert plates"
	path = /obj/item/clothing/accessory/armor/plate

/datum/fabricator_recipe/textiles/armor/plate/medium
	path = /obj/item/clothing/accessory/armor/plate/medium
	
/datum/fabricator_recipe/textiles/armor/plate/tactical
	path = /obj/item/clothing/accessory/armor/plate/tactical

/datum/fabricator_recipe/textiles/armor/plate/merc
	path = /obj/item/clothing/accessory/armor/plate/merc

// Limb armor attachments

/datum/fabricator_recipe/textiles/armor/limb
	category = "Armor - Limb armor"
	path = /obj/item/clothing/accessory/legguards/riot

/datum/fabricator_recipe/textiles/armor/limb/arm_riot
	path = /obj/item/clothing/accessory/armguards/riot

/datum/fabricator_recipe/textiles/armor/limb/arm_merc
	path = /obj/item/clothing/accessory/armguards/merc

/datum/fabricator_recipe/textiles/armor/limb/leg_merc
	path = /obj/item/clothing/accessory/legguards/merc

/datum/fabricator_recipe/textiles/armor/limb/arm_ballistic
	path = /obj/item/clothing/accessory/armguards/ballistic

/datum/fabricator_recipe/textiles/armor/limb/leg_ballistic
	path = /obj/item/clothing/accessory/legguards/ballistic

// Speciality vests and plate carriers

/datum/fabricator_recipe/textiles/armor/vest
	category = "Armor - Vests"
	path = /obj/item/clothing/suit/armor/pcarrier

/datum/fabricator_recipe/textiles/armor/vest/bulletproof
	path = /obj/item/clothing/suit/armor/bulletproof

/datum/fabricator_recipe/textiles/armor/vest/riot
	path = /obj/item/clothing/suit/armor/riot

/datum/fabricator_recipe/textiles/armor/vest/blue
	path = /obj/item/clothing/suit/armor/pcarrier/blue

/datum/fabricator_recipe/textiles/armor/vest/tan
	path = /obj/item/clothing/suit/armor/pcarrier/tan

/datum/fabricator_recipe/textiles/armor/vest/green
	path = /obj/item/clothing/suit/armor/pcarrier/green

// Helmets

/datum/fabricator_recipe/textiles/armor/helmet
	category = "Armor - Helmets"
	path = /obj/item/clothing/head/helmet
	
/datum/fabricator_recipe/textiles/helmet/tactical
	path = /obj/item/clothing/head/helmet/tactical

/datum/fabricator_recipe/textiles/helmet/merc
	path = /obj/item/clothing/head/helmet/merc

/datum/fabricator_recipe/textiles/helmet/riot
	path = /obj/item/clothing/head/helmet/riot

/datum/fabricator_recipe/textiles/helmet/ablative
	path = /obj/item/clothing/head/helmet/ablative

/datum/fabricator_recipe/textiles/helmet/ballistic
	path = /obj/item/clothing/head/helmet/ballistic

/datum/fabricator_recipe/textiles/helmet/swat
	path = /obj/item/clothing/head/helmet/swat

/datum/fabricator_recipe/textiles/helmet/thunderdome
	path = /obj/item/clothing/head/helmet/thunderdome

var/list/melee_mats = list(
	/decl/material/solid/gemstone/diamond = ARMOR_MELEE_SHIELDED,
	/decl/material/solid/metal/plasteel = ARMOR_MELEE_SHIELDED,
	/decl/material/solid/metal/titanium = ARMOR_MELEE_VERY_HIGH,
	/decl/material/solid/metal/steel = ARMOR_MELEE_MAJOR,
	/decl/material/solid/metal/iron = ARMOR_MELEE_KNIVES,
	/decl/material/solid/leather = ARMOR_MELEE_KNIVES,
	/decl/material/solid/plastic = ARMOR_MELEE_SMALL
)

var/list/bullet_mats = list(
	/decl/material/solid/gemstone/diamond = ARMOR_BALLISTIC_AP,
	/decl/material/solid/metal/plasteel = ARMOR_BALLISTIC_RIFLE,
	/decl/material/solid/metal/titanium = ARMOR_BALLISTIC_RESISTANT,
	/decl/material/solid/metal/steel = ARMOR_BALLISTIC_PISTOL,
	/decl/material/solid/metal/iron = ARMOR_BALLISTIC_SMALL,
	/decl/material/solid/leather = ARMOR_BALLISTIC_MINOR,
	/decl/material/solid/plastic = ARMOR_BALLISTIC_MINOR
)
