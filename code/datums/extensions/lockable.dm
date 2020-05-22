/datum/extension/lockable
	base_type = /datum/extension/lockable
	expected_type = /obj/item
	flags = EXTENSION_FLAG_IMMEDIATE
	// Configuration variables
	var/max_code_length = 5		// Max length of the password.

	// Stateful variables
	var/locked 			= 1		// Is it locked?
	var/code 					// The passcode currently inputed.
	var/l_code 			= null	// The actual code of the lock
	var/l_set 			= 0		// Whether or not the lock has been set.
	var/l_setshort 		= 0		// Whether or not the ability to set the lock is broken.
	var/l_hacking 		= 0		// Whether or not the lock is being hacked.
	var/emagged 		= 0		// What or not the lock is emagged.
	var/is_digital_lock = FALSE	// Whether or not the lock is digital, and its ability to be brute forced.
	var/open			= 0		// Whether or not the lock panel is open.
	var/error					// Any errors from user input. Temporary.

/datum/extension/lockable/New(holder, var/is_digital = FALSE)
	..(holder)
	is_digital_lock = is_digital

/datum/extension/lockable/nano_host()
	return holder.nano_host()

/datum/extension/lockable/ui_data(mob/user, ui_key)
	var/list/data[0]
	data["emagged"] = emagged
	data["locked"] = locked
	data["disabled"] = l_setshort || emagged
	if(emagged)
		data["error"] = "LOCKING SYSTEM ERROR - 1701"
	else if(l_setshort)
		data["error"] = "ALERT: MEMORY SYSTEM ERROR - 6040 201"
	else if(error)
		data["error"] = error
	if((src.l_set == 0) && (!src.emagged) && (!src.l_setshort))
		data["status"] = "[max_code_length]-DIGIT PASSCODE NOT SET. ENTER NEW PASSCODE."
	data["input_code"] = !locked ? "*****" : (code ? code : "N/A")
	return data

/datum/extension/lockable/Topic(href, href_list)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	if(!can_interact(user))
		return

	// Always clear error.
	error = null

	var/key_num = text2num(href_list["key"])
	if(isnum(key_num))
		code += href_list["key"]
		return TOPIC_REFRESH
	if(href_list["key"] == "E")
		if(!l_set && !l_setshort)
			// We're in lock set mode.
			if(length(code) != max_code_length)
				error = "Incorrect code length. Must be [max_code_length] numbers long."
				return TOPIC_REFRESH
			l_code = code
			code = null
			l_set = TRUE
			locked = FALSE
		else if(locked && !emagged && !l_setshort)
			if(code != l_code)
				error = "Invalid keycode entered."
				bad_access_attempt(user)
				return TOPIC_REFRESH
			locked = FALSE
			code = null
		return TOPIC_REFRESH
	if(href_list["key"] == "C")
		code = null
		error = null
		locked = TRUE
		return TOPIC_REFRESH

/datum/extension/lockable/proc/bad_access_attempt(var/mob/user)

/datum/extension/lockable/proc/can_interact(user)
	return holder.CanUseTopic(user) == STATUS_INTERACTIVE

/datum/extension/lockable/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/data = ui_data(user)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		var/atom/A = holder
		ui = new(user, src, ui_key, "keypad_lock.tmpl", capitalize(A.name), 380, 500)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/extension/lockable/proc/open()

/datum/extension/lockable/proc/close()

/datum/extension/lockable/proc/attackby(var/obj/item/W, var/mob/user)
	var/obj/item/A = holder
	if(locked)
		if (!is_digital_lock && istype(W, /obj/item/melee/energy/blade) && emag_act(INFINITY, user, "You slice through the lock of \the [holder]"))
			var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
			spark_system.set_up(5, 0, A.loc)
			spark_system.start()
			playsound(A.loc, 'sound/weapons/blade1.ogg', 50, 1)
			playsound(A.loc, "sparks", 50, 1)
			return TRUE

		if(isScrewdriver(W))
			if (do_after(user, 20 * user.skill_delay_mult(SKILL_DEVICES), holder))
				if(open)
					close()
				else
					open()
				user.show_message(SPAN_NOTICE("You [open ? "open" : "close"] the service panel."))
			return TRUE

		if(isMultitool(W) && open && !l_hacking)
			user.show_message(SPAN_NOTICE("Now attempting to reset internal memory, please hold."), 1)
			l_hacking = 1
			if (do_after(user, 100 * user.skill_delay_mult(SKILL_ELECTRICAL), holder))
				if (prob(user.skill_fail_chance(SKILL_DEVICES, 40, SKILL_EXPERT)))
					l_setshort = 1
					user.show_message(SPAN_NOTICE("Internal memory reset. Please give it a few seconds to reinitialize."), 1)
					addtimer(CALLBACK(src, /datum/extension/lockable/proc/reset_memory), 3 SECONDS)
					return TRUE
				else
					user.show_message(SPAN_WARNING("Unable to reset internal memory."), 1)
					l_hacking = 0
					bad_access_attempt(user)
					return TRUE
			else	
				l_hacking = 0
	return FALSE

/datum/extension/lockable/proc/reset_memory()
	if(!l_hacking)
		return
	reset_memory()
	l_setshort = 0
	l_hacking = 0
	l_code = null
	l_set = FALSE

/datum/extension/lockable/proc/emag_act(var/remaining_charges, var/mob/user, var/feedback)
	var/atom/movable/A = holder
	if(!emagged)
		emagged = 1
		locked = 0
		to_chat(user, (feedback ? feedback : "You short out the lock of \the [A]."))
		return 1

/datum/extension/lockable/storage
	base_type = /datum/extension/lockable
	expected_type = /obj/item/storage
	

/datum/extension/lockable/storage/open()
	open = TRUE

/datum/extension/lockable/storage/close()
	open = FALSE

/datum/extension/lockable/storage/safe
	base_type = /datum/extension/lockable
	expected_type = /obj/item/storage