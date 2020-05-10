/datum/chemical_reaction/recipe/goldschlager
	name = "Goldschlager"
	result = /decl/reagent/ethanol/goldschlager
	required_reagents = list(/decl/reagent/ethanol/vodka = 10, /decl/reagent/gold = 1)
	result_amount = 10
	mix_message = "The gold flakes and settles in the vodka."

/datum/chemical_reaction/recipe/patron
	name = "Patron"
	result = /decl/reagent/ethanol/patron
	required_reagents = list(/decl/reagent/ethanol/tequilla = 10, /decl/reagent/silver = 1)
	result_amount = 10
	mix_message = "The silver flakes and settles in the tequila."

/datum/chemical_reaction/recipe/bilk
	name = "Bilk"
	result = /decl/reagent/ethanol/bilk
	required_reagents = list(/decl/reagent/drink/milk = 1, /decl/reagent/ethanol/beer = 1)
	result_amount = 2
	mix_message = "The solution takes on an unpleasant, thick, brown appearance."

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

/datum/chemical_reaction/recipe/spacebeer
	name = "Space Beer"
	result = /decl/reagent/ethanol/beer
	required_reagents = list(/decl/reagent/nutriment/cornoil = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a foaming amber liquid."

/datum/chemical_reaction/recipe/vodka
	name = "Vodka"
	result = /decl/reagent/ethanol/vodka
	required_reagents = list(/decl/reagent/drink/juice/potato = 10)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 10
	mix_message = "The solution roils as it rapidly ferments into a crystal clear liquid."

/datum/chemical_reaction/recipe/vodka2
	name = "Vodka"
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

/datum/chemical_reaction/recipe/gin_tonic
	name = "Gin and Tonic"
	result = /decl/reagent/ethanol/gintonic
	required_reagents = list(/decl/reagent/ethanol/gin = 2, /decl/reagent/drink/tonic = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/cuba_libre
	name = "Cuba Libre"
	result = /decl/reagent/ethanol/cuba_libre
	required_reagents = list(/decl/reagent/ethanol/rum = 2, /decl/reagent/drink/cola = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/martini
	name = "Classic Martini"
	result = /decl/reagent/ethanol/martini
	required_reagents = list(/decl/reagent/ethanol/gin = 2, /decl/reagent/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/vodkamartini
	name = "Vodka Martini"
	result = /decl/reagent/ethanol/vodkamartini
	required_reagents = list(/decl/reagent/ethanol/vodka = 2, /decl/reagent/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/white_russian
	name = "White Russian"
	result = /decl/reagent/ethanol/white_russian
	required_reagents = list(/decl/reagent/ethanol/black_russian = 2, /decl/reagent/drink/milk/cream = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/whiskey_cola
	name = "Whiskey Cola"
	result = /decl/reagent/ethanol/whiskey_cola
	required_reagents = list(/decl/reagent/ethanol/whiskey = 2, /decl/reagent/drink/cola = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/screwdriver
	name = "Screwdriver"
	result = /decl/reagent/ethanol/screwdrivercocktail
	required_reagents = list(/decl/reagent/ethanol/vodka = 2, /decl/reagent/drink/juice/orange = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/bloody_mary
	name = "Bloody Mary"
	result = /decl/reagent/ethanol/bloody_mary
	required_reagents = list(/decl/reagent/ethanol/vodka = 2, /decl/reagent/drink/juice/tomato = 3, /decl/reagent/drink/juice/lime = 1)
	result_amount = 6

/datum/chemical_reaction/recipe/livergeist
	name = "The Livergeist"
	result = /decl/reagent/ethanol/livergeist
	required_reagents = list(/decl/reagent/ethanol/vodka = 2, /decl/reagent/ethanol/gin = 1, /decl/reagent/ethanol/aged_whiskey = 1, /decl/reagent/ethanol/cognac = 1, /decl/reagent/drink/juice/lime = 1)
	result_amount = 6

/datum/chemical_reaction/recipe/brave_bull
	name = "Brave Bull"
	result = /decl/reagent/ethanol/coffee/brave_bull
	required_reagents = list(/decl/reagent/ethanol/tequilla = 2, /decl/reagent/ethanol/coffee/kahlua = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/tequilla_sunrise
	name = "Tequilla Sunrise"
	result = /decl/reagent/ethanol/tequilla_sunrise
	required_reagents = list(/decl/reagent/ethanol/tequilla = 2, /decl/reagent/drink/juice/orange = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/phoron_special
	name = "Toxins Special"
	result = /decl/reagent/ethanol/toxins_special
	required_reagents = list(/decl/reagent/ethanol/rum = 2, /decl/reagent/ethanol/vermouth = 2, /decl/reagent/toxin/phoron = 2)
	result_amount = 6

/datum/chemical_reaction/recipe/beepsky_smash
	name = "Beepksy Smash"
	result = /decl/reagent/ethanol/beepsky_smash
	required_reagents = list(/decl/reagent/drink/juice/lime = 1, /decl/reagent/ethanol/whiskey = 1, /decl/reagent/iron = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/doctor_delight
	name = "The Doctor's Delight"
	result = /decl/reagent/drink/doctor_delight
	required_reagents = list(/decl/reagent/drink/juice/lime = 1, /decl/reagent/drink/juice/tomato = 1, /decl/reagent/drink/juice/orange = 1, /decl/reagent/drink/milk/cream = 2, /decl/reagent/regenerator = 1)
	result_amount = 6

/datum/chemical_reaction/recipe/irish_cream
	name = "Irish Cream"
	result = /decl/reagent/ethanol/irish_cream
	required_reagents = list(/decl/reagent/ethanol/whiskey = 2, /decl/reagent/drink/milk/cream = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/manly_dorf
	name = "The Manly Dorf"
	result = /decl/reagent/ethanol/manly_dorf
	required_reagents = list (/decl/reagent/ethanol/beer = 1, /decl/reagent/ethanol/ale = 2)
	result_amount = 3

/datum/chemical_reaction/recipe/hooch
	name = "Hooch"
	result = /decl/reagent/ethanol/hooch
	required_reagents = list (/decl/reagent/nutriment/sugar = 1, /decl/reagent/ethanol = 2, /decl/reagent/fuel = 1)
	minimum_temperature = 30 CELSIUS
	maximum_temperature = (30 CELSIUS) + 100
	result_amount = 3

/datum/chemical_reaction/recipe/irish_coffee
	name = "Irish Coffee"
	result = /decl/reagent/ethanol/coffee/irishcoffee
	required_reagents = list(/decl/reagent/ethanol/irish_cream = 1, /decl/reagent/drink/coffee = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/b52
	name = "B-52"
	result = /decl/reagent/ethanol/coffee/b52
	required_reagents = list(/decl/reagent/ethanol/irish_cream = 1, /decl/reagent/ethanol/coffee/kahlua = 1, /decl/reagent/ethanol/cognac = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/atomicbomb
	name = "Atomic Bomb"
	result = /decl/reagent/ethanol/atomicbomb
	required_reagents = list(/decl/reagent/ethanol/coffee/b52 = 10, /decl/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/recipe/margarita
	name = "Margarita"
	result = /decl/reagent/ethanol/margarita
	required_reagents = list(/decl/reagent/ethanol/tequilla = 2, /decl/reagent/drink/juice/lime = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/longislandicedtea
	name = "Long Island Iced Tea"
	result = /decl/reagent/ethanol/longislandicedtea
	required_reagents = list(/decl/reagent/ethanol/vodka = 1, /decl/reagent/ethanol/gin = 1, /decl/reagent/ethanol/tequilla = 1, /decl/reagent/ethanol/cuba_libre = 3)
	result_amount = 6

/datum/chemical_reaction/recipe/threemileisland
	name = "Three Mile Island Iced Tea"
	result = /decl/reagent/ethanol/threemileisland
	required_reagents = list(/decl/reagent/ethanol/longislandicedtea = 10, /decl/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/recipe/whiskeysoda
	name = "Whiskey Soda"
	result = /decl/reagent/ethanol/whiskeysoda
	required_reagents = list(/decl/reagent/ethanol/whiskey = 2, /decl/reagent/drink/sodawater = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/black_russian
	name = "Black Russian"
	result = /decl/reagent/ethanol/black_russian
	required_reagents = list(/decl/reagent/ethanol/vodka = 2, /decl/reagent/ethanol/coffee/kahlua = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/manhattan
	name = "Manhattan"
	result = /decl/reagent/ethanol/manhattan
	required_reagents = list(/decl/reagent/ethanol/whiskey = 2, /decl/reagent/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/manhattan_proj
	name = "Manhattan Project"
	result = /decl/reagent/ethanol/manhattan_proj
	required_reagents = list(/decl/reagent/ethanol/manhattan = 10, /decl/reagent/uranium = 1)
	result_amount = 10

/datum/chemical_reaction/recipe/vodka_tonic
	name = "Vodka and Tonic"
	result = /decl/reagent/ethanol/vodkatonic
	required_reagents = list(/decl/reagent/ethanol/vodka = 2, /decl/reagent/drink/tonic = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/gin_fizz
	name = "Gin Fizz"
	result = /decl/reagent/ethanol/ginfizz
	required_reagents = list(/decl/reagent/ethanol/gin = 1, /decl/reagent/drink/sodawater = 1, /decl/reagent/drink/juice/lime = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/bahama_mama
	name = "Bahama Mama"
	result = /decl/reagent/ethanol/bahama_mama
	required_reagents = list(/decl/reagent/ethanol/rum = 2, /decl/reagent/drink/juice/orange = 2, /decl/reagent/drink/juice/lime = 1, /decl/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/recipe/singulo
	name = "Singulo"
	result = /decl/reagent/ethanol/singulo
	required_reagents = list(/decl/reagent/ethanol/vodka = 5, /decl/reagent/radium = 1, /decl/reagent/ethanol/wine = 5)
	result_amount = 10

/datum/chemical_reaction/recipe/alliescocktail
	name = "Allies Cocktail"
	result = /decl/reagent/ethanol/alliescocktail
	required_reagents = list(/decl/reagent/ethanol/vodkamartini = 1, /decl/reagent/ethanol/martini = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/demonsblood
	name = "Demon's Blood"
	result = /decl/reagent/ethanol/demonsblood
	required_reagents = list(/decl/reagent/ethanol/rum = 3, /decl/reagent/drink/citrussoda = 1, /decl/reagent/blood = 1, /decl/reagent/drink/cherrycola = 1)
	result_amount = 6

/datum/chemical_reaction/recipe/booger
	name = "Booger"
	result = /decl/reagent/ethanol/booger
	required_reagents = list(/decl/reagent/drink/milk/cream = 2, /decl/reagent/drink/juice/banana = 1, /decl/reagent/ethanol/rum = 1, /decl/reagent/drink/juice/watermelon = 1)
	result_amount = 5
	mix_message = "The solution thickens unpleasantly."

/datum/chemical_reaction/recipe/antifreeze
	name = "Anti-freeze"
	result = /decl/reagent/ethanol/antifreeze
	required_reagents = list(/decl/reagent/ethanol/vodka = 1, /decl/reagent/drink/milk/cream = 1, /decl/reagent/drink/ice = 1)
	minimum_temperature = (0 CELSIUS) - 100
	maximum_temperature = 0 CELSIUS
	result_amount = 3
	mix_message = "The solution thickens sluggishly."

/datum/chemical_reaction/recipe/barefoot
	name = "Barefoot"
	result = /decl/reagent/ethanol/barefoot
	required_reagents = list(/decl/reagent/drink/juice/berry = 1, /decl/reagent/drink/milk/cream = 1, /decl/reagent/ethanol/vermouth = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/sbiten
	name = "Sbiten"
	result = /decl/reagent/ethanol/sbiten
	required_reagents = list(/decl/reagent/ethanol/mead = 10, /decl/reagent/capsaicin = 1)
	result_amount = 10

/datum/chemical_reaction/recipe/red_mead
	name = "Red Mead"
	result = /decl/reagent/ethanol/red_mead
	required_reagents = list(/decl/reagent/blood = 1, /decl/reagent/ethanol/mead = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/mead
	name = "Mead"
	result = /decl/reagent/ethanol/mead
	required_reagents = list(/decl/reagent/nutriment/honey = 1, /decl/reagent/water = 1)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 2

/datum/chemical_reaction/recipe/grog
	name = "Grog"
	result = /decl/reagent/ethanol/grog
	required_reagents = list(/decl/reagent/ethanol/rum = 1, /decl/reagent/water = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/acidspit
	name = "Acid Spit"
	result = /decl/reagent/ethanol/acid_spit
	required_reagents = list(/decl/reagent/acid = 1, /decl/reagent/ethanol/wine = 5)
	result_amount = 6
	mix_message = "The solution curdles into an unpleasant, slimy liquid."

/datum/chemical_reaction/recipe/amasec
	name = "Amasec"
	result = /decl/reagent/ethanol/amasec
	required_reagents = list(/decl/reagent/iron = 1, /decl/reagent/ethanol/wine = 5, /decl/reagent/ethanol/vodka = 5)
	result_amount = 10

/datum/chemical_reaction/recipe/changelingsting
	name = "Changeling Sting"
	result = /decl/reagent/ethanol/changelingsting
	required_reagents = list(/decl/reagent/ethanol/screwdrivercocktail = 1, /decl/reagent/drink/juice/lime = 1, /decl/reagent/drink/juice/lemon = 1)
	result_amount = 3
	mix_message = "The solution begins to shift and change colour."

/datum/chemical_reaction/recipe/aloe
	name = "Aloe"
	result = /decl/reagent/ethanol/aloe
	required_reagents = list(/decl/reagent/drink/milk/cream = 1, /decl/reagent/ethanol/aged_whiskey = 1, /decl/reagent/drink/juice/watermelon = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/andalusia
	name = "Andalusia"
	result = /decl/reagent/ethanol/andalusia
	required_reagents = list(/decl/reagent/ethanol/rum = 1, /decl/reagent/ethanol/whiskey = 1, /decl/reagent/drink/juice/lemon = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/neurotoxin
	name = "Neurotoxin"
	result = /decl/reagent/ethanol/neurotoxin
	required_reagents = list(/decl/reagent/ethanol/livergeist = 1, /decl/reagent/sedatives = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/snowwhite
	name = "Snow White"
	result = /decl/reagent/ethanol/snowwhite
	required_reagents = list(/decl/reagent/ethanol/beer = 1, /decl/reagent/drink/lemon_lime = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/irishslammer
	name = "Irish Slammer"
	result = /decl/reagent/ethanol/irishslammer
	required_reagents = list(/decl/reagent/ethanol/ale = 1, /decl/reagent/ethanol/irish_cream = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/syndicatebomb
	name = "Syndicate Bomb"
	result = /decl/reagent/ethanol/syndicatebomb
	required_reagents = list(/decl/reagent/ethanol/beer = 1, /decl/reagent/ethanol/whiskey_cola = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/erikasurprise
	name = "Erika Surprise"
	result = /decl/reagent/ethanol/erikasurprise
	required_reagents = list(/decl/reagent/ethanol/ale = 2, /decl/reagent/drink/juice/lime = 1, /decl/reagent/ethanol/whiskey = 1, /decl/reagent/drink/juice/banana = 1, /decl/reagent/drink/ice = 1)
	result_amount = 6

/datum/chemical_reaction/recipe/devilskiss
	name = "Devils Kiss"
	result = /decl/reagent/ethanol/devilskiss
	required_reagents = list(/decl/reagent/blood = 1, /decl/reagent/ethanol/coffee/kahlua = 1, /decl/reagent/ethanol/rum = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/hippiesdelight
	name = "Hippies Delight"
	result = /decl/reagent/ethanol/hippies_delight
	required_reagents = list(/decl/reagent/psychotropics = 1, /decl/reagent/ethanol/livergeist = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/bananahonk
	name = "Banana Honk"
	result = /decl/reagent/ethanol/bananahonk
	required_reagents = list(/decl/reagent/drink/juice/banana = 1, /decl/reagent/drink/milk/cream = 1, /decl/reagent/nutriment/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/silencer
	name = "Silencer"
	result = /decl/reagent/ethanol/silencer
	required_reagents = list(/decl/reagent/drink/nothing = 1, /decl/reagent/drink/milk/cream = 1, /decl/reagent/nutriment/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/recipe/driestmartini
	name = "Driest Martini"
	result = /decl/reagent/ethanol/driestmartini
	required_reagents = list(/decl/reagent/drink/nothing = 1, /decl/reagent/ethanol/gin = 1)
	result_amount = 2

/datum/chemical_reaction/recipe/rum
	name = "Rum"
	result = /decl/reagent/ethanol/rum
	required_reagents = list(/decl/reagent/nutriment/sugar = 1, /decl/reagent/water = 1)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 2
	mix_message = "The solution roils as it rapidly ferments into a red-brown liquid."

/datum/chemical_reaction/recipe/ships_surgeon
	name = "Ship's Surgeon"
	result = /decl/reagent/ethanol/ships_surgeon
	required_reagents = list(/decl/reagent/ethanol/rum = 1, /decl/reagent/drink/cherrycola = 2, /decl/reagent/drink/ice = 1)
	result_amount = 4

/datum/chemical_reaction/recipe/applecider
	name = "Apple Cider"
	result = /decl/reagent/ethanol/applecider
	required_reagents = list(/decl/reagent/drink/juice/apple = 2, /decl/reagent/nutriment/sugar = 1)
	catalysts = list(/decl/reagent/nutriment = 5)
	result_amount = 3

/datum/chemical_reaction/recipe/vodkacola
	name = "Vodka Cola"
	result = /decl/reagent/ethanol/vodkacola
	required_reagents = list(/decl/reagent/drink/cola = 1, /decl/reagent/ethanol/vodka = 2)
	result_amount = 3

/datum/chemical_reaction/recipe/arak
	name = "Arak"
	result = /decl/reagent/ethanol/arak
	required_reagents = list(/decl/reagent/ethanol/absinthe = 2, /decl/reagent/drink/juice/grape = 1)
	catalysts = list(/decl/reagent/nutriment)
	result_amount = 3
	minimum_temperature = (0 CELSIUS) - 100
	maximum_temperature = 0 CELSIUS
	mix_message = "The aniseed ferments into a translucent white mixture"

/datum/chemical_reaction/recipe/sawbonesdismay
	name = "Sawbones' Dismay"
	result = /decl/reagent/ethanol/sawbonesdismay
	required_reagents = list(/decl/reagent/drink/beastenergy = 1, /decl/reagent/ethanol/jagermeister = 2)
	result_amount = 3

/datum/chemical_reaction/recipe/jagermeister
	name = "Jagermeister"
	result = /decl/reagent/ethanol/jagermeister
	required_reagents = list(/decl/reagent/ethanol/herbal = 2, /decl/reagent/water = 1)
	catalysts = list(/decl/reagent/drink/syrup/mint)
	result_amount = 3

/datum/chemical_reaction/recipe/kvass
	name = "Kvass"
	result = /decl/reagent/ethanol/kvass
	required_reagents = list(/decl/reagent/nutriment/sugar = 1, /decl/reagent/ethanol/beer = 1)
	catalysts = list(/decl/reagent/enzyme = 5)
	result_amount = 3

/datum/chemical_reaction/recipe/suidream
	name = "Sui Dream"
	result = /decl/reagent/ethanol/suidream
	required_reagents = list(/decl/reagent/drink/lemonade = 1, /decl/reagent/ethanol/bluecuracao = 1, /decl/reagent/ethanol/melonliquor = 1)
	result_amount = 3
