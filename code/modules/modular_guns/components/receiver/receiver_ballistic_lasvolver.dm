/obj/item/firearm_component/receiver/ballistic/lasbulb
	loaded = /obj/item/ammo_casing/lasbulb
	bulk = 1

/obj/item/firearm_component/receiver/ballistic/lasbulb/handle_post_holder_fire()
	. = ..()
	playsound(loc, 'sound/effects/rewind.ogg', 20, 0)
