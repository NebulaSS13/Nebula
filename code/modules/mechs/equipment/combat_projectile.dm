/obj/item/mech_equipment/mounted_system/projectile
	name = "mounted submachine gun"
	icon_state = "mech_ballistic"
	holding = /obj/item/gun/projectile/automatic/smg/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)
	origin_tech = @'{"programming":4,"combat":6,"engineering":5}'

/obj/item/mech_equipment/mounted_system/projectile/attackby(var/obj/item/used_item, var/mob/user)
	var/obj/item/gun/projectile/automatic/A = holding
	if(!istype(A))
		return FALSE
	if(istype(used_item, /obj/item/crowbar))
		A.unload_ammo(user)
		to_chat(user, SPAN_NOTICE("You remove the ammo magazine from \the [src]."))
	else if(istype(used_item, A.magazine_type))
		A.load_ammo(used_item, user)
		to_chat(user, SPAN_NOTICE("You load the ammo magazine into \the [src]."))
	return TRUE

/obj/item/gun/projectile/automatic/get_hardpoint_status_value()
	if(!isnull(ammo_magazine))
		return ammo_magazine.get_stored_ammo_count()

/obj/item/gun/projectile/automatic/get_hardpoint_maptext()
	if(!isnull(ammo_magazine))
		return "[ammo_magazine.get_stored_ammo_count()]/[ammo_magazine.max_ammo]"
	return 0

//Weapons below this.
/obj/item/gun/projectile/automatic/smg/mech
	magazine_type = /obj/item/ammo_magazine/mech/smg_top
	allowed_magazines = /obj/item/ammo_magazine/mech/smg_top
	one_hand_penalty = 0
	has_safety = FALSE
	manual_unload = FALSE
	firemodes = list(
		list(mode_name="semi auto",      burst=1, fire_delay=null, one_hand_penalty=0, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, one_hand_penalty=0, burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 1.6, 2.4, 2.4), autofire_enabled=0),
		list(mode_name="short bursts",   burst=5, fire_delay=null, one_hand_penalty=0, burst_accuracy=list(0,-1,-1,-1,-2), dispersion=list(1.6, 1.6, 2.0, 2.0, 2.4), autofire_enabled=0),
		list(mode_name="full auto",      burst=1, fire_delay=null, burst_delay=1,      one_hand_penalty=0,                 burst_accuracy=list(0,-1,-1,-1,-2), dispersion=list(1.6, 1.6, 2.0, 2.0, 2.4), autofire_enabled=1)
	)

/obj/item/mech_equipment/mounted_system/projectile/assault_rifle
	name = "mounted assault rifle"
	icon_state = "mech_ballistic2"
	holding = /obj/item/gun/projectile/automatic/assault_rifle/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)
	origin_tech = @'{"programming":4,"combat":8,"engineering":6}'

/obj/item/gun/projectile/automatic/assault_rifle/mech
	magazine_type = /obj/item/ammo_magazine/mech/rifle
	allowed_magazines = /obj/item/ammo_magazine/mech/rifle
	one_hand_penalty = 0
	has_safety = FALSE
	manual_unload = FALSE
	firemodes = list(
		list(mode_name="semi auto",      burst=1,    fire_delay=null, one_hand_penalty=0,  burst_accuracy=null,            dispersion=null, autofire_enabled=0),
		list(mode_name="3-round bursts", burst=3,    fire_delay=null, one_hand_penalty=0,  burst_accuracy=list(0,-1,-1),   dispersion=list(0.0, 0.6, 1.0), autofire_enabled=0),
		list(mode_name="full auto",      burst=1,    fire_delay=null, burst_delay=1,       one_hand_penalty=0,             burst_accuracy = list(0,-1,-1), dispersion=list(0.0, 0.6, 1.0), autofire_enabled=1)
	)

/obj/item/mech_equipment/mounted_system/projectile/machine
	name = "mounted machine gun"
	icon_state = "mech_machine_gun"
	holding = /obj/item/gun/projectile/automatic/machine/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)
	origin_tech = @'{"programming":4,"combat":8,"engineering":6}'

/obj/item/gun/projectile/automatic/machine/mech
	magazine_type = /obj/item/ammo_magazine/mech/rifle/drum
	allowed_magazines = /obj/item/ammo_magazine/mech/rifle/drum
	one_hand_penalty = 0
	has_safety = FALSE
	manual_unload = FALSE

// Magazines below this.

/obj/item/ammo_magazine/mech/attack_self(mob/user)
	to_chat(user, SPAN_WARNING("It's pretty hard to extract ammo from a magazine that fits on a mech. You'll have to do it one round at a time."))
	return

/obj/item/ammo_magazine/mech/smg_top
	name = "large 7mm magazine"
	desc = "A large magazine for a mech's gun. Looks way too big for a normal gun."
	icon_state = "smg_top"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol/small
	material = /decl/material/solid/metal/steel
	caliber = CALIBER_PISTOL_SMALL
	max_ammo = 90

/obj/item/ammo_magazine/mech/rifle
	name = "large assault rifle magazine"
	icon_state = "assault_rifle"
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE
	material = /decl/material/solid/metal/steel
	ammo_type = /obj/item/ammo_casing/rifle
	max_ammo = 100

/obj/item/ammo_magazine/mech/rifle/drum
	name = "large machine gun magazine"
	icon_state = "drum"
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE
	material = /decl/material/solid/metal/steel
	ammo_type = /obj/item/ammo_casing/rifle
	max_ammo = 300
