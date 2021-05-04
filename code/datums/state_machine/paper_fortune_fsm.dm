/decl/state/paper_fortune

/decl/state/paper_fortune/entered_state(obj/item/paper_fortune_teller/P)
	P.update_icon()

// The starting point.
/decl/state/paper_fortune/closed
	transitions = list(/decl/state_transition/paper_fortune/closed_to_open_vertical)

// Alternates between this and the below state.
/decl/state/paper_fortune/open_vertical
	transitions = list(/decl/state_transition/paper_fortune/vertical_to_horizontal)

/decl/state/paper_fortune/open_horizontal
	transitions = list(/decl/state_transition/paper_fortune/horizontal_to_vertical)


/decl/state_transition/paper_fortune/closed_to_open_vertical/is_open(datum/holder)
	return TRUE

/decl/state_transition/paper_fortune/vertical_to_horizontal/is_open(datum/holder)
	return TRUE

/decl/state_transition/paper_fortune/horizontal_to_vertical/is_open(datum/holder)
	return TRUE

/datum/extension/state_machine/paper_fortune
	current_state = /decl/state/paper_fortune/closed

/*
closed > open state one > one set of fortunes   \
           ^        v                            closed
         open state two > other set of fortunes /


/mob/some_mob/Initialize()
    . = ..()
    set_extension(src, /datum/extension/state_machine/some_subtype)

/mob/some_mob/handle_ai()
    var/datum/extension/state_machine/fsm = get_extension(src, /datum/extension/state_machine)
    fsm.do_the_thing()
*/
