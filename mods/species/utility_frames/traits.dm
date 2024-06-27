/decl/trait/build_references()
	. = ..()
	LAZYDISTINCTADD(blocked_species, SPECIES_FRAME)

/decl/trait/utility_frame
	abstract_type = /decl/trait/utility_frame

/decl/trait/utility_frame/build_references()
	. = ..()
	blocked_species = null
	permitted_species = list(SPECIES_FRAME)

// Cosmetic/armour changes, different models of limb
/decl/trait/utility_frame/customisation
	name = "Heavy Frame"
	description = "Coming soon!"
	category = "Frame Customisation"

// Additional augments, organs, better armour, robomodules
/decl/trait/utility_frame/upgrade
	name = "Upgraded Widget"
	description = "Coming soon!"
	category = "Upgrades"

// Various maluses
/decl/trait/utility_frame/fault
	name = "Faulty Widget"
	description = "Coming soon!"
	category = "Faults"
