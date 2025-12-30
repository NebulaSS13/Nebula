/proc/emissive_overlay(icon, icon_state, loc, dir, color, flags)
	var/image/I = image(icon, loc, icon_state, EMISSIVE_LAYER, dir)
	I.plane = EMISSIVE_PLANE
	I.color = color
	I.appearance_flags |= flags
	return I
