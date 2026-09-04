/obj/structure/coatrack
	name = "coat rack"
	desc = "A rack that holds coats."
	icon = 'icons/obj/structures/coatrack.dmi'
	icon_state = "coatrack0"
	material = /decl/material/solid/organic/wood/mahogany
	color = /decl/material/solid/organic/wood/mahogany::color
	material_alteration =    (MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_COLOR)
	tool_interaction_flags = TOOL_INTERACTION_DECONSTRUCT
	var/max_items = 3
	var/tmp/list/slots_allowed
	var/tmp/list/blacklisted_types = list(/obj/item/clothing/suit/space)

/obj/structure/coatrack/ebony
	material = /decl/material/solid/organic/wood/ebony
	color = /decl/material/solid/organic/wood/ebony::color

/obj/structure/coatrack/dismantle_structure(mob/user)
	for(var/obj/item/thing in contents)
		thing.dropInto(loc)
	. = ..()

/obj/structure/coatrack/Initialize(ml, _mat, _reinf_mat)
	slots_allowed = list(
		"[slot_wear_suit_str]" = SLOT_OVER_BODY,
		"[slot_head_str]" = SLOT_HEAD
	)
	. = ..()

/obj/structure/coatrack/on_update_icon()
	..()
	var/offset = -3
	for(var/obj/item/thing in contents)
		for(var/slot in slots_allowed)
			if(thing.slot_flags & slots_allowed[slot])
				var/image/I = thing.get_mob_overlay(null, slot)
				if(I)
					I.pixel_z += offset
					add_overlay(I)
					offset += 3
				break

/obj/structure/coatrack/attack_hand(mob/user)
	if(!length(contents) || !user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()
	var/obj/item/removing = contents[contents.len]
	user.visible_message( \
		SPAN_NOTICE("\The [user] takes \the [removing] off \the [src]."),
		SPAN_NOTICE("You take \the [removing] off \the [src].")
	)
	removing.dropInto(loc)
	user.put_in_active_hand(removing)
	update_icon()
	return TRUE

/obj/structure/coatrack/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(length(contents))
		. += SPAN_NOTICE("It has the following [length(contents) == 1 ? "article" : "articles"] hanging on it:")
		for(var/obj/item/thing in contents)
			. += "- \icon[thing] \The [thing]."

/obj/structure/coatrack/proc/can_hang(var/obj/item/thing)
	if(!istype(thing))
		return FALSE
	for(var/blacklisted_type in blacklisted_types)
		if(istype(thing, blacklisted_type))
			return FALSE
	for(var/slot in slots_allowed)
		if(thing.slot_flags & slots_allowed[slot])
			return TRUE

/obj/structure/coatrack/attackby(obj/item/used_item, mob/user)
	if(!can_hang(used_item))
		return ..()
	if(length(contents) >= max_items)
		to_chat(user, SPAN_NOTICE("There is no room on \the [src] to hang \the [used_item]."))
		return TRUE
	if(user.try_unequip(used_item, src))
		user.visible_message( \
			SPAN_NOTICE("\The [user] hangs \the [used_item] on \the [src]."), \
			SPAN_NOTICE("You hang \the [used_item] on \the [src].") \
		)
		update_icon()
	return TRUE

/obj/structure/coatrack/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(can_hang(mover) && length(contents) < max_items)
		visible_message(SPAN_NOTICE("\The [mover] lands on \the [src]!"))
		mover.forceMove(src)
		update_icon()
		return FALSE
	return TRUE
