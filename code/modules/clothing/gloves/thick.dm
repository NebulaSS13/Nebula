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
	force = 5
	sprite_sheets = null
	armor = list(
		melee = ARMOR_MELEE_RESISTANT, 
		bullet = ARMOR_BALLISTIC_PISTOL, 
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_SMALL, 
		bomb = ARMOR_BOMB_RESISTANT, 
		bio = ARMOR_BIO_MINOR)

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
	applies_material_colour = TRUE
	applies_material_name = TRUE
	material = /decl/material/solid/leather

/obj/item/clothing/gloves/thick/botany/on_update_icon()
	. = ..()
	var/image/I = image(icon, "[icon_state]-botany_fingertips")
	I.appearance_flags |= RESET_COLOR
	overlays = list(I)

/obj/item/clothing/gloves/thick/botany/apply_overlays(var/mob/user_mob, var/bodytype, var/image/overlay, var/slot)
	if(slot == slot_gloves_str)
		var/image/I = image(icon, "[bodytype]-botany_fingertips")
		I.appearance_flags |= RESET_COLOR
		overlay.overlays = list(I)
	. = ..()

/obj/item/clothing/gloves/thick/duty
	desc = "These brown duty gloves are made from a durable synthetic."
	color = COLOR_BEASTY_BROWN
	material = /decl/material/solid/leather

/obj/item/clothing/gloves/thick/craftable
	name = "gauntlets"
	desc = "Made to be thrown at scoundrels. Pretty heavy."
	icon = 'icons/clothing/hands/gauntlets.dmi'
	material = /decl/material/solid/metal/steel
	material_armor_multiplier = 1
	applies_material_colour = TRUE
	applies_material_name = TRUE

/obj/item/clothing/gloves/thick/craftable/set_material(var/new_material)
	..()
	if(material.conductive)
		siemens_coefficient = 1
	if(material.is_brittle())
		item_flags &= ~ITEM_FLAG_THICKMATERIAL