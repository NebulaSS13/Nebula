// Powersink - used to drain station power

/obj/item/powersink
	name = "power sink"
	desc = "A nulling power sink which drains energy from electrical systems."
	icon = 'icons/obj/items/device/powersink.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_LARGE
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	throwforce = 5
	throw_speed = 1
	throw_range = 2

	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/metallic_hydrogen = MATTER_AMOUNT_REINFORCEMENT)

	origin_tech = "{'powerstorage':3,'esoteric':5}"
	var/drain_rate = 1500000		// amount of power to drain per tick
	var/power_drained = 0 			// Amount of power drained.
	var/max_power = 5e9				// Detonation point.
	var/mode = 0					// 0 = off, 1=clamped (off), 2=operating

	var/const/DISCONNECTED = 0
	var/const/CLAMPED_OFF = 1
	var/const/OPERATING = 2

	var/obj/structure/cable/attached		// the attached cable

/obj/item/powersink/on_update_icon()
	. = ..()
	z_flags &= ~ZMM_MANGLE_PLANES
	if(mode == OPERATING)
		if(plane == HUD_PLANE)
			add_overlay("[icon_state]-on")
		else
			add_overlay(emissive_overlay(icon, "[icon_state]-on"))
			z_flags |= ~ZMM_MANGLE_PLANES

/obj/item/powersink/proc/set_mode(value)
	if(value == mode)
		return
	switch(value)
		if(DISCONNECTED)
			attached = null
			if(mode == OPERATING)
				STOP_PROCESSING_POWER_OBJECT(src)
			anchored = FALSE

		if(CLAMPED_OFF)
			if(!attached)
				return
			if(mode == OPERATING)
				STOP_PROCESSING_POWER_OBJECT(src)
			anchored = TRUE

		if(OPERATING)
			if(!attached)
				return
			START_PROCESSING_POWER_OBJECT(src)
			anchored = TRUE

	mode = value
	update_icon()
	set_light(0)

/obj/item/powersink/Destroy()
	if(mode == 2)
		STOP_PROCESSING_POWER_OBJECT(src)
	. = ..()

/obj/item/powersink/attackby(var/obj/item/I, var/mob/user)
	if(IS_SCREWDRIVER(I))
		if(mode == DISCONNECTED)
			var/turf/T = loc
			if(isturf(T) && !!T.is_plating())
				attached = locate() in T
				if(!attached)
					to_chat(user, "<span class='warning'>This device must be placed over an exposed, powered cable node!</span>")
				else
					set_mode(CLAMPED_OFF)
					user.visible_message( \
						"[user] attaches \the [src] to the cable.", \
						"<span class='notice'>You attach \the [src] to the cable.</span>",
						"<span class='italics'>You hear some wires being connected to something.</span>")
			else
				to_chat(user, "<span class='warning'>This device must be placed over an exposed, powered cable node!</span>")
		else
			set_mode(DISCONNECTED)
			user.visible_message( \
				"[user] detaches \the [src] from the cable.", \
				"<span class='notice'>You detach \the [src] from the cable.</span>",
				"<span class='italics'>You hear some wires being disconnected from something.</span>")
	else
		return ..()

/obj/item/powersink/attack_ai()
	return

/obj/item/powersink/attack_hand(var/mob/user)
	if(!user.check_dexterity(DEXTERITY_SIMPLE_MACHINES, TRUE))
		return ..()
	if(mode == CLAMPED_OFF)
		user.visible_message(
			"[user] activates \the [src]!",
			SPAN_NOTICE("You activate \the [src]."),
			SPAN_ITALIC("You hear a click.")
		)
		message_admins("Power sink activated by [key_name_admin(user)] at (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")
		log_game("Power sink activated by [key_name(user)] at [get_area_name(src)]")
		set_mode(OPERATING)
		return TRUE

	if(mode == OPERATING)
		user.visible_message( \
			"[user] deactivates \the [src]!", \
			"<span class='notice'>You deactivate \the [src].</span>",
			"<span class='italics'>You hear a click.</span>")
		set_mode(CLAMPED_OFF)
		return TRUE

	return ..()

/obj/item/powersink/pwr_drain()
	if(!attached)
		set_mode(DISCONNECTED)
		return

	var/datum/powernet/PN = attached.powernet
	var/drained = 0
	if(PN)
		set_light(12)
		PN.trigger_warning()
		// found a powernet, so drain up to max power from it
		drained = PN.draw_power(drain_rate)
		// if tried to drain more than available on powernet
		// now look for APCs and drain their cells
		if(drained < drain_rate)
			for(var/obj/machinery/power/terminal/T in PN.nodes)
				// Enough power drained this tick, no need to torture more APCs
				if(drained >= drain_rate)
					break
				var/obj/machinery/power/apc/A = T.master_machine()
				if(istype(A))
					drained += A.drain_power(amount = drain_rate)
		power_drained += drained

	if(power_drained > max_power * 0.95)
		playsound(src, 'sound/effects/screech.ogg', 100, 1, 1)
	if(power_drained >= max_power)
		STOP_PROCESSING_POWER_OBJECT(src)
		explosion(src.loc, 3,6,9,12)
		qdel(src)
