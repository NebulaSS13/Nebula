//Fires bursts of weaker projs
/obj/item/gun/energy/pulse_pistol
	name = "pulse pistol"
	desc = "A weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. Even smaller than the carbine."
	icon = 'icons/obj/guns/pulse_pistol.dmi'
	icon_state = ICON_STATE_WORLD
	indicator_color = COLOR_LUMINOL
	slot_flags = SLOT_LOWER_BODY|SLOT_HOLSTER
	_base_attack_force = 6
	projectile_type = /obj/item/projectile/beam/pulse
	max_shots = 21
	w_class = ITEM_SIZE_NORMAL
	one_hand_penalty=1 //a bit heavy
	burst_delay = 3
	burst = 3
	accuracy = -1
	bulk = 0
