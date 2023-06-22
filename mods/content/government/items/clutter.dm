/obj/item/tableflag
	name = "table flag"
	icon = 'mods/content/government/icons/table_flag.dmi'
	icon_state = "tableflag"
	force = 0.5
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("whipped")
	hitsound = 'sound/weapons/towelwhip.ogg'
	desc = "The iconic flag of the Sol Central Government, a symbol with many different meanings."
	material = /decl/material/solid/plastic

/obj/structure/banner_frame/solgov
	banner = /obj/item/banner/solgov

/datum/fabricator_recipe/textiles/banner/solgov
	path = /obj/item/banner/solgov

/obj/item/banner/solgov
	name = "\improper SolGov banner"
	desc = "A banner emblazoned with the solar seal."
	icon = 'mods/content/government/icons/banner.dmi'
	hung_desc = "The banner is emblazoned with a golden SolGov seal."
	material_alteration = MAT_FLAG_ALTERATION_NONE
	color = COLOR_NAVY_BLUE
	decals = list(
		"banner_trim" =   COLOR_GOLD,
		"banner_solgov" = COLOR_WHITE
	)

/obj/structure/banner_frame/virgov
	banner = /obj/item/banner/virgov

/datum/fabricator_recipe/textiles/banner/virgov
	path = /obj/item/banner/virgov

/obj/item/banner/virgov
	name = "\improper VirGov banner"
	hung_desc = "The banner is emblazoned with a white VirGov seal."
	desc = "A banner emblazoned with the VirGov seal."
	icon = 'mods/content/government/icons/banner.dmi'
	material_alteration = MAT_FLAG_ALTERATION_NONE
	color = COLOR_NAVY_BLUE
	decals = list(
		"banner_trim" =   COLOR_GOLD,
		"banner_virgov" = COLOR_WHITE
	)
