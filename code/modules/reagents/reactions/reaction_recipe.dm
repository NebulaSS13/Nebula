/datum/chemical_reaction/recipe/soysauce
	name = "Vinegar Soy Sauce"
	result = /decl/reagent/nutriment/soysauce
	required_reagents = list(/decl/reagent/drink/milk/soymilk = 5, /decl/reagent/nutriment/vinegar = 5)
	result_amount = 10
	mix_message = "The solution settles into a glossy black sauce."

/datum/chemical_reaction/recipe/soysauce_acid
	name = "Acid Soy Sauce"
	result = /decl/reagent/nutriment/soysauce
	required_reagents = list(/decl/reagent/drink/milk/soymilk = 4, /decl/reagent/acid = 1)
	result_amount = 5
	mix_message = "The solution settles into a glossy black sauce."

/datum/chemical_reaction/recipe/ketchup
	name = "Ketchup"
	result = /decl/reagent/nutriment/ketchup
	required_reagents = list(/decl/reagent/drink/juice/tomato = 2, /decl/reagent/water = 1, /decl/reagent/nutriment/sugar = 1)
	result_amount = 4
	mix_message = "The solution thickens into a sweet-smelling red sauce."

/datum/chemical_reaction/recipe/banana_cream
	name = "Banana Cream"
	result = /decl/reagent/nutriment/banana_cream
	catalysts = list(/decl/reagent/enzyme = 5)
	required_reagents = list(/decl/reagent/drink/juice/banana = 2, /decl/reagent/drink/milk/cream = 1)
	result_amount = 3
	mix_message = "The solution thickens into a creamy banana-scented substance."

/datum/chemical_reaction/recipe/barbecue
	name = "Barbecue Sauce"
	result = /decl/reagent/nutriment/barbecue
	required_reagents = list(/decl/reagent/nutriment/ketchup = 2, /decl/reagent/blackpepper = 1, /decl/reagent/sodiumchloride = 1)
	result_amount = 4
	mix_message = "The solution thickens into a sweet-smelling brown sauce."

/datum/chemical_reaction/recipe/garlicsauce
	name = "Garlic Sauce"
	result = /decl/reagent/nutriment/garlicsauce
	required_reagents = list(/decl/reagent/drink/juice/garlic = 1, /decl/reagent/nutriment/cornoil = 1)
	result_amount = 2
	mix_message = "The solution thickens into a creamy white oil."

//batter reaction as food precursor, for things that don't use pliable dough precursor.
/datum/chemical_reaction/recipe/batter
	name = "Batter"
	result = /decl/reagent/nutriment/batter
	required_reagents = list(/decl/reagent/nutriment/protein/egg = 3, /decl/reagent/nutriment/flour = 5, /decl/reagent/drink/milk = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy batter."

/datum/chemical_reaction/recipe/cakebatter
	name = "Cake Batter"
	result = /decl/reagent/nutriment/batter/cakebatter
	required_reagents = list(/decl/reagent/nutriment/sugar = 1, /decl/reagent/nutriment/batter = 2)
	result_amount = 3
	mix_message = "The sugar lightens the batter and gives it a sweet smell."

/datum/chemical_reaction/recipe/soybatter
	name = "Vegan Batter"
	result = /decl/reagent/nutriment/batter
	required_reagents = list(/decl/reagent/nutriment/plant_protein = 3, /decl/reagent/nutriment/flour = 5, /decl/reagent/drink/milk = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy batter."

/datum/chemical_reaction/recipe/vinegar
	name = "Apple Vinegar"
	result = /decl/reagent/nutriment/vinegar
	required_reagents = list(/decl/reagent/drink/juice/apple = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a sharp-smelling liquid."

/datum/chemical_reaction/recipe/vinegar2
	name = "Clear Vinegar"
	result = /decl/reagent/nutriment/vinegar
	required_reagents = list(/decl/reagent/ethanol = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a sharp-smelling liquid."

/datum/chemical_reaction/recipe/mayo
	name = "Vinegar Mayo"
	result = /decl/reagent/nutriment/mayo
	required_reagents = list(/decl/reagent/nutriment/vinegar = 5, /decl/reagent/nutriment/protein/egg = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy, creamy substance."

/datum/chemical_reaction/recipe/mayo2
	name = "Lemon Mayo"
	result = /decl/reagent/nutriment/mayo
	required_reagents = list(/decl/reagent/drink/juice/lemon = 5, /decl/reagent/nutriment/protein/egg = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy, creamy substance."

/datum/chemical_reaction/recipe/hot_ramen
	name = "Hot Ramen"
	result = /decl/reagent/drink/hot_ramen
	required_reagents = list(/decl/reagent/water = 1, /decl/reagent/drink/dry_ramen = 3)
	result_amount = 3
	mix_message = "The noodles soften in the hot water, releasing savoury steam."
	hidden_from_codex = TRUE

/datum/chemical_reaction/recipe/hell_ramen
	name = "Hell Ramen"
	result = /decl/reagent/drink/hell_ramen
	required_reagents = list(/decl/reagent/capsaicin = 1, /decl/reagent/drink/hot_ramen = 6)
	result_amount = 6
	mix_message = "The broth of the noodles takes on a hellish red gleam."
	hidden_from_codex = TRUE

/datum/chemical_reaction/recipe/chazuke
	name = "Chazuke"
	result = /decl/reagent/nutriment/rice/chazuke
	required_reagents = list(/decl/reagent/nutriment/rice = 10, /decl/reagent/drink/tea/green = 1)
	result_amount = 10
	mix_message = "The tea mingles with the rice."
