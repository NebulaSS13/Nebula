// Adds integrated electronics to the electronics store.
/datum/merchant/transient/electronics_store/pre_inventory_generation()
	..()
	supply_potential += /decl/merchant_potential_commodities/integrated_electronics

/decl/merchant_potential_commodities/integrated_electronics
	type_instructions = list(
		/obj/item/integrated_circuit_printer	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/wirer							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/debugger						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/analyzer						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/detailer						= MERCHANT_INCLUDE_THIS_TYPE
	)