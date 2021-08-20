/decl/aspect/Initialize()
	. = ..()
	LAZYINITLIST(blocked_species)
	blocked_species |= SPECIES_VOX

/decl/aspect/vox/Initialize()
	. = ..()
	blocked_species = global.all_species.Copy()
	blocked_species -= SPECIES_VOX

// Modified organs/bodyparts.
/decl/aspect/vox/form
	name = "Specialized Form"
	desc = "Coming soon!"
	category = "Voxform"

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
