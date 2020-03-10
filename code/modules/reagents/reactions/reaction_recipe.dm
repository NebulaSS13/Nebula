/datum/chemical_reaction/recipe/soysauce
	name = "Vinegar Soy Sauce"
	result = /datum/reagent/nutriment/soysauce
	required_reagents = list(/datum/reagent/drink/milk/soymilk = 5, /datum/reagent/nutriment/vinegar = 5)
	result_amount = 10
	mix_message = "The solution settles into a glossy black sauce."

/datum/chemical_reaction/recipe/soysauce_acid
	name = "Acid Soy Sauce"
	result = /datum/reagent/nutriment/soysauce
	required_reagents = list(/datum/reagent/drink/milk/soymilk = 4, /datum/reagent/acid = 1)
	result_amount = 5
	mix_message = "The solution settles into a glossy black sauce."

/datum/chemical_reaction/recipe/ketchup
	name = "Ketchup"
	result = /datum/reagent/nutriment/ketchup
	required_reagents = list(/datum/reagent/drink/juice/tomato = 2, /datum/reagent/water = 1, /datum/reagent/nutriment/sugar = 1)
	result_amount = 4
	mix_message = "The solution thickens into a sweet-smelling red sauce."

/datum/chemical_reaction/recipe/banana_cream
	name = "Banana Cream"
	result = /datum/reagent/nutriment/banana_cream
	catalysts = list(/datum/reagent/enzyme = 5)
	required_reagents = list(/datum/reagent/drink/juice/banana = 2, /datum/reagent/drink/milk/cream = 1)
	result_amount = 3
	mix_message = "The solution thickens into a creamy banana-scented substance."

/datum/chemical_reaction/recipe/barbecue
	name = "Barbecue Sauce"
	result = /datum/reagent/nutriment/barbecue
	required_reagents = list(/datum/reagent/nutriment/ketchup = 2, /datum/reagent/blackpepper = 1, /datum/reagent/sodiumchloride = 1)
	result_amount = 4
	mix_message = "The solution thickens into a sweet-smelling brown sauce."

/datum/chemical_reaction/recipe/garlicsauce
	name = "Garlic Sauce"
	result = /datum/reagent/nutriment/garlicsauce
	required_reagents = list(/datum/reagent/drink/juice/garlic = 1, /datum/reagent/nutriment/cornoil = 1)
	result_amount = 2
	mix_message = "The solution thickens into a creamy white oil."

//batter reaction as food precursor, for things that don't use pliable dough precursor.
/datum/chemical_reaction/recipe/batter
	name = "Batter"
	result = /datum/reagent/nutriment/batter
	required_reagents = list(/datum/reagent/nutriment/protein/egg = 3, /datum/reagent/nutriment/flour = 5, /datum/reagent/drink/milk = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy batter."

/datum/chemical_reaction/recipe/cakebatter
	name = "Cake Batter"
	result = /datum/reagent/nutriment/batter/cakebatter
	required_reagents = list(/datum/reagent/nutriment/sugar = 1, /datum/reagent/nutriment/batter = 2)
	result_amount = 3
	mix_message = "The sugar lightens the batter and gives it a sweet smell."

/datum/chemical_reaction/recipe/soybatter
	name = "Vegan Batter"
	result = /datum/reagent/nutriment/batter
	required_reagents = list(/datum/reagent/nutriment/plant_protein = 3, /datum/reagent/nutriment/flour = 5, /datum/reagent/drink/milk = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy batter."

/datum/chemical_reaction/recipe/vinegar
	name = "Apple Vinegar"
	result = /datum/reagent/nutriment/vinegar
	required_reagents = list(/datum/reagent/drink/juice/apple = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a sharp-smelling liquid."

/datum/chemical_reaction/recipe/vinegar2
	name = "Clear Vinegar"
	result = /datum/reagent/nutriment/vinegar
	required_reagents = list(/datum/reagent/ethanol = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a sharp-smelling liquid."

/datum/chemical_reaction/recipe/mayo
	name = "Vinegar Mayo"
	result = /datum/reagent/nutriment/mayo
	required_reagents = list(/datum/reagent/nutriment/vinegar = 5, /datum/reagent/nutriment/protein/egg = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy, creamy substance."

/datum/chemical_reaction/recipe/mayo2
	name = "Lemon Mayo"
	result = /datum/reagent/nutriment/mayo
	required_reagents = list(/datum/reagent/drink/juice/lemon = 5, /datum/reagent/nutriment/protein/egg = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy, creamy substance."

/datum/chemical_reaction/recipe/hot_ramen
	name = "Hot Ramen"
	result = /datum/reagent/drink/hot_ramen
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/drink/dry_ramen = 3)
	result_amount = 3
	mix_message = "The noodles soften in the hot water, releasing savoury steam."
	hidden_from_codex = TRUE

/datum/chemical_reaction/recipe/hell_ramen
	name = "Hell Ramen"
	result = /datum/reagent/drink/hell_ramen
	required_reagents = list(/datum/reagent/capsaicin = 1, /datum/reagent/drink/hot_ramen = 6)
	result_amount = 6
	mix_message = "The broth of the noodles takes on a hellish red gleam."
	hidden_from_codex = TRUE

/datum/chemical_reaction/recipe/chazuke
	name = "Chazuke"
	result = /datum/reagent/nutriment/rice/chazuke
	required_reagents = list(/datum/reagent/nutriment/rice = 10, /datum/reagent/drink/tea/green = 1)
	result_amount = 10
	mix_message = "The tea mingles with the rice."
