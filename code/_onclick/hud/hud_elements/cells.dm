/decl/hud_element/cells
	screen_name = "cell"
	screen_icon_state = "charge-empty"
	screen_icon = 'icons/mob/screen/robot_charge.dmi'
	screen_loc = ui_nutrition
	update_in_life = TRUE

/decl/hud_element/cells/refresh_screen_object(datum/hud/hud, obj/screen/elem, datum/gas_mixture/environment)
	if(!isliving(hud?.mymob))
		return
	var/mob/living/user = hud.mymob
	if(!user.isSynthetic())
		elem.invisibility = INVISIBILITY_MAXIMUM
	else
		elem.invisibility = 0
		var/obj/item/cell/cell = user.get_cell()
		if(cell)
			// 0-100 maps to 0-4, but give it a paranoid clamp just in case.
			elem.icon_state = "charge[clamp(CEILING(cell.percent()/25), 0, 4)]"
		else
			elem.icon_state = "charge-empty"
