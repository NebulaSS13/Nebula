/*
 * Pill Bottles
 */
/obj/item/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/items/storage/pillbottle.dmi'
	item_state = "contsolid"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 21
	can_hold = list(
		/obj/item/chems/pill,
		/obj/item/dice,
		/obj/item/paper
	)
	allow_quick_gather = 1
	use_to_pickup = 1
	use_sound = 'sound/effects/storage/pillbottle.ogg'
	material = /decl/material/solid/plastic

	var/pop_sound = 'sound/effects/peelz.ogg'
	var/wrapper_color
	var/label

/obj/item/storage/pill_bottle/remove_from_storage(obj/item/W, atom/new_location, NoUpdate)
	. = ..()
	if(. && pop_sound)
		playsound(get_turf(src), pop_sound, 50)

/obj/item/storage/pill_bottle/proc/pop_pill(var/mob/user)

	var/target_mouth = (user.zone_sel?.selecting == BP_MOUTH)
	if(target_mouth)
		if(!user.can_eat())
			to_chat(user, SPAN_WARNING("You can't eat anything!"))
			return TRUE
	else
		if(!user.get_empty_hand_slot())
			to_chat(user, SPAN_WARNING("You need an empty hand to take something from \the [src]."))
			return TRUE

	var/list/pills_here = filter_list(contents, /obj/item/chems/pill)
	if(!length(pills_here))
		to_chat(user, SPAN_WARNING("\The [src] is empty!"))
		return TRUE

	var/obj/item/chems/pill/pill = pick(pills_here)
	if(remove_from_storage(pill, user))
		if(target_mouth)
			user.visible_message(SPAN_NOTICE("\The [user] pops a pill from \the [src]."))
			pill.attack(user, user)
		else
			if(user.put_in_inactive_hand(pill))
				to_chat(user, SPAN_NOTICE("You take \the [pill] out of \the [src]."))
			else
				pill.dropInto(loc)
				to_chat(user, SPAN_DANGER("You fumble around with \the [src] and drop \the [pill]."))
	return TRUE

/obj/item/storage/pill_bottle/afterattack(mob/living/target, mob/living/user, proximity_flag)
	. = (proximity_flag && user == target && pop_pill(user)) || ..()

/obj/item/storage/pill_bottle/attack_self(mob/living/user)
	. = pop_pill(user) || ..()

/obj/item/storage/pill_bottle/Initialize()
	. = ..()
	update_icon()

/obj/item/storage/pill_bottle/on_update_icon()
	cut_overlays()
	if(wrapper_color)
		var/image/I = image(icon, "pillbottle_wrap")
		I.color = wrapper_color
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)