/datum/chemical_reaction/recipe/soysauce
	name = "Vinegar Soy Sauce"
	result = /decl/material/chem/nutriment/soysauce
	required_reagents = list(/decl/material/chem/drink/milk/soymilk = 5, /decl/material/chem/nutriment/vinegar = 5)
	result_amount = 10
	mix_message = "The solution settles into a glossy black sauce."

/datum/chemical_reaction/recipe/soysauce_acid
	name = "Acid Soy Sauce"
	result = /decl/material/chem/nutriment/soysauce
	required_reagents = list(/decl/material/chem/drink/milk/soymilk = 4, /decl/material/chem/acid = 1)
	result_amount = 5
	mix_message = "The solution settles into a glossy black sauce."

/datum/chemical_reaction/recipe/ketchup
	name = "Ketchup"
	result = /decl/material/chem/nutriment/ketchup
	required_reagents = list(/decl/material/chem/drink/juice/tomato = 2, /decl/material/gas/water = 1, /decl/material/chem/nutriment/sugar = 1)
	result_amount = 4
	mix_message = "The solution thickens into a sweet-smelling red sauce."

/datum/chemical_reaction/recipe/banana_cream
	name = "Banana Cream"
	result = /decl/material/chem/nutriment/banana_cream
	catalysts = list(/decl/material/chem/enzyme = 5)
	required_reagents = list(/decl/material/chem/drink/juice/banana = 2, /decl/material/chem/drink/milk/cream = 1)
	result_amount = 3
	mix_message = "The solution thickens into a creamy banana-scented substance."

/datum/chemical_reaction/recipe/barbecue
	name = "Barbecue Sauce"
	result = /decl/material/chem/nutriment/barbecue
	required_reagents = list(/decl/material/chem/nutriment/ketchup = 2, /decl/material/chem/blackpepper = 1, /decl/material/sodium_chloride = 1)
	result_amount = 4
	mix_message = "The solution thickens into a sweet-smelling brown sauce."

/datum/chemical_reaction/recipe/garlicsauce
	name = "Garlic Sauce"
	result = /decl/material/chem/nutriment/garlicsauce
	required_reagents = list(/decl/material/chem/drink/juice/garlic = 1, /decl/material/chem/nutriment/cornoil = 1)
	result_amount = 2
	mix_message = "The solution thickens into a creamy white oil."

//batter reaction as food precursor, for things that don't use pliable dough precursor.
/datum/chemical_reaction/recipe/batter
	name = "Batter"
	result = /decl/material/chem/nutriment/batter
	required_reagents = list(/decl/material/chem/nutriment/protein/egg = 3, /decl/material/chem/nutriment/flour = 5, /decl/material/chem/drink/milk = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy batter."

/datum/chemical_reaction/recipe/cakebatter
	name = "Cake Batter"
	result = /decl/material/chem/nutriment/batter/cakebatter
	required_reagents = list(/decl/material/chem/nutriment/sugar = 1, /decl/material/chem/nutriment/batter = 2)
	result_amount = 3
	mix_message = "The sugar lightens the batter and gives it a sweet smell."

/datum/chemical_reaction/recipe/soybatter
	name = "Vegan Batter"
	result = /decl/material/chem/nutriment/batter
	required_reagents = list(/decl/material/chem/nutriment/plant_protein = 3, /decl/material/chem/nutriment/flour = 5, /decl/material/chem/drink/milk = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy batter."

/datum/chemical_reaction/recipe/vinegar
	name = "Apple Vinegar"
	result = /decl/material/chem/nutriment/vinegar
	required_reagents = list(/decl/material/chem/drink/juice/apple = 10)
	catalysts = list(/decl/material/chem/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a sharp-smelling liquid."

/datum/chemical_reaction/recipe/vinegar2
	name = "Clear Vinegar"
	result = /decl/material/chem/nutriment/vinegar
	required_reagents = list(/decl/material/chem/ethanol = 10)
	catalysts = list(/decl/material/chem/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a sharp-smelling liquid."

/datum/chemical_reaction/recipe/mayo
	name = "Vinegar Mayo"
	result = /decl/material/chem/nutriment/mayo
	required_reagents = list(/decl/material/chem/nutriment/vinegar = 5, /decl/material/chem/nutriment/protein/egg = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy, creamy substance."

/datum/chemical_reaction/recipe/mayo2
	name = "Lemon Mayo"
	result = /decl/material/chem/nutriment/mayo
	required_reagents = list(/decl/material/chem/drink/juice/lemon = 5, /decl/material/chem/nutriment/protein/egg = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy, creamy substance."

/datum/chemical_reaction/recipe/hot_ramen
	name = "Hot Ramen"
	result = /decl/material/chem/drink/hot_ramen
	required_reagents = list(/decl/material/gas/water = 1, /decl/material/chem/drink/dry_ramen = 3)
	result_amount = 3
	mix_message = "The noodles soften in the hot water, releasing savoury steam."
	hidden_from_codex = TRUE

/datum/chemical_reaction/recipe/hell_ramen
	name = "Hell Ramen"
	result = /decl/material/chem/drink/hell_ramen
	required_reagents = list(/decl/material/chem/capsaicin = 1, /decl/material/chem/drink/hot_ramen = 6)
	result_amount = 6
	mix_message = "The broth of the noodles takes on a hellish red gleam."
	hidden_from_codex = TRUE

/datum/chemical_reaction/recipe/chazuke
	name = "Chazuke"
	result = /decl/material/chem/nutriment/rice/chazuke
	required_reagents = list(/decl/material/chem/nutriment/rice = 10, /decl/material/chem/drink/tea/green = 1)
	result_amount = 10
	mix_message = "The tea mingles with the rice."
