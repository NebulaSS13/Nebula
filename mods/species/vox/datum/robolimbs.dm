
/decl/prosthetics_manufacturer/Initialize()
	. = ..()
	LAZYDISTINCTADD(bodytypes_cannot_use, BODYTYPE_VOX)

/decl/prosthetics_manufacturer/vox
	name = "Arkmade"
	icon = 'mods/species/vox/icons/body/primalis_cyberlimbs.dmi'

/decl/prosthetics_manufacturer/vox/Initialize()
	. = ..()
	bodytypes_cannot_use = null
	allowed_bodytypes = list(BODYTYPE_VOX)

/decl/prosthetics_manufacturer/vox/crap
	name = "Improvised"
	icon = 'mods/species/vox/icons/body/improvised_cyberlimbs.dmi'
