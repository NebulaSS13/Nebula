/datum/keybinding/mob
	abstract_type = /datum/keybinding/mob
	category = CATEGORY_MOB

/datum/keybinding/mob/can_use(client/user)
	return ismob(user.mob)

/datum/keybinding/mob/toggle_throw_mode
	hotkey_keys = list("R", "Southwest")
	classic_keys = list("Southwest")
	name = "toggle_throw_mode"
	full_name = "Toggle Throw mode"
	description = "Toggle throwing the current item or not."

/datum/keybinding/mob/toggle_throw_mode/down(client/user)
	user.toggle_throw_mode_verb()
	return TRUE

/datum/keybinding/mob/hold_throw_mode
	hotkey_keys = list("Space")
	classic_keys = list("Unbound")
	name = "hold_throw_mode"
	full_name = "Hold throw mode"
	description = "Hold this to turn on throw mode, and release it to turn off throw mode"

/datum/keybinding/mob/hold_throw_mode/down(client/user)
	user.mob.toggle_throw_mode(TRUE)
	return TRUE

/datum/keybinding/mob/hold_throw_mode/up(client/user)
	user.mob.toggle_throw_mode(FALSE)
	return TRUE

/datum/keybinding/mob/swap_hands
	hotkey_keys = list("X", "Northeast")
	classic_keys = list("Northeast")
	name = "swap_hands"
	full_name = "Swap Hands"

/datum/keybinding/mob/swap_hands/down(client/user)
	user.mob.swap_hand()
	return TRUE

/datum/keybinding/mob/drop_item
	hotkey_keys = list("Q", "Northwest")
	classic_keys = list("Northwest")
	name = "drop_item"
	full_name = "Drop Item"

/datum/keybinding/mob/drop_item/down(client/user)
	user.mob.drop_item()
	return TRUE

/datum/keybinding/mob/select_help_intent
	hotkey_keys = list("1")
	classic_keys = list("Unbound")
	name = "select_help_intent"
	full_name = "Select Help Intent"

/datum/keybinding/mob/select_help_intent/down(client/user)
	user.mob.set_intent(I_FLAG_HELP)
	return TRUE

/datum/keybinding/mob/select_disarm_intent
	hotkey_keys = list("2")
	classic_keys = list("Unbound")
	name = "select_disarm_intent"
	full_name = "Select Disarm Intent"

/datum/keybinding/mob/select_disarm_intent/down(client/user)
	user.mob.set_intent(I_FLAG_DISARM)
	return TRUE

/datum/keybinding/mob/select_grab_intent
	hotkey_keys = list("3")
	classic_keys = list("Unbound")
	name = "select_grab_intent"
	full_name = "Select Grab Intent"

/datum/keybinding/mob/select_grab_intent/down(client/user)
	user.mob.set_intent(I_FLAG_GRAB)
	return TRUE

/datum/keybinding/mob/select_harm_intent
	hotkey_keys = list("4")
	classic_keys = list("Unbound")
	name = "select_harm_intent"
	full_name = "Select Harm Intent"

/datum/keybinding/mob/select_harm_intent/down(client/user)
	user.mob.set_intent(I_FLAG_HARM)
	return TRUE

/datum/keybinding/mob/cycle_intent_right
	hotkey_keys = list("G", "Insert")
	classic_keys = list("Insert")
	name = "cycle_intent_right"
	full_name = "Сycle Intent: Right"

/datum/keybinding/mob/cycle_intent_right/down(client/user)
	user.mob.cycle_intent(INTENT_HOTKEY_RIGHT)
	return TRUE

/datum/keybinding/mob/cycle_intent_left
	hotkey_keys = list("F")
	classic_keys = list("Unbound")
	name = "cycle_intent_left"
	full_name = "Сycle Intent: Left"

/datum/keybinding/mob/cycle_intent_left/down(client/user)
	user.mob.cycle_intent(INTENT_HOTKEY_LEFT)
	return TRUE

/datum/keybinding/mob/activate_inhand
	hotkey_keys = list("Z", "Y","Southeast") // Southeast = PAGEDOWN
	classic_keys = list("Southeast")
	name = "activate_inhand"
	full_name = "Activate In-Hand"
	description = "Uses whatever item you have inhand"

/datum/keybinding/mob/activate_inhand/down(client/user)
	user.mob.mode()
	return TRUE

/datum/keybinding/mob/target_head_cycle
	hotkey_keys = list("Numpad8")
	name = "target_head_cycle"
	full_name = "Target: Cycle Head"

/datum/keybinding/mob/target_head_cycle/down(client/user)
	user.body_toggle_head()
	return TRUE

/datum/keybinding/mob/target_r_arm
	hotkey_keys = list("Numpad4")
	name = "target_r_arm"
	full_name = "Target: Right Arm"

/datum/keybinding/mob/target_r_arm/down(client/user)
	user.body_r_arm()
	return TRUE

/datum/keybinding/mob/target_body_chest
	hotkey_keys = list("Numpad5")
	name = "target_body_chest"
	full_name = "Target: Body"

/datum/keybinding/mob/target_body_chest/down(client/user)
	user.body_chest()
	return TRUE

/datum/keybinding/mob/target_left_arm
	hotkey_keys = list("Numpad6")
	name = "target_left_arm"
	full_name = "Target: Left Arm"

/datum/keybinding/mob/target_left_arm/down(client/user)
	user.body_l_arm()
	return TRUE

/datum/keybinding/mob/target_right_leg
	hotkey_keys = list("Numpad1")
	name = "target_right_leg"
	full_name = "Target: Right leg"

/datum/keybinding/mob/target_right_leg/down(client/user)
	user.body_r_leg()
	return TRUE

/datum/keybinding/mob/target_body_groin
	hotkey_keys = list("Numpad2")
	name = "target_body_groin"
	full_name = "Target: Groin"

/datum/keybinding/mob/target_body_groin/down(client/user)
	user.body_groin()
	return TRUE

/datum/keybinding/mob/target_left_leg
	hotkey_keys = list("Numpad3")
	name = "target_left_leg"
	full_name = "Target: Left Leg"

/datum/keybinding/mob/target_left_leg/down(client/user)
	user.body_l_leg()
	return TRUE

/datum/keybinding/mob/minimal_hud
	hotkey_keys = list("F12")
	name = "minimal_hud"
	full_name = "Minimal HUD"
	description = "Hide most HUD features"

/datum/keybinding/mob/minimal_hud/down(client/user)
	user.mob.minimize_hud()
	return TRUE

/datum/keybinding/mob/interact
	hotkey_keys = list("Return")
	name = "interact"
	full_name = "Interact"
	description = "Interact with the turf directly in front of you."

/datum/keybinding/mob/interact/down(client/user)
	user.mob.interact_with_facing()
	return TRUE

/mob/proc/interact_with_facing()

	var/turf/facing = get_step(get_turf(src), dir)
	if(!istype(facing) || !facing.simulated)
		return

	var/list/atoms = facing.get_contained_external_atoms()
	// Move non-prioritised atoms to the end of the list (to avoid burning our hands on lights when trying to open a closet)
	if(length(atoms) > 1)
		atoms = sortTim(atoms, /proc/cmp_planelayer_interact_priority)
	LAZYDISTINCTADD(atoms, facing) // Turf is always at the end of the list.

	// Try to click something.
	for(var/atom/clickable as anything in atoms)
		if(clickable.invisibility <= see_invisible)
			return clickable.Click()
