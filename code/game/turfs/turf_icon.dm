/turf/on_update_icon(var/update_neighbors = FALSE)
	var/decl/flooring/flooring = get_flooring()
	if(flooring)
		. = list()
		var/edge_overlays = flooring.get_edge_overlays(src)
		if(length(edge_overlays))
			. += edge_overlays
		if(flooring.flags & TURF_CAN_BREAK)
			var/is_broken = is_turf_broken()
			if(!isnull(is_broken))
				. += get_damage_overlay("[flooring.icon_base]_broken[is_broken]", BLEND_MULTIPLY, flooring.icon)
		if(flooring.flags & TURF_CAN_BURN)
			var/is_burned = is_turf_burned()
			if(!isnull(is_burned))
				. += get_damage_overlay("[flooring.icon_base]_burned[is_burned]", BLEND_MULTIPLY, flooring.icon)
	else
		icon =  initial(icon)
		color = initial(color)

	if(length(decals))
		LAZYINITLIST(.)
		for(var/image/I as anything in decals)
			if(istype(I) && I.layer > FLOAT_LAYER && I.layer < layer) // decals can contain bare string overlays
				continue
			. += I
	if(length(.))
		set_overlays(.)
	else
		cut_overlays()

	if(update_neighbors)
		for(var/direction in global.alldirs)
			var/turf/target_turf = get_step_resolving_mimic(src, direction)
			if(target_turf)
				if(TICK_CHECK) // not CHECK_TICK -- only queue if the server is overloaded
					target_turf.queue_icon_update()
				else
					target_turf.update_icon(FALSE)
				target_turf.queue_ao(FALSE)
