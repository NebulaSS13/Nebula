/datum/chemical_reaction/recipe/mutagen_cola
	name = "Mutagen Cola"
	result = /datum/reagent/drink/mutagencola
	required_reagents = list(/datum/reagent/mutagenics = 1, /datum/reagent/drink/cola = 5)
	result_amount = 5
	mix_message = "The solution bubbles and emits an eerie green glow."

/datum/chemical_reaction/recipe/grapesoda
	name = "Grape Soda"
	result = /datum/reagent/drink/grapesoda
	required_reagents = list(/datum/reagent/drink/juice/grape = 2, /datum/reagent/drink/cola = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/lemonade
	name = "Lemonade"
	result = /datum/reagent/drink/lemonade
	required_reagents = list(/datum/reagent/drink/juice/lemon = 1, /datum/reagent/nutriment/sugar = 1, /datum/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/citrusseltzer
	name = "Citrus Seltzer"
	result = /datum/reagent/drink/citrusseltzer
	required_reagents = list(/datum/reagent/drink/juice/orange = 1, /datum/reagent/drink/juice/lime = 1, /datum/reagent/drink/sodawater = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/orangecola
	name = "Orange Cola"
	result = /datum/reagent/drink/orangecola
	required_reagents = list(/datum/reagent/drink/juice/orange = 2, /datum/reagent/drink/cola = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/milkshake
	name = "Milkshake"
	result = /datum/reagent/drink/milkshake
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/drink/ice = 2, /datum/reagent/drink/milk = 2)
	result_amount = 5

/datum/chemical_reaction/recipe/rewriter
	name = "Rewriter"
	result = /datum/reagent/drink/rewriter
	required_reagents = list(/datum/reagent/drink/citrussoda = 1, /datum/reagent/drink/coffee = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/chocolate_milk
	name = "Chocolate Milk"
	result = /datum/reagent/drink/milk/chocolate
	required_reagents = list(/datum/reagent/drink/milk = 5, /datum/reagent/nutriment/coco = 1)
	result_amount = 5
	mix_message = "The solution thickens into a creamy brown beverage."
	maximum_temperature = 70 CELSIUS

/datum/chemical_reaction/recipe/nothing
	name = "Nothing"
	result = /datum/reagent/drink/nothing
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/nutriment/sugar = 1, /datum/reagent/water= 1)
	result_amount = 3

/datum/chemical_reaction/recipe/fools_gold
	name = "Fools Gold"
	result = /datum/reagent/drink/fools_gold
	required_reagents = list(/datum/reagent/water = 2, /datum/reagent/ethanol/whiskey = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/snowball
	name = "Snowball"
	result = /datum/reagent/drink/snowball
	required_reagents = list(/datum/reagent/drink/ice = 2, /datum/reagent/drink/coffee/icecoffee = 1, /datum/reagent/drink/juice/watermelon = 1)
	result_amount = 4
	minimum_temperature = (0 CELSIUS) - 100
	maximum_temperature = 0 CELSIUS
	mix_message = "The solution turns pure white."

/datum/chemical_reaction/recipe/browndwarf
	name = "Brown Dwarf"
	result = /datum/reagent/drink/browndwarf
	required_reagents = list(/datum/reagent/drink/hot_coco = 2, /datum/reagent/drink/citrussoda = 1)
	result_amount = 3
	minimum_temperature = 70 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The chocolate puffs up into a semi-solid state"

/datum/chemical_reaction/recipe/kefir
	name = "Kefir"
	result = /datum/reagent/drink/kefir
	required_reagents = list(/datum/reagent/drink/milk = 2, /datum/reagent/drink/milk/cream = 1)
	result_amount = 3
	catalysts = list(/datum/reagent/nutriment = 1)
	mix_message = "The milk ferments into kefir"