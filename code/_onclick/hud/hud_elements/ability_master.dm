/decl/hud_element/ability_master
	apply_hud_icon =  FALSE
	apply_hud_alpha = FALSE
	apply_hud_color = FALSE
	hud_element_category = /decl/hud_element/ability_master

/decl/hud_element/ability_master/create_screen_object(datum/hud/hud)
	return new /obj/screen/ability_master(null, hud?.mymob)
