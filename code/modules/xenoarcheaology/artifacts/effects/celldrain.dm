//todo
/datum/artifact_effect/celldrain
	name = "cell drain"
	origin_type = XA_EFFECT_ELECTRO
	var/last_message

/datum/artifact_effect/celldrain/DoEffectTouch(var/mob/user)
	if(user)
		if(isrobot(user))
			var/mob/living/silicon/robot/robot = user
			var/obj/item/cell/cell = robot.get_cell()
			if(cell)
				cell.use(100)
				to_chat(robot, SPAN_WARNING("SYSTEM ALERT: Energy drain detected!"))
				return 1

/datum/artifact_effect/celldrain/DoEffectAura()
	if(holder)
		drain_cells_in_range(rand() * 50)
		return 1

/datum/artifact_effect/celldrain/DoEffectPulse()
	if(holder)
		drain_cells_in_range(rand() * 150)
		return 1

/datum/artifact_effect/celldrain/proc/drain_cells_in_range(amount)
	var/turf/T = get_turf(holder)
	for (var/obj/machinery/apc/A in range(effect_range, T))
		var/obj/item/cell/cell = A.get_cell()
		if(cell)
			cell.use(amount)
	for (var/obj/machinery/power/smes/S in range(effect_range, T))
		S.remove_charge(amount / CELLRATE)
	for (var/mob/living/silicon/robot/M in range(effect_range, T))
		var/obj/item/cell/cell = M.get_cell()
		if(cell)
			cell.use(amount)
			if(world.time - last_message > 200)
				to_chat(M, SPAN_WARNING("SYSTEM ALERT: Energy drain detected!"))
				last_message = world.time
