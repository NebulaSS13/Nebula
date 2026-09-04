/obj/structure/salvage/personal
	name = "personal terminal"
	desc = "An unusable personal terminal. There might still be useful components inside."
	icon_state = "personal0"

/obj/structure/salvage/personal/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	icon_state = "personal[rand(0,12)]"

/obj/structure/salvage/personal/get_salvageable_components()
	var/static/list/salvageable_parts = list(
		/obj/item/stock_parts/console_screen                         = 90,
		/obj/item/stack/cable_coil/five                              = 90,
		/obj/item/stack/material/pane/mapped/glass/five              = 70,
		/obj/item/debris/salvage/circuit                             = 60,
		/obj/item/debris/salvage/metal                               = 60,
		/obj/item/debris/salvage/metal/plasteel                      = 15,
		/obj/item/stock_parts/computer/network_card                  = 60,
		/obj/item/stock_parts/computer/network_card                  = 40,
		/obj/item/stock_parts/computer/network_card/advanced         = 40,
		/obj/item/stock_parts/computer/card_slot                     = 40,
		/obj/item/stock_parts/computer/processor_unit                = 60,
		/obj/item/stock_parts/computer/processor_unit/small          = 50,
		/obj/item/stock_parts/computer/processor_unit/photonic       = 40,
		/obj/item/stock_parts/computer/processor_unit/photonic/small = 30,
		/obj/item/stock_parts/computer/hard_drive                    = 60,
		/obj/item/stock_parts/computer/hard_drive/advanced           = 40
	)
	return salvageable_parts
