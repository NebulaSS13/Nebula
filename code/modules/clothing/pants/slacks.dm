/obj/item/clothing/pants/slacks
	name = "grey slacks"
	desc = "Crisp grey slacks. Moderately formal."
	icon = 'icons/clothing/pants/slacks.dmi'

/obj/item/clothing/pants/slacks/outfit_chef
	starting_accessories = list(
		/obj/item/clothing/shirt/button
	)

/obj/item/clothing/pants/slacks/outfit
	starting_accessories = list(
		/obj/item/clothing/shirt/button,
		/obj/item/clothing/suit/jacket/waistcoat/black
	)

/obj/item/clothing/pants/slacks/outfit/tie
	starting_accessories = list(
		/obj/item/clothing/shirt/button,
		/obj/item/clothing/suit/jacket/waistcoat/black,
		/obj/item/clothing/neck/tie/long/red
	)

/obj/item/clothing/pants/slacks/tan
	name = "tan slacks"
	desc = "Crisp tan slacks. Moderately formal. Careful with the mustard."
	icon = 'icons/clothing/pants/slacks_tan.dmi'

/obj/item/clothing/pants/slacks/tan/outfit
	starting_accessories = list(
		/obj/item/clothing/shirt/button,
		/obj/item/clothing/neck/tie/long/yellow,
		/obj/item/clothing/suit/jacket/tan
	)

/obj/item/clothing/pants/slacks/blue
	name = "blue slacks"
	desc = "Crisp blue slacks. Moderately formal."
	icon = 'icons/clothing/pants/slacks_blue.dmi'

/obj/item/clothing/pants/slacks/security
	name = "security slacks"
	desc = "Dark red, lightly armoured slacks. Moderately formal."
	icon = 'icons/clothing/pants/security.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.9
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_TRACE
	)

/obj/item/clothing/pants/slacks/security/outfit
	starting_accessories = list(
		/obj/item/clothing/shirt/button/security
	)

/obj/item/clothing/pants/slacks/red
	name = "red slacks"
	desc = "Crisp red slacks. Moderately formal."
	icon = 'icons/clothing/pants/slacks_red.dmi'

/obj/item/clothing/pants/slacks/red/blazer_outfit
	starting_accessories = list(
		/obj/item/clothing/shirt/button,
		/obj/item/clothing/neck/tie/navy,
		/obj/item/clothing/suit/jacket/blazer
	)

/obj/item/clothing/pants/slacks/red/outfit
	starting_accessories = list(
		/obj/item/clothing/shirt/button,
		/obj/item/clothing/neck/tie/navy,
		/obj/item/clothing/suit/jacket/charcoal
	)

/obj/item/clothing/pants/slacks/white
	name = "white slacks"
	desc = "Crisp white slacks. Very formal."
	icon = 'icons/clothing/pants/slacks_white.dmi'

/obj/item/clothing/pants/slacks/white/orderly
	name = "orderly's slacks"
	permeability_coefficient = 0.50
	armor = list(
		ARMOR_BIO = ARMOR_BIO_MINOR
	)

/obj/item/clothing/pants/slacks/white/orderly/outfit
	starting_accessories = list(
		/obj/item/clothing/shirt/button/orderly,
		/obj/item/clothing/neck/tie/long/red
	)

/obj/item/clothing/pants/slacks/black
	name = "black slacks"
	desc = "Crisp black slacks. Very formal."
	icon = 'icons/clothing/pants/slacks_black.dmi'

/obj/item/clothing/pants/slacks/black/outfit
	starting_accessories = list(
		/obj/item/clothing/shirt/button,
		/obj/item/clothing/neck/tie/navy,
		/obj/item/clothing/suit/jacket/charcoal
	)

/obj/item/clothing/pants/slacks/black/outfit/navy
	starting_accessories = list(
		/obj/item/clothing/shirt/button,
		/obj/item/clothing/neck/tie/red,
		/obj/item/clothing/suit/jacket/navy
	)

/obj/item/clothing/pants/slacks/black/outfit/burgundy
	starting_accessories = list(
		/obj/item/clothing/shirt/button,
		/obj/item/clothing/neck/tie/black,
		/obj/item/clothing/suit/jacket/burgundy
	)

/obj/item/clothing/pants/slacks/black/outfit/internal_affairs
	starting_accessories = list(
		/obj/item/clothing/shirt/button,
		/obj/item/clothing/neck/tie/black
	)

/obj/item/clothing/pants/slacks/black/outfit/nanotrasen
	starting_accessories = list(
		/obj/item/clothing/shirt/button,
		/obj/item/clothing/neck/tie/long/red
	)

/obj/item/clothing/pants/slacks/black/outfit/checkered
	desc = "That's a very nice suit you have there. Shame if something were to happen to it, eh?"
	starting_accessories = list(
		/obj/item/clothing/shirt/button,
		/obj/item/clothing/neck/tie/black,
		/obj/item/clothing/suit/jacket/checkered
	)

/obj/item/clothing/pants/slacks/purple
	name = "purple slacks"
	desc = "Some whimsical purple slacks. Not very formal."
	icon = 'icons/clothing/pants/slacks_purple.dmi'

/obj/item/clothing/pants/slacks/purple/outfit
	starting_accessories = list(
		/obj/item/clothing/shirt/button,
		/obj/item/clothing/suit/jacket/vest/black
	)

/obj/item/clothing/pants/slacks/navy
	name = "navy slacks"
	desc = "Some formal navy blue slacks."
	icon = 'icons/clothing/pants/slacks_navy.dmi'
