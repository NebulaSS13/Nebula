/obj/machinery/vending/dinnerware/Initialize(mapload, d, populate_parts)
	products = products || list()
	products[/obj/item/storage/lunchbox/nt] = 3
	products[/obj/item/storage/lunchbox/dais] = 3
	. = ..()
