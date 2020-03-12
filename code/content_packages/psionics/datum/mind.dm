/datum/mind/Topic(href, href_list)
	. = ..()
	if(!. && check_rights(R_ADMIN, FALSE) && current && isliving(current) && href_list["set_psi_faculty"] && href_list["set_psi_faculty_rank"])
		current.set_psi_rank(href_list["set_psi_faculty"], text2num(href_list["set_psi_faculty_rank"]))
		log_and_message_admins("set [key_name(current)]'s [href_list["set_psi_faculty"]] faculty to [text2num(href_list["set_psi_faculty_rank"])].")
		var/datum/admins/admin = GLOB.admins[usr.key]
		if(istype(admin)) admin.show_player_panel(current)
		return TRUE
