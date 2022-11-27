// Identical to default behavior, but does not require circuit boards and wrench on panel closed deconstructs.

/decl/machine_construction/default/panel_closed/item_chassis
	needs_board = null
	down_state = /decl/machine_construction/default/panel_open/item_chassis


/decl/machine_construction/default/panel_closed/item_chassis/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if(IS_WRENCH(I))
		TRANSFER_STATE(/decl/machine_construction/default/deconstructed)
		playsound(get_turf(machine), 'sound/items/Ratchet.ogg', 50, 1)
		machine.visible_message(SPAN_NOTICE("\The [user] deconstructs \the [machine]."))
		machine.dismantle()
		return
	return ..()

/decl/machine_construction/default/panel_closed/item_chassis/mechanics_info()
	. = ..()
	. += "Use a wrench to deconstruct the machine"

/decl/machine_construction/default/panel_closed/item_chassis/post_construct()

/decl/machine_construction/default/panel_open/item_chassis
	needs_board = null
	up_state = /decl/machine_construction/default/panel_closed/item_chassis