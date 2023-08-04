/obj/machinery/vending/worth()
	. = ..()
	for(var/datum/stored_items/vending_products/product in product_records)
		. += product.price_og * product.amount

/obj/structure/vending_refill/worth()
	. = ..()
	for(var/datum/stored_items/vending_products/product in product_records)
		. += product.price_og * product.amount