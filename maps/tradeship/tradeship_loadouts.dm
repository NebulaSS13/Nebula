/datum/gear/utility/guns
	display_name = "guns"
	cost = 4
	sort_category = "Utility"
	path = /obj/item/gun/hand/pistol/holdout

/datum/gear/utility/guns/New()
	..()
	var/guns = list()
	guns["holdout pistol"] = /obj/item/gun/hand/pistol/holdout
	gear_tweaks += new/datum/gear_tweak/path(guns)
