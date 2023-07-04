////////////////////////////////////////////////////////////////////////
// Pre-Defined Planet Flora
////////////////////////////////////////////////////////////////////////

///Contains data about the flora found on a planetoid, and facilities to pick and spawn them randomly.
/// This base type is meant to be used on its own only for fixed flora lists defined at compile time.
/datum/planet_flora
	/// Seeds of 'small' flora at runtime. At definition is a list of /datum/seed types or plant names.
	var/list/small_flora_types
	/// Seeds of tree-tier flora at runtime. At definition is a list of /datum/seed types or plant names.
	var/list/big_flora_types
	/// Color used for grass floors.
	var/grass_color
	/// Colors allowed for generated flora.
	var/list/plant_colors
	///Gases that plants should never produce during their lives.
	var/list/exuded_gases_exclusions

///Make sure our flora seed lists actually contains valid seeds!
/// Call this after creating the datum to ensure everything is ready!
/datum/planet_flora/proc/setup_flora(var/datum/gas_mixture/atmos)
	if(length(small_flora_types))
		setup_flora_list(atmos, small_flora_types)

	if(length(big_flora_types))
		setup_flora_list(atmos, big_flora_types)

///Go through a flora list and ensure any seed names and seed datum types are properly turned into a seed instance, and carry over any existing seed instances.
/datum/planet_flora/proc/setup_flora_list(var/datum/gas_mixture/atmos, var/list/flora_list)
	var/list/old_flora = flora_list?.Copy()
	if(flora_list)
		flora_list.Cut()
	else
		flora_list = list()

	for(var/flora_type in old_flora)
		if(istext(flora_type))
			ASSERT(SSplants?.initialized)
			var/datum/seed/flora_existing_seed = SSplants.seeds[flora_type]
			if(!flora_existing_seed)
				CRASH("Trying to add non-existant seed named '[flora_type]' to planet flora!")

			var/datum/seed/seedcopy = flora_existing_seed.Clone()
			adapt_seed(seedcopy, atmos)
			//Make sure we got our plant color in the list
			LAZYDISTINCTADD(plant_colors, seedcopy.get_trait(TRAIT_PLANT_COLOUR))
			flora_list += seedcopy

		else if(ispath(flora_type, /datum/seed))
			var/datum/seed/newseed = new flora_type
			adapt_seed(newseed, atmos)
			//Make sure we got our plant color in the list
			LAZYDISTINCTADD(plant_colors, newseed.get_trait(TRAIT_PLANT_COLOUR))
			flora_list += newseed

		else if(istype(flora_type, /datum/seed))
			//We can just move actual datums over without any tampering
			flora_list += flora_type

	return flora_list

//Adapts seeds to this planet's atmopshere. Any special planet-speicific adaptations should go here too
/datum/planet_flora/proc/adapt_seed(var/datum/seed/S, var/datum/gas_mixture/atmos)
	var/expected_pressure = atmos.return_pressure()
	S.set_trait(TRAIT_IDEAL_HEAT,          atmos.temperature + rand(-5,5),800,70)
	S.set_trait(TRAIT_HEAT_TOLERANCE,      S.get_trait(TRAIT_HEAT_TOLERANCE) + rand(-5,5),800,70)
	S.set_trait(TRAIT_LOWKPA_TOLERANCE,    expected_pressure + rand(-5,-50), 80,  0)
	S.set_trait(TRAIT_HIGHKPA_TOLERANCE,   expected_pressure + rand(5,50),   500, 110)

	if(S.exude_gasses)
		S.exude_gasses -= exuded_gases_exclusions
	if(length(atmos.gas))
		if(S.consume_gasses)
			S.consume_gasses = list(pick(atmos.gas)) // ensure that if the plant consumes a gas, the atmosphere will have it
		for(var/g in atmos.gas)
			var/decl/material/mat = GET_DECL(g)
			if(mat.gas_flags & XGM_GAS_CONTAMINANT)
				S.set_trait(TRAIT_TOXINS_TOLERANCE, rand(10,15))
	if(prob(50))
		var/chem_type = SSmaterials.get_random_chem(TRUE, atmos.temperature || T0C)
		if(chem_type)
			var/nutriment = S.chems[/decl/material/liquid/nutriment]
			S.chems.Cut()
			S.chems[/decl/material/liquid/nutriment] = nutriment
			S.chems[chem_type] = list(rand(1,10),rand(10,20))

	return S

///Spawns a randomly chosen small flora from our small flora seed list.
/datum/planet_flora/proc/spawn_random_small_flora(var/turf/T)
	if(LAZYLEN(small_flora_types))
		. = new /obj/structure/flora/plant(T, null, null, pick(small_flora_types))

///Spawns a randomly chosen big flora from our big flora seed list.
/datum/planet_flora/proc/spawn_random_big_flora(var/turf/T)
	if(LAZYLEN(big_flora_types))
		. = new /obj/structure/flora/plant(T, null, null, pick(big_flora_types))


////////////////////////////////////////////////////////////////////////
// Randomly Generated Planet Flora
////////////////////////////////////////////////////////////////////////

///A randomly generating planet_flora data datum
/datum/planet_flora/random
	plant_colors = list("RANDOM")
	/// Max number of different seeds growing here
	var/flora_diversity = 4
	/// If large flora should be generated
	var/has_trees = TRUE


/datum/planet_flora/random/setup_flora(datum/gas_mixture/atmos)
	generate_flora(atmos)
	. = ..()

///Generates a bunch of seeds adapted to the specified climate
/datum/planet_flora/random/proc/generate_flora(var/datum/gas_mixture/atmos)
	if(atmos?.total_moles <= 0)
		return
	if(!grass_color && LAZYLEN(plant_colors))
		var/list/possible_grass = (plant_colors.Copy()  - "RANDOM")
		if(length(possible_grass))
			grass_color = pick(possible_grass)

	generate_small_flora(atmos)
	if(has_trees)
		generate_large_flora(atmos)

/datum/planet_flora/random/proc/generate_small_flora(var/datum/gas_mixture/atmos)
	for(var/i = 1 to flora_diversity)
		var/datum/seed/S = new
		var/planticon    = "alien[rand(1,4)]"
		var/color        = pick(plant_colors)
		var/carnivorous  = prob(10)? 2 : (prob(20)? 1 : 0)
		if(color == "RANDOM")
			color = get_random_colour(0, 75, 190)

		S.randomize(atmos.temperature, atmos.return_pressure())
		S.set_trait(TRAIT_PRODUCT_ICON, planticon)
		S.set_trait(TRAIT_PLANT_ICON,   planticon)
		S.set_trait(TRAIT_PLANT_COLOUR, color)
		S.set_trait(TRAIT_CARNIVOROUS,  carnivorous)
		if(carnivorous == 2)
			S.set_trait(TRAIT_SPREAD,1)

		adapt_seed(S, atmos)
		LAZYADD(small_flora_types, S)

/datum/planet_flora/random/proc/generate_large_flora(var/datum/gas_mixture/atmos)
	var/tree_diversity = max(1, flora_diversity/2)
	for(var/i = 1 to tree_diversity)
		var/datum/seed/S = new
		var/color        = pick(plant_colors)
		if(color == "RANDOM")
			color = get_random_colour(0, 75, 190)

		S.randomize(atmos.temperature, atmos.return_pressure())
		S.set_trait(TRAIT_PRODUCT_ICON,   "alien[rand(1,5)]")
		S.set_trait(TRAIT_PLANT_ICON,     "tree")
		S.set_trait(TRAIT_SPREAD,         0)
		S.set_trait(TRAIT_HARVEST_REPEAT, 1)
		S.set_trait(TRAIT_LARGE,          1)
		S.set_trait(TRAIT_LEAVES_COLOUR,  color)
		S.chems[/decl/material/solid/wood] = 1  //#TODO: Maybe look at Why the seed creates injectable wood?
		adapt_seed(S, atmos)
		LAZYADD(big_flora_types, S)
