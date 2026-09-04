/*
These are all the things that can be adjusted for equipping stuff and
each one can be in the NORTH, SOUTH, EAST, and WEST direction. Specify
the x and y amounts to shift the thing for a given direction.

example:
	_equip_adjust = list(
		(slot_back_str) = list("[NORTH]" = list(-12, 7), "[EAST]" = list(-2, -12))
	)

This would shift back items (backpacks, axes, etc.) when the mob
is facing either north or east.
When the mob faces north the back item icon is shifted 12 pixes down and 7 pixels to the right.
When the mob faces east the back item icon is shifted 2 pixels down and 12 pixels to the left.

The slots that you can use are found in items_clothing.dm and are the inventory slot string ones, so make sure
	you use the _str version of the slot.
*/

/decl/bodytype
	VAR_PRIVATE/list/_equip_adjust
	VAR_PRIVATE/list/equip_overlays = list()

// Will be used by changelings/shapeshifters in the future
/decl/bodytype/proc/resolve_to_equipment_bodytype(mob/living/user)
	return src

/decl/bodytype/proc/get_equip_adjustments(mob/mob)
	return _equip_adjust

/decl/bodytype/proc/get_offset_overlay_image(mob/mob, mob_icon, mob_state, color, slot)
	// If we don't actually need to offset this, don't bother with any of the generation/caching.
	var/list/use_equip_adjust = get_equip_adjustments(mob)
	if(length(use_equip_adjust) && use_equip_adjust[slot] && length(use_equip_adjust[slot]))

		// Check the cache for previously made icons.
		var/modifier = mob?.get_overlay_state_modifier()
		var/image_key = modifier ? "[modifier]-[mob_icon]-[mob_state]-[color]-[slot]" : "generic-[mob_icon]-[mob_state]-[color]-[slot]"
		var/image/copying = equip_overlays[image_key]
		if(!copying)

			var/icon/final_I = new(icon_template)
			var/list/shifts = use_equip_adjust[slot]

			// Apply all pixel shifts for each direction.
			for(var/shift_facing in shifts)
				var/list/facing_list = shifts[shift_facing]
				var/use_dir = text2num(shift_facing)
				var/icon/equip = new(mob_icon, icon_state = mob_state, dir = use_dir)
				var/icon/canvas = new(icon_template)
				canvas.Blend(equip, ICON_OVERLAY, facing_list[1]+1, facing_list[2]+1)
				final_I.Insert(canvas, icon_state = mob_state, dir = use_dir)
			copying = overlay_image(final_I, mob_state, color, RESET_COLOR)
			equip_overlays[image_key] = copying

		var/image/I = new() // We return a copy of the cached image, in case downstream procs mutate it.
		I.appearance = copying
		// For some reason icon_state is coming back null...
		I.icon       = copying.icon
		I.icon_state = copying.icon_state
		return I

	return overlay_image(mob_icon, mob_state, color, RESET_COLOR)
