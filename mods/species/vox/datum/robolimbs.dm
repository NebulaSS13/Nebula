/decl/prosthetics_manufacturer/vox
	name = "Arkmade"
	icon = 'mods/species/vox/icons/body/primalis_cyberlimbs.dmi'
	allowed_bodytypes = list(BODYTYPE_VOX)
	species_restricted = list(SPECIES_VOX)

/decl/prosthetics_manufacturer/vox/crap
	name = "Improvised"
	icon = 'mods/species/vox/icons/body/improvised_cyberlimbs.dmi'

DEFINE_ROBOLIMB_MODEL_ASPECTS_WITH_SPECIES_BODYTYPE(/decl/prosthetics_manufacturer/vox, arkmade, 2, SPECIES_VOX, BODYTYPE_VOX)
