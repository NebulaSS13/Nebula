/obj/item/firearm_component/receiver/ballistic/submachine_gun
	caliber = CALIBER_PISTOL_SMALL
	load_method = MAGAZINE
	loaded = /obj/item/ammo_casing/pistol/small
	ammo_magazine = /obj/item/ammo_magazine/smg/rubber
	allowed_magazines = /obj/item/ammo_magazine/smg
	auto_eject = TRUE
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	ammo_indicator = TRUE

/obj/item/firearm_component/receiver/ballistic/submachine_gun/get_holder_overlay(holder_state)
	var/image/ret = ..()
	if(ret && ammo_magazine)
		ret.icon_state = "[ret.icon_state]-mag[round(ammo_magazine.stored_ammo.len,5)]"
	return ret

/obj/item/firearm_component/receiver/ballistic/submachine_gun/cheap
	jam_chance = 20
