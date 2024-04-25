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
	result = /decl/material/liquid/nutriment/soup/stock
	items = list(/obj/item/chems/food/butchery)
	completion_message = "The liquid darkens to a rich brown as the meat dissolves."

/decl/recipe/soup/stock/meat/get_result_data(atom/container, list/used_ingredients)
	. = list()
	var/list/meat_names = list()
	for(var/obj/item/chems/food/butchery/meat in used_ingredients["items"])
		if(meat.meat_name)
			meat_names[meat.meat_name]++
	if(length(meat_names))
		.["soup_ingredients"] = meat_names.Copy()
	.["soup_flags"] = SOUP_CARNIVORE

/decl/recipe/soup/stock/vegetable
	display_name = "vegetable stock"
	result = /decl/material/liquid/nutriment/soup/stock
	items = list(/obj/item/chems/food/grown)
	completion_message = "The liquid darkens to a rich brown as the vegetable matter dissolves."

/decl/recipe/soup/stock/vegetable/get_result_data(atom/container, list/used_ingredients)
	. = list()
	var/list/veg_names = used_ingredients["fruits"]
	if(islist(veg_names))
		veg_names = veg_names.Copy()
	else
		veg_names = list()
	for(var/obj/item/chems/food/grown/veg in used_ingredients["items"])
		veg_names[veg.name]++
	if(length(veg_names))
		.["soup_ingredients"] = veg_names.Copy()
	.["soup_flags"] = SOUP_VEGETARIAN

/decl/recipe/soup/stock/bone
	display_name = "bone broth"
	result = /decl/material/liquid/nutriment/soup/stock
	items = list(/obj/item/stack/material/bone = 3)
	completion_message = "The liquid darkens to a rich brown as the marrow dissolves."

/decl/recipe/soup/stock/bone/get_result_data(atom/container, list/used_ingredients)
	. = list()
	.["soup_ingredients"] = list("marrow" = 1)
	.["soup_flags"] = SOUP_CARNIVORE
