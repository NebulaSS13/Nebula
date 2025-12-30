/decl/mob_modifier/stasis
	name           = "Stasis"
	desc           = "Your life processes have been reduced or halted by stasis."
	hud_icon_state = "stasis"
	hide_expiry    = TRUE

/decl/mob_modifier/stasis/on_modifier_datum_mob_life(mob/living/_owner, list/modifiers)
	. = ..()

	var/decl/bodytype/my_bodytype = _owner.get_bodytype()
	if(my_bodytype?.body_flags & BODY_FLAG_NO_STASIS)
		return

	var/stasis_power = 0
	for(var/datum/mob_modifier/modifier in modifiers)
		var/atom/movable/source_atom = modifier.source?.resolve()
		if(istype(source_atom))
			var/add_stasis = source_atom.get_cryogenic_power()
			if(add_stasis)
				stasis_power += add_stasis
				to_chat(_owner, "[source_atom] gave [add_stasis]")

	if(stasis_power > 1 && GET_STATUS(_owner, STAT_DROWSY) < stasis_power * 4)
		ADJ_STATUS(_owner, STAT_DROWSY, min(stasis_power, 3))
		if(_owner.stat == CONSCIOUS)// && prob(1))
			to_chat(_owner, SPAN_NOTICE("You feel slow and sluggish..."))
