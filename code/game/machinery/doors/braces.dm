// MAINTENANCE JACK - Allows removing of braces with certain delay.
/obj/item/crowbar/brace_jack
	name = "maintenance jack"
	desc = "A special crowbar that can be used to safely remove airlock braces from airlocks."
	w_class = ITEM_SIZE_NORMAL
	icon = 'icons/obj/items/tool/maintenance_jack.dmi'
	icon_state = ICON_STATE_WORLD
	_base_attack_force = 17.5 //It has a hammer head, should probably do some more damage. - Cirra
	attack_cooldown = 2.5*DEFAULT_WEAPON_COOLDOWN
	melee_accuracy_bonus = -25
	material = /decl/material/solid/metal/steel
	origin_tech = @'{"engineering":3,"materials":2}'

// BRACE - Can be installed on airlock to reinforce it and keep it closed.
/obj/item/airlock_brace
	name = "airlock brace"
	desc = "A sturdy device that can be attached to an airlock to reinforce it and provide additional security."
	w_class = ITEM_SIZE_LARGE
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "brace_open"
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	material_health_multiplier = 0.6
	origin_tech = @'{"engineering":3,"materials":2}'

	var/obj/machinery/door/airlock/airlock = null
	var/obj/item/stock_parts/circuitboard/airlock_electronics/brace/electronics


/obj/item/airlock_brace/examine(mob/user)
	. = ..()
	to_chat(user, examine_health())

// This is also called from airlock's examine, so it's a different proc to prevent code copypaste.
/obj/item/airlock_brace/proc/examine_health()
	switch(get_percent_health())
		if(-100 to 25)
			return "<span class='danger'>\The [src] looks seriously damaged, and probably won't last much more.</span>"
		if(25 to 50)
			return "<span class='notice'>\The [src] looks damaged.</span>"
		if(50 to 75)
			return "\The [src] looks slightly damaged."
		if(75 to 99)
			return "\The [src] has few dents."
		if(99 to INFINITY)
			return "\The [src] is in excellent condition."

/obj/item/airlock_brace/on_update_icon()
	. = ..()
	if(airlock)
		icon_state = "brace_closed"
	else
		icon_state = "brace_open"

/obj/item/airlock_brace/Initialize()
	. = ..()
	if(!electronics)
		electronics = new (src)

/obj/item/airlock_brace/Destroy()
	if(airlock)
		airlock.brace = null
		airlock = null
	QDEL_NULL(electronics)
	return ..()

// Interact with the electronics to set access requirements.
/obj/item/airlock_brace/attack_self(mob/user)
	electronics.attack_self(user)

/obj/item/airlock_brace/attackby(obj/item/W, mob/user)
	..()
	if (istype(W.GetIdCard(), /obj/item/card/id))
		if(!airlock)
			attack_self(user)
			return
		else
			var/obj/item/card/id/C = W.GetIdCard()
			if(check_access(C))
				to_chat(user, "You swipe \the [C] through \the [src].")
				if(do_after(user, 10, airlock))
					to_chat(user, "\The [src] clicks a few times and detaches itself from \the [airlock]!")
					unlock_brace(usr)
			else
				to_chat(user, "You swipe \the [C] through \the [src], but it does not react.")
		return

	if (istype(W, /obj/item/crowbar/brace_jack))
		if(!airlock)
			return
		var/obj/item/crowbar/brace_jack/C = W
		to_chat(user, "You begin forcibly removing \the [src] with \the [C].")
		if(do_after(user, rand(150,300), airlock))
			to_chat(user, "You finish removing \the [src].")
			unlock_brace(user)
		return

	if(IS_WELDER(W))
		var/obj/item/weldingtool/C = W
		if(!is_damaged())
			to_chat(user, "\The [src] does not require repairs.")
			return
		if(C.weld(0,user))
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			current_health = min(current_health + rand(20,30), get_max_health())
			if(!is_damaged())
				to_chat(user, "You repair some dents on \the [src]. It is in perfect condition now.")
			else
				to_chat(user, "You repair some dents on \the [src].")


/obj/item/airlock_brace/physically_destroyed(skip_qdel)
	if(airlock)
		airlock.visible_message(SPAN_DANGER("\The [src] breaks off of \the [airlock]!"))
	unlock_brace(null)
	. = ..()

/obj/item/airlock_brace/proc/unlock_brace(var/mob/user)
	if(!airlock)
		return
	if(user)
		user.put_in_hands(src)
		airlock.visible_message("\The [user] removes \the [src] from \the [airlock]!")
	else
		dropInto(loc)
	airlock.brace = null
	airlock.update_icon()
	airlock = null
	update_icon()

