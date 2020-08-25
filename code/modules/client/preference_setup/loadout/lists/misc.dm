/datum/gear/cane
	display_name = "cane"
	path = /obj/item/cane

/datum/gear/union_card
	display_name = "union membership"
	path = /obj/item/card/union

/datum/gear/union_card/spawn_on_mob(var/mob/living/carbon/human/H, var/metadata)
	. = ..()
	if(.)
		var/obj/item/card/union/card = .
		card.signed_by = H.real_name

/datum/gear/dice
	display_name = "dice pack"
	path = /obj/item/storage/pill_bottle/dice

/datum/gear/dice/nerd
	display_name = "dice pack (gaming)"
	path = /obj/item/storage/pill_bottle/dice_nerd

/datum/gear/cards
	display_name = "deck of cards"
	path = /obj/item/deck/cards

/datum/gear/tarot
	display_name = "deck of tarot cards"
	path = /obj/item/deck/tarot

/datum/gear/holder
	display_name = "card holder"
	path = /obj/item/deck/holder

/datum/gear/cardemon_pack
	display_name = "Cardemon booster pack"
	path = /obj/item/pack/cardemon

/datum/gear/spaceball_pack
	display_name = "Spaceball booster pack"
	path = /obj/item/pack/spaceball

/datum/gear/flask
	display_name = "flask"
	path = /obj/item/chems/food/drinks/flask/barflask

/datum/gear/flask/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/reagents])
	.[/datum/gear_tweak/reagents] |= lunchables_ethanol_reagents()

/datum/gear/vacflask
	display_name = "vacuum-flask"
	path = /obj/item/chems/food/drinks/flask/vacuumflask

/datum/gear/vacflask/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/reagents])
	.[/datum/gear_tweak/reagents] |= lunchables_drink_reagents()

/datum/gear/coffeecup
	display_name = "coffee cup"
	path = /obj/item/chems/food/drinks/glass2/coffeecup
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/knives
	display_name = "knives selection"
	description = "A selection of knives."
	path = /obj/item/knife

/datum/gear/knives/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"folding knife" =             /obj/item/knife/folding,
		"peasant folding knife" =     /obj/item/knife/folding/wood,
		"tactical folding knife" =    /obj/item/knife/folding/tacticool,
		"utility knife" =             /obj/item/knife/utility,
		"lightweight utility knife" = /obj/item/knife/utility/lightweight
	)

/datum/gear/lunchbox
	display_name = "lunchbox"
	description = "A little lunchbox."
	cost = 2
	path = /obj/item/storage/lunchbox

/datum/gear/lunchbox/get_gear_tweak_options()
	. = ..()
	var/list/lunchboxes = list()
	for(var/lunchbox_type in typesof(/obj/item/storage/lunchbox))
		var/obj/item/storage/lunchbox/lunchbox = lunchbox_type
		if(!initial(lunchbox.filled))
			lunchboxes[initial(lunchbox.name)] = lunchbox_type
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= lunchboxes

/datum/gear/lunchbox/New()
	..()
	// This one won't accept a list() without refactoring so just leaving the direct insertion alone.
	gear_tweaks += new /datum/gear_tweak/contents(lunchables_lunches(), lunchables_snacks(), lunchables_drinks())

/datum/gear/towel
	display_name = "towel"
	path = /obj/item/towel
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/plush_toy
	display_name = "plush toy"
	description = "A plush toy."
	path = /obj/item/toy/plushie

/datum/gear/plush_toy/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"mouse plush" =  /obj/item/toy/plushie/mouse,
		"kitten plush" = /obj/item/toy/plushie/kitten,
		"lizard plush" = /obj/item/toy/plushie/lizard,
		"spider plush" = /obj/item/toy/plushie/spider
	)

/datum/gear/passport
	display_name = "passport"
	path = /obj/item/passport
	custom_setup_proc = /obj/item/passport/proc/set_info

/datum/gear/mirror
	display_name = "handheld mirror"
	sort_category = "Cosmetics"
	path = /obj/item/mirror

/datum/gear/lipstick
	display_name = "lipstick selection"
	sort_category = "Cosmetics"
	path = /obj/item/lipstick
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/comb
	display_name = "plastic comb"
	path = /obj/item/haircomb
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/mask
	display_name = "sterile mask"
	path = /obj/item/clothing/mask/surgical
	cost = 2

/datum/gear/smokingpipe
	display_name = "pipe, smoking"
	path = /obj/item/clothing/mask/smokable/pipe

/datum/gear/cornpipe
	display_name = "pipe, corn"
	path = /obj/item/clothing/mask/smokable/pipe/cobpipe

/datum/gear/matchbook
	display_name = "matchbook"
	path = /obj/item/storage/box/matches

/datum/gear/lighter
	display_name = "cheap lighter"
	path = /obj/item/flame/lighter

/datum/gear/lighter/get_gear_tweak_options()
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

/datum/gear/zippo
	display_name = "zippo"
	path = /obj/item/flame/lighter/zippo

/datum/gear/zippo/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"random" =    /obj/item/flame/lighter/zippo/random,
		"silver" =    /obj/item/flame/lighter/zippo,
		"blackened" = /obj/item/flame/lighter/zippo/black,
		"gunmetal" =  /obj/item/flame/lighter/zippo/gunmetal,
		"bronze" =    /obj/item/flame/lighter/zippo/bronze,
		"pink" =      /obj/item/flame/lighter/zippo/pink
	)

/datum/gear/ashtray
	display_name = "ashtray, plastic"
	path = /obj/item/ashtray/plastic

/datum/gear/cigars
	display_name = "fancy cigar case"
	path = /obj/item/storage/fancy/cigar
	cost = 2

/datum/gear/cigar
	display_name = "fancy cigar"
	path = /obj/item/clothing/mask/smokable/cigarette/cigar

/datum/gear/cigar/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"premium" =        /obj/item/clothing/mask/smokable/cigarette/cigar,
		"Cohiba Robusto" = /obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	)

/datum/gear/ecig
	display_name = "electronic cigarette"
	path = /obj/item/clothing/mask/smokable/ecig/util

/datum/gear/ecig/deluxe
	display_name = "electronic cigarette, deluxe"
	path = /obj/item/clothing/mask/smokable/ecig/deluxe
	cost = 2

/datum/gear/bible
	display_name = "holy book"
	path = /obj/item/storage/bible
	cost = 2

/datum/gear/bible/get_gear_tweak_options()
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

/datum/gear/swiss
	display_name = "multi-tool"
	path = /obj/item/knife/folding/swiss
	cost = 4
	flags = GEAR_HAS_COLOR_SELECTION


/datum/gear/cross
	display_name = "cross"
	path = /obj/item/cross
	cost = 2

/datum/gear/cross/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"cross, wood"=    /obj/item/cross,
		"cross, silver" = /obj/item/cross/silver,
		"cross, gold" =   /obj/item/cross/gold
	)