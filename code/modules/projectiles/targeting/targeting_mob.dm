/mob/living
	VAR_PRIVATE/obj/abstract/aiming_overlay/_aiming
	var/list/aimed_at_by

/mob/living/proc/get_aiming_overlay(create_if_missing = FALSE)
	RETURN_TYPE(/obj/abstract/aiming_overlay)
	if(create_if_missing && !_aiming)
		_aiming = new(src)
	return _aiming

//Needs to be a mob verb to prevent error messages when using hotkeys
/mob/verb/toggle_gun_mode_verb()
	set name = "Toggle Gun Mode"
	set desc = "Begin or stop aiming."
	set category = "IC"
	toggle_gun_mode()

/mob/proc/toggle_gun_mode()
	to_chat(src, SPAN_WARNING("This verb may only be used by living mobs, sorry."))

/mob/living/toggle_gun_mode()
	var/obj/abstract/aiming_overlay/aiming = get_aiming_overlay(create_if_missing = TRUE)
	aiming.toggle_active()

/mob/living/proc/stop_aiming(var/obj/item/thing, var/no_message = 0)
	var/obj/abstract/aiming_overlay/aiming = get_aiming_overlay()
	if(!aiming || (thing && aiming.aiming_with != thing))
		return
	aiming.cancel_aiming(no_message)
