/mob/proc/get_base_layer()
	if(lying)
		return LYING_MOB_LAYER
	return initial(layer)

/mob/reset_layer()
	var/last_layer = layer
	var/new_layer = get_base_layer()
	if(isturf(loc))
		if(buckled && buckled.buckle_layer_above)
			new_layer = buckled.layer + ((buckled.dir == SOUTH) ? -0.1 : 0.1)
		else if(length(grabbed_by))
			var/draw_under = TRUE
			var/adjust_layer = FALSE
			for(var/obj/item/grab/G as anything in grabbed_by)
				if(get_dir(G.assailant, src) & SOUTH)
					draw_under = FALSE
				if(G.current_grab.adjust_plane)
					adjust_layer = TRUE
			if(adjust_layer)
				new_layer += (draw_under ? -0.01 : 0.01)
	if(new_layer != last_layer)
		layer = new_layer
		UPDATE_OO_IF_PRESENT

/mob/reset_plane()
	var/last_plane = plane
	..()
	var/new_plane = plane
	if(isturf(loc))
		if(buckled && buckled.buckle_layer_above)
			new_plane = buckled.plane
		else if(length(grabbed_by))
			for(var/obj/item/grab/G as anything in grabbed_by)
				if(G.current_grab.adjust_plane)
					new_plane = max(new_plane, G.assailant.plane)
	if(last_plane != new_plane)
		plane = new_plane
		UPDATE_OO_IF_PRESENT

/mob/living/get_base_layer()
	if(jumping)
		return VEHICLE_LOAD_LAYER
	if (hiding)
		return HIDING_MOB_LAYER
	. = ..()

/mob/living/carbon/human/get_base_layer()
	if(lying)
		return LYING_HUMAN_LAYER
	. = ..()

// If you ever want to change how a mob offsets by default, you MUST add the offset
// changes to this proc and call it from your new feature code. This prevents conflicting
// animations and offsets from getting weird and ovewriting each other.
/mob/reset_offsets(var/anim_time = 2)

	var/last_pixel_x = pixel_x
	var/last_pixel_y = pixel_y
	var/last_pixel_z = pixel_z

	var/new_pixel_x =  default_pixel_x
	var/new_pixel_y =  default_pixel_y
	var/new_pixel_z =  default_pixel_z

	if(isturf(loc))
		// Update offsets from grabs.
		if(length(grabbed_by))
			for(var/obj/item/grab/G as anything in grabbed_by)
				var/grab_dir = get_dir(G.assailant, src)
				if(grab_dir && G.current_grab.shift > 0)
					if(grab_dir & WEST)
						new_pixel_x = min(new_pixel_x+G.current_grab.shift, default_pixel_x+G.current_grab.shift)
					else if(grab_dir & EAST)
						new_pixel_x = max(new_pixel_x-G.current_grab.shift, default_pixel_x-G.current_grab.shift)
					if(grab_dir & NORTH)
						new_pixel_y = max(new_pixel_y-G.current_grab.shift, default_pixel_y-G.current_grab.shift)
					else if(grab_dir & SOUTH)
						new_pixel_y = min(new_pixel_y+G.current_grab.shift, default_pixel_y+G.current_grab.shift)

		// Update offsets from structures in loc.
		var/structure_offset = 0
		for(var/obj/structure/struct in loc)
			structure_offset = max(structure_offset, struct.mob_offset)
		new_pixel_z += structure_offset

		// Update offsets from our buckled atom.
		if(buckled && buckled.buckle_pixel_shift)
			var/list/pixel_shift = buckled.buckle_pixel_shift
			if(istext(pixel_shift))
				pixel_shift = cached_json_decode(pixel_shift)
			if(islist(pixel_shift))
				var/list/directional_offset = LAZYACCESS(pixel_shift, "[dir]")
				if(islist(directional_offset))
					pixel_shift = directional_offset
				new_pixel_x += pixel_shift["x"] || 0
				new_pixel_y += pixel_shift["y"] || 0
				new_pixel_z += pixel_shift["z"] || 0

	if(last_pixel_x != new_pixel_x || last_pixel_y != new_pixel_y || last_pixel_z != new_pixel_z)
		if(anim_time > 0)
			animate(src, pixel_x = new_pixel_x, pixel_y = new_pixel_y, pixel_z = new_pixel_z, anim_time, 1, (LINEAR_EASING|EASE_IN))
		else
			pixel_x = new_pixel_x
			pixel_y = new_pixel_y
			pixel_z = new_pixel_z
