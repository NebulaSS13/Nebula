/obj/item/mobile_ladder
	name = "mobile ladder"
	desc = "A lightweight deployable ladder, which you can use to move up or down. Or alternatively, you can bash some faces in."
	icon = 'icons/obj/mobile_ladder.dmi'
	icon_state = ICON_STATE_WORLD
	throw_range = 3
	force = 10
	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_BACK

/obj/item/mobile_ladder/proc/place_ladder(atom/A, mob/user)
	var/above = FALSE
	var/turf/target

	var/turf/T = A
	if(istype(T) && T.is_open())
		target = GetBelow(A)
		if(!istype(target) || !target.is_open())
			to_chat(user, SPAN_WARNING("There is nothing below you."))
			return FALSE
	else if (istype(A, /turf/simulated/floor) || istype(A, /turf/unsimulated/floor))
		target = GetAbove(A)
		if(!istype(target) || !target.is_open())
			to_chat(user, SPAN_WARNING("There is something above you. You can't deploy \the [src]!"))
			return FALSE
		above = TRUE

	if(above)
		user.visible_message(
			SPAN_NOTICE("\The [user] begins deploying \the [src] on \the [A]."),
			SPAN_NOTICE("You begin to deploy \the [src] on \the [A].")
		)
	else
		user.visible_message(
			SPAN_NOTICE("\The [user] begins to lower \the [src] into \the [A]."),
			SPAN_WARNING("You begin to lower \the [src] into \the [A].")
		)

	if (!handle_action(A, user))
		return

	var/obj/structure/ladder/mobile/ladder = new (target)
	transfer_fingerprints_to(ladder)
	ladder = new(get_turf(A))
	transfer_fingerprints_to(ladder)

	user.drop_from_inventory(src,get_turf(src))
	qdel(src)

/obj/item/mobile_ladder/afterattack(atom/A, mob/user,proximity)
	if (!proximity)
		return

	place_ladder(A,user)

/obj/item/mobile_ladder/proc/handle_action(atom/A, mob/user)
	if (!do_after(user, 30, user))
		return FALSE
	if (!QDELETED(A) || QDELETED(src))
		// Shit was deleted during delay, call is no longer valid.
		return FALSE
	return TRUE

/obj/structure/ladder/mobile
	base_icon = "mobile_ladder"
	climb_time = 4 SECONDS
	draw_shadow = FALSE
	tool_interaction_flags = 0

/obj/structure/ladder/mobile/verb/fold_ladder()
	set name = "Fold Ladder"
	set category = "Object"
	set src in oview(1)
	fold(usr)

/obj/structure/ladder/mobile/AltClick(mob/user)
	fold(user)

/obj/structure/ladder/mobile/proc/fold(mob/user)
	if(user)
		if(!CanPhysicallyInteract(user) || !ishuman(user))
			to_chat(user, SPAN_WARNING("You can't do that right now!"))
			return

		if(!user.check_dexterity(DEXTERITY_GRIP))
			return

		user.visible_message(
			SPAN_NOTICE("[user] starts folding up \the [src]."),
			SPAN_NOTICE("You start folding up \the [src]."))

		if(!do_after(user, 30, src))
			return

	var/obj/item/mobile_ladder/R = new(get_turf(user || src))
	if(user)
		user.put_in_hands(R)
		transfer_fingerprints_to(R)

		user.visible_message(
			SPAN_NOTICE("[user] folds \the [src]."),
			SPAN_NOTICE("You fold \the [src]."))

	if(target_down && istype(target_down, /obj/structure/ladder/mobile))
		QDEL_NULL(target_down)
		qdel(src)
	else if(target_up && istype(target_up, /obj/structure/ladder/mobile))
		QDEL_NULL(target_up)
		qdel(src)
