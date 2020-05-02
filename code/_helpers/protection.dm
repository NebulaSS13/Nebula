/atom/proc/isProtected(var/mob/user)
	var/area/A
	if(istype(src, /turf))
		A = get_area(src)
	else
		A = get_area(loc)
		
	var/protected = A.area_flags & AREA_FLAG_PROTECTED
	if(!protected)
		return FALSE
	if(!user)
		return TRUE
	// Check permission whitelists for this user.
	return TRUE // TODO: actually implement.