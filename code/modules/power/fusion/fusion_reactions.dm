#define FUSION_PROCESSING_TIME_MULT 2 // SSmachines.wait / (1 SECOND) - previous values were intended for SSobj 1-second wait.

/decl/chemical_reaction/fusion
	codex_category = "fusion reaction"
	minimum_temperature = 1000
	thermal_product = 0
	result_amount = 1
	abstract_type = /decl/chemical_reaction/fusion

	var/energy_consumption = 0
	var/radiation = 0
	var/instability = 0

/decl/chemical_reaction/fusion/Initialize()
	. = ..()
	if(!is_abstract())
		mechanics_text = "This reaction consumes [energy_consumption] heat unit\s and produces [thermal_product] heat unit\s.<br>The process has an instability rating of [instability] and a radiation rating of [radiation]."

/decl/chemical_reaction/fusion/can_happen(var/datum/reagents/holder)
	return istype(holder?.get_reaction_loc(), /obj/effect/fusion_em_field) && ..()

/decl/chemical_reaction/fusion/on_reaction(datum/reagents/holder, created_volume, reaction_flags)
	. = ..()
	var/obj/effect/fusion_em_field/container = holder.get_reaction_loc()
	if(istype(container))
		container.temperature += thermal_product * created_volume

/decl/chemical_reaction/fusion/post_reaction(var/datum/reagents/holder, var/reacted_amount)
	var/obj/effect/fusion_em_field/container = holder.get_reaction_loc()
	if(istype(container))
		container.temperature -=      energy_consumption * reacted_amount // Remove the consumed energy.
		container.radiation +=        radiation          * reacted_amount // Add any produced radiation.
		container.tick_instability += instability        * reacted_amount // Perturb the field

// Basic power production reactions.
// This is not necessarily realistic, but it makes a basic failure more spectacular.
//Proton-Proton chain things below.
/decl/chemical_reaction/fusion/deuterium_deuterium
	name = "deuterium-deuterium"
	required_reagents = list(/decl/material/gas/hydrogen/deuterium = 2)
	energy_consumption = 1 * FUSION_PROCESSING_TIME_MULT
	thermal_product =    1 * FUSION_PROCESSING_TIME_MULT
	radiation =          1 * FUSION_PROCESSING_TIME_MULT
	instability =        1 * FUSION_PROCESSING_TIME_MULT
	result = /decl/material/gas/helium
	inhibitors = list(
		/decl/material/solid/lithium = 1,
		/decl/material/gas/helium = 1,
		/decl/material/gas/hydrogen/tritium = 1
	)
	priority = 3

/decl/chemical_reaction/fusion/deuterium_lithium // placeholder nonsense
	name = "deuterium-lithium"
	required_reagents = list(
		/decl/material/gas/hydrogen/deuterium = 1,
		/decl/material/solid/lithium = 1
	)
	energy_consumption = 1 * FUSION_PROCESSING_TIME_MULT
	thermal_product =    1 * FUSION_PROCESSING_TIME_MULT
	radiation =          1 * FUSION_PROCESSING_TIME_MULT
	instability =        1 * FUSION_PROCESSING_TIME_MULT
	result = /decl/material/gas/hydrogen/tritium
	priority = 3

/decl/chemical_reaction/fusion/deuterium_helium
	name = "deuterium-helium"
	required_reagents = list(
		/decl/material/gas/hydrogen/deuterium = 1,
		/decl/material/gas/helium = 1
	)
	energy_consumption = 1 * FUSION_PROCESSING_TIME_MULT
	thermal_product =    5 * FUSION_PROCESSING_TIME_MULT
	radiation =          2 * FUSION_PROCESSING_TIME_MULT
	instability =        2 * FUSION_PROCESSING_TIME_MULT
	priority = 4

/decl/chemical_reaction/fusion/deuterium_tritium
	name = "deuterium-tritium"
	required_reagents = list(
		/decl/material/gas/hydrogen/deuterium = 1,
		/decl/material/gas/hydrogen/tritium = 1
	)
	energy_consumption = 1 * FUSION_PROCESSING_TIME_MULT
	thermal_product =    1 * FUSION_PROCESSING_TIME_MULT
	instability =      0.5 * FUSION_PROCESSING_TIME_MULT
	radiation =          3 * FUSION_PROCESSING_TIME_MULT
	result = /decl/material/gas/helium
	priority = 3

// Unideal/material production reactions
/decl/chemical_reaction/fusion/oxygen_oxygen
	name = "oxygen-oxygen"
	required_reagents = list(/decl/material/gas/oxygen = 2)
	thermal_product =   0
	energy_consumption = 10 * FUSION_PROCESSING_TIME_MULT
	instability =         5 * FUSION_PROCESSING_TIME_MULT
	radiation =           5 * FUSION_PROCESSING_TIME_MULT
	result = /decl/material/solid/silicon

/decl/chemical_reaction/fusion/iron_iron
	name = "iron-iron"
	required_reagents = list(/decl/material/solid/metal/iron = 2)
	result = /decl/material/solid/metal/platinum
	result_amount = 10
	thermal_product = 0
	energy_consumption = 10 * FUSION_PROCESSING_TIME_MULT
	instability =         2 * FUSION_PROCESSING_TIME_MULT
	minimum_temperature = 10000

// VERY UNIDEAL REACTIONS.
/decl/chemical_reaction/fusion/helium_supermatter
	name = "portal storm"
	required_reagents = list(
		/decl/material/solid/exotic_matter = 1,
		/decl/material/gas/helium = 1
	)
	energy_consumption = 0
	thermal_product =    5 * FUSION_PROCESSING_TIME_MULT
	radiation =         40 * FUSION_PROCESSING_TIME_MULT
	instability =       20 * FUSION_PROCESSING_TIME_MULT
	hidden_from_codex = TRUE

/decl/chemical_reaction/fusion/helium_supermatter/post_reaction(var/datum/reagents/holder, var/reacted_amount)
	..()
	addtimer(CALLBACK(src, .proc/portal_storm, holder.my_atom, reacted_amount), 0)

/decl/chemical_reaction/fusion/helium_supermatter/proc/portal_storm(var/obj/effect/fusion_em_field/field, var/reacted_amount)
	set waitfor = FALSE
	var/datum/event/wormholes/WM = /datum/event/wormholes
	WM.setup(affected_z_levels = GetConnectedZlevels(field))
	new WM(new /datum/event_meta(EVENT_LEVEL_MAJOR))

	var/turf/origin = get_turf(field)
	field.Rupture()
	qdel(field)
	var/radiation_level = rand(100, 200)

	// Copied from the SM for proof of concept. //Not any more --Cirra //Use the whole z proc --Leshana
	SSradiation.z_radiate(locate(1, 1, field.z), radiation_level, 1)

	for(var/mob/living/mob in global.living_mob_list_)
		var/turf/T = get_turf(mob)
		if(T && (field.z == T.z))
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
/decl/chemical_reaction/fusion/boron_hydrogen
	name = "boron-hydrogen"
	required_reagents = list(
		/decl/material/solid/boron = 1,
		/decl/material/gas/hydrogen = 1
	)
	minimum_temperature =    FUSION_HEAT_CAP * 0.5
	energy_consumption = 3 * FUSION_PROCESSING_TIME_MULT
	thermal_product =   15 * FUSION_PROCESSING_TIME_MULT
	radiation =          3 * FUSION_PROCESSING_TIME_MULT
	instability =        3 * FUSION_PROCESSING_TIME_MULT

#undef FUSION_PROCESSING_TIME_MULT
