/decl/sprite_accessory/hair/bald/Initialize()
	. = ..()
	LAZYDISTINCTADD(species_allowed, SPECIES_VOX)
	
/decl/sprite_accessory/facial_hair/shaved/Initialize()
	. = ..()
	LAZYDISTINCTADD(species_allowed, SPECIES_VOX)

/decl/sprite_accessory/hair/vox
	name = "Long Vox Quills"
	icon = 'mods/species/vox/icons/body/hair.dmi'
	icon_state = "vox_longquills"
	species_allowed = list(SPECIES_VOX)

/decl/sprite_accessory/hair/vox/short
	name = "Short Vox Quills"
	icon_state = "vox_shortquills"

/decl/sprite_accessory/hair/vox/mohawk
	name = "Vox Mohawk"
	icon_state = "vox_mohawk"

/decl/sprite_accessory/hair/vox/stubble
	name = "Vox Stubble"
	icon_state = "vox_stubble"

/decl/sprite_accessory/marking/vox
	name = "Vox Neck Markings"
	icon_state = "neck_markings"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_VOX)
	icon = 'mods/species/vox/icons/markings.dmi'
	blend = ICON_MULTIPLY

/decl/sprite_accessory/marking/vox/arm_markings
	name = "Vox Arm Markings (Left)"
	icon_state = "arm_markings"
	body_parts = list(BP_L_ARM)

/decl/sprite_accessory/marking/vox/arm_markings/right
	name = "Vox Arm Markings (Right)"
	body_parts = list(BP_R_ARM)

/decl/sprite_accessory/marking/vox/crest
	name = "Vox Crest Colouration"
	icon_state = "crest"
