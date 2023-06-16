/decl/hud_element/condition/hydration
	screen_name = "hydration"
	screen_object_type = /obj/screen/drink
	screen_icon_state = "hydration1"
	screen_loc = ui_nutrition_small
	hud_element_category = /decl/hud_element/condition/hydration
	var/hud_states = 4

/decl/hud_element/condition/hydration/refresh_screen_object(datum/hud/hud, obj/screen/elem, datum/gas_mixture/environment)
	if(!isliving(hud?.mymob))
		return
	var/mob/living/user = hud.mymob
	var/max_hyd = user.get_max_hydration()
	var/hyd =     user.get_hydration()
	var/hyd_offset = max_hyd * 0.2
	if(hyd >= max_hyd - hyd_offset)
		elem.icon_state = "hydration[hud_states]"
	else if(hyd <= hyd_offset * 2)
		elem.icon_state = "hydration"
	else
		elem.icon_state = "hydration[round(((hyd-(hyd_offset*2))/(max_hyd-hyd_offset))*(hud_states-2))+1]"
