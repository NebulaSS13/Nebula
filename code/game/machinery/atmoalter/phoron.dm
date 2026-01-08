/obj/machinery/portable_atmospherics/canister/phoron
	name = "\improper Canister \[Phoron\]"
	icon_state = "orange"
	canister_color = "orange"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/phoron/Initialize()
	. = ..()
	air_contents.adjust_gas(/decl/material/solid/phoron, MolesForPressure())
	queue_icon_update()

/obj/machinery/portable_atmospherics/canister/phoron/engine_setup/Initialize()
	. = ..()
	src.air_contents.adjust_gas(/decl/material/solid/phoron, MolesForPressure())
	queue_icon_update()

/obj/machinery/portable_atmospherics/canister/empty/phoron
	name = /obj/machinery/portable_atmospherics/canister/phoron::name
	icon_state = /obj/machinery/portable_atmospherics/canister/phoron::icon_state
	canister_color = /obj/machinery/portable_atmospherics/canister/phoron::canister_color
