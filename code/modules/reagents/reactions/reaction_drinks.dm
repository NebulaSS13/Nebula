/datum/chemical_reaction/recipe/mutagen_cola
	name = "Mutagen Cola"
	result = /decl/reagent/drink/mutagencola
	required_reagents = list(/decl/reagent/mutagenics = 1, /decl/reagent/drink/cola = 5)
	result_amount = 5
	mix_message = "The solution bubbles and emits an eerie green glow."

/datum/chemical_reaction/recipe/grapesoda
	name = "Grape Soda"
	result = /decl/reagent/drink/grapesoda
	required_reagents = list(/decl/reagent/drink/juice/grape = 2, /decl/reagent/drink/cola = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/lemonade
	name = "Lemonade"
	result = /decl/reagent/drink/lemonade
	required_reagents = list(/decl/reagent/drink/juice/lemon = 1, /decl/reagent/nutriment/sugar = 1, /decl/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/citrusseltzer
	name = "Citrus Seltzer"
	result = /decl/reagent/drink/citrusseltzer
	required_reagents = list(/decl/reagent/drink/juice/orange = 1, /decl/reagent/drink/juice/lime = 1, /decl/reagent/drink/sodawater = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/orangecola
	name = "Orange Cola"
	result = /decl/reagent/drink/orangecola
	required_reagents = list(/decl/reagent/drink/juice/orange = 2, /decl/reagent/drink/cola = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/milkshake
	name = "Milkshake"
	result = /decl/reagent/drink/milkshake
	required_reagents = list(/decl/reagent/drink/milk/cream = 1, /decl/reagent/drink/ice = 2, /decl/reagent/drink/milk = 2)
	result_amount = 5

/datum/chemical_reaction/recipe/chocolate_milk
	name = "Chocolate Milk"
	result = /decl/reagent/drink/milk/chocolate
	required_reagents = list(/decl/reagent/drink/milk = 5, /decl/reagent/nutriment/coco = 1)
	result_amount = 5
	mix_message = "The solution thickens into a creamy brown beverage."
	maximum_temperature = 70 CELSIUS

/datum/chemical_reaction/recipe/kefir
	name = "Kefir"
	result = /decl/reagent/drink/kefir
	required_reagents = list(/decl/reagent/drink/milk = 2, /decl/reagent/drink/milk/cream = 1)
	result_amount = 3
	catalysts = list(/decl/reagent/nutriment = 1)
	mix_message = "The milk ferments into kefir"