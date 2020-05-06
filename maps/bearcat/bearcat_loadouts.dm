/datum/gear/utility/guns
	display_name = "guns"
	flags = GEAR_HAS_COLOR_SELECTION
	cost = 4
	sort_category = "Utility"
	path = /obj/item/gun/projectile/

/datum/gear/utility/guns/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"holdout pistol" = /obj/item/gun/projectile/pistol/holdout,
		"lasvolver" =      /obj/item/gun/projectile/revolver/lasvolver,
		"pistol" =         /obj/item/gun/projectile/pistol/random
	)