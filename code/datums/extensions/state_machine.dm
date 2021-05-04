// This contains the current state of the FSM and should be held by whatever the FSM is controlling.
// Unlike the individual states and their transitions, the state machine objects are not singletons, and hence aren't `/decl`s.
/datum/extension/state_machine
	expected_type = /datum
	base_type = /datum/extension/state_machine
	var/decl/state/current_state = null // Acts both as a ref to the current state and holds which state it will default to on init.

/datum/extension/state_machine/New()
	..()
	set_state(current_state)

/datum/extension/state_machine/Destroy()
	current_state = null
	return ..()

// Makes the FSM enter a new state, if it can, based on it's current state, that state's transitions, and the holder's status.
// Call it in the holder's `process()`, or whenever you need to.
/datum/extension/state_machine/proc/evaluate()
	var/list/options = current_state.get_open_transitions(holder)
	if(LAZYLEN(options))
		var/decl/state_transition/choice = choose_transition(options)
		current_state.exited_state(holder)
		current_state = choice.target
		current_state.entered_state(holder)
		return current_state

// Decides which transition to walk into, to the next state.
// By default it chooses the first one on the list.
/datum/extension/state_machine/proc/choose_transition(list/valid_transitions)
	return valid_transitions[1]

// Forces the FSM to switch to a specific state, no matter what.
// Use responsibly.
/datum/extension/state_machine/proc/set_state(new_state_type)
	if(istype(current_state))
		current_state.exited_state(holder)
	current_state = GET_DECL(new_state_type)
	if(istype(current_state))
		current_state.entered_state(holder)
		return current_state
