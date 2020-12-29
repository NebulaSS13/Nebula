/obj/screen/intent/ascent_nymph
	icon = 'mods/species/ascent/icons/species/nymph.dmi'
	icon_state = "intent_devour"
	screen_loc = ANYMPH_SCREEN_LOC_INTENT

/obj/screen/intent/ascent_nymph/on_update_icon()
	if(intent == I_HURT || intent == I_GRAB)
		intent = I_GRAB
		icon_state = "intent_expel"
	else
		intent = I_DISARM
		icon_state = "intent_devour"

/obj/screen/ascent_nymph
	icon = 'mods/species/ascent/icons/species/nymph.dmi'

/obj/screen/ascent_nymph/held
	name = "held item"
	screen_loc =  ANYMPH_SCREEN_LOC_HELD
	icon_state = "held"

/obj/screen/ascent_nymph/held/Click()
	var/mob/living/carbon/alien/ascent_nymph/nymph = usr
	if(istype(nymph) && nymph.holding_item) nymph.unEquip(nymph.holding_item)

/obj/screen/ascent_nymph/molt
	name = "molt"
	icon = 'icons/obj/action_buttons/organs.dmi'
	screen_loc =  ANYMPH_SCREEN_LOC_MOLT
	icon_state = "molt-on"

/obj/screen/ascent_nymph/molt/Click()
	var/mob/living/carbon/alien/ascent_nymph/nymph = usr
	if(istype(nymph)) nymph.molt()

/datum/hud/ascent_nymph
	var/obj/screen/ascent_nymph/held/held
	var/obj/screen/ascent_nymph/molt/molt
	var/obj/screen/food/food
	var/obj/screen/drink/drink

/datum/hud/ascent_nymph/FinalizeInstantiation()

	src.adding = list()
	src.other = list()

	held = new
	adding += held

	molt = new
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
	adding += action_intent

	mymob.healths = new /obj/screen()
	mymob.healths.SetName("health")
	mymob.healths.screen_loc = ANYMPH_SCREEN_LOC_HEALTH

	mymob.client.screen = list(mymob.healths)
	mymob.client.screen += src.adding + src.other