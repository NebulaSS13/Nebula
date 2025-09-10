//////////////////////////////////////////////////////////////////////
// Geothermal Generator
//////////////////////////////////////////////////////////////////////

///A power generator that can create power from being placed on top of a geyser.
/obj/machinery/geothermal
	name                           = "geothermal generator"
	icon                           = 'icons/obj/machines/power/geothermal.dmi'
	icon_state                     = "geothermal-base"
	density                        = TRUE
	anchored                       = TRUE
	waterproof                     = TRUE
	interact_offline               = TRUE
	stat_immune                    = NOSCREEN | NOINPUT | NOPOWER
	core_skill                     = SKILL_ENGINES
	required_interaction_dexterity = DEXTERITY_SIMPLE_MACHINES
	construct_state                = /decl/machine_construction/default/panel_closed
	uncreated_component_parts      = list(
		/obj/item/stock_parts/power/terminal,
	)
	stock_part_presets             = list(
		/decl/stock_part_preset/terminal_setup/offset_dir,
	)
	var/tmp/neighbors              = 0
	var/tmp/current_pressure       = 0
	var/tmp/efficiency             = 0.5
	var/tmp/last_generated         = 0
	var/tmp/datum/extension/geothermal_vent/vent
	var/tmp/obj/item/stock_parts/power/terminal/connector
	var/tmp/image/glow
	var/tmp/list/neighbor_connectors
	var/tmp/list/neighbor_connectors_glow

	var/const/GEOTHERMAL_EFFICIENCY_MOD =             0.2
	var/const/GEOTHERMAL_PRESSURE_LOSS =              0.3
	var/const/GEOTHERMAL_PRESSURE_CONSUMED_PER_TICK = 0.05
	var/const/GEOTHERMAL_PRESSURE_TO_POWER =          800
	var/const/MAX_GEOTHERMAL_PRESSURE =               12000

//#TODO: Maybe should cache neighbors and put listeners on them?

/obj/machinery/geothermal/Initialize(mapload, d, populate_parts = TRUE)
	. = ..()
	if(get_turf(loc))
		refresh_neighbors()
		propagate_refresh_neighbors()
	STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/geothermal/LateInitialize()
	. = ..()
	setup_vent()

/obj/machinery/geothermal/Destroy()
	var/atom/last_loc = loc
	unset_vent()
	connector = null
	. = ..()
	if(istype(last_loc))
		propagate_refresh_neighbors(last_loc)

///Tell all neighbors of the center atom to call update neighbors
/obj/machinery/geothermal/proc/propagate_refresh_neighbors(var/atom/center = src)
	for(var/adir in global.alldirs)
		var/obj/machinery/geothermal/G = locate(/obj/machinery/geothermal) in get_step(center, adir)
		if(G?.anchored)
			G.refresh_neighbors()

/obj/machinery/geothermal/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance < 2)
		. += SPAN_INFO("Pressure: [current_pressure]kPa")
		. += SPAN_INFO("Output:   [last_generated]W")

///Attempts to connect to any existing geothermal vents in our turf.
/obj/machinery/geothermal/proc/setup_vent()
	var/turf/T = get_turf(src)
	for(var/obj/O in T)
		var/datum/extension/geothermal_vent/GV = get_extension(O, /datum/extension/geothermal_vent)
		if(!GV || QDELETED(GV))
			continue
		vent = GV
		vent.set_my_generator(src)
		return TRUE

///Disconnect from any geothermal vents we may be connected to
/obj/machinery/geothermal/proc/unset_vent()
	if(QDELETED(vent))
		return
	vent.set_my_generator(null)
	vent = null

/obj/machinery/geothermal/RefreshParts()
	..()
	efficiency = clamp(total_component_rating_of_type(/obj/item/stock_parts/capacitor) * GEOTHERMAL_EFFICIENCY_MOD, GEOTHERMAL_EFFICIENCY_MOD, 1)
	connector = get_component_of_type(/obj/item/stock_parts/power/terminal)

/obj/machinery/geothermal/proc/add_pressure(var/pressure)
	current_pressure = clamp(current_pressure + pressure, 0, MAX_GEOTHERMAL_PRESSURE)
	var/leftover = round(pressure - current_pressure)
	if(leftover > 0)
		addtimer(CALLBACK(src, PROC_REF(propagate_pressure), leftover), 5)
	update_icon()
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/geothermal/Process()
	if(loc && anchored && !(stat & BROKEN))
		var/consumed_pressure = current_pressure * GEOTHERMAL_PRESSURE_CONSUMED_PER_TICK
		current_pressure -= consumed_pressure
		var/remaining_pressure = consumed_pressure
		consumed_pressure = round(consumed_pressure * efficiency, 0.01)
		remaining_pressure -= consumed_pressure

		last_generated = round(consumed_pressure * GEOTHERMAL_PRESSURE_TO_POWER, 0.01)
		if(last_generated)
			generate_power(last_generated)
		remaining_pressure = round(remaining_pressure * GEOTHERMAL_PRESSURE_LOSS)
		if(remaining_pressure)
			addtimer(CALLBACK(src, PROC_REF(propagate_pressure), remaining_pressure), 5)
	update_icon()
	if(current_pressure <= 1)
		return PROCESS_KILL

/obj/machinery/geothermal/proc/propagate_pressure(var/remaining_pressure)
	var/list/neighbors
	for(var/neighbordir in global.cardinal)
		var/obj/machinery/geothermal/neighbor = (locate() in get_step(loc, neighbordir))
		if(neighbor?.anchored && !(neighbor.stat & BROKEN))
			LAZYADD(neighbors, neighbor)
	if(LAZYLEN(neighbors))
		remaining_pressure = round(remaining_pressure / LAZYLEN(neighbors))
		if(remaining_pressure)
			for(var/obj/machinery/geothermal/neighbor as anything in neighbors)
				neighbor.add_pressure(remaining_pressure)

/obj/machinery/geothermal/proc/refresh_neighbors()
	var/last_neighbors = neighbors
	neighbors = 0
	for(var/neighbordir in global.cardinal)
		if(locate(/obj/machinery/geothermal) in get_step(loc, neighbordir))
			neighbors |= neighbordir
	if(last_neighbors != neighbors)
		update_icon()

/obj/machinery/geothermal/on_update_icon()
	cut_overlays()
	var/output_ratio = current_pressure / 3000
	var/glow_alpha   = clamp(round((current_pressure / MAX_GEOTHERMAL_PRESSURE) * 255), 10, 255)
	if(!glow)
		glow = emissive_overlay(icon, "geothermal-glow")
	if(!length(neighbor_connectors))
		for(var/neighbordir in global.cardinal)
			LAZYSET(neighbor_connectors,      "[neighbordir]", image(icon, "geothermal-connector",      dir = neighbordir))
			LAZYSET(neighbor_connectors_glow, "[neighbordir]", image(icon, "geothermal-connector-glow", dir = neighbordir))

	if(neighbors)
		for(var/neighbordir in global.cardinal)
			if(neighbors & neighbordir)
				add_overlay(neighbor_connectors["[neighbordir]"])
				// emissive_overlay is not setting dir and setting plane/layer directly also causes dir to break :(
				var/image/neighborglow = neighbor_connectors_glow["[neighbordir]"]
				neighborglow.alpha = glow_alpha
				add_overlay(neighborglow)

	if(round(current_pressure, 0.1) <= 0)
		set_light(0)
		return

	set_light(1, clamp(output_ratio, 0.2, 1.0), COLOR_RED)
	add_overlay("geothermal-turbine-[clamp(round(output_ratio * 3), 0, 3)]")
	glow.alpha = glow_alpha
	add_overlay(glow)

/obj/machinery/geothermal/dismantle()
	. = ..()
	unset_vent()

/obj/machinery/geothermal/get_powernet()
	return connector?.terminal?.get_powernet()

/obj/machinery/geothermal/drain_power()
	return -1