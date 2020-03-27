/client/view_var_Topic(href, href_list, hsrc)
	if((usr.client != src) || !src.holder)
		return
	if(href_list["give_spell"])
		if(!check_rights(R_ADMIN|R_FUN))	return

		var/mob/M = locate(href_list["give_spell"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		src.give_spell(M)
		href_list["datumrefresh"] = href_list["give_spell"]
		return
	. = ..()