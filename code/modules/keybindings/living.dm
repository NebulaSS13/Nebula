/decl/keybinding/living
	name = "Living"
	abstract_type = /decl/keybinding/living

/decl/keybinding/living/can_use(client/user)
	return isliving(user.mob)

/decl/keybinding/living/rest
	hotkey_keys = list("ShiftB")
	uid = "keybind_rest"
	name = "Rest"
	description = "You lay down/get up"

/decl/keybinding/living/rest/down(client/user)
	var/mob/living/L = user.mob
	L.lay_down()
	return TRUE

/decl/keybinding/living/resist
	hotkey_keys = list("B")
	uid = "keybind_resist"
	name = "Resist"
	description = "Break free of your current state. Handcuffed? On fire? Resist!"

/decl/keybinding/living/resist/down(client/user)
	var/mob/living/L = user.mob
	L.resist()
	return TRUE

/decl/keybinding/living/drop_item
	hotkey_keys = list("Q", "Northwest") // HOME
	uid = "keybind_drop_item"
	name = "Drop Item"
	description = ""

/decl/keybinding/living/drop_item/down(client/user)
	var/mob/living/L = user.mob
	L.drop_item()
	return TRUE
