/decl/keybinding/robot
	name = "Robot"

/decl/keybinding/robot/can_use(client/user)
	return isrobot(user.mob)

/decl/keybinding/robot/moduleone
	hotkey_keys = list("1")
	uid = "keybind_module_one"
	name = "Toggle Module 1"
	description = "Equips or unequips the first module"

/decl/keybinding/robot/moduleone/down(client/user)
	var/mob/living/silicon/robot/R = user.mob
	R.toggle_module(1)
	return TRUE

/decl/keybinding/robot/moduletwo
	hotkey_keys = list("2")
	uid = "keybind_module_two"
	name = "Toggle Module 2"
	description = "Equips or unequips the second module"

/decl/keybinding/robot/moduletwo/down(client/user)
	var/mob/living/silicon/robot/R = user.mob
	R.toggle_module(2)
	return TRUE

/decl/keybinding/robot/modulethree
	hotkey_keys = list("3")
	uid = "keybind_module_three"
	name = "Toggle Module 3"
	description = "Equips or unequips the third module"

/decl/keybinding/robot/modulethree/down(client/user)
	var/mob/living/silicon/robot/R = user.mob
	R.toggle_module(3)
	return TRUE

/decl/keybinding/robot/intent_cycle
	hotkey_keys = list("4")
	uid = "keybind_cycle_intent"
	name = "Cycle Intent Left"
	description = "Cycles the intent left"

/decl/keybinding/robot/intent_cycle/down(client/user)
	var/mob/living/silicon/robot/R = user.mob
	R.a_intent_change(INTENT_HOTKEY_LEFT)
	return TRUE

/decl/keybinding/robot/module_cycle
	hotkey_keys = list("X")
	uid = "keybind_cycle_modules"
	name = "Cycle Modules"
	description = "Cycles your modules"

/decl/keybinding/robot/module_cycle/down(client/user)
	var/mob/living/silicon/robot/R = user.mob
	R.cycle_modules()
	return TRUE

/decl/keybinding/robot/unequip_module
	hotkey_keys = list("Q")
	uid = "keybind_unequip_module"
	name = "Unequip Module"
	description = "Unequips the active module"

/decl/keybinding/robot/unequip_module/down(client/user)
	var/mob/living/silicon/robot/R = user.mob
	if(R.module)
		R.uneq_active()
	return TRUE
