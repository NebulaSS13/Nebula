/obj/structure/skele_stand
	name = "hanging skeleton model"
	density = 1
	icon = 'icons/obj/surgery.dmi'
	icon_state = "hangskele"
	desc = "It's an anatomical model of a human skeletal system made of plaster."
	var/list/swag = list()
	var/cooldown

/obj/structure/skele_stand/Initialize()
	. = ..()
	gender = pick(MALE, FEMALE, PLURAL)

/obj/structure/skele_stand/proc/rattle_bones(mob/user, atom/thingy)
	if((world.time - cooldown) <= 1 SECOND)
		return //reduces spam.

	var/decl/pronouns/G = get_pronouns()
	if(user)
		if(thingy)
			visible_message(SPAN_NOTICE("\The [user] pushes \the [src] with \the [thingy], giving the bones a good rattle."))
		else
			visible_message(SPAN_NOTICE("\The [user] pushes \the [src], giving the bones a good rattle."))
	else
		if(thingy)
			visible_message(SPAN_NOTICE("\The [src] rattles on [G.his] stand as [G.he] [G.is] hit by \the [thingy]."))
		else
			visible_message(SPAN_NOTICE("\The [src] rattles on [G.his] stand."))

	cooldown = world.time
	playsound(loc, 'sound/effects/bonerattle.ogg', 40)

/obj/structure/skele_stand/attack_hand(mob/user)
	if(length(swag) && user.check_dexterity(DEXTERITY_GRIP, TRUE))
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

/obj/structure/skele_stand/examine(mob/user)
	. = ..()
	if(swag.len)
		var/list/swagnames = list()
		for(var/slot in swag)
			var/obj/item/clothing/C = swag[slot]
			swagnames += C.get_examine_line()
		to_chat(user,"[gender == MALE ? "He" : "She"] is wearing [english_list(swagnames)].")

/obj/structure/skele_stand/attackby(obj/item/W, mob/user)
	if(IS_PEN(W))
		var/nuname = sanitize(input(user,"What do you want to name this skeleton as?","Skeleton Christening",name) as text|null)
		if(nuname && CanPhysicallyInteract(user))
			SetName(nuname)
			return 1
	if(istype(W,/obj/item/clothing))
		var/slot
		if(istype(W, /obj/item/clothing/under))
			slot = slot_w_uniform_str
		else if(istype(W, /obj/item/clothing/suit))
			slot = slot_wear_suit_str
		else if(istype(W, /obj/item/clothing/head))
			slot = slot_head_str
		else if(istype(W, /obj/item/clothing/shoes))
			slot = slot_shoes_str
		else if(istype(W, /obj/item/clothing/mask))
			slot = slot_wear_mask_str
		if(slot)
			if(swag[slot])
				to_chat(user,"<span class='notice'>There is already that kind of clothing on \the [src].</span>")
			else if(user.try_unequip(W, src))
				swag[slot] = W
				update_icon()
				return 1
	else
		rattle_bones(user, W)

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