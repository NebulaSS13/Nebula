/decl/loadout_option/utility/guns
	name = "guns"
	cost = 4
	path = /obj/item/gun/projectile
	uid = "gear_utility_guns"

/decl/loadout_option/utility/guns/Initialize()
	. = ..()
	var/guns = list()
	guns["holdout pistol"] = /obj/item/gun/projectile/pistol/holdout
	gear_tweaks += new/datum/gear_tweak/path(guns)
