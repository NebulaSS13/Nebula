/datum/trader/trading_beacon/manufacturing/New()
	LAZYSET(possible_trading_items, /obj/item/bee_pack,         TRADER_THIS_TYPE)
	LAZYSET(possible_trading_items, /obj/item/bee_smoker,       TRADER_THIS_TYPE)
	LAZYSET(possible_trading_items, /obj/item/beehive_assembly, TRADER_THIS_TYPE)
	LAZYSET(possible_trading_items, /obj/item/honey_frame,      TRADER_THIS_TYPE)
	..()

/decl/hierarchy/supply_pack/hydroponics/bee_keeper
	name = "Equipment - Beekeeping"
	contains = list(/obj/item/beehive_assembly,
					/obj/item/bee_smoker,
					/obj/item/honey_frame = 5,
					/obj/item/bee_pack)
	containername = "beekeeping crate"
	access = access_hydroponics
