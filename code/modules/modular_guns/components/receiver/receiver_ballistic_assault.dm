/obj/item/firearm_component/receiver/ballistic/assault_rifle
	caliber = CALIBER_RIFLE
	load_method = MAGAZINE
	loaded = /obj/item/ammo_casing/rifle
	ammo_magazine = /obj/item/ammo_magazine/rifle
	mag_insert_sound = 'sound/weapons/guns/interaction/batrifle_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/batrifle_magout.ogg'
	allowed_magazines = /obj/item/ammo_magazine/rifle
	max_shells = 1
	auto_eject = TRUE
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

/obj/item/firearm_component/receiver/ballistic/assault_rifle/get_holder_overlay(holder_state)
	var/image/ret = ..()
	if(ret && ammo_magazine)
		ret.icon_state = "[ret.icon_state]-[length(ammo_magazine.stored_ammo) ? "loaded" : "empty"]"
	return ret
