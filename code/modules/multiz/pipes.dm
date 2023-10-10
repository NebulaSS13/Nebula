////////////////////////////
// parent class for pipes //
////////////////////////////
/obj/machinery/atmospherics/pipe/zpipe
	icon = 'icons/obj/pipe-item.dmi'
	icon_state = "up"

	name = "upwards pipe"
	desc = "A pipe segment to connect upwards."

	volume = 70

	dir = SOUTH
	initialize_directions = SOUTH

	level = 1

/obj/machinery/atmospherics/pipe/zpipe/check_pressure(pressure)
	var/datum/gas_mixture/environment = loc.return_air()

	var/pressure_difference = pressure - environment.return_pressure()

	if(pressure_difference > maximum_pressure)
		burst()

	else if(pressure_difference > fatigue_pressure)
		//TODO: leak to turf, doing pfshhhhh
		if(prob(5))
			burst()

	else return 1

/obj/machinery/atmospherics/pipe/zpipe/proc/burst()
	src.visible_message("<span class='warning'>\The [src] bursts!</span>");
	playsound(src.loc, 'sound/effects/bang.ogg', 25, 1)
	var/datum/effect/effect/system/smoke_spread/smoke = new
	smoke.set_up(1,0, src.loc, 0)
	smoke.start()
	qdel(src) // NOT qdel.

/obj/machinery/atmospherics/pipe/zpipe/on_update_icon()
	return

/////////////////////////
// the elusive up pipe //
/////////////////////////
/obj/machinery/atmospherics/pipe/zpipe/up
	icon_state = "up"

	name = "upwards pipe"
	desc = "A pipe segment to connect upwards."

/obj/machinery/atmospherics/pipe/zpipe/up/atmos_init()
	..()
	var/turf/above = GetAbove(src)
	if(above)
		for(var/obj/machinery/atmospherics/target in above)
			if(istype(target, /obj/machinery/atmospherics/pipe/zpipe/down) && check_connect_types(target,src))
				LAZYDISTINCTADD(nodes_to_networks, target)

///////////////////////
// and the down pipe //
///////////////////////

/obj/machinery/atmospherics/pipe/zpipe/down
	icon_state = "down"

	name = "downwards pipe"
	desc = "A pipe segment to connect downwards."

/obj/machinery/atmospherics/pipe/zpipe/down/atmos_init()
	..()
	var/turf/below = GetBelow(src)
	if(below)
		for(var/obj/machinery/atmospherics/target in below)
			if(istype(target, /obj/machinery/atmospherics/pipe/zpipe/up) && check_connect_types(target,src))
				LAZYDISTINCTADD(nodes_to_networks, target)

///////////////////////
// supply/scrubbers  //
///////////////////////

/obj/machinery/atmospherics/pipe/zpipe/up/scrubbers
	icon_state = "up-scrubbers"
	name = "upwards scrubbers pipe"
	desc = "A scrubbers pipe segment to connect upwards."
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/zpipe/up/supply
	icon_state = "up-supply"
	name = "upwards supply pipe"
	desc = "A supply pipe segment to connect upwards."
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/zpipe/down/scrubbers
	icon_state = "down-scrubbers"
	name = "downwards scrubbers pipe"
	desc = "A scrubbers pipe segment to connect downwards."
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/zpipe/down/supply
	icon_state = "down-supply"
	name = "downwards supply pipe"
	desc = "A supply pipe segment to connect downwards."
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

// Colored misc. pipes
/obj/machinery/atmospherics/pipe/zpipe/up/cyan
	color = PIPE_COLOR_CYAN
/obj/machinery/atmospherics/pipe/zpipe/down/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/zpipe/up/red
	color = PIPE_COLOR_RED
/obj/machinery/atmospherics/pipe/zpipe/down/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/zpipe/up/fuel
	name = "upwards fuel pipe"
	color = PIPE_COLOR_ORANGE
	maximum_pressure = 420 ATM
	fatigue_pressure = 350 ATM
	connect_types = CONNECT_TYPE_FUEL

/obj/machinery/atmospherics/pipe/zpipe/down/fuel
	name = "downwards fuel pipe"
	color = PIPE_COLOR_ORANGE
	maximum_pressure = 420 ATM
	fatigue_pressure = 350 ATM
	connect_types = CONNECT_TYPE_FUEL
