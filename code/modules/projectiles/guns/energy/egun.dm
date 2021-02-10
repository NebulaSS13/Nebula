
/obj/item/gun/hand/egun
	name = "energy gun"
	desc = "Another bestseller of Lawson Arms and the FTU, the LAEP90 Perun is a versatile energy based sidearm, capable of switching between low, medium and high power projectile settings. In other words: stun, shock or kill."
	icon = 'icons/obj/guns/energy_gun.dmi'
	fire_delay = 10 // To balance for the fact that it is a pistol and can be used one-handed without penalty
	barrel = /obj/item/firearm_component/barrel/energy/sidearm
	receiver = /obj/item/firearm_component/receiver/energy/sidearm

/obj/item/gun/hand/egun/small
	name = "small energy gun"
	desc = "A smaller model of the versatile LAEP90 Perun, the LAEP90-C packs considerable utility in a smaller package. Best used in situations where full-sized sidearms are inappropriate."
	icon = 'icons/obj/guns/small_egun.dmi'
	barrel = /obj/item/firearm_component/barrel/energy/sidearm/small
	receiver = /obj/item/firearm_component/receiver/energy/sidearm/small

/obj/item/gun/hand/egun/mounted
	name = "mounted energy gun"
	receiver = /obj/item/firearm_component/receiver/energy/sidearm/mounted
