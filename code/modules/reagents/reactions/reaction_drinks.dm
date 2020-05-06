/datum/chemical_reaction/recipe/mutagen_cola
	name = "Mutagen Cola"
	result = /decl/material/drink/mutagencola
	required_reagents = list(/decl/material/mutagenics = 1, /decl/material/drink/cola = 5)
	result_amount = 5
	mix_message = "The solution bubbles and emits an eerie green glow."

/datum/chemical_reaction/recipe/grapesoda
	name = "Grape Soda"
	result = /decl/material/drink/grapesoda
	required_reagents = list(
		/decl/material/drink/juice/grape = 2, 
		/decl/material/drink/cola = 1
	)
	result_amount = 3

/datum/chemical_reaction/recipe/lemonade
	name = "Lemonade"
	result = /decl/material/drink/lemonade
	required_reagents = list(
		/decl/material/drink/juice/lemon = 1, 
		/decl/material/nutriment/sugar = 1, 
		MAT_WATER = 1
	)
	result_amount = 3

/datum/chemical_reaction/recipe/citrusseltzer
	name = "Citrus Seltzer"
	result = /decl/material/drink/citrusseltzer
	required_reagents = list(/decl/material/drink/juice/orange = 1, /decl/material/drink/juice/lime = 1, /decl/material/drink/sodawater = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/orangecola
	name = "Orange Cola"
	result = /decl/material/drink/orangecola
	required_reagents = list(/decl/material/drink/juice/orange = 2, /decl/material/drink/cola = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/milkshake
	name = "Milkshake"
	result = /decl/material/drink/milkshake
	required_reagents = list(
		/decl/material/drink/milk/cream = 1, 
		MAT_WATER = 2, 
		/decl/material/drink/milk = 2
	)
	result_amount = 5

/datum/chemical_reaction/recipe/rewriter
	name = "Rewriter"
	result = /decl/material/drink/rewriter
	required_reagents = list(/decl/material/drink/citrussoda = 1, /decl/material/drink/coffee = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/chocolate_milk
	name = "Chocolate Milk"
	result = /decl/material/drink/milk/chocolate
	required_reagents = list(/decl/material/drink/milk = 5, /decl/material/nutriment/coco = 1)
	result_amount = 5
	mix_message = "The solution thickens into a creamy brown beverage."
	maximum_temperature = 70 CELSIUS

/datum/chemical_reaction/recipe/nothing
	name = "Nothing"
	result = /decl/material/drink/nothing
	required_reagents = list(
		/decl/material/drink/milk/cream = 1, 
		/decl/material/nutriment/sugar = 1, 
		MAT_WATER = 1
	)
	result_amount = 3

/datum/chemical_reaction/recipe/fools_gold
	name = "Fools Gold"
	result = /decl/material/drink/fools_gold
	required_reagents = list(
		MAT_WATER = 2, 
		/decl/material/ethanol/whiskey = 1
	)
	result_amount = 3

/datum/chemical_reaction/recipe/snowball
	name = "Snowball"
	result = /decl/material/drink/snowball
	required_reagents = list(
		MAT_WATER = 2, 
		/decl/material/drink/coffee/icecoffee = 1, 
		/decl/material/drink/juice/watermelon = 1
	)
	result_amount = 4
	minimum_temperature = (0 CELSIUS) - 100
	maximum_temperature = 0 CELSIUS
	mix_message = "The solution turns pure white."

/datum/chemical_reaction/recipe/browndwarf
	name = "Brown Dwarf"
	result = /decl/material/drink/browndwarf
	required_reagents = list(/decl/material/drink/hot_coco = 2, /decl/material/drink/citrussoda = 1)
	result_amount = 3
	minimum_temperature = 70 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The chocolate puffs up into a semi-solid state"

/datum/chemical_reaction/recipe/kefir
	name = "Kefir"
	result = /decl/material/drink/kefir
	required_reagents = list(/decl/material/drink/milk = 2, /decl/material/drink/milk/cream = 1)
	result_amount = 3
	catalysts = list(/decl/material/nutriment = 1)
	mix_message = "The milk ferments into kefir"