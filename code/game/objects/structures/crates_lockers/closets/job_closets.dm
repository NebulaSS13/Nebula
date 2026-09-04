/* Closets for specific jobs
 * Contains:
 *		Bartender
 *		Janitor
 *		Lawyer
 */

/*
 * Bartender
 */
/obj/structure/closet/gmcloset
	name = "formal closet"
	desc = "It's a storage unit for formal clothing."
	closet_appearance = /decl/closet_appearance/wardrobe/black

/obj/structure/closet/gmcloset/WillContain()
	return list(
		/obj/item/clothing/head/that                   = 2,
		/obj/item/radio/headset/headset_service        = 2,
		/obj/item/clothing/head/hairflower             = 1,
		/obj/item/clothing/head/hairflower/pink        = 1,
		/obj/item/clothing/head/hairflower/yellow      = 1,
		/obj/item/clothing/head/hairflower/blue        = 1,
		/obj/item/clothing/pants/slacks/black          = 2,
		/obj/item/clothing/shirt/button                = 2,
		/obj/item/clothing/pants/formal/black          = 2,
		/obj/item/clothing/shirt/button                = 2,
		/obj/item/clothing/dress/saloon                = 1,
		/obj/item/clothing/suit/jacket/waistcoat/black = 2,
		/obj/item/clothing/shoes/color/black           = 2
	)

/*
 * Chef
 */
/obj/structure/closet/chefcloset
	name = "chef's closet"
	desc = "It's a storage unit for food service garments."
	closet_appearance = /decl/closet_appearance/wardrobe/black

/obj/structure/closet/chefcloset/WillContain()
	return list(
		/obj/item/clothing/dress/sun,
		/obj/item/clothing/pants/slacks/black = 2,
		/obj/item/clothing/shirt/button = 2,
		/obj/item/clothing/neck/tie/bow/red = 2,
		/obj/item/clothing/suit/jacket/vest/blue = 2,
		/obj/item/radio/headset/headset_service = 2,
		/obj/item/box/mousetraps = 2,
		/obj/item/clothing/pants/slacks,
		/obj/item/clothing/shirt/button,
		/obj/item/clothing/head/chefhat
	)

/*
 * Janitor
 */
/obj/structure/closet/jcloset
	name = "custodial closet"
	desc = "It's a storage unit for janitorial clothes and gear."
	closet_appearance = /decl/closet_appearance/wardrobe/mixed

/obj/structure/closet/jcloset/WillContain()
	return list(
		/obj/item/clothing/jumpsuit/janitor,
		/obj/item/radio/headset/headset_service,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/head/soft/purple,
		/obj/item/clothing/head/beret/purple,
		/obj/item/flashlight,
		/obj/item/caution = 4,
		/obj/item/lightreplacer,
		/obj/item/bag/trash,
		/obj/item/clothing/shoes/galoshes,
		/obj/item/soap,
		/obj/item/belt/janitor
	)

/*
 * Lawyer
 */
/obj/structure/closet/lawcloset
	name = "legal closet"
	desc = "It's a storage unit for courtroom apparel and items."
	closet_appearance = /decl/closet_appearance/wardrobe


/obj/structure/closet/lawcloset/WillContain()
	return list(
		/obj/item/clothing/costume/lawyer,
		/obj/item/clothing/costume/lawyer_red,
		/obj/item/clothing/costume/lawyer_bluesuit,
		/obj/item/clothing/pants/slacks/purple,
		/obj/item/clothing/shirt/button,
		/obj/item/clothing/suit/jacket/vest/black,
		/obj/item/clothing/suit/jacket/blue,
		/obj/item/clothing/suit/jacket/purple,
		/obj/item/clothing/shoes/color/brown,
		/obj/item/clothing/shoes/color/black
	)
