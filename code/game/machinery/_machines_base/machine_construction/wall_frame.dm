// For use with wall frame + circuit machines.

/decl/machine_construction/wall_frame
	needs_board = "wall"
	var/active_state = /decl/machine_construction/wall_frame/panel_closed
	var/open_state = /decl/machine_construction/wall_frame/panel_open
	var/diconnected_state = /decl/machine_construction/wall_frame/no_wires
	var/bottom_state = /decl/machine_construction/wall_frame/no_circuit
	var/newly_built_state = /decl/machine_construction/wall_frame/no_circuit

// Fully built

/decl/machine_construction/wall_frame/panel_closed/state_is_valid(obj/machinery/machine)
	return !machine.panel_open

/decl/machine_construction/wall_frame/panel_closed/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		if(machine.get_component_of_type(/obj/item/stock_parts/circuitboard))
			try_change_state(machine, open_state)
		else
			try_change_state(machine, newly_built_state)

/decl/machine_construction/wall_frame/panel_closed/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	if(isScrewdriver(I))
		TRANSFER_STATE(open_state)
		playsound(get_turf(machine), 'sound/items/Screwdriver.ogg', 50, 1)
		machine.panel_open = TRUE
		to_chat(user, SPAN_NOTICE("You open the maintenance hatch of \the [machine], exposing the wiring."))
		machine.queue_icon_update()
		return
	if(istype(I, /obj/item/storage/part_replacer))
		machine.display_parts(user)
		return TRUE

/decl/machine_construction/wall_frame/panel_closed/mechanics_info()
	. = list()
	. += "Use a screwdriver to open the panel and expose the wires."
	. += "Use a parts replacer to view installed parts."

/decl/machine_construction/wall_frame/panel_closed/post_construct(obj/machinery/machine)
	try_change_state(machine, newly_built_state)
	machine.panel_open = TRUE
	machine.queue_icon_update()

// Open panel

/decl/machine_construction/wall_frame/panel_open/state_is_valid(obj/machinery/machine)
	return machine.panel_open && machine.get_component_of_type(/obj/item/stock_parts/circuitboard)

/decl/machine_construction/wall_frame/panel_open/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		if(machine.panel_open)
			try_change_state(machine, bottom_state)
		else
			try_change_state(machine, active_state)

/decl/machine_construction/wall_frame/panel_open/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return

	if(isWirecutter(I))
		TRANSFER_STATE(diconnected_state)
		playsound(get_turf(machine), 'sound/items/Wirecutter.ogg', 50, 1)
		user.visible_message(SPAN_WARNING("\The [user] has cut the wires inside \the [machine]!"), "You have cut the wires inside \the [machine].")
		new /obj/item/stack/cable_coil(get_turf(machine), 5)
		machine.set_broken(TRUE, MACHINE_BROKEN_CONSTRUCT)
		machine.queue_icon_update()
		return

	if(isScrewdriver(I))
		TRANSFER_STATE(active_state)
		playsound(get_turf(machine), 'sound/items/Screwdriver.ogg', 50, 1)
		machine.panel_open = FALSE
		to_chat(user, SPAN_NOTICE("You close the maintenance hatch of \the [machine]."))
		machine.queue_icon_update()
		return

	if(istype(I, /obj/item/storage/part_replacer))
		return machine.part_replacement(user, I)

	if(isWrench(I))
		return machine.part_removal(user)

	if(istype(I))
		return machine.part_insertion(user, I)

// Wires removed

/decl/machine_construction/wall_frame/panel_open/mechanics_info()
	. = list()
	. += "Use a screwdriver to close the panel."
	. += "Use a parts replacer to upgrade some parts."
	. += "Insert a new part to install it."
	. += "Remove installed parts with a wrench."
	. += "Use a wirecutter to disconnect the wires and expose the circuit board."


/decl/machine_construction/wall_frame/no_wires

/decl/machine_construction/wall_frame/no_wires/state_is_valid(obj/machinery/machine)
	return machine.panel_open && machine.get_component_of_type(/obj/item/stock_parts/circuitboard)

/decl/machine_construction/wall_frame/no_wires/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		if(machine.panel_open)
			try_change_state(machine, bottom_state)
		else
			try_change_state(machine, active_state)

/decl/machine_construction/wall_frame/no_wires/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return

	if(isCoil(I))
		var/obj/item/stack/cable_coil/A = I
		if (A.can_use(5))
			TRANSFER_STATE(open_state)
			A.use(5)
			to_chat(user, SPAN_NOTICE("You wire the [machine]."))
			machine.set_broken(FALSE, MACHINE_BROKEN_CONSTRUCT)
			machine.queue_icon_update()
			return
		else
			to_chat(user, SPAN_WARNING("You need five pieces of cable to wire \the [machine]."))
			return TRUE

	if(isCrowbar(I))
		TRANSFER_STATE(bottom_state)
		playsound(get_turf(machine), 'sound/items/Crowbar.ogg', 50, 1)
		to_chat(user, "You pry out the circuit!")
		machine.uninstall_component(/obj/item/stock_parts/circuitboard)
		machine.queue_icon_update()
		return

	if(istype(I, /obj/item/storage/part_replacer))
		return machine.part_replacement(user, I)

	if(isWrench(I))
		return machine.part_removal(user)

	if(istype(I))
		return machine.part_insertion(user, I)

/decl/machine_construction/wall_frame/no_wires/mechanics_info()
	. = list()
	. += "Add wires to hook up the circuit board to the machine."
	. += "Use a parts replacer to upgrade some parts."
	. += "Insert a new part to install it."
	. += "Remove installed parts with a wrench."
	. += "Use a crowbar to pry out the circuit board."

// Empty frame

/decl/machine_construction/wall_frame/no_circuit

/decl/machine_construction/wall_frame/no_circuit/state_is_valid(obj/machinery/machine)
	return machine.panel_open && !machine.get_component_of_type(/obj/item/stock_parts/circuitboard)

/decl/machine_construction/wall_frame/no_circuit/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		if(machine.panel_open)
			try_change_state(machine, open_state)
		else
			try_change_state(machine, active_state)

/decl/machine_construction/wall_frame/no_circuit/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return

	if(istype(I, /obj/item/stock_parts/circuitboard))
		var/obj/item/stock_parts/circuitboard/board = I
		if(board.build_path != (machine.base_type || machine.type))
			to_chat(user, SPAN_WARNING("This circuitboard does not fit inside \the [machine]!"))
			return TRUE
		if(!user.canUnEquip(board))
			return TRUE
		TRANSFER_STATE(diconnected_state)
		user.unEquip(board, machine)
		machine.install_component(board)
		user.visible_message(SPAN_NOTICE("\The [user] inserts \the [board] into \the [machine]!"), SPAN_NOTICE("You insert \the [board] into \the [machine]!"))
		machine.queue_icon_update()
		return

	if(isWrench(I))
		TRANSFER_STATE(/decl/machine_construction/default/deconstructed)
		machine.dismantle()
		return

/decl/machine_construction/wall_frame/no_circuit/mechanics_info()
	. = list()
	. += "Insert a circuit board to continue assembling the machine."
	. += "Use a wrench to unfasten the machine frame."