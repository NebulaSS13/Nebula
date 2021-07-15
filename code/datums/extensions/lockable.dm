/datum/extension/lockable
	base_type = /datum/extension/lockable
	expected_type = /obj/item
	flags = EXTENSION_FLAG_IMMEDIATE
	// Configuration variables
	var/max_code_length = 5		// Max length of the password.

	// Stateful variables
	var/locked 			= TRUE	// Is it locked?
	var/code 					// The passcode currently inputed.
	var/l_code 					// The actual code of the lock
	var/l_set 			= FALSE	// Whether or not the lock has been set.
	var/l_setshort 		= FALSE	// Whether or not the ability to set the lock is broken.
	var/l_hacking 		= FALSE	// Whether or not the lock is being hacked.
	var/emagged 		= FALSE	// What or not the lock is emagged.
	var/is_digital_lock = FALSE	// Whether or not the lock is digital, and its ability to be brute forced.
	var/open			= FALSE	// Whether or not the lock panel is open.
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

	var/atom/A = holder
	if(href_list["key"] == "E")
		if(!l_set && !l_setshort)
			// We're in lock set mode.
			if(length(code) < FLOOR(max_code_length * 0.5) || length(code) > max_code_length)
				error = "Incorrect code length. Must be between [FLOOR(max_code_length * 0.5)] and [max_code_length] numbers long."
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
		A.update_icon()
		return TOPIC_REFRESH
	if(href_list["key"] == "C")
		code = null
		error = null
		locked = TRUE
		A.update_icon()
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

/datum/extension/lockable/proc/toggle_panel(var/mob/user)
	if(user)
		user.show_message(SPAN_NOTICE("You [open ? "open" : "close"] the service panel."))
	open = !open

/datum/extension/lockable/proc/attackby(var/obj/item/W, var/mob/user)
	var/obj/item/A = holder
	if(locked)
		if (!is_digital_lock && istype(W, /obj/item/energy_blade/blade) && emag_act(INFINITY, user, "You slice through the lock of \the [holder]"))
			spark_at(A.loc, amount=5)
			playsound(A.loc, 'sound/weapons/blade1.ogg', 50, 1)
			return TRUE

		if(isScrewdriver(W))
			if (do_after(user, 20 * user.skill_delay_mult(SKILL_DEVICES), holder))
				toggle_panel()
			return TRUE

		if(isMultitool(W) && open && !l_hacking)
			user.show_message(SPAN_NOTICE("Now attempting to reset internal memory, please hold."), 1)
			l_hacking = 1
			if (do_after(user, 100 * user.skill_delay_mult(SKILL_ELECTRICAL), holder))
				if (prob(user.skill_fail_chance(SKILL_DEVICES, 40, SKILL_EXPERT)))
					l_setshort = FALSE
					user.show_message(SPAN_NOTICE("Internal memory reset. Please give it a few seconds to reinitialize."), 1)
					addtimer(CALLBACK(src, /datum/extension/lockable/proc/reset_memory), 3 SECONDS)
					return TRUE
				else
					user.show_message(SPAN_WARNING("Unable to reset internal memory."), 1)
					l_hacking = FALSE
					bad_access_attempt(user)
					return TRUE
			else
				l_hacking = FALSE
	return FALSE

/datum/extension/lockable/proc/reset_memory()
	if(!l_hacking)
		return
	reset_memory()
	l_setshort = FALSE
	l_hacking = FALSE
	l_code = null
	l_set = FALSE
	var/atom/movable/A = holder
	A.update_icon()

/datum/extension/lockable/proc/emag_act(var/remaining_charges, var/mob/user, var/feedback)
	var/atom/movable/A = holder
	if(!emagged)
		emagged = TRUE
		locked = FALSE
		to_chat(user, (feedback || "You short out the lock of \the [A]."))
		A.update_icon()
		return TRUE

/datum/extension/lockable/storage
	base_type = /datum/extension/lockable
	expected_type = /obj/item/storage

/datum/extension/lockable/storage/safe
	base_type = /datum/extension/lockable
	expected_type = /obj/item/storage

/datum/extension/lockable/charge_stick
	base_type = /datum/extension/lockable
	expected_type = /obj/item/charge_stick
	var/shock_strength = 0
	var/alarm_loudness = 0

/datum/extension/lockable/charge_stick/bad_access_attempt(var/mob/user)
	if(shock_strength > 0)
		shock(user, 80)
	if(alarm_loudness > 0)
		var/atom/A = holder
		A.audible_message(SPAN_WARNING("\The [holder] shrills in an annoying tone, alerting those nearby of unauthorized tampering."), hearing_distance = alarm_loudness)
		playsound(holder, 'sound/effects/alarm.ogg', 50, 1, alarm_loudness)

/datum/extension/lockable/charge_stick/proc/shock(var/mob/living/user, prb)
	if(!prob(prb) || !istype(user))
		return FALSE
	spark_at(holder, amount=5, cardinal_only = TRUE)
	user.electrocute_act(rand(40 * shock_strength, 80 * shock_strength), holder, shock_strength) //zzzzzzap!
	return TRUE

/datum/extension/lockable/charge_stick/copper
	shock_strength = 0.2
	alarm_loudness = 1
	max_code_length = 5

/datum/extension/lockable/charge_stick/silver
	shock_strength = 0.4
	max_code_length = 7
	alarm_loudness = 3

/datum/extension/lockable/charge_stick/gold
	shock_strength = 0.6
	max_code_length = 9
	alarm_loudness = 5

/datum/extension/lockable/charge_stick/platinum
	shock_strength = 0.9
	max_code_length = 11
	alarm_loudness = 7