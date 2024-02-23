/obj/machinery/vending/dinnerware/Initialize(mapload, d, populate_parts)
	products = products || list()
	products[/obj/item/lunchbox/nt] = 3
	products[/obj/item/lunchbox/dais] = 3
	. = ..()
