//Pump Shotguns
//Here's the deal;

//Trench shotgun is deadly at close range but falls off quickly
//Hunting shotgun is deadly at longer ranges, but has less capacity
//Leveractions are less deadly at both but can fit into your bag. Also shakes your screen more

/obj/item/gun/projectile/shotgun/pump/trench
	name = "trench shotgun"
	desc = "A shotgun found in the hands of the NCR."
	icon = 'mods/content/fallout/guns/icons/shotgun/trench.dmi'
	max_shells = 6
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	screen_shake = 0.2
	accuracy = -2
	accuracy_power = 10

//Hunting Shotgun
/obj/item/gun/projectile/shotgun/pump/hunting
	name = "hunting shotgun"
	desc = "A 5 capacity shotgun found in the wastes."
	icon = 'mods/content/fallout/guns/icons/shotgun/huntingshotgun.dmi'
	max_shells = 4
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	screen_shake = 0.1
	accuracy = 0
	accuracy_power = 3

//Lever action
/obj/item/gun/projectile/shotgun/pump/leveraction
	name = "Lever-action shotgun"
	desc = "A high capacity shotgun with very poor accuracy."
	icon = 'mods/content/fallout/guns/icons/shotgun/leveraction.dmi'
	max_shells = 8
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	screen_shake = 0.2
	accuracy = -3
	accuracy_power = 10


//The widowmaker mirrors the trench shottie
/obj/item/gun/projectile/shotgun/doublebarrel/widowmaker
	name = "winchester widowmaker"
	desc = "A standard double barreled shotgun"
	icon = 'mods/content/fallout/guns/icons/shotgun/widowmaker.dmi'
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	screen_shake = 0.2
	accuracy = -2
	accuracy_power = 10

//And the caravan shotgun mirrors the hunting
/obj/item/gun/projectile/shotgun/doublebarrel/caravan
	name = "caravan shotgun"
	desc = "A standard double barreled shotgun"
	icon = 'mods/content/fallout/guns/icons/shotgun/caravanshotgun.dmi'
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	screen_shake = 0.1
	accuracy = 0
	accuracy_power = 3
