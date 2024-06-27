/decl/plant_gene/output
	unmasked_name = "output"
	associated_traits = list(
		TRAIT_PRODUCES_POWER,
		TRAIT_BIOLUM
	)

/decl/plant_gene/output/mutate(datum/seed/seed, turf/location)
	if(prob(50))
		seed.set_trait(TRAIT_BIOLUM, !seed.get_trait(TRAIT_BIOLUM))
		if(seed.get_trait(TRAIT_BIOLUM))
			location.visible_message(SPAN_NOTICE("\The [seed.display_name] begins to glow!"))
			if(prob(50))
				seed.set_trait(TRAIT_BIOLUM_COLOUR,get_random_colour(0,75,190))
				location.visible_message(SPAN_NOTICE("\The [seed.display_name]'s glow <font color='[seed.get_trait(TRAIT_BIOLUM_COLOUR)]'>changes colour</font>!"))
			else
				location.visible_message(SPAN_NOTICE("\The [seed.display_name]'s glow dims..."))
	if(prob(60))
		seed.set_trait(TRAIT_PRODUCES_POWER, !seed.get_trait(TRAIT_PRODUCES_POWER))
