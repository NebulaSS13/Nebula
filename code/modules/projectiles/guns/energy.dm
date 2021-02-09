var/global/list/registered_weapons = list()
var/global/list/registered_cyborg_weapons = list()

/obj/item/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon = 'icons/obj/guns/basic_energy.dmi'
	icon_state = "energy"
	fire_sound = 'sound/weapons/Taser.ogg'
	fire_sound_text = "laser blast"
	accuracy = 1
