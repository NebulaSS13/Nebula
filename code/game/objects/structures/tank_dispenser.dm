/obj/structure/dispenser
	name = "tank storage unit"
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to ten oxygen tanks, and ten hydrogen tanks."
	icon = 'icons/obj/structures/tank_dispenser.dmi'
	icon_state = "dispenser"
	density = 1
	anchored = 1.0
	tool_interaction_flags = TOOL_INTERACTION_ANCHOR

	var/oxygentanks = 10
	var/hydrogentanks = 10
	var/list/oxytanks = list()	//sorry for the similar var names
	var/list/hydtanks = list()

/obj/structure/dispenser/oxygen
	hydrogentanks = 0

/obj/structure/dispenser/hydrogen
	oxygentanks = 0

/obj/structure/dispenser/Initialize()
	. = ..()
	update_icon()

/obj/structure/dispenser/on_update_icon()
	overlays.Cut()
	switch(oxygentanks)
		if(1 to 3)	overlays += "oxygen-[oxygentanks]"
		if(4 to INFINITY) overlays += "oxygen-4"
	switch(hydrogentanks)
		if(1 to 4)	overlays += "hydrogen-[hydrogentanks]"
		if(5 to INFINITY) overlays += "hydrogen-5"

/obj/structure/dispenser/attack_ai(mob/user)
	if(user.Adjacent(src))
		return attack_hand(user)
	..()

/obj/structure/dispenser/attack_hand(mob/user)
	user.set_machine(src)
	var/dat = "[src]<br><br>"
	dat += "Oxygen tanks: [oxygentanks] - [oxygentanks ? "<A href='?src=\ref[src];oxygen=1'>Dispense</A>" : "empty"]<br>"
	dat += "Hydrogen tanks: [hydrogentanks] - [hydrogentanks ? "<A href='?src=\ref[src];hydrogen=1'>Dispense</A>" : "empty"]"
	show_browser(user, dat, "window=dispenser")
	onclose(user, "dispenser")
	return


/obj/structure/dispenser/attackby(obj/item/I, mob/user)
	. = ..()
	if(!.)
		if(istype(I, /obj/item/tank/oxygen) || istype(I, /obj/item/tank/air))
			if(oxygentanks < 10)
				if(!user.unEquip(I, src))
					return
				oxytanks.Add(I)
				oxygentanks++
				to_chat(user, "<span class='notice'>You put [I] in [src].</span>")
				if(oxygentanks < 5)
					update_icon()
			else
				to_chat(user, "<span class='notice'>[src] is full.</span>")
			updateUsrDialog()
			return
		if(istype(I, /obj/item/tank/hydrogen))
			if(hydrogentanks < 10)
				if(!user.unEquip(I, src))
					return
				hydtanks.Add(I)
				hydrogentanks++
				to_chat(user, "<span class='notice'>You put [I] in [src].</span>")
				if(oxygentanks < 6)
					update_icon()
			else
				to_chat(user, "<span class='notice'>[src] is full.</span>")
			updateUsrDialog()
			return

/obj/structure/dispenser/Topic(href, href_list)
	if(usr.stat || usr.restrained())
		return
	if(Adjacent(usr))
		usr.set_machine(src)
		if(href_list["oxygen"])
			if(oxygentanks > 0)
				var/obj/item/tank/oxygen/O
				if(oxytanks.len == oxygentanks)
					O = oxytanks[1]
					oxytanks.Remove(O)
				else
					O = new /obj/item/tank/oxygen(loc)
				O.dropInto(loc)
				to_chat(usr, "<span class='notice'>You take [O] out of [src].</span>")
				oxygentanks--
				update_icon()
		if(href_list["hydrogen"])
			if(hydrogentanks > 0)
				var/obj/item/tank/hydrogen/P
				if(hydtanks.len == hydrogentanks)
					P = hydtanks[1]
					hydtanks.Remove(P)
				else
					P = new /obj/item/tank/hydrogen(loc)
				P.dropInto(loc)
				to_chat(usr, "<span class='notice'>You take [P] out of [src].</span>")
				hydrogentanks--
				update_icon()
		add_fingerprint(usr)
		updateUsrDialog()
	else
		close_browser(usr, "window=dispenser")
		return
	return
