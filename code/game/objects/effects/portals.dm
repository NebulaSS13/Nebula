/obj/effect/portal
	name = "portal"
	desc = "Looks unstable. Best to test it with the clown."
	icon = 'icons/effects/portal.dmi'
	icon_state = "portal"
	density = TRUE
	anchored = TRUE
	unacidable = TRUE // Can't destroy energy portals.
	var/obj/item/target = null
	var/dangerous = FALSE
	var/failchance = 0

/obj/effect/portal/Bumped(atom/movable/AM)
	teleport(AM)

/obj/effect/portal/Crossed(atom/movable/AM)
	teleport(AM)

/obj/effect/portal/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	teleport(user)
	return TRUE

/obj/effect/portal/Initialize(mapload, end, delete_after = 300, failure_rate)
	. = ..()
	setup_portal(end, delete_after, failure_rate)

/obj/effect/portal/proc/setup_portal(end, delete_after, failure_rate)
	if(failure_rate)
		failchance = failure_rate
		if(prob(failchance))
			icon_state = "portal1"
			dangerous = 1
	playsound(src, 'sound/effects/phasein.ogg', 25, 1)
	target = end
	events_repository.register(/decl/observ/moved, src, src, /datum/proc/qdel_self)

	if(delete_after)
		QDEL_IN(src, delete_after)

/obj/effect/portal/Destroy()
	target = null
	events_repository.unregister(/decl/observ/moved, src, src)
	. = ..()

/obj/effect/portal/proc/teleport(atom/movable/M)
	if(iseffect(M))
		return

	if(!ismovable(M))
		return

	if(icon_state == "portal1")
		return

	if(!target)
		qdel(src)
		return

	if(dangerous && prob(failchance))
		var/destination_z = global.using_map.get_transit_zlevel(z)
		do_teleport(M, locate(rand(TRANSITIONEDGE, world.maxx - TRANSITIONEDGE), rand(TRANSITIONEDGE, world.maxy -TRANSITIONEDGE), destination_z), 0)
	else
		do_teleport(M, target, 1)
