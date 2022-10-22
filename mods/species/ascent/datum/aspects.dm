/decl/aspect/build_references()
	. = ..()
	LAZYDISTINCTADD(blocked_species, list(
		SPECIES_SERPENTID,
		SPECIES_MANTID_ALATE,
		SPECIES_MANTID_GYNE,
		SPECIES_MANTID_NYMPH
	))

/decl/aspect/ascent/build_references()
	. = ..()
	blocked_species = null
	permitted_species = list(
		SPECIES_SERPENTID,
		SPECIES_MANTID_ALATE,
		SPECIES_MANTID_GYNE,
		SPECIES_MANTID_NYMPH
	)

// Modifies the exosuit that you spawn with.
/decl/aspect/ascent/suit_upgrade
	name = "Upgraded Support Systems"
	desc = "Coming soon!"
	category = "Suit Upgrades"

// Physical modifications like extra organs or different resistances.
/decl/aspect/ascent/adaptation
	name = "Specialized Molt"
	desc = "Coming soon!"
	category = "Adaptations"

// Behavioral compulsions enforced by AI
/decl/aspect/ascent/derangement
	name = "Megalomania"
	desc = "Coming soon!"
	category = "Derangements"
