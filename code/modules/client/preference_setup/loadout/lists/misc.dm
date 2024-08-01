/decl/loadout_option/cane
	name = "cane"
	path = /obj/item/cane
	uid = "gear_misc_cane"

/decl/loadout_option/dice
	name = "dice pack"
	path = /obj/item/pill_bottle/dice
	uid = "gear_misc_dice"

/decl/loadout_option/dice/nerd
	name = "dice pack (gaming)"
	path = /obj/item/pill_bottle/dice_nerd
	uid = "gear_misc_dice_gamer"

/decl/loadout_option/cards
	name = "deck of cards"
	path = /obj/item/deck/cards
	uid = "gear_misc_cards"

/decl/loadout_option/tarot
	name = "deck of tarot cards"
	path = /obj/item/deck/tarot
	uid = "gear_misc_cards_tarot"

/decl/loadout_option/holder
	name = "card holder"
	path = /obj/item/deck/holder
	uid = "gear_misc_card_holder"

/decl/loadout_option/cardemon_pack
	name = "Cardemon booster pack"
	path = /obj/item/pack/cardemon
	uid = "gear_misc_cardemon"

/decl/loadout_option/spaceball_pack
	name = "Spaceball booster pack"
	path = /obj/item/pack/spaceball
	uid = "gear_misc_spaceball"

/decl/loadout_option/flask
	name = "flask"
	path = /obj/item/chems/drinks/flask/barflask
	uid = "gear_misc_flask"

/decl/loadout_option/flask/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/reagents])
	.[/datum/gear_tweak/reagents] |= lunchables_ethanol_reagents()

/decl/loadout_option/vacflask
	name = "vacuum-flask"
	path = /obj/item/chems/drinks/flask/vacuumflask
	uid = "gear_misc_vacflask"

/decl/loadout_option/vacflask/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/reagents])
	.[/datum/gear_tweak/reagents] |= lunchables_drink_reagents()

/decl/loadout_option/coffeecup
	name = "coffee cup"
	path = /obj/item/chems/drinks/glass2/coffeecup
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	uid = "gear_misc_coffeecup"

/decl/loadout_option/towel
	name = "towel"
	path = /obj/item/towel
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_misc_towel"

/decl/loadout_option/mirror
	name = "handheld mirror"
	path = /obj/item/mirror
	uid = "gear_misc_mirror"

/decl/loadout_option/lipstick
	name = "lipstick selection"
	path = /obj/item/cosmetics/lipstick
	loadout_flags = GEAR_HAS_SUBTYPE_SELECTION
	uid = "gear_misc_lipstick"

/decl/loadout_option/eyeshadow
	name = "eyeshadow selection"
	path = /obj/item/cosmetics/eyeshadow
	loadout_flags = GEAR_HAS_SUBTYPE_SELECTION
	uid = "gear_misc_eyeshadow"

/decl/loadout_option/grooming
	name = "grooming tool selection"
	path = /obj/item/grooming
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_misc_grooming"

/decl/loadout_option/grooming/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"comb"           = /obj/item/grooming/comb/colorable,
		"butterfly comb" = /obj/item/grooming/comb/butterfly/colorable,
		"brush"          = /obj/item/grooming/brush/colorable,
		"file"           = /obj/item/grooming/file/colorable
	)

/decl/loadout_option/mask
	name = "sterile mask"
	path = /obj/item/clothing/mask/surgical
	cost = 2
	uid = "gear_misc_mask"

/decl/loadout_option/smokingpipe
	name = "pipe, smoking"
	path = /obj/item/clothing/mask/smokable/pipe
	uid = "gear_misc_pipe"

/decl/loadout_option/cornpipe
	name = "pipe, corn"
	path = /obj/item/clothing/mask/smokable/pipe/cobpipe
	uid = "gear_misc_cornpipe"

/decl/loadout_option/matchbook
	name = "matchbook"
	path = /obj/item/box/matches
	uid = "gear_misc_matches"

/decl/loadout_option/lighter
	name = "cheap lighter"
	path = /obj/item/flame/fuelled/lighter
	uid = "gear_misc_lighter"

/decl/loadout_option/lighter/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"random" = /obj/item/flame/fuelled/lighter/random,
		"red" =    /obj/item/flame/fuelled/lighter/red,
		"yellow" = /obj/item/flame/fuelled/lighter/yellow,
		"cyan" =   /obj/item/flame/fuelled/lighter/cyan,
		"green" =  /obj/item/flame/fuelled/lighter/green,
		"pink" =   /obj/item/flame/fuelled/lighter/pink
	)

/decl/loadout_option/ashtray
	name = "ashtray, plastic"
	path = /obj/item/ashtray/plastic
	uid = "gear_misc_ashtray"

/decl/loadout_option/ecig
	name = "electronic cigarette"
	path = /obj/item/clothing/mask/smokable/ecig/util
	uid = "gear_misc_ecig"

/decl/loadout_option/ecig/deluxe
	name = "electronic cigarette, deluxe"
	path = /obj/item/clothing/mask/smokable/ecig/deluxe
	cost = 2
	uid = "gear_misc_ecig_deluxe"

/decl/loadout_option/bible
	name = "holy book"
	path = /obj/item/bible
	cost = 2
	uid = "gear_misc_bible"

/decl/loadout_option/bible/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"bible (adjustable)" = /obj/item/bible,
		"Bible" =              /obj/item/bible/bible,
		"Tanakh" =             /obj/item/bible/tanakh,
		"Quran" =              /obj/item/bible/quran,
		"Kitab-i-Aqdas" =      /obj/item/bible/aqdas,
		"Kojiki" =             /obj/item/bible/kojiki
	)

/decl/loadout_option/cross
	name = "cross"
	path = /obj/item/cross
	cost = 2
	uid = "gear_misc_cross"

/decl/loadout_option/cross/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"cross, wood"=    /obj/item/cross,
		"cross, silver" = /obj/item/cross/silver,
		"cross, gold" =   /obj/item/cross/gold
	)

/decl/loadout_option/wallet
	name = "wallet, color select"
	path = /obj/item/wallet
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_misc_wallet"

/decl/loadout_option/wallet_poly
	name = "wallet, polychromic"
	path = /obj/item/wallet/poly
	cost = 2
	uid = "gear_misc_wallet_poly"


/decl/loadout_option/swiss
	name = "multi-tool"
	path = /obj/item/knife/folding/swiss
	cost = 4
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_misc_multitool"
