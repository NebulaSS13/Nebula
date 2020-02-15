/datum/chemical_reaction/mutagen_cola
	name = "Mutagen Cola"
	result = /datum/reagent/drink/mutagencola
	required_reagents = list(/datum/reagent/mutagenics = 1, /datum/reagent/drink/cola = 5)
	result_amount = 5
	mix_message = "The solution bubbles and emits an eerie green glow."

/datum/chemical_reaction/grapesoda
	name = "Grape Soda"
	result = /datum/reagent/drink/grapesoda
	required_reagents = list(/datum/reagent/drink/juice/grape = 2, /datum/reagent/drink/cola = 1)
	result_amount = 3

/datum/chemical_reaction/lemonade
	name = "Lemonade"
	result = /datum/reagent/drink/lemonade
	required_reagents = list(/datum/reagent/drink/juice/lemon = 1, /datum/reagent/nutriment/sugar = 1, /datum/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/citrusseltzer
	name = "Citrus Seltzer"
	result = /datum/reagent/drink/citrusseltzer
	required_reagents = list(/datum/reagent/drink/juice/orange = 1, /datum/reagent/drink/juice/lime = 1, /datum/reagent/drink/sodawater = 1)
	result_amount = 3

/datum/chemical_reaction/indrelbreakfast
	name = "Indrel Breakfast"
	result = /datum/reagent/drink/orangecola
	required_reagents = list(/datum/reagent/drink/juice/orange = 2, /datum/reagent/drink/cola = 1)
	result_amount = 3

/datum/chemical_reaction/milkshake
	name = "Milkshake"
	result = /datum/reagent/drink/milkshake
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/drink/ice = 2, /datum/reagent/drink/milk = 2)
	result_amount = 5

/datum/chemical_reaction/rewriter
	name = "Rewriter"
	result = /datum/reagent/drink/rewriter
	required_reagents = list(/datum/reagent/drink/citrussoda = 1, /datum/reagent/drink/coffee = 1)
	result_amount = 2

/datum/chemical_reaction/chocolate_milk
	name = "Chocolate Milk"
	result = /datum/reagent/drink/milk/chocolate
	required_reagents = list(/datum/reagent/drink/milk = 5, /datum/reagent/nutriment/coco = 1)
	result_amount = 5
	mix_message = "The solution thickens into a creamy brown beverage."

/datum/chemical_reaction/nothing
	name = "Nothing"
	result = /datum/reagent/drink/nothing
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/nutriment/sugar = 1, /datum/reagent/water= 1)
	result_amount = 3

/datum/chemical_reaction/fools_gold
	name = "Fools Gold"
	result = /datum/reagent/drink/fools_gold
	required_reagents = list(/datum/reagent/water = 2, /datum/reagent/ethanol/whiskey = 1)
	result_amount = 3

/datum/chemical_reaction/snowball
	name = "Snowball"
	result = /datum/reagent/drink/snowball
	required_reagents = list(/datum/reagent/drink/ice = 2, /datum/reagent/drink/coffee/icecoffee = 1, /datum/reagent/drink/juice/watermelon = 1)
	result_amount = 4
	minimum_temperature = (0 CELSIUS) - 100
	maximum_temperature = 0 CELSIUS
	mix_message = "The solution turns pure white."

/datum/chemical_reaction/browndwarf
	name = "Brown Dwarf"
	result = /datum/reagent/drink/browndwarf
	required_reagents = list(/datum/reagent/drink/hot_coco = 2, /datum/reagent/drink/citrussoda = 1)
	result_amount = 3
	minimum_temperature = 70 CELSIUS
	maximum_temperature = (70 CELSIUS) + 100
	mix_message = "The chocolate puffs up into a semi-solid state"

/datum/chemical_reaction/kefir
	name = "Kefir"
	result = /datum/reagent/drink/kefir
	required_reagents = list(/datum/reagent/drink/milk = 2, /datum/reagent/drink/milk/cream = 1)
	result_amount = 3
	catalysts = list(/datum/reagent/nutriment)
	mix_message = "The milk ferments into kefir"