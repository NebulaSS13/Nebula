/decl/keybinding/movement
	name = "Movement"

/decl/keybinding/movement/north
	hotkey_keys = list("W", "North")
	name = "North"
	name = "Move North"
	description = "Moves your character north"

/decl/keybinding/movement/south
	hotkey_keys = list("S", "South")
	name = "South"
	name = "Move South"
	description = "Moves your character south"

/decl/keybinding/movement/west
	hotkey_keys = list("A", "West")
	name = "West"
	name = "Move West"
	description = "Moves your character left"

/decl/keybinding/movement/east
	hotkey_keys = list("D", "East")
	name = "East"
	name = "Move East"
	description = "Moves your character east"

/decl/keybinding/movement/move_quickly
	hotkey_keys = list("Shift")
	name = "moving_quickly"
	name = "Move Quickly"
	description = "Makes you move quickly"

/decl/keybinding/movement/move_quickly/down(client/user)
	user.setmovingquickly()
	return TRUE

/decl/keybinding/movement/move_quickly/up(client/user)
	user.setmovingslowly()
	return TRUE
