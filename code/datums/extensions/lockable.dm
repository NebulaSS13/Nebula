/**Sent by the lockable when it's been locked or unlocked. */
/decl/observ/lock_state_changed
	name = "lockable state changed"

/**Sent by lockable when the service panel is opened/closed. */
/decl/observ/lock_panel_state_changed
	name = "lockable panel state changed"

/decl/observ/keypad_pressed
	name = "lockable keypad pressed"

/**
	Extension for giving an object a code lock, with it's own ui.
 */
/datum/extension/lockable
	base_type     = /datum/extension/lockable
	expected_type = /obj/item
	flags         = EXTENSION_FLAG_IMMEDIATE

	/// Max length of the password.
	var/max_code_length = 5
	///Whether the lock is locked.
	var/locked = TRUE
	/// The code to unlock the lock
	var/l_code
	/// Whether or not the lock has been set.
	var/l_set = FALSE
	/// Whether or not the ability to set the lock is broken.
	var/l_setshort = FALSE
	/// Whether or not the lock is being hacked.
	var/tmp/l_hacking = FALSE
	/// Whether or not the lock is emagged.
	var/emagged = FALSE
	/// Whether or not the lock is digital, and its ability to be brute forced.
	var/is_digital_lock = FALSE
	/// Whether or not the lock service panel is open.
	var/open = FALSE
	/// The absolute range in turfs the lockable's sounds can be heard at from the holder's position.
	var/sound_range = 5
	/// Whether we're currently opening the panel or not. (Unskilled people can take a long time to open it)
	var/tmp/opening_panel = FALSE
	/// Error text currently displayed to the user. Temporary.
	var/tmp/error
	/// The passcode currently inputed so far and what is displayed on the UI.
	var/tmp/code

/datum/extension/lockable/New(holder, is_digital = FALSE)
	..(holder)
	is_digital_lock = is_digital

/**
 Makes the holder play a sound when a keypad key has been pressed.
 * key: A single key character that was pressed. Any leters between A to Z, any numbers between 0-9, or *, #, ⌗, ⚹.
 * user: The user inputing the key.
 * user_only: If set, the key sound will only be sent to the client using the keypad.
 **/
/datum/extension/lockable/proc/play_key_sound(key, mob/user, user_only = FALSE)
	global.play_dtmf_key_sound(holder, key, user, user_only, SOUND_RANGE_ABS(sound_range))

///Makes the holder play the success sound, when an operation was successful.
/datum/extension/lockable/proc/play_success_sound()
	playsound(holder, 'sound/effects/synth_bell.ogg', 15, FALSE, SOUND_RANGE_ABS(sound_range), 2)

///Makes the holder play the failure sound, when an invalid operation has been done.
/datum/extension/lockable/proc/play_failure_sound()
	playsound(holder, 'sound/machines/synth_no.ogg', 15, FALSE, SOUND_RANGE_ABS(sound_range), 2)

///Makes the holder play the lock's locking sound.
/datum/extension/lockable/proc/play_lock_sound()
	playsound(holder, 'sound/items/containers/briefcase_lock.ogg', 15, FALSE, SOUND_RANGE_ABS(sound_range), 2)

///Makes the holder play the lock's unlock sound.
/datum/extension/lockable/proc/play_unlock_sound()
	playsound(holder, 'sound/machines/mechanical_switch.ogg', 15, FALSE, SOUND_RANGE_ABS(sound_range), 2)

///Makes the holder play the sound after a new keycode has been set.
/datum/extension/lockable/proc/play_code_set_sound()
	set waitfor = FALSE
	//Add a slight delay so it doesn't overlap the key sound.
	sleep(0.3 SECOND)
	playsound(holder, 'sound/effects/fastbeep.ogg', 15, FALSE, SOUND_RANGE_ABS(sound_range), 2)

/datum/extension/lockable/Topic(href, href_list)
	if((. = ..()) || !can_interact(usr)) //Double check if the user can actually send topics to us.
		return
	//Handle a key press
	if(href_list["key"])
		pressed_key(href_list["key"], usr)
		return TOPIC_REFRESH

/**
	Process keypresses coming from the nanoUI.
 */
/datum/extension/lockable/proc/pressed_key(key_char, mob/user)
	if(!user.check_dexterity(DEXTERITY_KEYBOARDS))
		return
	// Always clear error when pressing a button.
	clear_error()

	key_char = uppertext(key_char)
	if(isnum(text2num(key_char)))
		. = enter_number(key_char, user)
	else if(key_char == "E")
		. = confirm_code(user)
	else if(key_char == "C")
		. = clear_button(user)
	else
		CRASH("Unsupported key pressed : '[key_char]'")

	//If the button proc wants us to, we'll play the key sound for the key pressed.
	if(.)
		play_key_sound(key_char, user)

/**
	Called whenever the user input a number key.
	Adds the value of the key to the currently entered keycode.
 */
/datum/extension/lockable/proc/enter_number(num, mob/user, quiet = FALSE)
	//When unlocked we can't enter more numbers, otherwise it gets confusing.
	if(is_locked())
		code += num
		//If we hit the max length after entering the number, just confirm now.
		if(length(code) >= max_code_length)
			return confirm_code(user)
		return TRUE
	if(!quiet)
		play_failure_sound()
	return FALSE //Return false, so calling proc doesn't play a key sound

/**
	Checks the given code for any issues with using it as this lockable's keycode.
	Returns null if there are no problems. Or a text string describing the problem otherwise.
 */
/datum/extension/lockable/proc/keycode_issues_text(code)
	if(length(code) < floor(max_code_length * 0.5) || length(code) > max_code_length)
		return "Keycode must be between [floor(max_code_length * 0.5)] and [max_code_length] numbers long."
	return null //Return null, since we have no issues

/**
	Called when the user press the enter key on the lockable keypad, or when the last key of the code is entered.
	Either sets the keycode for unlocking this lockable, or checks if the current keycode entered is the correct one, and unlocks the lockable.
	Returns TRUE if the code entered was appropriate.
 */
/datum/extension/lockable/proc/confirm_code(mob/user, quiet = FALSE)
	if(l_setshort)
		return FALSE //Shorted lock doesn't do anything

	//Handles setting the lockable's keycode, if not set yet.
	if(is_setting_keycode())
		// We're in lock set mode. So check if the code is valid
		var/keycode_issues = keycode_issues_text(code)
		if(length(keycode_issues))
			//Code is invalid
			clear_current_code()
			set_error_message(keycode_issues)
			if(!quiet)
				play_failure_sound()
			return FALSE
		//Code is valid
		set_keycode(code, quiet)
		return TRUE

	if(emagged)
		clear_current_code()
		set_error_message("Stack Overflow Error 0xDEADBEEF")
		return TRUE

	//If we're already unlocked, do nothing.
	if(!is_locked())
		return FALSE

	//Handles attempts to unlock with a code
	if(!matches_keycode(code))
		//We got a bad keycode.
		clear_current_code()
		set_error_message("Invalid keycode entered.")
		bad_access_attempt(user)
		if(!quiet)
			play_failure_sound()
		return FALSE

	//Handles actually entering the right keycode and unlocking the lockable
	set_locked(FALSE, quiet)
	if(!quiet)
		play_success_sound()
	return TRUE

/**
	Clears the currently entered code and the current error text, and lock the lockable if it's not already.
 */
/datum/extension/lockable/proc/clear_button(mob/user, quiet = FALSE)
	if(!is_locked())
		set_locked(TRUE)
	clear_current_code()
	clear_error()
	return TRUE

/**
	Clear the currently entered code on the ui.
 */
/datum/extension/lockable/proc/clear_current_code()
	//NOTE: Don't trigger a ui update here
	code = null

/**
	Clear the currently displayed error text on the ui.
 */
/datum/extension/lockable/proc/clear_error()
	//NOTE: Don't trigger a ui update here
	error = null

/**
	Sets the error message to be displayed currently.
 */
/datum/extension/lockable/proc/set_error_message(msg)
	//NOTE: Don't trigger a ui update here
	error = msg

/**
	Locks or unlocks the lockable. And play a sound.
 */
/datum/extension/lockable/proc/set_locked(new_state, quiet = FALSE)
	if(locked == new_state)
		return
	locked = new_state
	if(!quiet)
		if(locked)
			play_lock_sound()
		else
			play_unlock_sound()
	clear_current_code()
	RAISE_EVENT(/decl/observ/lock_state_changed, src, !locked, locked)
	//TODO: The code below probably should be handled by the event callback on the atom..
	var/atom/A = holder
	A.update_icon()

/**
	Sets the keycode that unlocks this lockable.
 */
/datum/extension/lockable/proc/set_keycode(new_code, quiet = FALSE)
	l_code  = new_code
	l_set   = length(code) > 0
	set_locked(FALSE)
	if(!quiet)
		play_code_set_sound()

/**
	Whether the incoming keycode matches the keycode we have set to unlock this lockable.
*/
/datum/extension/lockable/proc/matches_keycode(incoming)
	return incoming == l_code

/**
	Whether we're currently awaiting a keycode input to set the keycode to unlock this lockable.
 */
/datum/extension/lockable/proc/is_setting_keycode()
	return !l_set && !l_setshort

/**
	Whether the lockable is currently locked or not.
 */
/datum/extension/lockable/proc/is_locked()
	return locked && !emagged

/**
	Whether the user can actually issue commands to the ui.
 */
/datum/extension/lockable/proc/can_interact(mob/user)
	return holder.CanUseTopic(user) == STATUS_INTERACTIVE

/**
	Opens the "service panel" for nefarious purposes.
 */
/datum/extension/lockable/proc/toggle_panel(mob/user)
	open = !open
	if(user)
		user.visible_message(
			SPAN_NOTICE("\The [user] [open ? "open" : "close"] the service panel of \the [holder]."),
			SPAN_NOTICE("You [open ? "open" : "close"] the service panel of \the [holder]."))
	SSnano.update_uis(src) //The ui is tied to the extension, not the holder
	RAISE_EVENT(/decl/observ/lock_panel_state_changed, src, !open, open)
	//TODO: The code below probably should be handled by the event callback on the atom..
	var/atom/A = holder
	A.update_icon()

/datum/extension/lockable/nano_host()
	return holder.nano_host()

/datum/extension/lockable/ui_data(mob/user, ui_key)
	var/list/data = ..(user, ui_key)
	data["emagged"] = emagged
	data["locked"] = is_locked()
	data["disabled"] = l_setshort || emagged
	if(emagged)
		data["error"] = "LOCKING SYSTEM ERROR - 1701"
	else if(l_setshort)
		data["error"] = "ALERT: MEMORY SYSTEM ERROR - 6040 201"
	else if(error)
		data["error"] = error
	if((src.l_set == 0) && (!src.emagged) && (!src.l_setshort))
		data["status"] = "[max_code_length]-DIGIT PASSCODE NOT SET. ENTER NEW PASSCODE."
	data["input_code"] = (!locked) ? "unlocked" : pad_right(code, max_code_length, "-")
	return data

/datum/extension/lockable/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/data = ui_data(user)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		var/atom/A = holder
		ui = new(user, src, ui_key, "keypad_lock.tmpl", capitalize(A.name), 312, 400)
		ui.set_initial_data(data)
		ui.open()

/**
	Called after the user enters the wrong keycode, or fails a hacking attempt.
 */
/datum/extension/lockable/proc/bad_access_attempt(mob/user)
	return

/**
	Item attack handler for interactions with the host.
 */
/datum/extension/lockable/proc/attackby(obj/item/used_item, mob/user)
	if(!locked)
		return FALSE

	if(!used_item.user_can_wield(user))
		return TRUE

	//TODO: This probably should be handled in a better way.
	if(!is_digital_lock && istype(used_item, /obj/item/energy_blade))
		var/obj/item/energy_blade/blade = used_item
		if(blade.is_special_cutting_tool() && emag_act(INFINITY, user, "You slice through the lock of \the [holder]."))
			var/obj/item/A = holder
			spark_at(A.loc, amount=5)
			playsound(A.loc, 'sound/weapons/blade1.ogg', 50, 1)
			return TRUE

	if(IS_SCREWDRIVER(used_item))
		if(!opening_panel)
			var/obj/item/screwdriver/S = used_item
			opening_panel = TRUE //Make sure we only have one user/attempt to opens the panel at a time.
			if(
				S.do_tool_interaction(
				TOOL_SCREWDRIVER,
				user,
				holder,
				2 SECONDS,
				"[open? "closing" : "opening"] the service panel on",
				null,
				check_skill = SKILL_DEVICES,
				check_skill_threshold = SKILL_NONE)
			)
				opening_panel = FALSE
				toggle_panel(user)
		return TRUE

	if(IS_MULTITOOL(used_item))
		try_hack(used_item, user)
		return TRUE

/**
	Clears the currently set keycode, hacked state, and shorted state.
	Called by the hacking proc via timer after a short delay.
 */
/datum/extension/lockable/proc/reset_memory()
	if(!l_hacking)
		return
	l_hacking = FALSE
	l_setshort = FALSE
	l_code = null
	l_set = FALSE
	//Make sure the thing is locked, since that's the expected initial state, so the user can input a new code.
	if(!locked)
		set_locked(TRUE)
	else
		//If already locked, just update the ui and icon
		SSnano.update_uis(src) //The ui is tied to the extension
		//TODO: This code should probably be run by a callback on the holder
		var/atom/A = holder
		A.update_icon()
	spark_at(get_turf(holder), amount = 2)

/**
	Called when an emag is used on the holder.
 */
/datum/extension/lockable/proc/emag_act(remaining_charges, mob/user, feedback)
	if(emagged)
		return
	emagged = TRUE
	to_chat(user, SPAN_NOTICE(feedback || "You short out the lock of \the [holder]."))
	set_locked(FALSE) //Emagging instantly unlocks the thing.
	return TRUE

/**
	Called when a multitool is used on the holder to hack the device.
 */
/datum/extension/lockable/proc/try_hack(obj/item/multitool/W, mob/user)
	//Don't do anything if the panel isn't opened, or if we're already hacking it.
	if(!open || l_hacking)
		return FALSE

	//Show a message to let the user know how likely this is to even succeed.
	var/fail_chance = hack_fail_chance(W, user)
	var/skill_msg
	if(fail_chance >= 90)
		skill_msg = SPAN_WARNING("But, you struggle to make sense of this thing..")
	else if(fail_chance >= 50)
		skill_msg = SPAN_YELLOW("But, this lock is complicated. You might need several attempts..")
	else if(fail_chance >= 20)
		skill_msg = SPAN_NOTICE("This should only take a few attempts at most.")
	else
		skill_msg = SPAN_BLUE("You're confident it shouldn't take long.")
	to_chat(user, SPAN_NOTICE("You begin trying to force-reset the lock of \the [holder]. ") + skill_msg)

	var/atom/A = holder
	l_hacking = TRUE
	//Display the "hacking" icon. TODO: Maybe a callback on the holder be better?
	A.update_icon()
	if(!user.do_skilled(10 SECONDS, SKILL_ELECTRICAL, holder, 0.8))
		l_hacking = FALSE
	else
		if (!prob(fail_chance))
			l_setshort = FALSE
			to_chat(user, SPAN_NOTICE("You've successfully factory reset the lock! Wait a second for the lock to reinitialize.."))
			//The callback will handle setting 'l_hacking' to false!
			addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/extension/lockable, reset_memory)), 3 SECONDS)
		else
			to_chat(user, SPAN_WARNING("\icon[holder] Unauthorized access detected!"))
			l_hacking = FALSE
			bad_access_attempt(user)
	//Clear the "hacking" icon. TODO: Maybe a callback on the holder be better?
	A.update_icon()
	return TRUE //We handled the interaction even if it didn't work

/**
	Returns a percent chance of the given user failing at hacking this lock.
 */
/datum/extension/lockable/proc/hack_fail_chance(obj/item/multitool/W, mob/user)
	//In order to make the lock actually any use at all, make sure not just anybody with a multitool can open it.
	return user.skill_fail_chance(SKILL_DEVICES, 99, SKILL_MAX, 0.35)

//////////////////////////////////////
// Lockable Storage
//////////////////////////////////////

/datum/extension/lockable/storage
	base_type = /datum/extension/lockable
	expected_type = /obj/item

/datum/extension/lockable/storage/safe
	base_type = /datum/extension/lockable
	expected_type = /obj/item

//////////////////////////////////////
// Lockable Charge Sticks
//////////////////////////////////////

/datum/extension/lockable/charge_stick
	base_type = /datum/extension/lockable
	expected_type = /obj/item/charge_stick
	sound_range = 1
	var/shock_strength = 0
	var/alarm_loudness = 0

/datum/extension/lockable/charge_stick/bad_access_attempt(mob/user)
	if(shock_strength > 0)
		shock(user, 80)
	if(alarm_loudness > 0)
		var/atom/A = holder
		A.audible_message(SPAN_WARNING("\The [holder] shrills in an annoying tone, alerting those nearby of unauthorized tampering."), hearing_distance = alarm_loudness)
		playsound(holder, 'sound/effects/alarm.ogg', 50, TRUE, alarm_loudness)

/datum/extension/lockable/charge_stick/proc/shock(mob/living/user, prb)
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