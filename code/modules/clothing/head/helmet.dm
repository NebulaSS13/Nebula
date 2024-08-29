/obj/item/clothing/head/helmet
	name = "helmet"
	desc = "Reinforced headgear. Protects the head from impacts."
	icon = 'icons/clothing/head/armor/helmet.dmi'
	valid_accessory_slots = list(ACCESSORY_SLOT_HELM_C)
	restricted_accessory_slots = list(ACCESSORY_SLOT_HELM_C)
	item_flags = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = SLOT_HEAD
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_RESISTANT,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_SMALL,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	flags_inv = HIDEEARS|BLOCK_HEAD_HAIR
	cold_protection = SLOT_HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = SLOT_HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = ITEM_SIZE_NORMAL
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/metal/plasteel = MATTER_AMOUNT_TRACE)
	origin_tech = @'{"materials":1,"engineering":1,"combat":1}'
	protects_against_weather = TRUE
	replaced_in_loadout = FALSE
	_base_attack_force = 8

/obj/item/clothing/head/helmet/tactical
	name = "tactical helmet"
	desc = "A tan helmet made from advanced ceramic. Comfortable and robust."
	icon = 'icons/clothing/head/armor/tactical.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_MAJOR,
		ARMOR_BULLET = ARMOR_BALLISTIC_RIFLE,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	siemens_coefficient = 0.6
	material = /decl/material/solid/metal/plasteel
	origin_tech = @'{"materials":2,"engineering":2,"combat":2}'

/obj/item/clothing/head/helmet/merc
	name = "combat helmet"
	desc = "A heavily reinforced helmet painted with red markings. Feels like it could take a lot of punishment."
	icon = 'icons/clothing/head/armor/merc.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_VERY_HIGH,
		ARMOR_BULLET = ARMOR_BALLISTIC_RIFLE,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	siemens_coefficient = 0.5
	material = /decl/material/solid/metal/plasteel
	matter = list(/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_REINFORCEMENT)
	origin_tech = @'{"materials":2,"engineering":2,"combat":2}'

/obj/item/clothing/head/helmet/riot
	name = "riot helmet"
	desc = "It's a helmet specifically designed to protect against close range attacks."
	icon = 'icons/clothing/head/armor/riot.dmi'
	valid_accessory_slots = null
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES //face shield
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_VERY_HIGH,
		ARMOR_BULLET = ARMOR_BALLISTIC_MINOR
		)
	siemens_coefficient = 0.7
	action_button_name = "Toggle Visor"
	var/up = 0
	matter = list(/decl/material/solid/organic/cloth = MATTER_AMOUNT_SECONDARY)

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

/obj/item/clothing/head/helmet/riot/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && up && check_state_in_icon("[overlay.icon_state]_up", overlay.icon))
		overlay.icon_state = "[overlay.icon_state]_up"
	. = ..()

/obj/item/clothing/head/helmet/ablative
	name = "ablative helmet"
	desc = "A helmet made from advanced materials which protects against concentrated energy weapons."
	icon = 'icons/clothing/head/armor/reflective.dmi'
	valid_accessory_slots = null
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_SMALL,
		ARMOR_BULLET = ARMOR_BALLISTIC_MINOR,
		ARMOR_LASER = ARMOR_LASER_RIFLES,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT
		)
	siemens_coefficient = 0
	matter = list(/decl/material/solid/metal/plasteel = MATTER_AMOUNT_TRACE)

/obj/item/clothing/head/helmet/ballistic
	name = "ballistic helmet"
	desc = "A helmet with reinforced plating to protect against ballistic projectiles."
	icon = 'icons/clothing/head/armor/bulletproof.dmi'
	valid_accessory_slots = null
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_MINOR,
		ARMOR_BULLET = ARMOR_BALLISTIC_AP,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	siemens_coefficient = 0.7
	material = /decl/material/solid/metal/plasteel
	matter = list(
		/decl/material/solid/metal/titanium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
		)
	origin_tech = @'{"materials":3,"engineering":2,"combat":3}'

/obj/item/clothing/head/helmet/swat
	name = "\improper SWAT helmet"
	desc = "They're often used by highly trained Swat Members."
	icon = 'icons/clothing/head/armor/merc.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_VERY_HIGH,
		ARMOR_BULLET = ARMOR_BALLISTIC_RESISTANT,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	cold_protection = SLOT_HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5
	material = /decl/material/solid/metal/plasteel
	matter = list(/decl/material/solid/metal/titanium = MATTER_AMOUNT_REINFORCEMENT)
	origin_tech = @'{"materials":4,"engineering":2,"combat":4}'

/obj/item/clothing/head/helmet/thunderdome
	name = "\improper Thunderdome helmet"
	desc = "<i>'Let the battle commence!'</i>"
	icon = 'icons/clothing/head/armor/thunderdome.dmi'
	valid_accessory_slots = null
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_VERY_HIGH,
		ARMOR_BULLET = ARMOR_BALLISTIC_RESISTANT,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	cold_protection = SLOT_HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 1
	material = /decl/material/solid/metal/plasteel
	matter = list(/decl/material/solid/metal/titanium = MATTER_AMOUNT_REINFORCEMENT)
	origin_tech = @'{"materials":4,"engineering":2,"combat":4}'

/obj/item/clothing/head/helmet/gladiator
	name = "gladiator helmet"
	desc = "Ave, Imperator, morituri te salutant."
	icon = 'icons/clothing/head/armor/gladiator.dmi'
	valid_accessory_slots = null
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCK_HEAD_HAIR
	body_parts_covered = SLOT_HEAD|SLOT_FACE
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/augment
	name = "augment array"
	desc = "A helmet with optical and cranial augments coupled to it."
	icon = 'icons/clothing/head/armor/augment.dmi'
	valid_accessory_slots = null
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_VERY_HIGH,
		ARMOR_BULLET = ARMOR_BALLISTIC_RESISTANT,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	flags_inv = HIDEEARS|HIDEEYES|BLOCK_HEAD_HAIR
	body_parts_covered = SLOT_HEAD|SLOT_EYES
	cold_protection = SLOT_HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5
	matter = list(/decl/material/solid/metal/plasteel = MATTER_AMOUNT_REINFORCEMENT)
