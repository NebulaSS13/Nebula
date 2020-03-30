// Basic pipe analogues. There is only one state, and the main interaction is wrench to deconstruct.

/decl/machine_construction/pipe
	visible_components = FALSE

/decl/machine_construction/pipe/state_is_valid(obj/machinery/machine)
	return TRUE

/decl/machine_construction/pipe/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	if(isWrench(I))
		TRANSFER_STATE(/decl/machine_construction/default/deconstructed)
		playsound(get_turf(machine), 'sound/items/Ratchet.ogg', 50, 1)
		machine.visible_message(SPAN_NOTICE("\The [user] unfastens \the [src]."))
		machine.dismantle()

/decl/machine_construction/pipe/mechanics_info()
	. = list()
	. += "Use a wrench to deconstruct the machine"