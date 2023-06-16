/decl/hud_element/condition/oxygen
	screen_name = "oxygen"
	screen_object_type = /obj/screen/oxygen
	screen_loc = ui_temp
	screen_icon_state = "oxy0"
	hud_element_category = /decl/hud_element/condition/oxygen

/decl/hud_element/condition/oxygen/refresh_screen_object(datum/hud/hud, obj/screen/elem, datum/gas_mixture/environment)
	elem.icon_state = "oxy[hud?.alerts ? (LAZYACCESS(hud.alerts, hud_element_category) || 0) : 0]"
