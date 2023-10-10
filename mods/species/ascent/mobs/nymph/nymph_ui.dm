/obj/screen/intent/ascent_nymph
	icon_state = "intent_devour"
	screen_loc = ANYMPH_SCREEN_LOC_INTENT

/obj/screen/intent/ascent_nymph/on_update_icon()
	if(intent == I_HURT || intent == I_GRAB)
		intent = I_GRAB
		icon_state = "intent_harm"
	else
		intent = I_DISARM
		icon_state = "intent_help"

/obj/screen/ascent_nymph_held
	name = "held item"
	screen_loc =  ANYMPH_SCREEN_LOC_HELD
	icon_state = "held"

/obj/screen/ascent_nymph_held/Click()
	var/mob/living/carbon/alien/ascent_nymph/nymph = usr
	if(istype(nymph) && nymph.holding_item) nymph.try_unequip(nymph.holding_item)

/obj/screen/ascent_nymph_molt
	name = "molt"
	icon = 'icons/obj/action_buttons/organs.dmi'
	screen_loc =  ANYMPH_SCREEN_LOC_MOLT
	icon_state = "molt-on"

/obj/screen/ascent_nymph_molt/Click()
	var/mob/living/carbon/alien/ascent_nymph/nymph = usr
	if(istype(nymph)) nymph.molt()

/datum/hud/ascent_nymph
	var/obj/screen/ascent_nymph_held/held
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

	src.adding = list()
	src.other = list()

	held = new
	held.icon =  ui_style
	held.color = ui_color
	held.alpha = ui_alpha
	adding += held

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

	action_intent = new /obj/screen/intent/ascent_nymph()
	action_intent.icon =  ui_style
	action_intent.color = ui_color
	action_intent.alpha = ui_alpha
	adding += action_intent

	mymob.healths = new /obj/screen()
	mymob.healths.icon =  ui_style
	mymob.healths.color = ui_color
	mymob.healths.alpha = ui_alpha
	mymob.healths.SetName("health")
	mymob.healths.screen_loc = ANYMPH_SCREEN_LOC_HEALTH

	mymob.client.screen = list(mymob.healths)
	mymob.client.screen += src.adding + src.other