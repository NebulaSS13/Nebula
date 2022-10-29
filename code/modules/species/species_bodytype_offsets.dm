/*
These are all the things that can be adjusted for equipping stuff and
each one can be in the NORTH, SOUTH, EAST, and WEST direction. Specify
the direction to shift the thing and what direction.

example:
	equip_adjust = list(
		slot_back_str = list(NORTH = list(SOUTH = 12, EAST = 7), EAST = list(SOUTH = 2, WEST = 12))
			)

This would shift back items (backpacks, axes, etc.) when the mob
is facing either north or east.
When the mob faces north the back item icon is shifted 12 pixes down and 7 pixels to the right.
When the mob faces east the back item icon is shifted 2 pixels down and 12 pixels to the left.

The slots that you can use are found in items_clothing.dm and are the inventory slot string ones, so make sure
	you use the _str version of the slot.
*/

/decl/bodytype
	var/list/equip_adjust = list()
	var/list/equip_icons =  list()

/decl/bodytype/proc/get_offset_overlay_image(var/spritesheet, var/mob_icon, var/mob_state, var/color, var/slot)
	// If we don't actually need to offset this, don't bother with any of the generation/caching.
	if(!spritesheet && length(equip_adjust) && equip_adjust[slot] && length(equip_adjust[slot]))
		// Grab our collected offsets for this base icon.
		var/icon/offset_icon = equip_icons[mob_icon]
		// If we haven't gone one yet, generate a blank one.
		if(!offset_icon)
			offset_icon = new(icon_template)
			equip_icons[mob_icon] = offset_icon
		// If we haven't got this state yet, generate and insert it.
		if(!check_state_in_icon(mob_state, offset_icon) && check_state_in_icon(mob_state, mob_icon))
			var/list/shifts = equip_adjust[slot]
			for(var/shift_facing in shifts)
				var/list/facing_list = shifts[shift_facing]
				var/use_dir = text2num(shift_facing)
				var/icon/equip = new(mob_icon, icon_state = mob_state, dir = use_dir)
				var/icon/canvas = new(icon_template)
				canvas.Blend(equip, ICON_OVERLAY, facing_list["x"]+1, facing_list["y"]+1)
				offset_icon.Insert(canvas, mob_state, dir = use_dir)
		// Replace our mob icon with the offset icon.
		mob_icon = offset_icon
	return overlay_image(mob_icon, mob_state, color, RESET_COLOR)
