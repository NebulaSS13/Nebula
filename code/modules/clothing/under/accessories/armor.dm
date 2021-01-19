//Pouches
/obj/item/clothing/accessory/storage/pouches
	name = "storage pouches"
	desc = "A collection of black pouches that can be attached to a plate carrier. Carries up to two items."
	icon = 'icons/clothing/accessories/pouches/pouches.dmi'
	icon_state = ICON_STATE_WORLD
	color = COLOR_GRAY40
	gender = PLURAL
	slot = ACCESSORY_SLOT_ARMOR_S
	slots = 2

/obj/item/clothing/accessory/storage/pouches/large
	name = "large storage pouches"
	desc = "A collection of black pouches that can be attached to a plate carrier. Carries up to four items."
	icon = 'icons/clothing/accessories/pouches/lpouches.dmi'
	slots = 4
	slowdown = 1

/obj/item/clothing/accessory/storage/pouches/large/tan
	color = COLOR_TAN

//Armor plates
/obj/item/clothing/accessory/armor/plate
	name = "light armor plate"
	desc = "A basic armor plate made of steel-reinforced synthetic fibers. Attaches to a plate carrier."
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR
		)
	slot = ACCESSORY_SLOT_ARMOR_C

/obj/item/clothing/accessory/armor/plate/get_fibers()
	return null	//plates do not shed

/obj/item/clothing/accessory/armor/plate/medium
	name = "medium armor plate"
	desc = "A plasteel-reinforced synthetic armor plate, providing good protection. Attaches to a plate carrier."
	icon = 'icons/clothing/accessories/armor/armor_medium.dmi'
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/accessory/armor/plate/tactical
	name = "tactical armor plate"
	desc = "A heavier armor plate with additional ablative coating. Attaches to a plate carrier."
	icon = 'icons/clothing/accessories/armor/armor_tactical.dmi'
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
	icon = 'icons/clothing/accessories/armor/armguards.dmi'
	icon_state = ICON_STATE_WORLD
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
	icon = 'icons/clothing/accessories/armor/legguards.dmi'
	icon_state = ICON_STATE_WORLD
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

/obj/item/clothing/accessory/armor
	name = "master armor"
	icon = 'icons/clothing/accessories/tags/tag_small.dmi'
	icon_state = ICON_STATE_WORLD

//Decorative attachments
/obj/item/clothing/accessory/armor/tag
	name = "\improper WARDEN tag"
	desc = "A tag with the word WARDEN printed in silver lettering on it."
	icon = 'icons/clothing/accessories/tags/tag_large.dmi'
	slot = ACCESSORY_SLOT_ARMOR_M

/obj/item/clothing/accessory/armor/tag/press
	name = "\improper PRESS tag"
	desc = "A tag with the word PRESS printed in white lettering on it."
	slot_flags = SLOT_LOWER_BODY

/obj/item/clothing/accessory/armor/tag/hos
	name = "\improper COMMANDER tag"
	desc = "A tag with the word COMMANDER printed in golden lettering on it."
	color = COLOR_GOLD

/obj/item/clothing/accessory/armor/tag/oneg
	name = "\improper O- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as O NEGATIVE."
	icon = 'icons/clothing/accessories/tags/tag_oneg.dmi'

/obj/item/clothing/accessory/armor/tag/opos
	name = "\improper O+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as O POSITIVE."
	icon = 'icons/clothing/accessories/tags/tag_opos.dmi'

/obj/item/clothing/accessory/armor/tag/apos
	name = "\improper A+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as A POSITIVE."
	icon = 'icons/clothing/accessories/tags/tag_apos.dmi'

/obj/item/clothing/accessory/armor/tag/aneg
	name = "\improper A- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as A NEGATIVE."
	icon = 'icons/clothing/accessories/tags/tag_aneg.dmi'

/obj/item/clothing/accessory/armor/tag/bpos
	name = "\improper B+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as B POSITIVE."
	icon = 'icons/clothing/accessories/tags/tag_bpos.dmi'

/obj/item/clothing/accessory/armor/tag/bneg
	name = "\improper B- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as B NEGATIVE."
	icon = 'icons/clothing/accessories/tags/tag_bneg.dmi'

/obj/item/clothing/accessory/armor/tag/abpos
	name = "\improper AB+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as AB POSITIVE."
	icon = 'icons/clothing/accessories/tags/tag_abpos.dmi'

/obj/item/clothing/accessory/armor/tag/abneg
	name = "\improper AB- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as AB NEGATIVE."
	icon = 'icons/clothing/accessories/tags/tag_abneg.dmi'

/obj/item/clothing/accessory/armor/helmcover
	name = "helmet cover"
	desc = "A fabric cover for armored helmets."
	icon = 'icons/clothing/accessories/armor/helmcover.dmi'
	icon_state = ICON_STATE_WORLD
	slot = ACCESSORY_SLOT_HELM_C

/obj/item/clothing/accessory/armor/helmcover/blue
	color = COLOR_SKY_BLUE

/obj/item/clothing/accessory/armor/helmcover/green
	color = COLOR_DARK_GREEN_GRAY

/obj/item/clothing/accessory/armor/helmcover/tan
	color = COLOR_TAN

