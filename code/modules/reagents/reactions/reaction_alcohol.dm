/datum/chemical_reaction/recipe/moonshine
	name = "Moonshine"
	result = /decl/reagent/ethanol/moonshine
	required_reagents = list(/decl/reagent/nutriment = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution exudes the powerful reek of raw alcohol."

/datum/chemical_reaction/recipe/grenadine
	name = "Grenadine Syrup"
	result = /decl/reagent/drink/grenadine
	required_reagents = list(/decl/reagent/drink/juice/berry = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/recipe/wine
	name = "Wine"
	result = /decl/reagent/ethanol/wine
	required_reagents = list(/decl/reagent/drink/juice/grape = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a rich red liquid."

/datum/chemical_reaction/recipe/pwine
	name = "Poison Wine"
	result = /decl/reagent/ethanol/pwine
	required_reagents = list(/decl/reagent/toxin/poisonberryjuice = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a shifting purple liquid."

/datum/chemical_reaction/recipe/melonliquor
	name = "Melon Liquor"
	result = /decl/reagent/ethanol/melonliquor
	required_reagents = list(/decl/reagent/drink/juice/watermelon = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a pale liquor."

/datum/chemical_reaction/recipe/bluecuracao
	name = "Blue Curacao"
	result = /decl/reagent/ethanol/bluecuracao
	required_reagents = list(/decl/reagent/drink/juice/orange = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a shockingly blue liquor."

/datum/chemical_reaction/recipe/beer
	name = "Beer"
	result = /decl/reagent/ethanol/beer
	required_reagents = list(/decl/reagent/nutriment/cornoil = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a foaming amber liquid."

/datum/chemical_reaction/recipe/vodka
	name = "Potato Vodka"
	result = /decl/reagent/ethanol/vodka
	required_reagents = list(/decl/reagent/drink/juice/potato = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/datum/chemical_reaction/recipe/vodka2
	name = "Turnip Vodka"
	result = /decl/reagent/ethanol/vodka
	required_reagents = list(/decl/reagent/drink/juice/turnip = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/datum/chemical_reaction/recipe/sake
	name = "Sake"
	result = /decl/reagent/ethanol/sake
	required_reagents = list(/decl/reagent/nutriment/rice = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/datum/chemical_reaction/recipe/kahlua
	name = "Kahlua"
	result = /decl/reagent/ethanol/coffee/kahlua
	required_reagents = list(/decl/reagent/drink/coffee = 5, /decl/reagent/nutriment/sugar = 5)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 5
	mix_message = "The solution roils as it rapidly ferments into a rich brown liquid."

/datum/chemical_reaction/recipe/irish_cream
	name = "Irish Cream"
	result = /decl/reagent/ethanol/irish_cream
	required_reagents = list(/decl/reagent/ethanol/whiskey = 2, /decl/reagent/drink/milk/cream = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/hooch
	name = "Hooch"
	result = /decl/reagent/ethanol/hooch
	required_reagents = list (/decl/reagent/nutriment/sugar = 1, /decl/reagent/ethanol = 2, /decl/reagent/fuel = 1)
	minimum_temperature = 30 CELSIUS
	maximum_temperature = (30 CELSIUS) + 100
	result_amount = 3

/datum/chemical_reaction/recipe/mead
	name = "Mead"
	result = /decl/reagent/ethanol/mead
	required_reagents = list(/decl/reagent/nutriment/honey = 1, /decl/reagent/water = 1)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 2

/datum/chemical_reaction/recipe/rum
	name = "Rum"
	result = /decl/reagent/ethanol/rum
	required_reagents = list(/decl/reagent/nutriment/sugar = 1, /decl/reagent/water = 1)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 2
	mix_message = "The solution roils as it rapidly ferments into a red-brown liquid."

/datum/chemical_reaction/recipe/applecider
	name = "Apple Cider"
	result = /decl/reagent/ethanol/applecider
	required_reagents = list(/decl/reagent/drink/juice/apple = 2, /decl/reagent/nutriment/sugar = 1)
	catalysts = list(/decl/reagent/nutriment = 5)
	result_amount = 3

/datum/chemical_reaction/recipe/kvass
	name = "Kvass"
	result = /decl/reagent/ethanol/kvass
	required_reagents = list(/decl/reagent/nutriment/sugar = 1, /decl/reagent/ethanol/beer = 1)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 3