/obj/item/organ/internal/egg_sac/insectoid
	name = "gyne egg-sac"
	action_button_name = "Produce Egg"
	organ_tag = BP_EGG
	var/egg_metabolic_cost = 100

/obj/item/organ/internal/egg_sac/insectoid/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "egg-on"
		action.button?.update_icon()

/obj/item/organ/internal/egg_sac/insectoid/attack_self(var/mob/user)
	. = ..()
	var/mob/living/H = user
	if(.)
		if(H.incapacitated())
			to_chat(H, SPAN_WARNING("You can't produce eggs in your current state."))
			return
		if(H.nutrition < egg_metabolic_cost)
			to_chat(H, SPAN_WARNING("You are too ravenously hungry to produce more eggs."))
			return
		if(do_after(H, 5 SECONDS, H, FALSE))
			H.adjust_nutrition(-1 * egg_metabolic_cost)
			H.visible_message(SPAN_NOTICE("\icon[H] [H] carelessly deposits an egg on \the [get_turf(src)]."))
			var/obj/structure/insectoid_egg/egg = new(get_turf(H)) // splorp
			egg.lineage = H.get_gyne_lineage()

/obj/item/organ/external/foot/insectoid/mantid
	name = "left tail tip"

/obj/item/organ/external/foot/right/insectoid/mantid
	name = "right tail tip"

/obj/item/organ/external/leg/insectoid/mantid
	name = "left tail side"

/obj/item/organ/external/leg/right/insectoid/mantid
	name = "right tail side"
