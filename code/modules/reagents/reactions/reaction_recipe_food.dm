/decl/chemical_reaction/recipe/food
	result = null
	result_amount = 1
	abstract_type = /decl/chemical_reaction/recipe/food
	var/obj_result

/decl/chemical_reaction/recipe/food/on_reaction(datum/reagents/holder, created_volume, reaction_flags, list/reaction_data)
	..()
	var/location = get_turf(holder.get_reaction_loc(chemical_reaction_flags))
	if(obj_result && isturf(location))
		for(var/i = 1, i <= created_volume, i++)
			create_food(location, reaction_data)

/decl/chemical_reaction/recipe/food/proc/create_food(location, list/data)
	var/atom/movable/food = new obj_result
	if(istype(food))
		food.dropInto(location)
	if(length(data) && istype(food, /obj/item/food))
		var/obj/item/food/food_item = food
		food_item.set_nutriment_data(data)
	return food

/decl/chemical_reaction/recipe/food/dairy
	abstract_type = /decl/chemical_reaction/recipe/food/dairy
	var/static/list/milk_data_keys = list(
		DATA_MILK_DONOR,
		DATA_MILK_NAME,
		DATA_MILK_COLOR,
		DATA_CHEESE_NAME,
		DATA_CHEESE_COLOR
	)

/decl/chemical_reaction/recipe/food/dairy/send_data(var/datum/reagents/holder, var/reaction_limit)
	. = ..()
	for(var/reagent in required_reagents)
		var/list/data = LAZYACCESS(holder.reagent_data, reagent)
		if(!islist(data))
			continue
		for(var/milk_key in milk_data_keys)
			var/milk_val = data[milk_key]
			if(isnull(milk_val))
				continue
			LAZYSET(., milk_key, milk_val)

/decl/chemical_reaction/recipe/food/dairy/butter
	name = "Enzyme Butter"
	required_reagents = list(
		/decl/material/solid/sodiumchloride = 1,
		/decl/material/liquid/drink/milk/cream = 20
	)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	mix_message = "The solution thickens and curdles into a buttery yellow solid."
	minimum_temperature = 40 CELSIUS
	maximum_temperature = (40 CELSIUS) + 100
	obj_result = /obj/item/food/dairy/butter/stick

/decl/chemical_reaction/recipe/food/dairy/margarine
	name = "Enzyme Margarine"
	required_reagents = list(
		/decl/material/solid/sodiumchloride = 1,
		/decl/material/liquid/nutriment/plant_oil = 20
	)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	mix_message = "The solution thickens and curdles into a pale yellow solid."
	minimum_temperature = 40 CELSIUS
	maximum_temperature = (40 CELSIUS) + 100
	obj_result = /obj/item/food/dairy/butter/stick/margarine

/decl/chemical_reaction/recipe/food/dairy/cheesewheel
	name = "Enzyme Cheesewheel"
	required_reagents = list(/decl/material/liquid/drink/milk = 40)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	mix_message = "The solution thickens and curdles into a rich yellow solid."
	minimum_temperature = 40 CELSIUS
	maximum_temperature = (40 CELSIUS) + 100
	obj_result = /obj/item/food/dairy/cheese/wheel

/decl/chemical_reaction/recipe/food/dairy/cheesewheel/rennet
	name = "Rennet Cheesewheel"
	catalysts = list()
	required_reagents = list(
		/decl/material/liquid/drink/milk    = 40,
		/decl/material/liquid/enzyme/rennet = 3
	)

/decl/chemical_reaction/recipe/food/rawmeatball
	name = "Raw Meatball"
	required_reagents = list(
		/decl/material/solid/organic/meat     = 3,
		/decl/material/liquid/nutriment/flour = 5
	)
	result_amount = 3
	mix_message = "The flour thickens the processed meat until it clumps."
	obj_result = /obj/item/food/meatball/raw

/decl/chemical_reaction/recipe/food/piecrust
	name = "Butter Pie Crust"
	required_reagents = list(
		/decl/material/liquid/nutriment/sugar  = 1,
		/decl/material/solid/sodiumchloride    = 1,
		/decl/material/liquid/nutriment/flour  = 10,
		/decl/material/liquid/water            = 5,
		/decl/material/liquid/nutriment/butter = 1
	)
	mix_message = "The solution smooths out into a pie crust."
	obj_result = /obj/item/food/piecrust
	// Trying to get the chemical recipe overlaps with dough sorted out.
	maximum_temperature = 60 CELSIUS

/decl/chemical_reaction/recipe/food/piecrust/margarine
	name = "Shortening Pie Crust"
	required_reagents = list(
		/decl/material/liquid/nutriment/sugar     = 1,
		/decl/material/solid/sodiumchloride       = 1,
		/decl/material/liquid/nutriment/flour     = 10,
		/decl/material/liquid/water               = 5,
		/decl/material/liquid/nutriment/margarine = 1
	)

/decl/chemical_reaction/recipe/food/dough
	name = "Dough (Leavened)"
	required_reagents = list(
		/decl/material/liquid/nutriment/yeast = 1,
		/decl/material/liquid/nutriment/flour = 10,
		/decl/material/liquid/water           = 10
	)
	mix_message = "The solution rises into a large ball of leavened dough."
	obj_result = /obj/item/food/dough
	minimum_temperature = 60 CELSIUS

/decl/chemical_reaction/recipe/food/dough/unleavened
	name = "Dough (Unleavened)"
	required_reagents = list(
		/decl/material/solid/sodiumchloride   = 1,
		/decl/material/liquid/nutriment/flour = 10,
		/decl/material/liquid/water           = 10
	)
	mix_message = "The solution swells into a round of unleavened dough."
	obj_result = /obj/item/food/sliceable/unleaveneddough
	inhibitors = list(/decl/material/liquid/nutriment/yeast)

/decl/chemical_reaction/recipe/food/syntiflesh
	name = "Synthetic Meat"
	required_reagents = list(/decl/material/liquid/blood = 5, /decl/material/liquid/plasticide = 1)
	mix_message = "The solution thickens disturbingly, taking on a meaty appearance."
	obj_result = /obj/item/food/butchery/meat/syntiflesh

/decl/chemical_reaction/recipe/food/tofu
	name = "Tofu"
	required_reagents = list(/decl/material/liquid/drink/milk/soymilk = 10)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	mix_message = "The solution thickens and clumps into a yellow-white substance."
	obj_result = /obj/item/food/tofu

/decl/chemical_reaction/recipe/food/chocolate_bar
	name = "Soy Chocolate"
	required_reagents = list(/decl/material/liquid/drink/milk/soymilk = 2, /decl/material/liquid/nutriment/coco = 2, /decl/material/liquid/nutriment/sugar = 2)
	mix_message = "The solution thickens and hardens into a glossy brown substance."
	obj_result = /obj/item/food/chocolatebar

/decl/chemical_reaction/recipe/food/chocolate_bar2
	name = "Milk Chocolate"
	required_reagents = list(/decl/material/liquid/drink/milk = 2, /decl/material/liquid/nutriment/coco = 2, /decl/material/liquid/nutriment/sugar = 2)
	mix_message = "The solution thickens and hardens into a glossy brown substance."
	obj_result = /obj/item/food/chocolatebar
	minimum_temperature = 70 CELSIUS

/decl/chemical_reaction/recipe/food/stuffing
	name = "Stuffing"
	required_reagents = list(
		/decl/material/liquid/water = 10,
		/decl/material/solid/sodiumchloride = 1,
		/decl/material/solid/blackpepper = 1,
		/decl/material/liquid/nutriment/bread = 5
	)
	mix_message = "The breadcrumbs and water clump together to form a thick stuffing."
	obj_result = /obj/item/food/stuffing

/decl/chemical_reaction/recipe/food/mint
	name = "Mint"
	required_reagents = list(
		/decl/material/liquid/nutriment/sugar = 5,
		/decl/material/liquid/frostoil = 5
	)
	mix_message = "The solution thickens and hardens into a glossy brown substance."
	obj_result = /obj/item/food/mint

/decl/chemical_reaction/recipe/food/pudding
	abstract_type = /decl/chemical_reaction/recipe/food/pudding
	minimum_temperature = T0C + 80

/decl/chemical_reaction/recipe/food/pudding/chazuke
	name = "Chazuke"
	required_reagents = list(
		/decl/material/liquid/nutriment/rice  = 5,
		/decl/material/liquid/drink/tea/green = 1
	)
	mix_message = "The tea mingles with and cooks the rice."
	obj_result = /obj/item/food/chazuke

/decl/chemical_reaction/recipe/food/pudding/ricepudding
	name = "Rice Pudding"
	required_reagents = list(
		/decl/material/liquid/drink/milk = 5,
		/decl/material/liquid/nutriment/rice = 10
	)
	obj_result = /obj/item/food/ricepudding

/decl/chemical_reaction/recipe/food/pudding/spacylibertyduff
	name = "Space Liberty Duff"
	required_reagents = list(
		/decl/material/liquid/water = 10,
		/decl/material/liquid/ethanol/vodka = 5,
		/decl/material/liquid/psychotropics = 5
	)
	obj_result = /obj/item/food/spacylibertyduff

/decl/chemical_reaction/recipe/food/pudding/amanitajelly
	name = "Amanita Jelly"
	required_reagents = list(
		/decl/material/liquid/water = 10,
		/decl/material/liquid/ethanol/vodka = 5,
		/decl/material/liquid/amatoxin = 5
	)
	obj_result = /obj/item/food/amanitajelly

/decl/chemical_reaction/recipe/food/pudding/amanitajelly/create_food(location, list/data)
	var/obj/item/food/amanitajelly/being_cooked = ..()
	if(being_cooked?.reagents)
		being_cooked.reagents.clear_reagent(/decl/material/liquid/amatoxin)
	return being_cooked
