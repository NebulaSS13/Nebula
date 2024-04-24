/decl/recipe/soup
	abstract_type = /decl/recipe/soup
	reagents = list(/decl/material/liquid/water = 10)
	reagent_mix = REAGENT_REPLACE

/decl/recipe/soup/stock
	abstract_type = /decl/recipe/soup/stock
	result_quantity = 10
	minimum_temperature = 100 CELSIUS

/decl/recipe/soup/stock/meat
	display_name = "meat stock"
	result = /decl/material/liquid/nutriment/soup_stock/meat
	items = list(/obj/item/chems/food/butchery)
	completion_message = "The stock darkens to a rich brown as the meat dissolves."

/decl/recipe/soup/stock/meat/get_result_data(atom/container, list/used_ingredients)
	var/list/meat_names = list()
	for(var/obj/item/chems/food/butchery/meat in used_ingredients["items"])
		if(meat.meat_name)
			meat_names[meat.meat_name]++
	if(length(meat_names) == 1)
		return list("mask_name" = "[meat_names[1]] stock")
	return null

/decl/recipe/soup/stock/vegetable
	display_name = "vegetable stock"
	result = /decl/material/liquid/nutriment/soup_stock/vegetable
	items = list(/obj/item/chems/food/grown)
	completion_message = "The stock darkens to a pale brown as the vegetable matter dissolves."

/decl/recipe/soup/stock/vegetable/get_result_data(atom/container, list/used_ingredients)
	var/list/veg_names = used_ingredients["fruits"]
	if(length(veg_names) == 1)
		return list("mask_name" = "[veg_names[1]] stock")
	return null

/decl/recipe/soup/stock/bone
	display_name = "bone broth"
	result = /decl/material/liquid/nutriment/soup_stock/bone
	items = list(/obj/item/stack/material/bone = 3)
	completion_message = "The stock darkens to a pale brown as the marrow dissolves."
