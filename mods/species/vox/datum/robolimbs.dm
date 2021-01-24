
/datum/robolimb/New()
	..()
	LAZYDISTINCTADD(bodytypes_cannot_use, BODYTYPE_VOX)

/datum/robolimb/vox
	company = "Arkmade"
	icon = 'mods/species/vox/icons/body/primalis_cyberlimbs.dmi'

/datum/robolimb/vox/New()
	..()
	bodytypes_cannot_use = null
	allowed_bodytypes = list(BODYTYPE_VOX)

/datum/robolimb/vox/crap
	company = "Improvised"
	icon = 'mods/species/vox/icons/body/improvised_cyberlimbs.dmi'
