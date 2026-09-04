// Construction frames

/decl/machine_construction/frame/unwrenched/state_is_valid(obj/machinery/machine)
	return !machine.anchored

/decl/machine_construction/frame/unwrenched/validate_state(obj/machinery/constructable_frame/machine)
	. = ..()
	if(!.)
		if(machine.circuit)
			try_change_state(machine, /decl/machine_construction/frame/awaiting_parts)
		else
			try_change_state(machine, /decl/machine_construction/frame/wrenched)

/decl/machine_construction/frame/unwrenched/attackby(obj/item/used_item, mob/user, obj/machinery/machine)
	if(IS_WRENCH(used_item))
		playsound(machine.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 20, machine))
			TRANSFER_STATE(/decl/machine_construction/frame/wrenched)
			to_chat(user, "<span class='notice'>You wrench \the [machine] into place.</span>")
			machine.anchored = TRUE
	if(IS_WELDER(used_item))
		var/obj/item/weldingtool/welder = used_item
		if(!welder.weld(0, user))
			to_chat(user, "The welding tool must be on to complete this task.")
			return TRUE
		playsound(machine.loc, 'sound/items/Welder.ogg', 50, 1)
		if(do_after(user, 20, machine))
			if(!welder.isOn())
				return TRUE
			TRANSFER_STATE(/decl/machine_construction/default/deconstructed)
			to_chat(user, "<span class='notice'>You deconstruct \the [machine].</span>")
			machine.dismantle()
	return FALSE

/decl/machine_construction/frame/unwrenched/mechanics_info()
	. = list()
	. += "Use a welder to break apart the frame."
	. += "Use a wrench to secure the frame in place."

/decl/machine_construction/frame/wrenched/state_is_valid(obj/machinery/constructable_frame/machine)
	return machine.anchored && !machine.circuit

/decl/machine_construction/frame/wrenched/validate_state(obj/machinery/constructable_frame/machine)
	. = ..()
	if(!.)
		if(machine.circuit)
			try_change_state(machine, /decl/machine_construction/frame/awaiting_parts)
		else
			try_change_state(machine, /decl/machine_construction/frame/unwrenched)

/decl/machine_construction/frame/wrenched/attackby(obj/item/used_item, mob/user, obj/machinery/machine)
	if(IS_WRENCH(used_item))
		playsound(machine.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 20, machine))
			TRANSFER_STATE(/decl/machine_construction/frame/unwrenched)
			to_chat(user, "<span class='notice'>You unfasten \the [machine].</span>")
			machine.anchored = FALSE
		return TRUE
	if(IS_COIL(used_item))
		var/obj/item/stack/cable_coil/C = used_item
		if(C.get_amount() < 5)
			to_chat(user, "<span class='warning'>You need five lengths of cable to add them to \the [machine].</span>")
			return TRUE
		playsound(machine.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		to_chat(user, "<span class='notice'>You start to add cables to the frame.</span>")
		if(do_after(user, 20, machine) && C.use(5))
			TRANSFER_STATE(/decl/machine_construction/frame/awaiting_circuit)
			to_chat(user, "<span class='notice'>You add cables to the frame.</span>")
		return TRUE
	return FALSE

/decl/machine_construction/frame/wrenched/mechanics_info()
	. = list()
	. += "Use a wrench to unfasten the frame from the floor and prepare it for deconstruction."
	. += "Add cables to make it ready for a circuit."

/decl/machine_construction/frame/awaiting_circuit/state_is_valid(obj/machinery/constructable_frame/machine)
	return machine.anchored && !machine.circuit

/decl/machine_construction/frame/awaiting_circuit/validate_state(obj/machinery/constructable_frame/machine)
	. = ..()
	if(!.)
		if(machine.circuit)
			try_change_state(machine, /decl/machine_construction/frame/awaiting_parts)
		else
			try_change_state(machine, /decl/machine_construction/frame/unwrenched)

/decl/machine_construction/frame/awaiting_circuit/attackby(obj/item/used_item, mob/user, obj/machinery/constructable_frame/machine)
	if(istype(used_item, /obj/item/stock_parts/circuitboard))
		var/obj/item/stock_parts/circuitboard/circuit = used_item
		if(circuit.board_type == machine.expected_machine_type)
			if(user.can_unequip_item(used_item))
				TRANSFER_STATE(/decl/machine_construction/frame/awaiting_parts)
				user.try_unequip(used_item, machine)
				playsound(machine.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You add the circuit board to \the [machine].</span>")
				machine.circuit = used_item
		else
			to_chat(user, "<span class='warning'>This frame does not accept circuit boards of this type!</span>")
		return TRUE
	if(IS_WIRECUTTER(used_item))
		TRANSFER_STATE(/decl/machine_construction/frame/wrenched)
		playsound(machine.loc, 'sound/items/Wirecutter.ogg', 50, 1)
		to_chat(user, "<span class='notice'>You remove the cables.</span>")
		new /obj/item/stack/cable_coil(machine.loc, 5)
		return TRUE
	return FALSE

/decl/machine_construction/frame/awaiting_circuit/mechanics_info()
	. = list()
	. += "Insert a circuit board to progress with constructing the machine."
	. += "Use a wirecutter to remove the cables."

/decl/machine_construction/frame/awaiting_parts/state_is_valid(obj/machinery/constructable_frame/machine)
	return machine.anchored && machine.circuit

/decl/machine_construction/frame/awaiting_parts/validate_state(obj/machinery/constructable_frame/machine)
	. = ..()
	if(!.)
		if(machine.anchored)
			try_change_state(machine, /decl/machine_construction/frame/wrenched)
		else
			try_change_state(machine, /decl/machine_construction/frame/unwrenched)

/decl/machine_construction/frame/awaiting_parts/attackby(obj/item/used_item, mob/user, obj/machinery/constructable_frame/machine)
	if(IS_CROWBAR(used_item))
		TRANSFER_STATE(/decl/machine_construction/frame/awaiting_circuit)
		playsound(machine.loc, 'sound/items/Crowbar.ogg', 50, 1)
		machine.circuit.dropInto(machine.loc)
		machine.circuit = null
		to_chat(user, "<span class='notice'>You remove the circuit board.</span>")
		return TRUE
	if(IS_SCREWDRIVER(used_item))
		playsound(machine.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		var/obj/machinery/new_machine = new machine.circuit.build_path(machine.loc, machine.dir, FALSE)
		machine.circuit.construct(new_machine)
		new_machine.install_component(machine.circuit, refresh_parts = FALSE)
		new_machine.apply_component_presets()
		new_machine.RefreshParts()
		if(new_machine.construct_state)
			new_machine.construct_state.post_construct(new_machine)
		else
			PRINT_STACK_TRACE("Machine of type [new_machine.type] was built from a circuit and frame, but had no construct state set.")
		qdel(machine)
		return TRUE
	return FALSE

/decl/machine_construction/frame/awaiting_parts/mechanics_info()
	. = list()
	. += "Use a crowbar to remove the circuitboard and any parts installed."
	. += "Use a screwdriver to build the machine."