/obj/item/clothing/head/helmet
	name = "helmet"
	desc = "Reinforced headgear. Protects the head from impacts."

	icon = 'icons/clothing/head/armor/helmet.dmi'
	valid_accessory_slots = list(ACCESSORY_SLOT_HELM_C)
	restricted_accessory_slots = list(ACCESSORY_SLOT_HELM_C)
	item_flags = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = SLOT_HEAD
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
		)
	flags_inv = HIDEEARS|BLOCKHEADHAIR
	cold_protection = SLOT_HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = SLOT_HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = ITEM_SIZE_NORMAL
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/metal/plasteel = MATTER_AMOUNT_TRACE)
	origin_tech = "{'materials':2,'engineering':2,'combat':2}"

/obj/item/clothing/head/helmet/tactical
	name = "tactical helmet"
	desc = "A tan helmet made from advanced ceramic. Comfortable and robust."
	icon = 'icons/clothing/head/armor/tactical.dmi'
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
		)
	siemens_coefficient = 0.6
	matter = list(/decl/material/solid/metal/plasteel = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/clothing/head/helmet/merc
	name = "combat helmet"
	desc = "A heavily reinforced helmet painted with red markings. Feels like it could take a lot of punishment."
	icon = 'icons/clothing/head/armor/merc.dmi'
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
		)
	siemens_coefficient = 0.5
	matter = list(/decl/material/solid/metal/plasteel = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/clothing/head/helmet/riot
	name = "riot helmet"
	desc = "It's a helmet specifically designed to protect against close range attacks."
	icon = 'icons/clothing/head/armor/riot.dmi'
	valid_accessory_slots = null
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES //face shield
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_MINOR
		)
	siemens_coefficient = 0.7
	action_button_name = "Toggle Visor"
	var/up = 0
	matter = list(/decl/material/solid/metal/plasteel = MATTER_AMOUNT_TRACE)

/obj/item/clothing/head/helmet/riot/attack_self(mob/user)
	up = !up
	if(up)
		to_chat(user, "You raise the visor on the [src].")
	else
		to_chat(user, "You lower the visor on the [src].")
	update_icon()

/obj/item/clothing/head/helmet/riot/on_update_icon(mob/user)
	. = ..()
	icon_state = get_world_inventory_state()
	if(up && check_state_in_icon("[icon_state]_up", icon))
		icon_state = "[icon_state]_up"
	update_clothing_icon()

/obj/item/clothing/head/helmet/riot/experimental_mob_overlay()
	var/image/ret = ..()
	if(up && check_state_in_icon("[ret.icon_state]_up", icon))
		ret.icon_state = "[ret.icon_state]_up"
	return ret

/obj/item/clothing/head/helmet/ablative
	name = "ablative helmet"
	desc = "A helmet made from advanced materials which protects against concentrated energy weapons."
	icon = 'icons/clothing/head/armor/reflective.dmi'
	valid_accessory_slots = null
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_RIFLES,
		energy = ARMOR_ENERGY_RESISTANT
		)
	siemens_coefficient = 0
	matter = list(/decl/material/solid/metal/plasteel = MATTER_AMOUNT_TRACE)

/obj/item/clothing/head/helmet/ballistic
	name = "ballistic helmet"
	desc = "A helmet with reinforced plating to protect against ballistic projectiles."
	icon = 'icons/clothing/head/armor/bulletproof.dmi'
	valid_accessory_slots = null
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		bullet = ARMOR_BALLISTIC_AP,
		laser = ARMOR_LASER_SMALL,
		bomb = ARMOR_BOMB_PADDED
		)
	siemens_coefficient = 0.7
	matter = list(/decl/material/solid/metal/plasteel = MATTER_AMOUNT_SECONDARY)

/obj/item/clothing/head/helmet/swat
	name = "\improper SWAT helmet"
	desc = "They're often used by highly trained Swat Members."
	icon = 'icons/clothing/head/armor/merc.dmi'
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
		)
	cold_protection = SLOT_HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5
	matter = list(/decl/material/solid/metal/plasteel = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/clothing/head/helmet/thunderdome
	name = "\improper Thunderdome helmet"
	desc = "<i>'Let the battle commence!'</i>"
	icon = 'icons/clothing/head/armor/thunderdome.dmi'
	valid_accessory_slots = null
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
		)
	cold_protection = SLOT_HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 1
	matter = list(/decl/material/solid/metal/plasteel = MATTER_AMOUNT_SECONDARY)

/obj/item/clothing/head/helmet/gladiator
	name = "gladiator helmet"
	desc = "Ave, Imperator, morituri te salutant."
	icon = 'icons/clothing/head/armor/gladiator.dmi'
	valid_accessory_slots = null
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_parts_covered = SLOT_HEAD|SLOT_FACE
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/augment
	name = "Augment Array"
	desc = "A helmet with optical and cranial augments coupled to it."
	icon = 'icons/clothing/head/armor/augment.dmi'
	valid_accessory_slots = null
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
		)
	flags_inv = HIDEEARS|HIDEEYES
	body_parts_covered = SLOT_HEAD|SLOT_EYES|BLOCKHEADHAIR
	cold_protection = SLOT_HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5
	matter = list(/decl/material/solid/metal/plasteel = MATTER_AMOUNT_REINFORCEMENT)
