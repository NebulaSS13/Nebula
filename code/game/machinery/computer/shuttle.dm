/obj/machinery/computer/shuttle
	name = "Shuttle"
	desc = "For shuttle control."
	icon_keyboard = "tech_key"
	icon_screen = "shuttle"
	light_color = "#00ffff"
	construct_state = null
	var/auths_needed = 3
	var/list/authorized

/obj/machinery/computer/shuttle/Initialize()
	if(!istype(SSevac.evacuation_controller, /datum/evacuation_controller/shuttle))
		PRINT_STACK_TRACE("Shuttle console found without a shuttle evacuation controller!")
		return INITIALIZE_HINT_QDEL
	return ..()

/obj/machinery/computer/shuttle/attackby(var/obj/item/used_item, var/mob/user)
	if(stat & (BROKEN|NOPOWER))
		return TRUE

	var/obj/item/card/id/id_card = used_item.GetIdCard() // if used_item is already an ID, it'll just return itself
	if(!istype(id_card, /obj/item/card/id) || SSevac.evacuation_controller.has_evacuated() || SSevac.evacuation_controller.is_prepared() || !user)
		return FALSE

	if(!LAZYISIN(id_card.access, access_bridge)) //doesn't have the required access
		to_chat(user, "The access level of [id_card.registered_name]\'s card is not high enough.")
		return TRUE

	var/choice = alert(user, "Would you like to (un)authorize a shortened launch time? [auths_needed - LAZYLEN(authorized)] authorization\s are still needed. Use abort to cancel all authorizations.", "Shuttle Launch", "Authorize", "Repeal", "Abort")
	// since alert() sleeps, we need to recheck the previous SSevacuation conditions
	// and make sure used_item is still being held
	if(SSevac.evacuation_controller.has_evacuated() || SSevac.evacuation_controller.is_prepared() || user.get_active_held_item() != used_item)
		return TRUE // we've already had a user-visible interaction, so return TRUE to avoid further interactions this click
	switch(choice)
		if("Authorize")
			LAZYDISTINCTADD(authorized, id_card.registered_name)
			if (LAZYLEN(authorized) >= auths_needed)
				message_admins("[key_name_admin(user)] has launched the shuttle")
				log_game("[user.ckey] has launched the shuttle early")
				to_world(SPAN_NOTICE("<b>Alert: Shuttle launch time shortened to 10 seconds!</b>"))
				SSevac.evacuation_controller.evac_launch_time = world.time + 10 SECONDS
				LAZYCLEARLIST(authorized)
			else
				message_admins("[key_name_admin(user)] has authorized early shuttle launch")
				log_game("[user.ckey] has authorized early shuttle launch")
				to_world(SPAN_NOTICE("<b>Alert: [auths_needed - LAZYLEN(authorized)] authorizations needed until shuttle is launched early</b>"))

		if("Repeal")
			LAZYREMOVE(authorized, id_card.registered_name)
			to_world(SPAN_NOTICE("<b>Alert: [auths_needed - LAZYLEN(authorized)] authorizations needed until shuttle is launched early</b>"))

		if("Abort")
			to_world(SPAN_NOTICE("<b>All authorizations to shortening time for shuttle launch have been revoked!</b>"))
			LAZYCLEARLIST(authorized)
	return TRUE

/obj/machinery/computer/shuttle/emag_act(remaining_charges, mob/user, emag_source)
	// Must not be launched or launching, and not already emagged
	if(SSevac.evacuation_controller.has_evacuated() || SSevac.evacuation_controller.is_prepared() || emagged)
		return NO_EMAG_ACT
	to_world(SPAN_NOTICE("<b>Alert: Shuttle launch time shortened to 10 seconds!</b>"))
	SSevac.evacuation_controller.evac_launch_time = world.time + 10 SECONDS
	emagged = TRUE
	return 1 // not a bool, number of charges to consume