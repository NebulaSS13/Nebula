// Adds the fake carp grenades to the prank store merchant.
/datum/merchant/transient/prank_shop/pre_inventory_generation()
	..()
	supply_potential += /decl/merchant_potential_commodities/fake_carp_grenade

/decl/merchant_potential_commodities/fake_carp_grenade
	type_instructions = list(/obj/item/grenade/spawnergrenade/fake_carp = MERCHANT_INCLUDE_THIS_TYPE)