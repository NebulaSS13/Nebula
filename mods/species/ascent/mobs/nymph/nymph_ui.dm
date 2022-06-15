/obj/screen/intent/ascent_nymph
	icon_state = "intent_hurt"
	screen_loc = "RIGHT-2:28,BOTTOM:5"

/obj/screen/intent/ascent_nymph/on_update_icon()
	if(intent == I_HURT || intent == I_GRAB)
		intent = I_GRAB
		icon_state = "intent_harm"
	else
		intent = I_DISARM
		icon_state = "intent_help"

/obj/screen/ascent_nymph_molt
	name = "molt"
	icon = 'icons/obj/action_buttons/organs.dmi'
	screen_loc =  "RIGHT-1:28,BOTTOM:5"
	icon_state = "molt-on"

/obj/screen/ascent_nymph_molt/Click()
	var/mob/living/carbon/alien/ascent_nymph/nymph = usr
	if(istype(nymph))
		nymph.molt()

/datum/hud/ascent_nymph
	var/obj/screen/ascent_nymph_molt/molt
	var/obj/screen/food/food
	var/obj/screen/drink/drink

/datum/hud/ascent_nymph/get_ui_style()
	return 'mods/species/ascent/icons/ui.dmi'

/datum/hud/ascent_nymph/get_ui_color()
	return COLOR_WHITE

/datum/hud/ascent_nymph/get_ui_alpha()
	return 255

/datum/hud/ascent_nymph/FinalizeInstantiation()


	var/ui_style = get_ui_style()
	var/ui_color = get_ui_color()
	var/ui_alpha = get_ui_alpha()

	adding = list()
	hotkeybuttons = list()

	action_intent = new /obj/screen/intent/ascent_nymph()
	adding += action_intent

	molt = new
	molt.icon =  ui_style
	molt.color = ui_color
	molt.alpha = ui_alpha
	adding += molt

	food = new
	food.icon = 'icons/mob/status_hunger.dmi'
	food.SetName("nutrition")
	food.icon_state = "nutrition1"
	food.pixel_w = 8
	food.screen_loc = ui_nutrition_small
	adding += food

	drink = new
	drink.icon = 'icons/mob/status_hunger.dmi'
	drink.icon_state = "hydration1"
	drink.SetName("hydration")
	drink.screen_loc = ui_nutrition_small
	adding += drink


	mymob.healths = new /obj/screen()
	mymob.healths.icon = ui_style
	mymob.healths.icon_state = "health0"
	mymob.healths.SetName("health")
	mymob.healths.screen_loc = "RIGHT-1:28,CENTER-1:24"
	adding += mymob.healths

	mymob.throw_icon = new /obj/screen()
	mymob.throw_icon.icon_state = "act_throw_off"
	mymob.throw_icon.SetName("throw")
	mymob.throw_icon.screen_loc = "RIGHT-1:28,BOTTOM+1:5"
	mymob.throw_icon.icon = ui_style
	mymob.throw_icon.color = ui_color
	mymob.throw_icon.alpha = ui_alpha

	hotkeybuttons += mymob.throw_icon
	adding += mymob.throw_icon

	var/obj/screen/drop = new()
	drop.SetName("drop")
	drop.icon_state = "act_drop"
	drop.screen_loc = "RIGHT-1:28,BOTTOM+1:5"
	drop.icon = ui_style
	drop.color = ui_color
	drop.alpha = ui_alpha
	hotkeybuttons += drop
	adding += drop

	BuildInventoryUI()
	BuildHandsUI()

	mymob.client.screen = adding | hotkeybuttons | hand_hud_objects | swaphand_hud_objects
