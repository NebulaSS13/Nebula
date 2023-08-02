/obj/item/gun/projectile/shotgun/
	load_sound = 'sound/weapons/guns/interaction/shotgun_instert.ogg'
	w_class = ITEM_SIZE_HUGE
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	force = 10

	caliber = CALIBER_SHOTGUN
	ammo_type = /obj/item/ammo_casing/shotgun

	accuracy_power   = 10
	one_hand_penalty = 10
	bulk             = 5

	matter = list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY)

//Pump shotgun

/obj/item/gun/projectile/shotgun/pump
	name = "pump shotgun"
	desc = "A favourite weapon of police and security forces on many worlds. Useful for sweeping alleys."
	icon = 'icons/obj/guns/shotgun/pump.dmi'

	load_method = SINGLE_CASING
	handle_casings = HOLD_CASINGS
	max_shells = 4

	var/recentpump = 0 // to prevent spammage

/obj/item/gun/projectile/shotgun/pump/empty
	starts_loaded = FALSE

/obj/item/gun/projectile/shotgun/update_base_icon()
	if(length(loaded))
		icon_state = get_world_inventory_state()
	else
		icon_state = "[get_world_inventory_state()]-empty"

/obj/item/gun/projectile/shotgun/pump/consume_next_projectile()
	if(chambered)
		return chambered.BB
	return null

/obj/item/gun/projectile/shotgun/pump/attack_self(mob/user)
	if(world.time >= recentpump + 10)
		pump(user)
		recentpump = world.time

/obj/item/gun/projectile/shotgun/pump/proc/pump(mob/M)
	playsound(M, 'sound/weapons/shotgunpump.ogg', 60, 1)

	if(chambered)//We have a shell in the chamber
		chambered.dropInto(loc)//Eject casing
		if(chambered.drop_sound)
			playsound(loc, pick(chambered.drop_sound), 50, 1)
		chambered = null

	if(loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

	update_icon()

//Doublebarrel shotgun

/obj/item/gun/projectile/shotgun/doublebarrel
	name = "double-barreled shotgun"
	desc = "A true classic, has primitive yet extremely reliable design."
	icon = 'icons/obj/guns/shotgun/doublebarrel.dmi'

	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = CYCLE_CASINGS
	max_shells = 2

	burst_delay = 0
	firemodes = list(
		list(mode_name="fire one barrel at a time", burst=1),
		list(mode_name="fire both barrels at once", burst=2),
		)

/obj/item/gun/projectile/shotgun/doublebarrel/empty
	starts_loaded = FALSE

/obj/item/gun/projectile/shotgun/doublebarrel/unload_ammo(user, allow_dump)
	..(user, allow_dump=1)

//Sawn-off

/obj/item/gun/projectile/shotgun/doublebarrel/sawn
	name = "sawn-off shotgun"
	desc = "Omar's coming!"
	icon = 'icons/obj/guns/shotgun/sawnoff.dmi'
	slot_flags = SLOT_LOWER_BODY|SLOT_HOLSTER
	w_class = ITEM_SIZE_NORMAL
	force = 5
	ammo_type = /obj/item/ammo_casing/shotgun/pellet

	bulk = 2
	one_hand_penalty = 4

/obj/item/gun/projectile/shotgun/doublebarrel/sawn/empty
	starts_loaded = FALSE

//this is largely hacky and bad :(	-Pete
/obj/item/gun/projectile/shotgun/doublebarrel/attackby(var/obj/item/A, mob/user)
	if(w_class > ITEM_SIZE_NORMAL && A.get_tool_quality(TOOL_SAW) > 0)
		if(istype(A, /obj/item/gun/energy/plasmacutter))
			var/obj/item/gun/energy/plasmacutter/cutter = A
			if(!cutter.slice(user))
				return ..()
		to_chat(user, "<span class='notice'>You begin to shorten the barrel of \the [src].</span>")
		if(loaded.len)
			for(var/i in 1 to max_shells)
				Fire(user, user)	//will this work? //it will. we call it twice, for twice the FUN
			user.visible_message("<span class='danger'>The shotgun goes off!</span>", "<span class='danger'>The shotgun goes off in your face!</span>")
			return
		if(do_after(user, 30, src))	//SHIT IS STEALTHY EYYYYY
			user.try_unequip(src)
			var/obj/item/gun/projectile/shotgun/doublebarrel/sawn/empty/buddy = new(loc)
			transfer_fingerprints_to(buddy)
			qdel(src)
			to_chat(user, "<span class='warning'>You shorten the barrel of \the [src]!</span>")
	else
		..()

