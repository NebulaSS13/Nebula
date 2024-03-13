/obj/item/ano_scanner
	name = "\improper Alden-Saraspova counter"
	desc = "A device which aids in triangulation of exotic particles."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "flashgun"
	item_state = "flashgun"
	origin_tech = @'{"wormholes":3,"magnets":3}'
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/fiberglass = MATTER_AMOUNT_TRACE
	)
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_LOWER_BODY

	var/last_scan_time = 0
	var/scan_delay = 25

/obj/item/ano_scanner/attack_self(var/mob/user)
	interact(user)

/obj/item/ano_scanner/interact(var/mob/living/user)
	if(world.time - last_scan_time >= scan_delay)
		last_scan_time = world.time

		var/nearestTargetDist = -1
		var/nearestTargetId

		var/nearestSimpleTargetDist = -1
		var/turf/cur_turf = get_turf(src)

		var/list/artifact = SSxenoarch.get_nearest_artifact(cur_turf)
		if(artifact)
			nearestTargetId = artifact[1]
			nearestTargetDist = artifact[2]

		for(var/A in SSxenoarch.digsite_spawning_turfs)
			var/turf/wall/natural/T = A
			if(T.density && T.finds && T.finds.len)
				if(T.z == cur_turf.z)
					var/cur_dist = get_dist(cur_turf, T) * 2
					if(nearestSimpleTargetDist < 0 || cur_dist < nearestSimpleTargetDist)
						nearestSimpleTargetDist = cur_dist + rand() * 2 - 1
			else
				SSxenoarch.digsite_spawning_turfs.Remove(T)

		if(nearestTargetDist >= 0)
			to_chat(user, "Exotic energy detected on wavelength '[nearestTargetId]' in a radius of [nearestTargetDist]m[nearestSimpleTargetDist > 0 ? "; small anomaly detected in a radius of [nearestSimpleTargetDist]m" : ""]")
		else if(nearestSimpleTargetDist >= 0)
			to_chat(user, "Small anomaly detected in a radius of [nearestSimpleTargetDist]m.")
		else
			to_chat(user, "Background radiation levels detected.")
	else
		to_chat(user, "Scanning array is recharging.")