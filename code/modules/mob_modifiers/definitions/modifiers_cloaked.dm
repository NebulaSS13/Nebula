/decl/mob_modifier/cloaked
	name                 = "Cloaked"
	desc                 = "You are hidden from casual sight."
	hud_icon_state       = "cloaked"
	on_add_message_1p    = SPAN_NOTICE("You feel completely invisible.")
	on_add_message_3p    = SPAN_WARNING("$USER$ seems to disappear before your eyes!")
	on_end_message_1p    = SPAN_NOTICE("You have re-appeared.")
	on_end_message_3p    = SPAN_WARNING("$USER$ appears from thin air!")
	can_be_admin_granted = TRUE

// Not ideal, but existing cloaking code is iffy about removing cloaking sources appropriately (specifically rig modules)
/decl/mob_modifier/cloaked/on_modifier_datum_mob_life(mob/living/_owner, list/modifiers)
	. = ..()
	for(var/datum/mob_modifier/modifier in modifiers)
		var/atom/source = modifier.source?.resolve()
		if(istype(source) && source.get_recursive_loc_of_type(/mob/living) != _owner)
			_owner.remove_mob_modifier(src, source = source)
