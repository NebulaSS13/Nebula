/spell/hand/burning_grip
	name = "Burning Grip"
	desc = "Cause someone to drop a held object by causing it to heat up intensly."
	school = "transmutation"
	feedback = "bg"
	range = 5
	spell_flags = 0
	invocation_type = SpI_NONE
	show_message = " throws sparks from their hands"
	spell_delay = 120
	hud_state = "wiz_burn"
	cast_sound = 'sound/magic/fireball.ogg'
	compatible_targets = list(/mob/living/carbon/human)

/spell/hand/burning_grip/valid_target(var/mob/living/L, var/mob/user)
	if(!..())
		return 0
	if(length(L.get_held_items()))
		return 0
	return 1

/spell/hand/burning_grip/cast_hand(var/mob/living/carbon/human/H, var/mob/user)
	var/list/targets = list()
	for(var/hand_slot in H.get_held_item_slots())
		targets |= hand_slot

	var/obj/O = new /obj/effect/temporary(get_turf(H),3, 'icons/effects/effects.dmi', "fire_goon")
	O.alpha = 150

	for(var/organ in targets)
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(H, organ)
		if(!E)
			continue
		E.take_external_damage(burn=10, used_weapon = "hot iron")
		if(E.can_feel_pain())
			E.check_pain_disarm()
		else
			E.take_external_damage(burn=6, used_weapon = "hot iron")
			to_chat(H, SPAN_WARNING("You notice that your [E] is burned."))

/spell/hand/burning_grip/tower
	desc = "Allows you cause an object to heat up intensly in someone's hand, making them drop it and whatever skin is attached."
	charge_max = 3