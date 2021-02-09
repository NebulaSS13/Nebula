
/obj/item/gun/energy/gun
	name = "energy gun"
	desc = "Another bestseller of Lawson Arms and the FTU, the LAEP90 Perun is a versatile energy based sidearm, capable of switching between low, medium and high power projectile settings. In other words: stun, shock or kill."
	icon = 'icons/obj/guns/energy_gun.dmi'
	icon_state = ICON_STATE_WORLD
	fire_delay = 10 // To balance for the fact that it is a pistol and can be used one-handed without penalty
	origin_tech = "{'combat':3,'magnets':2}"
	barrel = /obj/item/firearm_component/barrel/energy/sidearm
	receiver = /obj/item/firearm_component/receiver/energy/sidearm

/obj/item/gun/energy/gun/small
	name = "small energy gun"
	desc = "A smaller model of the versatile LAEP90 Perun, the LAEP90-C packs considerable utility in a smaller package. Best used in situations where full-sized sidearms are inappropriate."
	icon = 'icons/obj/guns/small_egun.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	force = 2 //it's the size of a car key, what did you expect?
	receiver = /obj/item/firearm_component/receiver/energy/sidearm/small

/obj/item/gun/energy/gun/mounted
	name = "mounted energy gun"
	receiver = /obj/item/firearm_component/receiver/energy/sidearm/mounted
