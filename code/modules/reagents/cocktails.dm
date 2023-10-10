// This is a system used to change the name and description of a glass of
// alcohol if it meets certain minimum proportions of ingredients. It
// replaces the previous system, which used chemical reactions.

/decl/cocktail
	abstract_type = /decl/cocktail
	/// Cocktail name, applied to the glass.
	var/name
	/// Cocktail description, applied to the glass.
	var/description
	/// Associative list of reagents. The actual amount only matters for defining proportions and will be normalized.
	/// These should ideally be whole numbers in the lowest possible ratio, e.g.
	/// 1, 2, 3 instead of 0.1, 0.2, 0.3 or 2, 4, 6.
	/// Reagents with no assoc value will count as valid for any amount (even 0.001u).
	var/list/ratios
	/// The ratio displayed in the codex, which is the same as ratios prior to normalisation.
	var/list/display_ratios
	/// If TRUE, cocktail ingredients must be added in the order they're specified in the ratio.
	var/order_specific = FALSE
	/// If TRUE, doesn't generate a codex entry.
	var/hidden_from_codex
	/// The icon to use for the cocktail. May be null, in which case no custom icon is used.
	var/icon/glass_icon
	/// The icon_state to use for the cocktail. May be null, in which case the first state in the icon is used.
	var/glass_icon_state
	/// A list of types (incl. subtypes) to display this cocktail's glass sprite on.
	var/display_types = list(/obj/item/chems/drinks/glass2)

	// Impurity tolerance gives a buffer for imprecise mixing, avoiding finnicky measurements
	// and allowing for things like spiked drinks. The default is 0.3, meaning aside from ice,
	// the drink can be at most 30% other reagents not part of the cocktail recipe.

	/// What fraction of the total volume of the drink (ignoring ice) can be unrelated chems?
	var/impurity_tolerance = 0.3

	/// What tastes (and associated strengths) this cocktail adds. Scaled in taste code by total_volume.
	/// Example: list("something funny" = 0.5)
	/// Consider using a total strength proportional to the number of ingredients, i.e. 0.25 for 4 ingredients, 0.5 for 2, etc.
	var/list/tastes = null

/decl/cocktail/Initialize()
	. = ..()
	// Normalize the ratios to ensure a specific degree of tolerance.
	if(ratios)
		display_ratios = ratios.Copy() // Copy the initial ratio to use for the codex.
	var/ratio_wiggle_room = (1-impurity_tolerance)
	var/ratio_sum = 0
	for(var/r in ratios)
		ratio_sum += ratios[r]
	for(var/r in ratios)
		ratios[r] *= ratio_wiggle_room / ratio_sum
	// Normalize the tastes to be relative to the number of ingredients.
	// This lets you roughly reason about the strength of the taste
	// of the cocktail relative to its ingredients' tastes.
	for(var/t in tastes)
		tastes[t] /= length(ratios)

/decl/cocktail/proc/get_presentation_name(var/obj/item/prop)
	. = name
	if(prop?.reagents?.has_reagent(/decl/material/solid/ice) && !(/decl/material/solid/ice in ratios))
		. = "[name], on the rocks"

/decl/cocktail/proc/get_presentation_desc(var/obj/item/prop)
	. = description
	// placeholder for future functionality (vapor/fizz/etc. descriptions)

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
	if(!(/decl/material/solid/ice in ratios))
		effective_volume -= REAGENT_VOLUME(prop.reagents, /decl/material/solid/ice)
	for(var/rtype in check_ratios)
		if((REAGENT_VOLUME(prop.reagents, rtype) / effective_volume) < check_ratios[rtype])
			return FALSE
	return TRUE

/decl/cocktail/proc/has_sprite(obj/item/prop)
	// assumes we match, checks if we have (compatible) sprites
	return !(isnull(glass_icon) || isnull(glass_icon_state))

/decl/cocktail/proc/can_use_sprite(obj/item/prop)
	// assume we already match; just check types
	return is_type_in_list(prop, display_types)

/decl/cocktail/validate()
	. = ..()
	if(!length(ratios))
		. += "no ratios defined for cocktail"

/decl/cocktail/grog
	name = "grog"
	description = "Watered-down rum. Pirate approved!"
	ratios = list(
		/decl/material/liquid/water =       1,
		/decl/material/liquid/ethanol/rum = 1
	)

/decl/cocktail/screwdriver
	name = "screwdriver"
	description = "A classic mixture of vodka and orange juice. Just the thing for the tired engineer."
	ratios = list(
		/decl/material/liquid/drink/juice/orange = 4,
		/decl/material/liquid/ethanol/vodka =      1
	)

/decl/cocktail/tequila_sunrise
	name = "tequila sunrise"
	description = "A simple cocktail of tequila and orange juice. Much like a screwdriver."
	ratios = list(
		/decl/material/liquid/drink/juice/orange = 4,
		/decl/material/liquid/ethanol/tequila =    1
	)

/decl/cocktail/classic_martini
	name = "gin martini"
	description = "Vermouth with gin. The classiest of all cocktails."
	ratios = list(
		/decl/material/liquid/ethanol/gin =      4,
		/decl/material/liquid/ethanol/vermouth = 1
	)

/decl/cocktail/vodka_martini
	name = "vodka martini"
	description = "A bastardisation of the classic martini. Still great."
	ratios = list(
		/decl/material/liquid/ethanol/vodka =    4,
		/decl/material/liquid/ethanol/vermouth = 1
	)

/decl/cocktail/allies_cocktail
	name = "Allies Cocktail"
	description = "A drink made from your allies, not as sweet as when made from your enemies."
	ratios = list(
		/decl/material/liquid/ethanol/vermouth = 2,
		/decl/material/liquid/ethanol/vodka    = 2,
		/decl/material/liquid/ethanol/gin =      2
	)

/decl/cocktail/bilk
	name = "bilk"
	description =  "A foul brew of milk and beer. For alcoholics who fear osteoporosis."
	ratios = list(
		/decl/material/liquid/ethanol/beer = 1,
		/decl/material/liquid/drink/milk =   1
	)

/decl/cocktail/gin_and_tonic
	name = "gin and tonic"
	description = "A mild cocktail, widely considered an all-time classic."
	ratios = list(
		/decl/material/liquid/drink/tonic = 4,
		/decl/material/liquid/ethanol/gin = 1
	)

/decl/cocktail/cuba_libre
	name = "Cuba Libre"
	description = "A classic mix of rum and cola."
	ratios = list(
		/decl/material/liquid/drink/cola =  4,
		/decl/material/liquid/ethanol/rum = 1
	)

/decl/cocktail/black_russian
	name = "black Russian"
	description = "Similar to a white Russian, but fit for the lactose-intolerant."
	ratios = list(
		/decl/material/liquid/ethanol/vodka =  2,
		/decl/material/liquid/ethanol/coffee = 1
	)

/decl/cocktail/white_russian
	name = "white Russian"
	description = "A straightforward cocktail of coffee liqueur and vodka. Popular in a lot of places, but that's just, like, an opinion, man."
	ratios = list(
		/decl/material/liquid/ethanol/coffee =   2,
		/decl/material/liquid/drink/milk/cream,
		/decl/material/liquid/ethanol/vodka =    1
	)

/decl/cocktail/whiskey_cola
	name = "whiskey cola"
	description = "Whiskey mixed with cola. Quite refreshing."
	ratios = list(
		/decl/material/liquid/drink/cola =      4,
		/decl/material/liquid/ethanol/whiskey = 1
	)

/decl/cocktail/bloody_mary
	name = "Bloody Mary"
	description = "A cocktail of vodka, tomato and lime juice. Celery stalk optional."
	ratios = list(
		/decl/material/liquid/drink/juice/tomato = 3,
		/decl/material/liquid/ethanol/vodka =      1,
		/decl/material/liquid/drink/juice/lime =   1
	)

/decl/cocktail/livergeist
	name = "The Livergeist"
	description = "A cocktail pioneered by a small cabal with a vendetta against the liver. Drink very carefully."
	ratios = list(
		/decl/material/liquid/ethanol/vodka =        1,
		/decl/material/liquid/ethanol/gin =          1,
		/decl/material/liquid/ethanol/aged_whiskey = 1,
		/decl/material/liquid/ethanol/cognac =       1,
		/decl/material/liquid/drink/juice/lime =     1
	)

/decl/cocktail/brave_bull
	name = "Brave Bull"
	description = "A strong cocktail of tequila and coffee liquor."
	ratios = list(
		/decl/material/liquid/ethanol/tequila =   2,
		/decl/material/liquid/ethanol/coffee =    1
	)

/decl/cocktail/toxins_special
	name = "H2 Special"
	description = "Raise a glass to the bomb technicians of yesteryear, wherever their ashes now reside."
	ratios = list(
		/decl/material/liquid/ethanol/rum = 1,
		/decl/material/liquid/ethanol/vermouth = 1,
		/decl/material/solid/metallic_hydrogen
	)

/decl/cocktail/beepsky_smash
	name = "Beepsky Smash"
	description = "A cocktail originating with stationside security forces. Rumoured to take the edge off being stunned with your own baton."
	ratios = list(
		/decl/material/liquid/ethanol/whiskey =  2,
		/decl/material/liquid/drink/juice/lime = 1,
		/decl/material/solid/metal/iron
	)

/decl/cocktail/doctor_delight
	name = "Doctor's Delight"
	description = "A healthy mixture of juices and medication, guaranteed to keep you healthy until the next maintenance goblin decides to put a few new holes in you."
	ratios = list(
		/decl/material/liquid/regenerator =        3,
		/decl/material/liquid/drink/juice/lime =   1,
		/decl/material/liquid/drink/juice/tomato = 1,
		/decl/material/liquid/drink/juice/orange = 1,
		/decl/material/liquid/drink/milk/cream
	)

/decl/cocktail/manly_dorf
	name = "The Manly Dorf"
	description = "A cocktail of old that claims to be for manly men, but is mostly for people who can't tell beer and ale apart."
	ratios = list(
		/decl/material/liquid/ethanol/ale =  1,
		/decl/material/liquid/ethanol/beer = 1
	)

/decl/cocktail/irish_coffee
	name = "Irish coffee"
	description = "A cocktail of coffee, whiskey and cream, just the thing to kick you awake while also dulling the pain of existence."
	ratios = list(
		/decl/material/liquid/drink/coffee =        4,
		/decl/material/liquid/ethanol/irish_cream = 1
	)

/decl/cocktail/b52
	name = "B-52"
	description = "A semi-modern spin on an Irish coffee, featuring a dash of cognac. It will get you bombed."
	ratios = list(
		/decl/material/liquid/ethanol/coffee =      1,
		/decl/material/liquid/ethanol/irish_cream = 1,
		/decl/material/liquid/ethanol/cognac =      1
	)
	order_specific = TRUE // layered cocktail

/decl/cocktail/atomicbomb
	name = "Atomic Bomb"
	description = "A radioactive take on a B-52, popularized by asteroid miners with prosthetic organs and something to prove."
	ratios = list(
		/decl/material/liquid/ethanol/coffee =      1,
		/decl/material/liquid/ethanol/irish_cream = 1,
		/decl/material/liquid/ethanol/cognac =      1,
		/decl/material/solid/metal/uranium
	)
	order_specific = TRUE // layered cocktail

// todo: consider creating clear curacao for this
/decl/cocktail/margarita
	name = "margarita"
	description = "A classic cocktail of antiquity."
	ratios = list(
		/decl/material/liquid/ethanol/tequila = 3,
		/decl/material/liquid/drink/juice/lime = 1
	)

/decl/cocktail/longislandicedtea
	name = "Long Island Iced Tea"
	description = "Most of the liquor cabinet, brought together in a delicious mix. Designed for middle-aged alcoholics."
	ratios = list(
		/decl/material/liquid/drink/cola =      2,
		/decl/material/liquid/ethanol/rum =     1,
		/decl/material/liquid/ethanol/vodka =   1,
		/decl/material/liquid/ethanol/gin =     1,
		/decl/material/liquid/ethanol/tequila = 1
	)

/decl/cocktail/threemileisland
	name = "Three Mile Island Iced Tea"
	description = "Much like the Atomic Bomb, this cocktail was adapted by asteroid miners who couldn't enjoy a drink without a dose of radiation poisoning."
	ratios = list(
		/decl/material/liquid/drink/cola =      2,
		/decl/material/liquid/ethanol/rum =     1,
		/decl/material/liquid/ethanol/vodka =   1,
		/decl/material/liquid/ethanol/gin =     1,
		/decl/material/liquid/ethanol/tequila = 1,
		/decl/material/solid/metal/uranium
	)

/decl/cocktail/whiskeysoda
	name = "whiskey soda"
	description = "A simple cocktail, considered to be cultured and refined."
	ratios = list(
		/decl/material/liquid/drink/sodawater = 4,
		/decl/material/liquid/ethanol/whiskey = 1
	)

/decl/cocktail/manhattan
	name = "Manhattan"
	description = "Another classic cocktail of antiquity. Popular with private investigators."
	ratios = list(
		/decl/material/liquid/ethanol/whiskey =  2,
		/decl/material/liquid/ethanol/vermouth = 1
	)

/decl/cocktail/manhattan_proj
	name = "Manhattan Project"
	description = "A classic cocktail with a spicy twist, pioneered by a robot detective."
	ratios = list(
		/decl/material/liquid/ethanol/whiskey =  2,
		/decl/material/liquid/ethanol/vermouth = 1,
		/decl/material/solid/metal/uranium
	)

/decl/cocktail/vodka_tonic
	name = "vodka and tonic"
	description = "A simple, refreshing cocktail with a kick to it."
	ratios = list(
		/decl/material/liquid/drink/tonic =   4,
		/decl/material/liquid/ethanol/vodka = 1
	)

/decl/cocktail/gin_fizz
	name = "gin fizz"
	description = "A dry, refreshing cocktail with a tang of lime."
	ratios = list(
		/decl/material/liquid/ethanol/gin =      2,
		/decl/material/liquid/drink/sodawater =  2,
		/decl/material/liquid/drink/juice/lime = 1
	)

/decl/cocktail/bahama_mama
	name = "Bahama Mama"
	description = "A sweet tropical cocktail that is deceptively strong."
	ratios = list(
		/decl/material/liquid/ethanol/rum =        2,
		/decl/material/liquid/drink/juice/orange = 2,
		/decl/material/liquid/drink/juice/lime =   2,
		/decl/material/liquid/drink/grenadine =    1
	)

/decl/cocktail/singulo
	name = "Singulo"
	description = "Traditionally thrown together from maintenance stills and used to treat singularity exposure in engineers who forgot their meson goggles."
	ratios = list(
		/decl/material/liquid/ethanol/vodka = 1,
		/decl/material/liquid/ethanol/wine =  1,
		/decl/material/solid/metal/radium
	)

/decl/cocktail/demonsblood
	name = "Demon's Blood"
	description = "A ghoulish cocktail that originated as a practical joke in a fringe habitat."
	ratios = list(
		/decl/material/liquid/ethanol/rum =      2,
		/decl/material/liquid/drink/citrussoda = 2,
		/decl/material/liquid/drink/cherrycola = 2,
		/decl/material/liquid/blood =            1
	)

/decl/cocktail/booger
	name = "Booger"
	description = "A thick and creamy cocktail."
	ratios = list(
		/decl/material/liquid/drink/milk/cream =       2,
		/decl/material/liquid/ethanol/rum =            2,
		/decl/material/liquid/drink/juice/banana =     1,
		/decl/material/liquid/drink/juice/watermelon = 1
	)

/decl/cocktail/antifreeze
	name = "Anti-freeze"
	description = "A chilled cocktail invented and popularized by corona miners."
	ratios = list(
		/decl/material/liquid/ethanol/vodka =    3,
		/decl/material/liquid/drink/milk/cream = 2,
		/decl/material/solid/ice =               2
	)

/decl/cocktail/barefoot
	name = "Barefoot"
	description = "A smooth cocktail that will take your mind off the broken glass you stepped on."
	ratios = list(
		/decl/material/liquid/ethanol/vermouth =  4,
		/decl/material/liquid/drink/juice/berry = 2,
		/decl/material/liquid/drink/milk/cream =  1
	)

/decl/cocktail/sbiten
	name = "sbiten"
	description = "A form of spiced mead that will bring tears to the eyes of the most hardened drinker."
	ratios = list(
		/decl/material/liquid/ethanol/mead = 9,
		/decl/material/liquid/capsaicin =    1
	)

/decl/cocktail/red_mead
	name = "red mead"
	description = "Supposedly a traditional drink amongst mercenary groups prior to dangerous missions."
	ratios = list(
		/decl/material/liquid/ethanol/mead = 1,
		/decl/material/liquid/blood =        1
	)

/decl/cocktail/acidspit
	name = "Acid Spit"
	description = "A cocktail inspired by monsters of legend, popular with college students daring their friends to drink one."
	ratios = list(
		/decl/material/liquid/ethanol/wine = 1,
		/decl/material/liquid/acid
	)

// A screwdriver, with half the mixer replaced with other citrus juices.
/decl/cocktail/changelingsting
	name = "Changeling Sting"
	description = "A deceptively simple cocktail with a complex flavour profile. Rumours of causing paralysis and voice loss are common but unsubstantiated."
	ratios = list(
		/decl/material/liquid/drink/juice/orange = 2,
		/decl/material/liquid/drink/juice/lime =   1,
		/decl/material/liquid/drink/juice/lemon =  1,
		/decl/material/liquid/ethanol/vodka =      1
	)

/decl/cocktail/neurotoxin
	name = "Neurotoxin"
	description = "A cocktail primarily intended for people with a grudge against their own brain."
	ratios = list(
		/decl/material/liquid/ethanol/vodka =        1,
		/decl/material/liquid/ethanol/gin =          1,
		/decl/material/liquid/ethanol/aged_whiskey = 1,
		/decl/material/liquid/ethanol/cognac =       1,
		/decl/material/liquid/drink/juice/lime =     1,
		/decl/material/liquid/sedatives
	)

/decl/cocktail/snowwhite
	name = "Snow White"
	description = "A tangy, fizzy twist on beer."
	ratios = list(
		/decl/material/liquid/drink/lemon_lime = 3,
		/decl/material/liquid/ethanol/beer =     1
	)

/decl/cocktail/irishslammer
	name = "Irish Slammer"
	description = "A rich cocktail of whiskey, stout and cream that was performed using a shot glass before glass-interleaving technology was lost."
	ratios = list(
		/decl/material/liquid/ethanol/ale =         5,
		/decl/material/liquid/ethanol/whiskey =     1,
		/decl/material/liquid/ethanol/irish_cream = 1
	)

// A whiskey cola with added beer.
/decl/cocktail/syndicatebomb
	name = "Syndicate Bomb"
	description = "A murky cocktail reputed to have originated in criminal circles. It will definitely get you bombed."
	ratios = list(
		/decl/material/liquid/ethanol/whiskey = 1,
		/decl/material/liquid/ethanol/beer =    1,
		/decl/material/liquid/drink/cola =      4
	)

/decl/cocktail/devilskiss
	name = "Devil's Kiss"
	description = "A ghoulish cocktail popular in some of the weirder dive bars on the system fringe."
	ratios = list(
		/decl/material/liquid/ethanol/rum =    4,
		/decl/material/liquid/blood =          1,
		/decl/material/liquid/ethanol/coffee = 2
	)

/decl/cocktail/hippiesdelight
	name = "Hippy's Delight"
	description = "A complex cocktail that just might open your third eye."
	ratios = list(
		/decl/material/liquid/ethanol/vodka =        1,
		/decl/material/liquid/ethanol/gin =          1,
		/decl/material/liquid/ethanol/aged_whiskey = 1,
		/decl/material/liquid/ethanol/cognac =       1,
		/decl/material/liquid/drink/juice/lime =     1,
		/decl/material/liquid/psychotropics =        2
	)

/decl/cocktail/bananahonk
	name = "Banana Honk"
	description = "A virgin cocktail intended for the class clown. If someone orders you one of these, it is probably an insult."
	ratios = list(
		/decl/material/liquid/drink/juice/banana = 4,
		/decl/material/liquid/drink/milk/cream =   2,
		/decl/material/liquid/nutriment/sugar =    1
	)

/decl/cocktail/ships_surgeon
	name = "Ship's Surgeon"
	description = "A smooth, steady cocktail supposedly ordered by sawbones and surgeons of legend."
	ratios = list(
		/decl/material/liquid/drink/cherrycola = 4,
		/decl/material/liquid/ethanol/rum =      2
	)

/decl/cocktail/vodkacola
	name = "vodka cola"
	description = "A simple mix of cola and vodka, combining sweetness, fizz and a kick in the teeth."
	ratios = list(
		/decl/material/liquid/drink/cola =    2,
		/decl/material/liquid/ethanol/vodka = 1
	)

/decl/cocktail/sawbonesdismay
	name = "Sawbones' Dismay"
	description = "Legally, we are required to inform you that drinking this cocktail may invalidate your health insurance."
	ratios = list(
		/decl/material/liquid/ethanol/jagermeister = 1,
		/decl/material/liquid/drink/beastenergy =    1
	)

/decl/cocktail/patron
	name = "Patron"
	description = "Tequila mixed with flaked silver, for those with moderate expensive tastes."
	ratios = list(
		/decl/material/liquid/ethanol/tequila = 1,
		/decl/material/solid/metal/silver
	)

/decl/cocktail/rewriter
	name = "Rewriter"
	description = "A sickly concotion that college students and academics swear by for getting you through an all-nighter or six."
	ratios = list(
		/decl/material/liquid/drink/coffee =     1,
		/decl/material/liquid/drink/citrussoda = 1
	)

// TODO: add schnapps
/decl/cocktail/goldschlager
	name = "Goldschlager"
	description = "Schnapps mixed with flaked gold, for those with very expensive tastes."
	ratios = list(
		/decl/material/liquid/ethanol/vodka = 1,
		/decl/material/solid/metal/gold
	)

/decl/cocktail/browndwarf
	name = "Brown Dwarf"
	description = "A foamy chocolate beverage that has failed to sustain nuclear fusion."
	ratios = list(
		/decl/material/liquid/drink/hot_coco =   2,
		/decl/material/liquid/drink/citrussoda = 1
	)

/decl/cocktail/snowball
	name = "Snowball"
	description = "A cold pick-me-up frequently drunk in scientific outposts and academic offices."
	ratios = list(
		/decl/material/solid/ice =                     3,
		/decl/material/liquid/drink/coffee =           2,
		/decl/material/liquid/drink/juice/watermelon = 1
	)

/decl/cocktail/fools_gold
	name = "Fool's Gold"
	description = "Watered-down whiskey. Essentially grog, but without the pirates."
	ratios = list(
		/decl/material/liquid/water =           1,
		/decl/material/liquid/ethanol/whiskey = 1
	)
