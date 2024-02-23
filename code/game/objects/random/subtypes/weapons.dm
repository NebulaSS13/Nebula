/obj/random/energy
	name = "Random Energy Weapon"
	desc = "This is a random energy weapon."
	icon = 'icons/obj/guns/energy_gun.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/energy/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/gun/energy/laser =                  4,
		/obj/item/gun/energy/gun =                    3,
		/obj/item/gun/energy/lasercannon =            2,
		/obj/item/gun/energy/xray =                   3,
		/obj/item/gun/energy/sniperrifle =            1,
		/obj/item/gun/energy/gun/nuclear =            1,
		/obj/item/gun/energy/ionrifle =               2,
		/obj/item/gun/energy/toxgun =                 3,
		/obj/item/gun/energy/taser =                  4,
		/obj/item/gun/energy/crossbow/largecrossbow = 2
	)
	return spawnable_choices

/obj/random/energy/sec
	name = "Random Security Weapon"
	desc = "This is a random energy weapon."

/obj/random/energy/sec/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/gun/energy/laser = 2,
		/obj/item/gun/energy/gun = 2
	)
	return spawnable_choices
/obj/random/projectile
	name = "Random Projectile Weapon"
	desc = "This is a random projectile weapon."
	icon = 'icons/obj/guns/revolvers.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/projectile/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/gun/projectile/shotgun/pump =              3,
		/obj/item/gun/projectile/automatic/assault_rifle =   2,
		/obj/item/gun/projectile/pistol =                    3,
		/obj/item/gun/projectile/pistol/holdout =            4,
		/obj/item/gun/projectile/zipgun =                    5,
		/obj/item/gun/projectile/automatic/smg =             4,
		/obj/item/gun/projectile/revolver =                  2,
		/obj/item/gun/projectile/shotgun/doublebarrel =      4,
		/obj/item/gun/projectile/shotgun/doublebarrel/sawn = 3,
		/obj/item/gun/projectile/bolt_action/sniper =        1
	)
	return spawnable_choices

/obj/random/projectile/sec
	name = "Random Security Weapon"
	desc = "This is a random security projectile weapon."

/obj/random/projectile/sec/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/gun/projectile/shotgun/pump =         3,
		/obj/item/gun/projectile/shotgun/doublebarrel = 2,
		/obj/item/gun/projectile/automatic/smg =        1
	)
	return spawnable_choices

/obj/random/handgun
	name = "Random Handgun"
	desc = "This is a random sidearm."
	icon = 'icons/obj/guns/pistol.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/handgun/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/gun/projectile/pistol =         3,
		/obj/item/gun/energy/gun =                3,
		/obj/item/gun/projectile/pistol/holdout = 2
	)
	return spawnable_choices

/obj/random/ammo
	name = "Random Ammunition"
	desc = "This is random ammunition."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "magnum"

/obj/random/ammo/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/box/ammo/beanbags =      6,
		/obj/item/box/ammo/shotgunammo =   2,
		/obj/item/box/ammo/shotgunshells = 4,
		/obj/item/box/ammo/stunshells =    1,
		/obj/item/ammo_magazine/pistol =           2,
		/obj/item/ammo_magazine/smg =              2,
		/obj/item/ammo_magazine/smg/rubber =       6
	)
	return spawnable_choices
