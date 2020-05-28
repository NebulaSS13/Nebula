/datum/chemical_reaction/recipe/moonshine
	name = "Moonshine"
	result = /decl/material/chem/ethanol/moonshine
	required_reagents = list(/decl/material/chem/nutriment = 10)
	catalysts = list(/decl/material/chem/enzyme = 5)
	result_amount = 10
	mix_message = "The solution exudes the powerful reek of raw alcohol."

/datum/chemical_reaction/recipe/grenadine
	name = "Grenadine Syrup"
	result = /decl/material/chem/drink/grenadine
	required_reagents = list(/decl/material/chem/drink/juice/berry = 10)
	catalysts = list(/decl/material/chem/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/recipe/wine
	name = "Wine"
	result = /decl/material/chem/ethanol/wine
	required_reagents = list(/decl/material/chem/drink/juice/grape = 10)
	catalysts = list(/decl/material/chem/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a rich red liquid."

/datum/chemical_reaction/recipe/pwine
	name = "Poison Wine"
	result = /decl/material/chem/ethanol/pwine
	required_reagents = list(/decl/material/chem/toxin/poisonberryjuice = 10)
	catalysts = list(/decl/material/chem/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a shifting purple liquid."

/datum/chemical_reaction/recipe/melonliquor
	name = "Melon Liquor"
	result = /decl/material/chem/ethanol/melonliquor
	required_reagents = list(/decl/material/chem/drink/juice/watermelon = 10)
	catalysts = list(/decl/material/chem/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a pale liquor."

/datum/chemical_reaction/recipe/bluecuracao
	name = "Blue Curacao"
	result = /decl/material/chem/ethanol/bluecuracao
	required_reagents = list(/decl/material/chem/drink/juice/orange = 10)
	catalysts = list(/decl/material/chem/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a shockingly blue liquor."

/datum/chemical_reaction/recipe/beer
	name = "Beer"
	result = /decl/material/chem/ethanol/beer
	required_reagents = list(/decl/material/chem/nutriment/cornoil = 10)
	catalysts = list(/decl/material/chem/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a foaming amber liquid."

/datum/chemical_reaction/recipe/vodka
	name = "Potato Vodka"
	result = /decl/material/chem/ethanol/vodka
	required_reagents = list(/decl/material/chem/drink/juice/potato = 10)
	catalysts = list(/decl/material/chem/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/datum/chemical_reaction/recipe/vodka2
	name = "Turnip Vodka"
	result = /decl/material/chem/ethanol/vodka
	required_reagents = list(/decl/material/chem/drink/juice/turnip = 10)
	catalysts = list(/decl/material/chem/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/datum/chemical_reaction/recipe/sake
	name = "Sake"
	result = /decl/material/chem/ethanol/sake
	required_reagents = list(/decl/material/chem/nutriment/rice = 10)
	catalysts = list(/decl/material/chem/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/datum/chemical_reaction/recipe/kahlua
	name = "Kahlua"
	result = /decl/material/chem/ethanol/coffee/kahlua
	required_reagents = list(/decl/material/chem/drink/coffee = 5, /decl/material/chem/nutriment/sugar = 5)
	catalysts = list(/decl/material/chem/enzyme = 5)
	result_amount = 5
	mix_message = "The solution roils as it rapidly ferments into a rich brown liquid."

/datum/chemical_reaction/recipe/irish_cream
	name = "Irish Cream"
	result = /decl/material/chem/ethanol/irish_cream
	required_reagents = list(/decl/material/chem/ethanol/whiskey = 2, /decl/material/chem/drink/milk/cream = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/hooch
	name = "Hooch"
	result = /decl/material/chem/ethanol/hooch
	required_reagents = list (/decl/material/chem/nutriment/sugar = 1, /decl/material/chem/ethanol = 2, /decl/material/chem/fuel = 1)
	minimum_temperature = 30 CELSIUS
	maximum_temperature = (30 CELSIUS) + 100
	result_amount = 3

/datum/chemical_reaction/recipe/mead
	name = "Mead"
	result = /decl/material/chem/ethanol/mead
	required_reagents = list(/decl/material/chem/nutriment/honey = 1, /decl/material/gas/water = 1)
	catalysts = list(/decl/material/chem/enzyme = 5)
	result_amount = 2

/datum/chemical_reaction/recipe/rum
	name = "Rum"
	result = /decl/material/chem/ethanol/rum
	required_reagents = list(/decl/material/chem/nutriment/sugar = 1, /decl/material/gas/water = 1)
	catalysts = list(/decl/material/chem/enzyme = 5)
	result_amount = 2
	mix_message = "The solution roils as it rapidly ferments into a red-brown liquid."

/datum/chemical_reaction/recipe/applecider
	name = "Apple Cider"
	result = /decl/material/chem/ethanol/applecider
	required_reagents = list(/decl/material/chem/drink/juice/apple = 2, /decl/material/chem/nutriment/sugar = 1)
	catalysts = list(/decl/material/chem/nutriment = 5)
	result_amount = 3

/datum/chemical_reaction/recipe/kvass
	name = "Kvass"
	result = /decl/material/chem/ethanol/kvass
	required_reagents = list(/decl/material/chem/nutriment/sugar = 1, /decl/material/chem/ethanol/beer = 1)
	catalysts = list(/decl/material/chem/enzyme = 5)
	result_amount = 3