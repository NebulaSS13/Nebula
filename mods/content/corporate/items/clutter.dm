/obj/item/toy/balloon/nanotrasen
	name = "\improper 'motivational' balloon"
	desc = "Man, I love NanoTrasen soooo much. I use only NanoTrasen products. You have NO idea."
	icon_state = "ntballoon"
	item_state = "ntballoon"

/obj/item/lunchbox/dais
	name = "\improper DAIS brand lunchbox"
	icon = 'mods/content/corporate/icons/lunchbox_dais.dmi'
	desc = "A little lunchbox. This one is branded with the Deimos Advanced Information Systems logo!"

/obj/item/lunchbox/nt
	name = "\improper NanoTrasen brand lunchbox"
	icon = 'mods/content/corporate/icons/lunchbox_nanotrasen.dmi'
	desc = "A little lunchbox. This one is branded with the NanoTrasen logo!"

/obj/item/lunchbox/nt/filled
	filled = TRUE

/datum/fabricator_recipe/textiles/banner/nanotrasen
	path = /obj/item/banner/nanotrasen

/obj/item/banner/nanotrasen
	name = "\improper NanoTrasen banner"
	hung_desc = "The banner is emblazoned with the NanoTrasen logo."
	desc = "A banner emblazoned with the NanoTrasen logo."
	material_alteration = MAT_FLAG_ALTERATION_NONE
	color = COLOR_NAVY_BLUE
	trim_color = COLOR_GOLD
	decals = list(
		/decl/banner_symbol/nanotrasen = COLOR_WHITE
	)

/obj/structure/banner_frame/nanotrasen
	banner = /obj/item/banner/nanotrasen

/decl/banner_symbol/nanotrasen
	icon       = 'mods/content/corporate/icons/banner_symbols.dmi'
	name       = "NanoTrasen logo"
	icon_state = "nanotrasen"
	uid        = "symbol_corporate_nanotrasen"
