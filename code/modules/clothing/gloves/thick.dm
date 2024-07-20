/obj/item/clothing/gloves/thick
	name = "work gloves"
	desc = "These work gloves are thick and fire-resistant."
	siemens_coefficient = 0.50
	permeability_coefficient = 0.05
	item_flags = ITEM_FLAG_THICKMATERIAL
	cold_protection = SLOT_HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = SLOT_HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	color = COLOR_GRAY20
	icon = 'icons/clothing/hands/gloves_thick.dmi'
	icon_state = ICON_STATE_WORLD
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_SMALL,
		ARMOR_BOMB = ARMOR_BOMB_RESISTANT,
		ARMOR_BIO = ARMOR_BIO_MINOR)
	material = /decl/material/solid/organic/leather
	replaced_in_loadout = FALSE

/obj/item/clothing/gloves/thick/swat
	desc = "These tactical gloves are somewhat fire and impact-resistant."
	name = "\improper SWAT Gloves"

/obj/item/clothing/gloves/thick/combat //Combined effect of SWAT gloves and insulated gloves
	desc = "These tactical gloves are somewhat fire and impact resistant."
	name = "combat gloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_SECONDARY,
	)

/obj/item/clothing/gloves/thick/botany
	desc = "These work gloves protect against thorns, barbs, prickles, spikes and other harmful objects of floral origin."
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME

/obj/item/clothing/gloves/thick/botany/on_update_icon()
	. = ..()
	add_overlay(overlay_image(icon, "[icon_state]-botany_fingertips", flags = RESET_COLOR))

/obj/item/clothing/gloves/thick/botany/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && slot == slot_gloves_str)
		var/image/I = image(overlay.icon, "[overlay.icon_state]-botany_fingertips")
		I.appearance_flags |= RESET_COLOR
		overlay.overlays += I
	return ..()

/obj/item/clothing/gloves/thick/duty
	desc = "These brown duty gloves are made from a durable synthetic."
	color = COLOR_BEASTY_BROWN
	material = /decl/material/solid/organic/leather

/obj/item/clothing/gloves/thick/craftable
	name = "gauntlets"
	desc = "Made to be thrown at scoundrels. Pretty heavy."
	icon = 'icons/clothing/hands/gauntlets.dmi'
	material = /decl/material/solid/metal/steel
	material_armor_multiplier = 1
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME

/obj/item/clothing/gloves/thick/craftable/set_material(var/new_material)
	..()
	if(material.conductive)
		siemens_coefficient = 1
	if(material.is_brittle())
		item_flags &= ~ITEM_FLAG_THICKMATERIAL