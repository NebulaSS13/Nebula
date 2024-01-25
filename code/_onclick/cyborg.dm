/mob/living/silicon/robot/check_additional_click_requirements(var/atom/A, var/params)
	if(silicon_camera?.in_camera_mode)
		silicon_camera.camera_mode_off()
		if(is_component_functioning("camera"))
			silicon_camera.captureimage(A, usr)
		else
			to_chat(src, SPAN_WARNING("Your camera isn't functional."))
		return TRUE
	return ..()

/mob/living/silicon/robot/handle_unarmed_click_intercept(var/atom/A, var/params)
	A.add_hiddenprint(src)
	A.attack_robot(src)
	return TRUE

//Give cyborgs hotkey clicks without breaking existing uses of hotkey clicks
// for non-doors/apcs
/mob/living/silicon/robot/CtrlShiftClickOn(var/atom/A)
	return A.BorgCtrlShiftClick(src)

/mob/living/silicon/robot/ShiftClickOn(var/atom/A)
	return A.BorgShiftClick(src)

/mob/living/silicon/robot/CtrlClickOn(var/atom/A)
	return A.BorgCtrlClick(src)

/mob/living/silicon/robot/AltClickOn(var/atom/A)
	return A.BorgAltClick(src)

/mob/living/silicon/robot/CtrlAltClickOn(atom/A)
	return A.BorgCtrlAltClick(src)

/atom/proc/BorgCtrlShiftClick(var/mob/living/silicon/robot/user) //forward to human click if not overriden
	return CtrlShiftClick(user)

/obj/machinery/door/airlock/BorgCtrlShiftClick()
	return AICtrlShiftClick()

/atom/proc/BorgShiftClick(var/mob/living/silicon/robot/user) //forward to human click if not overriden
	return ShiftClick(user)

/obj/machinery/door/airlock/BorgShiftClick()  // Opens and closes doors! Forwards to AI code.
	return AIShiftClick()

/atom/proc/BorgCtrlClick(var/mob/living/silicon/robot/user) //forward to human click if not overriden
	return CtrlClick(user)

/obj/machinery/door/airlock/BorgCtrlClick() // Bolts doors. Forwards to AI code.
	return AICtrlClick()

/obj/machinery/power/apc/BorgCtrlClick() // turns off/on APCs. Forwards to AI code.
	return AICtrlClick()

/obj/machinery/turretid/BorgCtrlClick() //turret control on/off. Forwards to AI code.
	return AICtrlClick()

/atom/proc/BorgAltClick(var/mob/living/silicon/robot/user)
	return AltClick(user)

/obj/machinery/door/airlock/BorgAltClick() // Eletrifies doors. Forwards to AI code.
	if (usr.a_intent != I_HELP)
		return AICtrlAltClick()
	return ..()

/obj/machinery/turretid/BorgAltClick() //turret lethal on/off. Forwards to AI code.
	return AIAltClick()

/obj/machinery/atmospherics/binary/pump/BorgAltClick()
	return AltClick()

/atom/proc/BorgCtrlAltClick(var/mob/living/silicon/robot/user)
	return CtrlAltClick(user)

/*
	As with AI, these are not used in click code,
	because the code for robots is specific, not generic.

	If you would like to add advanced features to robot
	clicks, you can do so here, but you will have to
	change attack_robot() above to the proper function
*/
/mob/living/silicon/robot/UnarmedAttack(atom/A)
	return A.attack_robot(src)

/mob/living/silicon/robot/RangedAttack(atom/A, var/params)
	return A.attack_robot(src)

/atom/proc/attack_robot(mob/user)
	return attack_ai(user)
