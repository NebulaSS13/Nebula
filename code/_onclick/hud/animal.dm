
/mob/living/simple_animal
	hud_type = /datum/hud/animal

/datum/hud/animal/FinalizeInstantiation()
	action_intent = new(null, mymob, get_ui_style_data(), get_ui_color(), get_ui_alpha(), UI_ICON_INTENT)
	adding += action_intent
	..()

