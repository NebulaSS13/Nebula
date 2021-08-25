/decl/aspect/Initialize()
	. = ..()
	LAZYDISTINCTADD(blocked_species, SPECIES_FRAME)

/decl/aspect/utility_frame/Initialize()
	. = ..()
	blocked_species = global.all_species.Copy()
	blocked_species -= SPECIES_FRAME

// Cosmetic/armour changes, different models of limb
/decl/aspect/utility_frame/customisation
	name = "Heavy Frame"
	desc = "Coming soon!"
	category = "Frame Customisation"

// Additional augments, organs, better armour, robomodules
/decl/aspect/utility_frame/upgrade
	name = "Upgraded Widget"
	desc = "Coming soon!"
	category = "Upgrades"

// Various maluses
/decl/aspect/utility_frame/fault
	name = "Faulty Widget"
	desc = "Coming soon!"
	category = "Faults"
