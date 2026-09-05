/obj/random/energy
	name = "Random Energy Weapon"
	desc = "This is a random energy weapon."
	icon = /obj/item/gun/energy/laser::icon
	icon_state = /obj/item/gun/energy/laser::icon_state

/obj/random/energy/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/gun/energy/laser                  = 4,
		/obj/item/gun/energy/gun                    = 3,
		/obj/item/gun/energy/lasercannon            = 2,
		/obj/item/gun/energy/xray                   = 3,
		/obj/item/gun/energy/sniperrifle            = 1,
		/obj/item/gun/energy/gun/nuclear            = 1,
		/obj/item/gun/energy/ionrifle               = 2,
		/obj/item/gun/energy/toxgun                 = 3,
		/obj/item/gun/energy/taser                  = 4,
		/obj/item/gun/energy/crossbow/largecrossbow = 2
	)
	return spawnable_choices

/obj/random/energy/sec
	name = "Random Security Weapon"
	desc = "This is a random energy weapon."

/obj/random/energy/sec/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/gun/energy/laser = 2,
		/obj/item/gun/energy/gun   = 2
	)
	return spawnable_choices

/obj/random/energy/highend
	name = "Random Energy Weapon"
	desc = "This is a random, actually good energy weapon."
	icon = /obj/item/gun/energy/laser::icon
	icon_state = /obj/item/gun/energy/laser::icon_state

/obj/random/energy/highend/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/gun/energy/laser                  = 3,
		/obj/item/gun/energy/gun                    = 4,
		/obj/item/gun/energy/gun/nuclear            = 1,
		/obj/item/gun/energy/retro                  = 2,
		/obj/item/gun/energy/lasercannon            = 2,
		/obj/item/gun/energy/xray                   = 3,
		/obj/item/gun/energy/sniperrifle            = 1,
		/obj/item/gun/energy/crossbow/largecrossbow = 2

	)
	return spawnable_choices
