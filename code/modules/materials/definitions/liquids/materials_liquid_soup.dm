/decl/material/liquid/nutriment/soup
	name                 = "abstract soup"
	abstract_type        = /decl/material/liquid/nutriment/soup
	nutriment_factor     = 4
	hydration_factor     = 5 // Per removed amount each tick
	glass_name           = "soup"
	var/mask_name_suffix = "soup"

/decl/material/liquid/nutriment/soup/get_presentation_name(var/obj/item/prop)
	if(prop?.reagents?.reagent_data)
		. = prop.reagents.reagent_data["mask_name"]
	return . || ..()

/decl/material/liquid/nutriment/soup/initialize_data(var/newdata)
	var/list/ingredients = LAZYACCESS(newdata, "soup_ingredients")
	if(length(ingredients))
		ingredients = sortTim(ingredients, /proc/cmp_numeric_dsc, associative = TRUE)
		LAZYSET(newdata, "soup_ingredients", ingredients)
		var/list/name_ingredients = ingredients.Copy()
		if(length(name_ingredients) > 3)
			name_ingredients.Cut(4)
		newdata["mask_name"] = "[english_list(name_ingredients)] [mask_name_suffix]"
	return newdata

/decl/material/liquid/nutriment/soup/mix_data(var/datum/reagents/reagents, var/list/newdata, var/newamount)

	var/soup_flags = INGREDIENT_FLAG_PLAIN
	var/list/ingredients = list()

	. = ..()
	if(islist(.) && length(.))
		soup_flags |= .["soup_flags"]
		var/list/old_ingredients = .["soup_ingredients"]
		for(var/ingredient in old_ingredients)
			ingredients[ingredient] += old_ingredients[ingredient]

	if(islist(newdata) && length(newdata))
		soup_flags |= newdata["soup_flags"]
		var/list/new_ingredients = newdata["soup_ingredients"]
		for(var/ingredient in new_ingredients)
			ingredients[ingredient] += new_ingredients[ingredient]

	if(length(ingredients))
		ingredients = sortTim(ingredients, /proc/cmp_numeric_dsc, associative = TRUE)
		LAZYSET(., "soup_ingredients", ingredients)
		var/list/name_ingredients = ingredients.Copy()
		if(length(name_ingredients) > 3)
			name_ingredients.Cut(4)
		LAZYSET(., "mask_name", "[english_list(name_ingredients)] [mask_name_suffix]")
	else
		LAZYREMOVE(., "mask_name")

	if(soup_flags)
		LAZYSET(., "soup_flags", soup_flags)
	else
		LAZYREMOVE(., "soup_flags")

/decl/material/liquid/nutriment/soup/stock
	name              = "broth"
	codex_name        = "simple broth"
	uid               = "liquid_soup_broth"
	solid_name        = "stock"
	color             = "#8a7452"
	mask_name_suffix  = "broth"
	taste_description = "salty, savoury flavours"
	taste_mult        = 1
	nutriment_factor  = 5
	glass_name        = "broth"

/decl/material/liquid/nutriment/soup/stock/bone
	name              = "bone broth"
	uid               = "liquid_soup_stock_bone"
	liquid_name       = "bone broth"
	solid_name        = "powdered bone broth"
	color             = "#c0b067"
	mask_name_suffix  = "broth"
	taste_description = "salty, savoury flavours"

/decl/material/liquid/nutriment/soup/simple
	name              = "soup"
	liquid_name       = "soup"
	solid_name        = "powdered soup"
	uid               = "liquid_soup_simple"
	mask_name_suffix  = "soup"
	reagent_overlay   = "soup_meatballs"
	nutriment_factor  = 10

/decl/material/liquid/nutriment/soup/stew
	name             = "stew"
	liquid_name      = "stew"
	solid_name       = "powdered stew"
	uid              = "liquid_soup_stew"
	mask_name_suffix = "stew"
	reagent_overlay  = "soup_chunks"
	nutriment_factor = 10
	glass_name       = "stew"
