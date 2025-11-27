/obj/structure/skele_stand
	name = "hanging skeleton model"
	density = TRUE
	icon = 'icons/obj/surgery.dmi'
	icon_state = "hangskele"
	desc = "It's an anatomical model of a human skeletal system made of plaster."
	var/list/swag = list()
	var/cooldown

/obj/structure/skele_stand/Initialize()
	. = ..()
	set_gender(pick(MALE, FEMALE, PLURAL))

/obj/structure/skele_stand/proc/rattle_bones(mob/user, atom/thingy)
	if((world.time - cooldown) <= 1 SECOND)
		return //reduces spam.

	var/decl/pronouns/pronouns = get_pronouns()
	if(user)
		if(thingy)
			visible_message(SPAN_NOTICE("\The [user] pushes \the [src] with \the [thingy], giving the bones a good rattle."))
		else
			visible_message(SPAN_NOTICE("\The [user] pushes \the [src], giving the bones a good rattle."))
	else
		if(thingy)
			visible_message(SPAN_NOTICE("\The [src] rattles on [pronouns.his] stand as [pronouns.he] [pronouns.is] hit by \the [thingy]."))
		else
			visible_message(SPAN_NOTICE("\The [src] rattles on [pronouns.his] stand."))

	cooldown = world.time
	playsound(loc, 'sound/effects/bonerattle.ogg', 40)

/obj/structure/skele_stand/attack_hand(mob/user)
	if(length(swag) && user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		var/obj/item/clothing/C = input("What piece of clothing do you want to remove?", "Skeleton Undressing") as null|anything in list_values(swag)
		if(C)
			swag -= get_key_by_value(swag, C)
			user.put_in_hands(C)
			to_chat(user, SPAN_NOTICE("You take \the [C] off \the [src]."))
			update_icon()
		return TRUE
	if(user.check_dexterity(DEXTERITY_SIMPLE_MACHINES, TRUE))
		rattle_bones(user, null)
		return TRUE
	return ..()

/obj/structure/skele_stand/Bumped(atom/thing)
	rattle_bones(null, thing)

/obj/structure/skele_stand/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(swag.len)
		var/list/swagnames = list()
		for(var/slot in swag)
			var/obj/item/clothing/C = swag[slot]
			swagnames += C.get_examine_line()
		var/decl/pronouns/stand_pronouns = get_pronouns()
		. += "[stand_pronouns.He] [stand_pronouns.is] wearing [english_list(swagnames)]."

/obj/structure/skele_stand/attackby(obj/item/used_item, mob/user)
	if(IS_PEN(used_item))
		var/nuname = sanitize(input(user,"What do you want to name this skeleton as?","Skeleton Christening",name) as text|null)
		if(nuname && CanPhysicallyInteract(user))
			SetName(nuname)
			return TRUE
	if(istype(used_item,/obj/item/clothing))
		var/obj/item/clothing/clothes = used_item
		if(!clothes.fallback_slot)
			return FALSE
		if(swag[clothes.fallback_slot])
			to_chat(user,SPAN_NOTICE("There is already that kind of clothing on \the [src]."))
		else if(user.try_unequip(used_item, src))
			swag[clothes.fallback_slot] = used_item
			update_icon()
		return TRUE
	. = ..()
	if(!.)
		rattle_bones(user, used_item)
		return TRUE

/obj/structure/skele_stand/Destroy()
	for(var/slot in swag)
		var/obj/item/I = swag[slot]
		I.forceMove(loc)
	. = ..()

/obj/structure/skele_stand/on_update_icon()
	..()
	for(var/slot in swag)
		var/obj/item/I = swag[slot]
		if(I)
			add_overlay(I.get_mob_overlay(null, slot))