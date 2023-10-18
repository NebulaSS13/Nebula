/mob/living/silicon/robot/Login()
	..()
	update_icon()
	show_laws(0)
	// Forces synths to select an icon relevant to their module
	if(!icon_selected && module)
		choose_icon(module.get_sprites_for(src))
