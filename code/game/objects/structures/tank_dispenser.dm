/obj/structure/tank_rack
	name = "tank rack"
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to ten oxygen tanks, and ten hydrogen tanks."
	icon = 'icons/obj/structures/tank_dispenser.dmi'
	icon_state = "dispenser"
	density = TRUE
	anchored = TRUE
	material = /decl/material/solid/metal/steel
	tool_interaction_flags = TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT
	var/list/oxygen_tanks =   6
	var/list/hydrogen_tanks = 6

/obj/structure/tank_rack/Initialize()
	. = ..()

	if(isnum(oxygen_tanks) && oxygen_tanks > 0)
		var/spawn_oxy = oxygen_tanks
		oxygen_tanks = list()
		for(var/i in 1 to spawn_oxy)
			oxygen_tanks += weakref(new /obj/item/tank/oxygen(src))
	else
		oxygen_tanks = null

	if(isnum(hydrogen_tanks) && hydrogen_tanks > 0)
		var/spawn_hyd = hydrogen_tanks
		hydrogen_tanks = list()
		for(var/i in 1 to spawn_hyd)
			hydrogen_tanks += weakref(new /obj/item/tank/hydrogen(src))
	else
		hydrogen_tanks = null

	update_icon()

/obj/structure/tank_rack/examine(mob/user, distance)
	. = ..()
	to_chat(user, SPAN_NOTICE("It is holding [LAZYLEN(oxygen_tanks)] air tank\s and [LAZYLEN(hydrogen_tanks)] hydrogen tank\s."))

/obj/structure/tank_rack/Destroy()
	QDEL_NULL_LIST(hydrogen_tanks)
	QDEL_NULL_LIST(oxygen_tanks)
	return ..()

/obj/structure/tank_rack/dump_contents()
	hydrogen_tanks = null
	oxygen_tanks = null
	return ..()

/obj/structure/tank_rack/on_update_icon()
	..()

	var/oxycount = LAZYLEN(oxygen_tanks)
	switch(oxycount)
		if(1 to 3)
			add_overlay("oxygen-[oxycount]")
		if(4 to INFINITY)
			add_overlay("oxygen-4")

	var/hydrocount = LAZYLEN(hydrogen_tanks)
	switch(hydrocount)
		if(1 to 4)
			add_overlay("hydrogen-[hydrocount]")
		if(5 to INFINITY)
			add_overlay("hydrogen-5")

/obj/structure/tank_rack/attack_robot(mob/user)
	return attack_hand_with_interaction_checks(user)

/obj/structure/tank_rack/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return ..()
	var/list/dat = list()
	var/oxycount = LAZYLEN(oxygen_tanks)
	dat += "Oxygen tanks: [oxycount] - [oxycount ? "<A href='?src=\ref[src];oxygen=1'>Dispense</A>" : "empty"]<br>"
	var/hydrocount = LAZYLEN(hydrogen_tanks)
	dat += "Hydrogen tanks: [hydrocount] - [hydrocount ? "<A href='?src=\ref[src];hydrogen=1'>Dispense</A>" : "empty"]"
	var/datum/browser/popup = new(user, "window=tank_rack")
	popup.set_content(jointext(dat, "<br>"))
	popup.open()
	return TRUE

/obj/structure/tank_rack/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/tank))
		var/list/adding_to_list
		if(istype(I, /obj/item/tank/oxygen) || istype(I, /obj/item/tank/air))
			LAZYINITLIST(oxygen_tanks)
			adding_to_list = oxygen_tanks
		else if(istype(I, /obj/item/tank/hydrogen))
			LAZYINITLIST(hydrogen_tanks)
			adding_to_list = hydrogen_tanks
		if(LAZYLEN(adding_to_list) >= 10)
			to_chat(user, SPAN_WARNING("\The [src] is full."))
			UNSETEMPTY(adding_to_list)
			return TRUE
		if(!user.try_unequip(I, src))
			return TRUE
		LAZYADD(adding_to_list, weakref(I))
		to_chat(user, SPAN_NOTICE("You put [I] in [src]."))
		update_icon()
		attack_hand_with_interaction_checks(user)
		return TRUE
	return ..()

/obj/structure/tank_rack/OnTopic(mob/user, href_list, datum/topic_state/state)

	var/list/remove_tank_from
	if(href_list["oxygen"])
		remove_tank_from = oxygen_tanks
	else if(href_list["hydrogen"])
		remove_tank_from = hydrogen_tanks
	else
		return TOPIC_NOACTION

	if(LAZYLEN(remove_tank_from))
		var/weakref/tankref = remove_tank_from[length(remove_tank_from)]
		LAZYREMOVE(remove_tank_from, tankref)
		var/obj/item/tank/O = tankref?.resolve()
		if(istype(O) && !QDELETED(O) && O.loc == src)
			O.dropInto(loc)
			to_chat(user, SPAN_NOTICE("You take \the [O] out of \the [src]."))
			update_icon()
			attack_hand_with_interaction_checks(user)
		return TOPIC_REFRESH

/*
 * Mappable subtypes.
 */
/obj/structure/tank_rack/oxygen
	hydrogen_tanks = 0

/obj/structure/tank_rack/hydrogen
	oxygen_tanks = 0

/obj/structure/tank_rack/empty
	hydrogen_tanks = 0
	oxygen_tanks = 0
