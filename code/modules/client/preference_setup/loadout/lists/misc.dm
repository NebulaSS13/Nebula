/decl/loadout_option/cane
	name = "cane"
	path = /obj/item/cane

/decl/loadout_option/dice
	name = "dice pack"
	path = /obj/item/storage/pill_bottle/dice

/decl/loadout_option/dice/nerd
	name = "dice pack (gaming)"
	path = /obj/item/storage/pill_bottle/dice_nerd

/decl/loadout_option/cards
	name = "deck of cards"
	path = /obj/item/deck/cards

/decl/loadout_option/tarot
	name = "deck of tarot cards"
	path = /obj/item/deck/tarot

/decl/loadout_option/holder
	name = "card holder"
	path = /obj/item/deck/holder

/decl/loadout_option/cardemon_pack
	name = "Cardemon booster pack"
	path = /obj/item/pack/cardemon

/decl/loadout_option/spaceball_pack
	name = "Spaceball booster pack"
	path = /obj/item/pack/spaceball

/decl/loadout_option/flask
	name = "flask"
	path = /obj/item/chems/drinks/flask/barflask

/decl/loadout_option/flask/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/reagents])
	.[/datum/gear_tweak/reagents] |= lunchables_ethanol_reagents()

/decl/loadout_option/vacflask
	name = "vacuum-flask"
	path = /obj/item/chems/drinks/flask/vacuumflask

/decl/loadout_option/vacflask/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/reagents])
	.[/datum/gear_tweak/reagents] |= lunchables_drink_reagents()

/decl/loadout_option/coffeecup
	name = "coffee cup"
	path = /obj/item/chems/drinks/glass2/coffeecup
	flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/towel
	name = "towel"
	path = /obj/item/towel
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/mirror
	name = "handheld mirror"
	path = /obj/item/mirror

/decl/loadout_option/lipstick
	name = "lipstick selection"
	path = /obj/item/lipstick
	flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/comb
	name = "plastic comb"
	path = /obj/item/haircomb
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/mask
	name = "sterile mask"
	path = /obj/item/clothing/mask/surgical
	cost = 2

/decl/loadout_option/smokingpipe
	name = "pipe, smoking"
	path = /obj/item/clothing/mask/smokable/pipe

/decl/loadout_option/cornpipe
	name = "pipe, corn"
	path = /obj/item/clothing/mask/smokable/pipe/cobpipe

/decl/loadout_option/matchbook
	name = "matchbook"
	path = /obj/item/storage/box/matches

/decl/loadout_option/lighter
	name = "cheap lighter"
	path = /obj/item/flame/lighter

/decl/loadout_option/lighter/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"random" = /obj/item/flame/lighter/random,
		"red" =    /obj/item/flame/lighter/red,
		"yellow" = /obj/item/flame/lighter/yellow,
		"cyan" =   /obj/item/flame/lighter/cyan,
		"green" =  /obj/item/flame/lighter/green,
		"pink" =   /obj/item/flame/lighter/pink
	)

/decl/loadout_option/ashtray
	name = "ashtray, plastic"
	path = /obj/item/ashtray/plastic

/decl/loadout_option/ecig
	name = "electronic cigarette"
	path = /obj/item/clothing/mask/smokable/ecig/util

/decl/loadout_option/ecig/deluxe
	name = "electronic cigarette, deluxe"
	path = /obj/item/clothing/mask/smokable/ecig/deluxe
	cost = 2

/decl/loadout_option/bible
	name = "holy book"
	path = /obj/item/storage/bible
	cost = 2

/decl/loadout_option/bible/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"bible (adjustable)" = /obj/item/storage/bible,
		"Bible" =              /obj/item/storage/bible/bible,
		"Tanakh" =             /obj/item/storage/bible/tanakh,
		"Quran" =              /obj/item/storage/bible/quran,
		"Kitab-i-Aqdas" =      /obj/item/storage/bible/aqdas,
		"Kojiki" =             /obj/item/storage/bible/kojiki
	)

/decl/loadout_option/cross
	name = "cross"
	path = /obj/item/cross
	cost = 2

/decl/loadout_option/cross/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"cross, wood"=    /obj/item/cross,
		"cross, silver" = /obj/item/cross/silver,
		"cross, gold" =   /obj/item/cross/gold
	)

/decl/loadout_option/wallet
	name = "wallet, colour select"
	path = /obj/item/storage/wallet
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/wallet_poly
	name = "wallet, polychromic"
	path = /obj/item/storage/wallet/poly
	cost = 2


/decl/loadout_option/swiss
	name = "multi-tool"
	path = /obj/item/knife/folding/swiss
	cost = 4
	flags = GEAR_HAS_COLOR_SELECTION
