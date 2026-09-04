/obj/screen/psi
	icon = 'mods/content/psionics/icons/psi.dmi'
	requires_ui_style = FALSE
	apply_screen_overlay = FALSE
	var/hidden = TRUE
	var/can_hide = TRUE

/obj/screen/psi/Initialize(mapload, mob/_owner, ui_style, ui_color, ui_alpha, ui_cat)
	. = ..()
	update_icon()

/obj/screen/psi/on_update_icon()
	..()
	if(hidden && can_hide)
		set_invisibility(INVISIBILITY_ABSTRACT)
	else
		set_invisibility(INVISIBILITY_NONE)