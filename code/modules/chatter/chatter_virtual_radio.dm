/obj/item/radio/virtual
	intercom =     TRUE
	virtual =      TRUE
	simulated =    FALSE
	anchored =     TRUE
	opacity =      FALSE
	density =      FALSE
	invisibility = INVISIBILITY_MAXIMUM
	is_spawnable_type = FALSE
	var/decl/radio_chatter/owner

/obj/item/radio/virtual/Initialize(var/ml, var/decl/radio_chatter/_owner)
	. = ..()
	owner = _owner
	name = null
	verbs.Cut()
	if(!istype(owner))
		return INITIALIZE_HINT_QDEL

/obj/item/radio/virtual/received_chatter(display_freq, level)
	owner?.hear_chat()

/obj/item/radio/virtual/Destroy(var/force)
	return !force ? QDEL_HINT_LETMELIVE : ..()

/obj/item/radio/virtual/emp_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	return

/obj/item/radio/virtual/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	return
