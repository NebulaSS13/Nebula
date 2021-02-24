// An individual state, defined as a `/decl` to save memory.
// On a directed graph, these would be the nodes themselves, connected to each other by unidirectional arrows.
/decl/state
	// Transition decl types, which get turned into refs to those types.
	// Note that the order DOES matter, as decls earlier in the list have higher priority
	// if more than one becomes 'open'.
	var/list/transitions = null

// Called by `SSstate_machines` to have the state decls build the directed graph themselves.
/decl/state/proc/set_up()
	if(!LAZYLEN(transitions))
		return
	for(var/i in 1 to transitions.len)
		var/decl/state_transition/T = GET_DECL(transitions[i])
		if(!istype(T))
			CRASH("[type] expected a state transition object but was not given one.")
		T.set_up(src)
		transitions[i] = T // Replace the path with a ref to the instance.

// Returns a list of transitions that a FSM could switch to.
// Note that `holder` is NOT the FSM, but instead the thing the FSM is attached to.
/decl/state/proc/get_open_transitions(datum/holder)
	. = list()
	for(var/thing in transitions)
		var/decl/state_transition/T = thing
		if(T.is_open(holder))
			. += T

// Stub for child states to modify the holder when switched to.
// Again, `holder` is not the FSM.
/decl/state/proc/entered_state(datum/holder)
	return

// Another stub for when leaving a state.
/decl/state/proc/exited_state(datum/holder)
	return