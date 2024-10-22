/obj/screen/action_button
	screen_loc = "LEFT,TOP"
	requires_ui_style = FALSE
	var/datum/action/action

/obj/screen/action_button/Initialize(mapload, mob/_owner, ui_style, ui_color, ui_alpha, ui_cat, _action)
	action = _action
	return ..()

/obj/screen/action_button/handle_click(mob/user, params)
	if(action && user.next_move < world.time)
		action.Trigger()
		return TRUE
	return FALSE

/obj/screen/action_button/on_update_icon()
	if(!action)
		return
	icon = action.background_icon
	icon_state = action.background_icon_state

	cut_overlays()
	var/image/img
	if(action.action_type == AB_ITEM && action.target)
		var/obj/item/I = action.target
		img = image(I.icon, src , I.icon_state)
	else if(action.button_icon && action.button_icon_state)
		img = image(action.button_icon,src,action.button_icon_state)
	img.pixel_x = 0
	img.pixel_y = 0
	add_overlay(img)
	compile_overlays()

	if(!action.IsAvailable())
		color = rgb(128,0,0,128)
	else
		color = rgb(255,255,255,255)

/obj/screen/action_button/MouseEntered(location, control, params)
	openToolTip(user = usr, tip_src = src, params = params, title = name, content = desc)
	..()

/obj/screen/action_button/MouseDown()
	closeToolTip(usr)
	..()

/obj/screen/action_button/MouseExited()
	closeToolTip(usr)
	..()

//Hide/Show Action Buttons ... Button
/obj/screen/action_button/hide_toggle
	name = "Hide Buttons"
	icon = 'icons/obj/action_buttons/actions.dmi'
	icon_state = "bg_default"
	var/hidden = FALSE

/obj/screen/action_button/hide_toggle/Initialize(mapload, mob/_owner, ui_style, ui_color, ui_alpha, ui_cat)
	. = ..()
	icon_state = "bg_default"
	update_icon()

/obj/screen/action_button/hide_toggle/handle_click(mob/user, params)
	if(!istype(user.hud_used))
		return
	user.hud_used.action_buttons_hidden = !user.hud_used.action_buttons_hidden
	hidden = user.hud_used.action_buttons_hidden
	if(hidden)
		name = "Show Buttons"
	else
		name = "Hide Buttons"
	update_icon()
	user.update_action_buttons()

/obj/screen/action_button/hide_toggle/on_update_icon()
	cut_overlays()
	add_overlay(hidden ? "show" : "hide")
	compile_overlays()
