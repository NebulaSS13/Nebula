///////////////////////////
// Dost thou even hoist? //
///////////////////////////

#define NORMAL_LAYER 3

/obj/item/hoist_kit
	name = "hoist kit"
	desc = "A setup kit for a hoist that can be used to lift things. The hoist will deploy in the direction you're facing."
	icon = 'icons/obj/hoists.dmi'
	icon_state = "hoist_case"

/obj/item/hoist_kit/attack_self(mob/user)
	if (!do_after(usr, (2 SECONDS), src))
		return

	var/obj/structure/hoist/hoist = new (get_turf(user), user.dir)
	transfer_fingerprints_to(hoist)
	user.visible_message(
		SPAN_NOTICE("[user] deploys the hoist kit!"),
		SPAN_NOTICE("You deploy the hoist kit!"),
		"You hear the sound of parts snapping into place.")
	qdel(src)

/obj/effect/hoist_hook
	name = "hoist clamp"
	desc = "A clamp used to lift people or things."
	icon = 'icons/obj/hoists.dmi'
	icon_state = "hoist_hook"
	can_buckle = TRUE
	anchored = TRUE
	simulated = FALSE

	var/obj/structure/hoist/source_hoist

/obj/effect/hoist_hook/attack_hand(mob/living/user)
	return // no, bad

/obj/effect/hoist_hook/MouseDrop_T(atom/movable/AM,mob/user)
	if (issilicon(user))
		return

	if (!AM.simulated || AM.anchored)
		to_chat(user, SPAN_WARNING("You can't do that with \the [AM]."))
		return
	if (source_hoist.hoistee)
		to_chat(user, SPAN_NOTICE("\The [source_hoist.hoistee] is already attached to \the [src]!"))
		return
	source_hoist.attach_hoistee(AM)
	user.visible_message(
		SPAN_NOTICE("[user] attaches \the [AM] to \the [src]."),
		SPAN_NOTICE("You attach \the [AM] to \the [src]."),
		"You hear something clamp into place.")

/obj/structure/hoist/proc/attach_hoistee(atom/movable/AM)
	hoistee = AM
	if(ismob(AM))
		source_hook.buckle_mob(AM)
	AM.anchored = TRUE // why isn't this being set by buckle_mob for silicons?
	source_hook.layer = AM.layer + 0.1
	if (get_turf(AM) != get_turf(source_hook))
		AM.forceMove(get_turf(source_hook))

	GLOB.destroyed_event.register(AM, src, .proc/release_hoistee)

/obj/effect/hoist_hook/MouseDrop(atom/dest)
	..()
	if(!Adjacent(usr) || !dest.Adjacent(usr)) return // carried over from the default proc

	if (!ishuman(usr))
		return

	if (usr.incapacitated())
		to_chat(usr, SPAN_WARNING("You can't do that while incapacitated."))
		return

	if (!usr.check_dexterity(DEXTERITY_GRIP))
		return

	if (!source_hoist.hoistee)
		return
	if (!isturf(dest))
		return
	if (!dest.Adjacent(source_hoist.hoistee))
		return

	source_hoist.check_consistency()

	var/turf/desturf = dest
	source_hoist.hoistee.forceMove(desturf)
	usr.visible_message(
		SPAN_NOTICE("[usr] detaches \the [source_hoist.hoistee] from the hoist clamp."),
		SPAN_NOTICE("You detach \the [source_hoist.hoistee] from the hoist clamp."),
		"You hear something unclamp.")
	source_hoist.release_hoistee()

// This will handle mobs unbuckling themselves.
/obj/effect/hoist_hook/unbuckle_mob()
	. = ..()
	if (. && !QDELETED(source_hoist))
		var/mob/M = .
		source_hoist.hoistee = null
		M.fall(get_turf(src))	// fuck you, you fall now!

/obj/structure/hoist
	name = "hoist"
	desc = "A manual hoist, uses a clamp and pulley to hoist things."
	icon = 'icons/obj/hoists.dmi'
	icon_state = "hoist_base"
	density = TRUE
	anchored = TRUE

	var/broken = FALSE
	var/atom/movable/hoistee
	var/movedir = UP
	var/obj/effect/hoist_hook/source_hook

/obj/structure/hoist/Initialize(mapload, ndir)
	. = ..()
	set_dir(ndir)
	var/turf/newloc = get_step(src, dir)
	source_hook = new(newloc)
	source_hook.source_hoist = src

/obj/structure/hoist/Destroy()
	if(hoistee)
		release_hoistee()
	QDEL_NULL(src.source_hook)
	return ..()

/obj/effect/hoist_hook/Destroy()
	source_hoist = null
	return ..()

/obj/structure/hoist/proc/check_consistency()
	if (!hoistee)
		return
	if (hoistee.z != source_hook.z)
		release_hoistee()
		return

/obj/structure/hoist/proc/release_hoistee()
	if(ismob(hoistee))
		source_hook.unbuckle_mob(hoistee)
	else
		hoistee.anchored = FALSE
	GLOB.destroyed_event.unregister(hoistee, src)
	hoistee = null
	layer = initial(layer)

/obj/structure/hoist/proc/break_hoist()
	if(broken)
		return
	broken = TRUE
	desc += " It looks broken, and the clamp has retracted back into the hoist. Seems like you'd have to re-deploy it to get it to work again."
	if(hoistee)
		release_hoistee()
	QDEL_NULL(source_hook)

/obj/structure/hoist/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
			else
				visible_message("\The [src] shakes violently, and neatly collapses as its damage sensors go off.")
				collapse_kit()
			return
		if(3.0)
			if(prob(50) && !broken)
				break_hoist()
			return

/obj/effect/hoist_hook/ex_act(severity)
	switch(severity)
		if(1.0)
			source_hoist.break_hoist()
			return
		if(2.0)
			if(prob(50))
				source_hoist.break_hoist()
			return
		if(3.0)
			if(prob(25))
				source_hoist.break_hoist()
			return


/obj/structure/hoist/attack_hand(mob/living/user)
	if (!ishuman(user))
		return

	if (user.incapacitated())
		to_chat(user, SPAN_WARNING("You can't do that while incapacitated."))
		return

	if (!user.check_dexterity(DEXTERITY_GRIP))
		return

	if(broken)
		to_chat(user, SPAN_WARNING("The hoist is broken!"))
		return
	var/can = can_move_dir(movedir)
	var/movtext = movedir == UP ? "raise" : "lower"
	if (!can) // If you can't...
		movedir = movedir == UP ? DOWN : UP // switch directions!
		to_chat(user, SPAN_NOTICE("You switch the direction of the pulley."))
		return

	if (!hoistee)
		user.visible_message(
			SPAN_NOTICE("[user] begins to [movtext] the clamp."),
			SPAN_NOTICE("You begin to [movtext] the clamp."),
			SPAN_NOTICE("You hear the sound of a crank."))
		move_dir(movedir, 0)
		return

	check_consistency()

	var/size
	if (ismob(hoistee))
		var/mob/M = hoistee
		size = M.mob_size
	else if (isobj(hoistee))
		var/obj/O = hoistee
		size = O.w_class

	user.visible_message(
		SPAN_NOTICE("[user] begins to [movtext] \the [hoistee]!"),
		SPAN_NOTICE("You begin to [movtext] \the [hoistee]!"),
		SPAN_NOTICE("You hear the sound of a crank."))
	if (do_after(user, (1 SECONDS) * size / 4, src))
		move_dir(movedir, 1)

/obj/structure/hoist/proc/collapse_kit(mob/user)
	var/obj/item/hoist_kit/kit = new (get_turf(src))
	if(user)
		transfer_fingerprints_to(kit)
	qdel(src)

/obj/structure/hoist/verb/collapse_hoist()
	set name = "Collapse Hoist"
	set category = "Object"
	set src in range(1)

	if (!ishuman(usr))
		return

	if (isobserver(usr) || usr.incapacitated())
		return
	if (!usr.check_dexterity(DEXTERITY_GRIP))
		return

	if (hoistee)
		to_chat(usr, SPAN_NOTICE("You cannot collapse the hoist with \the [hoistee] attached!"))
		return

	if (!do_after(usr, (2 SECONDS), src))
		return

	collapse_kit()

/obj/structure/hoist/proc/can_move_dir(direction)
	var/turf/dest = direction == UP ? GetAbove(source_hook) : GetBelow(source_hook)
	switch(direction)
		if (UP)
			if (!isopenspace(dest)) // can't move into a solid tile
				return 0
			if (source_hook in get_step(src, dir)) // you don't get to move above the hoist
				return 0
		if (DOWN)
			if (!isopenspace(get_turf(source_hook))) // can't move down through a solid tile
				return 0
	if (!dest) // can't move if there's nothing to move to
		return 0
	return 1 // i thought i could trust myself to write something as simple as this, guess i was wrong

/obj/structure/hoist/proc/move_dir(direction, ishoisting)
	var/can = can_move_dir(direction)
	if (!can)
		return 0
	var/turf/move_dest = direction == UP ? GetAbove(source_hook) : GetBelow(source_hook)
	source_hook.forceMove(move_dest)
	if (!ishoisting)
		return 1
	hoistee.hoist_act(move_dest)
	return 1

/atom/movable/proc/hoist_act(turf/dest)
	forceMove(dest)
	return TRUE

#undef NORMAL_LAYER
