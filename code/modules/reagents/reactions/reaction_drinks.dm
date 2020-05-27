/datum/chemical_reaction/recipe/mutagen_cola
	name = "Mutagen Cola"
	result = /decl/material/drink/mutagencola
	required_reagents = list(/decl/material/mutagenics = 1, /decl/material/drink/cola = 5)
	result_amount = 5
	mix_message = "The solution bubbles and emits an eerie green glow."

/datum/chemical_reaction/recipe/grapesoda
	name = "Grape Soda"
	result = /decl/material/drink/grapesoda
	required_reagents = list(/decl/material/drink/juice/grape = 2, /decl/material/drink/cola = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/lemonade
	name = "Lemonade"
	result = /decl/material/drink/lemonade
	required_reagents = list(/decl/material/drink/juice/lemon = 1, /decl/material/nutriment/sugar = 1, /decl/material/water = 1)
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
	required_reagents = list(/decl/material/drink/milk/cream = 1, /decl/material/drink/ice = 2, /decl/material/drink/milk = 2)
	result_amount = 5

/datum/chemical_reaction/recipe/chocolate_milk
	name = "Chocolate Milk"
	result = /decl/material/drink/milk/chocolate
	required_reagents = list(/decl/material/drink/milk = 5, /decl/material/nutriment/coco = 1)
	result_amount = 5
	mix_message = "The solution thickens into a creamy brown beverage."
	maximum_temperature = 70 CELSIUS

/datum/chemical_reaction/recipe/kefir
	name = "Kefir"
	result = /decl/material/drink/kefir
	required_reagents = list(/decl/material/drink/milk = 2, /decl/material/drink/milk/cream = 1)
	result_amount = 3
	catalysts = list(/decl/material/nutriment = 1)
	mix_message = "The milk ferments into kefir"