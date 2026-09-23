// Adds supermatter types to the rare 'rock' merchant.
/datum/merchant/transient/rare/rock/pre_inventory_generation()
	..()
	supply_potential += /decl/merchant_potential_commodities/supermatter


/decl/merchant_potential_commodities/supermatter
	type_instructions = list(
		/obj/structure/supermatter			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/structure/supermatter/shard	= MERCHANT_INCLUDE_THIS_TYPE
	)