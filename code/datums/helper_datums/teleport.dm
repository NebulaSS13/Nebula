/decl/teleport
	var/static/list/teleport_blacklist = list(/obj/item/disk/nuclear, /obj/item/backpack/holding, /obj/effect/sparks) //Items that cannot be teleported, or be in the contents of someone who is teleporting.

/decl/teleport/proc/teleport(var/atom/target, var/atom/destination, var/precision = 0)
	if(!can_teleport(target,destination))
		target.visible_message("<span class='warning'>\The [target] bounces off the teleporter!</span>")
		return

	teleport_target(target, destination, precision)

/decl/teleport/proc/teleport_target(var/atom/movable/target, var/atom/destination, var/precision)
	var/list/possible_turfs = circlerangeturfs(destination, precision)
	destination = SAFEPICK(possible_turfs)

	target.forceMove(destination)
	if(isliving(target))
		var/mob/living/L = target
		if(L.buckled)
			var/atom/movable/buckled = L.buckled
			buckled.forceMove(destination)

/decl/teleport/proc/can_reach_z(var/oz, var/tz)

	if(isAdminLevel(oz))
		return isAdminLevel(tz) || isStationLevel(tz) || isContactLevel(tz)

	var/list/accessible_z_levels = SSmapping.get_connected_levels(oz)
	var/obj/effect/overmap/sector = global.overmap_sectors[num2text(oz)]
	if(sector)

		var/list/neighbors_to_add = list()
		for(var/obj/effect/overmap/visitable/neighbor in sector.loc)
			neighbors_to_add |= neighbor

		var/list/neighboring_sectors = list()
		while(length(neighbors_to_add))
			var/obj/effect/overmap/visitable/neighbor = neighbors_to_add[1]
			neighbors_to_add -= neighbor
			neighboring_sectors |= neighbor
			for(var/obj/effect/overmap/visitable/subneighbor in neighbor)
				if(!(subneighbor in neighboring_sectors))
					neighbors_to_add |= subneighbor

		for(var/obj/effect/overmap/visitable/neighbor in neighboring_sectors)
			accessible_z_levels |= neighbor.map_z

	return (tz in accessible_z_levels)

/decl/teleport/proc/can_teleport(var/atom/movable/target, var/atom/destination)
	if(!destination || !target?.loc)
		return FALSE
	if(!can_reach_z(target.z, destination.z))
		return FALSE
	if(is_type_in_list(target, teleport_blacklist))
		return FALSE
	for(var/thing in target)
		if(is_type_in_list(thing, teleport_blacklist))
			return FALSE
	return TRUE

/decl/teleport/sparks/proc/do_spark(var/atom/target)
	if(!target.simulated)
		return
	spark_at(get_turf(target), amount=5, cardinal_only = TRUE, holder=target)

/decl/teleport/sparks/teleport_target(var/atom/target, var/atom/destination, var/precision)
	do_spark(target)
	..()
	do_spark(target)

/proc/do_teleport(var/atom/movable/target, var/atom/destination, var/precision = 0, var/type = /decl/teleport/sparks)
	var/decl/teleport/tele = GET_DECL(type)
	tele.teleport(target, destination, precision)
