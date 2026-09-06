/obj/structure/armor_stand
	name                     = "armor stand"
	desc                     = "A simple stand used to hold armor and helmets for display."
	icon                     = 'icons/obj/structures/armor_stand.dmi'
	icon_state               = ICON_STATE_WORLD
	anchored                 = TRUE
	density                  = TRUE
	material                 = /decl/material/solid/organic/wood/oak
	material_alteration      = MAT_FLAG_ALTERATION_ALL
	var/list/slots_to_gear   = list(
		(slot_wear_suit_str) = null,
		(slot_head_str)      = null,
		(slot_belt_str)      = null,
		(slot_shoes_str)     = null,
		(slot_gloves_str)    = null
	)
	var/list/gear_to_slot

/obj/structure/armor_stand/Exited(atom/movable/AM, atom/new_loc)
	. = ..()
	var/weakref/atom_ref = weakref(AM)
	if(atom_ref in gear_to_slot)
		var/slot = gear_to_slot[atom_ref]
		slots_to_gear[slot] = null
		LAZYREMOVE(gear_to_slot, atom_ref)
		update_icon()

/obj/structure/armor_stand/Destroy()
	slots_to_gear.Cut()
	LAZYCLEARLIST(gear_to_slot)
	. = ..()

/obj/structure/armor_stand/attack_hand(mob/user)
	. = ..()
	if(. || !LAZYLEN(gear_to_slot))
		return
	var/weakref/removed_item_ref
	if(LAZYLEN(gear_to_slot) == 1)
		removed_item_ref = gear_to_slot[1]
	else
		removed_item_ref = input(user, "Which piece of equipment would you like to remove?", "Armor Stand") as null|anything in gear_to_slot
		if(!CanPhysicallyInteract(user) || QDELETED(src) || QDELETED(user) || !(removed_item_ref in gear_to_slot))
			return TRUE
	var/obj/item/removed_item = removed_item_ref?.resolve()
	if(istype(removed_item) && !QDELETED(removed_item) && removed_item.loc == src)
		removed_item.dropInto(loc)
		user.put_in_hands(removed_item)
	return TRUE

/obj/structure/armor_stand/attackby(obj/item/used_item, mob/user)
	if(istype(used_item, /obj/item/clothing))
		var/obj/item/clothing/clothes = used_item
		if(!(clothes.fallback_slot in slots_to_gear))
			to_chat(user, SPAN_WARNING("\The [src] cannot hold \the [used_item]."))
		else if(slots_to_gear[clothes.fallback_slot])
			var/weakref/atom_ref = slots_to_gear[clothes.fallback_slot]
			to_chat(user, SPAN_WARNING("\The [src] is already holding \the [atom_ref.resolve()]."))
		else if(user.try_unequip(clothes, src))
			var/weakref/atom_ref = weakref(clothes)
			slots_to_gear[clothes.fallback_slot] = atom_ref
			LAZYSET(gear_to_slot, atom_ref, clothes.fallback_slot)
			to_chat(user, SPAN_NOTICE("You hang \the [clothes] from \the [src]."))
			update_icon()
		return TRUE
	return ..()

/obj/structure/armor_stand/on_update_icon()
	. = ..()
	for(var/slot in slots_to_gear)
		var/weakref/atom_ref = slots_to_gear[slot]
		var/obj/item/thing = atom_ref?.resolve()
		if(istype(thing))
			var/image/mob_overlay = thing.get_mob_overlay(null, slot)
			mob_overlay.appearance_flags |= RESET_COLOR
			add_overlay(mob_overlay)
	compile_overlays()
