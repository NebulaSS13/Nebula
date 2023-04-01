#define REAGENT_UNITS_PER_PIPE 1200

/datum/reagents/pipeline
	var/datum/pipeline/pipeline

/datum/reagents/pipeline/Destroy()
	if(pipeline)
		if(pipeline.liquid == src)
			pipeline.liquid = null
		pipeline = null
	. = ..()

/datum/pipeline
	var/datum/gas_mixture/air
	var/datum/reagents/pipeline/liquid // Needs to be an atom for reagent holder to work.

	var/list/obj/machinery/atmospherics/pipe/members
	var/list/obj/machinery/atmospherics/pipe/edges //Used for building networks

	var/datum/pipe_network/network
	// Leaking nodes
	var/list/leaks = list()

	var/maximum_pressure = 0

/datum/pipeline/New()
	START_PROCESSING(SSprocessing, src)

/datum/pipeline/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	QDEL_NULL(network)

	if(air?.volume || liquid?.total_volume)
		temporarily_store_fluids()
		QDEL_NULL(air)
		QDEL_NULL(liquid)

	for(var/obj/machinery/atmospherics/pipe/P in members)
		P.parent = null

	leaks.Cut()
	members.Cut()
	edges.Cut()

	. = ..()

/datum/pipeline/Process()//This use to be called called from the pipe networks
	//Check to see if pressure is within acceptable limits
	var/pressure = air.return_pressure()
	if(pressure > maximum_pressure)
		for(var/obj/machinery/atmospherics/pipe/member in members)
			if(!member.check_pressure(pressure))
				members.Remove(member)
				break //Only delete 1 pipe per process

/datum/pipeline/proc/temporarily_store_fluids()
	//Update individual gas_mixtures by volume ratio

	var/liquid_transfer_per_pipe = min(REAGENT_UNITS_PER_PIPE, (liquid && length(members)) ? (liquid.total_volume / length(members)) : 0)
	if(!liquid_transfer_per_pipe && !liquid_transfer_per_pipe)
		return

	for(var/obj/machinery/atmospherics/pipe/member in members)

		if(air?.volume)
			member.air_temporary = new
			member.air_temporary.copy_from(air)
			member.air_temporary.volume = member.volume
			member.air_temporary.multiply(member.volume / air.volume)

		if(liquid_transfer_per_pipe)
			member.liquid_temporary = new(REAGENT_UNITS_PER_PIPE, src)
			liquid.trans_to_holder(member.liquid_temporary, liquid_transfer_per_pipe)

/datum/pipeline/proc/build_pipeline(obj/machinery/atmospherics/pipe/base)

	members = list(base)
	edges = list()

	var/volume = base.volume
	base.parent = src
	maximum_pressure = base.maximum_pressure

	if(base.air_temporary)
		air = base.air_temporary
		base.air_temporary = null
	else
		air = new

	liquid = new
	liquid.pipeline = src

	if(base.leaking)
		leaks |= base

	var/list/possible_expansions = list(base)
	while(possible_expansions.len)
		for(var/obj/machinery/atmospherics/pipe/borderline in possible_expansions)

			var/list/result = borderline.pipeline_expansion()
			var/edge_check = result.len

			if(edge_check)
				for(var/obj/machinery/atmospherics/pipe/item in result)
					if(!members.Find(item))
						members += item
						possible_expansions += item

						volume += item.volume
						item.parent = src

						maximum_pressure = min(maximum_pressure, item.maximum_pressure)

						if(item.air_temporary)
							air.merge(item.air_temporary)
							item.air_temporary = null

						liquid.maximum_volume += REAGENT_UNITS_PER_PIPE
						if(item.liquid_temporary)
							item.liquid_temporary.trans_to_holder(liquid, item.liquid_temporary.total_volume)
							item.liquid_temporary = null

						if(item.leaking)
							leaks |= item

					edge_check--

			if(edge_check > 0)
				edges += borderline

			possible_expansions -= borderline

	air.volume = volume
	liquid.maximum_volume = length(members) * REAGENT_UNITS_PER_PIPE

/datum/pipeline/proc/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(new_network.line_members.Find(src))
		return

	if(network == new_network) // Should be caught by the above check in all reasonable cases, so we crash and try to clean up as best we can.
		PRINT_STACK_TRACE("pipeline - pipenet reference mismatch.")
	else
		qdel(network)

	new_network.line_members += src

	network = new_network
	network.leaks |= leaks

	for(var/obj/machinery/atmospherics/pipe/edge in edges)
		for(var/obj/machinery/atmospherics/result in edge.pipeline_expansion())
			if(!istype(result,/obj/machinery/atmospherics/pipe))
				result.network_expand(new_network, edge)

/datum/pipeline/proc/return_network(obj/machinery/atmospherics/reference)
	if(!network)
		var/datum/pipe_network/new_network = new
		new_network.build_network(src, null)
			//technically passing these parameters should not be allowed
			//however pipe_network.build_network(..) and pipeline.network_extend(...)
			//		were setup to properly handle this case

	return network

/datum/pipeline/proc/mingle_with_turf(turf/target, mingle_volume)

	if(!isturf(target))
		return

	var/datum/gas_mixture/air_sample = air.remove_ratio(mingle_volume/air.volume)
	air_sample.volume = mingle_volume

	if(target.zone)
		//Have to consider preservation of group statuses
		var/datum/gas_mixture/turf_copy = new

		turf_copy.copy_from(target.zone.air)
		turf_copy.volume = target.zone.air.volume //Copy a good representation of the turf from parent group

		equalize_gases(list(air_sample, turf_copy))
		air.merge(air_sample)

		turf_copy.subtract(target.zone.air)

		target.zone.air.merge(turf_copy)

	else
		var/datum/gas_mixture/turf_air = target.return_air()

		equalize_gases(list(air_sample, turf_air))
		air.merge(air_sample)
		//turf_air already modified by equalize_gases()

	if(liquid?.total_volume)
		liquid.trans_to_turf(target, FLUID_PUDDLE)

	if(network)
		network.update = 1

/datum/pipeline/proc/temperature_interact(turf/target, share_volume, thermal_conductivity)
	var/total_heat_capacity = air.heat_capacity()
	var/partial_heat_capacity = total_heat_capacity*(share_volume/air.volume)

	if(SHOULD_PARTICIPATE_IN_ZONES(target) && !target.blocks_air)
		var/delta_temperature = 0
		var/sharer_heat_capacity = 0

		if(target.zone)
			delta_temperature = (air.temperature - target.zone.air.temperature)
			sharer_heat_capacity = target.zone.air.heat_capacity()
		else
			delta_temperature = (air.temperature - target.air.temperature)
			sharer_heat_capacity = target.air.heat_capacity()

		var/self_temperature_delta = 0
		var/sharer_temperature_delta = 0

		if((sharer_heat_capacity > 0) && (partial_heat_capacity > 0))
			var/heat = thermal_conductivity*delta_temperature* \
				(partial_heat_capacity*sharer_heat_capacity/(partial_heat_capacity+sharer_heat_capacity))

			self_temperature_delta = -heat/total_heat_capacity
			sharer_temperature_delta = heat/sharer_heat_capacity
		else
			return 1

		air.temperature += self_temperature_delta

		if(target.zone)
			target.zone.air.temperature += sharer_temperature_delta/target.zone.air.group_multiplier
		else
			target.air.temperature += sharer_temperature_delta

	else if(istype(target, /turf/exterior) && !target.blocks_air)
		var/turf/exterior/modeled_location = target
		var/datum/gas_mixture/target_air = modeled_location.return_air()

		var/delta_temperature = air.temperature - target_air.temperature
		var/sharer_heat_capacity = target_air.heat_capacity()

		if((sharer_heat_capacity > 0) && (partial_heat_capacity > 0))
			var/heat = thermal_conductivity*delta_temperature* \
				(partial_heat_capacity*sharer_heat_capacity/(partial_heat_capacity+sharer_heat_capacity))

			air.temperature += -heat/total_heat_capacity
		else
			return 1

	else
		if((target.heat_capacity > 0) && (partial_heat_capacity > 0))
			var/delta_temperature = air.temperature - target.temperature

			var/heat = thermal_conductivity*delta_temperature* \
				(partial_heat_capacity*target.heat_capacity/(partial_heat_capacity+target.heat_capacity))

			air.temperature -= heat/total_heat_capacity
			// Only increase the temperature of the target if it's simulated.
			if(istype(target, /turf/simulated))
				target.temperature += heat/target.heat_capacity

	if(network)
		network.update = 1

//surface must be the surface area in m^2
/datum/pipeline/proc/radiate_heat_to_space(surface, thermal_conductivity)
	var/gas_density = air.total_moles/air.volume
	thermal_conductivity *= min(gas_density / ( RADIATOR_OPTIMUM_PRESSURE/(R_IDEAL_GAS_EQUATION*GAS_CRITICAL_TEMPERATURE) ), 1) //mult by density ratio

	var/heat_gain = get_thermal_radiation(air.temperature, surface, RADIATOR_EXPOSED_SURFACE_AREA_RATIO, thermal_conductivity)

	air.add_thermal_energy(heat_gain)
	if(network)
		network.update = 1

//Returns the amount of heat gained while in space due to thermal radiation (usually a negative value)
//surface - the surface area in m^2
//exposed_surface_ratio - the proportion of the surface that is exposed to sunlight
//thermal_conductivity - a multipler on the heat transfer rate. See OPEN_HEAT_TRANSFER_COEFFICIENT and friends
/proc/get_thermal_radiation(var/surface_temperature, var/surface, var/exposed_surface_ratio, var/thermal_conductivity)
	//*** Gain heat from sunlight, then lose heat from radiation.

	// We only get heat from the star on the exposed surface area.
	// If the HE pipes gain more energy from AVERAGE_SOLAR_RADIATION than they can radiate, then they have a net heat increase.
	. = AVERAGE_SOLAR_RADIATION * (exposed_surface_ratio * surface) * thermal_conductivity

	// Previously, the temperature would enter equilibrium at 26C or 294K.
	// Only would happen if both sides (all 2 square meters of surface area) were exposed to sunlight.  We now assume it aligned edge on.
	// It currently should stabilise at 129.6K or -143.6C
	. -= surface * STEFAN_BOLTZMANN_CONSTANT * thermal_conductivity * (surface_temperature - COSMIC_RADIATION_TEMPERATURE) ** 4

#undef REAGENT_UNITS_PER_PIPE