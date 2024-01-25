/datum/keybinding/robot
	category = CATEGORY_ROBOT

/datum/keybinding/robot/can_use(client/user)
	return isrobot(user.mob)

/datum/keybinding/robot/intent_cycle
	hotkey_keys = list("4")
	name = "cycle_intent"
	full_name = "Cycle Intent Left"
	description = "Cycles the intent left"

/datum/keybinding/robot/intent_cycle/down(client/user)
	user.mob.a_intent_change(INTENT_HOTKEY_LEFT)
	return TRUE
