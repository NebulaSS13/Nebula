/decl/chemical_reaction/recipe/soysauce
	name = "Vinegar Soy Sauce"
	result = /decl/material/liquid/nutriment/soysauce
	required_reagents = list(/decl/material/liquid/drink/milk/soymilk = 5, /decl/material/liquid/nutriment/vinegar = 5)
	result_amount = 10
	mix_message = "The solution settles into a glossy black sauce."

/decl/chemical_reaction/recipe/soysauce_acid
	name = "Acid Soy Sauce"
	result = /decl/material/liquid/nutriment/soysauce
	required_reagents = list(/decl/material/liquid/drink/milk/soymilk = 4, /decl/material/liquid/acid = 1)
	result_amount = 5
	mix_message = "The solution settles into a glossy black sauce."

/decl/chemical_reaction/recipe/ketchup
	name = "Ketchup"
	result = /decl/material/liquid/nutriment/ketchup
	required_reagents = list(/decl/material/liquid/drink/juice/tomato = 2, /decl/material/liquid/water = 1, /decl/material/liquid/nutriment/sugar = 1)
	result_amount = 4
	mix_message = "The solution thickens into a sweet-smelling red sauce."

/decl/chemical_reaction/recipe/banana_cream
	name = "Banana Cream"
	result = /decl/material/liquid/nutriment/banana_cream
	catalysts = list(/decl/material/liquid/enzyme = 5)
	required_reagents = list(/decl/material/liquid/drink/juice/banana = 2, /decl/material/liquid/drink/milk/cream = 1)
	result_amount = 3
	mix_message = "The solution thickens into a creamy banana-scented substance."

/decl/chemical_reaction/recipe/barbecue
	name = "Barbecue Sauce"
	result = /decl/material/liquid/nutriment/barbecue
	required_reagents = list(/decl/material/liquid/nutriment/ketchup = 2, /decl/material/solid/blackpepper = 1, /decl/material/solid/sodiumchloride = 1)
	result_amount = 4
	mix_message = "The solution thickens into a sweet-smelling brown sauce."

/decl/chemical_reaction/recipe/garlicsauce
	name = "Garlic Sauce"
	result = /decl/material/liquid/nutriment/garlicsauce
	required_reagents = list(/decl/material/liquid/drink/juice/garlic = 1, /decl/material/liquid/nutriment/cornoil = 1)
	result_amount = 2
	mix_message = "The solution thickens into a creamy white oil."

//batter reaction as food precursor, for things that don't use pliable dough precursor.
/decl/chemical_reaction/recipe/batter
	name = "Plain Batter"
	result = /decl/material/liquid/nutriment/batter
	required_reagents = list(
		/decl/material/solid/organic/meat/egg = 3,
		/decl/material/liquid/nutriment/flour = 5,
		/decl/material/liquid/drink/milk      = 5
	)
	result_amount = 10
	mix_message = "The solution thickens into a glossy batter."

/decl/chemical_reaction/recipe/cakebatter
	name = "Cake Batter"
	result = /decl/material/liquid/nutriment/batter/cakebatter
	required_reagents = list(/decl/material/liquid/nutriment/sugar = 1, /decl/material/liquid/nutriment/batter = 2)
	result_amount = 3
	mix_message = "The sugar lightens the batter and gives it a sweet smell."

/decl/chemical_reaction/recipe/soybatter
	name = "Vegan Batter"
	result = /decl/material/liquid/nutriment/batter
	required_reagents = list(/decl/material/liquid/nutriment/plant_protein = 3, /decl/material/liquid/nutriment/flour = 5, /decl/material/liquid/drink/milk = 5)
	result_amount = 10
	mix_message = "The solution thickens into a glossy batter."

/decl/chemical_reaction/recipe/vinegar
	name = "Apple Vinegar"
	result = /decl/material/liquid/nutriment/vinegar
	required_reagents = list(/decl/material/liquid/drink/juice/apple = 10)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	inhibitors = list(/decl/material/liquid/nutriment/sugar = 1)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a sharp-smelling liquid."

/decl/chemical_reaction/recipe/vinegar2
	name = "Clear Vinegar"
	result = /decl/material/liquid/nutriment/vinegar
	required_reagents = list(/decl/material/liquid/ethanol = 10)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a sharp-smelling liquid."

/decl/chemical_reaction/recipe/mayo
	name = "Vinegar Mayo"
	result = /decl/material/liquid/nutriment/mayo
	required_reagents = list(
		/decl/material/liquid/nutriment/vinegar = 5,
		/decl/material/solid/organic/meat/egg   = 5
	)
	result_amount = 10
	mix_message = "The solution thickens into a glossy, creamy substance."

/decl/chemical_reaction/recipe/mayo2
	name = "Lemon Mayo"
	result = /decl/material/liquid/nutriment/mayo
	required_reagents = list(
		/decl/material/liquid/drink/juice/lemon = 5,
		/decl/material/solid/organic/meat/egg   = 5
	)
	result_amount = 10
	mix_message = "The solution thickens into a glossy, creamy substance."

/decl/chemical_reaction/recipe/hot_ramen
	name = "Hot Ramen"
	result = /decl/material/liquid/drink/hot_ramen
	required_reagents = list(/decl/material/liquid/water = 1, /decl/material/liquid/drink/dry_ramen = 3)
	result_amount = 3
	mix_message = "The noodles soften in the hot water, releasing savoury steam."
	hidden_from_codex = TRUE

/decl/chemical_reaction/recipe/hell_ramen
	name = "Hell Ramen"
	result = /decl/material/liquid/drink/hell_ramen
	required_reagents = list(/decl/material/liquid/capsaicin = 1, /decl/material/liquid/drink/hot_ramen = 6)
	result_amount = 6
	mix_message = "The broth of the noodles takes on a hellish red gleam."
	hidden_from_codex = TRUE
