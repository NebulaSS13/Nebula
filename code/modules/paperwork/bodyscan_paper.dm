/obj/item/paper/bodyscan
	color = COLOR_OFF_WHITE
	scan_file_type = /datum/computer_file/data/bodyscan

/obj/item/paper/bodyscan/interact(mob/user, forceshow, readonly, admin_interact = FALSE)
	set_content(display_medical_data(metadata, user.get_skill_value(SKILL_MEDICAL), TRUE))
	. = ..()