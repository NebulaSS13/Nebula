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
