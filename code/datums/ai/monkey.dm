/datum/ai/monkey
	name = "monkey"
	expected_type = /mob/living/carbon/human
	var/list/no_touchie = list(
		/obj/item/mirror,
		/obj/item/storage/mirror
	)

/datum/ai/monkey/do_process(var/time_elapsed)
	if(body.stat != CONSCIOUS)
		return

	if(prob(33) && isturf(body.loc) && !LAZYLEN(body.grabbed_by)) //won't move if being pulled
		body.SelfMove(pick(GLOB.cardinal))

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
			body.unEquip(held)

	if(!held && !body.restrained() && prob(5))
		var/list/touchables = list()
		for(var/obj/O in range(1,get_turf(body)))
			if(O.simulated && O.Adjacent(body) && !is_type_in_list(O, no_touchie))
				touchables += O
		if(touchables.len)
			var/obj/touchy = pick(touchables)
			touchy.attack_hand(body)