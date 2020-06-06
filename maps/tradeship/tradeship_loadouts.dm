/datum/gear/utility/guns
	display_name = "guns"
	cost = 4
	sort_category = "Utility"
	path = /obj/item/gun/projectile

/datum/gear/utility/guns/New()
	..()
	var/guns = list()
	guns["holdout pistol"] = /obj/item/gun/projectile/pistol/holdout
	gear_tweaks += new/datum/gear_tweak/path(guns)

/datum/gear/scav_medical_belt/New()
	..()
	LAZYDISTINCTADD(allowed_roles, list(/datum/job/yinglet/patriarch, /datum/job/yinglet/matriarch, /datum/job/tradeship_doctor, /datum/job/tradeship_doctor/head))
