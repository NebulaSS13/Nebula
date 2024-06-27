/decl/trait/build_references()
	. = ..()
	LAZYINITLIST(blocked_species)
	blocked_species |= SPECIES_MANTID_ALATE
	blocked_species |= SPECIES_MANTID_GYNE
	blocked_species |= SPECIES_MANTID_NYMPH

/decl/trait/ascent
	abstract_type = /decl/trait/ascent

/decl/trait/ascent/build_references()
	. = ..()
	blocked_species = null
	permitted_species = list(
		SPECIES_MANTID_ALATE,
		SPECIES_MANTID_GYNE,
		SPECIES_MANTID_NYMPH
	)

// Modifies the exosuit that you spawn with.
/decl/trait/ascent/suit_upgrade
	name = "Upgraded Support Systems"
	description = "Coming soon!"
	category = "Suit Upgrades"

// Physical modifications like extra organs or different resistances.
/decl/trait/ascent/adaptation
	name = "Specialized Molt"
	description = "Coming soon!"
	category = "Adaptations"

// Behavioral compulsions enforced by AI
/decl/trait/ascent/derangement
	name = "Megalomania"
	description = "Coming soon!"
	category = "Derangements"
