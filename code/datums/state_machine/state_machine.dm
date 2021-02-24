// This contains the current state of the FSM and should be held by whatever the FSM is controlling.
// Unlike the individual states and their transitions, the state machine objects are not singletons.
/datum/state_machine
	var/decl/state/current_state = null // Acts both as a ref to the current state and holds which state it will default to on init.
	var/datum/holder = null // The object which is using the FSM to help decide what it should do.
	var/expected_holder_type = null

/datum/state_machine/New(datum/new_holder)
	ASSERT(istype(new_holder, expected_holder_type))
	holder = new_holder
	set_state(current_state)

/datum/state_machine/Destroy()
	holder = null
	current_state = null
	return ..()

// Makes the FSM enter a new state, if it can, based on it's current state, that state's transitions, and the holder's status.
// Call it in the holder's `process()`, or whenever you need to.
/datum/state_machine/proc/evaluate()
	var/list/options = current_state.get_open_transitions(holder)
	if(LAZYLEN(options))
		var/decl/state_transition/choice = choose_transition(options)
		current_state.exited_state(holder)
		current_state = choice.target
		current_state.entered_state(holder)

// Decides which transition to walk into, to the next state.
// By default it chooses the first one on the list.
/datum/state_machine/proc/choose_transition(list/valid_transitions)
	return LAZYACCESS(valid_transitions, 1)

// Forces the FSM to switch to a specific state, no matter what.
// It's recommended you avoid externally controlling the FSM with this.
/datum/state_machine/proc/set_state(new_state_type)
	if(istype(current_state))
		current_state.exited_state(holder)
	current_state = GET_DECL(new_state_type)
	current_state.entered_state(holder)
	return current_state
