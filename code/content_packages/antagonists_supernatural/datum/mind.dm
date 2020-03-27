/datum/mind/transfer_to(mob/living/new_character)
	. = ..()
	if(!QDELETED(new_character) && length(learned_spells))
		restore_spells(new_character)
