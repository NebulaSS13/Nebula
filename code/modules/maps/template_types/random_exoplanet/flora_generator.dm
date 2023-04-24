///A datum for generating a list of random plants fitting a given atmosphere
/datum/flora_generator
	/// Max number of different seeds growing here
	var/flora_diversity = 4
	/// If large flora should be generated
	var/has_trees = TRUE
	/// Seeds of 'small' flora
	var/list/small_flora_types
	/// Seeds of tree-tier flora
	var/list/big_flora_types
	/// Color for generated plants
	var/list/plant_colors  = list("RANDOM")
	/// Color picked for grass floors
	var/grass_color
	///Gases that plants should never produce during their lives.
	var/list/exuded_gases_exclusions

	/// **** Target Atmos Data ****
	///Target temperature
	var/expected_temperature
	///Target pressure
	var/expected_pressure
	///Target atmosphere composition (type = percent)
	var/list/expected_atmosphere_composition

/datum/flora_generator/proc/spawn_random_small_flora(var/turf/T)
	if(LAZYLEN(small_flora_types))
		. = new /obj/structure/flora/plant(T, null, null, pick(small_flora_types))

/datum/flora_generator/proc/spawn_random_big_flora(var/turf/T)
	if(LAZYLEN(big_flora_types))
		. = new /obj/structure/flora/plant(T, null, null, pick(big_flora_types))

///Generates a bunch of seeds adapted to the specified climate
/datum/flora_generator/proc/generate_flora(var/datum/gas_mixture/atmos)
	expected_temperature = atmos?.temperature || T20C
	expected_pressure    = atmos?.return_pressure() || 0
	for(var/gas in atmos.gas)
		LAZYSET(expected_atmosphere_composition, gas, (atmos.gas[gas] * 100) / atmos.total_moles)

	if(!grass_color && LAZYLEN(plant_colors))
		var/list/possible_grass = (plant_colors.Copy()  - "RANDOM")
		if(length(possible_grass))
			grass_color = pick(possible_grass)

	for(var/i = 1 to flora_diversity)
		var/datum/seed/S = new()
		S.randomize(expected_temperature)
		var/planticon = "alien[rand(1,4)]"
		S.set_trait(TRAIT_PRODUCT_ICON,planticon)
		S.set_trait(TRAIT_PLANT_ICON,planticon)
		var/color = pick(plant_colors)
		if(color == "RANDOM")
			color = get_random_colour(0,75,190)
		S.set_trait(TRAIT_PLANT_COLOUR,color)
		var/carnivore_prob = rand(100)
		if(carnivore_prob < 10)
			S.set_trait(TRAIT_CARNIVOROUS,2)
			S.set_trait(TRAIT_SPREAD,1)
		else if(carnivore_prob < 20)
			S.set_trait(TRAIT_CARNIVOROUS,1)
		adapt_seed(S, atmos)
		LAZYADD(small_flora_types, S)
	if(has_trees)
		var/tree_diversity = max(1,flora_diversity/2)
		for(var/i = 1 to tree_diversity)
			var/datum/seed/S = new()
			S.randomize(expected_temperature)
			S.set_trait(TRAIT_PRODUCT_ICON,"alien[rand(1,5)]")
			S.set_trait(TRAIT_PLANT_ICON,"tree")
			S.set_trait(TRAIT_SPREAD,0)
			S.set_trait(TRAIT_HARVEST_REPEAT,1)
			S.set_trait(TRAIT_LARGE,1)
			var/color = pick(plant_colors)
			if(color == "RANDOM")
				color = get_random_colour(0,75,190)
			S.set_trait(TRAIT_LEAVES_COLOUR,color)
			S.chems[/decl/material/solid/wood] = 1
			adapt_seed(S, atmos)
			LAZYADD(big_flora_types, S)

//Adapts seeds to this planet's atmopshere. Any special planet-speicific adaptations should go here too
/datum/flora_generator/proc/adapt_seed(var/datum/seed/S, var/datum/gas_mixture/atmos)
	S.set_trait(TRAIT_IDEAL_HEAT,          expected_temperature + rand(-5,5),800,70)
	S.set_trait(TRAIT_HEAT_TOLERANCE,      S.get_trait(TRAIT_HEAT_TOLERANCE) + rand(-5,5),800,70)
	S.set_trait(TRAIT_LOWKPA_TOLERANCE,    expected_pressure + rand(-5,-50),80,0)
	S.set_trait(TRAIT_HIGHKPA_TOLERANCE,   expected_pressure + rand(5,50),500,110)

	if(S.exude_gasses)
		S.exude_gasses -= exuded_gases_exclusions
	if(length(expected_atmosphere_composition))
		if(S.consume_gasses)
			S.consume_gasses = list(pick(expected_atmosphere_composition)) // ensure that if the plant consumes a gas, the atmosphere will have it
		for(var/g in expected_atmosphere_composition)
			var/decl/material/mat = GET_DECL(g)
			if(mat.gas_flags & XGM_GAS_CONTAMINANT)
				S.set_trait(TRAIT_TOXINS_TOLERANCE, rand(10,15))
	if(prob(50))
		var/chem_type = SSmaterials.get_random_chem(TRUE, expected_temperature || T0C)
		if(chem_type)
			var/nutriment = S.chems[/decl/material/liquid/nutriment]
			S.chems.Cut()
			S.chems[/decl/material/liquid/nutriment] = nutriment
			S.chems[chem_type] = list(rand(1,10),rand(10,20))

