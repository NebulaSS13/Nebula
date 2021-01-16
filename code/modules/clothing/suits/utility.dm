/*
 * Contains:
 *		Fire protection
 *		Bomb protection
 *		Radiation protection
 */

/*
 * Fire protection
 */

/obj/item/clothing/suit/fire
	name = "firesuit"
	desc = "A suit that protects against fire and heat."
	icon = 'icons/clothing/suit/firesuit.dmi'
	w_class = ITEM_SIZE_LARGE//large item
	flags_inv = HIDETAIL

	body_parts_covered = SLOT_UPPER_BODY | SLOT_LOWER_BODY| SLOT_ARMS
	armor = list(laser = ARMOR_LASER_MINOR, energy = ARMOR_ENERGY_MINOR, bomb = ARMOR_BOMB_MINOR)
	allowed = list(/obj/item/flashlight,/obj/item/tank/emergency,/obj/item/extinguisher,/obj/item/clothing/head/hardhat)
	
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50

	heat_protection = SLOT_UPPER_BODY | SLOT_LOWER_BODY | SLOT_ARMS
	cold_protection = SLOT_UPPER_BODY | SLOT_LOWER_BODY | SLOT_ARMS

	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT
	)
	origin_tech = "{'materials':2,'engineering':2}"

/obj/item/clothing/suit/fire/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 0.5)

/*
 * Bomb protection
 */
/obj/item/clothing/head/bomb_hood
	name = "bomb hood"
	desc = "Use in case of bomb."
	icon = 'icons/clothing/head/bombsuit.dmi'
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH, 
		bullet = ARMOR_BALLISTIC_MINOR, 
		laser = ARMOR_LASER_SMALL, 
		energy = ARMOR_ENERGY_RESISTANT, 
		bomb = ARMOR_BOMB_SHIELDED
		)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES
	siemens_coefficient = 0

/obj/item/clothing/suit/bomb_suit
	name = "bomb suit"
	desc = "A suit designed for safety when handling explosives."
	icon = 'icons/clothing/suit/bombsuit.dmi'
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH, 
		bullet = ARMOR_BALLISTIC_MINOR, 
		laser = ARMOR_LASER_SMALL, 
		energy = ARMOR_ENERGY_RESISTANT, 
		bomb = ARMOR_BOMB_SHIELDED
		)
	flags_inv = HIDEJUMPSUIT|HIDETAIL
	heat_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/suit/bomb_suit/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 2)

/obj/item/clothing/head/bomb_hood/security
	body_parts_covered = SLOT_HEAD
	icon = 'icons/clothing/head/bombsuit_olive.dmi'

/obj/item/clothing/suit/bomb_suit/security
	icon = 'icons/clothing/suit/bombsuit_olive.dmi'
	allowed = list(/obj/item/gun/energy,/obj/item/baton,/obj/item/handcuffs)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS

/*
 * Radiation protection
 */
/obj/item/clothing/head/radiation
	name = "radiation hood"
	desc = "A hood with radiation protective properties. Label: Made with lead, do not eat insulation."
	icon = 'icons/clothing/head/radsuit.dmi'
	flags_inv = BLOCKHAIR
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES
	armor = list(
		bio = ARMOR_BIO_RESISTANT, 
		rad = ARMOR_RAD_SHIELDED
		)
	matter = list(
		/decl/material/solid/plastic = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT
	)

	origin_tech = "{'materials':2,'engineering':2}"

/obj/item/clothing/suit/radiation
	name = "radiation suit"
	desc = "A suit that protects against radiation. Label: Made with lead, do not eat insulation."
	icon = 'icons/clothing/suit/rad_suit.dmi'
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS|SLOT_HANDS|SLOT_FEET
	allowed = list(/obj/item/flashlight,/obj/item/tank/emergency,/obj/item/clothing/head/radiation,/obj/item/clothing/mask/gas,/obj/item/geiger)
	armor = list(
		bio = ARMOR_BIO_RESISTANT, 
		rad = ARMOR_RAD_SHIELDED
		)
	flags_inv = HIDEJUMPSUIT|HIDETAIL|HIDEGLOVES|HIDESHOES
	matter = list(
		/decl/material/solid/plastic = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT
	)
	origin_tech = "{'materials':2,'engineering':2}"

/obj/item/clothing/suit/radiation/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_shoes_str, 1.5)

/*
 * chemical protection
 */

/obj/item/clothing/head/chem_hood
	name = "chemical hood"
	desc = "A hood that protects the head from chemical comtaminants."
	icon = 'icons/clothing/head/chem_hood.dmi'
	permeability_coefficient = 0
	armor = list(
		bio = ARMOR_BIO_RESISTANT, 
		rad = ARMOR_RAD_MINOR
		)
	flags_inv = HIDEEARS|HIDEEYES|BLOCKHAIR
	item_flags = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = SLOT_HEAD
	siemens_coefficient = 0.9
	matter = list(
		/decl/material/solid/plastic = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT
	)
	origin_tech = "{'materials':2,'engineering':2}"

/obj/item/clothing/suit/chem_suit
	name = "chemical suit"
	desc = "A suit that protects against chemical contamination."
	icon = 'icons/clothing/suit/chem_suit.dmi'
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0
	permeability_coefficient = 0
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS
	allowed = list(/obj/item/tank/emergency,/obj/item/pen,/obj/item/flashlight/pen,/obj/item/scanner/health,/obj/item/ano_scanner,/obj/item/clothing/head/chem_hood,/obj/item/clothing/mask/gas,/obj/item/geiger)
	armor = list(
		bio = ARMOR_BIO_RESISTANT, 
		rad = ARMOR_RAD_MINOR
		)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	item_flags = ITEM_FLAG_THICKMATERIAL
	siemens_coefficient = 0.9
	matter = list(
		/decl/material/solid/plastic = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT
	)
	origin_tech = "{'materials':2,'engineering':2}"
