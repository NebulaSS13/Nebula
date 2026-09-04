/decl/trait/build_references()
	. = ..()
	LAZYINITLIST(blocked_species)
	blocked_species |= /decl/species/mantid::uid
	blocked_species |= /decl/species/mantid/gyne::uid

/decl/trait/ascent
	abstract_type = /decl/trait/ascent

/decl/trait/ascent/build_references()
	. = ..()
	blocked_species = null
	permitted_species = list(
		/decl/species/mantid::uid,
		/decl/species/mantid/gyne::uid
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
