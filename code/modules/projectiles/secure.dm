/obj/item/gun/proc/free_fire()
	var/decl/security_state/security_state = GET_DECL(global.using_map.security_state)
	return security_state.current_security_level_is_same_or_higher_than(security_state.high_security_level)

/obj/item/gun/special_check()
	if(is_secure_gun() && !free_fire() && (!authorized_modes[sel_mode] || !registered_owner))
		audible_message(SPAN_WARNING("\The [src] buzzes, refusing to fire."), hearing_distance = 3)
		playsound(loc, 'sound/machines/buzz-sigh.ogg', 10, 0)
		return 0

	. = ..()

/obj/item/gun/get_next_firemode()
	if(!is_secure_gun())
		return ..()
	. = sel_mode
	do
		.++
		if(. > authorized_modes.len)
			. = 1
		if(. == sel_mode) // just in case all modes are unauthorized
			return null
	while (!authorized_modes[.] && !free_fire())
