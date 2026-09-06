/decl/keycard_auth_event
	abstract_type = /decl/keycard_auth_event
	decl_flags = DECL_FLAG_MANDATORY_UID
	var/name = "Abstract Keycard Authentication Event"

/decl/keycard_auth_event/proc/get_link_text(obj/machinery/keycard_auth/auth, mob/user)
	return name

/decl/keycard_auth_event/proc/is_available(obj/machinery/keycard_auth/auth, mob/user)
	return TRUE

/decl/keycard_auth_event/proc/get_option(obj/machinery/keycard_auth/auth, mob/user)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/fail_reason = get_failure_reason(user)
	if(fail_reason)
		return fail_reason
	return "<a href='byond://?src=\ref[auth];triggerevent=[uid]'>[get_link_text(auth, user)]</a>"

/decl/keycard_auth_event/proc/get_failure_reason(obj/machinery/keycard_auth/auth, mob/user)
	return

/decl/keycard_auth_event/proc/on_event(obj/machinery/keycard_auth/auth)
	return

/decl/keycard_auth_event/high_security
	name = "Toggle High Security Level"
	uid = "keycard_event_toggle_high_security"

/decl/keycard_auth_event/high_security/get_failure_reason(obj/machinery/keycard_auth/auth, mob/user)
	var/decl/security_state/security_state = GET_DECL(global.using_map.security_state)
	if(security_state.current_security_level == security_state.severe_security_level)
		return "Cannot modify the alert level at this time: [security_state.severe_security_level.name] engaged."

/decl/keycard_auth_event/high_security/get_link_text(obj/machinery/keycard_auth/auth, mob/user)
	var/decl/security_state/security_state = GET_DECL(global.using_map.security_state)
	if(security_state.current_security_level == security_state.high_security_level) // toggle!
		return "Disengage [security_state.high_security_level.name]"
	else
		return "Engage [security_state.high_security_level.name]"

/decl/keycard_auth_event/high_security/on_event(obj/machinery/keycard_auth/auth, mob/user)
	var/decl/security_state/security_state = GET_DECL(global.using_map.security_state)
	if(security_state.current_security_level == security_state.high_security_level)
		security_state.set_security_level(security_state.stored_security_level)
		SSstatistics.add_field("alert_keycard_revert_red",1)
	else
		security_state.stored_security_level = security_state.current_security_level
		security_state.set_security_level(security_state.high_security_level)
		SSstatistics.add_field("alert_keycard_auth_red",1)

/decl/keycard_auth_event/maintenance_access
	name = "Toggle Emergency Maintenance Access"
	uid = "keycard_event_maintenance_access"

/decl/keycard_auth_event/maintenance_access/get_link_text(obj/machinery/keycard_auth/auth, mob/user)
	if(global.using_map.maint_all_access)
		return "Revoke Emergency Maintenance Access"
	else
		return "Grant Emergency Maintenance Access"

/decl/keycard_auth_event/maintenance_access/on_event(obj/machinery/keycard_auth/auth)
	if(global.using_map.maint_all_access)
		global.using_map.revoke_maint_all_access()
		SSstatistics.add_field("alert_keycard_auth_maintRevoke",1)
	else
		global.using_map.make_maint_all_access()
		SSstatistics.add_field("alert_keycard_auth_maintGrant",1)

/decl/keycard_auth_event/nuke_code
	name = "Grant Nuclear Authorization Code"
	uid = "keycard_event_nuke_code"

/decl/keycard_auth_event/nuke_code/on_event(obj/machinery/keycard_auth/auth)
	var/obj/machinery/nuclearbomb/nuke = locate(/obj/machinery/nuclearbomb/station) in SSmachines.machinery
	if(nuke)
		auth.visible_message(SPAN_WARNING("\The [src] blinks and displays a message: The nuclear authorization code is [nuke.r_code]"), range=2)
	else
		auth.visible_message(SPAN_WARNING("\The [src] blinks and displays a message: No self-destruct terminal found."), range=2)
	SSstatistics.add_field("alert_keycard_auth_nukecode",1)