/*
	AI ClickOn()

	Note currently ai restrained() returns 0 in all cases,
	therefore restrained code has been removed

	The AI can double click to move the camera (this was already true but is cleaner),
	or double click a mob to track them.

	Note that AI have no need for the adjacency proc, and so this proc is a lot cleaner.
*/
/mob/living/silicon/ai/DblClickOn(var/atom/A, params)
	if(control_disabled || stat) return

	if(ismob(A))
		ai_actual_track(A)
	else
		A.move_camera_by_click()


/mob/living/silicon/ai/ClickOn(var/atom/A, params)
	if(world.time <= next_click)
		return
	next_click = world.time + 1

	if(incapacitated())
		return

	var/list/modifiers = params2list(params)
	if(modifiers["ctrl"] && modifiers["alt"])
		CtrlAltClickOn(A)
		return
	if(modifiers["shift"] && modifiers["ctrl"])
		CtrlShiftClickOn(A)
		return
	if(modifiers["middle"])
		MiddleClickOn(A)
		return
	if(modifiers["shift"])
		ShiftClickOn(A)
		return
	if(modifiers["alt"]) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return
	if(modifiers["ctrl"])
		CtrlClickOn(A)
		return

	face_atom(A) // change direction to face what you clicked on

	if(control_disabled || !canClick())
		return

	if(multitool_mode && isobj(A))
		var/obj/O = A
		var/datum/extension/interactive/multitool/MT = get_extension(O, /datum/extension/interactive/multitool)
		if(MT)
			MT.interact(aiMulti, src)
			return

	if(silicon_camera.in_camera_mode)
		silicon_camera.camera_mode_off()
		silicon_camera.captureimage(A, src)
		return

	A.add_hiddenprint(src)
	A.attack_ai(src)

/*
	AI has no need for the UnarmedAttack() and RangedAttack() procs,
	because the AI code is not generic;	attack_ai() is used instead.
	The below is only really for safety, or you can alter the way
	it functions and re-insert it above.
*/
/mob/living/silicon/ai/ResolveUnarmedAttack(atom/A)
	return A.attack_ai(src)

/mob/living/silicon/ai/RangedAttack(atom/A, var/params)
	A.attack_ai(src)
	return TRUE

/atom/proc/attack_ai(mob/living/silicon/ai/user)
	return

/*
	Since the AI handles shift, ctrl, and alt-click differently
	than anything else in the game, atoms have separate procs
	for AI shift, ctrl, and alt clicking.
*/

/mob/living/silicon/ai/CtrlAltClickOn(var/atom/A)
	if(!control_disabled && A.AICtrlAltClick(src))
		return
	..()

/mob/living/silicon/ai/ShiftClickOn(var/atom/A)
	if(!control_disabled && A.AIShiftClick(src))
		return
	..()

/mob/living/silicon/ai/CtrlClickOn(var/atom/A)
	if(!control_disabled && A.AICtrlClick(src))
		return TRUE
	. = ..()

/mob/living/silicon/ai/AltClickOn(var/atom/A)
	if(!control_disabled && A.AIAltClick(src))
		return
	..()

/mob/living/silicon/ai/MiddleClickOn(var/atom/A)
	if(!control_disabled && A.AIMiddleClick(src))
		return
	..()

/*
	The following criminally helpful code is just the previous code cleaned up;
	I have no idea why it was in atoms.dm instead of respective files.
*/

/atom/proc/AICtrlAltClick(mob/living/silicon/user)

/obj/machinery/door/airlock/AICtrlAltClick(mob/living/silicon/user) // Electrifies doors.
	if(user.incapacitated())
		return
	if(!electrified_until)
		// permanent shock
		Topic(src, list("command"="electrify_permanently", "activate" = "1"))
	else
		// disable/6 is not in Topic; disable/5 disables both temporary and permanent shock
		Topic(src, list("command"="electrify_permanently", "activate" = "0"))
	return 1

/atom/proc/AICtrlShiftClick(mob/living/silicon/user)
	return

/atom/proc/AIShiftClick(mob/living/silicon/user)
	return

/obj/machinery/door/airlock/AIShiftClick(mob/living/silicon/user)  // Opens and closes doors!
	if(user.incapacitated())
		return
	if(density)
		Topic(src, list("command"="open", "activate" = "1"))
	else
		Topic(src, list("command"="open", "activate" = "0"))
	return 1

/atom/proc/AICtrlClick(mob/living/silicon/user)
	return FALSE

/obj/machinery/door/airlock/AICtrlClick(mob/living/silicon/user) // Bolts doors
	if(user.incapacitated())
		return FALSE
	if(locked)
		Topic(src, list("command"="bolts", "activate" = "0"))
	else
		Topic(src, list("command"="bolts", "activate" = "1"))
	return TRUE

/obj/machinery/apc/AICtrlClick(mob/living/silicon/user) // turns off/on APCs.
	if(user.incapacitated())
		return FALSE
	Topic(src, list("breaker"="1"))
	return TRUE

/obj/machinery/turretid/AICtrlClick(mob/living/silicon/user) //turns off/on Turrets
	if(user.incapacitated())
		return FALSE
	Topic(src, list("command"="enable", "value"="[!enabled]"))
	return TRUE

/atom/proc/AIAltClick(mob/living/silicon/user)
	return AltClick(user)

/obj/machinery/turretid/AIAltClick(mob/living/silicon/user) //toggles lethal on turrets
	if(user.incapacitated())
		return
	Topic(src, list("command"="lethal", "value"="[!lethal]"))
	return 1

/obj/machinery/atmospherics/binary/pump/AIAltClick(mob/living/silicon/user)
	return AltClick(user)

/atom/proc/AIMiddleClick(var/mob/living/silicon/user)
	return 0

/obj/machinery/door/airlock/AIMiddleClick(mob/living/silicon/user) // Toggles door bolt lights.
	if(user.incapacitated())
		return
	if(..())
		return

	if(!src.lights)
		Topic(src, list("command"="lights", "activate" = "1"))
	else
		Topic(src, list("command"="lights", "activate" = "0"))
	return 1

//
// Override AdjacentQuick for AltClicking
//

/mob/living/silicon/ai/TurfAdjacent(var/turf/T)
	return (cameranet && cameranet.is_turf_visible(T))

/mob/living/silicon/ai/face_atom(var/atom/A)
	if(eyeobj)
		eyeobj.face_atom(A)
