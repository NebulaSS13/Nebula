/obj/machinery/vending/get_combined_monetary_worth()
	. = ..()
	var/stored_goods_worth = 0
	for(var/datum/stored_items/vending_products/product in product_records)
		// instances will be counted by parent call as they are in the vendor contents
		var/product_count = product.amount - length(product.instances)
		if(product_count > 0)
			stored_goods_worth += atom_info_repository.get_combined_worth_for(product.item_path) * product_count
	. += round(stored_goods_worth)

/obj/structure/vending_refill/get_combined_monetary_worth()
	. = ..()
	var/stored_goods_worth = 0
	for(var/datum/stored_items/vending_products/product in product_records)
		// instances will be counted by parent call as they are in the vendor contents
		var/product_count = product.amount - length(product.instances)
		if(product_count > 0)
			stored_goods_worth += atom_info_repository.get_combined_worth_for(product.item_path) * product_count
	. += round(stored_goods_worth)
