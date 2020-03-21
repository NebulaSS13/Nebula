/obj/effect/portal
	name = "portal"
	desc = "Looks unstable. Best to test it with the clown."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "portal"
	density = 1
	unacidable = 1//Can't destroy energy portals.
	var/obj/item/target = null
	var/creator = null
	anchored = TRUE
	var/dangerous = 0
	var/failchance = 0

// Spawns hack around call ordering; don't replace with waitfor without testing.
/obj/effect/portal/Bumped(mob/M)
	spawn(0)
		teleport(M)

/obj/effect/portal/Crossed(atom/movable/AM)
	spawn(0)
		teleport(AM)

/obj/effect/portal/attack_hand(mob/user)
	teleport(user)
	return TRUE

/obj/effect/portal/Initialize(mapload, var/end, var/delete_after = 300, var/failure_rate)
	. = ..()
	if(failure_rate)
		failchance = failure_rate
		if(prob(failchance))
			icon_state = "portal1"
			dangerous = 1
	playsound(src, 'sound/effects/phasein.ogg', 25, 1)
	target = end
	GLOB.moved_event.register(src, src, /datum/proc/qdel_self)

	if(delete_after)
		QDEL_IN(src, delete_after)

/obj/effect/portal/Destroy()
	target = null
	GLOB.moved_event.unregister(src, src)
	. = ..()

/obj/effect/portal/proc/teleport(atom/movable/M)
	if(istype(M, /obj/effect)) //sparks don't teleport
		return
	if (icon_state == "portal1")
		return
	if (!( target ))
		qdel(src)
		return
	if (istype(M, /atom/movable))
		if(dangerous && prob(failchance)) //oh dear a problem, put em in deep space
			var/destination_z = GLOB.using_map.get_transit_zlevel(z)
			do_teleport(M, locate(rand(TRANSITIONEDGE, world.maxx - TRANSITIONEDGE), rand(TRANSITIONEDGE, world.maxy -TRANSITIONEDGE), destination_z), 0)
		else
			do_teleport(M, target, 1) ///You will appear adjacent to the beacon
