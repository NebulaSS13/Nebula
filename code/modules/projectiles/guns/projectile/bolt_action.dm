/obj/item/gun/projectile/bolt_action
	name = "bolt-action rifle"
	desc = "A slow-firing but reliable bolt-action rifle. Rather old-fashioned."
	icon = 'icons/obj/guns/bolt_action.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_HUGE
	force = 5
	slot_flags = SLOT_BACK
	origin_tech = "{'combat':4,'materials':2}"
	caliber = CALIBER_RIFLE
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/shell
	one_hand_penalty = 2
	load_sound = 'sound/weapons/guns/interaction/rifle_load.ogg'
	fire_delay = 8
	var/bolt_open = FALSE

/obj/item/gun/projectile/bolt_action/on_update_icon()
	..()
	if(bolt_open)
		icon_state = "[get_world_inventory_state()]-open"
	else
		icon_state = get_world_inventory_state()

/obj/item/gun/projectile/bolt_action/handle_post_fire(atom/movable/firer, atom/target, var/pointblank=0, var/reflex=0)
	..()
	if(ismob(firer))
		var/mob/user = firer
		if(user.skill_check(SKILL_WEAPONS, SKILL_PROF))
			to_chat(user, "<span class='notice'>You work the bolt open with a reflexive motion, ejecting [chambered]!</span>")
			unload_shell()

/obj/item/gun/projectile/bolt_action/proc/unload_shell()
	if(chambered)
		if(!bolt_open)
			playsound(src.loc, 'sound/weapons/guns/interaction/rifle_boltback.ogg', 50, 1)
			bolt_open = TRUE
		chambered.dropInto(src.loc)
		loaded -= chambered
		chambered = null

/obj/item/gun/projectile/bolt_action/attack_self(mob/user)
	bolt_open = !bolt_open
	if(bolt_open)
		if(chambered)
			to_chat(user, "<span class='notice'>You work the bolt open, ejecting [chambered]!</span>")
			unload_shell()
		else
			to_chat(user, "<span class='notice'>You work the bolt open.</span>")
	else
		to_chat(user, "<span class='notice'>You work the bolt closed.</span>")
		playsound(src.loc, 'sound/weapons/guns/interaction/rifle_boltforward.ogg', 50, 1)
		bolt_open = FALSE
	add_fingerprint(user)
	update_icon()

/obj/item/gun/projectile/bolt_action/special_check(mob/user)
	if(bolt_open)
		to_chat(user, "<span class='warning'>You can't fire [src] while the bolt is open!</span>")
		return 0
	return ..()

/obj/item/gun/projectile/bolt_action/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/bolt_action/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/bolt_action/sniper
	name = "anti-materiel rifle"
	desc = "A portable anti-armour rifle fitted with a scope, the HI PTR-7 Rifle was originally designed to be used against armoured exosuits. It is capable of punching through windows and non-reinforced walls with ease."
	icon = 'icons/obj/guns/heavysniper.dmi'
	force = 10
	origin_tech = "{'combat':7,'materials':2,'esoteric':8}"
	caliber = CALIBER_ANTI_MATERIEL
	screen_shake = 2 //extra kickback
	one_hand_penalty = 6
	accuracy = -2
	bulk = 8
	scoped_accuracy = 8 //increased accuracy over the LWAP because only one shot
	scope_zoom = 2
	fire_delay = 12