/decl/material/liquid/nutriment/soup
	name                 = "abstract soup"
	abstract_type        = /decl/material/liquid/nutriment/soup
	nutriment_factor     = 4
	hydration_factor     = 5 // Per removed amount each tick
	glass_name           = "soup"
	opacity              = 0.9
	melting_point        = T0C // We assume soup is water-based by default and so it freezes at 0C.
	boiling_point        = null // It kind of sucks for your soup to boil away honestly
	var/mask_name_suffix = "soup"

/decl/material/liquid/nutriment/soup/initialize_data(list/newdata)
	. = ..()
	var/list/ingredients = LAZYACCESS(., DATA_INGREDIENT_LIST)
	if(length(ingredients))
		ingredients = sortTim(ingredients, /proc/cmp_numeric_dsc, associative = TRUE)
		LAZYSET(., DATA_INGREDIENT_LIST, ingredients)
		var/list/name_ingredients = ingredients.Copy()
		if(length(name_ingredients) > 3)
			name_ingredients.Cut(4)
		if(!(DATA_MASK_NAME in .))
			.[DATA_MASK_NAME] = "[english_list(name_ingredients)] [mask_name_suffix]"

/decl/material/liquid/nutriment/soup/mix_data(var/datum/reagents/reagents, var/list/newdata, var/newamount)

	var/allergen_flags = ALLERGEN_NONE
	var/list/ingredients = list()
	var/new_fraction = newamount / REAGENT_VOLUME(reagents, type) // the fraction of the total reagent volume that the new data is associated with
	var/old_fraction = 1 - new_fraction

	. = ..()
	if(islist(.) && length(.))
		allergen_flags |= .[DATA_INGREDIENT_FLAGS]
		var/list/old_ingredients = .[DATA_INGREDIENT_LIST]
		for(var/ingredient in old_ingredients)
			ingredients[ingredient] += old_ingredients[ingredient] * old_fraction

	if(islist(newdata) && length(newdata))
		allergen_flags |= newdata[DATA_INGREDIENT_FLAGS]
		var/list/new_ingredients = newdata[DATA_INGREDIENT_LIST]
		for(var/ingredient in new_ingredients)
			ingredients[ingredient] += new_ingredients[ingredient] * new_fraction

	if(length(ingredients))
		ingredients = sortTim(ingredients, /proc/cmp_numeric_dsc, associative = TRUE)
		LAZYSET(., DATA_INGREDIENT_LIST, ingredients)
		var/list/name_ingredients = ingredients.Copy()
		if(length(name_ingredients) > 3)
			name_ingredients.Cut(4)
		if(allergen_flags & ALLERGEN_DAIRY) // TODO: check ALLEGEN_CHEESE for cheese-based soups
			LAZYSET(., DATA_MASK_NAME, "[english_list(name_ingredients)] cream [mask_name_suffix]")
		else
			LAZYSET(., DATA_MASK_NAME, "[english_list(name_ingredients)] [mask_name_suffix]")
	else
		LAZYREMOVE(., DATA_MASK_NAME)

	if(allergen_flags)
		LAZYSET(., DATA_INGREDIENT_FLAGS, allergen_flags)
	else
		LAZYREMOVE(., DATA_INGREDIENT_FLAGS)

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
	name                 = "soup"
	liquid_name          = "soup"
	solid_name           = "powdered soup"
	uid                  = "liquid_soup_simple"
	mask_name_suffix     = "soup"
	nutriment_factor     = 10

/decl/material/liquid/nutriment/soup/simple/meatball
	uid                  = "liquid_soup_meatball"
	reagent_overlay      = "soup_meatballs"
	reagent_overlay_base = "reagent_base_chunky"

/decl/material/liquid/nutriment/soup/stew
	name                 = "stew"
	liquid_name          = "stew"
	solid_name           = "powdered stew"
	uid                  = "liquid_soup_stew"
	mask_name_suffix     = "stew"
	reagent_overlay      = "soup_chunks"
	nutriment_factor     = 10
	glass_name           = "stew"
	reagent_overlay_base = "reagent_base_chunky"
	opacity              = 1

/decl/material/liquid/nutriment/soup/chili
	name                 = "chili"
	liquid_name          = "chili"
	solid_name           = "powdered chili"
	uid                  = "liquid_soup_chili"
	mask_name_suffix     = "chili"
	reagent_overlay      = "decoration_chili"
	glass_name           = "chili"
	nutriment_factor     = 10
	reagent_overlay_base = "reagent_base_chunky"
	opacity              = 1

/decl/material/liquid/nutriment/soup/curry
	name                 = "curry"
	liquid_name          = "curry"
	solid_name           = "curry powder"
	uid                  = "liquid_soup_curry"
	mask_name_suffix     = "curry"
	reagent_overlay      = "soup_dumplings"
	glass_name           = "curry"
	nutriment_factor     = 10
	opacity              = 1
