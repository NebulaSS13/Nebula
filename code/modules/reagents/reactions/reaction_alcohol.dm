/datum/chemical_reaction/goldschlager
	name = "Goldschlager"
	result = /datum/reagent/ethanol/goldschlager
	required_reagents = list(/datum/reagent/ethanol/vodka = 10, /datum/reagent/gold = 1)
	result_amount = 10
	mix_message = "The gold flakes and settles in the vodka."

/datum/chemical_reaction/patron
	name = "Patron"
	result = /datum/reagent/ethanol/patron
	required_reagents = list(/datum/reagent/ethanol/tequilla = 10, /datum/reagent/silver = 1)
	result_amount = 10
	mix_message = "The silver flakes and settles in the tequila."

/datum/chemical_reaction/bilk
	name = "Bilk"
	result = /datum/reagent/ethanol/bilk
	required_reagents = list(/datum/reagent/drink/milk = 1, /datum/reagent/ethanol/beer = 1)
	result_amount = 2
	mix_message = "The solution takes on an unpleasant, thick, brown appearance."

/datum/chemical_reaction/moonshine
	name = "Moonshine"
	result = /datum/reagent/ethanol/moonshine
	required_reagents = list(/datum/reagent/nutriment = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution exudes the powerful reek of raw alcohol."

/datum/chemical_reaction/grenadine
	name = "Grenadine Syrup"
	result = /datum/reagent/drink/grenadine
	required_reagents = list(/datum/reagent/drink/juice/berry = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10

/datum/chemical_reaction/wine
	name = "Wine"
	result = /datum/reagent/ethanol/wine
	required_reagents = list(/datum/reagent/drink/juice/grape = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a rich red liquid."

/datum/chemical_reaction/pwine
	name = "Poison Wine"
	result = /datum/reagent/ethanol/pwine
	required_reagents = list(/datum/reagent/toxin/poisonberryjuice = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a shifting purple liquid."

/datum/chemical_reaction/melonliquor
	name = "Melon Liquor"
	result = /datum/reagent/ethanol/melonliquor
	required_reagents = list(/datum/reagent/drink/juice/watermelon = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a pale liquor."

/datum/chemical_reaction/bluecuracao
	name = "Blue Curacao"
	result = /datum/reagent/ethanol/bluecuracao
	required_reagents = list(/datum/reagent/drink/juice/orange = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a shockingly blue liquor."

/datum/chemical_reaction/spacebeer
	name = "Space Beer"
	result = /datum/reagent/ethanol/beer
	required_reagents = list(/datum/reagent/nutriment/cornoil = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a foaming amber liquid."

/datum/chemical_reaction/vodka
	name = "Vodka"
	result = /datum/reagent/ethanol/vodka
	required_reagents = list(/datum/reagent/drink/juice/potato = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/datum/chemical_reaction/vodka2
	name = "Vodka"
	result = /datum/reagent/ethanol/vodka
	required_reagents = list(/datum/reagent/drink/juice/turnip = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/datum/chemical_reaction/sake
	name = "Sake"
	result = /datum/reagent/ethanol/sake
	required_reagents = list(/datum/reagent/nutriment/rice = 10)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/datum/chemical_reaction/kahlua
	name = "Kahlua"
	result = /datum/reagent/ethanol/coffee/kahlua
	required_reagents = list(/datum/reagent/drink/coffee = 5, /datum/reagent/nutriment/sugar = 5)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 5
	mix_message = "The solution roils as it rapidly ferments into a rich brown liquid."

/datum/chemical_reaction/gin_tonic
	name = "Gin and Tonic"
	result = /datum/reagent/ethanol/gintonic
	required_reagents = list(/datum/reagent/ethanol/gin = 2, /datum/reagent/drink/tonic = 1)
	result_amount = 3

/datum/chemical_reaction/cuba_libre
	name = "Cuba Libre"
	result = /datum/reagent/ethanol/cuba_libre
	required_reagents = list(/datum/reagent/ethanol/rum = 2, /datum/reagent/drink/cola = 1)
	result_amount = 3

/datum/chemical_reaction/martini
	name = "Classic Martini"
	result = /datum/reagent/ethanol/martini
	required_reagents = list(/datum/reagent/ethanol/gin = 2, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/vodkamartini
	name = "Vodka Martini"
	result = /datum/reagent/ethanol/vodkamartini
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/white_russian
	name = "White Russian"
	result = /datum/reagent/ethanol/white_russian
	required_reagents = list(/datum/reagent/ethanol/black_russian = 2, /datum/reagent/drink/milk/cream = 1)
	result_amount = 3

/datum/chemical_reaction/whiskey_cola
	name = "Whiskey Cola"
	result = /datum/reagent/ethanol/whiskey_cola
	required_reagents = list(/datum/reagent/ethanol/whiskey = 2, /datum/reagent/drink/cola = 1)
	result_amount = 3

/datum/chemical_reaction/screwdriver
	name = "Screwdriver"
	result = /datum/reagent/ethanol/screwdrivercocktail
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/drink/juice/orange = 1)
	result_amount = 3

/datum/chemical_reaction/bloody_mary
	name = "Bloody Mary"
	result = /datum/reagent/ethanol/bloody_mary
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/drink/juice/tomato = 3, /datum/reagent/drink/juice/lime = 1)
	result_amount = 6

/datum/chemical_reaction/livergeist
	name = "The Livergeist"
	result = /datum/reagent/ethanol/livergeist
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/ethanol/gin = 1, /datum/reagent/ethanol/aged_whiskey = 1, /datum/reagent/ethanol/cognac = 1, /datum/reagent/drink/juice/lime = 1)
	result_amount = 6

/datum/chemical_reaction/brave_bull
	name = "Brave Bull"
	result = /datum/reagent/ethanol/coffee/brave_bull
	required_reagents = list(/datum/reagent/ethanol/tequilla = 2, /datum/reagent/ethanol/coffee/kahlua = 1)
	result_amount = 3

/datum/chemical_reaction/tequilla_sunrise
	name = "Tequilla Sunrise"
	result = /datum/reagent/ethanol/tequilla_sunrise
	required_reagents = list(/datum/reagent/ethanol/tequilla = 2, /datum/reagent/drink/juice/orange = 1)
	result_amount = 3

/datum/chemical_reaction/phoron_special
	name = "Toxins Special"
	result = /datum/reagent/ethanol/toxins_special
	required_reagents = list(/datum/reagent/ethanol/rum = 2, /datum/reagent/ethanol/vermouth = 2, /datum/reagent/toxin/phoron = 2)
	result_amount = 6

/datum/chemical_reaction/beepsky_smash
	name = "Beepksy Smash"
	result = /datum/reagent/ethanol/beepsky_smash
	required_reagents = list(/datum/reagent/drink/juice/lime = 1, /datum/reagent/ethanol/whiskey = 1, /datum/reagent/iron = 1)
	result_amount = 2

/datum/chemical_reaction/doctor_delight
	name = "The Doctor's Delight"
	result = /datum/reagent/drink/doctor_delight
	required_reagents = list(/datum/reagent/drink/juice/lime = 1, /datum/reagent/drink/juice/tomato = 1, /datum/reagent/drink/juice/orange = 1, /datum/reagent/drink/milk/cream = 2, /datum/reagent/regenerator = 1)
	result_amount = 6

/datum/chemical_reaction/irish_cream
	name = "Irish Cream"
	result = /datum/reagent/ethanol/irish_cream
	required_reagents = list(/datum/reagent/ethanol/whiskey = 2, /datum/reagent/drink/milk/cream = 1)
	result_amount = 3

/datum/chemical_reaction/manly_dorf
	name = "The Manly Dorf"
	result = /datum/reagent/ethanol/manly_dorf
	required_reagents = list (/datum/reagent/ethanol/beer = 1, /datum/reagent/ethanol/ale = 2)
	result_amount = 3

/datum/chemical_reaction/hooch
	name = "Hooch"
	result = /datum/reagent/ethanol/hooch
	required_reagents = list (/datum/reagent/nutriment/sugar = 1, /datum/reagent/ethanol = 2, /datum/reagent/fuel = 1)
	minimum_temperature = 30 CELSIUS
	maximum_temperature = (30 CELSIUS) + 100
	result_amount = 3

/datum/chemical_reaction/irish_coffee
	name = "Irish Coffee"
	result = /datum/reagent/ethanol/coffee/irishcoffee
	required_reagents = list(/datum/reagent/ethanol/irish_cream = 1, /datum/reagent/drink/coffee = 1)
	result_amount = 2

/datum/chemical_reaction/b52
	name = "B-52"
	result = /datum/reagent/ethanol/coffee/b52
	required_reagents = list(/datum/reagent/ethanol/irish_cream = 1, /datum/reagent/ethanol/coffee/kahlua = 1, /datum/reagent/ethanol/cognac = 1)
	result_amount = 3

/datum/chemical_reaction/atomicbomb
	name = "Atomic Bomb"
	result = /datum/reagent/ethanol/atomicbomb
	required_reagents = list(/datum/reagent/ethanol/coffee/b52 = 10, /datum/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/margarita
	name = "Margarita"
	result = /datum/reagent/ethanol/margarita
	required_reagents = list(/datum/reagent/ethanol/tequilla = 2, /datum/reagent/drink/juice/lime = 1)
	result_amount = 3

/datum/chemical_reaction/longislandicedtea
	name = "Long Island Iced Tea"
	result = /datum/reagent/ethanol/longislandicedtea
	required_reagents = list(/datum/reagent/ethanol/vodka = 1, /datum/reagent/ethanol/gin = 1, /datum/reagent/ethanol/tequilla = 1, /datum/reagent/ethanol/cuba_libre = 3)
	result_amount = 6

/datum/chemical_reaction/threemileisland
	name = "Three Mile Island Iced Tea"
	result = /datum/reagent/ethanol/threemileisland
	required_reagents = list(/datum/reagent/ethanol/longislandicedtea = 10, /datum/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/whiskeysoda
	name = "Whiskey Soda"
	result = /datum/reagent/ethanol/whiskeysoda
	required_reagents = list(/datum/reagent/ethanol/whiskey = 2, /datum/reagent/drink/sodawater = 1)
	result_amount = 3

/datum/chemical_reaction/black_russian
	name = "Black Russian"
	result = /datum/reagent/ethanol/black_russian
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/ethanol/coffee/kahlua = 1)
	result_amount = 3

/datum/chemical_reaction/manhattan
	name = "Manhattan"
	result = /datum/reagent/ethanol/manhattan
	required_reagents = list(/datum/reagent/ethanol/whiskey = 2, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/manhattan_proj
	name = "Manhattan Project"
	result = /datum/reagent/ethanol/manhattan_proj
	required_reagents = list(/datum/reagent/ethanol/manhattan = 10, /datum/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/vodka_tonic
	name = "Vodka and Tonic"
	result = /datum/reagent/ethanol/vodkatonic
	required_reagents = list(/datum/reagent/ethanol/vodka = 2, /datum/reagent/drink/tonic = 1)
	result_amount = 3

/datum/chemical_reaction/gin_fizz
	name = "Gin Fizz"
	result = /datum/reagent/ethanol/ginfizz
	required_reagents = list(/datum/reagent/ethanol/gin = 1, /datum/reagent/drink/sodawater = 1, /datum/reagent/drink/juice/lime = 1)
	result_amount = 3

/datum/chemical_reaction/bahama_mama
	name = "Bahama Mama"
	result = /datum/reagent/ethanol/bahama_mama
	required_reagents = list(/datum/reagent/ethanol/rum = 2, /datum/reagent/drink/juice/orange = 2, /datum/reagent/drink/juice/lime = 1, /datum/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/singulo
	name = "Singulo"
	result = /datum/reagent/ethanol/singulo
	required_reagents = list(/datum/reagent/ethanol/vodka = 5, /datum/reagent/radium = 1, /datum/reagent/ethanol/wine = 5)
	result_amount = 10

/datum/chemical_reaction/alliescocktail
	name = "Allies Cocktail"
	result = /datum/reagent/ethanol/alliescocktail
	required_reagents = list(/datum/reagent/ethanol/vodkamartini = 1, /datum/reagent/ethanol/martini = 1)
	result_amount = 2

/datum/chemical_reaction/demonsblood
	name = "Demon's Blood"
	result = /datum/reagent/ethanol/demonsblood
	required_reagents = list(/datum/reagent/ethanol/rum = 3, /datum/reagent/drink/citrussoda = 1, /datum/reagent/blood = 1, /datum/reagent/drink/cherrycola = 1)
	result_amount = 6

/datum/chemical_reaction/booger
	name = "Booger"
	result = /datum/reagent/ethanol/booger
	required_reagents = list(/datum/reagent/drink/milk/cream = 2, /datum/reagent/drink/juice/banana = 1, /datum/reagent/ethanol/rum = 1, /datum/reagent/drink/juice/watermelon = 1)
	result_amount = 5
	mix_message = "The solution thickens unpleasantly."

/datum/chemical_reaction/antifreeze
	name = "Anti-freeze"
	result = /datum/reagent/ethanol/antifreeze
	required_reagents = list(/datum/reagent/ethanol/vodka = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/drink/ice = 1)
	minimum_temperature = (0 CELSIUS) - 100
	maximum_temperature = 0 CELSIUS
	result_amount = 3
	mix_message = "The solution thickens sluggishly."

/datum/chemical_reaction/barefoot
	name = "Barefoot"
	result = /datum/reagent/ethanol/barefoot
	required_reagents = list(/datum/reagent/drink/juice/berry = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/sbiten
	name = "Sbiten"
	result = /datum/reagent/ethanol/sbiten
	required_reagents = list(/datum/reagent/ethanol/mead = 10, /datum/reagent/capsaicin = 1)
	result_amount = 10

/datum/chemical_reaction/red_mead
	name = "Red Mead"
	result = /datum/reagent/ethanol/red_mead
	required_reagents = list(/datum/reagent/blood = 1, /datum/reagent/ethanol/mead = 1)
	result_amount = 2

/datum/chemical_reaction/mead
	name = "Mead"
	result = /datum/reagent/ethanol/mead
	required_reagents = list(/datum/reagent/nutriment/honey = 1, /datum/reagent/water = 1)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 2

/datum/chemical_reaction/iced_beer
	name = "Iced Beer"
	result = /datum/reagent/ethanol/iced_beer
	required_reagents = list(/datum/reagent/ethanol/beer = 10, /datum/reagent/frostoil = 1)
	result_amount = 10
	mix_message = "The solution chills rapidly, frost forming on its surface."

/datum/chemical_reaction/iced_beer2
	name = "Iced Beer"
	result = /datum/reagent/ethanol/iced_beer
	required_reagents = list(/datum/reagent/ethanol/beer = 5, /datum/reagent/drink/ice = 1)
	result_amount = 6
	mix_message = "The ice clinks together in the beer."

/datum/chemical_reaction/grog
	name = "Grog"
	result = /datum/reagent/ethanol/grog
	required_reagents = list(/datum/reagent/ethanol/rum = 1, /datum/reagent/water = 1)
	result_amount = 2

/datum/chemical_reaction/acidspit
	name = "Acid Spit"
	result = /datum/reagent/ethanol/acid_spit
	required_reagents = list(/datum/reagent/acid = 1, /datum/reagent/ethanol/wine = 5)
	result_amount = 6
	mix_message = "The solution curdles into an unpleasant, slimy liquid."

/datum/chemical_reaction/amasec
	name = "Amasec"
	result = /datum/reagent/ethanol/amasec
	required_reagents = list(/datum/reagent/iron = 1, /datum/reagent/ethanol/wine = 5, /datum/reagent/ethanol/vodka = 5)
	result_amount = 10

/datum/chemical_reaction/changelingsting
	name = "Changeling Sting"
	result = /datum/reagent/ethanol/changelingsting
	required_reagents = list(/datum/reagent/ethanol/screwdrivercocktail = 1, /datum/reagent/drink/juice/lime = 1, /datum/reagent/drink/juice/lemon = 1)
	result_amount = 3
	mix_message = "The solution begins to shift and change colour."

/datum/chemical_reaction/aloe
	name = "Aloe"
	result = /datum/reagent/ethanol/aloe
	required_reagents = list(/datum/reagent/drink/milk/cream = 1, /datum/reagent/ethanol/aged_whiskey = 1, /datum/reagent/drink/juice/watermelon = 1)
	result_amount = 3

/datum/chemical_reaction/andalusia
	name = "Andalusia"
	result = /datum/reagent/ethanol/andalusia
	required_reagents = list(/datum/reagent/ethanol/rum = 1, /datum/reagent/ethanol/whiskey = 1, /datum/reagent/drink/juice/lemon = 1)
	result_amount = 3

/datum/chemical_reaction/neurotoxin
	name = "Neurotoxin"
	result = /datum/reagent/ethanol/neurotoxin
	required_reagents = list(/datum/reagent/ethanol/livergeist = 1, /datum/reagent/sedatives = 1)
	result_amount = 2

/datum/chemical_reaction/snowwhite
	name = "Snow White"
	result = /datum/reagent/ethanol/snowwhite
	required_reagents = list(/datum/reagent/ethanol/beer = 1, /datum/reagent/drink/lemon_lime = 1)
	result_amount = 2

/datum/chemical_reaction/irishslammer
	name = "Irish Slammer"
	result = /datum/reagent/ethanol/irishslammer
	required_reagents = list(/datum/reagent/ethanol/ale = 1, /datum/reagent/ethanol/irish_cream = 1)
	result_amount = 2

/datum/chemical_reaction/syndicatebomb
	name = "Syndicate Bomb"
	result = /datum/reagent/ethanol/syndicatebomb
	required_reagents = list(/datum/reagent/ethanol/beer = 1, /datum/reagent/ethanol/whiskey_cola = 1)
	result_amount = 2

/datum/chemical_reaction/erikasurprise
	name = "Erika Surprise"
	result = /datum/reagent/ethanol/erikasurprise
	required_reagents = list(/datum/reagent/ethanol/ale = 2, /datum/reagent/drink/juice/lime = 1, /datum/reagent/ethanol/whiskey = 1, /datum/reagent/drink/juice/banana = 1, /datum/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/devilskiss
	name = "Devils Kiss"
	result = /datum/reagent/ethanol/devilskiss
	required_reagents = list(/datum/reagent/blood = 1, /datum/reagent/ethanol/coffee/kahlua = 1, /datum/reagent/ethanol/rum = 1)
	result_amount = 3

/datum/chemical_reaction/hippiesdelight
	name = "Hippies Delight"
	result = /datum/reagent/ethanol/hippies_delight
	required_reagents = list(/datum/reagent/psychotropics = 1, /datum/reagent/ethanol/livergeist = 1)
	result_amount = 2

/datum/chemical_reaction/bananahonk
	name = "Banana Honk"
	result = /datum/reagent/ethanol/bananahonk
	required_reagents = list(/datum/reagent/drink/juice/banana = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/nutriment/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/silencer
	name = "Silencer"
	result = /datum/reagent/ethanol/silencer
	required_reagents = list(/datum/reagent/drink/nothing = 1, /datum/reagent/drink/milk/cream = 1, /datum/reagent/nutriment/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/driestmartini
	name = "Driest Martini"
	result = /datum/reagent/ethanol/driestmartini
	required_reagents = list(/datum/reagent/drink/nothing = 1, /datum/reagent/ethanol/gin = 1)
	result_amount = 2

/datum/chemical_reaction/rum
	name = "Rum"
	result = /datum/reagent/ethanol/rum
	required_reagents = list(/datum/reagent/nutriment/sugar = 1, /datum/reagent/water = 1)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 2
	mix_message = "The solution roils as it rapidly ferments into a red-brown liquid."

/datum/chemical_reaction/ships_surgeon
	name = "Ship's Surgeon"
	result = /datum/reagent/ethanol/ships_surgeon
	required_reagents = list(/datum/reagent/ethanol/rum = 1, /datum/reagent/drink/cherrycola = 2, /datum/reagent/drink/ice = 1)
	result_amount = 4

/datum/chemical_reaction/applecider
	name = "Apple Cider"
	result = /datum/reagent/ethanol/applecider
	required_reagents = list(/datum/reagent/drink/juice/apple = 2, /datum/reagent/nutriment/sugar = 1)
	catalysts = list(/datum/reagent/nutriment = 5)
	result_amount = 3

/datum/chemical_reaction/vodkacola
	name = "Vodka Cola"
	result = /datum/reagent/ethanol/vodkacola
	required_reagents = list(/datum/reagent/drink/cola = 1, /datum/reagent/ethanol/vodka = 2)
	result_amount = 3

/datum/chemical_reaction/arak
	name = "Arak"
	result = /datum/reagent/ethanol/arak
	required_reagents = list(/datum/reagent/ethanol/absinthe = 2, /datum/reagent/drink/juice/grape = 1)
	catalysts = list(/datum/reagent/nutriment)
	result_amount = 3
	minimum_temperature = (0 CELSIUS) - 100
	maximum_temperature = 0 CELSIUS
	mix_message = "The aniseed ferments into a translucent white mixture"

/datum/chemical_reaction/sawbonesdismay
	name = "Sawbones' Dismay"
	result = /datum/reagent/ethanol/sawbonesdismay
	required_reagents = list(/datum/reagent/drink/beastenergy = 1, /datum/reagent/ethanol/jagermeister = 2)
	result_amount = 3

/datum/chemical_reaction/jagermeister
	name = "Jagermeister"
	result = /datum/reagent/ethanol/jagermeister
	required_reagents = list(/datum/reagent/ethanol/herbal = 2, /datum/reagent/water = 1)
	catalysts = list(/datum/reagent/nutriment/mint)
	result_amount = 3

/datum/chemical_reaction/kvass
	name = "Kvass"
	result = /datum/reagent/ethanol/kvass
	required_reagents = list(/datum/reagent/nutriment/sugar = 1, /datum/reagent/ethanol/beer = 1)
	catalysts = list(/datum/reagent/enzyme = 5)
	result_amount = 3

/datum/chemical_reaction/suidream
	name = "Sui Dream"
	result = /datum/reagent/ethanol/suidream
	required_reagents = list(/datum/reagent/drink/lemonade = 1, /datum/reagent/ethanol/bluecuracao = 1, /datum/reagent/ethanol/melonliquor = 1)
	result_amount = 3
