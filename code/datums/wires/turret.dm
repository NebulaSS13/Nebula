/datum/wires/turret
	random = 1
	holder_type = /obj/machinery/turret
	wire_count = 9 // 4 'dud' wires to make hacking them a bit more difficult
	window_y = 500
	descriptions = list(
		new /datum/wire_description(TURRET_WIRE_POWER, "This wire seems to be carrying a heavy current."),
		new /datum/wire_description(TURRET_WIRE_HAYWIRE, "This wire connects to the target ID system.", SKILL_EXPERT),
		new /datum/wire_description(TURRET_WIRE_ACCESS, "This wire connects to the access panel."),
		new /datum/wire_description(TURRET_WIRE_AI_CONTROL, "This wire connects to automated control systems.", SKILL_EXPERT),
		new /datum/wire_description(TURRET_WIRE_REMOTE_CONTROL, "This wire connects to regional control systems.", SKILL_EXPERT)
	)


/datum/wires/turret/UpdateCut(index, mended)
	var/obj/machinery/turret/T = holder
	switch (index)
		if (TURRET_WIRE_POWER)
			if (mended)
				T.regain_power()
			else
				T.disable_power()
			T.shock(usr, 50)

		if (TURRET_WIRE_HAYWIRE)
			if (mended)
				T.clear_haywire()
			else
				T.set_haywire()

		if (TURRET_WIRE_ACCESS)
			T.lock_cut = !mended

		if (TURRET_WIRE_AI_CONTROL)
			T.ai_locked = !mended

		if (TURRET_WIRE_REMOTE_CONTROL)
			if (!mended)
				T.turret_controller = FALSE


/datum/wires/turret/UpdatePulsed(index)
	var/obj/machinery/turret/T = holder
	switch (index)
		if (TURRET_WIRE_POWER)
			T.disable_power(rand(30 SECONDS, 60 SECONDS))

		if (TURRET_WIRE_HAYWIRE)
			T.set_haywire(rand(30 SECONDS, 60 SECONDS))

		if (TURRET_WIRE_ACCESS)
			if (!T.lock_cut)
				T.panel_locked = !T.panel_locked

		if (TURRET_WIRE_AI_CONTROL)
			T.ai_locked = !T.ai_locked

		if (TURRET_WIRE_REMOTE_CONTROL)
			if (T.has_controller())
				T.turret_controller = !T.turret_controller
