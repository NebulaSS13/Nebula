/proc/emissive_overlay(var/icon, var/icon_state, var/loc, var/dir, var/color)
	var/image/emissive/I = new(icon, icon_state)
	if(!isnull(loc))
		I.loc = loc
	if(!isnull(dir))
		I.dir = dir
	if(!isnull(color))
		I.color = color
	return I

/image/emissive/New()
	..()
	layer = EMISSIVE_LAYER
	plane = EMISSIVE_PLANE
