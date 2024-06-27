/mob/living/simple_animal/alien/diona/on_update_icon()
	..()
	if(flower_color && icon_state == ICON_STATE_WORLD)
		var/image/flower = image(icon = icon, icon_state = "flower_back")
		var/image/I = image(icon = icon, icon_state = "flower_fore")
		I.color = flower_color
		flower.overlays += I
		add_overlay(flower)
