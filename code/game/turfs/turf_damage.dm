var/global/list/flooring_cache = list()
/turf/proc/get_damage_overlay(var/overlay_state, var/blend, var/damage_overlay_icon)
	if(!damage_overlay_icon)
		return
	var/cache_key = "[icon]-[overlay_state]"
	if(!global.flooring_cache[cache_key])
		var/image/I = image(icon = damage_overlay_icon, icon_state = overlay_state)
		if(!isnull(blend))
			I.blend_mode = blend
		I.layer = TURF_DAMAGE_LAYER
		global.flooring_cache[cache_key] = I
	return global.flooring_cache[cache_key]

/turf
	var/_burned
	var/_broken

/turf/proc/is_turf_broken()
	return _broken

/turf/proc/is_turf_burned()
	return _burned

/turf/proc/set_turf_burned(new_val, skip_icon_update, force)
	if(_burned != new_val || force)
		_burned = new_val
		if(!skip_icon_update)
			update_icon()

/turf/proc/set_turf_broken(new_val, skip_icon_update, force)
	if(_broken != new_val || force)
		_broken = new_val
		if(!skip_icon_update)
			update_icon()
