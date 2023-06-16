/decl/hud_element/drop
	screen_name = "drop"
	screen_icon_state = "act_drop"
	screen_loc = ui_drop_throw

/decl/hud_element/drop/register_screen_object(obj/screen/elem, datum/hud/hud)
	hud.hotkey_hud_elements |= elem
