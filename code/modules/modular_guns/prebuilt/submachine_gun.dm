/obj/item/gun/hand/submachine_gun
	name = "submachine gun"
	desc = "The WT-550 Saber is a cheap self-defense weapon, mass-produced for paramilitary and private use."
	icon = 'icons/obj/guns/sec_smg.dmi'
	barrel = /obj/item/firearm_component/barrel/ballistic/pistol
	receiver = /obj/item/firearm_component/receiver/ballistic/submachine_gun

/obj/item/gun/hand/submachine_gun/cheap
	desc = "A cheap mass-produced SMG. This one looks especially run-down. Uses pistol rounds."
	receiver = /obj/item/firearm_component/receiver/ballistic/submachine_gun/cheap

/obj/item/firearm_component/receiver/ballistic/submachine_gun
	safety_icon = "safety"
	caliber = CALIBER_PISTOL_SMALL
	load_method = MAGAZINE
	loaded = /obj/item/ammo_casing/pistol/small
	ammo_magazine = /obj/item/ammo_magazine/smg/rubber
	allowed_magazines = /obj/item/ammo_magazine/smg
	auto_eject = TRUE
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	ammo_indicator = TRUE
	firemodes = list(
		list(mode_name="semi auto",      burst=1, fire_delay=null, one_hand_penalty=3, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, one_hand_penalty=4, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 1.6, 2.4, 2.4)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, one_hand_penalty=5, burst_accuracy=list(0,-1,-1,-1,-2), dispersion=list(1.6, 1.6, 2.0, 2.0, 2.4)),
		list(mode_name="full auto",      can_autofire=1, burst=1, fire_delay=1, one_hand_penalty=7, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(2.0, 2.0, 2.0, 2.0, 2.4))
	)
	one_hand_penalty = 3
	bulk = -1

/obj/item/firearm_component/receiver/ballistic/submachine_gun/get_holder_overlay(holder_state)
	var/image/ret = ..()
	if(ret && ammo_magazine)
		ret.icon_state = "[ret.icon_state]-mag[round(ammo_magazine.stored_ammo.len,5)]"
	return ret

/obj/item/firearm_component/receiver/ballistic/submachine_gun/cheap
	jam_chance = 20
