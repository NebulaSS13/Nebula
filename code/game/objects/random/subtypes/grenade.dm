
/obj/random/grenade
	name = "Random Grenade"
	desc = "This is random thrown grenades (no C4/etc.)."
	icon = /obj/item/grenade::icon
	icon_state = /obj/item/grenade::icon_state

/obj/random/grenade/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/grenade/empgrenade              = 5,
		/obj/item/grenade/empgrenade/low_yield    = 15,
		/obj/item/grenade/chem_grenade/metalfoam  = 5,
		/obj/item/grenade/chem_grenade/incendiary = 2,
		/obj/item/grenade/chem_grenade/antiweed   = 10,
		/obj/item/grenade/chem_grenade/cleaner    = 10,
		/obj/item/grenade/chem_grenade/teargas    = 10,
		/obj/item/grenade/frag                    = 10,
		/obj/item/grenade/frag/high_yield         = 3,
		/obj/item/grenade/flashbang               = 15,
		/obj/item/grenade/flashbang/clusterbang   = 1,
		/obj/item/grenade/smokebomb               = 15
	)
	return spawnable_choices

/obj/random/grenade/lethal
	name = "Random Grenade"
	desc = "This is random thrown grenade that hurts a lot."

/obj/random/grenade/lethal/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/grenade/empgrenade              = 5,
		/obj/item/grenade/chem_grenade/incendiary = 2,
		/obj/item/grenade/frag                    = 12,
		/obj/item/grenade/frag/high_yield         = 3
	)
	return spawnable_choices

/obj/random/grenade/less_lethal
	name = "Random Security Grenade"
	desc = "This is a random thrown grenade that shouldn't kill anyone."

/obj/random/grenade/less_lethal/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/grenade/empgrenade/low_yield   = 15,
		/obj/item/grenade/chem_grenade/metalfoam = 15,
		/obj/item/grenade/chem_grenade/teargas   = 20,
		/obj/item/grenade/flashbang              = 20,
		/obj/item/grenade/flashbang/clusterbang  = 1
	)
	return spawnable_choices

/obj/random/grenade/box
	name = "Random Grenade Box"
	desc = "This is a random box of grenades. Not to be mistaken for a box of random grenades. Or a grenade of random boxes - but that would just be silly."
	icon = /obj/item/box/smokes::icon
	icon_state = /obj/item/box/smokes::icon_state

/obj/random/grenade/box/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/box/flashbangs   = 20,
		/obj/item/box/emps         = 10,
		/obj/item/box/empslite     = 20,
		/obj/item/box/smokes       = 15,
		/obj/item/box/anti_photons = 5,
		/obj/item/box/frags        = 5,
		/obj/item/box/metalfoam    = 10,
		/obj/item/box/teargas      = 15
	)
	return spawnable_choices

/obj/random/landmine
	name = "random landmine"
	icon = /obj/item/mine::icon
	icon_state = /obj/item/mine::icon_state

/obj/random/landmine/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/mine/emp/mapped,
		/obj/item/mine/frag/mapped,
		/obj/item/mine/incendiary/mapped,
		/obj/item/mine/napalm/mapped,
		/obj/item/mine/radiation/mapped,
		/obj/item/mine/stun/mapped
	)
	return spawnable_choices
