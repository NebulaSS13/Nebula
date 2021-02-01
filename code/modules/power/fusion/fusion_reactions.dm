
/decl/fusion_reaction
	var/p_react = "" // Primary reactant.
	var/s_react = "" // Secondary reactant.
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
/decl/fusion_reaction/hydrogen_hydrogen
	p_react = /decl/material/gas/hydrogen
	s_react = /decl/material/gas/hydrogen
	energy_consumption = 1
	energy_production = 2
	products = list(/decl/material/gas/helium = 1)
	priority = 10

/decl/fusion_reaction/deuterium_deuterium
	p_react = /decl/material/gas/hydrogen/deuterium
	s_react = /decl/material/gas/hydrogen/deuterium
	energy_consumption = 1
	energy_production = 2
	priority = 0

// Advanced production reactions (todo)
/decl/fusion_reaction/deuterium_helium
	p_react = /decl/material/gas/hydrogen/deuterium
	s_react = /decl/material/gas/helium
	energy_consumption = 1
	energy_production = 5
	radiation = 2

/decl/fusion_reaction/deuterium_tritium
	p_react = /decl/material/gas/hydrogen/deuterium
	s_react = /decl/material/gas/hydrogen/tritium
	energy_consumption = 1
	energy_production = 1
	products = list(/decl/material/gas/helium = 1)
	instability = 0.5
	radiation = 3

/decl/fusion_reaction/deuterium_lithium
	p_react = /decl/material/gas/hydrogen/deuterium
	s_react = /decl/material/solid/lithium
	energy_consumption = 2
	energy_production = 0
	radiation = 3
	products = list(/decl/material/gas/hydrogen/tritium= 1)
	instability = 1

// Unideal/material production reactions
/decl/fusion_reaction/oxygen_oxygen
	p_react = /decl/material/gas/oxygen
	s_react = /decl/material/gas/oxygen
	energy_consumption = 10
	energy_production = 0
	instability = 5
	radiation = 5
	products = list(MAT_SILICON = 1)

/decl/fusion_reaction/iron_iron
	p_react = /decl/material/solid/metal/iron
	s_react = /decl/material/solid/metal/iron
	products = list(/decl/material/solid/metal/silver = 10, /decl/material/solid/metal/gold = 10, /decl/material/solid/metal/platinum = 10) // Not realistic but w/e
	energy_consumption = 10
	energy_production = 0
	instability = 2
	minimum_reaction_temperature = 10000

// VERY UNIDEAL REACTIONS.
/decl/fusion_reaction/helium_supermatter
	p_react = /decl/material/solid/exotic_matter
	s_react = /decl/material/gas/helium
	energy_consumption = 0
	energy_production = 5
	radiation = 40
	instability = 20
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

	for(var/mob/living/mob in GLOB.living_mob_list_)
		var/turf/T = get_turf(mob)
		if(T && (holder.z == T.z))
			if(istype(mob, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = mob
				H.set_hallucination(rand(100,150), 51)

	for(var/obj/machinery/fusion_fuel_injector/I in range(world.view, origin))
		if(I.cur_assembly && I.cur_assembly.material && I.cur_assembly.material.type == /decl/material/solid/exotic_matter)
			explosion(get_turf(I), 1, 2, 3)
			spawn(5)
				if(I && I.loc)
					qdel(I)

	sleep(5)
	explosion(origin, 1, 2, 5)

// High end reactions.
/decl/fusion_reaction/boron_hydrogen
	p_react = /decl/material/solid/boron
	s_react = /decl/material/gas/hydrogen
	minimum_energy_level = FUSION_HEAT_CAP * 0.5
	energy_consumption = 3
	energy_production = 15
	radiation = 3
	instability = 3
