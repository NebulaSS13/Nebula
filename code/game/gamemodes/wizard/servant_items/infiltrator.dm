/obj/item/clothing/head/infilhat
	name = "immaculate fedora"
	desc = "Whoever owns this hat means business. Hopefully, it's just good business."
	color = COLOR_SILVER
	icon = 'icons/clothing/head/detective.dmi'
	markings_state_modifier = "band"
	markings_color = COLOR_DARK_GRAY
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_MINOR,
		ARMOR_BULLET = ARMOR_BALLISTIC_MINOR,
		ARMOR_LASER = ARMOR_LASER_MINOR,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR
		)
	bodytype_equip_flags = BODY_FLAG_HUMANOID

/obj/item/clothing/suit/infilsuit
	name = "immaculate suit"
	desc = "The clothes of an impeccable diplomat. Or perhaps a businessman. Let's not consider the horrors that might arise if it belongs to a lawyer."
	icon = 'icons/clothing/suits/wizard/servant/inf_suit.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_MINOR,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_MINOR,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR
		)

/obj/item/clothing/shoes/dress/infilshoes
	name = "black leather shoes"
	desc = "Dress shoes. Their footsteps are dead silent."
	inset_color = COLOR_INDIGO
	item_flags = ITEM_FLAG_SILENT

/obj/item/clothing/head/infilhat/fem
	name = "maid's headband"
	desc = "This dainty, frilled thing is apparently meant to go on your head."
	icon = 'icons/clothing/head/inf_hat.dmi'
	markings_state_modifier = null

/obj/item/clothing/suit/infilsuit/fem
	name = "maid's uniform"
	desc = "The uniform of someone you'd expect to see dusting off the Antique Gun's display case."
	icon = 'icons/clothing/suits/wizard/servant/inf_dress.dmi'
