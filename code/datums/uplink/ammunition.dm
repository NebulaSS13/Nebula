/*************
* Ammunition *
*************/
/datum/uplink_item/item/ammo
	item_cost = 4
	category = /datum/uplink_category/ammunition

/datum/uplink_item/item/ammo/holdout
	name = "Small Magazine"
	desc = "A magazine for small pistols. Contains 8 rounds."
	item_cost = 3
	path = /obj/item/ammo_magazine/pistol/small

/datum/uplink_item/item/ammo/empslug
	name = "Haywire Slug"
	desc = "Single 12-gauge shotgun slug fitted with a single-use ion pulse generator"
	item_cost = 1
	path = /obj/item/ammo_casing/shotgun/emp

/datum/uplink_item/item/ammo/darts
	name = "Dart Cartridge"
	desc = "A small cartridge for a gas-powered dart gun. Contains 5 hollow darts."
	path = /obj/item/ammo_magazine/chemdart

/datum/uplink_item/item/ammo/speedloader
	name = "Standard Speedloader"
	desc = "A speedloader for standard revolvers. Contains 6 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/speedloader

/datum/uplink_item/item/ammo/rifle
	name = "Rifle Magazine"
	desc = "A magazine for assault rifles. Contains 20 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/rifle

/datum/uplink_item/item/ammo/sniperammo
	name = "Ammobox of Sniper Rounds"
	desc = "A container of rounds for the anti-materiel rifle. Contains 7 rounds."
	item_cost = 8
	path = /obj/item/storage/box/ammo/sniperammo
	antag_roles = list(/decl/special_role/mercenary)

/datum/uplink_item/item/ammo/shotgun_shells
	name = "Ammobox of Shotgun Shells"
	desc = "An ammobox with 2 sets of shell holders. Contains 8 buckshot shells total."
	item_cost = 8
	path = /obj/item/storage/box/ammo/shotgunshells

/datum/uplink_item/item/ammo/shotgun_slugs
	name = "Ammobox of Shotgun Slugs"
	desc = "An ammobox with 2 sets of shell holders. Contains 8 slugs total."
	item_cost = 8
	path = /obj/item/storage/box/ammo/shotgunammo

/datum/uplink_item/item/ammo/smg
	name = "Standard Box Magazine"
	desc = "A magazine for standard SMGs. Contains 20 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/smg
	antag_roles = list(/decl/special_role/mercenary)

/datum/uplink_item/item/ammo/speedloader_magnum
	name = "Magnum Speedloader"
	desc = "A speedloader for magnum revolvers. Contains 6 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/speedloader

/datum/uplink_item/item/ammo/flechette
	name = "Flechette Rifle Magazine"
	desc = "A rifle magazine loaded with flechette rounds. Contains 9 rounds."
	item_cost = 8
	path = /obj/item/magnetic_ammo
	antag_roles = list(/decl/special_role/mercenary)
/*
/datum/uplink_item/item/ammo/pistol_emp
	name = "Standard EMP Ammo Box"
	desc = "A box of EMP ammo for standard pistols. Contains 15 rounds."
	item_cost = 8
	path = /obj/item/ammo_magazine/box/emp/pistol

/datum/uplink_item/item/ammo/holdout_emp
	name = "Small EMP Ammo Box"
	desc = "A box of EMP ammo for small pistols and revolvers. Contains 8 rounds."
	item_cost = 6
	path = /obj/item/ammo_magazine/box/emp/smallpistol
*/