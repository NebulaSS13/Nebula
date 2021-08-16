/decl/keybinding/mob
	name = "Mob"
	abstract_type = /decl/keybinding/mob

/decl/keybinding/mob/can_use(client/user)
	return ismob(user.mob) ? TRUE : FALSE

/decl/keybinding/mob/cycle_intent_right
	hotkey_keys = list("G", "Insert")
	uid = "keybind_cycle_intent_right"
	name = "Сycle Intent: Right"
	description = ""

/decl/keybinding/mob/cycle_intent_right/down(client/user)
	var/mob/M = user.mob
	M.a_intent_change(INTENT_HOTKEY_RIGHT)
	return TRUE

/decl/keybinding/mob/cycle_intent_left
	hotkey_keys = list("F")
	uid = "keybind_cycle_intent_left"
	name = "Сycle Intent: Left"
	description = ""

/decl/keybinding/mob/cycle_intent_left/down(client/user)
	var/mob/M = user.mob
	M.a_intent_change(INTENT_HOTKEY_LEFT)
	return TRUE

/decl/keybinding/mob/activate_inhand
	hotkey_keys = list("Z", "Y","Southeast") // Southeast = PAGEDOWN
	uid = "keybind_activate_inhand"
	name = "Activate In-Hand"
	description = "Uses whatever item you have inhand"

/decl/keybinding/mob/activate_inhand/down(client/user)
	var/mob/M = user.mob
	M.mode()
	return TRUE

/decl/keybinding/mob/target_head_cycle
	hotkey_keys = list("Numpad8")
	uid = "keybind_target_head_cycle"
	name = "Target: Cycle Head"
	description = ""

/decl/keybinding/mob/target_head_cycle/down(client/user)
	user.body_toggle_head()
	return TRUE

/decl/keybinding/mob/target_r_arm
	hotkey_keys = list("Numpad4")
	uid = "keybind_target_r_arm"
	name = "Target: Right Arm"
	description = ""

/decl/keybinding/mob/target_r_arm/down(client/user)
	user.body_r_arm()
	return TRUE

/decl/keybinding/mob/target_body_chest
	hotkey_keys = list("Numpad5")
	uid = "keybind_target_body_chest"
	name = "Target: Body"
	description = ""

/decl/keybinding/mob/target_body_chest/down(client/user)
	user.body_chest()
	return TRUE

/decl/keybinding/mob/target_left_arm
	hotkey_keys = list("Numpad6")
	uid = "keybind_target_left_arm"
	name = "Target: Left Arm"
	description = ""

/decl/keybinding/mob/target_left_arm/down(client/user)
	user.body_l_arm()
	return TRUE

/decl/keybinding/mob/target_right_leg
	hotkey_keys = list("Numpad1")
	uid = "keybind_target_right_leg"
	name = "Target: Right leg"
	description = ""

/decl/keybinding/mob/target_right_leg/down(client/user)
	user.body_r_leg()
	return TRUE

/decl/keybinding/mob/target_body_groin
	hotkey_keys = list("Numpad2")
	uid = "keybind_target_body_groin"
	name = "Target: Groin"
	description = ""

/decl/keybinding/mob/target_body_groin/down(client/user)
	user.body_groin()
	return TRUE

/decl/keybinding/mob/target_left_leg
	hotkey_keys = list("Numpad3")
	uid = "keybind_target_left_leg"
	name = "Target: Left Leg"
	description = ""

/decl/keybinding/mob/target_left_leg/down(client/user)
	user.body_l_leg()
	return TRUE

/decl/keybinding/mob/prevent_movement
	hotkey_keys = list("Ctrl")
	uid = "keybind_block_movement"
	name = "Block movement"
	description = "Prevents you from moving"

/decl/keybinding/mob/prevent_movement/down(client/user)
	user.movement_locked = TRUE
	return TRUE

/decl/keybinding/mob/prevent_movement/up(client/user)
	user.movement_locked = FALSE
	return TRUE

/decl/keybinding/mob/move_up
	hotkey_keys = list(",")
	uid = "keybind_move_up"
	name = "Move Up"
	description = "Makes you go up"

/decl/keybinding/mob/move_up/down(client/user)
	var/mob/M = user.mob
	M.move_up()

/decl/keybinding/mob/move_down
	hotkey_keys = list(".")
	uid = "keybind_move_down"
	name = "Move Down"
	description = "Makes you go down"

/decl/keybinding/mob/move_up/down(client/user)
	var/mob/M = user.mob
	M.SelfMove(DOWN)
