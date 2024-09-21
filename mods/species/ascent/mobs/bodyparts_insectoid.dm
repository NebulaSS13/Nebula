/datum/action/item_action/organ/ascent
	button_icon = 'mods/species/ascent/icons/actions.dmi'

/obj/item/organ/internal/egg_sac/insectoid
	name = "gyne egg-sac"
	action_button_name = "Produce Egg"
	organ_tag = BP_EGG
	default_action_type = /datum/action/item_action/organ/ascent
	var/egg_metabolic_cost = 100

/obj/item/organ/internal/egg_sac/insectoid/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "egg-on"
		action.button?.update_icon()

/obj/item/organ/internal/egg_sac/insectoid/attack_self(var/mob/user)
	. = ..()
	var/mob/living/living_user = user
	if(.)
		if(living_user.incapacitated())
			to_chat(living_user, SPAN_WARNING("You can't produce eggs in your current state."))
			return
		if(living_user.nutrition < egg_metabolic_cost)
			to_chat(living_user, SPAN_WARNING("You are too ravenously hungry to produce more eggs."))
			return
		if(do_after(living_user, 5 SECONDS, living_user, FALSE))
			living_user.adjust_nutrition(-1 * egg_metabolic_cost)
			living_user.visible_message(SPAN_NOTICE("\icon[living_user] [living_user] carelessly deposits an egg on \the [get_turf(src)]."))
			var/obj/structure/insectoid_egg/egg = new(get_turf(living_user)) // splorp
			egg.lineage = living_user.get_gyne_lineage()

/obj/item/organ/external/foot/insectoid/mantid
	name = "left tail tip"

/obj/item/organ/external/foot/right/insectoid/mantid
	name = "right tail tip"

/obj/item/organ/external/leg/insectoid/mantid
	name = "left tail side"

/obj/item/organ/external/leg/right/insectoid/mantid
	name = "right tail side"
