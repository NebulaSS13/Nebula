/decl/interaction_handler/admin_kill
	name = "Admin Kill"
	expected_user_type = /mob/observer
	expected_target_type = /mob/living
	interaction_flags = 0

/decl/interaction_handler/admin_kill/is_possible(atom/target, mob/user)
	. = ..()
	if(.)
		if(!check_rights(R_INVESTIGATE, 0, user)) 
			return FALSE
		var/mob/living/M = target
		if(M.stat == DEAD)
			return FALSE

/decl/interaction_handler/admin_kill/invoked(atom/target, mob/user)
	var/mob/living/M = target
	var/key_name = key_name(M)
	if(alert(user, "Do you wish to kill [key_name]?", "Kill \the [M]?", "No", "Yes") != "Yes")
		return FALSE
	if(!is_possible(target, user))
		to_chat(user, SPAN_NOTICE("You were unable to kill [key_name]."))
		return FALSE
	M.death()
	log_and_message_admins("\The [user] admin-killed [key_name].")
