/datum/mob_controller/monkey
	expected_type = /mob/living/human
	var/static/list/no_touchie = list(
		/obj/item/mirror,
		/obj/structure/mirror
	)

/datum/mob_controller/monkey/do_process(var/time_elapsed)

	if(!(. = ..()))
		return

	if(body.incapacitated())
		return

	var/obj/held = body.get_active_held_item()
	if(held && prob(1))
		var/turf/T = get_random_turf_in_range(body, 7, 2)
		if(T)
			if(istype(held, /obj/item/gun) && prob(40))
				var/obj/item/gun/G = held
				G.Fire(T, body)
			else
				body.mob_throw_item(T)
		else
			body.try_unequip(held)

	if(!held && !body.restrained() && prob(2.5))
		var/list/touchables = list()
		for(var/obj/O in range(1,get_turf(body)))
			if(O.simulated && CanPhysicallyInteractWith(body, O) && !is_type_in_list(O, no_touchie))
				touchables += O
		if(touchables.len)
			var/obj/touchy = pick(touchables)
			touchy.attack_hand(body) // No need for paranoid as we check physical interactivity above.
