/decl/hud_element/action_intent/diona_nymph
	screen_object_type = /obj/screen/intent/diona_nymph

/obj/screen/intent/diona_nymph
	icon_state = "intent_harm"
	screen_loc = DIONA_SCREEN_LOC_INTENT

/obj/screen/intent/diona_nymph/on_update_icon()
	if(intent == I_HURT || intent == I_GRAB)
		intent = I_GRAB
		icon_state = "intent_harm"
	else
		intent = I_DISARM
		icon_state = "intent_help"

/obj/screen/diona_held
	name = "held item"
	screen_loc =  DIONA_SCREEN_LOC_HELD
	icon_state = "held"

/obj/screen/diona_held/Click()
	var/mob/living/carbon/alien/diona/chirp = usr
	if(istype(chirp) && chirp.holding_item) chirp.try_unequip(chirp.holding_item)

/datum/hud/diona_nymph
	var/obj/screen/diona_held/held

/datum/hud/diona_nymph/get_ui_style()
	return 'mods/mobs/dionaea/icons/ui.dmi'

/datum/hud/diona_nymph/get_ui_color()
	return COLOR_WHITE

/datum/hud/diona_nymph/get_ui_alpha()
	return 255

/datum/hud/diona_nymph/FinalizeInstantiation()
	var/ui_style = get_ui_style()
	var/ui_color = get_ui_color()
	var/ui_alpha = get_ui_alpha()
	hat = new
	hat.icon =  ui_style
	hat.color = ui_color
	hat.alpha = ui_alpha
	misc_hud_elements += hat
	held = new
	held.icon =  ui_style
	held.color = ui_color
	held.alpha = ui_alpha
	misc_hud_elements += held
	return ..()
