/decl/hud_element/move_intent
	screen_name = "movement method"
	screen_object_type = /obj/screen/movement
	screen_loc = ui_movi
	hud_element_category = /decl/hud_element/move_intent

/decl/hud_element/move_intent/create_screen_object(var/datum/hud/hud)
	var/obj/screen/elem = ..()
	elem.icon_state = hud.mymob.move_intent.hud_icon_state
