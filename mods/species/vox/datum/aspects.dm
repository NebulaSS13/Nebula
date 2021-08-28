/decl/aspect/Initialize()
	. = ..()
	LAZYINITLIST(blocked_species)
	blocked_species |= SPECIES_VOX

/decl/aspect/vox/Initialize()
	. = ..()
	blocked_species = global.all_species.Copy()
	blocked_species -= SPECIES_VOX

// Modified organs/bodyparts.
/decl/aspect/prosthetic_limb/vox
	model = /decl/prosthetics_manufacturer/vox/crap
	category = "Voxform"

/decl/aspect/prosthetic_limb/vox/Initialize()
	. = ..()
	blocked_species = global.all_species.Copy()
	blocked_species -= SPECIES_VOX
	
/decl/aspect/prosthetic_limb/vox/left_hand
	bodypart_name = "Left Hand"
	incompatible_with = list(/decl/aspect/prosthetic_limb/vox/left_arm)
	apply_to_limb = BP_L_HAND
	category = "Voxform"

/decl/aspect/prosthetic_limb/vox/left_arm
	bodypart_name = "Left Arm"
	aspect_cost = 2
	apply_to_limb = BP_L_ARM
	incompatible_with = list(/decl/aspect/prosthetic_limb/vox/left_hand)

/decl/aspect/prosthetic_limb/vox/right_hand
	bodypart_name = "Right Hand"
	apply_to_limb = BP_R_HAND
	incompatible_with = list(/decl/aspect/prosthetic_limb/vox/right_arm)

/decl/aspect/prosthetic_limb/vox/right_arm
	bodypart_name = "Right Arm"
	aspect_cost = 2
	apply_to_limb = BP_R_ARM
	incompatible_with = list(/decl/aspect/prosthetic_limb/vox/right_hand)

/decl/aspect/prosthetic_limb/vox/left_foot
	bodypart_name = "Left Foot"
	apply_to_limb = BP_L_FOOT
	incompatible_with = list(/decl/aspect/prosthetic_limb/vox/left_leg)

/decl/aspect/prosthetic_limb/vox/left_leg
	bodypart_name = "Left Leg"
	aspect_cost = 2
	apply_to_limb = BP_L_LEG
	incompatible_with = list(/decl/aspect/prosthetic_limb/vox/left_foot)

/decl/aspect/prosthetic_limb/vox/right_foot
	bodypart_name = "Right Foot"
	apply_to_limb = BP_R_FOOT
	incompatible_with = list(/decl/aspect/prosthetic_limb/vox/right_leg)

/decl/aspect/prosthetic_limb/vox/right_leg
	bodypart_name = "Right Leg"
	aspect_cost = 2
	apply_to_limb = BP_R_LEG
	incompatible_with = list(/decl/aspect/prosthetic_limb/vox/right_foot)



/decl/aspect/prosthetic_limb/vox
	model = /decl/prosthetics_manufacturer/vox/crap
	category = "Voxform"

/decl/aspect/prosthetic_limb/vox/Initialize()
	. = ..()
	blocked_species = global.all_species.Copy()
	blocked_species -= SPECIES_VOX
	
/decl/aspect/prosthetic_limb/vox/left_hand/arkmade
	parent = /decl/aspect/prosthetic_limb/vox/left_hand
	base_type = /decl/aspect/prosthetic_limb/vox/left_hand
	model = /decl/prosthetics_manufacturer/vox
	aspect_cost = 1

/decl/aspect/prosthetic_limb/vox/left_arm/arkmade
	model = /decl/prosthetics_manufacturer/vox
	parent = /decl/aspect/prosthetic_limb/vox/left_arm
	base_type = /decl/aspect/prosthetic_limb/vox/left_arm
	aspect_cost = 1

/decl/aspect/prosthetic_limb/vox/right_hand/arkmade
	parent = /decl/aspect/prosthetic_limb/vox/right_hand
	base_type = /decl/aspect/prosthetic_limb/vox/right_hand
	model = /decl/prosthetics_manufacturer/vox
	aspect_cost = 1

/decl/aspect/prosthetic_limb/vox/right_arm/arkmade
	parent = /decl/aspect/prosthetic_limb/vox/right_arm
	base_type = /decl/aspect/prosthetic_limb/vox/right_arm
	model = /decl/prosthetics_manufacturer/vox
	aspect_cost = 1

/decl/aspect/prosthetic_limb/vox/left_foot/arkmade
	parent = /decl/aspect/prosthetic_limb/vox/left_foot
	base_type = /decl/aspect/prosthetic_limb/vox/left_foot
	model = /decl/prosthetics_manufacturer/vox
	aspect_cost = 1

/decl/aspect/prosthetic_limb/vox/left_leg/arkmade
	parent = /decl/aspect/prosthetic_limb/vox/left_leg
	base_type = /decl/aspect/prosthetic_limb/vox/left_leg
	model = /decl/prosthetics_manufacturer/vox
	aspect_cost = 1

/decl/aspect/prosthetic_limb/vox/right_foot/arkmade
	parent = /decl/aspect/prosthetic_limb/vox/right_foot
	base_type = /decl/aspect/prosthetic_limb/vox/right_foot
	model = /decl/prosthetics_manufacturer/vox
	aspect_cost = 1

/decl/aspect/prosthetic_limb/vox/right_leg/arkmade
	parent = /decl/aspect/prosthetic_limb/vox/right_leg
	base_type = /decl/aspect/prosthetic_limb/vox/right_leg
	model = /decl/prosthetics_manufacturer/vox
	aspect_cost = 1

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
