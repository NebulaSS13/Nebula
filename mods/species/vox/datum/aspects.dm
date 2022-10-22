/decl/aspect/build_references()
	. = ..()
	LAZYDISTINCTADD(blocked_species, SPECIES_VOX)

/decl/aspect/vox/build_references()
	. = ..()
	blocked_species = null
	permitted_species = list(SPECIES_VOX)

// Bonuses or maluses to skills/checks/actions.
/decl/aspect/vox/psyche
	name = "Apex-Edited"
	desc = "Coming soon!"
	category = "Psyche"

// Perks for interacting with vox equipment.
/decl/aspect/vox/symbiosis
	name = "Self-Maintaining Equipment"
	desc = "Coming soon!"
	category = "Symbiosis"
