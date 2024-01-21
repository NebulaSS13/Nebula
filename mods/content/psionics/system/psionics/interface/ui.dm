/obj/screen/psi
	icon = 'mods/content/psionics/icons/psi.dmi'
	var/hidden = TRUE

/obj/screen/psi/Initialize(mapload, mob/_owner, ui_style, ui_color, ui_alpha)
	. = ..()
	update_icon()

/obj/screen/psi/on_update_icon()
	if(hidden)
		set_invisibility(INVISIBILITY_ABSTRACT)
	else
		set_invisibility(INVISIBILITY_NONE)