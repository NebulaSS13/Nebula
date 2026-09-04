/obj/structure/salvage/console
	name = "console"
	desc = "A beat-up old console. Might still have some useful components inside."
	icon_state = "os_console"

/obj/structure/salvage/console/get_salvageable_components()
	var/static/list/salvageable_parts = list(
		/obj/item/stack/cable_coil/five                        = 90,
		/obj/item/stock_parts/console_screen                   = 80,
		/obj/item/stock_parts/capacitor                        = 60,
		/obj/item/stock_parts/capacitor                        = 60,
		/obj/item/stock_parts/computer/processor_unit/small    = 40,
		/obj/item/stock_parts/computer/processor_unit/photonic = 40,
		/obj/item/stock_parts/computer/card_slot               = 40,
		/obj/item/stock_parts/computer/card_slot               = 40,
		/obj/item/stock_parts/computer/network_card/advanced   = 40
	)
	return salvageable_parts

/obj/structure/salvage/console/broken
	icon_state = "os_console_broken"

/obj/structure/salvage/console/broken/get_salvageable_components()
	var/static/list/salvageable_parts = list(
		/obj/item/stack/cable_coil/five                        = 90,
		/obj/item/stock_parts/console_screen                   = 80,
		/obj/item/stock_parts/capacitor                        = 60,
		/obj/item/stock_parts/capacitor                        = 60,
		/obj/item/stock_parts/computer/processor_unit          = 40,
		/obj/item/stock_parts/computer/processor_unit/photonic = 40,
		/obj/item/stock_parts/computer/card_slot               = 40,
		/obj/item/stock_parts/computer/card_slot               = 40,
		/obj/item/stock_parts/computer/network_card/advanced   = 40
	)
	return salvageable_parts
