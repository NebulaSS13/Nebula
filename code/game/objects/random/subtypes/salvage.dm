/obj/random/scrapped_gun
	name = "random scrapped gun"
	icon = /obj/item/gun/projectile/automatic/assault_rifle::icon
	icon_state = /obj/item/gun/projectile/automatic/assault_rifle::icon_state

/obj/random/scrapped_gun/spawn_choices()
	var/static/list/spawn_choices = list(
		/obj/random/scrapped_pistol          = 10,
		/obj/random/scrapped_smg             = 5,
		/obj/random/scrapped_laser           = 5,
		/obj/random/scrapped_shotgun         = 3,
		/obj/random/scrapped_ionrifle        = 3,
		/obj/random/scrapped_assault         = 1,
		/obj/random/scrapped_flechette       = 1,
		/obj/random/scrapped_grenadelauncher = 1,
		/obj/random/scrapped_dartgun         = 1
	)
	return spawn_choices

/obj/random/scrapped_assault
	name = "random scrapped assault rifle"
	icon = /obj/item/gun/projectile/automatic/assault_rifle::icon
	icon_state = /obj/item/gun/projectile/automatic/assault_rifle::icon_state

/obj/random/scrapped_assault/spawn_choices()
	var/static/list/spawn_choices = list(
		/obj/item/salvage/ballistic/assault              = 10,
		/obj/item/gun/projectile/automatic/assault_rifle = 1
	)
	return spawn_choices

/obj/random/scrapped_pistol
	name = "random scrapped pistol"
	icon = /obj/item/gun/projectile/pistol::icon
	icon_state = /obj/item/gun/projectile/pistol::icon_state

/obj/random/scrapped_pistol/spawn_choices()
	var/static/list/spawn_choices = list(
		/obj/item/salvage/ballistic/pistol = 10,
		/obj/item/gun/projectile/pistol    = 1
	)
	return spawn_choices

/obj/random/scrapped_ionrifle
	name = "random scrapped ion rifle"
	icon = /obj/item/gun/energy/ionrifle::icon
	icon_state = /obj/item/gun/energy/ionrifle::icon_state

/obj/random/scrapped_ionrifle/spawn_choices()
	var/static/list/spawn_choices = list(
		/obj/item/salvage/energy/ionrifle = 10,
		/obj/item/gun/energy/ionrifle     = 1
	)
	return spawn_choices

/obj/random/scrapped_grenadelauncher
	name = "random scrapped grenade launcher"
	icon = /obj/item/gun/launcher/grenade::icon
	icon_state = /obj/item/gun/launcher/grenade::icon_state

/obj/random/scrapped_grenadelauncher/spawn_choices()
	var/static/list/spawn_choices = list(
		/obj/item/salvage/launcher/grenade = 10,
		/obj/item/gun/launcher/grenade     = 1
	)
	return spawn_choices

/obj/random/scrapped_laser
	name = "random scrapped laser rifle"
	icon = /obj/item/gun/energy/laser::icon
	icon_state = /obj/item/gun/energy/laser::icon_state

/obj/random/scrapped_laser/spawn_choices()
	var/static/list/spawn_choices = list(
		/obj/item/salvage/energy/laserrifle = 10,
		/obj/item/gun/energy/laser          = 1
	)
	return spawn_choices

/obj/random/scrapped_smg
	name = "random scrapped submachine gun"
	icon = /obj/item/gun/projectile/automatic/smg::icon
	icon_state = /obj/item/gun/projectile/automatic/smg::icon_state

/obj/random/scrapped_smg/spawn_choices()
	var/static/list/spawn_choices = list(
		/obj/item/salvage/ballistic/smg        = 10,
		/obj/item/gun/projectile/automatic/smg = 1
	)
	return spawn_choices

/obj/random/scrapped_shotgun
	name = "random scrapped shotgun"
	icon = /obj/item/gun/projectile/shotgun/pump::icon
	icon_state = /obj/item/gun/projectile/shotgun/pump::icon_state

/obj/random/scrapped_shotgun/spawn_choices()
	var/static/list/spawn_choices = list(
		/obj/item/salvage/ballistic/shotgun_pump         = 10,
		/obj/item/salvage/ballistic/shotgun_doublebarrel = 10,
		/obj/item/gun/projectile/shotgun/pump            = 1,
		/obj/item/gun/projectile/shotgun/doublebarrel    = 1
	)
	return spawn_choices

/obj/random/scrapped_dartgun
	name = "random scrapped dartgun"
	icon = /obj/item/gun/projectile/dartgun::icon
	icon_state = /obj/item/gun/projectile/dartgun::icon_state

/obj/random/scrapped_dartgun/spawn_choices()
	var/static/list/spawn_choices = list(
		/obj/item/salvage/launcher/dartgun = 10,
		/obj/item/gun/projectile/dartgun = 1
	)
	return spawn_choices

/obj/random/scrapped_flechette
	name = "random scrapped flechette rifle"
	icon = /obj/item/gun/magnetic/railgun/flechette::icon
	icon_state = /obj/item/gun/magnetic/railgun/flechette::icon_state

/obj/random/scrapped_flechette/spawn_choices()
	var/static/list/spawn_choices = list(
		/obj/item/salvage/magnetic/flechette     = 10,
		/obj/item/gun/magnetic/railgun/flechette = 1
	)
	return spawn_choices
