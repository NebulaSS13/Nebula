/obj/item/mech_equipment/mounted_system/projectile/attackby(var/obj/item/O as obj, mob/user as mob)
	var/obj/item/gun/projectile/automatic/A = holding
	if(istype(O, /obj/item/crowbar))
		A.unload_ammo(user)
		to_chat(user, SPAN_NOTICE("You remove the ammo magazine from the [src]."))
	if(istype(O, A.magazine_type))
		A.load_ammo(O, user)
		to_chat(user, SPAN_NOTICE("You load the ammo magazine into the [src]."))

/obj/item/mech_equipment/mounted_system/projectile/attack_self(var/mob/user)
	. = ..()
	if(. && holding)
		var/obj/item/gun/M = holding
		return M.switch_firemodes(user)

/obj/item/gun/projectile/automatic/get_hardpoint_status_value()
	if(!isnull(ammo_magazine))
		return ammo_magazine.stored_ammo.len

/obj/item/gun/projectile/automatic/get_hardpoint_maptext()
	if(!isnull(ammo_magazine))
		return "[ammo_magazine.stored_ammo.len]/[ammo_magazine.max_ammo]"
	return 0

//Weapons below this.
/obj/item/mech_equipment/mounted_system/projectile
	name = "mounted submachine gun"
	icon_state = "mech_ballistic"
	holding_type = /obj/item/gun/projectile/automatic/smg/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)

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
	holding_type = /obj/item/gun/projectile/automatic/assault_rifle/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)

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
	holding_type = /obj/item/gun/projectile/automatic/machine/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)

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

// Handling for auto-fire mechanic
/mob/living/exosuit/can_autofire(obj/item/gun/autofiring, atom/autofiring_at)
	if(autofiring.autofiring_by != src)
		return FALSE
	var/client/C
	if(current_user)
		C = current_user.client
		if(current_user.incapacitated())
			return FALSE
	else
		C = client
		if(incapacitated())
			return FALSE
	if(!C || !(autofiring_at in view(C.view, src)))
		return FALSE
	if(!(get_dir(src, autofiring_at) & dir))
		return FALSE
	if(!(autofiring in selected_system)) // Make sure the gun is still selected.
		return FALSE
	return TRUE

/obj/item/mech_equipment/mounted_system/projectile/MouseDownInteraction(atom/object, location, control, params, mob/user)
	var/obj/item/gun/gun = holding
	if(istype(object) && (isturf(object) || isturf(object.loc)) && istype(gun))
		if(user != src)
			if(!user.incapacitated())
				gun.set_autofire(object, owner, FALSE) // Passed gun-firer is still the exosuit since all checks need to be done on the suit.
				owner.current_user = user
		else
			if(!owner.incapacitated())
				gun.set_autofire(object, owner, FALSE)
				owner.current_user = null

/obj/item/mech_equipment/mounted_system/projectile/MouseUpInteraction(atom/object, location, control, params, mob/user)
	var/obj/item/gun/gun = holding
	if(istype(gun))
		gun.clear_autofire()
	owner.current_user = null

/obj/item/mech_equipment/mounted_system/projectile/MouseDragInteraction(atom/src_object, atom/over_object, src_location, over_location, src_control, over_control, params, mob/user)
	var/obj/item/gun/gun = holding
	if(!istype(gun))
		owner.current_user = null
		return
	if(istype(over_object) && (isturf(over_object) || isturf(over_object.loc)))
		if(user != owner)
			if(user != owner.current_user || user.incapacitated())
				gun.clear_autofire()
				return
		else if(owner.incapacitated())
			gun.clear_autofire()
			return
		gun.set_autofire(over_object, owner, FALSE)
		return
	
	gun.clear_autofire()