/obj/structure/salvage/computer
	name = "computer"
	desc = "A defunct computer. There might still be useful components inside."
	icon_state = "computer0"

/obj/structure/salvage/computer/Initialize()
	. = ..()
	icon_state = "computer[rand(0,7)]"

/obj/structure/salvage/computer/get_salvageable_components()
	var/static/list/salvageable_parts = list(
		/obj/item/stock_parts/console_screen                 = 80,
		/obj/item/stack/cable_coil/five                      = 90,
		/obj/item/stack/material/pane/mapped/glass/five      = 90,
		/obj/item/debris/salvage/circuit                     = 60,
		/obj/item/debris/salvage/metal                       = 60,
		/obj/item/debris/salvage/metal/plasteel              = 15,
		/obj/item/stock_parts/capacitor                      = 60,
		/obj/item/stock_parts/capacitor                      = 60,
		/obj/item/stock_parts/computer/network_card          = 40,
		/obj/item/stock_parts/computer/network_card          = 40,
		/obj/item/stock_parts/computer/network_card/advanced = 20,
		/obj/item/stock_parts/computer/processor_unit        = 40,
		/obj/item/stock_parts/computer/processor_unit        = 40,
		/obj/item/stock_parts/computer/card_slot             = 40,
		/obj/item/stock_parts/computer/card_slot             = 40,
		/obj/item/stock_parts/capacitor/adv                  = 30,
	)
	return salvageable_parts

/obj/structure/salvage/server
	name = "server"
	desc = "A damaged, broken server. There might still be useful components inside."
	icon_state = "server0"

/obj/structure/salvage/server/Initialize(ml, _mat, _reinf_mat)
	. = ..()

/obj/structure/salvage/server/get_salvageable_components()
	var/static/list/salvageable_parts = list(
		/obj/item/stock_parts/console_screen                 = 80,
		/obj/item/stack/cable_coil/five                      = 90,
		/obj/item/stack/material/pane/mapped/glass/five      = 90,
		/obj/item/debris/salvage/circuit                     = 60,
		/obj/item/debris/salvage/metal                       = 60,
		/obj/item/debris/salvage/metal/plasteel              = 15,
		/obj/item/stock_parts/computer/network_card          = 40,
		/obj/item/stock_parts/computer/network_card          = 40,
		/obj/item/stock_parts/computer/processor_unit        = 40,
		/obj/item/stock_parts/computer/processor_unit        = 40,
		/obj/item/stock_parts/subspace/amplifier             = 40,
		/obj/item/stock_parts/subspace/amplifier             = 40,
		/obj/item/stock_parts/subspace/analyzer              = 40,
		/obj/item/stock_parts/subspace/analyzer              = 40,
		/obj/item/stock_parts/subspace/ansible               = 40,
		/obj/item/stock_parts/subspace/ansible               = 40,
		/obj/item/stock_parts/subspace/transmitter           = 40,
		/obj/item/stock_parts/subspace/transmitter           = 40,
		/obj/item/stock_parts/subspace/crystal               = 30,
		/obj/item/stock_parts/subspace/crystal               = 30,
		/obj/item/stock_parts/computer/network_card/advanced = 20
	)
	return salvageable_parts

/obj/structure/salvage/computer_old
	name = "computer"
	desc = "A defunct computer. There might still be useful components inside."
	icon_state = "os-computer"

/obj/structure/salvage/computer_old/get_salvageable_components()
	var/static/list/salvageable_parts = list(
		/obj/item/stock_parts/console_screen                   = 80,
		/obj/item/stack/cable_coil/five                        = 90,
		/obj/item/stack/material/pane/mapped/glass/five        = 90,
		/obj/item/stock_parts/capacitor                        = 60,
		/obj/item/stock_parts/capacitor                        = 60,
		/obj/item/stock_parts/computer/processor_unit/photonic = 40,
		/obj/item/stock_parts/computer/processor_unit/photonic = 40,
		/obj/item/stock_parts/computer/card_slot               = 40,
		/obj/item/stock_parts/computer/card_slot               = 40,
		/obj/item/stock_parts/computer/network_card/advanced   = 40
	)
	return salvageable_parts

/obj/structure/salvage/data
	name = "data storage"
	desc = "An old, battered, broken data storage rack. There might still be useful components inside."
	icon_state = "data0"

/obj/structure/salvage/data/Initialize()
	. = ..()
	icon_state = "data[rand(0,1)]"

/obj/structure/salvage/data/get_salvageable_components()
	var/static/list/salvageable_parts = list(
		/obj/item/stock_parts/console_screen                 = 80,
		/obj/item/stack/cable_coil/five                      = 90,
		/obj/item/stack/material/pane/mapped/glass/five      = 90,
		/obj/item/debris/salvage/circuit                     = 60,
		/obj/item/debris/salvage/metal                       = 60,
		/obj/item/debris/salvage/metal/plasteel              = 15,
		/obj/item/stock_parts/computer/network_card          = 40,
		/obj/item/stock_parts/computer/network_card          = 40,
		/obj/item/stock_parts/computer/processor_unit        = 40,
		/obj/item/stock_parts/computer/processor_unit        = 40,
		/obj/item/stock_parts/computer/hard_drive            = 50,
		/obj/item/stock_parts/computer/hard_drive            = 50,
		/obj/item/stock_parts/computer/hard_drive            = 50,
		/obj/item/stock_parts/computer/hard_drive            = 50,
		/obj/item/stock_parts/computer/hard_drive            = 50,
		/obj/item/stock_parts/computer/hard_drive            = 50,
		/obj/item/stock_parts/computer/hard_drive/advanced   = 30,
		/obj/item/stock_parts/computer/hard_drive/advanced   = 30,
		/obj/item/stock_parts/computer/network_card/advanced = 20
	)
	return salvageable_parts
