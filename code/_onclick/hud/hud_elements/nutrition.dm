/decl/hud_element/condition/nutrition
	screen_name = "nutrition"
	screen_object_type = /obj/screen/food
	screen_icon_state = "nutrition1"
	screen_loc = ui_nutrition_small
	hud_element_category = /decl/hud_element/condition/nutrition
	var/hud_states = 4

/decl/hud_element/condition/nutrition/create_screen_object(datum/hud/hud)
	var/obj/screen/elem = ..()
	elem.pixel_w = 8
	return elem

/decl/hud_element/condition/nutrition/refresh_screen_object(datum/hud/hud, obj/screen/elem, datum/gas_mixture/environment)
	if(!isliving(hud?.mymob))
		return
	var/mob/living/user = hud.mymob
	var/max_nut = user.get_max_nutrition()
	var/nut =     user.get_nutrition()
	var/nut_offset = max_nut * 0.2
	if(nut >= max_nut - nut_offset)
		elem.icon_state = "nutrition[hud_states]"
	else if(nut <= nut_offset * 2)
		elem.icon_state = "nutrition0"
	else
		elem.icon_state = "nutrition[round(((nut-(nut_offset*2))/(max_nut-nut_offset))*(hud_states-2))+1]"
