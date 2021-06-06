/datum/extension/ship_engine/gas/fusion
	engine_type = "direct fusion drive"
	expected_type = /obj/machinery/atmospherics/unary/engine/fusion
	volume_per_burn = 100
	charge_per_burn = 8000
	boot_time = 30 SECONDS

/datum/extension/ship_engine/gas/fusion/burn(var/partial = 1)
	var/obj/machinery/atmospherics/unary/engine/E = holder
	if(!is_on())
		return FALSE
	if(!has_fuel() || (0 < E.use_power_oneoff(charge_per_burn)) || check_blockage())
		E.update_use_power(POWER_USE_OFF)
		E.audible_message(src, SPAN_WARNING("[holder] buzzes twice."))
		playsound(E.loc, 'sound/machines/buzz-two.ogg', 40)
		return FALSE

	var/datum/gas_mixture/removed = get_propellant(FALSE, partial)
	if(!removed)
		return FALSE
	. = get_exhaust_velocity(removed)
	playsound(E.loc, 'sound/machines/thruster.ogg', 300 * thrust_limit * partial, 0, world.view * 6, 0.6)
	E.update_networks()
	E.update_icon()

	var/exhaust_dir = global.reverse_dir[E.dir]
	var/turf/T = get_step(holder, exhaust_dir)
	if(T)
		T.assume_air(removed)
		new/obj/effect/engine_exhaust(T, E.dir)

//Essentialy: simplified fusion.

/datum/extension/ship_engine/gas/fusion/get_propellant(var/sample_only = TRUE, var/partial = 1)
	var/obj/machinery/atmospherics/unary/engine/E = holder
	var/datum/gas_mixture/removed = E.air_contents.remove_ratio((volume_per_burn * thrust_limit * partial) / E.air_contents.volume)
	if(!removed) return
	var/datum/gas_mixture/sample = new(removed.volume)
	sample.copy_from(removed)

//Full simulation of fusion reaction if we're only sampling is bad, methink. Maybe change this?

	var/list/fusion_guys = list() //Make a list of gas we will work with
	for(var/fusion in sample.gas)
		if(sample.gas[fusion] < 1) continue
		var/decl/material/mat = GET_DECL(fusion)
		if(mat.flags & MAT_FLAG_FUSION_FUEL) 
			fusion_guys += fusion

	var/list/possible_reactions = list()
	for(var/P in fusion_guys)
		for(var/S in fusion_guys)
			var/decl/fusion_reaction/cur_reaction = SSmaterials.get_fusion_reaction(P, S)
			if(cur_reaction) 
				LAZYDISTINCTADD(possible_reactions, cur_reaction)
	sortTim(possible_reactions, /proc/cmp_fusion_reaction_des)

	while(possible_reactions.len)
		var/decl/fusion_reaction/in_progress = possible_reactions[1]
		if(in_progress.minimum_reaction_temperature > 300 || in_progress.minimum_reaction_temperature > sample.temperature)
			continue //Not enough heat to start the reaction
		var/particles = sample.gas[in_progress.p_react] > sample.gas[in_progress.s_react] ? \
		sample.gas[in_progress.s_react] : sample.gas[in_progress.p_react]
		sample.temperature += particles * in_progress.energy_production * 40
		//This magic "fifty" above is taken directly from rust code as constant for particles/mole multiplied by 4 (four) to make it more efficient
		sample.gas[in_progress.p_react] = 0 //remove everything, cuz everything reacted
		sample.gas[in_progress.s_react] = 0
		for(var/product in in_progress.products)
			sample.adjust_gas(product, particles)
		possible_reactions.Remove(in_progress)

	if(sample_only)
		E.air_contents.merge(removed)
		return sample

	return sample