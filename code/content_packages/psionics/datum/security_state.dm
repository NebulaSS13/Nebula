/decl/security_state/set_security_level(var/decl/security_level/new_security_level, var/force_change = FALSE)
	. = ..()
	if(.)
		for(var/thing in SSpsi.psi_dampeners)
			var/obj/item/implant/psi_control/implant = thing
			implant.update_functionality()

/decl/security_level
	var/psionic_control_level = PSI_IMPLANT_WARN

/decl/security_level/default/code_blue
	psionic_control_level = PSI_IMPLANT_LOG

/decl/security_level/default/code_red
	psionic_control_level = PSI_IMPLANT_DISABLED

/decl/security_level/default/code_delta
	psionic_control_level = PSI_IMPLANT_DISABLED