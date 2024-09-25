/decl/chemical_reaction/recipe
	abstract_type = /decl/chemical_reaction/recipe
	reaction_category = REACTION_TYPE_RECIPE

/decl/chemical_reaction/recipe/enzyme
	name = "Universal Enzyme"
	required_reagents = list(
		/decl/material/liquid/enzyme/rennet = 1,
		/decl/material/liquid/acid/polyacid = 1
	)
	minimum_temperature = 100 CELSIUS
	result = /decl/material/liquid/enzyme
	result_amount = 2

/decl/chemical_reaction/recipe/moonshine
	name = "Moonshine"
	result = /decl/material/liquid/ethanol/moonshine
	required_reagents = list(/decl/material/liquid/nutriment = 10)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	result_amount = 10
	mix_message = "The solution exudes the powerful reek of raw alcohol."

/decl/chemical_reaction/recipe/grenadine
	name = "Grenadine Syrup"
	result = /decl/material/liquid/drink/grenadine
	required_reagents = list(/decl/material/liquid/drink/juice/berry = 10)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	result_amount = 10

/decl/chemical_reaction/recipe/wine
	name = "Red Wine"
	result = /decl/material/liquid/ethanol/wine
	required_reagents = list(/decl/material/liquid/drink/juice/grape = 10)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a rich red liquid."

/decl/chemical_reaction/recipe/pwine
	name = "Poison Wine"
	result = /decl/material/liquid/ethanol/pwine
	required_reagents = list(/decl/material/liquid/poisonberryjuice = 10)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a shifting purple liquid."

/decl/chemical_reaction/recipe/melonliquor
	name = "Melon Liquor"
	result = /decl/material/liquid/ethanol/melonliquor
	required_reagents = list(/decl/material/liquid/drink/juice/watermelon = 10)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a pale liquor."

/decl/chemical_reaction/recipe/bluecuracao
	name = "Blue Curacao"
	result = /decl/material/liquid/ethanol/bluecuracao
	required_reagents = list(/decl/material/liquid/drink/juice/orange = 10)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a shockingly blue liquor."

/decl/chemical_reaction/recipe/beer
	name = "Plain Beer"
	result = /decl/material/liquid/ethanol/beer
	required_reagents = list(/decl/material/liquid/nutriment/cornoil = 10)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a foaming amber liquid."

/decl/chemical_reaction/recipe/vodka
	name = "Potato Vodka"
	result = /decl/material/liquid/ethanol/vodka
	required_reagents = list(/decl/material/liquid/drink/juice/potato = 10)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/decl/chemical_reaction/recipe/vodka2
	name = "Turnip Vodka"
	result = /decl/material/liquid/ethanol/vodka
	required_reagents = list(/decl/material/liquid/drink/juice/turnip = 10)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/decl/chemical_reaction/recipe/sake
	name = "Sake"
	result = /decl/material/liquid/ethanol/sake
	required_reagents = list(/decl/material/liquid/nutriment/rice = 10)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/decl/chemical_reaction/recipe/kahlua
	name = "Kahlua"
	result = /decl/material/liquid/ethanol/coffee
	required_reagents = list(/decl/material/liquid/drink/coffee = 5, /decl/material/liquid/nutriment/sugar = 5)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	result_amount = 5
	mix_message = "The solution roils as it rapidly ferments into a rich brown liquid."

/decl/chemical_reaction/recipe/irish_cream
	name = "Irish Cream"
	result = /decl/material/liquid/ethanol/irish_cream
	required_reagents = list(/decl/material/liquid/ethanol/whiskey = 2, /decl/material/liquid/drink/milk/cream = 1)
	result_amount = 3

/decl/chemical_reaction/recipe/hooch
	name = "Hooch"
	result = /decl/material/liquid/ethanol/hooch
	required_reagents = list (/decl/material/liquid/nutriment/sugar = 1, /decl/material/liquid/ethanol = 2, /decl/material/liquid/fuel = 1)
	minimum_temperature = 30 CELSIUS
	maximum_temperature = (30 CELSIUS) + 100
	result_amount = 3

/decl/chemical_reaction/recipe/mead
	name = "Mead"
	result = /decl/material/liquid/ethanol/mead
	required_reagents = list(/decl/material/liquid/nutriment/honey = 1, /decl/material/liquid/water = 1)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	result_amount = 2

/decl/chemical_reaction/recipe/rum
	name = "Dark Rum"
	result = /decl/material/liquid/ethanol/rum
	required_reagents = list(/decl/material/liquid/nutriment/sugar = 1, /decl/material/liquid/water = 1)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	result_amount = 2
	mix_message = "The solution roils as it rapidly ferments into a red-brown liquid."

/decl/chemical_reaction/recipe/cider_apple
	name = "Apple Cider"
	result = /decl/material/liquid/ethanol/cider_apple
	required_reagents = list(/decl/material/liquid/drink/juice/apple = 2, /decl/material/liquid/nutriment/sugar = 1)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	result_amount = 3

/decl/chemical_reaction/recipe/cider_pear
	name = "Pear Cider"
	result = /decl/material/liquid/ethanol/cider_pear
	required_reagents = list(/decl/material/liquid/drink/juice/pear = 2, /decl/material/liquid/nutriment/sugar = 1)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	result_amount = 3

/decl/chemical_reaction/recipe/kvass
	name = "Kvass"
	result = /decl/material/liquid/ethanol/kvass
	required_reagents = list(/decl/material/liquid/nutriment/sugar = 1, /decl/material/liquid/ethanol/beer = 1)
	catalysts = list(/decl/material/liquid/enzyme = 5)
	result_amount = 3
