/turf/proc/replace_flooring_layer(var/decl/flooring/adding_layer, var/decl/flooring/replacing_layer)
	if(islist(flooring_layers))
		for(var/i = length(flooring_layers); i > 0; i--)
			var/check_layer = flooring_layers[i]
			if(check_layer == replacing_layer || (ispath(check_layer) && istype(replacing_layer, check_layer)))
				flooring_layers.Remove(check_layer)
				flooring_layers.Insert(i, adding_layer)
				if(i == length(flooring_layers))
					refresh_flooring()
				return TRUE
	else if(flooring_layers == replacing_layer || (ispath(flooring_layers) && istype(replacing_layer, flooring_layers)))
		flooring_layers = adding_layer
		refresh_flooring()
		return TRUE
	return FALSE

/turf/proc/add_flooring_layer(var/decl/flooring/adding_layer)
	if(ispath(adding_layer))
		adding_layer = GET_DECL(adding_layer)
	var/decl/flooring/top_layer = get_flooring()
	if(adding_layer == top_layer || !top_layer.can_have_additional_layers(adding_layer))
		return FALSE
	// flooring_layers can handle single non-list entries (to avoid list overhead on /turf);
	// convert to a list now that it's being modified directly.
	if(flooring_layers && !islist(flooring_layers))
		flooring_layers = list(flooring_layers)
	LAZYADD(flooring_layers, adding_layer)
	refresh_flooring()

/turf/proc/remove_flooring_layer()
	if(!flooring_layers || !length(flooring_layers))
		return
	var/decl/flooring/top_layer = get_flooring()
	if(!top_layer.is_removable)
		return
	top_layer.on_remove(src)
	if(islist(flooring_layers))
		LAZYREMOVE(flooring_layers, top_layer)
	else if(flooring_layers == top_layer || (ispath(flooring_layers) && istype(top_layer, flooring_layers)))
		flooring_layers = null
	refresh_flooring()
	return top_layer

/turf/proc/get_flooring()
	RETURN_TYPE(/decl/flooring)
	if(flooring_layers)
		if(islist(flooring_layers))
			if(length(flooring_layers))
				. = flooring_layers[length(flooring_layers)]
			else
				flooring_layers = null
		else
			. = flooring_layers
	if(!.)
		. = get_plating_data()
	else if(ispath(., /decl/flooring))
		. = GET_DECL(.)

/turf/proc/get_plating_data()
	return GET_DECL(/decl/flooring/plating)

// assume_unchanged is passed to refresh_flooring() to avoid unnecessary initial()/appearance mutation during Initialize.
/turf/proc/set_flooring_layers(var/decl/flooring/new_flooring, var/defer_icon_update, var/assume_unchanged = FALSE)
	// TODO: consider passing old flooring down to refresh_flooring() and nooping if no change was made.
	// Can't work out how to do that without making Initialize() need to null flooring_layers before calling.
	flooring_layers = new_flooring
	refresh_flooring(defer_icon_update, assume_unchanged)

/turf/proc/refresh_flooring(var/defer_icon_update = FALSE, var/assume_unchanged = FALSE)
	var/decl/flooring/flooring = get_flooring()
	if(flooring)
		flooring.apply_appearance_to(src)
		. = TRUE
	else if(!assume_unchanged)
		SetName(initial(name))
		desc       = initial(desc)
		icon       = initial(icon)
		icon_state = initial(icon_state)
		icon_base  = initial(icon_base)
		color = null
		. = TRUE
	if(. && !defer_icon_update)
		update_icon(TRUE)
