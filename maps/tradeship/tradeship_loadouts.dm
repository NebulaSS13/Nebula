/datum/gear/utility/guns
	display_name = "guns"
	cost = 4
	sort_category = "Utility"
	path = /obj/item/gun/pistol/holdout

/datum/gear/utility/guns/New()
	..()
	var/guns = list()
	guns["holdout pistol"] = /obj/item/gun/pistol/holdout
	gear_tweaks += new/datum/gear_tweak/path(guns)
