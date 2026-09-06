/decl/trait/build_references()
	. = ..()
	LAZYDISTINCTADD(blocked_species, /decl/species/vox::uid)

/decl/trait/vox
	abstract_type = /decl/trait/vox

/decl/trait/vox/build_references()
	. = ..()
	blocked_species = null
	permitted_species = list(/decl/species/vox::uid)

// Bonuses or maluses to skills/checks/actions.
/decl/trait/vox/psyche
	name = "Apex-Edited"
	description = "Coming soon!"
	category = "Psyche"

// Perks for interacting with vox equipment.
/decl/trait/vox/symbiosis
	name = "Self-Maintaining Equipment"
	description = "Coming soon!"
	category = "Symbiosis"
