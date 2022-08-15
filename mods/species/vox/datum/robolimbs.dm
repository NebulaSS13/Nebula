
/decl/bodytype/prosthetic/Initialize()
	. = ..()
	if(!is_abstract())
		LAZYDISTINCTADD(bodytypes_cannot_use, BODYTYPE_VOX)

/decl/bodytype/prosthetic/vox
	name = "Arkmade"
	icon = 'mods/species/vox/icons/body/primalis_cyberlimbs.dmi'

/decl/bodytype/prosthetic/vox/Initialize()
	. = ..()
	bodytypes_cannot_use = null
	allowed_bodytypes = list(BODYTYPE_VOX)

/decl/bodytype/prosthetic/vox/crap
	name = "Improvised"
	icon = 'mods/species/vox/icons/body/improvised_cyberlimbs.dmi'
