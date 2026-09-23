// Adds beekeeping items to the manufacturing trade beacon.
/datum/merchant/trading_beacon/manufacturing/pre_inventory_generation()
	..()
	supply_potential += /decl/merchant_potential_commodities/beekeeping_products


/decl/merchant_potential_commodities/beekeeping_products
	type_instructions = list(
		/obj/item/bee_pack								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/smoker								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stack/material/plank/mapped/wood/ten	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/hive_frame/crafted					= MERCHANT_INCLUDE_THIS_TYPE
	)