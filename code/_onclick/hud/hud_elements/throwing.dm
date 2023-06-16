/decl/hud_element/throwing
	screen_name = "throw"
	screen_icon_state = "act_throw_off"
	screen_loc = ui_drop_throw

/decl/hud_element/throwing/register_screen_object(obj/screen/elem, datum/hud/hud)
	hud.hotkey_hud_elements |= elem
