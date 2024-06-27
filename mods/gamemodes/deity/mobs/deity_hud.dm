/mob/living/deity
	hud_used = /datum/hud/deity

/datum/hud/deity/FinalizeInstantiation()
	action_intent =  new /obj/screen/intent/deity(null, mymob, get_ui_style_data(), get_ui_color(), get_ui_alpha(), UI_ICON_INTENT)
	adding += action_intent
	..()
	var/obj/screen/intent/deity/D = action_intent
	D.sync_to_mob(mymob)
