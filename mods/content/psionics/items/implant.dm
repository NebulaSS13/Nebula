/obj/item/implant/psi_control
	name = "psi dampener implant"
	desc = "A safety implant for registered psi-operants."
	known = TRUE

	var/overload = 0
	var/max_overload = 100
	var/psi_mode = PSI_IMPLANT_AUTOMATIC

/obj/item/implant/psi_control/islegal()
	return TRUE

/obj/item/implant/psi_control/Initialize()
	. = ..()
	SSpsi.psi_dampeners += src

/obj/item/implant/psi_control/Destroy()
	SSpsi.psi_dampeners -= src
	. = ..()

/obj/item/implant/psi_control/emp_act()
	. = ..()
	update_functionality()

/obj/item/implant/psi_control/meltdown()
	. = ..()
	update_functionality()

/obj/item/implant/psi_control/disrupts_psionics()
	var/use_psi_mode = get_psi_mode()
	return (!malfunction && (use_psi_mode == PSI_IMPLANT_SHOCK || use_psi_mode == PSI_IMPLANT_WARN)) ? src : FALSE

/obj/item/implant/psi_control/removed()
	var/mob/living/M = imp_in
	if(disrupts_psionics() && istype(M) && M.get_ability_handler(/datum/ability_handler/psionics))
		to_chat(M, SPAN_NOTICE("You feel the chilly shackles around your psionic faculties fade away."))
	. = ..()

/obj/item/implant/psi_control/proc/update_functionality(var/silent)
	var/mob/living/M = imp_in
	if(get_psi_mode() == PSI_IMPLANT_DISABLED || malfunction)
		if(implanted && !silent && istype(M) && M.get_ability_handler(/datum/ability_handler/psionics))
			to_chat(M, SPAN_NOTICE("You feel the chilly shackles around your psionic faculties fade away."))
	else
		if(implanted && !silent && istype(M) && M.get_ability_handler(/datum/ability_handler/psionics))
			to_chat(M, SPAN_NOTICE("Bands of hollow ice close themselves around your psionic faculties."))

/obj/item/implant/psi_control/meltdown()
	if(!malfunction)
		overload = max_overload
		if(imp_in)
			for(var/thing in SSpsi.psi_monitors)
				var/obj/machinery/psi_monitor/monitor = thing
				monitor.report_failure(src)
	. = ..()

/obj/item/implant/psi_control/proc/get_psi_mode()
	if(psi_mode == PSI_IMPLANT_AUTOMATIC)
		var/decl/security_state/security_state = GET_DECL(global.using_map.security_state)
		return security_state.current_security_level.psionic_control_level
	return psi_mode

/obj/item/implant/psi_control/withstand_psi_stress(var/stress, var/atom/source)

	var/use_psi_mode = get_psi_mode()

	if(malfunction || use_psi_mode == PSI_IMPLANT_DISABLED)
		return stress

	. = 0

	if(stress > 0)

		// If we're disrupting psionic attempts at the moment, we might overload.
		if(disrupts_psionics())
			var/overload_amount = floor(stress/10)
			if(overload_amount > 0)
				overload += overload_amount
				if(overload >= max_overload)
					if(imp_in)
						to_chat(imp_in, SPAN_DANGER("Your psi dampener overloads violently!"))
					meltdown()
					update_functionality()
					return
				if(imp_in)
					switch(overload / max_overload)
						if(0.25 to 0.5)
							to_chat(imp_in, SPAN_WARNING("You feel your psi dampener heating up..."))
						if(0.5 to 0.75)
							to_chat(imp_in, SPAN_WARNING("Your psi dampener is uncomfortably hot..."))
						if(0.75 to 1)
							to_chat(imp_in, SPAN_DANGER("Your psi dampener is searing hot!"))

		// If all we're doing is logging the incident then just pass back stress without changing it.
		if(source && source == imp_in && implanted)
			for(var/thing in SSpsi.psi_monitors)
				var/obj/machinery/psi_monitor/monitor = thing
				monitor.report_violation(src, stress)
			if(use_psi_mode == PSI_IMPLANT_LOG)
				return stress
			else if(use_psi_mode == PSI_IMPLANT_SHOCK)
				to_chat(imp_in, SPAN_DANGER("Your psi dampener punishes you with a violent neural shock!"))
				imp_in.flash_eyes()
				SET_STATUS_MAX(imp_in, STAT_WEAK, 5)
				if(isliving(imp_in))
					var/mob/living/M = imp_in
					var/datum/ability_handler/psionics/psi = M.get_ability_handler(/datum/ability_handler/psionics)
					psi?.stunned(5)
			else if(use_psi_mode == PSI_IMPLANT_WARN)
				to_chat(imp_in, SPAN_WARNING("Your psi dampener primly informs you it has reported this violation."))
