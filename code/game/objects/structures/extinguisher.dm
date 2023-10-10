/obj/structure/extinguisher_cabinet
	name = "extinguisher cabinet"
	desc = "A small wall mounted cabinet designed to hold a fire extinguisher."
	icon = 'icons/obj/structures/extinguisher.dmi'
	icon_state = "extinguisher_closed"
	anchored = 1
	density = 0
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	directional_offset = "{'NORTH':{'y':-29}, 'SOUTH':{'y':29}, 'EAST':{'x':-29}, 'WEST':{'x':29}}"
	var/obj/item/chems/spray/extinguisher/has_extinguisher
	var/opened = 0

/obj/structure/extinguisher_cabinet/Initialize()
	. = ..()
	has_extinguisher = new/obj/item/chems/spray/extinguisher(src)

/obj/structure/extinguisher_cabinet/attackby(obj/item/O, mob/user)
	if(isrobot(user))
		return
	if(istype(O, /obj/item/chems/spray/extinguisher))
		if(!has_extinguisher && opened && user.try_unequip(O, src))
			has_extinguisher = O
			to_chat(user, "<span class='notice'>You place [O] in [src].</span>")
			playsound(src.loc, 'sound/effects/extin.ogg', 50, 0)
		else
			opened = !opened
	else
		opened = !opened
	update_icon()


/obj/structure/extinguisher_cabinet/attack_hand(mob/user)

	if(user.check_dexterity(DEXTERITY_GRIP, TRUE) && has_extinguisher)
		user.put_in_hands(has_extinguisher)
		to_chat(user, SPAN_NOTICE("You take [has_extinguisher] from [src]."))
		playsound(src.loc, 'sound/effects/extout.ogg', 50, 0)
		has_extinguisher = null
		opened = TRUE
		update_icon()
		return TRUE

	if(user.check_dexterity(DEXTERITY_SIMPLE_MACHINES, TRUE))
		opened = !opened
		update_icon()
		return TRUE

	return ..()

/obj/structure/extinguisher_cabinet/on_update_icon()
	..()
	if(!opened)
		icon_state = "extinguisher_closed"
		return
	if(has_extinguisher)
		if(istype(has_extinguisher, /obj/item/chems/spray/extinguisher/mini))
			icon_state = "extinguisher_mini"
		else
			icon_state = "extinguisher_full"
	else
		icon_state = "extinguisher_empty"

/obj/structure/extinguisher_cabinet/do_simple_ranged_interaction(var/mob/user)
	if(has_extinguisher)
		has_extinguisher.dropInto(loc)
		has_extinguisher = null
		opened = 1
	else
		opened = !opened
	update_icon()
	return TRUE

/obj/structure/extinguisher_cabinet/get_alt_interactions(var/mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/extinguisher_cabinet_open)

/decl/interaction_handler/extinguisher_cabinet_open
	name = "Open/Close"
	expected_target_type = /obj/structure/extinguisher_cabinet

/decl/interaction_handler/extinguisher_cabinet_open/invoked(var/atom/target, var/mob/user)
	var/obj/structure/extinguisher_cabinet/C = target
	C.opened = !C.opened
	C.update_icon()
