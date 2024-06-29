
/mob/living/simple_animal
	hud_used = /datum/hud/animal

/datum/hud/animal/FinalizeInstantiation()

	var/ui_style = get_ui_style_data()
	var/ui_color = get_ui_color()
	var/ui_alpha = get_ui_alpha()

	move_intent = new(null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_MOVEMENT)
	move_intent.icon_state = mymob.move_intent.hud_icon_state
	adding += move_intent
	action_intent = new(null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_INTENT)
	adding += action_intent
	..()
