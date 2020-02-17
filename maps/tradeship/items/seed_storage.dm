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
