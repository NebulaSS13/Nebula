/obj/machinery/vending/get_combined_monetary_worth()
	. = ..()
	var/stored_goods_worth = 0
	for(var/datum/stored_items/vending_products/product in product_records)
		stored_goods_worth += product.price * product.amount
	if(markup)
		stored_goods_worth /= markup
	. += round(stored_goods_worth)

/obj/structure/vending_refill/get_combined_monetary_worth()
	. = ..()
	var/stored_goods_worth = 0
	for(var/datum/stored_items/vending_products/product in product_records)
		stored_goods_worth += product.price * product.amount
	. += round(stored_goods_worth)
