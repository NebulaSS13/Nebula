/decl/vv_set_handler
	var/handled_type
	var/predicates
	var/list/handled_vars

/decl/vv_set_handler/proc/can_handle_set_var(var/datum/O, variable, var_value, client)
	if(!istype(O, handled_type))
		return FALSE
	if(!(variable in handled_vars))
		return FALSE
	if(istype(O) && !(variable in O.vars))
		log_error("Did not find the variable '[variable]' for the instance [log_info_line(O)].")
		return FALSE
	if(predicates)
		for(var/predicate in predicates)
			if(!call(predicate)(var_value, client))
				return FALSE
	return TRUE

/decl/vv_set_handler/proc/handle_set_var(var/datum/O, variable, var_value, client)
	var/proc_to_call = handled_vars[variable]
	if(proc_to_call)
		call(O, proc_to_call)(var_value)
	else
		O.vars[variable] = var_value

/decl/vv_set_handler/location_handler
	handled_type = /atom/movable
	handled_vars = list("loc","x","y","z")

/decl/vv_set_handler/location_handler/handle_set_var(var/atom/movable/AM, variable, var_value, client)
	if(variable == "loc")
		if(istype(var_value, /atom) || isnull(var_value) || var_value == "")	// Proper null or empty string is fine, 0 is not
			AM.forceMove(var_value)
		else
			to_chat(client, "<span class='warning'>May only assign null or /atom types to loc.</span>")
	else if(variable == "x" || variable == "y" || variable == "z")
		if(istext(var_value))
			var_value = text2num(var_value)
		if(!is_num_predicate(var_value, client))
			return

		// We set the default to 1,1,1 when at 0,0,0 (i.e. any non-turf location) to mimic the standard BYOND behaviour when adjusting x,y,z directly
		var/x = AM.x || 1
		var/y = AM.y || 1
		var/z = AM.z || 1
		switch(variable)
			if("x")
				x = var_value
			if("y")
				y = var_value
			if("z")
				z = var_value

		var/turf/T = locate(x,y,z)
		if(T)
			AM.forceMove(T)
		else
			to_chat(client, "<span class='warning'>Unable to locate a turf at [x]-[y]-[z].</span>")

/decl/vv_set_handler/opacity_hander
	handled_type = /atom
	handled_vars = list("opacity" = /atom/proc/set_opacity)
	predicates = list(/proc/is_num_predicate)

/decl/vv_set_handler/dir_hander
	handled_type = /atom
	handled_vars = list("dir" = /atom/proc/set_dir)
	predicates = list(/proc/is_dir_predicate)

/decl/vv_set_handler/ghost_appearance_handler
	handled_type = /mob/observer/ghost
	handled_vars = list("appearance" = /mob/observer/ghost/proc/set_appearance)
	predicates = list(/proc/is_atom_predicate)

/decl/vv_set_handler/virtual_ability_handler
	handled_type = /mob/observer/virtual
	handled_vars = list("abilities")
	predicates = list(/proc/is_num_predicate)

/decl/vv_set_handler/virtual_ability_handler/handle_set_var(var/mob/observer/virtual/virtual, variable, var_value, client)
	..()
	virtual.update_icon()

/decl/vv_set_handler/mob_see_invisible_handler
	handled_type = /mob
	handled_vars = list("see_invisible" = /mob/proc/set_see_invisible)
	predicates = list(/proc/is_num_predicate)

/decl/vv_set_handler/mob_sight_handler
	handled_type = /mob
	handled_vars = list("sight" = /mob/proc/set_sight)
	predicates = list(/proc/is_num_predicate)

/decl/vv_set_handler/mob_see_in_dark_handler
	handled_type = /mob
	handled_vars = list("see_in_dark" = /mob/proc/set_see_in_dark)
	predicates = list(/proc/is_num_predicate)

/decl/vv_set_handler/mob_stat_handler
	handled_type = /mob
	handled_vars = list("set_stat" = /mob/proc/set_stat)
	predicates = list(/proc/is_num_predicate)

/decl/vv_set_handler/icon_state_handler
	handled_type = /atom
	handled_vars = list("icon_state" = /atom/proc/set_icon_state)

/decl/vv_set_handler/invisibility_handler
	handled_type = /atom
	handled_vars = list("invisibility" = /atom/proc/set_invisibility)
	predicates = list(/proc/is_num_predicate)

/decl/vv_set_handler/name_handler
	handled_type = /atom
	handled_vars = list("name" = /atom/proc/SetName)
	predicates = list(/proc/is_text_predicate)

/decl/vv_set_handler/light_handler
	handled_type = /atom
	handled_vars = list("light_color", "light_range", "light_power", "light_wedge")

// I'm lazy, ok.
#define VV_LIGHTING_SET(V) var/new_##V = variable == #V ? var_value : A.##V

/decl/vv_set_handler/light_handler/handle_set_var(var/atom/A, variable, var_value, client)
	var_value = text2num(var_value)
	if (variable == "light_color")	// This one's text.
		if (!is_text_predicate(var_value, client))
			return
	else if(!is_num_predicate(var_value, client))
		return
	// More sanity checks

	VV_LIGHTING_SET(light_range)
	VV_LIGHTING_SET(light_power)
	VV_LIGHTING_SET(light_wedge)
	VV_LIGHTING_SET(light_color)

	A.set_light(new_light_range, new_light_power, new_light_color, new_light_wedge)

#undef VV_LIGHTING_SET

/decl/vv_set_handler/ambient_light_handler
	handled_type = /turf
	handled_vars = list("ambient_light", "ambient_light_multiplier")

/decl/vv_set_handler/ambient_light_handler/handle_set_var(turf/T, variable, value, client)
	switch (variable)
		if ("ambient_light")
			if (!istext(value) && !isnull(value))
				to_chat(client, "<span class='alert'><pre>ambient_light</pre> must be text or null.</span>")
				return
			var/static/regex/color_regex = regex(@"^#[\dA-Fa-f]{6}$")
			if (istext(value) && !color_regex.Find(value))
				to_chat(client, "<span class='alert'><pre>ambient_light</pre> must be a 6 digit (<pre>#AABBCC</pre>) hexadecimal color string.</span>")
				return
			T.set_ambient_light(value)

		if ("ambient_light_multiplier")
			if (!isnum(value))
				to_chat(client, "<span class='alert'><pre>ambient_light_multiplier</pre> must be num.</span>")
				return
			T.set_ambient_light(multiplier = value)

/decl/vv_set_handler/icon_rotation_handler
	handled_type = /atom
	handled_vars = list("icon_rotation" = /atom/proc/set_rotation)
	predicates = list(/proc/is_num_predicate)

/decl/vv_set_handler/icon_scale_handler
	handled_type = /atom
	handled_vars = list("icon_scale_x", "icon_scale_y")

/decl/vv_set_handler/icon_scale_handler/handle_set_var(atom/A, variable, var_value, client)
	var_value = text2num(var_value)
	if(!is_num_predicate(var_value, client))
		return

	var/new_scale_x = variable == "icon_scale_x" ? var_value : A.icon_scale_x
	var/new_scale_y = variable == "icon_scale_y" ? var_value : A.icon_scale_y

	A.set_scale(new_scale_x, new_scale_y)


/decl/vv_set_handler/directional_offset_hander
	handled_type = /obj
	handled_vars = list("directional_offset")

/decl/vv_set_handler/directional_offset_hander/handle_set_var(var/obj/O, variable, var_value, client)
	if(!istext(var_value) && !isnull(var_value))
		to_chat(client, SPAN_WARNING("You can only enter a JSON string, or nothing in this field!"))
		return

	//Set the offset and force update
	O.directional_offset = var_value
	O.update_directional_offset(TRUE)
