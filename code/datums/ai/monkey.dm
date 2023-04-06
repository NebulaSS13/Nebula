/datum/ai/monkey
	name = "monkey"
	expected_type = /mob/living/carbon/human
	var/list/no_touchie = list(
		/obj/item/mirror,
		/obj/structure/mirror
	)

/datum/ai/monkey/do_process(var/time_elapsed)
	if(body.incapacitated())
		return

	if(prob(33) && isturf(body.loc) && !LAZYLEN(body.grabbed_by)) //won't move if being pulled
		body.SelfMove(pick(global.cardinal))

	var/obj/held = body.get_active_hand()
	if(held && prob(1))
		var/turf/T = get_random_turf_in_range(body, 7, 2)
		if(T)
			if(istype(held, /obj/item/gun) && prob(80))
				var/obj/item/gun/G = held
				G.Fire(T, body)
			else
				body.throw_item(T)
		else
			body.try_unequip(held)

	if(!held && !body.restrained() && prob(5))
		var/list/touchables = list()
		for(var/obj/O in range(1,get_turf(body)))
			if(O.simulated && CanPhysicallyInteractWith(body, O) && !is_type_in_list(O, no_touchie))
				touchables += O
		if(touchables.len)
			var/obj/touchy = pick(touchables)
			touchy.attack_hand(body) // No need for paranoid as we check physical interactivity above.
