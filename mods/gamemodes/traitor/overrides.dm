/mob/living/silicon/is_malfunctioning()
	var/decl/special_role/traitors = GET_DECL(/decl/special_role/traitor)
	return mind && traitors.is_antagonist(mind)

/mob/living/silicon/robot/show_master(mob/who)
	// TODO: Update to new antagonist system.
	if (mind?.assigned_special_role == /decl/special_role/traitor && mind.original == src && connected_ai)
		to_chat(who, "<b>Remember, [connected_ai.name] is technically your master, but your objective comes first.</b>")
		return
	return ..()

/mob/living/silicon/robot/lawsync()
	. = ..()
	// TODO: Update to new antagonist system.
	if(mind?.assigned_special_role == /decl/special_role/traitor && mind.original == src)
		to_chat(src, SPAN_BOLD("Remember, your AI does NOT share or know about your law 0."))

/mob/living/silicon/robot/handle_regular_hud_updates()
	. = ..()
	if(!.)
		return
	if (syndicate && client)
		var/decl/special_role/traitors = GET_DECL(/decl/special_role/traitor)
		for(var/datum/mind/tra in traitors.current_antagonists)
			if(tra.current)
				// TODO: Update to new antagonist system.
				var/I = image('icons/mob/mob.dmi', loc = tra.current, icon_state = "traitor")
				src.client.images += I
		disconnect_from_ai()
		if(mind)
			traitors.add_antagonist_mind(mind)