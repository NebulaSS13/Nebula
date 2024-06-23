/proc/emissive_overlay(var/icon, var/icon_state, var/loc, var/dir, var/color)
	var/image/I = image(icon, loc, icon_state, EMISSIVE_LAYER, dir)
	I.plane = EMISSIVE_PLANE
	I.color = color
	return I
