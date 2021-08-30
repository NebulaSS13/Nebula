// Casting stubs for grabs, check /mob/living for full definition.
/mob/proc/apply_damage(var/damage = 0,var/damagetype = BRUTE, var/def_zone = null, var/damage_flags = 0, var/used_weapon = null, var/armor_pen, var/silent = FALSE)
	return
/mob/proc/get_blocked_ratio(def_zone, damage_type, damage_flags, armor_pen, damage)
	return
/mob/proc/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	return
/mob/proc/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	return
// See /mob/living/carbon/human for this one.
/mob/proc/get_organ(var/zone)
	return
// End grab casting stubs.
/mob/proc/get_internal_organ(var/organ_tag)
	return
/mob/proc/get_internal_organs()
	return

/mob/can_be_grabbed(var/mob/grabber, var/target_zone)
	if(!grabber.can_pull_mobs)
		to_chat(grabber, SPAN_WARNING("\The [src] won't budge!"))
		return FALSE
	. = ..() && !buckled
	if(.)
		if((grabber.mob_size < grabber.mob_size) && grabber.can_pull_mobs != MOB_PULL_LARGER)
			to_chat(grabber, SPAN_WARNING("You are too small to move \the [src]!"))
			return FALSE
		if((grabber.mob_size == mob_size) && grabber.can_pull_mobs == MOB_PULL_SMALLER)
			to_chat(grabber, SPAN_WARNING("\The [src] is too large for you to move!"))
			return FALSE
		if(iscarbon(grabber))
			last_handled_by_mob = weakref(grabber)

/mob/proc/handle_grab_damage()
	set waitfor = FALSE

/mob/proc/handle_grabs_after_move()
	set waitfor = FALSE

/mob/proc/add_grab(var/obj/item/grab/grab)
	return FALSE

/mob/proc/ProcessGrabs()
	return

/mob/proc/get_active_grabs()
	. = list()
	for(var/obj/item/grab/grab in contents)
		. += grab

/mob/get_object_size()
	return mob_size	

/mob/refresh_pixel_offsets(var/anim_time = 2)
	if(isnull(pixel_offset_anim_time))
		pixel_offset_anim_time = anim_time
	else
		pixel_offset_anim_time = min(pixel_offset_anim_time, anim_time)
	addtimer(CALLBACK(src, .proc/rebuild_pixel_offsets), 0, TIMER_UNIQUE) // Avoid doing this repeatedly in a single tick.

/mob/proc/rebuild_pixel_offsets()

	var/last_plane =   plane
	var/last_layer =   layer

	reset_plane_and_layer()

	var/new_plane =    plane
	var/new_layer =    layer

	var/last_pixel_x = pixel_x
	var/last_pixel_y = pixel_y
	var/last_pixel_z = pixel_z

	var/new_pixel_x =  default_pixel_x
	var/new_pixel_y =  default_pixel_y
	var/new_pixel_z =  default_pixel_z

	if(isturf(loc))

		// Update offsets from grabs.
		if(length(grabbed_by))
			var/draw_under = TRUE
			var/adjust_layer = FALSE
			for(var/obj/item/grab/G AS_ANYTHING in grabbed_by)
				var/grab_dir = get_dir(G.assailant, src)
				if(grab_dir)
					switch(grab_dir)
						if(NORTH)
							new_pixel_y = max(new_pixel_y-G.current_grab.shift, default_pixel_y-G.current_grab.shift)
						if(WEST)
							new_pixel_y = min(new_pixel_x+G.current_grab.shift, default_pixel_x+G.current_grab.shift)
						if(EAST)
							new_pixel_y = max(new_pixel_x-G.current_grab.shift, default_pixel_x-G.current_grab.shift)
						if(SOUTH)
							new_pixel_y = min(new_pixel_y+G.current_grab.shift, default_pixel_y+G.current_grab.shift)
							draw_under = FALSE
					if(G.current_grab.adjust_plane)
						adjust_layer = TRUE
						new_plane = G.assailant.plane
			if(adjust_layer)
				new_layer = layer + (draw_under ? -0.01 : 0.01)

		// Update offsets from structures in loc.
		var/structure_offset = 0
		for(var/obj/structure/struct in loc)
			structure_offset = max(structure_offset, struct.mob_offset)
		new_pixel_z += structure_offset

		// Update offsets from our buckled atom.
		if(buckled && buckled.buckle_pixel_shift)
			var/list/pixel_shift = buckled.buckle_pixel_shift
			if(islist(pixel_shift))
				var/list/directional_offset = LAZYACCESS(pixel_shift, "[dir]")
				if(islist(directional_offset))
					pixel_shift = directional_offset
				new_pixel_x += pixel_shift["x"] || 0
				new_pixel_y += pixel_shift["y"] || 0
				new_pixel_z += pixel_shift["z"] || 0

	// Apply offsets.
	if(last_pixel_x != new_pixel_x || last_pixel_y != new_pixel_y || last_pixel_z != new_pixel_z)
		if(pixel_offset_anim_time > 0)
			animate(src, pixel_x = new_pixel_x, pixel_y = new_pixel_y, pixel_z = new_pixel_z, pixel_offset_anim_time, 1, (LINEAR_EASING|EASE_IN))
		else
			pixel_x = new_pixel_x
			pixel_y = new_pixel_y
			pixel_z = new_pixel_z

	if(new_plane != last_plane)
		plane = new_plane
	if(new_layer != last_layer)
		layer = new_layer
	pixel_offset_anim_time = null