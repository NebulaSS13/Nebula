// Holographic Items!

// Holographic tables are in code/modules/tables/presets.dm
// Holographic racks are in code/modules/tables/rack.dm

/obj
	/// if the obj is a holographic object spawned by the holodeck
	var/holographic = FALSE

/obj/structure/holostool
	name          = "stool"
	desc          = "Apply butt."
	icon          = 'icons/obj/stool.dmi'
	icon_state    = "stool_padded_preview"
	anchored      = TRUE
	worthless     = TRUE
	holographic   = TRUE

/obj/item/clothing/gloves/boxing/hologlove
	name          = "boxing gloves"
	desc          = "Because you really needed another excuse to punch your crewmates."
	worthless     = TRUE
	holographic   = TRUE

/obj/structure/window/reinforced/holowindow
	worthless     = TRUE
	holographic   = TRUE

/obj/structure/window/reinforced/holowindow/full
	dir           = NORTHEAST
	icon_state    = "rwindow_full"

/obj/structure/window/reinforced/holowindow/attackby(obj/item/used_item, mob/user)
	if(IS_SCREWDRIVER(used_item) || IS_CROWBAR(used_item) || IS_WRENCH(used_item))
		to_chat(user, SPAN_NOTICE("It's a holowindow, you can't dismantle it!"))
		return TRUE
	return bash(used_item, user)

/obj/structure/window/reinforced/holowindow/shatter(var/display_message = 1)
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("[src] fades away as it shatters!")
	qdel(src)
	return

// This subtype is deleted when a ready button in the same area is pressed.
/obj/structure/window/reinforced/holowindow/disappearing

/obj/machinery/door/window/holowindoor
	holographic = TRUE
	worthless = TRUE

/obj/machinery/door/window/holowindoor/attackby(obj/item/used_item, mob/user)

	if (operating)
		return TRUE

	if(density && istype(used_item, /obj/item) && !istype(used_item, /obj/item/card))
		playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
		visible_message("<span class='danger'>\The [src] was hit by \the [used_item].</span>")
		if(used_item.atom_damage_type == BRUTE || used_item.atom_damage_type == BURN)
			take_damage(used_item.expend_attack_force(user))
		return TRUE

	add_fingerprint(user)
	if (allowed(user))
		if (density)
			open()
		else
			close()
		return TRUE

	else if (density)
		flick("[base_state]deny", src)
		return TRUE
	return FALSE

/obj/machinery/door/window/holowindoor/shatter(var/display_message = TRUE)
	set_density(FALSE)
	playsound(loc, "shatter", 70, TRUE)
	if(display_message)
		visible_message("[src] fades away as it shatters!")
	animate(src, 0.5 SECONDS, alpha = 0)
	QDEL_IN_CLIENT_TIME(src, 0.5 SECONDS)

/obj/structure/bed/holobed
	tool_interaction_flags = 0
	holographic = TRUE
	worthless = TRUE
	material = /decl/material/solid/metal/aluminium/holographic

/obj/structure/chair/holochair
	tool_interaction_flags = 0
	holographic = TRUE
	worthless = TRUE
	material = /decl/material/solid/metal/aluminium/holographic

/obj/item/holo
	holographic = TRUE
	worthless = TRUE
	atom_damage_type =  PAIN
	no_attack_log = 1
	max_health = ITEM_HEALTH_NO_DAMAGE

/obj/item/holo/esword
	name = "holosword"
	desc = "May the force be within you. Sorta."
	icon = 'icons/obj/items/weapon/e_sword.dmi'
	icon_state = "sword0"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	atom_flags = ATOM_FLAG_NO_BLOOD
	base_parry_chance = 50
	_base_attack_force = 3
	var/active = 0
	var/item_color

/obj/item/holo/esword/green
	item_color = "green"

/obj/item/holo/esword/red
	item_color = "red"

/obj/item/holo/esword/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	. = ..()
	if(.)
		spark_at(user.loc, amount=5)
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)

/obj/item/holo/esword/get_parry_chance(mob/user)
	return active ? ..() : 0

/obj/item/holo/esword/Initialize()
	. = ..()
	item_color = pick("red","blue","green","purple")

/obj/item/holo/esword/attack_self(mob/user)
	active = !active
	if (active)
		set_base_attack_force(30)
		icon_state = "sword[item_color]"
		w_class = ITEM_SIZE_HUGE
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, "<span class='notice'>[src] is now active.</span>")
	else
		set_base_attack_force(3)
		icon_state = "sword0"
		w_class = ITEM_SIZE_SMALL
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, "<span class='notice'>[src] can now be concealed.</span>")

	update_held_icon()

	add_fingerprint(user)
	return

//BASKETBALL OBJECTS
/obj/structure/holohoop
	name = "basketball hoop"
	desc = "Boom, Shakalaka!"
	icon = 'icons/obj/structures/basketball.dmi'
	icon_state = "hoop"
	anchored = TRUE
	density = TRUE
	throwpass = 1
	holographic = TRUE
	worthless = TRUE

/obj/structure/holohoop/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (istype(mover,/obj/item) && mover.throwing)
		var/obj/item/thing = mover
		if(istype(thing, /obj/item/projectile))
			return
		if(prob(50))
			thing.dropInto(loc)
			visible_message("<span class='notice'>Swish! \the [thing] lands in \the [src].</span>", range = 3)
		else
			visible_message("<span class='warning'>\The [thing] bounces off of \the [src]'s rim!</span>", range = 3)
		return 0
	else
		return ..(mover, target, height, air_group)

//VOLEYBALL OBJECTS
/obj/structure/holonet
	name = "net"
	desc = "Bullshit, you can be mine!"
	icon = 'icons/obj/structures/volleyball.dmi'
	icon_state = "volleynet_mid"
	density = TRUE
	anchored = TRUE
	layer = TABLE_LAYER
	throwpass = 1
	dir = EAST
	holographic = TRUE
	worthless = TRUE

/obj/structure/holonet/end
	icon_state = "volleynet_end"

/obj/structure/holonet/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (istype(mover,/obj/item) && mover.throwing)
		var/obj/item/thing = mover
		if(istype(thing, /obj/item/projectile))
			return
		if(prob(10))
			thing.dropInto(loc)
			visible_message("<span class='notice'>Swish! \the [thing] gets caught in \the [src].</span>", range = 3)
			return 0
		else
			return 1
	else
		return ..(mover, target, height, air_group)

/obj/machinery/readybutton
	name = "Ready Declaration Device"
	desc = "This device is used to declare ready. If all devices in an area are ready, the event will begin!"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "auth_off"
	var/ready = 0
	var/area/currentarea = null
	var/eventstarted = 0

	anchored = TRUE
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON
	holographic = TRUE
	worthless = TRUE

/obj/machinery/readybutton/attack_ai(mob/living/silicon/ai/user)
	to_chat(user, "The AI is not to interact with these devices!")
	return

/obj/machinery/readybutton/attackby(obj/item/used_item, mob/user)
	to_chat(user, "The device is a solid button, there's nothing you can do with it!")
	return TRUE

/obj/machinery/readybutton/physical_attack_hand(mob/user)
	currentarea = get_area(src)
	if(!currentarea)
		qdel(src)
		return TRUE

	if(eventstarted)
		to_chat(user, "The event has already begun!")
		return TRUE

	ready = !ready

	update_icon()

	var/numbuttons = 0
	var/numready = 0
	for(var/obj/machinery/readybutton/button in currentarea)
		numbuttons++
		if (button.ready)
			numready++

	if(numbuttons == numready)
		begin_event()
	return TRUE

/obj/machinery/readybutton/on_update_icon()
	if(ready)
		icon_state = "auth_on"
	else
		icon_state = "auth_off"

/obj/machinery/readybutton/proc/begin_event()

	eventstarted = 1

	for(var/obj/structure/window/reinforced/holowindow/disappearing/window in currentarea)
		qdel(window)

	for(var/mob/M in currentarea)
		to_chat(M, "FIGHT!")
