/datum/wires/apc
	holder_type = /obj/machinery/apc
	wire_count = 4
	descriptions = list(
		new /datum/wire_description(APC_WIRE_IDSCAN, "This wire is connected to the ID scanning panel.", SKILL_EXPERT),
		new /datum/wire_description(APC_WIRE_MAIN_POWER1, "This wire seems to be carrying a heavy current."),
		new /datum/wire_description(APC_WIRE_MAIN_POWER2, "This wire seems to be carrying a heavy current."),
		new /datum/wire_description(APC_WIRE_AI_CONTROL, "This wire connects to automated control systems.")
	)
	var/const/APC_WIRE_IDSCAN = BITFLAG(0)
	var/const/APC_WIRE_MAIN_POWER1 = BITFLAG(1)
	var/const/APC_WIRE_MAIN_POWER2 = BITFLAG(2)
	var/const/APC_WIRE_AI_CONTROL = BITFLAG(3)

/datum/wires/apc/GetInteractWindow(mob/user)
	var/obj/machinery/apc/A = holder
	. += ..()
	. += text("<br>\n[(A.locked ? "The APC is locked." : "The APC is unlocked.")]<br>\n[(A.shorted ? "The APCs power has been shorted." : "The APC is working properly!")]<br>\n[(A.aidisabled ? "The 'AI control allowed' light is off." : "The 'AI control allowed' light is on.")]")

/datum/wires/apc/CanUse(var/mob/living/L)
	var/obj/machinery/apc/A = holder
	if(istype(A.construct_state, /decl/machine_construction/wall_frame/panel_closed/hackable/hacking) && !(A.stat & BROKEN))
		return TRUE
	return FALSE

/datum/wires/apc/proc/reset_locked()
	var/obj/machinery/apc/A = holder
	if(A)
		A.locked = TRUE

/datum/wires/apc/proc/reset_shorted()
	var/obj/machinery/apc/A = holder
	if(A && !IsIndexCut(APC_WIRE_MAIN_POWER1) && !IsIndexCut(APC_WIRE_MAIN_POWER2))
		A.shorted = FALSE

/datum/wires/apc/proc/reset_ai_disabled()
	var/obj/machinery/apc/A = holder
	if(A && !IsIndexCut(APC_WIRE_AI_CONTROL))
		A.aidisabled = FALSE

/datum/wires/apc/UpdatePulsed(var/index)

	var/obj/machinery/apc/A = holder

	switch(index)

		if(APC_WIRE_IDSCAN)
			A.locked = FALSE
			addtimer(CALLBACK(src, PROC_REF(reset_locked)), 30 SECONDS)

		if (APC_WIRE_MAIN_POWER1, APC_WIRE_MAIN_POWER2)
			if(!A.shorted)
				A.shorted = TRUE
				addtimer(CALLBACK(src, PROC_REF(reset_shorted)), 2 MINUTES)

		if (APC_WIRE_AI_CONTROL)
			if (!A.aidisabled)
				A.aidisabled = TRUE
				addtimer(CALLBACK(src, PROC_REF(reset_ai_disabled)), 1 SECOND)

/datum/wires/apc/UpdateCut(var/index, var/mended)
	var/obj/machinery/apc/A = holder

	switch(index)
		if(APC_WIRE_MAIN_POWER1, APC_WIRE_MAIN_POWER2)
			if(!mended)
				A.shock(usr, 50)
				A.shorted = TRUE

			else if(!IsIndexCut(APC_WIRE_MAIN_POWER1) && !IsIndexCut(APC_WIRE_MAIN_POWER2))
				A.shorted = FALSE
				A.shock(usr, 50)

		if(APC_WIRE_AI_CONTROL)
			A.aidisabled = !mended