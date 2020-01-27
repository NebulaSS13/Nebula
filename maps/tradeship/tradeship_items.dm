/obj/machinery/vending/hydroseeds/Initialize()
	products = products || list()
	products[/obj/item/seeds/bruisegrassseed] = products[/obj/item/seeds/poppyseed] || 3
	products -= /obj/item/seeds/poppyseed
	. = ..()

/obj/machinery/seed_storage/garden/Initialize()
	starting_seeds = starting_seeds || list()
	starting_seeds[/obj/item/seeds/bruisegrassseed] = starting_seeds[/obj/item/seeds/poppyseed] || 15
	starting_seeds -= /obj/item/seeds/poppyseed
	. = ..()

/obj/machinery/seed_storage/xenobotany/Initialize()
	starting_seeds = starting_seeds || list()
	starting_seeds[/obj/item/seeds/bruisegrassseed] = starting_seeds[/obj/item/seeds/poppyseed] || 15
	starting_seeds -= /obj/item/seeds/poppyseed
	. = ..()

/obj/machinery/suit_cycler/tradeship
	req_access = list()

/obj/machinery/suit_cycler/tradeship/Initialize()
	if(prob(75))
		suit = pick(list(
			/obj/item/clothing/suit/space/void/mining, 
			/obj/item/clothing/suit/space/void/engineering, 
			/obj/item/clothing/suit/space/void/pilot, 
			/obj/item/clothing/suit/space/void/excavation, 
			/obj/item/clothing/suit/space/void/engineering/salvage
		))
	if(prob(75))
		helmet = pick(list(
			/obj/item/clothing/head/helmet/space/void/mining, 
			/obj/item/clothing/head/helmet/space/void/engineering, 
			/obj/item/clothing/head/helmet/space/void/pilot, 
			/obj/item/clothing/head/helmet/space/void/excavation, 
			/obj/item/clothing/head/helmet/space/void/engineering/salvage
		))
	. = ..()
