/decl/material/liquid/nutriment/soup
	name = "abstract soup"
	abstract_type = /decl/material/liquid/nutriment/soup
	var/mask_name_suffix = "soup"

/decl/material/liquid/nutriment/soup/initialize_data(var/newdata)
	var/list/ingredients = LAZYACCESS(newdata, "soup_ingredients")
	if(length(ingredients))
		newdata["mask_name"] = "[english_list(ingredients)] [mask_name_suffix]"
	return newdata

/decl/material/liquid/nutriment/soup/mix_data(var/datum/reagents/reagents, var/list/newdata, var/newamount)

	var/soup_flags = SOUP_PLAIN
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
		LAZYSET(., "mask_name", "[english_list(ingredients)] [mask_name_suffix]")
		LAZYSET(., "soup_ingredients", ingredients)
	else
		LAZYREMOVE(., "mask_name")

	if(soup_flags)
		LAZYSET(., "soup_flags", soup_flags)
	else
		LAZYREMOVE(., "soup_flags")

/decl/material/liquid/nutriment/soup/stock
	name = "stock"
	uid = "liquid_soup_stock"
	mask_name_suffix = "stock"
	solid_name = "powdered stock"
	color = "#8a7452"
	mask_name_suffix = "stock"
	taste_description = "salty, savoury flavours"
	taste_mult = 1

/decl/material/liquid/nutriment/soup/stock/bone
	name = "bone broth"
	uid = "liquid_soup_stock_bone"
	liquid_name = "bone broth"
	solid_name = "powdered bone broth"
	color = "#c0b067"
	mask_name_suffix = "broth"
	taste_description = "salty, savoury flavours"
