#define SOUND_ID "pipe_leakage"

/obj/machinery/atmospherics/pipe

	var/datum/gas_mixture/air_temporary // used when reconstructing a pipeline that broke
	var/datum/pipeline/parent
	var/volume = 0
	var/leaking = 0		// Do not set directly, use set_leaking(TRUE/FALSE)
	use_power = POWER_USE_OFF

	//minimum pressure before check_pressure(...) should be called
	var/maximum_pressure = 210 * ONE_ATMOSPHERE
	var/fatigue_pressure = 170 * ONE_ATMOSPHERE
	var/alert_pressure = 170 * ONE_ATMOSPHERE

	can_buckle = 1
	buckle_require_restraints = 1
	buckle_lying = -1
	var/datum/sound_token/sound_token
	build_icon_state = "simple"
	build_icon = 'icons/obj/pipe-item.dmi'
	pipe_class = PIPE_CLASS_BINARY
	atom_flags = ATOM_FLAG_CAN_BE_PAINTED

	frame_type = /obj/item/pipe
	uncreated_component_parts = null // No apc connection
	construct_state = /decl/machine_construction/pipe

/obj/machinery/atmospherics/pipe/drain_power()
	return -1

/obj/machinery/atmospherics/pipe/Initialize()
	if(istype(get_turf(src), /turf/simulated/wall) || istype(get_turf(src), /turf/simulated/shuttle/wall) || istype(get_turf(src), /turf/unsimulated/wall))
		level = 1
	alpha = 255 // for mapping hidden pipes
	. = ..()

/obj/machinery/atmospherics/pipe/hides_under_flooring()
	return level != 2

/obj/machinery/atmospherics/pipe/proc/set_leaking(var/new_leaking)
	if(new_leaking && !leaking)
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		leaking = TRUE
		if(parent)
			parent.leaks |= src
			if(parent.network)
				parent.network.leaks |= src
	else if (!new_leaking && leaking)
		update_sound(0)
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		leaking = FALSE
		if(parent)
			parent.leaks -= src
			if(parent.network)
				parent.network.leaks -= src

/obj/machinery/atmospherics/pipe/proc/update_sound(var/playing)
	if(playing && !sound_token)
		sound_token = play_looping_sound(src, SOUND_ID, "sound/machines/pipeleak.ogg", volume = 8, range = 3, falloff = 1, prefer_mute = TRUE)
	else if(!playing && sound_token)
		QDEL_NULL(sound_token)

/obj/machinery/atmospherics/pipe/proc/pipeline_expansion()
	return nodes_to_networks || list()

/obj/machinery/atmospherics/pipe/proc/check_pressure(pressure)
	//Return 1 if parent should continue checking other pipes
	//Return null if parent should stop checking other pipes. Recall: qdel(src) will by default return null

	return 1


/obj/machinery/atmospherics/pipe/atmos_init()
	qdel(parent)
	..()
	var/turf/T = loc
	if(level == 1 && !T.is_plating())
		hide(1)

/obj/machinery/atmospherics/pipe/return_air()
	if(!parent)
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.air

/obj/machinery/atmospherics/pipe/build_network()
	if(!parent)
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.return_network()

/obj/machinery/atmospherics/pipe/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(!parent)
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.network_expand(new_network, reference)

/obj/machinery/atmospherics/pipe/return_network(obj/machinery/atmospherics/reference)
	if(!parent)
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.return_network(reference)

/obj/machinery/atmospherics/pipe/Destroy()
	QDEL_NULL(parent)
	QDEL_NULL(sound_token)
	if(air_temporary)
		loc.assume_air(air_temporary)
	. = ..()

/obj/machinery/atmospherics/pipe/deconstruction_pressure_check()
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()

	if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		return FALSE
	return TRUE

/obj/machinery/atmospherics/pipe/cannot_transition_to(state_path, mob/user)
	if(state_path == /decl/machine_construction/default/deconstructed)
		var/turf/T = get_turf(src)
		if (level==1 && isturf(T) && !T.is_plating())
			return SPAN_WARNING("You must remove the plating first.")
	return ..()

/obj/machinery/atmospherics/pipe/dismantle()
	for (var/obj/machinery/meter/meter in get_turf(src))
		if (meter.target == src)
			meter.dismantle()
	..()

/obj/machinery/atmospherics/pipe/disconnect(obj/machinery/atmospherics/reference)
	if(reference in nodes_to_networks)
		if(istype(reference, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		LAZYREMOVE(nodes_to_networks, reference)
	update_icon()

/obj/machinery/atmospherics/get_color()
	return pipe_color

/obj/machinery/atmospherics/set_color(new_color)
	pipe_color = new_color
	update_icon()

/obj/machinery/atmospherics/pipe/color_cache_name(var/obj/machinery/atmospherics/node)
	if(istype(src, /obj/machinery/atmospherics/unary/tank))
		return ..()

	if(istype(node, /obj/machinery/atmospherics/pipe/manifold) || istype(node, /obj/machinery/atmospherics/pipe/manifold4w))
		if(pipe_color == node.pipe_color)
			return node.pipe_color
		else
			return null
	else if(istype(node, /obj/machinery/atmospherics/pipe/simple))
		return node.pipe_color
	else
		return pipe_color

/obj/machinery/atmospherics/pipe/set_color(new_color)
	..()
	//for updating connected atmos device pipes (i.e. vents, manifolds, etc)
	for(var/obj/machinery/atmospherics/node as anything in nodes_to_networks)
		node.update_icon()

/obj/machinery/atmospherics/pipe/proc/try_leak()
	var/missing = FALSE
	for(var/direction in global.cardinal)
		if((direction & initialize_directions) && !length(nodes_in_dir(direction)))
			missing = TRUE
			break
	set_leaking(missing)

/obj/machinery/atmospherics/pipe/hide(var/i)
	if(istype(loc, /turf/simulated))
		set_invisibility(i ? 101 : 0)
	update_icon()

/obj/machinery/atmospherics/pipe/Process()
	if(!parent) //This should cut back on the overhead calling build_network thousands of times per cycle
		..()
	else if(parent.air.compare(loc.return_air()))
		update_sound(0)
		. = PROCESS_KILL
	else if(leaking)
		parent.mingle_with_turf(loc, volume)
		var/air = parent.air && parent.air.return_pressure()
		if(!sound_token && air)
			update_sound(1)
		else if(sound_token && !air)
			update_sound(0)
	else
		. = PROCESS_KILL

/obj/machinery/atmospherics/pipe/simple
	icon = 'icons/atmos/pipes.dmi'
	icon_state = "11"
	name = "pipe"
	desc = "A one meter section of regular pipe."

	volume = ATMOS_DEFAULT_VOLUME_PIPE

	dir = SOUTH
	initialize_directions = SOUTH|NORTH

	var/minimum_temperature_difference = 300
	var/thermal_conductivity = 0 //WALL_HEAT_TRANSFER_COEFFICIENT No

	level = 1

	rotate_class = PIPE_ROTATE_TWODIR
	connect_dir_type = SOUTH | NORTH // Overridden if dir is not a cardinal for bent pipes. For straight pipes this is correct.

/obj/machinery/atmospherics/pipe/simple/check_pressure(pressure)
	// Don't ask me, it happened somehow.
	if (!istype(loc, /turf))
		return 1

	var/datum/gas_mixture/environment = loc.return_air()

	var/pressure_difference = pressure - environment.return_pressure()

	if(pressure_difference > maximum_pressure)
		burst()

	else if(pressure_difference > fatigue_pressure)
		//TODO: leak to turf, doing pfshhhhh
		if(prob(5))
			burst()

	else return 1

/obj/machinery/atmospherics/pipe/simple/proc/burst()
	ASSERT(parent)
	parent.temporarily_store_air()
	src.visible_message("<span class='danger'>\The [src] bursts!</span>");
	playsound(src.loc, 'sound/effects/bang.ogg', 25, 1)
	var/datum/effect/effect/system/smoke_spread/smoke = new
	smoke.set_up(1,0, src.loc, 0)
	smoke.start()
	qdel(src)

/obj/machinery/atmospherics/pipe/simple/on_update_icon(var/safety = 0)
	if(!atmos_initalized)
		return

	var/integrity_key = ""
	for(var/direction in global.cardinal) // go through initialize directions in flag order, add "1" if there's a node and "0" if not, that's the key
		if(!(direction & initialize_directions))
			continue
		integrity_key += "[!!length(nodes_in_dir(direction))]"

	icon_state = "[integrity_key][icon_connect_type]"
	if(!isnull(pipe_color))
		color = pipe_color

	try_leak()

/obj/machinery/atmospherics/pipe/simple/visible
	level = 2

/obj/machinery/atmospherics/pipe/simple/visible/scrubbers
	name = "Scrubbers pipe"
	desc = "A one meter section of scrubbers pipe."
	icon_state = "11-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/visible/supply
	name = "Air supply pipe"
	desc = "A one meter section of supply pipe."
	icon_state = "11-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/simple/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/simple/visible/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/simple/visible/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/simple/visible/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/visible/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/visible/fuel
	name = "Fuel pipe"
	color = PIPE_COLOR_ORANGE
	maximum_pressure = 420*ONE_ATMOSPHERE
	fatigue_pressure = 350*ONE_ATMOSPHERE
	alert_pressure = 350*ONE_ATMOSPHERE
	connect_types = CONNECT_TYPE_FUEL

/obj/machinery/atmospherics/pipe/simple/hidden
	level = 1
	alpha = 128		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/machinery/atmospherics/pipe/simple/hidden/scrubbers
	name = "Scrubbers pipe"
	desc = "A one meter section of scrubbers pipe."
	icon_state = "11-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/hidden/supply
	name = "Air supply pipe"
	desc = "A one meter section of supply pipe."
	icon_state = "11-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/simple/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/simple/hidden/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/simple/hidden/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/simple/hidden/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/hidden/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/hidden/fuel
	name = "Fuel pipe"
	color = PIPE_COLOR_ORANGE
	maximum_pressure = 420*ONE_ATMOSPHERE
	fatigue_pressure = 350*ONE_ATMOSPHERE
	alert_pressure = 350*ONE_ATMOSPHERE
	connect_types = CONNECT_TYPE_FUEL

/obj/machinery/atmospherics/pipe/manifold
	icon = 'icons/atmos/manifold.dmi'
	icon_state = "map"
	name = "pipe manifold"
	desc = "A manifold composed of regular pipes."
	volume = ATMOS_DEFAULT_VOLUME_PIPE * 1.5

	dir = SOUTH
	initialize_directions = EAST|NORTH|WEST

	build_icon_state = "manifold"
	level = 1

	pipe_class = PIPE_CLASS_TRINARY
	connect_dir_type = NORTH | EAST | WEST

/obj/machinery/atmospherics/pipe/manifold/on_update_icon(var/safety = 0)
	if(!atmos_initalized)
		return

	icon_state = null
	cut_overlays()
	var/image/I = image(icon, "core[icon_connect_type]")
	I.color = pipe_color
	add_overlay(I)
	add_overlay("clamps[icon_connect_type]")

	underlays.Cut()
	for(var/direction in global.cardinal)
		if(!(direction & initialize_directions))
			continue
		var/list/check_nodes = nodes_in_dir(direction)
		add_underlay(get_turf(src), length(check_nodes) && check_nodes[1], direction, icon_connect_type)

	try_leak()

/obj/machinery/atmospherics/pipe/manifold/visible
	icon_state = "map"
	level = 2

/obj/machinery/atmospherics/pipe/manifold/visible/scrubbers
	name="Scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes."
	icon_state = "map-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/visible/supply
	name="Air supply pipe manifold"
	desc = "A manifold composed of supply pipes."
	icon_state = "map-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold/visible/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/manifold/visible/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/manifold/visible/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/visible/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold/visible/fuel
	name = "Fuel pipe manifold"
	color = PIPE_COLOR_ORANGE
	connect_types = CONNECT_TYPE_FUEL

/obj/machinery/atmospherics/pipe/manifold/hidden
	icon_state = "map"
	level = 1
	alpha = 128		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/machinery/atmospherics/pipe/manifold/hidden/scrubbers
	name="Scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes."
	icon_state = "map-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/hidden/supply
	name="Air supply pipe manifold"
	desc = "A manifold composed of supply pipes."
	icon_state = "map-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold/hidden/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/manifold/hidden/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/manifold/hidden/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/hidden/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold/hidden/fuel
	name = "Fuel pipe manifold"
	color = PIPE_COLOR_ORANGE
	connect_types = CONNECT_TYPE_FUEL

/obj/machinery/atmospherics/pipe/manifold4w
	icon = 'icons/atmos/manifold.dmi'
	icon_state = ""
	name = "4-way pipe manifold"
	desc = "A manifold composed of regular pipes."
	volume = ATMOS_DEFAULT_VOLUME_PIPE * 2

	dir = SOUTH
	initialize_directions = NORTH|SOUTH|EAST|WEST

	build_icon_state = "manifold4w"
	level = 1

	pipe_class = PIPE_CLASS_QUATERNARY
	rotate_class = PIPE_ROTATE_ONEDIR
	connect_dir_type = NORTH | SOUTH | EAST | WEST

/obj/machinery/atmospherics/pipe/manifold4w/on_update_icon(var/safety = 0)
	if(!atmos_initalized)
		return

	icon_state = null
	cut_overlays()
	var/image/I = image(icon, "4way[icon_connect_type]")
	I.color = pipe_color
	add_overlay(I)
	add_overlay("clamps_4way[icon_connect_type]")

	underlays.Cut()
	for(var/direction in global.cardinal)
		if(!(direction & initialize_directions))
			continue
		var/list/check_nodes = nodes_in_dir(direction)
		add_underlay(get_turf(src), length(check_nodes) && check_nodes[1], direction, icon_connect_type)

	try_leak()

/obj/machinery/atmospherics/pipe/manifold4w/visible
	icon_state = "map_4way"
	level = 2

/obj/machinery/atmospherics/pipe/manifold4w/visible/scrubbers
	name="4-way scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes."
	icon_state = "map_4way-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold4w/visible/supply
	name="4-way air supply pipe manifold"
	desc = "A manifold composed of supply pipes."
	icon_state = "map_4way-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold4w/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold4w/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold4w/visible/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/manifold4w/visible/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/manifold4w/visible/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold4w/visible/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold4w/visible/fuel
	name = "4-way fuel pipe manifold"
	color = PIPE_COLOR_ORANGE
	connect_types = CONNECT_TYPE_FUEL

/obj/machinery/atmospherics/pipe/manifold4w/hidden
	icon_state = "map_4way"
	level = 1
	alpha = 128		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/machinery/atmospherics/pipe/manifold4w/hidden/scrubbers
	name="4-way scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes."
	icon_state = "map_4way-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold4w/hidden/supply
	name="4-way air supply pipe manifold"
	desc = "A manifold composed of supply pipes."
	icon_state = "map_4way-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold4w/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold4w/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold4w/hidden/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/manifold4w/hidden/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/manifold4w/hidden/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold4w/hidden/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold4w/hidden/fuel
	name = "4-way fuel pipe manifold"
	color = PIPE_COLOR_ORANGE
	connect_types = CONNECT_TYPE_FUEL

/obj/machinery/atmospherics/pipe/cap
	name = "pipe endcap"
	desc = "An endcap for pipes."
	icon = 'icons/atmos/pipes.dmi'
	icon_state = "cap"
	level = 2
	volume = 35

	pipe_class = PIPE_CLASS_UNARY
	dir = SOUTH
	initialize_directions = SOUTH
	build_icon_state = "cap"

/obj/machinery/atmospherics/pipe/cap/on_update_icon(var/safety = 0)
	icon_state = "cap[icon_connect_type]"
	color = pipe_color

/obj/machinery/atmospherics/pipe/cap/visible
	level = 2
	icon_state = "cap"

/obj/machinery/atmospherics/pipe/cap/visible/scrubbers
	name = "scrubbers pipe endcap"
	desc = "An endcap for scrubbers pipes."
	icon_state = "cap-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/cap/visible/supply
	name = "supply pipe endcap"
	desc = "An endcap for supply pipes."
	icon_state = "cap-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/cap/visible/fuel
	name = "fuel pipe endcap"
	desc = "An endcap for fuel pipes."
	color = PIPE_COLOR_ORANGE
	connect_types = CONNECT_TYPE_FUEL

/obj/machinery/atmospherics/pipe/cap/hidden
	level = 1
	icon_state = "cap"
	alpha = 128

/obj/machinery/atmospherics/pipe/cap/hidden/scrubbers
	name = "scrubbers pipe endcap"
	desc = "An endcap for scrubbers pipes."
	icon_state = "cap-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/cap/hidden/supply
	name = "supply pipe endcap"
	desc = "An endcap for supply pipes."
	icon_state = "cap-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/cap/hidden/fuel
	name = "fuel pipe endcap"
	desc = "An endcap for fuel pipes."
	color = PIPE_COLOR_ORANGE
	connect_types = CONNECT_TYPE_FUEL

/obj/machinery/atmospherics/pipe/simple/visible/universal
	name="Universal pipe adapter"
	desc = "An adapter for regular, supply, scrubbers, and fuel pipes."
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL|CONNECT_TYPE_HE
	icon_state = "map_universal"
	build_icon_state = "universal"

/obj/machinery/atmospherics/pipe/simple/visible/universal/on_update_icon(var/safety = 0)
	if(!atmos_initalized)
		return

	icon_state = "universal"

	underlays.Cut()
	for(var/direction in global.cardinal)
		if(direction & initialize_directions)
			universal_underlays(direction)

/obj/machinery/atmospherics/pipe/simple/hidden/universal
	name="Universal pipe adapter"
	desc = "An adapter for regular, supply and scrubbers pipes."
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL|CONNECT_TYPE_HE
	icon_state = "map_universal"
	build_icon_state = "universal"

/obj/machinery/atmospherics/pipe/simple/hidden/universal/on_update_icon(var/safety = 0)
	if(!atmos_initalized)
		return

	icon_state = "universal"

	underlays.Cut()
	for(var/direction in global.cardinal)
		if(direction & initialize_directions)
			universal_underlays(direction)

/obj/machinery/atmospherics/proc/universal_underlays(var/direction)
	var/turf/T = loc
	var/connections = list("", "-supply", "-scrubbers")
	for(var/obj/machinery/atmospherics/node as anything in nodes_in_dir(direction))
		if(node.icon_connect_type in connections)
			connections[node.icon_connect_type] = node
	for(var/suffix in connections)
		add_underlay(T, connections[suffix], direction, suffix, "retracted")

#undef SOUND_ID