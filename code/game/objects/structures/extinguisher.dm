/obj/structure/extinguisher_cabinet
	name = "extinguisher cabinet"
	desc = "A small wall mounted cabinet designed to hold a fire extinguisher."
	icon = 'icons/obj/structures/extinguisher.dmi'
	icon_state = "extinguisher_closed"
	anchored = TRUE
	density = FALSE
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	directional_offset = @'{"NORTH":{"y":-29}, "SOUTH":{"y":29}, "EAST":{"x":-29}, "WEST":{"x":29}}'
	var/obj/item/chems/spray/extinguisher/has_extinguisher
	var/opened = 0

/obj/structure/extinguisher_cabinet/Initialize()
	. = ..()
	has_extinguisher = new/obj/item/chems/spray/extinguisher(src)

// TODO: I wanted to make it so you had to actually use your hand to open it if it's closed, but
// that'd be out of scope for just an attackby audit. Someone fix this so it can call parent please.
/obj/structure/extinguisher_cabinet/attackby(obj/item/used_item, mob/user)
	if(isrobot(user))
		return FALSE
	if(istype(used_item, /obj/item/chems/spray/extinguisher))
		if(!has_extinguisher && opened && user.try_unequip(used_item, src))
			has_extinguisher = used_item
			to_chat(user, "<span class='notice'>You place [used_item] in [src].</span>")
			playsound(src.loc, 'sound/effects/extin.ogg', 50, 0)
		else
			opened = !opened
	else
		opened = !opened
	update_icon()
	return TRUE


/obj/structure/extinguisher_cabinet/attack_hand(mob/user)

	if(user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE) && has_extinguisher)
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
	examine_desc = "open or close $TARGET_THEM$"

/decl/interaction_handler/extinguisher_cabinet_open/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/structure/extinguisher_cabinet/C = target
	C.opened = !C.opened
	C.update_icon()
