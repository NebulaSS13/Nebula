#define isslime(X) istype(X, /mob/living/slime)

/decl/modpack/xenobiology
	name = "Xenobiology"

/decl/modpack/xenobiology/initialize()
	. = ..()
	SSmodpacks.default_submap_blacklisted_species += /decl/species/golem::uid
