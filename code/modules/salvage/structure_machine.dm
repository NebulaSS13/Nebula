
/obj/structure/salvage/fabricator
	name = "fabricator"
	desc = "A busted, defunct fabricator. There might still be useful components or materials inside."
	icon_state = "autolathe"

/obj/structure/salvage/fabricator/get_salvageable_components()
	var/static/list/salvageable_parts = list(
		/obj/item/stock_parts/console_screen                          = 80,
		/obj/item/stack/cable_coil/five                               = 80,
		/obj/item/debris/salvage/circuit                              = 60,
		/obj/item/debris/salvage/metal                                = 60,
		/obj/item/debris/salvage/metal/plasteel                       = 15,
		/obj/item/stock_parts/capacitor                               = 40,
		/obj/item/stock_parts/scanning_module                         = 40,
		/obj/item/stock_parts/manipulator                             = 40,
		/obj/item/stock_parts/micro_laser                             = 40,
		/obj/item/stock_parts/micro_laser                             = 40,
		/obj/item/stock_parts/micro_laser                             = 40,
		/obj/item/stock_parts/matter_bin                              = 40,
		/obj/item/stock_parts/matter_bin                              = 40,
		/obj/item/stock_parts/matter_bin                              = 40,
		/obj/item/stock_parts/matter_bin                              = 40,
		/obj/item/stock_parts/capacitor/adv                           = 20,
		/obj/item/stock_parts/micro_laser/high                        = 20,
		/obj/item/stock_parts/micro_laser/high                        = 20,
		/obj/item/stock_parts/matter_bin/adv                          = 20,
		/obj/item/stock_parts/matter_bin/adv                          = 20,
		/obj/item/stack/material/sheet/mapped/steel/twenty            = 40,
		/obj/item/stack/material/pane/mapped/glass/twenty             = 40,
		/obj/item/stack/material/panel/mapped/plastic/twenty          = 40,
		/obj/item/stack/material/sheet/reinforced/mapped/plasteel/ten = 40,
		/obj/item/stack/material/ingot/mapped/silver/ten              = 20,
		/obj/item/stack/material/ingot/mapped/gold/ten                = 20
	)
	return salvageable_parts

/obj/structure/salvage/machine
	name = "machine"
	desc = "A badly-damaged machine of some kind. There might still be some usable components inside."
	icon_state = "machine1"

/obj/structure/salvage/machine/Initialize()
	. = ..()
	icon_state = "machine[rand(0,6)]"

/obj/structure/salvage/machine/get_salvageable_components()
	var/static/list/salvageable_parts = list(
		/obj/item/stock_parts/console_screen      = 80,
		/obj/item/stack/cable_coil/five           = 80,
		/obj/item/debris/salvage/circuit          = 60,
		/obj/item/debris/salvage/metal            = 60,
		/obj/item/debris/salvage/metal/plasteel   = 15,
		/obj/item/stock_parts/capacitor           = 40,
		/obj/item/stock_parts/capacitor           = 40,
		/obj/item/stock_parts/scanning_module     = 40,
		/obj/item/stock_parts/scanning_module     = 40,
		/obj/item/stock_parts/manipulator         = 40,
		/obj/item/stock_parts/manipulator         = 40,
		/obj/item/stock_parts/micro_laser         = 40,
		/obj/item/stock_parts/micro_laser         = 40,
		/obj/item/stock_parts/matter_bin          = 40,
		/obj/item/stock_parts/matter_bin          = 40,
		/obj/item/stock_parts/capacitor/adv       = 20,
		/obj/item/stock_parts/scanning_module/adv = 20,
		/obj/item/stock_parts/manipulator/nano    = 20,
		/obj/item/stock_parts/micro_laser/high    = 20,
		/obj/item/stock_parts/matter_bin/adv      = 20
	)
	return salvageable_parts

/obj/structure/salvage/machine_old
	name = "machine"
	desc = "A badly-damaged machine of some kind. There might still be some usable components inside."
	icon_state = "os-machine"

/obj/structure/salvage/machine_old/get_salvageable_components()
	var/static/list/salvageable_parts = list(
		/obj/item/stock_parts/console_screen  = 80,
		/obj/item/stack/cable_coil/five       = 80,
		/obj/item/stock_parts/capacitor       = 40,
		/obj/item/stock_parts/capacitor       = 40,
		/obj/item/stock_parts/scanning_module = 40,
		/obj/item/stock_parts/scanning_module = 40,
		/obj/item/stock_parts/manipulator     = 40,
		/obj/item/stock_parts/manipulator     = 40,
		/obj/item/stock_parts/micro_laser     = 40,
		/obj/item/stock_parts/micro_laser     = 40,
		/obj/item/stock_parts/matter_bin      = 40,
		/obj/item/stock_parts/matter_bin      = 40
	)
	return salvageable_parts
