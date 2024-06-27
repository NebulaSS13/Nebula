/// Plant is bioluminescent.
/decl/plant_trait/biolum
	name = "bioluminescence"
	shows_extended_data = TRUE

/decl/plant_trait/biolum/get_extended_data(val, datum/seed/grown_seed)
	if(val)
		return "It is [grown_seed?.get_trait(TRAIT_BIOLUM_COLOUR)  ? "<font color='[grown_seed.get_trait(TRAIT_BIOLUM_COLOUR)]'>bio-luminescent</font>" : "bio-luminescent"]."
