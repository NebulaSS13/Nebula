/*
	Cyborg ClickOn()

	Cyborgs have no range restriction on attack_robot(), because it is basically an AI click.
	However, they do have a range restriction on item use, so they cannot do without the
	adjacency code.
*/

/mob/living/silicon/robot/ClickOn(var/atom/A, var/params)
	if(world.time <= next_click)
		return
	next_click = world.time + 1

	var/list/modifiers = params2list(params)
	if (modifiers["ctrl"] && modifiers["alt"])
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

	if(incapacitated())
		return

	if(!canClick())
		return

	face_atom(A) // change direction to face what you clicked on

	if(silicon_camera.in_camera_mode)
		silicon_camera.camera_mode_off()
		if(is_component_functioning("camera"))
			silicon_camera.captureimage(A, src)
		else
			to_chat(src, SPAN_DANGER("Your camera isn't functional."))
		return

	var/obj/item/holding = get_active_held_item()

	// Cyborgs have no range-checking unless there is item use
	if(!holding)
		A.add_hiddenprint(src)
		A.attack_robot(src)
		return

	// buckled cannot prevent machine interlinking but stops arm movement
	if( buckled )
		return

	if(holding == A)

		holding.attack_self(src)
		return

	if(A == loc || (A in loc) || (A in contents))
		// No adjacency checks
		var/resolved = holding.resolve_attackby(A, src, params)
		if(!resolved && A && holding)
			holding.afterattack(A, src, 1, params) // 1 indicates adjacency
		setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		return

	if(!isturf(loc))
		return

	var/sdepth = A.storage_depth_turf()
	if(isturf(A) || isturf(A.loc) || (sdepth != -1 && sdepth <= 1))
		if(A.Adjacent(src)) // see adjacent.dm
			var/resolved = holding.resolve_attackby(A, src, params)
			if(!resolved && A && holding)
				holding.afterattack(A, src, 1, params) // 1 indicates adjacency
			setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		else
			holding.afterattack(A, src, 0, params)
		return

//Give cyborgs hotkey clicks without breaking existing uses of hotkey clicks
// for non-doors/apcs
/mob/living/silicon/robot/CtrlShiftClickOn(var/atom/A)
	A.BorgCtrlShiftClick(src)

/mob/living/silicon/robot/ShiftClickOn(var/atom/A)
	A.BorgShiftClick(src)

/mob/living/silicon/robot/CtrlClickOn(var/atom/A)
	return A.BorgCtrlClick(src)

/mob/living/silicon/robot/AltClickOn(var/atom/A)
	A.BorgAltClick(src)

/mob/living/silicon/robot/CtrlAltClickOn(atom/A)
	A.BorgCtrlAltClick(src)

/atom/proc/BorgCtrlShiftClick(var/mob/living/silicon/robot/user) //forward to human click if not overriden
	CtrlShiftClick(user)

/obj/machinery/door/airlock/BorgCtrlShiftClick(mob/living/silicon/robot/user)
	AICtrlShiftClick(user)

/atom/proc/BorgShiftClick(var/mob/living/silicon/robot/user) //forward to human click if not overriden
	ShiftClick(user)

/obj/machinery/door/airlock/BorgShiftClick(mob/living/silicon/robot/user)  // Opens and closes doors! Forwards to AI code.
	AIShiftClick(user)

/atom/proc/BorgCtrlClick(var/mob/living/silicon/robot/user) //forward to human click if not overriden
	return CtrlClick(user)

/obj/machinery/door/airlock/BorgCtrlClick(mob/living/silicon/robot/user) // Bolts doors. Forwards to AI code.
	return AICtrlClick(user)

/obj/machinery/apc/BorgCtrlClick(mob/living/silicon/robot/user) // turns off/on APCs. Forwards to AI code.
	return AICtrlClick(user)

/obj/machinery/turretid/BorgCtrlClick(mob/living/silicon/robot/user) //turret control on/off. Forwards to AI code.
	return AICtrlClick(user)

/atom/proc/BorgAltClick(var/mob/living/silicon/robot/user)
	AltClick(user)
	return

/obj/machinery/door/airlock/BorgAltClick(mob/living/silicon/robot/user) // Eletrifies doors. Forwards to AI code.
	if (!user.check_intent(I_FLAG_HELP))
		AICtrlAltClick(user)
	else
		..()

/obj/machinery/turretid/BorgAltClick(mob/living/silicon/robot/user) //turret lethal on/off. Forwards to AI code.
	AIAltClick(user)

/atom/proc/BorgCtrlAltClick(var/mob/living/silicon/robot/user)
	CtrlAltClick(user)

/*
	As with AI, these are not used in click code,
	because the code for robots is specific, not generic.

	If you would like to add advanced features to robot
	clicks, you can do so here, but you will have to
	change attack_robot() above to the proper function
*/
/mob/living/silicon/robot/ResolveUnarmedAttack(atom/A)
	return A.attack_robot(src)

/mob/living/silicon/robot/RangedAttack(atom/A, var/params)
	return A.attack_robot(src)

/atom/proc/attack_robot(mob/user)
	return attack_ai(user)
