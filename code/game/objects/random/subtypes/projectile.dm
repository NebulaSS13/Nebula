/obj/random/random_projectile
	name = "Random Projectile Weapon"
	desc = "This is a random projectile weapon."
	icon_state = /obj/item/gun/projectile/shotgun/doublebarrel::icon_state
	icon = /obj/item/gun/projectile/shotgun/doublebarrel::icon

/obj/random/random_gun/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/random/handgun = 3,
		/obj/random/smg     = 2,
		/obj/random/shotgun = 2,
		/obj/random/rifle   = 1
	)
	return spawnable_choices

/obj/random/projectile
	name = "Random Projectile Weapon"
	desc = "This is a random projectile weapon."
	icon = /obj/item/gun/projectile/revolver::icon
	icon_state = /obj/item/gun/projectile/revolver::icon_state

/obj/random/projectile/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/gun/projectile/shotgun/pump              = 3,
		/obj/item/gun/projectile/automatic/assault_rifle   = 2,
		/obj/item/gun/projectile/pistol                    = 3,
		/obj/item/gun/projectile/pistol/holdout            = 4,
		/obj/item/gun/projectile/zipgun                    = 5,
		/obj/item/gun/projectile/automatic/smg             = 4,
		/obj/item/gun/projectile/revolver                  = 2,
		/obj/item/gun/projectile/shotgun/doublebarrel      = 4,
		/obj/item/gun/projectile/shotgun/doublebarrel/sawn = 3,
		/obj/item/gun/projectile/bolt_action/sniper        = 1
	)
	return spawnable_choices

/obj/random/sec
	name = "Random Security Weapon"
	desc = "This is a random security projectile weapon."

/obj/random/sec/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/gun/projectile/shotgun/pump         = 3,
		/obj/item/gun/projectile/shotgun/doublebarrel = 2,
		/obj/item/gun/projectile/automatic/smg        = 1
	)
	return spawnable_choices

/obj/random/shotgun
	name = "random shotgun projectile gun"
	desc = "Loot for PoIs."
	icon_state = /obj/item/gun/projectile/shotgun/doublebarrel::icon_state
	icon = /obj/item/gun/projectile/shotgun/doublebarrel::icon

/obj/random/shotgun/spawn_choices()
	var/static/list/spawnable_choices = list(
		list(
			/obj/item/gun/projectile/shotgun/doublebarrel,
			/obj/item/ammo_casing/shotgun/pellet,
			/obj/item/ammo_casing/shotgun/pellet,
			/obj/item/ammo_casing/shotgun/pellet,
			/obj/item/ammo_casing/shotgun/pellet
		) = 4,
		list(
			/obj/item/gun/projectile/shotgun/doublebarrel,
			/obj/item/ammo_casing/shotgun/pellet,
			/obj/item/ammo_casing/shotgun/pellet,
			/obj/item/ammo_casing/shotgun/pellet,
			/obj/item/ammo_casing/shotgun/pellet
		) = 3,
		list(
			/obj/item/gun/projectile/shotgun/pump,
			/obj/item/box/ammo/shotgunammo
		) = 5
	)
	return spawnable_choices

/obj/random/smg
	name = "random smg projectile gun"
	desc = "Loot for PoIs."
	icon_state = /obj/item/gun/projectile/automatic/smg::icon_state
	icon = /obj/item/gun/projectile/automatic/smg::icon

/obj/random/smg/spawn_choices()
	var/static/list/spawnable_choices = list(
		list(
			/obj/item/gun/projectile/automatic/smg,
			/obj/item/ammo_magazine/smg,
			/obj/item/ammo_magazine/smg
		) = 8,
		list(
			/obj/item/gun/projectile/automatic/smg/uzi,
			/obj/item/ammo_magazine/smg,
			/obj/item/ammo_magazine/smg
		) = 5,
		list(
			/obj/item/gun/projectile/automatic/assault_rifle,
			/obj/item/ammo_magazine/rifle,
			/obj/item/ammo_magazine/rifle
		) = 5
	)
	return spawnable_choices

/obj/random/rifle
	name = "random rifle projectile gun"
	desc = "Loot for PoIs."
	icon_state = /obj/item/gun/projectile/bolt_action::icon_state
	icon = /obj/item/gun/projectile/bolt_action::icon

/obj/random/rifle/spawn_choices()
	var/static/list/spawnable_choices = list(
		list(
			/obj/item/gun/projectile/bolt_action,
			/obj/item/ammo_casing/rifle,
			/obj/item/ammo_casing/rifle,
			/obj/item/ammo_casing/rifle,
			/obj/item/ammo_casing/rifle,
			/obj/item/ammo_casing/rifle
		) = 5,
		list(
			/obj/item/gun/projectile/automatic/assault_rifle,
			/obj/item/ammo_magazine/rifle,
			/obj/item/ammo_magazine/rifle
		) = 1,
		/obj/item/secure_storage/briefcase/heavysniper = 1
	)
	return spawnable_choices

/obj/random/pistol
	name = "random handgun projectile gun"
	desc = "Loot for PoIs."
	icon_state = /obj/item/gun/projectile/pistol::icon_state
	icon = /obj/item/gun/projectile/pistol::icon

/obj/random/pistol/spawn_choices()
	var/static/list/spawnable_choices = list(
		list(
			/obj/item/gun/projectile/pistol,
			/obj/item/ammo_magazine/pistol,
			/obj/item/ammo_magazine/pistol
		) = 10,
		list(
			/obj/item/gun/projectile/pistol/holdout,
			/obj/item/ammo_magazine/pistol/small,
			/obj/item/ammo_magazine/pistol/small
		) = 8,
		list(
			/obj/item/gun/projectile/pistol/rubber,
			/obj/item/ammo_magazine/pistol/rubber,
			/obj/item/ammo_magazine/pistol/rubber
		) = 5,
		list(
			/obj/item/gun/projectile/pistol/emp,
			/obj/item/ammo_magazine/pistol/emp,
			/obj/item/ammo_magazine/pistol/emp
		) = 4,
		list(
			/obj/item/gun/projectile/revolver,
			/obj/item/ammo_magazine/speedloader,
			/obj/item/ammo_magazine/speedloader
		) = 4,
		list(
			/obj/item/gun/projectile/revolver/capgun,
			/obj/item/ammo_casing/cap,
			/obj/item/ammo_casing/cap,
			/obj/item/ammo_casing/cap,
			/obj/item/ammo_casing/cap,
			/obj/item/ammo_casing/cap
		) = 2,
		/obj/item/gun/projectile/revolver/stun = 3
	)
	return spawnable_choices

/obj/random/handgun
	name = "Random Handgun"
	desc = "This is a random sidearm."
	icon = /obj/item/gun/projectile/pistol::icon
	icon_state = /obj/item/gun/projectile/pistol::icon_state

/obj/random/handgun/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/gun/projectile/pistol         = 3,
		/obj/item/gun/energy/gun                = 3,
		/obj/item/gun/projectile/pistol/holdout = 2
	)
	return spawnable_choices

/obj/random/shotgun
	name = "Random Shotgun"
	desc = "This is a random shotgun-type weapon."
	icon_state = /obj/item/gun/projectile/shotgun/doublebarrel::icon_state
	icon = /obj/item/gun/projectile/shotgun/doublebarrel::icon

/obj/random/shotgun/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/gun/projectile/shotgun/doublebarrel      = 4,
		/obj/item/gun/projectile/shotgun/doublebarrel/sawn = 3,
		/obj/item/gun/projectile/shotgun/pump              = 3
	)
	return spawnable_choices

/obj/random/sidearm
	name = "Random Sidearm"
	desc = "This is a random one-handed sidearm of any type."
	icon_state = /obj/item/gun/projectile/pistol::icon_state
	icon = /obj/item/gun/projectile/pistol::icon

/obj/random/sidearm/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/random/handgun            = 5,
		/obj/random/revolver           = 5,
		/obj/item/gun/energy/gun/small = 5
	)
	return spawnable_choices

/obj/random/revolver
	name = "Random Revolver"
	desc = "This is a random revolver."
	icon = /obj/item/gun/projectile/revolver::icon
	icon_state = /obj/item/gun/projectile/revolver::icon_state

/obj/random/revolver/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/gun/projectile/revolver                 = 4,
		/obj/item/gun/projectile/revolver/stun            = 3,
		/obj/item/gun/projectile/revolver/capgun          = 2
	)
	return spawnable_choices

/obj/random/ammo
	name = "Random Ammunition"
	desc = "This is random ammunition."
	icon = /obj/item/ammo_magazine::icon
	icon_state = /obj/item/ammo_magazine::icon_state

/obj/random/ammo/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/box/ammo/beanbags        = 6,
		/obj/item/box/ammo/shotgunammo     = 2,
		/obj/item/box/ammo/shotgunshells   = 4,
		/obj/item/box/ammo/stunshells      = 1,
		/obj/item/ammo_magazine/pistol     = 2,
		/obj/item/ammo_magazine/smg        = 2,
		/obj/item/ammo_magazine/smg/rubber = 6
	)
	return spawnable_choices
