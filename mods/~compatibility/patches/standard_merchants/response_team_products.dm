// Removes the possibility that trade beacons can carry ERT backpacks.
/decl/merchant_potential_commodities/trading_beacon_supply/post_init()
	..()
	type_instructions += list(/obj/item/backpack/ert = MERCHANT_EXCLUDE_ALL)
