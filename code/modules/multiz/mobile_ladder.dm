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

	var/turf/T = get_turf(A)
	if(!istype(T) || T.contains_dense_objects())
		return FALSE

	if(T.is_open())
		target = GetBelow(A)
		if(!istype(target))
			to_chat(user, SPAN_WARNING("There's nothing below you!"))
			return FALSE
		else if(target.contains_dense_objects())
			to_chat(user, SPAN_WARNING("Objects below block \the [src] from deploying!"))
			return FALSE
		else if(T.CanZPass(T,DOWN) && target.CanZPass(target,DOWN))
			to_chat(user, SPAN_WARNING("You can't find anything to support \the [src] on!"))
			return FALSE
	else if (istype(T, /turf/simulated/floor) || istype(T, /turf/unsimulated/floor))
		target = GetAbove(A)
		if(!istype(target) || !target.is_open() || target.contains_dense_objects())
			to_chat(user, SPAN_WARNING("There is something above \the [T]. You can't deploy \the [src]!"))
			return FALSE
		above = TRUE
	else
		to_chat(user, SPAN_WARNING("You can't place \the [src] there."))
		return FALSE

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
	ladder = new(T)
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
	if (QDELETED(A) || QDELETED(src))
		// Shit was deleted during delay, call is no longer valid.
		return FALSE
	return TRUE

/obj/structure/ladder/mobile
	name = "mobile ladder"
	desc = "A lightweight deployable ladder, it can be folded back into its portable form."
	base_icon = "mobile_ladder"
	climb_time = 4 SECONDS
	draw_shadow = FALSE
	tool_interaction_flags = 0
	material_alteration = 0

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
