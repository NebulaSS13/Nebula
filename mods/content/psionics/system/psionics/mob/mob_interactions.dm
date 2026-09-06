#define INVOKE_PSI_POWERS(holder, powers, target)                               \
	if(can_use()) {                                                             \
		for(var/decl/psionic_power/power as anything in powers) {               \
			var/obj/item/result = power.invoke(user, target);                   \
			if(result) {                                                        \
				power.handle_post_power(user, target);                          \
				if(istype(result)) {                                            \
					sound_to(user, sound('sound/effects/psi/power_evoke.ogg')); \
				}                                                               \
				return TRUE;                                                    \
			}                                                                   \
		}                                                                       \
	}                                                                           \
	return FALSE;

/datum/ability_handler/psionics/can_do_self_invocation(mob/user)
	return TRUE

/datum/ability_handler/psionics/do_self_invocation(mob/user)
	INVOKE_PSI_POWERS(user, get_manifestations(), user)

/datum/ability_handler/psionics/can_do_grabbed_invocation(mob/user, atom/target)
	return TRUE

/datum/ability_handler/psionics/do_grabbed_invocation(mob/user, atom/target)
	INVOKE_PSI_POWERS(user, get_grab_powers(SSpsi.get_faculty_by_intent(user.get_intent())), target)

/datum/ability_handler/psionics/can_do_melee_invocation(mob/user, atom/target)
	SHOULD_CALL_PARENT(FALSE)
	return TRUE

/datum/ability_handler/psionics/do_melee_invocation(mob/user, atom/target)
	SHOULD_CALL_PARENT(FALSE)
	INVOKE_PSI_POWERS(user, get_melee_powers(SSpsi.get_faculty_by_intent(user.get_intent())), target)

/datum/ability_handler/psionics/can_do_ranged_invocation(mob/user, atom/target)
	SHOULD_CALL_PARENT(FALSE)
	return TRUE

/datum/ability_handler/psionics/do_ranged_invocation(mob/user, atom/target)
	SHOULD_CALL_PARENT(FALSE)
	INVOKE_PSI_POWERS(user, get_ranged_powers(SSpsi.get_faculty_by_intent(user.get_intent())), target)

#undef INVOKE_PSI_POWERS
