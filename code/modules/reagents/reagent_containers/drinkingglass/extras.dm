/obj/item/chems/drinks/glass2/attackby(obj/item/used_item, mob/user)
	if(extras.len >= 2) return ..() // max 2 extras, one on each side of the drink

	if(istype(used_item, /obj/item/glass_extra))
		var/obj/item/glass_extra/GE = used_item
		if(!can_add_extra(GE))
			to_chat(user, "<span class=warning>There's no space to put \the [GE] on \the [src]!</span>")
			return TRUE
		extras += GE
		if(!user.try_unequip(GE, src))
			return TRUE
		to_chat(user, "<span class=notice>You add \the [GE] to \the [src].</span>")
		update_icon()
		return TRUE
	else if(istype(used_item, /obj/item/food/processed_grown/slice))
		if(!rim_pos)
			to_chat(user, "<span class=warning>There's no space to put \the [used_item] on \the [src]!</span>")
			return TRUE
		var/obj/item/food/processed_grown/slice/FS = used_item
		extras += FS
		if(!user.try_unequip(FS, src))
			return TRUE
		reset_offsets(0) // Reset its pixel offsets so the icons work!
		to_chat(user, "<span class=notice>You add \the [FS] to \the [src].</span>")
		update_icon()
		return TRUE
	else
		return ..()

/obj/item/chems/drinks/glass2/attack_hand(mob/user)
	if(!user.is_holding_offhand(src) || !user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()

	if(!extras.len)
		to_chat(user, SPAN_WARNING("There's nothing on the glass to remove!"))
		return TRUE

	var/choice = input(user, "What would you like to remove from the glass?") as null|anything in extras
	if(!choice || !(choice in extras))
		return TRUE

	user.put_in_active_hand(choice)
	to_chat(user, SPAN_NOTICE("You remove \the [choice] from \the [src]."))
	extras -= choice
	update_icon()
	return TRUE

/obj/item/glass_extra
	abstract_type = /obj/item/glass_extra
	name = "generic glass addition"
	desc = "This goes on a glass."
	var/glass_addition
	var/glass_desc
	w_class = ITEM_SIZE_TINY
	icon = 'icons/obj/drink_glasses/extras.dmi'
	material = /decl/material/solid/organic/plastic

/obj/item/glass_extra/stick
	name = "stick"
	desc = "This goes in a glass."
	glass_addition = "stick"
	glass_desc = "There is a stick in the glass."
	icon_state = "stick"
	color = COLOR_BLACK

/obj/item/glass_extra/stick/Initialize()
	. = ..()
	if(prob(50))
		color = get_random_colour(0,50,150)

/obj/item/glass_extra/straw
	name = "straw"
	desc = "This goes in a glass."
	glass_addition = "straw"
	glass_desc = "There is a straw in the glass."
	icon_state = "straw"
