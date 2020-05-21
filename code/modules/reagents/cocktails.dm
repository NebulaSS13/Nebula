// This is a system used to change the name and description of a glass of
// alcohol if it meets certain minimum proportions of ingredients. It 
// replaces the previous system, which used chemical reactions.

/decl/cocktail
	var/name                   // Cocktail name, applied to the glass.
	var/description            // Cocktail description, applied to the glass.
	var/list/ratios            // Associative list of reagents to a minimum percentage of mix (<1).
	                           // Reagents with no assoc value will count as valid for any amount (even 0.001u)
	var/order_specific = FALSE // If set, cocktail will fail if ingredients were added out of ratio order.
	var/hidden_from_codex      // Doesn't generate a codex entry.

// Shoot for total ratios of about 70% (0.7) for any cocktail that doesn't need 
// to be super precise - this will leave room in a mix for people to spike your 
// drink or to be comfortably over or under their proportions without having to 
// be frustratingly picky with measurements.

/decl/cocktail/proc/get_presentation_name(var/obj/item/prop)
	. = name
	if(prop?.reagents?.has_reagent(/decl/reagent/drink/ice) && !(/decl/reagent/drink/ice in ratios))
		. = "[name], on the rocks"

/decl/cocktail/proc/mix_priority()
	. = length(ratios)

/decl/cocktail/proc/matches(var/obj/item/prop)
	if(length(ratios) > length(prop.reagents.reagent_volumes))
		return FALSE
	var/list/check_ratios
	var/i = 0
	for(var/rtype in ratios)
		i++
		if(!prop.reagents.has_reagent(rtype) || (order_specific && prop.reagents.reagent_volumes[i] != rtype))
			return FALSE
		if(isnum(ratios[rtype]))
			LAZYSET(check_ratios, rtype, ratios[rtype])
	var/effective_volume = prop.reagents.total_volume
	if(!(/decl/reagent/drink/ice in ratios))
		effective_volume -= REAGENT_VOLUME(prop.reagents, /decl/reagent/drink/ice)
	for(var/rtype in check_ratios)
		if((REAGENT_VOLUME(prop.reagents, rtype) / effective_volume) < check_ratios[rtype])
			return FALSE
	return TRUE

/decl/cocktail/grog
	name = "grog"
	ratios = list(
		/decl/reagent/water =       0.5,
		/decl/reagent/ethanol/rum = 0.2
	)

/decl/cocktail/screwdriver
	name = "screwdriver"
	description = "A classic mixture of vodka and orange juice. Just the thing for the tired engineer."
	ratios = list(
		/decl/reagent/drink/juice/orange = 0.6,
		/decl/reagent/ethanol/vodka =      0.1
	)

/decl/cocktail/tequilla_sunrise
	name = "tequilla sunrise"
	description = "A simple cocktail of tequilla and orange juice. Much like a Screwdriver, only Mexican."
	ratios = list(
		/decl/reagent/drink/juice/orange = 0.6,
		/decl/reagent/ethanol/tequilla =   0.1
	)

/decl/cocktail/classic_martini
	name = "martini"
	description = "Vermouth with gin. The classiest of all cocktails."
	ratios = list(
		/decl/reagent/ethanol/gin =      0.4,
		/decl/reagent/ethanol/vermouth = 0.3
	)

/decl/cocktail/vodka_martini
	name = "vodka martini" 
	ratios = list(
		/decl/reagent/ethanol/vodka =    0.4,
		/decl/reagent/ethanol/vermouth = 0.3
	)

/decl/cocktail/allies_cocktail
	name = "Allies Cocktail"
	description = "A drink made from your allies, not as sweet as when made from your enemies."
	ratios = list(
		/decl/reagent/ethanol/vermouth = 0.3,
		/decl/reagent/ethanol/vodka =    0.1,
		/decl/reagent/ethanol/gin =      0.3
	)

/decl/cocktail/bilk
	name = "bilk"
	ratios = list(
		/decl/reagent/ethanol/beer = 0.35,
		/decl/reagent/drink/milk =   0.35
	)

/decl/cocktail/gin_and_tonic
	name = "gin and tonic"
	ratios = list(
		/decl/reagent/drink/tonic = 0.4,
		/decl/reagent/ethanol/gin = 0.3
	)

/decl/cocktail/cuba_libre
	name = "Cuba Libre"
	ratios = list(
		/decl/reagent/ethanol/rum = 0.2,
		/decl/reagent/drink/cola =  0.5
	)

/decl/cocktail/black_russian
	name = "Black Russian"
	ratios = list(
		/decl/reagent/ethanol/vodka =         0.4,
		/decl/reagent/ethanol/coffee/kahlua = 0.2
	)

/decl/cocktail/white_russian
	name = "White Russian"
	ratios = list(
		/decl/reagent/ethanol/vodka =         0.3,
		/decl/reagent/ethanol/coffee/kahlua = 0.15,
		/decl/reagent/drink/milk/cream =      0.15
	)

/decl/cocktail/whiskey_cola
	name = "whiskey cola"
	ratios = list(
		/decl/reagent/ethanol/whiskey = 0.2,
		/decl/reagent/drink/cola =      0.5
	)

/decl/cocktail/bloody_mary
	name = "Bloody Mary"
	ratios = list(
		/decl/reagent/drink/juice/tomato = 0.4,
		/decl/reagent/ethanol/vodka =      0.15, 
		/decl/reagent/drink/juice/lime =   0.15
	)

/decl/cocktail/livergeist
	name = "The Livergeist"
	ratios = list(
		/decl/reagent/ethanol/vodka =        0.1,
		/decl/reagent/ethanol/gin =          0.1,
		/decl/reagent/ethanol/aged_whiskey = 0.1,
		/decl/reagent/ethanol/cognac =       0.1,
		/decl/reagent/drink/juice/lime =     0.1
	)

/decl/cocktail/brave_bull
	name = "Brave Bull"
	ratios = list(
		/decl/reagent/ethanol/tequilla =      0.45,
		/decl/reagent/ethanol/coffee/kahlua = 0.25
	)

/decl/cocktail/phoron_special
	name = "Toxins Special"
	ratios = list(
		/decl/reagent/ethanol/rum = 0.35,
		/decl/reagent/ethanol/vermouth = 0.35,
		/decl/reagent/toxin/phoron
	)

/decl/cocktail/beepsky_smash
	name = "Beepsky Smash"
	ratios = list(
		/decl/reagent/ethanol/whiskey =  0.4,
		/decl/reagent/drink/juice/lime = 0.2, 
		/decl/reagent/iron =             0.1
	)

/decl/cocktail/doctor_delight
	name = "Doctor's Delight"
	ratios = list(
		/decl/reagent/regenerator =        0.3,
		/decl/reagent/drink/juice/lime =   0.1, 
		/decl/reagent/drink/juice/tomato = 0.1, 
		/decl/reagent/drink/juice/orange = 0.1, 
		/decl/reagent/drink/milk/cream =   0.1
	)

/decl/cocktail/manly_dorf
	name = "The Manly Dorf"
	ratios = list(
		/decl/reagent/ethanol/ale =  0.35,
		/decl/reagent/ethanol/beer = 0.35
	)

/decl/cocktail/irish_coffee
	name = "Irish coffee"
	ratios = list(
		/decl/reagent/drink/coffee =        0.5,
		/decl/reagent/ethanol/irish_cream = 0.2
	)

/decl/cocktail/b52
	name = "B-52"
	ratios = list(
		/decl/reagent/ethanol/cognac =        0.3,
		/decl/reagent/ethanol/irish_cream =   0.2,
		/decl/reagent/ethanol/coffee/kahlua = 0.2
	)

/decl/cocktail/atomicbomb
	name = "Atomic Bomb"
	ratios = list(
		/decl/reagent/ethanol/cognac =        0.3,
		/decl/reagent/ethanol/irish_cream =   0.2,
		/decl/reagent/ethanol/coffee/kahlua = 0.2,
		/decl/reagent/uranium
	)

/decl/cocktail/margarita
	name = "margarita"
	ratios = list(
		/decl/reagent/ethanol/tequilla = 0.35,
		/decl/reagent/drink/juice/lime = 0.35
	)

/decl/cocktail/longislandicedtea
	name = "Long Island Iced Tea"
	ratios = list(
		/decl/reagent/drink/cola =       0.2,
		/decl/reagent/ethanol/rum =      0.1,
		/decl/reagent/ethanol/vodka =    0.1, 
		/decl/reagent/ethanol/gin =      0.1, 
		/decl/reagent/ethanol/tequilla = 0.1	
	)

/decl/cocktail/threemileisland
	name = "Three Mile Island Iced Tea"
	ratios = list(
		/decl/reagent/drink/cola =       0.2,
		/decl/reagent/ethanol/rum =      0.1,
		/decl/reagent/ethanol/vodka =    0.1, 
		/decl/reagent/ethanol/gin =      0.1, 
		/decl/reagent/ethanol/tequilla = 0.1,
		/decl/reagent/uranium
	)

/decl/cocktail/whiskeysoda
	name = "whiskey soda"
	ratios = list(
		/decl/reagent/ethanol/whiskey = 0.25,
		/decl/reagent/drink/sodawater = 0.45
	)

/decl/cocktail/manhattan
	name = "Manhattan"
	ratios = list(
		/decl/reagent/ethanol/whiskey =  0.45,
		/decl/reagent/ethanol/vermouth = 0.25
	)

/decl/cocktail/manhattan_proj
	name = "Manhattan Project"
	ratios = list(
		/decl/reagent/ethanol/whiskey =  0.45,
		/decl/reagent/ethanol/vermouth = 0.25,
		/decl/reagent/uranium
	)

/decl/cocktail/vodka_tonic
	name = "vodka and tonic"
	ratios = list(
		/decl/reagent/ethanol/vodka = 0.2,
		/decl/reagent/drink/tonic =   0.5
	)

/decl/cocktail/gin_fizz
	name = "gin fizz"
	ratios = list(
		/decl/reagent/ethanol/gin =      0.3,
		/decl/reagent/drink/sodawater =  0.2, 
		/decl/reagent/drink/juice/lime = 0.2
	)

/decl/cocktail/bahama_mama
	name = "Bahama Mama"
	ratios = list(
		/decl/reagent/ethanol/rum =        0.2,
		/decl/reagent/drink/juice/orange = 0.2,
		/decl/reagent/drink/juice/lime =   0.2,
		/decl/reagent/drink/grenadine =    0.1
	)

/decl/cocktail/singulo
	name = "Singulo"
	ratios = list(
		/decl/reagent/ethanol/vodka = 0.35,
		/decl/reagent/ethanol/wine =  0.35,
		/decl/reagent/radium
	)

/decl/cocktail/demonsblood
	name = "Demon's Blood"
	ratios = list(
		/decl/reagent/ethanol/rum =      0.2,
		/decl/reagent/drink/citrussoda = 0.2,
		/decl/reagent/blood =            0.1,
		/decl/reagent/drink/cherrycola = 0.2
	)

/decl/cocktail/booger
	name = "Booger"
	ratios = list(
		/decl/reagent/drink/milk/cream =       0.2,
		/decl/reagent/drink/juice/banana =     0.15, 
		/decl/reagent/ethanol/rum =            0.2,
		/decl/reagent/drink/juice/watermelon = 0.15
	)

/decl/cocktail/antifreeze
	name = "Anti-freeze"
	ratios = list(
		/decl/reagent/ethanol/vodka =    0.3,
		/decl/reagent/drink/milk/cream = 0.2, 
		/decl/reagent/drink/ice =        0.2
	)

/decl/cocktail/barefoot
	name = "Barefoot"
	ratios = list(
		/decl/reagent/ethanol/vermouth =  0.4,
		/decl/reagent/drink/juice/berry = 0.2, 
		/decl/reagent/drink/milk/cream =  0.1
	)

/decl/cocktail/sbiten
	name = "sbiten"
	ratios = list(
		/decl/reagent/ethanol/mead = 0.6,
		/decl/reagent/capsaicin =    0.1
	)

/decl/cocktail/red_mead
	name = "red mead"
	ratios = list(
		/decl/reagent/ethanol/mead = 0.6,
		/decl/reagent/blood =        0.1
	)

/decl/cocktail/acidspit
	name = "Acid Spit"
	ratios = list(
		/decl/reagent/ethanol/wine = 0.7,
		/decl/reagent/acid
	)

/decl/cocktail/changelingsting
	name = "Changeling Sting"
	ratios = list(
		/decl/reagent/ethanol/vodka =      0.4,
		/decl/reagent/drink/juice/lime =   0.1, 
		/decl/reagent/drink/juice/lemon =  0.1,
		/decl/reagent/drink/juice/orange = 0.1
	)

/decl/cocktail/neurotoxin
	name = "Neurotoxin"
	ratios = list(
		/decl/reagent/ethanol/vodka =        0.1,
		/decl/reagent/ethanol/gin =          0.1,
		/decl/reagent/ethanol/aged_whiskey = 0.1,
		/decl/reagent/ethanol/cognac =       0.1,
		/decl/reagent/drink/juice/lime =     0.1,
		/decl/reagent/sedatives =            0.1
	)

/decl/cocktail/snowwhite
	name = "Snow White"
	ratios = list(
		/decl/reagent/ethanol/beer =     0.4,
		/decl/reagent/drink/lemon_lime = 0.3
	)

/decl/cocktail/irishslammer
	name = "Irish Slammer"
	ratios = list(
		/decl/reagent/ethanol/ale =         0.5,
		/decl/reagent/ethanol/whiskey =     0.1,
		/decl/reagent/ethanol/irish_cream = 0.1
	)

/decl/cocktail/syndicatebomb
	name = "Syndicate Bomb"
	ratios = list(
		/decl/reagent/ethanol/whiskey = 0.2,
		/decl/reagent/ethanol/beer =    0.2,
		/decl/reagent/drink/cola =      0.3
	)

/decl/cocktail/devilskiss
	name = "Devil's Kiss"
	ratios = list(
		/decl/reagent/ethanol/rum =           0.4,
		/decl/reagent/blood =                 0.1, 
		/decl/reagent/ethanol/coffee/kahlua = 0.2
	)

/decl/cocktail/hippiesdelight
	name = "Hippy's Delight"
	ratios = list(
		/decl/reagent/ethanol/vodka =        0.1,
		/decl/reagent/ethanol/gin =          0.1,
		/decl/reagent/ethanol/aged_whiskey = 0.1,
		/decl/reagent/ethanol/cognac =       0.1,
		/decl/reagent/drink/juice/lime =     0.1,
		/decl/reagent/psychotropics =        0.2
	)

/decl/cocktail/bananahonk
	name = "Banana Honk"
	ratios = list(
		/decl/reagent/drink/juice/banana = 0.4,
		/decl/reagent/drink/milk/cream =   0.2, 
		/decl/reagent/nutriment/sugar =    0.1
	)

/decl/cocktail/silencer
	name = "Silencer"
	ratios = list(
		/decl/reagent/drink/nothing =    0.3,
		/decl/reagent/drink/milk/cream = 0.3,
		/decl/reagent/nutriment/sugar =  0.1
	)

/decl/cocktail/driestmartini
	name = "driest martini"
	ratios = list(
		/decl/reagent/ethanol/gin =   0.4,
		/decl/reagent/drink/nothing = 0.3
	)

/decl/cocktail/ships_surgeon
	name = "Ship's Surgeon"
	ratios = list(
		/decl/reagent/drink/cherrycola = 0.5,
		/decl/reagent/ethanol/rum =      0.2
	)

/decl/cocktail/vodkacola
	name = "vodka cola"
	ratios = list(
		/decl/reagent/ethanol/vodka = 0.5,
		/decl/reagent/drink/cola =    0.2
	)

/decl/cocktail/sawbonesdismay
	name = "Sawbones' Dismay"
	ratios = list(
		/decl/reagent/ethanol/jagermeister = 0.35,
		/decl/reagent/drink/beastenergy =    0.35
	)

/decl/cocktail/patron
	name = "Patron"
	ratios = list(
		/decl/reagent/ethanol/tequilla = 0.7,
		/decl/reagent/silver
	)

/decl/cocktail/rewriter
	name = "Rewriter"
	ratios = list(
		/decl/reagent/drink/coffee =     0.35,
		/decl/reagent/drink/citrussoda = 0.35
	)

// TODO: add schnapps
/decl/cocktail/goldschlager
	name = "Goldschlager"
	ratios = list(
		/decl/reagent/ethanol/vodka = 0.7,
		/decl/reagent/gold
	)
