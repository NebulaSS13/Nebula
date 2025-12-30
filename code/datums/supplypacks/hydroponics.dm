/decl/hierarchy/supply_pack/hydroponics
	name = "Hydroponics"
	containertype = /obj/structure/closet/crate/hydroponics

/decl/hierarchy/supply_pack/hydroponics/hydroponics // -- Skie
	name = "Gear - Hydroponics Supplies"
	contains = list(/obj/item/chems/spray/plantbgone = 4,
					/obj/item/chems/glass/bottle/ammonia = 2,
					/obj/item/tool/axe/hatchet,
					/obj/item/tool/hoe/mini,
					/obj/item/scanner/plant,
					/obj/item/clothing/gloves/thick/botany,
					/obj/item/clothing/suit/apron,
					/obj/item/tool/hoe/mini,
					/obj/item/box/botanydisk
					)
	containername = "hydroponics supply crate"
	access = access_hydroponics

/decl/hierarchy/supply_pack/hydroponics/seeds
	name = "Samples - Mundane Seeds"
	contains = list(/obj/item/seeds/chiliseed,
					/obj/item/seeds/berryseed,
					/obj/item/seeds/cornseed,
					/obj/item/seeds/eggplantseed,
					/obj/item/seeds/tomatoseed,
					/obj/item/seeds/appleseed,
					/obj/item/seeds/soyaseed,
					/obj/item/seeds/wheatseed,
					/obj/item/seeds/carrotseed,
					/obj/item/seeds/harebell,
					/obj/item/seeds/lemonseed,
					/obj/item/seeds/orangeseed,
					/obj/item/seeds/grassseed,
					/obj/item/seeds/sunflowerseed,
					/obj/item/seeds/chantermycelium,
					/obj/item/seeds/potatoseed,
					/obj/item/seeds/sugarcaneseed)
	containername = "seeds crate"
	access = access_hydroponics

/decl/hierarchy/supply_pack/hydroponics/weedcontrol
	name = "Gear - Weed control"
	contains = list(/obj/item/tool/axe/hatchet = 2,
					/obj/item/chems/spray/plantbgone = 4,
					/obj/item/clothing/mask/gas = 2,
					/obj/item/grenade/chem_grenade/antiweed = 2)
	containername = "weed control crate"
	access = access_hydroponics

/decl/hierarchy/supply_pack/hydroponics/exoticseeds
	name = "Samples - Exotic seeds"
	contains = list(/obj/item/seeds/libertymycelium,
					/obj/item/seeds/reishimycelium,
					/obj/item/seeds/random = 6,
					/obj/item/seeds/kudzuseed)
	containertype = /obj/structure/closet/crate/secure
	containername = "exotic Seeds crate"
	access = access_xenobiology

/decl/hierarchy/supply_pack/hydroponics/hydrotray
	name = "Equipment - Hydroponics tray"
	contains = list(/obj/machinery/portable_atmospherics/hydroponics)
	containertype = /obj/structure/closet/crate/large/hydroponics
	containername = "hydroponics tray crate"
	access = access_hydroponics

/decl/hierarchy/supply_pack/hydroponics/pottedplant
	name = "Deco - Potted plants"
	num_contained = 1
	contains = list(/obj/structure/flora/pottedplant,
					/obj/structure/flora/pottedplant/large,
					/obj/structure/flora/pottedplant/fern,
					/obj/structure/flora/pottedplant/overgrown,
					/obj/structure/flora/pottedplant/bamboo,
					/obj/structure/flora/pottedplant/largebush,
					/obj/structure/flora/pottedplant/thinbush,
					/obj/structure/flora/pottedplant/mysterious,
					/obj/structure/flora/pottedplant/smalltree,
					/obj/structure/flora/pottedplant/unusual,
					/obj/structure/flora/pottedplant/orientaltree,
					/obj/structure/flora/pottedplant/smallcactus,
					/obj/structure/flora/pottedplant/tall,
					/obj/structure/flora/pottedplant/sticky,
					/obj/structure/flora/pottedplant/smelly,
					/obj/structure/flora/pottedplant/small,
					/obj/structure/flora/pottedplant/aquatic,
					/obj/structure/flora/pottedplant/shoot,
					/obj/structure/flora/pottedplant/flower,
					/obj/structure/flora/pottedplant/crystal,
					/obj/structure/flora/pottedplant/subterranean,
					/obj/structure/flora/pottedplant/minitree,
					/obj/structure/flora/pottedplant/stoutbush,
					/obj/structure/flora/pottedplant/drooping,
					/obj/structure/flora/pottedplant/tropical,
					/obj/structure/flora/pottedplant/dead,
					/obj/structure/flora/pottedplant/decorative)
	containertype = /obj/structure/closet/crate/large/hydroponics
	containername = "potted plant crate"
	supply_method = /decl/supply_method/randomized