//Heavy sniper, basically PTRD

/obj/item/gun/projectile/heavysniper
	name = "heavy sniper rifle"
	desc = "A portable anti-tank rifle fitted with a scope. It is capable of punching through windows and non-reinforced walls with ease."
	icon = 'icons/obj/guns/heavysniper.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	force = 10

	max_shells = 1
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	caliber = CALIBER_ANTI_MATERIEL
	ammo_type = /obj/item/ammo_casing/rifle/shell
	load_sound = 'sound/weapons/guns/interaction/rifle_load.ogg'

	var/bolt_open = FALSE

	screen_shake = 10
	one_hand_penalty = 10
	accuracy = -2
	bulk = 8
	scoped_accuracy = 8
	scope_zoom = 2
	fire_delay = 12

/obj/item/gun/projectile/heavysniper/on_update_icon()
	..()
	if(bolt_open)
		icon_state = "[get_world_inventory_state()]-open"
	else
		icon_state = get_world_inventory_state()

/obj/item/gun/projectile/heavysniper/handle_post_fire(atom/movable/firer, atom/target, var/pointblank=0, var/reflex=0)
	..()
	if(ismob(firer))
		var/mob/user = firer
		if(user.skill_check(SKILL_WEAPONS, SKILL_PROF))
			to_chat(user, "<span class='notice'>You work the bolt open with a reflexive motion, ejecting [chambered]!</span>")
			unload_shell()

/obj/item/gun/projectile/heavysniper/proc/unload_shell()
	if(chambered)
		if(!bolt_open)
			playsound(src.loc, 'sound/weapons/guns/interaction/rifle_boltback.ogg', 50, 1)
			bolt_open = TRUE
		chambered.dropInto(src.loc)
		loaded -= chambered
		chambered = null

/obj/item/gun/projectile/heavysniper/attack_self(mob/user)
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

/obj/item/gun/projectile/heavysniper/special_check(mob/user)
	if(bolt_open)
		to_chat(user, "<span class='warning'>You can't fire [src] while the bolt is open!</span>")
		return 0
	return ..()

/obj/item/gun/projectile/heavysniper/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/heavysniper/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return
	..()