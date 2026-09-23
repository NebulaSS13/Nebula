// Adds the brain interface to what used to be the 'devices' merchant.
// Kinda odd for a drugstore to sell them but it achieves parity with the old system.
/datum/merchant/drugstore/pre_inventory_generation()
	..()
	supply_potential += /decl/merchant_potential_commodities/brain_interface

/decl/merchant_potential_commodities/brain_interface
	type_instructions = list(/obj/item/organ/internal/brain_interface = MERCHANT_INCLUDE_SUBTYPES)