//Pouches
/obj/item/clothing/accessory/storage/pouches
	name = "storage pouches"
	desc = "A collection of black pouches that can be attached to a plate carrier. Carries up to two items."
	icon_override = 'icons/mob/onmob/onmob_modular_armor.dmi'
	icon = 'icons/obj/clothing/obj_suit_modular_armor.dmi'
	accessory_icons = list(slot_tie_str = 'icons/mob/onmob/onmob_modular_armor.dmi', slot_wear_suit_str = 'icons/mob/onmob/onmob_modular_armor.dmi')
	icon_state = "pouches"
	color = COLOR_GRAY40
	gender = PLURAL
	slot = ACCESSORY_SLOT_ARMOR_S
	slots = 2

/obj/item/clothing/accessory/storage/pouches/large
	name = "large storage pouches"
	desc = "A collection of black pouches that can be attached to a plate carrier. Carries up to four items."
	icon_state = "lpouches"
	slots = 4
	slowdown = 1

/obj/item/clothing/accessory/storage/pouches/large/tan
	color = COLOR_TAN

//Armor plates
/obj/item/clothing/accessory/armorplate
	name = "light armor plate"
	desc = "A basic armor plate made of steel-reinforced synthetic fibers. Attaches to a plate carrier."
	icon = 'icons/obj/clothing/obj_suit_modular_armor.dmi'
	icon_state = "armor_light"
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR
		)
	slot = ACCESSORY_SLOT_ARMOR_C

/obj/item/clothing/accessory/armorplate/get_fibers()
	return null	//plates do not shed

/obj/item/clothing/accessory/armorplate/medium
	name = "medium armor plate"
	desc = "A plasteel-reinforced synthetic armor plate, providing good protection. Attaches to a plate carrier."
	icon_state = "armor_medium"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
		)

/obj/item/clothing/accessory/armorplate/tactical
	name = "tactical armor plate"
	desc = "A heavier armor plate with additional ablative coating. Attaches to a plate carrier."
	icon_state = "armor_tactical"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
		)
	slowdown = 0.5


//Arm guards
/obj/item/clothing/accessory/armguards
	name = "arm guards"
	desc = "A pair of black arm pads reinforced with armor plating. Attaches to a plate carrier."
	icon_override = 'icons/mob/onmob/onmob_modular_armor.dmi'
	icon = 'icons/obj/clothing/obj_suit_modular_armor.dmi'
	accessory_icons = list(slot_tie_str = 'icons/mob/onmob/onmob_modular_armor.dmi', slot_wear_suit_str = 'icons/mob/onmob/onmob_modular_armor.dmi')
	icon_state = "armguards"
	color = COLOR_GRAY40
	gender = PLURAL
	body_parts_covered = SLOT_ARMS
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
		)
	slot = ACCESSORY_SLOT_ARMOR_A
	material = /decl/material/solid/metal/steel
	origin_tech = "{'materials':1,'engineering':1,'combat':1}"

/obj/item/clothing/accessory/armguards/craftable
	material_armor_multiplier = 1
	applies_material_colour = TRUE
	applies_material_name = TRUE

//Leg guards
/obj/item/clothing/accessory/legguards
	name = "leg guards"
	desc = "A pair of armored leg pads in black. Attaches to a plate carrier."
	icon_override = 'icons/mob/onmob/onmob_modular_armor.dmi'
	icon = 'icons/obj/clothing/obj_suit_modular_armor.dmi'
	accessory_icons = list(slot_tie_str = 'icons/mob/onmob/onmob_modular_armor.dmi', slot_wear_suit_str = 'icons/mob/onmob/onmob_modular_armor.dmi')
	icon_state = "legguards"
	color = COLOR_GRAY40
	gender = PLURAL
	body_parts_covered = SLOT_LEGS
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
		)
	slot = ACCESSORY_SLOT_ARMOR_L
	material = /decl/material/solid/metal/steel
	origin_tech = "{'materials':1,'engineering':1,'combat':1}"

/obj/item/clothing/accessory/legguards/craftable
	material_armor_multiplier = 1
	applies_material_colour = TRUE
	applies_material_name =  TRUE

//Decorative attachments
/obj/item/clothing/accessory/armor/tag
	name = "master armor tag"
	desc = "A collection of various tags for placing on the front of a plate carrier."
	icon_override = 'icons/mob/onmob/onmob_modular_armor.dmi'
	icon = 'icons/obj/clothing/obj_suit_modular_armor.dmi'
	accessory_icons = list(slot_tie_str = 'icons/mob/onmob/onmob_modular_armor.dmi', slot_wear_suit_str = 'icons/mob/onmob/onmob_modular_armor.dmi')
	icon_state = "null"
	slot = ACCESSORY_SLOT_ARMOR_M
	w_class = ITEM_SIZE_TINY

/obj/item/clothing/accessory/armor/tag/press
	name = "\improper PRESS tag"
	desc = "A tag with the word PRESS printed in white lettering on it."
	icon_state = "smalltag"
	slot_flags = SLOT_LOWER_BODY

/obj/item/clothing/accessory/armor/tag/warden
	name = "\improper WARDEN tag"
	desc = "A tag with the word WARDEN printed in silver lettering on it."
	icon_state = "largetag"

/obj/item/clothing/accessory/armor/tag/hos
	name = "\improper COMMANDER tag"
	desc = "A tag with the word COMMANDER printed in golden lettering on it."
	icon_state = "largetag"
	color = COLOR_GOLD

/obj/item/clothing/accessory/armor/tag/oneg
	name = "\improper O- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as O NEGATIVE."
	icon_state = "onegtag"

/obj/item/clothing/accessory/armor/tag/apos
	name = "\improper A+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as A POSITIVE."
	icon_state = "apostag"

/obj/item/clothing/accessory/armor/tag/aneg
	name = "\improper A- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as A NEGATIVE."
	icon_state = "anegtag"

/obj/item/clothing/accessory/armor/tag/bpos
	name = "\improper B+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as B POSITIVE."
	icon_state = "bpostag"

/obj/item/clothing/accessory/armor/tag/bneg
	name = "\improper B- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as B NEGATIVE."
	icon_state = "bnegtag"

/obj/item/clothing/accessory/armor/tag/abpos
	name = "\improper AB+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as AB POSITIVE."
	icon_state = "abpostag"

/obj/item/clothing/accessory/armor/tag/abneg
	name = "\improper AB- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as AB NEGATIVE."
	icon_state = "abnegtag"

/obj/item/clothing/accessory/armor/helmcover
	name = "helmet cover"
	desc = "A fabric cover for armored helmets."
	icon_override = 'icons/mob/onmob/onmob_modular_armor.dmi'
	icon = 'icons/obj/clothing/obj_suit_modular_armor.dmi'
	accessory_icons = list(slot_tie_str = 'icons/mob/onmob/onmob_modular_armor.dmi', slot_head_str = 'icons/mob/onmob/onmob_modular_armor.dmi')
	icon_state = "helmcover"
	slot = ACCESSORY_SLOT_HELM_C

/obj/item/clothing/accessory/armor/helmcover/blue
	color = COLOR_SKY_BLUE

/obj/item/clothing/accessory/armor/helmcover/green
	color = COLOR_DARK_GREEN_GRAY

/obj/item/clothing/accessory/armor/helmcover/tan
	color = COLOR_TAN

