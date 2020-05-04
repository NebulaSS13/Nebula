/datum/gear/utility/guns
	display_name = "guns"
	flags = GEAR_HAS_COLOR_SELECTION
	cost = 4
	sort_category = "Utility"
	path = /obj/item/gun/projectile/

/datum/gear/utility/guns/New()
	..()
	var/guns = list()
	guns["holdout pistol"] = /obj/item/gun/projectile/pistol/holdout
	guns["lasvolver"] = /obj/item/gun/projectile/revolver/lasvolver
	guns["pistol"] = /obj/item/gun/projectile/pistol/random
	gear_tweaks += new/datum/gear_tweak/path(guns)