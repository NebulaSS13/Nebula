//Fires bursts of weaker projs
/obj/item/gun/hand/pulse_pistol
	name = "pulse pistol"
	desc = "A weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. Even smaller than the carbine."
	icon = 'icons/obj/guns/pulse_pistol.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY|SLOT_HOLSTER
	force = 6
	w_class = ITEM_SIZE_NORMAL
	multi_aim = 1
	barrel = /obj/item/firearm_component/barrel/energy/pulse
	receiver = /obj/item/firearm_component/receiver/energy/pulse
