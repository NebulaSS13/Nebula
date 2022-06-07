/decl/aspect/Initialize()
	. = ..()
	LAZYINITLIST(blocked_species)
	blocked_species |= SPECIES_MANTID_ALATE
	blocked_species |= SPECIES_MANTID_GYNE
	blocked_species |= SPECIES_MANTID_NYMPH

/decl/aspect/ascent/Initialize()
	. = ..()
	blocked_species = global.all_species.Copy()
	blocked_species -= SPECIES_MANTID_ALATE
	blocked_species -= SPECIES_MANTID_GYNE
	blocked_species -= SPECIES_MANTID_NYMPH

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
