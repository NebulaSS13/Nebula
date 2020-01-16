/obj/screen/movable
	var/moved = FALSE

/obj/screen/movable/MouseDrop(over_object, src_location, over_location, src_control, over_control, params)
	var/list/PM = params2list(params)
	if(LAZYLEN(PM) && PM["screen-loc"])
		var/list/screen_loc_params = splittext(PM["screen-loc"], ",")
		var/list/x_data = splittext(screen_loc_params[1], ":")
		var/list/y_data = splittext(screen_loc_params[2], ":")
		screen_loc = "[x_data[1]]:[text2num(x_data[2])-16],[y_data[1]]:[text2num(y_data[2])-16]"
