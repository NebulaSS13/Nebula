/obj/screen/warning
	use_supplied_ui_color = TRUE
	use_supplied_ui_alpha = TRUE
	var/base_state
	var/check_alert

/obj/screen/warning/on_update_icon()
	. = ..()
	if(base_state && check_alert)
		var/mob/living/owner = owner_ref?.resolve()
		if(istype(owner))
			icon_state = "[base_state][GET_HUD_ALERT(owner, check_alert)]"
