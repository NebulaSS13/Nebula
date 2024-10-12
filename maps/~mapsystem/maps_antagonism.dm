/datum/map
	var/list/potential_theft_targets = list(
		"the captain's antique laser gun"    = /obj/item/gun/energy/captain,
		"a wormhole generator"               = /obj/item/integrated_circuit/manipulation/wormhole,
		"an RCD"                             = /obj/item/rcd,
		"a jetpack"                          = /obj/item/tank/jetpack,
		"a captain's jumpsuit"               = /obj/item/clothing/jumpsuit/captain,
		"a functional AI"                    = /obj/item/aicard,
		"a pair of magboots"                 = /obj/item/clothing/shoes/magboots,
		"the master blueprints"              = /obj/item/blueprints,
		"a nasa voidsuit"                    = /obj/item/clothing/suit/space/void,
		"full tank of phoron"                = /obj/item/tank/phoron,
		"full tank of hydrogen"              = /obj/item/tank/hydrogen,
		"a piece of corgi meat"              = /obj/item/food/butchery/meat/corgi,
		"a chief science officer's jumpsuit" = /obj/item/clothing/jumpsuit/research_director,
		"a chief engineer's jumpsuit"        = /obj/item/clothing/jumpsuit/chief_engineer,
		"a chief medical officer's jumpsuit" = /obj/item/clothing/jumpsuit/chief_medical_officer,
		"a head of security's jumpsuit"      = /obj/item/clothing/jumpsuit/head_of_security,
		"a head of personnel's jumpsuit"     = /obj/item/clothing/jumpsuit/head_of_personnel,
		"the hypospray"                      = /obj/item/chems/hypospray,
		"the captain's pinpointer"           = /obj/item/pinpointer,
		"an ablative armor vest"             = /obj/item/clothing/suit/armor/laserproof
	)

	var/list/potential_special_theft_targets = list(
		"nuclear gun"         = /obj/item/gun/energy/gun/nuclear,
		"diamond drill"       = /obj/item/tool/drill/diamond,
		"bag of holding"      = /obj/item/backpack/holding,
		"hyper-capacity cell" = /obj/item/cell/hyper,
		"10 diamonds"         = list(/obj/item/stack/material/gemstone, 10, /decl/material/solid/gemstone/diamond),
		"50 gold ingots"      = list(/obj/item/stack/material/ingot,    50, /decl/material/solid/metal/gold),
		"25 uranium pucks"    = list(/obj/item/stack/material/puck,     25, /decl/material/solid/metal/uranium),
	)

/datum/map/proc/get_theft_targets()
	. = potential_theft_targets

/datum/map/proc/get_special_theft_targets()
	. = potential_special_theft_targets
