//Circuit boards are in /code/game/objects/items/weapons/circuitboards/machinery/
///Made into a seperate type to make future revisions easier.
/obj/machinery/constructable_frame
	name = "machine frame"
	icon = 'icons/obj/items/stock_parts/stock_parts.dmi'
	icon_state = "box_0"
	density = TRUE
	anchored = FALSE
	use_power = POWER_USE_OFF
	uncreated_component_parts = null
	construct_state = /decl/machine_construction/frame/unwrenched
	obj_flags = OBJ_FLAG_ROTATABLE
	atom_flags = ATOM_FLAG_CLIMBABLE
	var/obj/item/stock_parts/circuitboard/circuit = null
	var/expected_machine_type

/obj/machinery/constructable_frame/state_transition(decl/machine_construction/new_state)
	. = ..()
	update_icon()

/obj/machinery/constructable_frame/dismantle()
	SSmaterials.create_object(/decl/material/solid/metal/steel, loc, 5, object_type = /obj/item/stack/material/strut)
	qdel(src)
	return TRUE

/obj/machinery/constructable_frame/machine_frame
	expected_machine_type = "machine"

/obj/machinery/constructable_frame/machine_frame/on_update_icon()
	switch(construct_state && construct_state.type)
		if(/decl/machine_construction/frame/awaiting_circuit)
			icon_state = "box_1"
		if(/decl/machine_construction/frame/awaiting_parts)
			icon_state = "box_2"
		else
			icon_state = "box_0"

/obj/machinery/constructable_frame/machine_frame/deconstruct
	anchored = TRUE
	construct_state = /decl/machine_construction/frame/awaiting_circuit