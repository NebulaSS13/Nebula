/obj/machinery/computer/upload
	name = "\improper AI upload console"
	desc = "Used to upload laws to the AI."
	icon_keyboard = "rd_key"
	icon_screen = "command"
	var/target_noun = "active AIs"
	var/mob/living/silicon/current

/obj/machinery/computer/upload/proc/select_valid_target(var/mob/user)
	return select_active_ai(user, get_z(src))

/obj/machinery/computer/upload/proc/get_target(var/mob/user)
	current = select_valid_target(user)
	if (!current)
		to_chat(user, SPAN_WARNING("No [target_noun] detected."))
	else
		to_chat(user, SPAN_NOTICE("You have selected \the [current] for law changes."))
	return TRUE

/obj/machinery/computer/upload/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/ai_law_module))
		var/obj/item/ai_law_module/module = O
		if(stat & BROKEN)
			to_chat(user, SPAN_WARNING("\The [src] is not working!"))
			return TRUE
		if(stat & NOPOWER)
			to_chat(user, SPAN_WARNING("\The [src] has no power!"))
			return TRUE
		if(!current)
			to_chat(user, SPAN_WARNING("You haven't selected an intelligence to transmit laws to!"))
			return TRUE
		if(current.stat == DEAD)
			to_chat(user, SPAN_WARNING("Upload failed. No signal is being detected from the intelligence."))
			return
		if(istype(current, /mob/living/silicon/ai))
			var/mob/living/silicon/ai/ai = current
			if(ai.control_disabled)
				to_chat(user, SPAN_WARNING("Upload failed. No signal is being detected from the intelligence."))
				return TRUE
			else if(!ai.see_in_dark)
				to_chat(user, SPAN_WARNING("Upload failed. Only a faint signal is being detected from the intelligence, and it is not responding to our requests. It may be low on power."))
				return TRUE
		if(module.apply_laws_to(current, user))
			to_chat(user, SPAN_NOTICE("Upload complete. The intelligence's laws have been modified."))
		return TRUE
	. = ..()

/obj/machinery/computer/upload/interface_interact(var/mob/user)
	if(CanInteract(user, DefaultTopicState()))
		current = get_target(user)
		return TRUE
	return FALSE

/obj/machinery/computer/upload/robot
	name = "robot law upload console"
	desc = "Used to upload laws to robots."
	target_noun = "free robots"

/obj/machinery/computer/upload/robot/select_valid_target(var/mob/user)
	return freeborg(get_z(src))
