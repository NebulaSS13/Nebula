/obj/random/contraband
	name = "Random Illegal Item"
	desc = "Hot Stuff."
	icon = 'icons/obj/items/grooming/comb.dmi'
	icon_state = ICON_STATE_WORLD
	color = COLOR_PURPLE
	spawn_nothing_percentage = 50

/obj/random/contraband/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/grooming/comb                        = 4,
		/obj/item/pill_bottle/painkillers              = 3,
		/obj/item/pill_bottle/strong_painkillers       = 1,
		/obj/item/pill_bottle/happy                    = 2,
		/obj/item/pill_bottle/zoom                     = 2,
		/obj/item/chems/glass/beaker/vial/random/toxin = 1,
		/obj/item/chems/glass/beaker/sulphuric         = 1,
		/obj/item/poster                               = 5,
		/obj/item/butterflyblade                       = 3,
		/obj/item/butterflyhandle                      = 3,
		/obj/item/baton/cattleprod                     = 1,
		/obj/item/knife/combat                         = 1,
		/obj/item/knife/folding                        = 1,
		/obj/item/knife/folding/wood                   = 1,
		/obj/item/knife/folding/combat/balisong        = 2,
		/obj/item/knife/folding/combat/switchblade     = 1,
		/obj/item/secure_storage/briefcase/money       = 1,
		/obj/item/box/syndie_kit/cigarette             = 1,
		/obj/item/stack/telecrystal                    = 1,
		/obj/item/clothing/shirt/syndicate             = 2,
		/obj/item/chems/syringe                        = 3,
		/obj/item/chems/syringe/steroid                = 2,
		/obj/item/chems/syringe/drugs                  = 1,
		/obj/item/food/egg/lizard                = 3
	)
	return spawnable_choices

/obj/random/drinkingglass
	name = "random drinking glass"
	desc = "This is a random drinking glass."
	icon = 'icons/obj/drink_glasses/square.dmi'
	icon_state = "square"

/obj/random/drinkingglass/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/drinks/glass2/square,
		/obj/item/chems/drinks/glass2/rocks,
		/obj/item/chems/drinks/glass2/shake,
		/obj/item/chems/drinks/glass2/cocktail,
		/obj/item/chems/drinks/glass2/shot,
		/obj/item/chems/drinks/glass2/pint,
		/obj/item/chems/drinks/glass2/mug,
		/obj/item/chems/drinks/glass2/wine
	)
	return spawnable_choices

/obj/random/drinkbottle
	name = "random drink"
	desc = "This is a random drink."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "whiskeybottle"

/obj/random/drinkbottle/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/drinks/bottle/whiskey,
		/obj/item/chems/drinks/bottle/gin,
		/obj/item/chems/drinks/bottle/agedwhiskey,
		/obj/item/chems/drinks/bottle/vodka,
		/obj/item/chems/drinks/bottle/tequila,
		/obj/item/chems/drinks/bottle/absinthe,
		/obj/item/chems/drinks/bottle/wine,
		/obj/item/chems/drinks/bottle/cognac,
		/obj/item/chems/drinks/bottle/rum,
		/obj/item/chems/drinks/bottle/patron
	)
	return spawnable_choices

/obj/random/useful
	name = "random useful item"
	desc = "This is a random useful item."
	icon = 'icons/obj/items/storage/trashbag.dmi'
	icon_state = "trashbag3"

/obj/random/useful/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/random/crayon,
		/obj/item/pen,
		/obj/item/pen/blue,
		/obj/item/pen/red,
		/obj/item/pen/multi,
		/obj/item/box/matches,
		/obj/item/stack/material/cardstock/mapped/cardboard,
		/obj/item/box/fancy/cigarettes,
		/obj/item/deck/cards
	)
	return spawnable_choices

/obj/random/natural_debris // Natural crap that you might fish out of a river in unspoiled countryside.
	name = "random natural detritus"
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"

// We really have a limited amount of random crap, don't we...
/obj/random/natural_debris/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/remains/mouse,
		/obj/item/remains/lizard,
		/obj/item/stick,
		/obj/item/trash/mollusc_shell,
		/obj/item/trash/mollusc_shell/clam,
		/obj/item/trash/mollusc_shell/barnacle
	)
	return spawnable_choices

/obj/random/junk //Broken items, or stuff that could be picked up
	name = "random junk"
	desc = "This is some random junk."
	icon = 'icons/obj/items/storage/trashbag.dmi'
	icon_state = "trashbag3"
	var/spawn_choice

/obj/random/junk/spawn_choices()
	var/static/list/spawnable_choices
	if(!spawnable_choices)
		spawnable_choices = list(
			/obj/effect/decal/cleanable/generic            = 20,
			/obj/effect/decal/cleanable/spiderling_remains = 95,
			/obj/item/remains/mouse                        = 95,
			/obj/item/remains/robot                        = 95,
			/obj/item/paper/crumpled                       = 95,
			/obj/item/inflatable/torn                      = 95,
			/obj/effect/decal/cleanable/molten_item        = 95,
			/obj/item/shard                                = 95,
			/obj/item/hand/missing_card                    = 95,
			/obj/random/useful                             =  4
		)
		for(var/trash_type in subtypesof(/obj/item/trash))
			spawnable_choices[trash_type] = 95
		for(var/trash_type in typesof(/obj/item/trash/cigbutt))
			spawnable_choices[trash_type] = 95
		spawnable_choices -= /obj/item/trash/snack_bowl
		spawnable_choices -= /obj/item/trash/syndi_cakes
		var/lunches = lunchables_lunches()
		for(var/lunch in lunches)
			spawnable_choices[lunches[lunch]] = 1
	return spawnable_choices

/obj/random/trash //Mostly remains and cleanable decals. Stuff a janitor could clean up
	name = "random trash"
	desc = "This is some random trash."
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenglow"

/obj/random/trash/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/remains/lizard,
		/obj/effect/decal/cleanable/blood/gibs/robot,
		/obj/effect/decal/cleanable/blood/oil,
		/obj/effect/decal/cleanable/blood/oil/streak,
		/obj/effect/decal/cleanable/spiderling_remains,
		/obj/item/remains/mouse,
		/obj/effect/decal/cleanable/vomit,
		/obj/effect/decal/cleanable/blood/splatter,
		/obj/effect/decal/cleanable/ash,
		/obj/effect/decal/cleanable/generic,
		/obj/effect/decal/cleanable/flour,
		/obj/effect/decal/cleanable/dirt,
		/obj/item/remains/robot
	)
	return spawnable_choices

/obj/random/coin
	name = "random coin"
	desc = "This is a random coin."
	icon = 'icons/obj/items/coin.dmi'
	icon_state = "coin1"

/obj/random/coin/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/coin/gold     = 3,
		/obj/item/coin/silver   = 4,
		/obj/item/coin/diamond  = 2,
		/obj/item/coin/iron     = 4,
		/obj/item/coin/uranium  = 3,
		/obj/item/coin/platinum = 1
	)
	return spawnable_choices

/obj/random/material //Random materials for building stuff
	name = "random material"
	desc = "This is a random material."
	icon = 'icons/obj/items/stacks/materials.dmi'
	icon_state = "sheet"

/obj/random/material/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/stack/material/sheet/mapped/steel/ten,
		/obj/item/stack/material/pane/mapped/glass/ten,
		/obj/item/stack/material/pane/mapped/rglass/ten,
		/obj/item/stack/material/panel/mapped/plastic/ten,
		/obj/item/stack/material/plank/mapped/wood/ten,
		/obj/item/stack/material/cardstock/mapped/cardboard/ten,
		/obj/item/stack/material/sheet/reinforced/mapped/plasteel/ten,
		/obj/item/stack/material/sheet/mapped/steel/fifty,
		/obj/item/stack/material/sheet/reinforced/mapped/fiberglass/fifty,
		/obj/item/stack/material/ingot/mapped/copper/fifty,
		/obj/item/stack/material/pane/mapped/glass/fifty,
		/obj/item/stack/material/pane/mapped/rglass/fifty,
		/obj/item/stack/material/panel/mapped/plastic/fifty,
		/obj/item/stack/material/plank/mapped/wood/fifty,
		/obj/item/stack/material/cardstock/mapped/cardboard/fifty,
		/obj/item/stack/material/sheet/reinforced/mapped/plasteel/fifty,
		/obj/item/stack/material/rods/ten,
		/obj/item/stack/material/rods/fifty
	)
	return spawnable_choices

/obj/random/soap
	name = "Random Cleaning Supplies"
	desc = "This is a random bar of soap. Soap! SOAP?! SOAP!!!"
	icon = 'icons/obj/items/random_spawn.dmi'
	icon_state = "soaprandom"

/obj/random/soap/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/soap                         = 12,
		/obj/item/chems/glass/rag              =  2,
		/obj/item/chems/spray/cleaner          =  2,
		/obj/item/grenade/chem_grenade/cleaner =  1
	)
	return spawnable_choices

/obj/random/obstruction //Large objects to block things off in maintenance
	name = "random obstruction"
	desc = "This is a random obstruction."
	icon = 'icons/obj/cult.dmi'
	icon_state = "cultgirder"

/obj/random/obstruction/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/structure/barricade,
		/obj/structure/girder,
		/obj/structure/girder/displaced,
		/obj/structure/grille,
		/obj/structure/grille/broken,
		/obj/structure/foamedmetal,
		/obj/item/caution,
		/obj/item/caution/cone,
		/obj/structure/inflatable/wall,
		/obj/structure/inflatable/door
	)
	return spawnable_choices

/obj/random/smokes
	name = "random smokeable"
	desc = "This is a random smokeable item."
	icon = 'icons/obj/items/storage/cigpack/acme.dmi'
	icon_state = "Bpacket"

/obj/random/smokes/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/box/fancy/cigarettes                          = 5,
		/obj/item/box/fancy/cigarettes/dromedaryco              = 4,
		/obj/item/box/fancy/cigarettes/killthroat               = 1,
		/obj/item/box/fancy/cigarettes/luckystars               = 3,
		/obj/item/box/fancy/cigarettes/jerichos                 = 3,
		/obj/item/box/fancy/cigarettes/menthols                 = 2,
		/obj/item/box/fancy/cigarettes/carcinomas               = 3,
		/obj/item/box/fancy/cigarettes/professionals            = 2,
		/obj/item/box/fancy/cigar                               = 1,
		/obj/item/clothing/mask/smokable/cigarette              = 2,
		/obj/item/clothing/mask/smokable/cigarette/menthol      = 2,
		/obj/item/clothing/mask/smokable/cigarette/cigar        = 1,
		/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba = 1,
		/obj/item/clothing/mask/smokable/cigarette/cigar/havana = 1
	)
	return spawnable_choices

/obj/random/storage
	name = "random storage item"
	desc = "This is a storage item."
	icon = 'icons/obj/items/storage/box.dmi'
	icon_state = "idOld"

/obj/random/storage/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/secure_storage/briefcase       = 2,
		/obj/item/briefcase                      = 4,
		/obj/item/briefcase/inflatable           = 3,
		/obj/item/backpack                       = 5,
		/obj/item/backpack/satchel               = 5,
		/obj/item/backpack/dufflebag             = 2,
		/obj/item/box                            = 5,
		/obj/item/box/donkpockets                = 3,
		/obj/item/box/sinpockets                 = 1,
		/obj/item/box/fancy/donut                = 2,
		/obj/item/box/cups                       = 3,
		/obj/item/box/mousetraps                 = 4,
		/obj/item/box/engineer                   = 3,
		/obj/item/box/autoinjectors              = 2,
		/obj/item/box/beakers                    = 3,
		/obj/item/box/syringes                   = 3,
		/obj/item/box/gloves                     = 3,
		/obj/item/box/large                      = 2,
		/obj/item/box/glowsticks                 = 3,
		/obj/item/wallet                         = 1,
		/obj/item/ore                            = 2,
		/obj/item/belt/utility/full              = 2,
		/obj/item/belt/medical/emt               = 2,
		/obj/item/belt/medical                   = 2,
		/obj/item/belt/holster/security          = 2,
		/obj/item/belt/holster/security/tactical = 1
	)
	return spawnable_choices

/obj/random/cash
	name = "random currency"
	desc = "LOADSAMONEY!"
	icon = 'icons/obj/items/money.dmi'
	icon_state = "cash"

/obj/random/cash/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/cash/c1    = 4,
		/obj/item/cash/c10   = 3,
		/obj/item/cash/c20   = 3,
		/obj/item/cash/c50   = 2,
		/obj/item/cash/c100  = 2,
		/obj/item/cash/c1000 = 1
	)
	return spawnable_choices

/obj/random/loot /*Better loot for away missions and salvage */
	name = "random loot"
	desc = "This is some random loot."
	icon = 'icons/obj/items/gift_wrapped.dmi'
	icon_state = "gift_3"

/obj/random/loot/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/random/energy                                            = 10,
		/obj/random/projectile                                        = 10,
		/obj/random/voidhelmet                                        = 10,
		/obj/random/voidsuit                                          = 10,
		/obj/random/hardsuit                                          = 10,
		/obj/item/clothing/mask/gas/syndicate                         = 10,
		/obj/item/clothing/mask/muzzle                                =  7,
		/obj/item/clothing/glasses/night                              =  3,
		/obj/item/clothing/glasses/thermal                            =  1,
		/obj/item/clothing/glasses/welding/superior                   =  7,
		/obj/item/clothing/head/collectable/petehat                   =  4,
		/obj/item/clothing/suit/armor/pcarrier/merc                   =  3,
		/obj/item/clothing/suit/straight_jacket                       =  6,
		/obj/item/clothing/head/helmet/merc                           =  3,
		/obj/item/stack/material/gemstone/mapped/diamond/ten          =  7,
		/obj/item/stack/material/pane/mapped/rborosilicate/ten        =  7,
		/obj/item/stack/material/brick/mapped/marble/ten              =  8,
		/obj/item/stack/material/ingot/mapped/gold/ten                =  7,
		/obj/item/stack/material/ingot/mapped/silver/ten              =  7,
		/obj/item/stack/material/ingot/mapped/osmium/ten              =  7,
		/obj/item/stack/material/ingot/mapped/platinum/ten            =  8,
		/obj/item/stack/material/aerogel/mapped/tritium/ten           =  7,
		/obj/item/stack/material/segment/mapped/mhydrogen/ten         =  6,
		/obj/item/stack/material/sheet/reinforced/mapped/plasteel/ten =  9,
		/obj/item/stack/material/ingot/mapped/copper/ten              =  8,
		/obj/item/box/monkeycubes                                     =  5,
		/obj/item/firstaid/surgery                                    =  4,
		/obj/item/cell/infinite                                       =  1,
		/obj/random/archaeological_find                               =  2,
		/obj/item/multitool/hacktool                                  =  2,
		/obj/item/surgicaldrill                                       =  7,
		/obj/item/sutures                                             =  7,
		/obj/item/retractor                                           =  7,
		/obj/item/hemostat                                            =  7,
		/obj/item/cautery                                             =  7,
		/obj/item/bonesetter                                          =  7,
		/obj/item/bonegel                                             =  7,
		/obj/item/circular_saw                                        =  7,
		/obj/item/scalpel                                             =  7,
		/obj/item/baton/loaded                                        =  9,
		/obj/item/radio/headset/hacked                                =  6
	)
	return spawnable_choices

/obj/random/vendor
	name = "random vending machine"
	desc = "This is a randomly selected vending machine."
	icon = 'icons/obj/vending.dmi'
	icon_state = "coffee-hellfire"

/obj/random/vendor/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/machinery/vending/weeb,
		/obj/machinery/vending/sol,
		/obj/machinery/vending/snix
	)
	return spawnable_choices

/obj/random/lipstick
	name = "random lipstick"
	desc = "This is a tube of lipstick."
	icon = 'icons/obj/items/cosmetics/lipstick.dmi'
	icon_state = "lipstick_closed"

/obj/random/lipstick/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/cosmetics/lipstick/red,
		/obj/item/cosmetics/lipstick/blue,
		/obj/item/cosmetics/lipstick/green,
		/obj/item/cosmetics/lipstick/turquoise,
		/obj/item/cosmetics/lipstick/violet,
		/obj/item/cosmetics/lipstick/yellow,
		/obj/item/cosmetics/lipstick/orange,
		/obj/item/cosmetics/lipstick/white,
		/obj/item/cosmetics/lipstick/black
	)
	return spawnable_choices

/obj/random/eyeshadow
	name = "random eyeshadow"
	desc = "This is a tube of eyeshadow."
	icon = 'icons/obj/items/cosmetics/eyeshadow.dmi'
	icon_state = "eyeshadow_closed"

/obj/random/eyeshadow/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/cosmetics/eyeshadow/red,
		/obj/item/cosmetics/eyeshadow/blue,
		/obj/item/cosmetics/eyeshadow/green,
		/obj/item/cosmetics/eyeshadow/turquoise,
		/obj/item/cosmetics/eyeshadow/violet,
		/obj/item/cosmetics/eyeshadow/yellow,
		/obj/item/cosmetics/eyeshadow/orange,
		/obj/item/cosmetics/eyeshadow/white,
		/obj/item/cosmetics/eyeshadow/black
	)
	return spawnable_choices

/obj/random/makeup
	name = "random makeup"
	desc = "This is a tube of makeup."
	icon = 'icons/obj/items/cosmetics/lipstick.dmi'
	icon_state = "lipstick_closed"

/obj/random/makeup/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/cosmetics/lipstick/red,
		/obj/item/cosmetics/lipstick/blue,
		/obj/item/cosmetics/lipstick/green,
		/obj/item/cosmetics/lipstick/turquoise,
		/obj/item/cosmetics/lipstick/violet,
		/obj/item/cosmetics/lipstick/yellow,
		/obj/item/cosmetics/lipstick/orange,
		/obj/item/cosmetics/lipstick/white,
		/obj/item/cosmetics/lipstick/black,
		/obj/item/cosmetics/eyeshadow/red,
		/obj/item/cosmetics/eyeshadow/blue,
		/obj/item/cosmetics/eyeshadow/green,
		/obj/item/cosmetics/eyeshadow/turquoise,
		/obj/item/cosmetics/eyeshadow/violet,
		/obj/item/cosmetics/eyeshadow/yellow,
		/obj/item/cosmetics/eyeshadow/orange,
		/obj/item/cosmetics/eyeshadow/white,
		/obj/item/cosmetics/eyeshadow/black
	)
	return spawnable_choices

/obj/random/crayon
	name = "random crayon"
	desc = "This is a random crayon."
	icon = 'icons/obj/items/crayons.dmi'
	icon_state = "crayonred"

/obj/random/crayon/spawn_choices()
	var/static/list/spawnable_choices = subtypesof(/obj/item/pen/crayon)
	return spawnable_choices

/obj/random/umbrella
	name = "Random Umbrella"
	desc = "This is a random umbrella."
	icon = 'icons/obj/items/umbrella.dmi'
	icon_state = "map"
	color = COLOR_GRAY20

/obj/random/umbrella/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/umbrella,
		/obj/item/umbrella/blue,
		/obj/item/umbrella/green,
		/obj/item/umbrella/red,
		/obj/item/umbrella/yellow,
		/obj/item/umbrella/orange,
		/obj/item/umbrella/purple
	)
	return spawnable_choices

/obj/random/single/playing_cards
	name = "randomly spawned deck of cards"
	icon = 'icons/obj/items/playing_cards.dmi'
	icon_state = "deck"
	spawn_object = /obj/item/deck

/obj/random/single/lighter
	name = "randomly spawned lighter"
	icon = 'icons/obj/items/flame/lighter.dmi'
	icon_state = ICON_STATE_WORLD
	spawn_object = /obj/item/flame/fuelled/lighter

/obj/random/jewelry
	name = "Random Jewelry"
	desc = "Shiny things."
	icon = 'icons/obj/items/grooming/comb.dmi'
	icon_state = ICON_STATE_WORLD
	color = COLOR_GOLD

/obj/random/jewelry/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/clothing/ears/stud/wood                = 10,
		/obj/item/clothing/ears/dangle/wood              = 10,
		/obj/item/clothing/gloves/bracelet               = 10,
		/obj/item/clothing/neck/necklace                 = 10,
		/obj/item/clothing/gloves/ring/material/silver   = 5,
		/obj/item/clothing/gloves/ring/material/bronze   = 5,
		/obj/item/clothing/gloves/ring/material/gold     = 3,
		/obj/item/clothing/ears/stud/silver              = 3,
		/obj/item/clothing/ears/dangle/silver            = 3,
		/obj/item/clothing/ears/stud/gold                = 3,
		/obj/item/clothing/ears/dangle/gold              = 3,
		/obj/item/clothing/gloves/ring/material/platinum = 1,
		/obj/item/clothing/ears/stud/platinum            = 1,
		/obj/item/clothing/ears/dangle/platinum          = 1,
		/obj/item/clothing/ears/stud/diamond             = 1,
		/obj/item/clothing/ears/dangle/diamond           = 1

	)
	return spawnable_choices
