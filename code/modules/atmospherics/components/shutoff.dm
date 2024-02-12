var/global/list/shutoff_valves = list()

/obj/machinery/atmospherics/valve/shutoff
	icon = 'icons/atmos/clamp.dmi'
	icon_state = "map_vclamp0"

	name = "automatic shutoff valve"
	desc = "An automatic valve with control circuitry and pipe integrity sensor, capable of automatically isolating damaged segments of the pipe network."
	var/close_on_leaks = TRUE	// If false it will be always open
	level = LEVEL_BELOW_PLATING
	connect_types = CONNECT_TYPE_SCRUBBER | CONNECT_TYPE_SUPPLY | CONNECT_TYPE_REGULAR | CONNECT_TYPE_FUEL
	build_icon_state = "svalve"
	base_type = /obj/machinery/atmospherics/valve/shutoff/buildable

/obj/machinery/atmospherics/valve/shutoff/buildable
	uncreated_component_parts = null

/obj/machinery/atmospherics/valve/shutoff/on_update_icon()
	icon_state = "vclamp[open]"
	build_device_underlays(FALSE)

/obj/machinery/atmospherics/valve/shutoff/examine(mob/user)
	. = ..()
	to_chat(user, "The automatic shutoff circuit is [close_on_leaks ? "enabled" : "disabled"].")

/obj/machinery/atmospherics/valve/shutoff/Initialize()
	. = ..()
	shutoff_valves += src
	open()
	hide(1)

/obj/machinery/atmospherics/valve/shutoff/Destroy()
	. = ..()
	shutoff_valves -= src

/obj/machinery/atmospherics/valve/shutoff/interface_interact(var/mob/user)
	if(CanInteract(user, DefaultTopicState()))
		close_on_leaks = !close_on_leaks
		to_chat(user, "You [close_on_leaks ? "enable" : "disable"] the automatic shutoff circuit.")
		return TRUE

/obj/machinery/atmospherics/valve/shutoff/hide(var/do_hide)
	if(do_hide)
		if(level == LEVEL_BELOW_PLATING)
			layer = PIPE_LAYER
		else if(level == LEVEL_ABOVE_PLATING)
			..()
	else
		reset_plane_and_layer()

/obj/machinery/atmospherics/valve/shutoff/Process()
	..()

	var/directions = initialize_directions
	var/leaking = FALSE
	for(var/node in nodes_to_networks)
		directions &= ~get_dir(src, node) // connected in this direction
		var/datum/pipe_network/net = nodes_to_networks[node]
		if(length(net.leaks))
			leaking = TRUE

	if(directions && open) // disconnected on one side.
		close()
		return

	if(!close_on_leaks && !open)
		open()
		return

	if(leaking && open)
		close()
	else if(!leaking && !open)
		open()