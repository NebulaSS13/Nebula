/datum/keybinding/living
	category = CATEGORY_LIVING

/datum/keybinding/living/can_use(client/user)
	return isliving(user.mob)

/datum/keybinding/living/rest
	hotkey_keys = list("ShiftB")
	name = "rest"
	full_name = "Rest"
	description = "You lay down/get up"

/datum/keybinding/living/rest/down(client/user)
	var/mob/living/L = user.mob
	L.lay_down()
	return TRUE

/datum/keybinding/living/resist
	hotkey_keys = list("B")
	name = "resist"
	full_name = "Resist"
	description = "Break free of your current state. Handcuffed? On fire? Resist!"

/datum/keybinding/living/resist/down(client/user)
	var/mob/living/L = user.mob
	L.resist()
	return TRUE
