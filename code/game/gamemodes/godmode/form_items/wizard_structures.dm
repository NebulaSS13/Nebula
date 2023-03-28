/obj/structure/deity/altar/tower
	icon_state = "tomealtar"

/obj/structure/deity/wizard_recharger
	name = "fountain of power"
	desc = "Refreshing, cool water surrounded by archaic carvings."
	icon_state = "fountain"
	power_adjustment = 2
	build_cost = 700

/obj/structure/deity/wizard_recharger/attack_hand(var/mob/hitter)
	SHOULD_CALL_PARENT(FALSE)
	if(!length(hitter.mind?.learned_spells))
		to_chat(hitter, SPAN_WARNING("You don't feel as if this will do anything for you."))
		return TRUE

	hitter.visible_message(SPAN_NOTICE("\The [hitter] dips their hands into \the [src], a soft glow emanating from them."))
	if(do_after(hitter,300,src,check_holding=0))
		for(var/s in hitter.mind.learned_spells)
			var/spell/spell = s
			spell.charge_counter = spell.charge_max
		to_chat(hitter, SPAN_NOTICE("You feel refreshed!"))
	else
		to_chat(hitter, SPAN_WARNING("You need to keep in contact with \the [src]!"))
	return TRUE