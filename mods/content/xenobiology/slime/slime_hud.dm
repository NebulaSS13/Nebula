/datum/hud/slime/FinalizeInstantiation()
	action_intent = new /obj/screen/intent(null, mymob, mymob, get_ui_style_data(), get_ui_color(), get_ui_alpha(), UI_ICON_INTENT)
	src.adding = list(action_intent)

	..()
