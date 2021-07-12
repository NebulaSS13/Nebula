#define FUSION_PROCESSING_TIME_MULT 2 // SSmachines.wait / (1 SECOND) - previous values were intended for SSobj 1-second wait.

/decl/fusion_reaction
	var/p_react // Primary reactant.
	var/s_react // Secondary reactant.
	var/minimum_energy_level = 1
	var/energy_consumption = 0
	var/energy_production = 0
	var/radiation = 0
	var/instability = 0
	var/list/products = list()
	var/minimum_reaction_temperature = 100
	var/priority = 100
	var/hidden_from_codex = FALSE

/decl/fusion_reaction/proc/handle_reaction_special(var/obj/effect/fusion_em_field/holder)
	return 0

// Basic power production reactions.
// This is not necessarily realistic, but it makes a basic failure more spectacular.
//Proton-Proton chain things below.
/decl/fusion_reaction/deuterium_deuterium
	p_react = /decl/material/gas/hydrogen/deuterium
	s_react = /decl/material/gas/hydrogen/deuterium
	energy_consumption = 1 * FUSION_PROCESSING_TIME_MULT
	energy_production = 1 * FUSION_PROCESSING_TIME_MULT
	radiation = 1 * FUSION_PROCESSING_TIME_MULT
	instability = 1 * FUSION_PROCESSING_TIME_MULT
	products = list(/decl/material/gas/helium = 1)
	priority = 3

/decl/fusion_reaction/deuterium_deuterium_alternate //There are two fusion pathways in D-D fusion - one makes He3, one makes Tritium. That's why this is here.
	p_react = /decl/material/gas/hydrogen/deuterium
	s_react = /decl/material/gas/hydrogen/deuterium
	energy_consumption = 1 * FUSION_PROCESSING_TIME_MULT
	energy_production = 1 * FUSION_PROCESSING_TIME_MULT
	radiation = 1 * FUSION_PROCESSING_TIME_MULT
	instability = 1 * FUSION_PROCESSING_TIME_MULT
	products = list(/decl/material/gas/hydrogen/tritium = 1)
	priority = 3

/decl/fusion_reaction/deuterium_helium
	p_react = /decl/material/gas/hydrogen/deuterium
	s_react = /decl/material/gas/helium
	energy_consumption = 1 * FUSION_PROCESSING_TIME_MULT
	energy_production =  5 * FUSION_PROCESSING_TIME_MULT
	radiation = 2 * FUSION_PROCESSING_TIME_MULT
	instability = 2 * FUSION_PROCESSING_TIME_MULT
	priority = 4

/decl/fusion_reaction/deuterium_tritium
	p_react = /decl/material/gas/hydrogen/deuterium
	s_react = /decl/material/gas/hydrogen/tritium
	energy_consumption = 1 * FUSION_PROCESSING_TIME_MULT
	energy_production =  1 * FUSION_PROCESSING_TIME_MULT
	instability =      0.5 * FUSION_PROCESSING_TIME_MULT
	radiation =          3 * FUSION_PROCESSING_TIME_MULT
	products = list(/decl/material/gas/helium = 1)
	priority = 3

// Unideal/material production reactions
/decl/fusion_reaction/oxygen_oxygen
	p_react = /decl/material/gas/oxygen
	s_react = /decl/material/gas/oxygen
	energy_production =   0
	energy_consumption = 10 * FUSION_PROCESSING_TIME_MULT
	instability =         5 * FUSION_PROCESSING_TIME_MULT
	radiation =           5 * FUSION_PROCESSING_TIME_MULT
	products = list(MAT_SILICON = 1)

/decl/fusion_reaction/iron_iron
	p_react = /decl/material/solid/metal/iron
	s_react = /decl/material/solid/metal/iron
	products = list(/decl/material/solid/metal/silver = 10, /decl/material/solid/metal/gold = 10, /decl/material/solid/metal/platinum = 10) // Not realistic but w/e
	energy_production =   0
	energy_consumption = 10 * FUSION_PROCESSING_TIME_MULT
	instability =         2 * FUSION_PROCESSING_TIME_MULT
	minimum_reaction_temperature = 10000

// VERY UNIDEAL REACTIONS.
/decl/fusion_reaction/helium_supermatter
	p_react = /decl/material/solid/exotic_matter
	s_react = /decl/material/gas/helium
	energy_consumption = 0
	energy_production =  5 * FUSION_PROCESSING_TIME_MULT
	radiation =         40 * FUSION_PROCESSING_TIME_MULT
	instability =       20 * FUSION_PROCESSING_TIME_MULT
	hidden_from_codex = TRUE

/decl/fusion_reaction/helium_supermatter/handle_reaction_special(var/obj/effect/fusion_em_field/holder)
	set waitfor = FALSE
	. = 1
	var/datum/event/wormholes/WM = /datum/event/wormholes
	WM.setup(affected_z_levels = GetConnectedZlevels(holder))
	new WM(new /datum/event_meta(EVENT_LEVEL_MAJOR))

	var/turf/origin = get_turf(holder)
	holder.Rupture()
	qdel(holder)
	var/radiation_level = rand(100, 200)

	// Copied from the SM for proof of concept. //Not any more --Cirra //Use the whole z proc --Leshana
	SSradiation.z_radiate(locate(1, 1, holder.z), radiation_level, 1)

	for(var/mob/living/mob in global.living_mob_list_)
		var/turf/T = get_turf(mob)
		if(T && (holder.z == T.z))
			if(istype(mob, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = mob
				H.set_hallucination(rand(100,150), 51)

	for(var/obj/machinery/fusion_fuel_injector/I in range(world.view, origin))
		if(I.cur_assembly && I.cur_assembly.material && I.cur_assembly.material.type == /decl/material/solid/exotic_matter)
			explosion(get_turf(I), 1, 2, 3)
			if(!QDELETED(I))
				QDEL_IN(I, 5)

	sleep(5)
	explosion(origin, 1, 2, 5)

// High end reactions.
/decl/fusion_reaction/boron_hydrogen
	p_react = /decl/material/solid/boron
	s_react = /decl/material/gas/hydrogen
	minimum_energy_level = FUSION_HEAT_CAP * 0.5
	energy_consumption = 3 * FUSION_PROCESSING_TIME_MULT
	energy_production = 15 * FUSION_PROCESSING_TIME_MULT
	radiation =          3 * FUSION_PROCESSING_TIME_MULT
	instability =        3 * FUSION_PROCESSING_TIME_MULT

#undef FUSION_PROCESSING_TIME_MULT
