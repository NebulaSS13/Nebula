/decl/interaction_handler/forensics_remove_sample
	name = "Remove Sample"
	expected_target_type = /obj/machinery/forensic

/decl/interaction_handler/forensics_remove_sample/invoked(var/atom/target, var/mob/user)
	var/obj/machinery/forensic/F = target
	F.remove_sample(usr)

/decl/interaction_handler/hydroponics_close_lid
	name = "Open/Close Lid"
	expected_target_type = /obj/machinery/portable_atmospherics/hydroponics

/decl/interaction_handler/hydroponics_close_lid/is_possible(var/atom/target, var/mob/user)
	. = ..()
	if(.)
		var/obj/machinery/portable_atmospherics/hydroponics/T = target
		return T.mechanical

/decl/interaction_handler/hydroponics_close_lid/invoked(var/atom/target, var/mob/user)
	var/obj/machinery/portable_atmospherics/hydroponics/T = target
	T.close_lid(user)

/decl/interaction_handler/binary_pump_toggle
	name = "Switch On/Off"
	expected_target_type = /obj/machinery/atmospherics/binary/pump

/decl/interaction_handler/binary_pump_toggle/invoked(atom/target, mob/user)
	var/obj/machinery/atmospherics/binary/pump/P = target
	P.Topic(P, list("power" = "1"))
