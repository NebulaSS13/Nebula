/obj/item/gun/hand/revolver
	name = "revolver"
	desc = "The al-Maliki & Mosley Magnum Double Action is a choice revolver for when you absolutely, positively need to put a hole in the other guy."
	icon = 'icons/obj/guns/revolvers.dmi'
	icon_state = ICON_STATE_WORLD
	barrel = /obj/item/firearm_component/barrel/ballistic/revolver
	receiver = /obj/item/firearm_component/receiver/ballistic/revolver
	origin_tech = "{'combat':2,'materials':2}"
	fire_delay = 12 //Revolvers are naturally slower-firing
	accuracy = 2
	accuracy_power = 8

/obj/item/gun/hand/revolver/capgun
	name = "cap gun"
	desc = "Looks almost like the real thing! Ages 8 and up."
	barrel = /obj/item/firearm_component/barrel/ballistic/revolver/capgun
	receiver = /obj/item/firearm_component/receiver/ballistic/revolver/capgun
	origin_tech = "{'combat':1,'materials':1}"
