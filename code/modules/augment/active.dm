//Toggleable embedded module
/obj/item/organ/internal/augment/active
	action_button_name = "Activate"

/obj/item/organ/internal/augment/active/proc/activate()
	return

/obj/item/organ/internal/augment/active/proc/can_activate()
	if(!owner || owner.incapacitated() || !is_usable() || (status & ORGAN_CUT_AWAY))
		to_chat(owner, SPAN_WARNING("You can't do that now!"))
		return FALSE
	return TRUE

/obj/item/organ/internal/augment/active/attack_self()
	. = ..()
	if(. && can_activate())
		activate()

//Need to change icon?
/obj/item/organ/internal/augment/active/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = icon_state
		action.button?.update_icon()
