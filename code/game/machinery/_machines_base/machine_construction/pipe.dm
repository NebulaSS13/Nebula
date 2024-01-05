// Basic pipe analogues. There is only one state, and the main interaction is wrench to deconstruct.

/decl/machine_construction/pipe
	visible_components = FALSE

/decl/machine_construction/pipe/state_is_valid(obj/machinery/machine)
	return TRUE

/decl/machine_construction/pipe/proc/deconstruct_transition(obj/item/I, mob/user, obj/machinery/machine)
	if(IS_WRENCH(I))
		TRANSFER_STATE(/decl/machine_construction/default/deconstructed)
		playsound(get_turf(machine), 'sound/items/Ratchet.ogg', 50, 1)
		machine.visible_message(SPAN_NOTICE("\The [user] unfastens \the [machine]."))
		machine.dismantle()

/decl/machine_construction/pipe/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	return deconstruct_transition(I, user, machine)

/decl/machine_construction/pipe/mechanics_info()
	. = list()
	. += "Use a wrench to deconstruct the machine"

// Same, but uses different tool.
/decl/machine_construction/pipe/welder/deconstruct_transition(obj/item/I, mob/user, obj/machinery/machine)
	if(IS_WELDER(I))
		var/obj/item/weldingtool/WT = I
		if(!WT.isOn())
			return FALSE
		if(!WT.weld(0,user))
			return FALSE
		var/fail = machine.cannot_transition_to(/decl/machine_construction/default/deconstructed, user)
		if(istext(fail))
			to_chat(user, fail)
			return TRUE
		if(fail != MCS_CHANGE)
			return (fail == MCS_BLOCK)
		to_chat(user, SPAN_NOTICE("You start welding \the [machine]."))
		playsound(get_turf(machine), 'sound/items/Welder.ogg', 50, 1)
		if(!do_after(user, 5 SECONDS, machine))
			return TRUE
		if(!WT.isOn())
			return TRUE
		playsound(get_turf(machine), 'sound/items/Welder2.ogg', 50, 1)
		TRANSFER_STATE(/decl/machine_construction/default/deconstructed)
		machine.visible_message(SPAN_NOTICE("\The [user] unwelds \the [machine]."))
		machine.dismantle()

/decl/machine_construction/pipe/welder/mechanics_info()
	. = list()
	. += "Use a welder to deconstruct the machine"