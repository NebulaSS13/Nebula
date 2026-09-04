/decl/modpack/random_species
	name = "Random Alien Species"

/decl/modpack/random_species/initialize()
	. = ..()
	SSmodpacks.default_submap_blacklisted_species += /decl/species/alium::uid
