/proc/get_mech_image(var/decal, var/decal_blend = BLEND_MULTIPLY, var/cache_key, var/cache_icon, var/image_colour, var/overlay_layer = FLOAT_LAYER)

	var/use_key = "[cache_key]-[cache_icon]-[overlay_layer]-[decal ? decal : "none"]-[decal_blend]-[image_colour ? image_colour : "none"]"
	if(!global.mech_image_cache[use_key])
		var/image/I = image(icon = cache_icon, icon_state = cache_key)
		if(image_colour)
			var/image/masked_color = image(icon = cache_icon, icon_state = "[cache_key]_mask")
			masked_color.color = image_colour
			masked_color.blend_mode = BLEND_MULTIPLY
			I.overlays += masked_color
		if(decal)
			var/decal_key = "[decal]-[decal_blend]-[cache_key]"
			if(!global.mech_icon_cache[decal_key])
				var/template_key = "template-[cache_key]"
				var/icon/decal_icon = icon('icons/mecha/mech_decals.dmi', decal)
				if(!global.mech_icon_cache[template_key])
					global.mech_icon_cache[template_key] = icon(cache_icon, "[cache_key]_mask")
				decal_icon.AddAlphaMask(global.mech_icon_cache[template_key])
				global.mech_icon_cache[decal_key] = decal_icon
			var/image/decal_image = get_mech_image(null, null, decal_key, global.mech_icon_cache[decal_key])
			decal_image.blend_mode = decal_blend
			decal_image.appearance_flags |= RESET_COLOR
			I.overlays += decal_image
		I.appearance_flags |= RESET_COLOR
		I.layer = overlay_layer
		I.plane = FLOAT_PLANE
		global.mech_image_cache[use_key] = I

	var/image/I = new
	I.appearance = global.mech_image_cache[use_key]
	return I

/mob/living/exosuit/on_update_icon()
	..()
	var/list/new_overlays = list()
	if(body)
		new_overlays += get_mech_image(body.decal, body.decal_blend, body.icon_state, body.on_mech_icon, body.color, overlay_layer = MECH_BASE_LAYER)
		new_overlays += get_mech_image(body.decal, body.decal_blend, "[body.icon_state]_cockpit", body.on_mech_icon, overlay_layer = MECH_INTERMEDIATE_LAYER)
	update_pilots(FALSE)
	if(LAZYLEN(pilot_overlays))
		new_overlays += pilot_overlays
	if(body)
		new_overlays += get_mech_image(body.decal, body.decal_blend, "[body.icon_state]_overlay[hatch_closed ? "" : "_open"]", body.on_mech_icon, body.color, MECH_COCKPIT_LAYER)
	if(arms)
		new_overlays += get_mech_image(arms.decal, arms.decal_blend, arms.icon_state, arms.on_mech_icon, arms.color, MECH_ARM_LAYER)
	if(legs)
		new_overlays += get_mech_image(legs.decal, legs.decal_blend, legs.icon_state, legs.on_mech_icon, legs.color, MECH_LEG_LAYER)
	for(var/hardpoint in hardpoints)
		var/obj/item/mech_equipment/hardpoint_object = hardpoints[hardpoint]
		if(hardpoint_object)
			var/use_icon_state = "[hardpoint_object.icon_state]_[hardpoint]"
			if(use_icon_state in global.mech_weapon_overlays)
				var/color = COLOR_WHITE
				var/decal = null
				var/decal_blend = BLEND_MULTIPLY
				if(hardpoint in list(HARDPOINT_BACK, HARDPOINT_RIGHT_SHOULDER, HARDPOINT_LEFT_SHOULDER))
					color       = body.color
					decal       = body.decal
					decal_blend = body.decal_blend
				else if(hardpoint in list(HARDPOINT_RIGHT_HAND, HARDPOINT_LEFT_HAND))
					color       = arms.color
					decal       = arms.decal
					decal_blend = arms.decal_blend
				else
					color       = head.color
					decal       = head.decal
					decal_blend = head.decal_blend
				new_overlays += get_mech_image(decal, decal_blend, use_icon_state, 'icons/mecha/mech_weapon_overlays.dmi', color, hardpoint_object.mech_layer )

	set_overlays(new_overlays)

/mob/living/exosuit/proc/update_pilots(var/update_overlays = TRUE)
	if(update_overlays && LAZYLEN(pilot_overlays))
		overlays -= pilot_overlays
	pilot_overlays = null
	if(body && !(body.hide_pilot))
		for(var/i = 1 to LAZYLEN(pilots))
			var/mob/pilot = pilots[i]
			var/image/draw_pilot = new
			draw_pilot.appearance = pilot
			var/rel_pos = dir == NORTH ? -1 : 1
			draw_pilot.layer = MECH_PILOT_LAYER + (body ? ((LAZYLEN(body.pilot_positions)-i)*0.001 * rel_pos) : 0)
			draw_pilot.plane = FLOAT_PLANE
			draw_pilot.appearance_flags = KEEP_TOGETHER
			if(body && i <= LAZYLEN(body.pilot_positions))
				var/list/offset_values = body.pilot_positions[i]
				var/list/directional_offset_values = offset_values["[dir]"]
				draw_pilot.pixel_x = pilot.default_pixel_x + directional_offset_values["x"]
				draw_pilot.pixel_y = pilot.default_pixel_y + directional_offset_values["y"]
				draw_pilot.pixel_z = 0
				draw_pilot.transform = null

			//Mask pilots!
			//Masks are 48x48 and pilots 32x32 (in theory at least) so some math is required for centering
			var/diff_x = 8 - draw_pilot.pixel_x
			var/diff_y = 8 - draw_pilot.pixel_y
			draw_pilot.add_filter("pilot_mask", 1, list(type = "alpha", icon = icon(body.on_mech_icon, "[body.icon_state]_pilot_mask[hatch_closed ? "" : "_open"]", dir), x = diff_x, y = diff_y))

			LAZYADD(pilot_overlays, draw_pilot)
		if(update_overlays && LAZYLEN(pilot_overlays))
			overlays += pilot_overlays
