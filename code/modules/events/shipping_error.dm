/datum/event/shipping_error/start()
	var/datum/supply_order/order = new /datum/supply_order()
	order.ordernum = SSsupply.ordernum
	order.object = pick(SSsupply.master_supply_list)
	order.orderedby = random_name(pick(MALE,FEMALE), species = global.using_map.default_species)
	SSsupply.shoppinglist += order
