/mob/living/brain
	name = "brain"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "brain1"

	// Used for EMP damage when inside an interface or robobrain.
	var/emp_damage = 0
	var/last_emp_message = 0
	var/static/max_emp_damage = 30
	var/static/list/emp_reboot_strings = list(
		SPAN_NOTICE("System reboot nearly complete."),
		SPAN_NOTICE("Primary systems are now online."),
		SPAN_DANGER("Major electrical distruption detected: System rebooting.")
	)

/mob/living/brain/get_default_emotes()
	var/static/list/default_emotes = list(
		/decl/emote/audible/alarm,
		/decl/emote/audible/alert,
		/decl/emote/audible/notice,
		/decl/emote/audible/whistle,
		/decl/emote/audible/synth,
		/decl/emote/audible/boop,
		/decl/emote/visible/blink,
		/decl/emote/visible/flash
	)
	return default_emotes

/mob/living/brain/handle_regular_status_updates()
	. = ..()
	if(emp_damage || stat == DEAD || !is_in_interface())
		SET_STATUS_MAX(src, STAT_SILENCE, 2)

/mob/living/brain/is_deaf()
	return emp_damage || stat == DEAD || !is_in_interface()

/mob/living/brain/is_blind()
	return emp_damage || stat == DEAD || !is_in_interface()

/mob/living/brain/Logout()
	. = ..()
	var/obj/item/organ/internal/container = get_container()
	if(istype(container))
		container.queue_icon_update()

/mob/living/brain/proc/get_container()
	. = loc?.loc

/mob/living/brain/Login()
	. = ..()
	var/obj/item/organ/internal/container = get_container()
	if(istype(container))
		var/obj/item/organ/internal/brain_interface/interface = container
		if(istype(interface))
			interface.locked = TRUE
		container.update_icon()

/mob/living/brain/proc/is_in_interface()
	var/container = get_container()
	return istype(container, /obj/item/organ/internal/brain_interface) || istype(container, /obj/item/organ/internal/brain/robotic)

/mob/living/brain/can_emote(emote_type, show_message)
	return is_in_interface() && ..()

/mob/living/brain/can_use_rig()
	return is_in_interface()

/mob/living/brain/Destroy()
	ghostize()
	. = ..()

/mob/living/brain/say_understands(var/other)
	. = ishuman(other) || (is_in_interface() && issilicon(other)) || ..()

/mob/living/brain/get_available_postures()
	var/static/list/available_postures = list(
		/decl/posture/standing
	)
	return available_postures

/mob/living/brain/isSynthetic()
	return istype(get_container(), /obj/item/organ/internal/brain/robotic)

/mob/living/brain/binarycheck()
	return isSynthetic()

/mob/living/brain/check_has_mouth()
	return FALSE

/mob/living/brain/emp_act(severity)
	if(!isSynthetic())
		return
	switch(severity)
		if(1)
			emp_damage += rand(20,30)
		if(2)
			emp_damage += rand(10,20)
		if(3)
			emp_damage += rand(0,10)
	emp_damage = clamp(emp_damage, 0, max_emp_damage)

/mob/living/brain/handle_regular_status_updates() // Status & health update, are we dead or alive etc.
	. = ..()
	if(stat == DEAD || !isSynthetic())
		emp_damage = 0
		return
	if(emp_damage <= 0)
		return
	emp_damage -= 1
	var/msg_threshold = clamp(ceil(emp_damage / (max_emp_damage / length(emp_reboot_strings))), 1, length(emp_reboot_strings))
	if(last_emp_message != msg_threshold)
		last_emp_message = msg_threshold
		to_chat(src, emp_reboot_strings[msg_threshold])
	if(emp_damage <= 0)
		last_emp_message = 0
		emp_damage = 0
		to_chat(src, SPAN_NOTICE("All systems restored."))
