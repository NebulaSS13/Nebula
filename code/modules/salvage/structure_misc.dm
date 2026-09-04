/obj/structure/salvage/implant_container
	name = "old container"
	icon_state = "implant_container0"

/obj/structure/salvage/implant_container/Initialize()
	. = ..()
	icon_state = "implant_container[rand(0,1)]"

/obj/structure/salvage/implant_container/get_salvageable_components()
	var/static/list/salvageable_parts = list(
		/obj/item/stock_parts/console_screen             = 80,
		/obj/item/stack/cable_coil/five                  = 80,
		/obj/item/debris/salvage/circuit                 = 60,
		/obj/item/debris/salvage/metal                   = 60,
		/obj/item/debris/salvage/metal/plasteel          = 15,
		/obj/item/implant/death_alarm                    = 15,
		/obj/item/implant/explosive                      = 10,
		/obj/item/implant/freedom                        = 5,
		/obj/item/implant/tracking                       = 10,
		/obj/item/implant/chem                           = 10,
		/obj/item/implantcase                            = 30,
		/obj/item/implanter                              = 30,
		/obj/item/stack/material/sheet/mapped/steel/ten  = 30,
		/obj/item/stack/material/pane/mapped/glass/ten   = 30,
		/obj/item/stack/material/ingot/mapped/silver/ten = 30
	)
	return salvageable_parts
