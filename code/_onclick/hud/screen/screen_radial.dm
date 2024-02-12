/obj/screen/radial
	icon = 'icons/screen/radial.dmi'
	layer = HUD_ABOVE_ITEM_LAYER
	plane = HUD_PLANE
	requires_owner = FALSE
	requires_ui_style = FALSE
	var/datum/radial_menu/parent

/obj/screen/radial/Destroy()
	parent = null
	return ..()

/obj/screen/radial/slice
	icon_state = "radial_slice"
	var/choice
	var/next_page = FALSE
	var/tooltips = FALSE

/obj/screen/radial/slice/MouseEntered(location, control, params)
	. = ..()
	icon_state = "radial_slice_focus"
	if(tooltips)
		openToolTip(usr, src, params, title = name)

/obj/screen/radial/slice/MouseExited(location, control, params)
	. = ..()
	icon_state = "radial_slice"
	if(tooltips)
		closeToolTip(usr)

/obj/screen/radial/slice/handle_click(mob/user, params)
	if(parent && user.client == parent.current_user)
		if(next_page)
			parent.next_page()
		else
			parent.element_chosen(choice, user)

/obj/screen/radial/center
	name = "Close Menu"
	icon_state = "radial_center"

/obj/screen/radial/center/MouseEntered(location, control, params)
	. = ..()
	icon_state = "radial_center_focus"

/obj/screen/radial/center/MouseExited(location, control, params)
	. = ..()
	icon_state = "radial_center"

/obj/screen/radial/center/handle_click(mob/user, params)
	if(user.client == parent.current_user)
		parent.finished = TRUE


/obj/screen/radial/persistent/center
	name = "Close Menu"
	icon_state = "radial_center"

/obj/screen/radial/persistent/center/handle_click(mob/user, params)
	if(user.client == parent.current_user)
		parent.element_chosen(null,user)

/obj/screen/radial/persistent/center/MouseEntered(location, control, params)
	. = ..()
	icon_state = "radial_center_focus"

/obj/screen/radial/persistent/center/MouseExited(location, control, params)
	. = ..()
	icon_state = "radial_center"
