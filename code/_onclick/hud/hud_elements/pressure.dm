/decl/hud_element/condition/pressure
	screen_name = "pressure"
	screen_object_type = /obj/screen/pressure
	screen_icon_state = "pressure0"
	screen_loc = ui_temp
	hud_element_category = /decl/hud_element/condition/pressure

/decl/hud_element/condition/pressure/refresh_screen_object(datum/hud/hud, obj/screen/elem, datum/gas_mixture/environment)
	elem.icon_state = "pressure[hud?.alerts ? (LAZYACCESS(hud.alerts, hud_element_category) || 0) : 0]"
