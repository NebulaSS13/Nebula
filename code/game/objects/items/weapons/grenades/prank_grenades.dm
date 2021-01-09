/obj/item/grenade/fake
	icon = 'icons/obj/items/grenades/frag.dmi'

/obj/item/grenade/fake/detonate()
	active = 0
	playsound(src.loc, get_sfx("explosion"), 50, 1, 30)

/obj/item/natural_weapon/bite/fake
	force = 0

/mob/living/simple_animal/hostile/carp/holodeck/fake
	faction = null
	natural_weapon = /obj/item/natural_weapon/bite/fake
	environment_smash = 0
	destroy_surroundings = 0

/obj/item/grenade/spawnergrenade/fake_carp
	origin_tech = "{'materials':2,'magnets':2,'wormholes':5}"
	spawner_type = /mob/living/simple_animal/hostile/carp/holodeck/fake
	deliveryamt = 4
