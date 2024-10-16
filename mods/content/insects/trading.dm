/datum/trader/trading_beacon/manufacturing/New()
	LAZYSET(possible_trading_items, /obj/item/bee_pack,                             TRADER_THIS_TYPE)
	LAZYSET(possible_trading_items, /obj/item/bee_smoker,                           TRADER_THIS_TYPE)
	LAZYSET(possible_trading_items, /obj/item/hive_frame/crafted,                   TRADER_THIS_TYPE)
	LAZYSET(possible_trading_items, /obj/item/stack/material/plank/mapped/wood/ten, TRADER_THIS_TYPE)
	..()

/decl/hierarchy/supply_pack/hydroponics/bee_keeper
	name = "Equipment - Beekeeping"
	contains = list(
		/obj/item/stack/material/plank/mapped/wood/ten,
		/obj/item/bee_smoker,
		/obj/item/hive_frame/crafted = 5,
		/obj/item/bee_pack
	)
	containername = "beekeeping crate"
	access = access_hydroponics
