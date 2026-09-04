/decl/keycard_auth_event/call_ert
	name = "Emergency Response Team"
	uid = "keycard_event_call_ert"

/decl/keycard_auth_event/call_ert/is_available(obj/machinery/keycard_auth/auth, mob/user)
	if(get_config_value(/decl/config/toggle/ert_admin_call_only))
		return FALSE
	return TRUE

/decl/keycard_auth_event/call_ert/on_event(obj/machinery/keycard_auth/auth)
	if(!SSticker.mode || SSticker.mode.ert_disabled) // disabled by mode
		auth.visible_message(SPAN_WARNING("\The [src] blinks and displays a message: All emergency response teams are dispatched and can not be called at this time."), range=2)
		return

	trigger_armed_response_team(1)
	SSstatistics.add_field("alert_keycard_auth_ert",1)