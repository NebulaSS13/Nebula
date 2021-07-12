/obj/item/assembly/mousetrap
	name = "rat trap"
	desc = "A handy little spring-loaded trap for catching pesty rodents."
	icon_state = "mousetrap"
	origin_tech = "{'combat':1}"
	material = /decl/material/solid/wood
	matter = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT)
	var/armed = 0

/obj/item/assembly/mousetrap/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_HEMOSTAT = TOOL_QUALITY_WORST))

/obj/item/assembly/mousetrap/examine(mob/user)
	. = ..()
	if(armed)
		to_chat(user, "It looks like it's armed.")

/obj/item/assembly/mousetrap/on_update_icon()
	if(armed)
		icon_state = "mousetraparmed"
	else
		icon_state = "mousetrap"
	if(holder)
		holder.update_icon()

/obj/item/assembly/mousetrap/proc/triggered(mob/target, var/type = "feet")
	if(!armed)
		return
	var/obj/item/organ/external/affecting = null
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		switch(type)
			if("feet")
				if(!H.shoes)
					affecting = H.get_organ(pick(BP_L_LEG, BP_R_LEG))
					SET_STATUS_MAX(H, STAT_WEAK, 3)
			if(BP_L_HAND, BP_R_HAND)
				if(!H.gloves)
					affecting = H.get_organ(type)
					SET_STATUS_MAX(H, STAT_STUN, 3)
		if(affecting)
			affecting.take_external_damage(1, 0)
			H.updatehealth()
	else if(ismouse(target))
		var/mob/living/simple_animal/mouse/M = target
		visible_message("<span class='danger'>SPLAT!</span>")
		M.splat()
	playsound(target.loc, 'sound/effects/snap.ogg', 50, 1)
	reset_plane_and_layer()
	armed = 0
	update_icon()
	pulse(0)

/obj/item/assembly/mousetrap/proc/toggle_arming(var/mob/user)
	if(!armed)
		to_chat(user, SPAN_NOTICE("You arm [src]."))
		return TRUE

	if((MUTATION_CLUMSY in user.mutations) && prob(50))
		var/which_hand = user.get_active_held_item_slot()
		triggered(user, which_hand)
		user.visible_message(SPAN_DANGER("\The [user] accidentally sets off [src], hurting their fingers."), \
							 SPAN_DANGER("You accidentally trigger [src]!"))
		return TRUE

	to_chat(user, SPAN_NOTICE("You disarm [src]."))
	armed = !armed
	update_icon()
	playsound(user.loc, 'sound/weapons/handcuffs.ogg', 30, 1, -3)
	return TRUE

/obj/item/assembly/mousetrap/attack_self(mob/user)
	. = toggle_arming(user) || ..()

/obj/item/assembly/mousetrap/attack_hand(mob/user)
	. = toggle_arming(user) || ..()

/obj/item/assembly/mousetrap/Crossed(atom/movable/AM)
	if(armed)
		if(ishuman(AM))
			var/mob/living/carbon/H = AM
			if(!MOVING_DELIBERATELY(H))
				triggered(H)
				H.visible_message("<span class='warning'>[H] accidentally steps on [src].</span>", \
								  "<span class='warning'>You accidentally step on [src]</span>")
		if(ismouse(AM))
			triggered(AM)
	..()


/obj/item/assembly/mousetrap/on_found(mob/finder)
	if(armed)
		finder.visible_message("<span class='warning'>[finder] accidentally sets off [src], breaking their fingers.</span>", \
							   "<span class='warning'>You accidentally trigger [src]!</span>")
		triggered(finder, finder.get_active_held_item_slot())
		return 1	//end the search!
	return 0


/obj/item/assembly/mousetrap/hitby(atom/A)
	..()
	if(armed)
		visible_message(SPAN_WARNING("\The [src] is triggered by \the [A]."))
		triggered(A)

/obj/item/assembly/mousetrap/armed
	icon_state = "mousetraparmed"
	armed = 1


/obj/item/assembly/mousetrap/verb/hide_under()
	set src in oview(1)
	set name = "Hide"
	set category = "Object"

	if(usr.incapacitated())
		return

	layer = MOUSETRAP_LAYER
	to_chat(usr, "<span class='notice'>You hide [src].</span>")
