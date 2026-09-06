/decl/loadout_category/hands
	name = "Handwear"

/decl/loadout_option/gloves
	cost = 2
	slot = slot_gloves_str
	category = /decl/loadout_category/hands
	abstract_type = /decl/loadout_option/gloves

/decl/loadout_option/gloves/colored
	name = "gloves, colored"
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	path = /obj/item/clothing/gloves
	uid = "gear_gloves_color"

/decl/loadout_option/gloves/evening
	name = "gloves, evening, color select"
	path = /obj/item/clothing/gloves/evening
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_gloves_evening"

/decl/loadout_option/ring
	name = "ring"
	path = /obj/item/clothing/gloves/ring
	cost = 2
	uid = "gear_gloves_ring"
	var/list/available_materials = list(
		/decl/material/solid/metal/steel,
		/decl/material/solid/metal/bronze,
		/decl/material/solid/metal/silver,
		/decl/material/solid/metal/gold,
		/decl/material/solid/metal/platinum,
		/decl/material/solid/glass,
		/decl/material/solid/organic/plastic,
		/decl/material/solid/organic/wood/oak,
		/decl/material/solid/organic/wood/bamboo,
		/decl/material/solid/organic/wood/ebony,
		/decl/material/solid/organic/wood/mahogany,
		/decl/material/solid/organic/wood/maple,
		/decl/material/solid/organic/wood/walnut,
		/decl/material/solid/organic/wood/yew
	)

/decl/loadout_option/ring/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"ring"            = /obj/item/clothing/gloves/ring/gold,
		"ring, thin"      = /obj/item/clothing/gloves/ring/thin,
		"ring, thick"     = /obj/item/clothing/gloves/ring/thick,
		"ring, split"     = /obj/item/clothing/gloves/ring/split,
		"engagement ring" = /obj/item/clothing/gloves/ring/engagement,
		"signet ring"     = /obj/item/clothing/gloves/ring/seal/signet,
		"masonic ring"    = /obj/item/clothing/gloves/ring/seal/mason
	)
	if(length(available_materials))
		for(var/mat in available_materials)
			var/decl/material/mat_decl = GET_DECL(mat)
			available_materials -= mat
			available_materials[mat_decl.name] = mat
		LAZYINITLIST(.[/datum/gear_tweak/material])
		.[/datum/gear_tweak/material] = available_materials
