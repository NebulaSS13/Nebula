/decl/hud_element/condition/fire
	screen_name = "fire"
	screen_icon_state = "fire0"
	screen_loc = ui_fire
	hud_element_category = /decl/hud_element/condition/fire

/decl/hud_element/condition/fire/refresh_screen_object(var/datum/hud/hud, var/obj/screen/elem, var/datum/gas_mixture/environment)
	screen_icon_state = "fire[hud?.alerts ? (hud.alerts[hud_element_category] || 0) : 0]"
