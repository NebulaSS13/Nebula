/decl/hud_element/resist
	screen_name = "resist"
	screen_icon_state = "act_resist"
	screen_loc = ui_pull_resist

/decl/hud_element/resist/register_screen_object(obj/screen/elem, datum/hud/hud)
	hud.hotkey_hud_elements |= elem
