/******************
* Wizard Familiar *
******************/
/datum/ghosttrap/familiar
	object = "wizard familiar"
	pref_check = MODE_WIZARD
	ghost_trap_message = "They are occupying a familiar now."
	ghost_trap_role = "Wizard Familiar"
	ban_checks = list(MODE_WIZARD)

/datum/ghosttrap/familiar/welcome_candidate(var/mob/target)
	return 0

/datum/ghosttrap/cult
	object = "cultist"
	ban_checks = list("cultist")
	pref_check = MODE_CULTIST
	can_set_own_name = FALSE
	ghost_trap_message = "They are occupying a cultist's body now."
	ghost_trap_role = "Cultist"

/datum/ghosttrap/cult/welcome_candidate(var/mob/target)
	var/obj/item/soulstone/S = target.loc
	if(istype(S))
		if(S.is_evil)
			GLOB.cult.add_antagonist(target.mind)
			to_chat(target, "<b>Remember, you serve the one who summoned you first, and the cult second.</b>")
		else
			to_chat(target, "<b>This soultone has been purified. You do not belong to the cult.</b>")
			to_chat(target, "<b>Remember, you only serve the one who summoned you.</b>")

/datum/ghosttrap/cult/shade
	object = "soul stone"
	ghost_trap_message = "They are occupying a soul stone now."
	ghost_trap_role = "Shade"
