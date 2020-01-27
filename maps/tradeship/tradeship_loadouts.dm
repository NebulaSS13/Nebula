/datum/gear/utility/guns
	display_name = "guns"
	flags = GEAR_HAS_COLOR_SELECTION
	cost = 4
	sort_category = "Utility"
	path = /obj/item/gun/projectile/

/datum/gear/utility/guns/New()
	..()
	var/guns = list()
	guns["holdout reolver"] = /obj/item/gun/projectile/revolver/holdout
	guns["holdout pistol"] = /obj/item/gun/projectile/pistol/holdout
	guns["pistol"] = /obj/item/gun/projectile/pistol/sec
	gear_tweaks += new/datum/gear_tweak/path(guns)

/datum/gear/head/yinglet_hood
	display_name = "yinglet hood, colour select"
	path = /obj/item/clothing/head/yinglet
	flags = GEAR_HAS_COLOR_SELECTION
	description = "A simple cloth hood with ear-holes. Not suitable for human use."
