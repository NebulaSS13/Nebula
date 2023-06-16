/decl/hud_element/condition/toxins
	screen_name = "toxin"
	screen_object_type = /obj/screen/toxins
	screen_icon_state = "tox0"
	screen_loc = ui_temp
	hud_element_category = /decl/hud_element/condition/toxins

/decl/hud_element/condition/toxins/refresh_screen_object(datum/hud/hud, obj/screen/elem, datum/gas_mixture/environment)
	elem.icon_state = "tox[hud?.alerts ? (LAZYACCESS(hud.alerts, hud_element_category) || 0) : 0]"
