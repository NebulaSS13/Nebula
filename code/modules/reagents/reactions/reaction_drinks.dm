/datum/chemical_reaction/recipe/mutagen_cola
	name = "Mutagen Cola"
	result = /decl/material/liquid/drink/mutagencola
	required_reagents = list(/decl/material/liquid/mutagenics = 1, /decl/material/liquid/drink/cola = 5)
	result_amount = 5
	mix_message = "The solution bubbles and emits an eerie green glow."

/datum/chemical_reaction/recipe/grapesoda
	name = "Grape Soda"
	result = /decl/material/liquid/drink/grapesoda
	required_reagents = list(/decl/material/liquid/drink/juice/grape = 2, /decl/material/liquid/drink/cola = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/lemonade
	name = "Lemonade"
	result = /decl/material/liquid/drink/lemonade
	required_reagents = list(/decl/material/liquid/drink/juice/lemon = 1, /decl/material/liquid/nutriment/sugar = 1, /decl/material/liquid/water = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/citrusseltzer
	name = "Citrus Seltzer"
	result = /decl/material/liquid/drink/citrusseltzer
	required_reagents = list(/decl/material/liquid/drink/juice/orange = 1, /decl/material/liquid/drink/juice/lime = 1, /decl/material/liquid/drink/sodawater = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/orangecola
	name = "Orange Cola"
	result = /decl/material/liquid/drink/orangecola
	required_reagents = list(/decl/material/liquid/drink/juice/orange = 2, /decl/material/liquid/drink/cola = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/milkshake
	name = "Milkshake"
	result = /decl/material/liquid/drink/milkshake
	required_reagents = list(/decl/material/liquid/drink/milk/cream = 1, /decl/material/solid/ice = 2, /decl/material/liquid/drink/milk = 2)
	result_amount = 5

/datum/chemical_reaction/recipe/chocolate_milk
	name = "Chocolate Milk"
	result = /decl/material/liquid/drink/milk/chocolate
	required_reagents = list(/decl/material/liquid/drink/milk = 5, /decl/material/liquid/nutriment/coco = 1)
	result_amount = 5
	mix_message = "The solution thickens into a creamy brown beverage."
	maximum_temperature = 70 CELSIUS

/datum/chemical_reaction/recipe/kefir
	name = "Kefir"
	result = /decl/material/liquid/drink/kefir
	required_reagents = list(/decl/material/liquid/drink/milk = 2, /decl/material/liquid/drink/milk/cream = 1)
	result_amount = 3
	catalysts = list(/decl/material/liquid/nutriment = 1)
	mix_message = "The milk ferments into kefir."

/datum/chemical_reaction/recipe/compote
	name = "Compote"
	result = /decl/material/liquid/drink/compote
	required_reagents = list(/decl/material/liquid/water = 2, /decl/material/liquid/drink/juice/berry = 1, /decl/material/liquid/drink/juice/apple = 1, /decl/material/liquid/drink/juice/pear = 1)
	result_amount = 5
	mix_message = "The mixture turns a soft orange, bubbling faintly."
	minimum_temperature = 40 CELSIUS
	maximum_temperature = (40 CELSIUS)
