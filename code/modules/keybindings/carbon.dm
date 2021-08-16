/decl/keybinding/carbon
	name = "Carbon"
	abstract_type = /decl/keybinding/carbon

/decl/keybinding/carbon/can_use(client/user)
	return iscarbon(user.mob)

/decl/keybinding/carbon/toggle_throw_mode
	hotkey_keys = list("R", "Southwest") // PAGEDOWN
	uid = "keybind_toggle_throw_mode"
	name = "Toggle Throw Mode"
	description = "Toggle throwing the current item or not"

/decl/keybinding/carbon/toggle_throw_mode/down(client/user)
	var/mob/living/carbon/C = user.mob
	C.toggle_throw_mode()
	return TRUE

/decl/keybinding/carbon/select_help_intent
	hotkey_keys = list("1")
	uid = "keybind_select_help_intent"
	name = "Select Help Intent"
	description = ""

/decl/keybinding/carbon/select_help_intent/down(client/user)
	user.mob?.a_intent_change(I_HELP)
	return TRUE

/decl/keybinding/carbon/select_disarm_intent
	hotkey_keys = list("2")
	uid = "keybind_select_disarm_intent"
	name = "Select Disarm Intent"
	description = ""

/decl/keybinding/carbon/select_disarm_intent/down(client/user)
	user.mob?.a_intent_change(I_DISARM)
	return TRUE

/decl/keybinding/carbon/select_grab_intent
	hotkey_keys = list("3")
	uid = "keybind_select_grab_intent"
	name = "Select Grab Intent"
	description = ""

/decl/keybinding/carbon/select_grab_intent/down(client/user)
	user.mob?.a_intent_change(I_GRAB)
	return TRUE

/decl/keybinding/carbon/select_harm_intent
	hotkey_keys = list("4")
	uid = "keybind_select_harm_intent"
	name = "Select Harm Intent"
	description = ""

/decl/keybinding/carbon/select_harm_intent/down(client/user)
	user.mob?.a_intent_change(I_HURT)
	return TRUE

/decl/keybinding/carbon/swap_hands
	hotkey_keys = list("X", "Northeast") // PAGEUP
	uid = "keybind_swap_hands"
	name = "Swap Hands"
	description = ""

/decl/keybinding/carbon/swap_hands/down(client/user)
	var/mob/living/carbon/C = user.mob
	C.swap_hand()
	return TRUE
