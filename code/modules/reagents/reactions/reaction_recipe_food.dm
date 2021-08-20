/datum/chemical_reaction/recipe/food
	result = null
	result_amount = 1
	var/obj_result

/datum/chemical_reaction/recipe/food/on_reaction(var/datum/reagents/holder, var/created_volume, var/reaction_flags)
	..()
	var/location = get_turf(holder.my_atom)
	if(obj_result && isturf(location))
		for(var/i = 1, i <= created_volume, i++)
			new obj_result(location)

/datum/chemical_reaction/recipe/food/cheesewheel
	name = "Cheesewheel"
	required_reagents = list(/decl/material/liquid/drink/milk = 40)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	mix_message = "The solution thickens and curdles into a rich yellow substance."
	minimum_temperature = 40 CELSIUS
	maximum_temperature = (40 CELSIUS) + 100
	obj_result = /obj/item/chems/food/sliceable/cheesewheel

/datum/chemical_reaction/recipe/food/rawmeatball
	name = "Raw Meatball"
	required_reagents = list(/decl/material/liquid/nutriment/protein = 3, /decl/material/liquid/nutriment/flour = 5)
	result_amount = 3
	mix_message = "The flour thickens the processed meat until it clumps."
	obj_result = /obj/item/chems/food/rawmeatball

/datum/chemical_reaction/recipe/food/dough
	name = "Dough"
	required_reagents = list(/decl/material/liquid/nutriment/protein/egg = 3, /decl/material/liquid/nutriment/flour = 10, /decl/material/liquid/water = 10)
	mix_message = "The solution folds and thickens into a large ball of dough."
	obj_result = /obj/item/chems/food/dough

/datum/chemical_reaction/recipe/food/soydough
	name = "Soy dough"
	required_reagents = list(/decl/material/liquid/nutriment/plant_protein = 3, /decl/material/liquid/nutriment/flour = 10, /decl/material/liquid/water = 10)
	mix_message = "The solution folds and thickens into a large ball of dough."
	obj_result = /obj/item/chems/food/dough

/datum/chemical_reaction/recipe/food/syntiflesh
	name = "Synthetic Meat"
	required_reagents = list(/decl/material/liquid/blood = 5, /decl/material/liquid/plasticide = 1)
	mix_message = "The solution thickens disturbingly, taking on a meaty appearance."
	obj_result = /obj/item/chems/food/meat/syntiflesh

/datum/chemical_reaction/recipe/food/tofu
	name = "Tofu"
	required_reagents = list(/decl/material/liquid/drink/milk/soymilk = 10)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	mix_message = "The solution thickens and clumps into a yellow-white substance."
	obj_result = /obj/item/chems/food/tofu

/datum/chemical_reaction/recipe/food/chocolate_bar
	name = "Soy Chocolate"
	required_reagents = list(/decl/material/liquid/drink/milk/soymilk = 2, /decl/material/liquid/nutriment/coco = 2, /decl/material/liquid/nutriment/sugar = 2)
	mix_message = "The solution thickens and hardens into a glossy brown substance."
	obj_result = /obj/item/chems/food/chocolatebar

/datum/chemical_reaction/recipe/food/chocolate_bar2
	name = "Milk Chocolate"
	required_reagents = list(/decl/material/liquid/drink/milk = 2, /decl/material/liquid/nutriment/coco = 2, /decl/material/liquid/nutriment/sugar = 2)
	mix_message = "The solution thickens and hardens into a glossy brown substance."
	obj_result = /obj/item/chems/food/chocolatebar
	minimum_temperature = 70 CELSIUS