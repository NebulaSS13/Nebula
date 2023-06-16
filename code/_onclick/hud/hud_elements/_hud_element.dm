/decl/hud_element
	abstract_type = /decl/hud_element
	var/screen_name
	var/screen_icon
	var/screen_icon_state
	var/screen_loc
	var/screen_object_type = /obj/screen

	var/hidable = FALSE
	var/apply_hud_color = TRUE
	var/apply_hud_alpha = TRUE
	var/apply_hud_icon  = TRUE
	var/apply_color_on_cooldown = FALSE

	var/update_in_life = FALSE

	var/hud_element_category

/decl/hud_element/proc/refresh_screen_object(var/datum/hud/hud, var/obj/screen/elem, var/datum/gas_mixture/environment)
	return

/decl/hud_element/proc/create_screen_object(var/datum/hud/hud)
	var/obj/screen/elem = new screen_object_type
	if(screen_name)
		elem.SetName(screen_name)
	if(apply_hud_color)
		elem.color = hud.get_ui_color()
	if(apply_hud_alpha)
		elem.alpha = hud.get_ui_alpha()
	if(apply_hud_icon)
		elem.icon =  hud.get_ui_style()
	else if(screen_icon)
		elem.icon = screen_icon
	if(screen_icon_state)
		elem.icon_state = screen_icon_state
	if(screen_loc)
		elem.screen_loc = screen_loc
	register_screen_object(elem, hud)
	return elem

/decl/hud_element/proc/register_screen_object(var/obj/screen/elem, var/datum/hud/hud)
	hud.misc_hud_elements |= elem

/decl/hud_element/condition
	screen_icon = 'icons/mob/screen/condition.dmi'
	apply_hud_icon =  FALSE
	apply_hud_alpha = FALSE
	apply_hud_color = FALSE
	update_in_life =  TRUE
