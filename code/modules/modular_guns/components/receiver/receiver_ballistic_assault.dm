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
	firemodes = list(
		list(mode_name="semi auto",      burst=1,    fire_delay=null, use_launcher=null, one_hand_penalty=8,  burst_accuracy=null,          dispersion=null),
		list(mode_name="3-round bursts", burst=3,    fire_delay=null, use_launcher=null, one_hand_penalty=9,  burst_accuracy=list(0,-1,-1), dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="fire grenades",  burst=null, fire_delay=null, use_launcher=1,    one_hand_penalty=10, burst_accuracy=null,          dispersion=null)
	)

/obj/item/firearm_component/receiver/ballistic/assault_rifle/get_holder_overlay(holder_state)
	var/image/ret = ..()
	if(ret && ammo_magazine)
		ret.icon_state = "[ret.icon_state]-[length(ammo_magazine.stored_ammo) ? "loaded" : "empty"]"
	return ret

/*
	var/use_launcher = 0
	var/obj/item/gun/launcher/grenade/underslung/launcher

/obj/item/gun/projectile/automatic/assault_rifle/Initialize()
	. = ..()
	launcher = new(src)

/obj/item/gun/projectile/automatic/assault_rifle/Fire(atom/target, mob/living/user, params, pointblank=0, reflex=0)
	if(use_launcher)
		launcher.Fire(target, user, params, pointblank, reflex)
		if(!launcher.chambered)
			switch_firemodes() //switch back automatically
	else
		..()

/obj/item/gun/projectile/automatic/assault_rifle/examine(mob/user)
	. = ..()
	if(launcher.chambered)
		to_chat(user, "\The [launcher] has \a [launcher.chambered] loaded.")
	else
		to_chat(user, "\The [launcher] is empty.")

/obj/item/gun/projectile/automatic/assault_rifle/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/grenade)))
		launcher.load(I, user)
	else
		..()

*/