/decl/chemical_reaction/recipe/food
	result = null
	result_amount = 1
	abstract_type = /decl/chemical_reaction/recipe/food
	var/obj_result

/decl/chemical_reaction/recipe/food/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.get_reaction_loc(chemical_reaction_flags))
	if(obj_result && isturf(location))
		for(var/i = 1, i <= created_volume, i++)
			create_food(location)

/decl/chemical_reaction/recipe/food/proc/create_food(location)
	var/atom/movable/food = new obj_result
	if(istype(food))
		food.dropInto(location)
	return food

/decl/chemical_reaction/recipe/food/cheesewheel
	name = "Enzyme Cheesewheel"
	required_reagents = list(/decl/material/liquid/drink/milk = 40)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	mix_message = "The solution thickens and curdles into a rich yellow solid."
	minimum_temperature = 40 CELSIUS
	maximum_temperature = (40 CELSIUS) + 100
	obj_result = /obj/item/food/sliceable/cheesewheel

/decl/chemical_reaction/recipe/food/cheesewheel/rennet
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

/decl/chemical_reaction/recipe/food/dough
	name = "Plain dough"
	required_reagents = list(
		/decl/material/solid/organic/meat/egg = 3,
		/decl/material/liquid/nutriment/flour = 10,
		/decl/material/liquid/water           = 10
	)
	mix_message = "The solution folds and thickens into a large ball of dough."
	obj_result = /obj/item/food/dough

/decl/chemical_reaction/recipe/food/soydough
	name = "Soy dough"
	required_reagents = list(/decl/material/liquid/nutriment/plant_protein = 3, /decl/material/liquid/nutriment/flour = 10, /decl/material/liquid/water = 10)
	mix_message = "The solution folds and thickens into a large ball of dough."
	obj_result = /obj/item/food/dough

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

/decl/chemical_reaction/recipe/food/pudding/amanitajelly/create_food(location)
	var/obj/item/food/amanitajelly/being_cooked = ..()
	if(being_cooked?.reagents)
		being_cooked.reagents.clear_reagent(/decl/material/liquid/amatoxin)
	return being_cooked
