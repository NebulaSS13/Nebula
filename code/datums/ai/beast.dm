
/datum/mob_controller/aggressive/beast
	expected_type = /mob/living/simple_animal/hostile/beast
	only_attack_enemies = TRUE
	var/list/prey

/datum/mob_controller/aggressive/beast/do_process(time_elapsed)

	if(!(. = ..()))
		return

	var/mob/living/simple_animal/hostile/beast/beast = body
	if(!istype(beast))
		return

	var/nut = beast.get_nutrition()
	var/max_nut = beast.get_max_nutrition()
	if(nut > max_nut * 0.75 || beast.incapacitated())
		LAZYCLEARLIST(prey)
		return
	for(var/mob/living/simple_animal/S in range(beast,1))
		if(S == beast)
			continue
		if(S.stat != DEAD)
			continue
		beast.visible_message(SPAN_DANGER("\The [beast] consumes the body of \the [S]!"))
		var/turf/T = get_turf(S)
		var/remains_type = S.get_remains_type()
		if(remains_type)
			var/obj/item/remains/X = new remains_type(T)
			X.desc += "These look like they belonged to \a [S.name]."
		beast.adjust_nutrition(5 * S.get_max_health())
		if(prob(5))
			S.gib()
		else
			qdel(S)
		break

/datum/mob_controller/aggressive/beast/list_targets(var/dist = 7)
	. = ..()
	if(!length(.))
		if(LAZYLEN(prey))
			. = list()
			for(var/weakref/W in prey)
				var/mob/M = W.resolve()
				if(M)
					. |= M
		else if(body.get_nutrition() < body.get_max_nutrition() * 0.75) //time to look for some food
			for(var/mob/living/L in view(body, dist))
				if(attack_same_faction || L.faction != body.faction)
					LAZYDISTINCTADD(prey, weakref(L))
