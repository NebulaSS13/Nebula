/obj/item/stock_parts/computer/lan_port
	name = "wired connection port"
	desc = "A basic expansion port for use with wired connections."
	power_usage = 30
	origin_tech = @'{"programming":1,"engineering":1}'
	icon_state = "netcard_ethernet"
	hardware_size = 3
	material = /decl/material/solid/glass
	var/obj/structure/network_cable/terminal/terminal

/obj/item/stock_parts/computer/lan_port/Initialize()
	. = ..()
	// If we spawn in a machine, assume we want to generate a terminal immediately.
	if(istype(loc, /obj/machinery))
		set_terminal()

/obj/item/stock_parts/computer/lan_port/Destroy()
	QDEL_NULL(terminal)
	return ..()

/obj/item/stock_parts/computer/lan_port/on_uninstall(obj/machinery/machine, temporary)
	. = ..()
	QDEL_NULL(terminal)

/obj/item/stock_parts/computer/lan_port/proc/set_terminal()
	if(terminal)
		unset_terminal(terminal)
	var/obj/machinery/parent = loc
	if(!istype(parent))
		return
	terminal = new(get_turf(parent))
	set_extension(src, /datum/extension/event_registration/shuttle_stationary, GET_DECL(/decl/observ/moved), parent, PROC_REF(check_terminal_prox), get_area(src))
	events_repository.register(/decl/observ/destroyed, terminal, src, PROC_REF(unset_terminal))
	set_status(parent, PART_STAT_CONNECTED)

/obj/item/stock_parts/computer/lan_port/proc/unset_terminal()
	remove_extension(src, /datum/extension/event_registration/shuttle_stationary)
	events_repository.unregister(/decl/observ/destroyed, terminal, src, PROC_REF(unset_terminal))
	var/obj/machinery/parent = loc
	if(istype(parent))
		unset_status(parent, PART_STAT_CONNECTED)
	terminal = null

/obj/item/stock_parts/computer/lan_port/proc/check_terminal_prox()
	if(!terminal)
		return TRUE
	var/obj/machinery/parent = loc
	if(!istype(parent))
		qdel(terminal)
		return FALSE
	if(get_turf(parent) != get_turf(terminal))
		parent.visible_message(SPAN_WARNING("The terminal is ripped out of \the [parent]!"))
		qdel(terminal)
		return FALSE
	return TRUE

/obj/item/stock_parts/computer/lan_port/proc/check_terminal_block(var/turf/T)
	return locate(/obj/structure/network_cable) in T

/obj/item/stock_parts/computer/lan_port/attackby(obj/item/I, mob/user)
	var/obj/machinery/parent = loc
	if(!istype(parent))
		return ..()

	// Interactions inside machine only
	if (istype(I, /obj/item/stack/net_cable_coil) && !terminal)
		var/turf/T = get_turf(parent)
		if(check_terminal_block(T))
			to_chat(user, SPAN_WARNING("There's already a network cable there!"))
			return FALSE
		if(istype(T) && !T.is_plating())
			to_chat(user, SPAN_WARNING("You must remove the floor plating beneath \the [parent] first."))
			return TRUE

		var/obj/item/stack/net_cable_coil/C = I
		if(!C.can_use(5))
			to_chat(user, SPAN_WARNING("You need five lengths of network cable for \the [parent]."))
			return TRUE

		user.visible_message(SPAN_NOTICE("\The [user] adds cables to the \the [parent]."), "You start adding cables to \the [parent] frame...")
		if(do_after(user, 20, parent))
			if(!terminal && (loc == parent) && parent.components_are_accessible(type) && !check_terminal_block(T) && C.use(5))
				user.visible_message(SPAN_NOTICE("\The [user] has added cables to the \the [parent]!"), "You add cables to the \the [parent].")
				set_terminal()
		return TRUE
	if(IS_WIRECUTTER(I) && terminal)
		var/turf/T = get_turf(parent)
		if(istype(T) && !T.is_plating())
			to_chat(user, SPAN_WARNING("You must remove the floor plating beneath \the [parent] first."))
			return TRUE
		user.visible_message(SPAN_NOTICE("\The [user] dismantles the power terminal from \the [parent]."), "You begin to cut the cables...")
		if(do_after(user, 15, parent))
			if(terminal && (loc == parent) && parent.components_are_accessible(type))
				new /obj/item/stack/net_cable_coil(T, 5)
				to_chat(user, SPAN_NOTICE("You cut the cables and dismantle the network terminal."))
				qdel(terminal)
		return TRUE
