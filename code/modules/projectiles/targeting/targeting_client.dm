//These are called by the on-screen buttons, adjusting what the victim can and cannot do.
/client/proc/add_gun_icons()
	if(!usr?.hud_used)
		return
	for(var/elem_type in global.gun_hud_flag_decl_types)
		var/obj/screen/elem = usr.get_hud_element(elem_type)
		if(elem)
			screen |= elem

/client/proc/remove_gun_icons()
	if(!usr?.hud_used)
		return
	for(var/elem_type in global.gun_hud_flag_decl_types)
		var/obj/screen/elem = usr.get_hud_element(elem_type)
		if(elem)
			screen -= elem
