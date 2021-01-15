/obj/item/clothing/head/infilhat
	name = "immaculate fedora"
	desc = "Whoever owns this hat means business. Hopefully, it's just good business."
	color = COLOR_SILVER
	icon = 'icons/clothing/head/detective.dmi'
	markings_icon = "band"
	markings_color = COLOR_DARK_GRAY
	armor = list(
		melee = ARMOR_MELEE_MINOR, 
		bullet = ARMOR_BALLISTIC_MINOR, 
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR
		)
	bodytype_restricted = list(BODYTYPE_HUMANOID)

/obj/item/clothing/suit/infilsuit
	name = "immaculate suit"
	desc = "The clothes of an impeccable diplomat. Or perhaps a businessman. Let's not consider the horrors that might arise if it belongs to a lawyer."
	icon = 'icons/clothing/suit/wizard/servant/inf_suit.dmi'
	armor = list(
		melee = ARMOR_MELEE_MINOR, 
		bullet = ARMOR_BALLISTIC_PISTOL, 
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR
		)

/obj/item/clothing/under/lawyer/infil
	name = "formal outfit"
	desc = "A white dress shirt and navy pants. Snazzy."
	icon = 'icons/clothing/under/formal.dmi'
	bodytype_restricted = list(BODYTYPE_HUMANOID)

/obj/item/clothing/shoes/dress/infilshoes
	name = "black leather shoes"
	desc = "Dress shoes. Their footsteps are dead silent."
	inset_color = COLOR_INDIGO
	item_flags = ITEM_FLAG_SILENT

/obj/item/clothing/head/infilhat/fem
	name = "maid's headband"
	desc = "This dainty, frilled thing is apparently meant to go on your head."
	icon = 'icons/clothing/head/inf_hat.dmi'

/obj/item/clothing/suit/infilsuit/fem
	name = "maid's uniform"
	desc = "The uniform of someone you'd expect to see dusting off the Antique Gun's display case."
	icon = 'icons/clothing/suit/wizard/servant/inf_dress.dmi'

/obj/item/clothing/under/lawyer/infil/fem
	name = "white dress"
	desc = "It's a simple, sleeveless white dress with black trim."
	icon = 'icons/clothing/under/dresses/dress_white.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET