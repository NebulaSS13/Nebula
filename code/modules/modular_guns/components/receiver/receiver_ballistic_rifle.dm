/obj/item/firearm_component/receiver/ballistic/rifle
	caliber = CALIBER_RIFLE
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 1
	loaded = /obj/item/ammo_casing/shell
	load_sound = 'sound/weapons/guns/interaction/rifle_load.ogg'
	var/bolt_open = FALSE

/obj/item/firearm_component/receiver/ballistic/rifle/sniper
	caliber = CALIBER_ANTIMATERIAL

/obj/item/firearm_component/receiver/ballistic/rifle/get_holder_overlay(holder_state)
	var/image/ret = ..()
	if(bolt_open)
		ret.icon_state = "[ret.icon_state]-open"
	return ret

/obj/item/firearm_component/receiver/ballistic/rifle/handle_post_holder_fire(var/mob/user)
	. = ..()
	if(user && chambered && user.skill_check(SKILL_WEAPONS, SKILL_PROF))
		to_chat(user, SPAN_NOTICE("You work the bolt open with a reflexive motion, ejecting [chambered]!"))
		unload_shell()
	
/obj/item/firearm_component/receiver/ballistic/rifle/holder_attack_self(var/mob/user)
	bolt_open = !bolt_open
	if(bolt_open)
		if(chambered)
			to_chat(user, SPAN_NOTICE("You work the bolt open, ejecting [chambered]!"))
			unload_shell()
		else
			to_chat(user, SPAN_NOTICE("You work the bolt open."))
	else
		to_chat(user, SPAN_NOTICE("You work the bolt closed."))
		playsound(loc, 'sound/weapons/guns/interaction/rifle_boltforward.ogg', 50, 1)
		bolt_open = FALSE
	update_icon()
	loc.update_icon()
	return TRUE

/obj/item/firearm_component/receiver/ballistic/rifle/proc/unload_shell()
	if(chambered)
		if(!bolt_open)
			playsound(src.loc, 'sound/weapons/guns/interaction/rifle_boltback.ogg', 50, 1)
			bolt_open = TRUE
		chambered.dropInto(src.loc)
		loaded -= chambered
		chambered = null

/obj/item/firearm_component/receiver/ballistic/rifle/special_check(var/mob/user)
	if(bolt_open)
		to_chat(user, SPAN_WARNING("You can't fire \the [loc] while the bolt is open!"))
		return FALSE
	. = ..()

/obj/item/firearm_component/receiver/ballistic/rifle/load_ammo(mob/user, obj/item/loading)
	. = bolt_open && ..()
	
/obj/item/firearm_component/receiver/ballistic/rifle/unload_ammo(mob/user)
	. = bolt_open && ..()
