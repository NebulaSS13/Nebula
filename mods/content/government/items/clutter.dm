/obj/item/tableflag
	name = "table flag"
	icon = 'mods/content/government/icons/table_flag.dmi'
	icon_state = "tableflag"
	_base_attack_force = 1
	w_class = ITEM_SIZE_SMALL
	attack_verb = "whipped"
	hitsound = 'sound/weapons/towelwhip.ogg'
	desc = "The iconic flag of the Sol Central Government, a symbol with many different meanings."
	material = /decl/material/solid/organic/plastic

/obj/structure/banner_frame/solgov
	banner = /obj/item/banner/solgov

/datum/fabricator_recipe/textiles/banner/solgov
	path = /obj/item/banner/solgov

/obj/item/banner/solgov
	name = "\improper SolGov banner"
	desc = "A banner emblazoned with the solar seal."
	hung_desc = "The banner is emblazoned with a golden SolGov seal."
	material_alteration = MAT_FLAG_ALTERATION_NONE
	color = COLOR_NAVY_BLUE
	trim_color = COLOR_GOLD
	decals = list(
		/decl/banner_symbol/government/sol = COLOR_WHITE
	)

/obj/structure/banner_frame/virgov
	banner = /obj/item/banner/virgov

/datum/fabricator_recipe/textiles/banner/virgov
	path = /obj/item/banner/virgov

/obj/item/banner/virgov
	name = "\improper VirGov banner"
	hung_desc = "The banner is emblazoned with a white VirGov seal."
	desc = "A banner emblazoned with the VirGov seal."
	material_alteration = MAT_FLAG_ALTERATION_NONE
	color = COLOR_NAVY_BLUE
	trim_color = COLOR_GOLD
	decals = list(
		/decl/banner_symbol/government/vir = COLOR_WHITE
	)

/decl/banner_symbol/government
	icon = 'mods/content/government/icons/banner_symbols.dmi'
	abstract_type = /decl/banner_symbol/government

/decl/banner_symbol/government/sol
	name       = "Sol insignia"
	icon_state = "sol"
	uid        = "symbol_government_sol"

/decl/banner_symbol/government/vir
	name       = "Vir insignia"
	icon_state = "vir"
	uid        = "symbol_government_vir"
