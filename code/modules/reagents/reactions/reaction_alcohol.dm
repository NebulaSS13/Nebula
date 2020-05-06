/datum/chemical_reaction/recipe/goldschlager
	name = "Goldschlager"
	result = /decl/material/ethanol/goldschlager
	required_reagents = list(
		/decl/material/ethanol/vodka = 10, 
		MAT_GOLD = 1
	)
	result_amount = 10
	mix_message = "The gold flakes and settles in the vodka."

/datum/chemical_reaction/recipe/patron
	name = "Patron"
	result = /decl/material/ethanol/patron
	required_reagents = list(
		/decl/material/ethanol/tequilla = 10, 
		MAT_SILVER = 1
	)
	result_amount = 10
	mix_message = "The silver flakes and settles in the tequila."

/datum/chemical_reaction/recipe/bilk
	name = "Bilk"
	result = /decl/material/ethanol/bilk
	required_reagents = list(/decl/material/drink/milk = 1, /decl/material/ethanol/beer = 1)
	result_amount = 2
	mix_message = "The solution takes on an unpleasant, thick, brown appearance."

/datum/chemical_reaction/recipe/moonshine
	name = "Moonshine"
	result = /decl/material/ethanol/moonshine
	required_reagents = list(/decl/material/nutriment = 10)
	catalysts = list(/decl/material/enzyme = 5)
	result_amount = 10
	mix_message = "The solution exudes the powerful reek of raw alcohol."

/datum/chemical_reaction/recipe/grenadine
	name = "Grenadine Syrup"
	result = /decl/material/drink/grenadine
	required_reagents = list(/decl/material/drink/juice/berry = 10)
	catalysts = list(/decl/material/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/recipe/wine
	name = "Wine"
	result = /decl/material/ethanol/wine
	required_reagents = list(/decl/material/drink/juice/grape = 10)
	catalysts = list(/decl/material/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a rich red liquid."

/datum/chemical_reaction/recipe/pwine
	name = "Poison Wine"
	result = /decl/material/ethanol/pwine
	required_reagents = list(/decl/material/toxin/poisonberryjuice = 10)
	catalysts = list(/decl/material/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a shifting purple liquid."

/datum/chemical_reaction/recipe/melonliquor
	name = "Melon Liquor"
	result = /decl/material/ethanol/melonliquor
	required_reagents = list(/decl/material/drink/juice/watermelon = 10)
	catalysts = list(/decl/material/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a pale liquor."

/datum/chemical_reaction/recipe/bluecuracao
	name = "Blue Curacao"
	result = /decl/material/ethanol/bluecuracao
	required_reagents = list(/decl/material/drink/juice/orange = 10)
	catalysts = list(/decl/material/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a shockingly blue liquor."

/datum/chemical_reaction/recipe/spacebeer
	name = "Space Beer"
	result = /decl/material/ethanol/beer
	required_reagents = list(/decl/material/nutriment/cornoil = 10)
	catalysts = list(/decl/material/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a foaming amber liquid."

/datum/chemical_reaction/recipe/vodka
	name = "Vodka"
	result = /decl/material/ethanol/vodka
	required_reagents = list(/decl/material/drink/juice/potato = 10)
	catalysts = list(/decl/material/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/datum/chemical_reaction/recipe/vodka2
	name = "Vodka"
	result = /decl/material/ethanol/vodka
	required_reagents = list(/decl/material/drink/juice/turnip = 10)
	catalysts = list(/decl/material/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/datum/chemical_reaction/recipe/sake
	name = "Sake"
	result = /decl/material/ethanol/sake
	required_reagents = list(/decl/material/nutriment/rice = 10)
	catalysts = list(/decl/material/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/datum/chemical_reaction/recipe/kahlua
	name = "Kahlua"
	result = /decl/material/ethanol/coffee/kahlua
	required_reagents = list(/decl/material/drink/coffee = 5, /decl/material/nutriment/sugar = 5)
	catalysts = list(/decl/material/enzyme = 5)
	result_amount = 5
	mix_message = "The solution roils as it rapidly ferments into a rich brown liquid."

/datum/chemical_reaction/recipe/gin_tonic
	name = "Gin and Tonic"
	result = /decl/material/ethanol/gintonic
	required_reagents = list(/decl/material/ethanol/gin = 2, /decl/material/drink/tonic = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/cuba_libre
	name = "Cuba Libre"
	result = /decl/material/ethanol/cuba_libre
	required_reagents = list(/decl/material/ethanol/rum = 2, /decl/material/drink/cola = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/martini
	name = "Classic Martini"
	result = /decl/material/ethanol/martini
	required_reagents = list(/decl/material/ethanol/gin = 2, /decl/material/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/vodkamartini
	name = "Vodka Martini"
	result = /decl/material/ethanol/vodkamartini
	required_reagents = list(/decl/material/ethanol/vodka = 2, /decl/material/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/white_russian
	name = "White Russian"
	result = /decl/material/ethanol/white_russian
	required_reagents = list(/decl/material/ethanol/black_russian = 2, /decl/material/drink/milk/cream = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/whiskey_cola
	name = "Whiskey Cola"
	result = /decl/material/ethanol/whiskey_cola
	required_reagents = list(/decl/material/ethanol/whiskey = 2, /decl/material/drink/cola = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/screwdriver
	name = "Screwdriver"
	result = /decl/material/ethanol/screwdrivercocktail
	required_reagents = list(/decl/material/ethanol/vodka = 2, /decl/material/drink/juice/orange = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/bloody_mary
	name = "Bloody Mary"
	result = /decl/material/ethanol/bloody_mary
	required_reagents = list(/decl/material/ethanol/vodka = 2, /decl/material/drink/juice/tomato = 3, /decl/material/drink/juice/lime = 1)
	result_amount = 6

/datum/chemical_reaction/recipe/livergeist
	name = "The Livergeist"
	result = /decl/material/ethanol/livergeist
	required_reagents = list(/decl/material/ethanol/vodka = 2, /decl/material/ethanol/gin = 1, /decl/material/ethanol/aged_whiskey = 1, /decl/material/ethanol/cognac = 1, /decl/material/drink/juice/lime = 1)
	result_amount = 6

/datum/chemical_reaction/recipe/brave_bull
	name = "Brave Bull"
	result = /decl/material/ethanol/coffee/brave_bull
	required_reagents = list(/decl/material/ethanol/tequilla = 2, /decl/material/ethanol/coffee/kahlua = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/tequilla_sunrise
	name = "Tequilla Sunrise"
	result = /decl/material/ethanol/tequilla_sunrise
	required_reagents = list(/decl/material/ethanol/tequilla = 2, /decl/material/drink/juice/orange = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/phoron_special
	name = "Toxins Special"
	result = /decl/material/ethanol/toxins_special
	required_reagents = list(
		/decl/material/ethanol/rum = 2, 
		/decl/material/ethanol/vermouth = 2, 
		MAT_PHORON = 2
	)
	result_amount = 6

/datum/chemical_reaction/recipe/beepsky_smash
	name = "Beepksy Smash"
	result = /decl/material/ethanol/beepsky_smash
	required_reagents = list(
		/decl/material/drink/juice/lime = 1, 
		/decl/material/ethanol/whiskey = 1, 
		MAT_IRON = 1
	)
	result_amount = 2

/datum/chemical_reaction/recipe/doctor_delight
	name = "The Doctor's Delight"
	result = /decl/material/drink/doctor_delight
	required_reagents = list(/decl/material/drink/juice/lime = 1, /decl/material/drink/juice/tomato = 1, /decl/material/drink/juice/orange = 1, /decl/material/drink/milk/cream = 2, /decl/material/regenerator = 1)
	result_amount = 6

/datum/chemical_reaction/recipe/irish_cream
	name = "Irish Cream"
	result = /decl/material/ethanol/irish_cream
	required_reagents = list(/decl/material/ethanol/whiskey = 2, /decl/material/drink/milk/cream = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/manly_dorf
	name = "The Manly Dorf"
	result = /decl/material/ethanol/manly_dorf
	required_reagents = list (/decl/material/ethanol/beer = 1, /decl/material/ethanol/ale = 2)
	result_amount = 3

/datum/chemical_reaction/recipe/hooch
	name = "Hooch"
	result = /decl/material/ethanol/hooch
	required_reagents = list (
		/decl/material/nutriment/sugar = 1, 
		/decl/material/ethanol = 2, 
		MAT_FUEL = 1
	)
	minimum_temperature = 30 CELSIUS
	maximum_temperature = (30 CELSIUS) + 100
	result_amount = 3

/datum/chemical_reaction/recipe/irish_coffee
	name = "Irish Coffee"
	result = /decl/material/ethanol/coffee/irishcoffee
	required_reagents = list(/decl/material/ethanol/irish_cream = 1, /decl/material/drink/coffee = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/b52
	name = "B-52"
	result = /decl/material/ethanol/coffee/b52
	required_reagents = list(/decl/material/ethanol/irish_cream = 1, /decl/material/ethanol/coffee/kahlua = 1, /decl/material/ethanol/cognac = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/atomicbomb
	name = "Atomic Bomb"
	result = /decl/material/ethanol/atomicbomb
	required_reagents = list(
		/decl/material/ethanol/coffee/b52 = 10,
		MAT_URANIUM = 1
	)
	result_amount = 10

/datum/chemical_reaction/recipe/margarita
	name = "Margarita"
	result = /decl/material/ethanol/margarita
	required_reagents = list(/decl/material/ethanol/tequilla = 2, /decl/material/drink/juice/lime = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/longislandicedtea
	name = "Long Island Iced Tea"
	result = /decl/material/ethanol/longislandicedtea
	required_reagents = list(/decl/material/ethanol/vodka = 1, /decl/material/ethanol/gin = 1, /decl/material/ethanol/tequilla = 1, /decl/material/ethanol/cuba_libre = 3)
	result_amount = 6

/datum/chemical_reaction/recipe/threemileisland
	name = "Three Mile Island Iced Tea"
	result = /decl/material/ethanol/threemileisland
	required_reagents = list(
		/decl/material/ethanol/longislandicedtea = 10, 
		MAT_URANIUM = 1
	)
	result_amount = 10

/datum/chemical_reaction/recipe/whiskeysoda
	name = "Whiskey Soda"
	result = /decl/material/ethanol/whiskeysoda
	required_reagents = list(/decl/material/ethanol/whiskey = 2, /decl/material/drink/sodawater = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/black_russian
	name = "Black Russian"
	result = /decl/material/ethanol/black_russian
	required_reagents = list(/decl/material/ethanol/vodka = 2, /decl/material/ethanol/coffee/kahlua = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/manhattan
	name = "Manhattan"
	result = /decl/material/ethanol/manhattan
	required_reagents = list(/decl/material/ethanol/whiskey = 2, /decl/material/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/manhattan_proj
	name = "Manhattan Project"
	result = /decl/material/ethanol/manhattan_proj
	required_reagents = list(
		/decl/material/ethanol/manhattan = 10, 
		MAT_URANIUM = 1
	)
	result_amount = 10

/datum/chemical_reaction/recipe/vodka_tonic
	name = "Vodka and Tonic"
	result = /decl/material/ethanol/vodkatonic
	required_reagents = list(/decl/material/ethanol/vodka = 2, /decl/material/drink/tonic = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/gin_fizz
	name = "Gin Fizz"
	result = /decl/material/ethanol/ginfizz
	required_reagents = list(/decl/material/ethanol/gin = 1, /decl/material/drink/sodawater = 1, /decl/material/drink/juice/lime = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/bahama_mama
	name = "Bahama Mama"
	result = /decl/material/ethanol/bahama_mama
	required_reagents = list(
		/decl/material/ethanol/rum = 2, 
		/decl/material/drink/juice/orange = 2, 
		/decl/material/drink/juice/lime = 1, 
		MAT_WATER = 1
	)
	result_amount = 6

/datum/chemical_reaction/recipe/singulo
	name = "Singulo"
	result = /decl/material/ethanol/singulo
	required_reagents = list(/decl/material/ethanol/vodka = 5, /decl/material/radium = 1, /decl/material/ethanol/wine = 5)
	result_amount = 10

/datum/chemical_reaction/recipe/alliescocktail
	name = "Allies Cocktail"
	result = /decl/material/ethanol/alliescocktail
	required_reagents = list(/decl/material/ethanol/vodkamartini = 1, /decl/material/ethanol/martini = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/demonsblood
	name = "Demon's Blood"
	result = /decl/material/ethanol/demonsblood
	required_reagents = list(/decl/material/ethanol/rum = 3, /decl/material/drink/citrussoda = 1, /decl/material/blood = 1, /decl/material/drink/cherrycola = 1)
	result_amount = 6

/datum/chemical_reaction/recipe/booger
	name = "Booger"
	result = /decl/material/ethanol/booger
	required_reagents = list(/decl/material/drink/milk/cream = 2, /decl/material/drink/juice/banana = 1, /decl/material/ethanol/rum = 1, /decl/material/drink/juice/watermelon = 1)
	result_amount = 5
	mix_message = "The solution thickens unpleasantly."

/datum/chemical_reaction/recipe/antifreeze
	name = "Anti-freeze"
	result = /decl/material/ethanol/antifreeze
	required_reagents = list(
		/decl/material/ethanol/vodka = 1, 
		/decl/material/drink/milk/cream = 1, 
		MAT_WATER = 1
	)
	minimum_temperature = (0 CELSIUS) - 100
	maximum_temperature = 0 CELSIUS
	result_amount = 3
	mix_message = "The solution thickens sluggishly."

/datum/chemical_reaction/recipe/barefoot
	name = "Barefoot"
	result = /decl/material/ethanol/barefoot
	required_reagents = list(/decl/material/drink/juice/berry = 1, /decl/material/drink/milk/cream = 1, /decl/material/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/sbiten
	name = "Sbiten"
	result = /decl/material/ethanol/sbiten
	required_reagents = list(/decl/material/ethanol/mead = 10, /decl/material/capsaicin = 1)
	result_amount = 10

/datum/chemical_reaction/recipe/red_mead
	name = "Red Mead"
	result = /decl/material/ethanol/red_mead
	required_reagents = list(/decl/material/blood = 1, /decl/material/ethanol/mead = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/mead
	name = "Mead"
	result = /decl/material/ethanol/mead
	required_reagents = list(
		/decl/material/nutriment/honey = 1, 
		MAT_WATER = 1
	)
	catalysts = list(/decl/material/enzyme = 5)
	result_amount = 2

/datum/chemical_reaction/recipe/iced_beer
	name = "Iced Beer"
	result = /decl/material/ethanol/iced_beer
	required_reagents = list(/decl/material/ethanol/beer = 10, /decl/material/frostoil = 1)
	result_amount = 10
	mix_message = "The solution chills rapidly, frost forming on its surface."

/datum/chemical_reaction/recipe/iced_beer2
	name = "Iced Beer"
	result = /decl/material/ethanol/iced_beer
	required_reagents = list(
		/decl/material/ethanol/beer = 5,
		MAT_WATER = 1
	)
	result_amount = 6
	mix_message = "The ice clinks together in the beer."

/datum/chemical_reaction/recipe/grog
	name = "Grog"
	result = /decl/material/ethanol/grog
	required_reagents = list(
		/decl/material/ethanol/rum = 1, 
		MAT_WATER = 1
	)
	result_amount = 2

/datum/chemical_reaction/recipe/acidspit
	name = "Acid Spit"
	result = /decl/material/ethanol/acid_spit
	required_reagents = list(
		MAT_ACID_SULPHURIC = 1, 
		/decl/material/ethanol/wine = 5
	)
	result_amount = 6
	mix_message = "The solution curdles into an unpleasant, slimy liquid."

/datum/chemical_reaction/recipe/amasec
	name = "Amasec"
	result = /decl/material/ethanol/amasec
	required_reagents = list(
		MAT_IRON = 1, 
		/decl/material/ethanol/wine = 5, 
		/decl/material/ethanol/vodka = 5
	)
	result_amount = 10

/datum/chemical_reaction/recipe/changelingsting
	name = "Changeling Sting"
	result = /decl/material/ethanol/changelingsting
	required_reagents = list(/decl/material/ethanol/screwdrivercocktail = 1, /decl/material/drink/juice/lime = 1, /decl/material/drink/juice/lemon = 1)
	result_amount = 3
	mix_message = "The solution begins to shift and change colour."

/datum/chemical_reaction/recipe/aloe
	name = "Aloe"
	result = /decl/material/ethanol/aloe
	required_reagents = list(/decl/material/drink/milk/cream = 1, /decl/material/ethanol/aged_whiskey = 1, /decl/material/drink/juice/watermelon = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/andalusia
	name = "Andalusia"
	result = /decl/material/ethanol/andalusia
	required_reagents = list(/decl/material/ethanol/rum = 1, /decl/material/ethanol/whiskey = 1, /decl/material/drink/juice/lemon = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/neurotoxin
	name = "Neurotoxin"
	result = /decl/material/ethanol/neurotoxin
	required_reagents = list(/decl/material/ethanol/livergeist = 1, /decl/material/sedatives = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/snowwhite
	name = "Snow White"
	result = /decl/material/ethanol/snowwhite
	required_reagents = list(/decl/material/ethanol/beer = 1, /decl/material/drink/lemon_lime = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/irishslammer
	name = "Irish Slammer"
	result = /decl/material/ethanol/irishslammer
	required_reagents = list(/decl/material/ethanol/ale = 1, /decl/material/ethanol/irish_cream = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/syndicatebomb
	name = "Syndicate Bomb"
	result = /decl/material/ethanol/syndicatebomb
	required_reagents = list(/decl/material/ethanol/beer = 1, /decl/material/ethanol/whiskey_cola = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/erikasurprise
	name = "Erika Surprise"
	result = /decl/material/ethanol/erikasurprise
	required_reagents = list(
		/decl/material/ethanol/ale = 2, 
		/decl/material/drink/juice/lime = 1, 
		/decl/material/ethanol/whiskey = 1, 
		/decl/material/drink/juice/banana = 1, 
		MAT_WATER = 1
	)
	result_amount = 6

/datum/chemical_reaction/recipe/devilskiss
	name = "Devils Kiss"
	result = /decl/material/ethanol/devilskiss
	required_reagents = list(/decl/material/blood = 1, /decl/material/ethanol/coffee/kahlua = 1, /decl/material/ethanol/rum = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/hippiesdelight
	name = "Hippies Delight"
	result = /decl/material/ethanol/hippies_delight
	required_reagents = list(/decl/material/psychotropics = 1, /decl/material/ethanol/livergeist = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/bananahonk
	name = "Banana Honk"
	result = /decl/material/ethanol/bananahonk
	required_reagents = list(/decl/material/drink/juice/banana = 1, /decl/material/drink/milk/cream = 1, /decl/material/nutriment/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/silencer
	name = "Silencer"
	result = /decl/material/ethanol/silencer
	required_reagents = list(/decl/material/drink/nothing = 1, /decl/material/drink/milk/cream = 1, /decl/material/nutriment/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/driestmartini
	name = "Driest Martini"
	result = /decl/material/ethanol/driestmartini
	required_reagents = list(/decl/material/drink/nothing = 1, /decl/material/ethanol/gin = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/rum
	name = "Rum"
	result = /decl/material/ethanol/rum
	required_reagents = list(
		/decl/material/nutriment/sugar = 1,
		MAT_WATER = 1
	)
	catalysts = list(/decl/material/enzyme = 5)
	result_amount = 2
	mix_message = "The solution roils as it rapidly ferments into a red-brown liquid."

/datum/chemical_reaction/recipe/ships_surgeon
	name = "Ship's Surgeon"
	result = /decl/material/ethanol/ships_surgeon
	required_reagents = list(
		/decl/material/ethanol/rum = 1, 
		/decl/material/drink/cherrycola = 2, 
		MAT_WATER = 1
	)
	result_amount = 4

/datum/chemical_reaction/recipe/applecider
	name = "Apple Cider"
	result = /decl/material/ethanol/applecider
	required_reagents = list(/decl/material/drink/juice/apple = 2, /decl/material/nutriment/sugar = 1)
	catalysts = list(/decl/material/nutriment = 5)
	result_amount = 3

/datum/chemical_reaction/recipe/vodkacola
	name = "Vodka Cola"
	result = /decl/material/ethanol/vodkacola
	required_reagents = list(/decl/material/drink/cola = 1, /decl/material/ethanol/vodka = 2)
	result_amount = 3

/datum/chemical_reaction/recipe/arak
	name = "Arak"
	result = /decl/material/ethanol/arak
	required_reagents = list(/decl/material/ethanol/absinthe = 2, /decl/material/drink/juice/grape = 1)
	catalysts = list(/decl/material/nutriment)
	result_amount = 3
	minimum_temperature = (0 CELSIUS) - 100
	maximum_temperature = 0 CELSIUS
	mix_message = "The aniseed ferments into a translucent white mixture"

/datum/chemical_reaction/recipe/sawbonesdismay
	name = "Sawbones' Dismay"
	result = /decl/material/ethanol/sawbonesdismay
	required_reagents = list(/decl/material/drink/beastenergy = 1, /decl/material/ethanol/jagermeister = 2)
	result_amount = 3

/datum/chemical_reaction/recipe/jagermeister
	name = "Jagermeister"
	result = /decl/material/ethanol/jagermeister
	required_reagents = list(
		/decl/material/ethanol/herbal = 2, 
		MAT_WATER = 1
	)
	catalysts = list(/decl/material/nutriment/mint)
	result_amount = 3

/datum/chemical_reaction/recipe/kvass
	name = "Kvass"
	result = /decl/material/ethanol/kvass
	required_reagents = list(/decl/material/nutriment/sugar = 1, /decl/material/ethanol/beer = 1)
	catalysts = list(/decl/material/enzyme = 5)
	result_amount = 3

/datum/chemical_reaction/recipe/suidream
	name = "Sui Dream"
	result = /decl/material/ethanol/suidream
	required_reagents = list(/decl/material/drink/lemonade = 1, /decl/material/ethanol/bluecuracao = 1, /decl/material/ethanol/melonliquor = 1)
	result_amount = 3
