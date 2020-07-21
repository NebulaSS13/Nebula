/*****************
* Cortical Borer *
*****************/
/decl/ghosttrap/cortical_borer
	name = "cortical borer"
	ban_checks = list(MODE_BORER)
	pref_check = "ghost_borer"
	ghost_trap_message = "They are occupying a borer now."
	can_set_own_name = FALSE
	list_as_special_role = FALSE

/decl/ghosttrap/cortical_borer/forced(var/mob/user)
	request_player(new /mob/living/simple_animal/borer(get_turf(user)), "A cortical borer needs a player.")

/decl/ghosttrap/cortical_borer/welcome_candidate(var/mob/target)
	to_chat(target, SPAN_NOTICE("<b>You are a cortical borer!</b> You are a brain slug that worms its way \
	into the head of its victim. Use stealth, persuasion and your powers of mind control to keep you, \
	your host and your eventual spawn safe and warm."))
	to_chat(target, SPAN_NOTICE("You can speak to your victim with <b>say</b>, to other borers with <b>say [target.get_language_prefix()]x</b>, and use your Abilities tab to access powers."))
