/datum/mob_controller/aggressive/giant_spider/nurse
	expected_type = /mob/living/simple_animal/hostile/giant_spider/nurse
	break_stuff_probability = 10
	var/atom/cocoon_target
	var/infest_chance = 8
	var/weakref/paired_guard
	//things we can't encase in a cocoon
	var/static/list/cocoon_blacklist = list(
		/mob/living/simple_animal/hostile/giant_spider,
		/obj/structure/closet
	)

/datum/mob_controller/aggressive/giant_spider/nurse/do_process(time_elapsed)

	if(!(. = ..()) || get_activity() != AI_ACTIVITY_IDLE || get_stance() != STANCE_IDLE)
		return // We are doing something else, let it play out.

	var/mob/living/simple_animal/hostile/giant_spider/nurse/spooder = body
	var/list/can_see = view(body, 10)
	//30% chance to stop wandering and do something
	if(prob(30))

		// TODO: move webbing and coccoon creation into the mob attack procs so players can use them when possessing a spider nurse.
		// first, check for potential food nearby to cocoon
		for(var/mob/living/web_target in can_see)
			if(is_type_in_list(web_target, cocoon_blacklist))
				continue
			if(web_target.stat)
				cocoon_target = web_target
				set_activity(AI_ACTIVITY_MOVING_TO_TARGET)
				body.start_automove(web_target)
				//give up if we can't reach them after 10 seconds
				give_up(web_target)
				return

		//second, spin a sticky spiderweb on this tile
		var/obj/effect/spider/stickyweb/W = locate() in get_turf(body)
		if(!W)
			set_activity(AI_ACTIVITY_BUILDING)
			body.visible_message(SPAN_NOTICE("\The [body] begins to secrete a sticky substance."))
			pause()
			spawn(4 SECONDS)
				if(get_activity() == AI_ACTIVITY_BUILDING)
					new /obj/effect/spider/stickyweb(body.loc)
					set_activity(AI_ACTIVITY_IDLE)
					resume()
		else
			//third, lay an egg cluster there
			var/obj/effect/spider/eggcluster/E = locate() in get_turf(body)
			if(!E && spooder.fed > 0 && spooder.max_eggs)
				set_activity(AI_ACTIVITY_REPRODUCING)
				body.visible_message(SPAN_NOTICE("\The [body] begins to lay a cluster of eggs."))
				pause()
				spawn(5 SECONDS)
					if(get_activity() == AI_ACTIVITY_REPRODUCING)
						E = locate() in get_turf(body)
						if(!E)
							new /obj/effect/spider/eggcluster(body.loc, body)
							spooder.max_eggs--
							spooder.fed--
						set_activity(AI_ACTIVITY_IDLE)
						resume()
			else
				//fourthly, cocoon any nearby items so those pesky pinkskins can't use them
				for(var/obj/O in can_see)

					if(O.anchored)
						continue

					if(is_type_in_list(O, cocoon_blacklist))
						continue

					if(istype(O, /obj/item) || istype(O, /obj/structure) || istype(O, /obj/machinery))
						cocoon_target = O
						set_activity(AI_ACTIVITY_MOVING_TO_TARGET)
						stop_wandering()
						body.start_automove(O)
						//give up if we can't reach them after 10 seconds
						give_up(O)

	else if(cocoon_target && body.Adjacent(cocoon_target) && get_activity() == AI_ACTIVITY_IDLE)
		set_activity(AI_ACTIVITY_BUILDING)
		body.visible_message(SPAN_NOTICE("\The [body] begins to secrete a sticky substance around \the [cocoon_target]."))
		stop_wandering()
		body.stop_automove()
		spawn(5 SECONDS)
			if(get_activity() == AI_ACTIVITY_BUILDING)
				if(cocoon_target && isturf(cocoon_target.loc) && get_dist(body, cocoon_target) <= 1)
					var/obj/effect/spider/cocoon/C = new(cocoon_target.loc)
					var/large_cocoon = 0
					C.pixel_x = cocoon_target.pixel_x
					C.pixel_y = cocoon_target.pixel_y
					for(var/mob/living/M in C.loc)
						large_cocoon = 1
						spooder.fed++
						spooder.max_eggs++
						body.visible_message(SPAN_WARNING("\The [body] sticks a proboscis into \the [cocoon_target] and sucks a viscous substance out."))
						M.forceMove(C)
						C.pixel_x = M.pixel_x
						C.pixel_y = M.pixel_y
						break
					for(var/obj/item/I in C.loc)
						I.forceMove(C)
					for(var/obj/structure/S in C.loc)
						if(!S.anchored)
							S.forceMove(C)
					for(var/obj/machinery/M in C.loc)
						if(!M.anchored)
							M.forceMove(C)
					if(large_cocoon)
						C.icon_state = pick("cocoon_large1","cocoon_large2","cocoon_large3")
					cocoon_target = null
				set_activity(AI_ACTIVITY_IDLE)
				resume_wandering()

/datum/mob_controller/aggressive/giant_spider/nurse/handle_death(gibbed)
	. = ..()
	if(!paired_guard)
		return
	var/datum/mob_controller/aggressive/giant_spider/guard/paired_guard_instance = paired_guard?.resolve()
	if(istype(paired_guard_instance) && paired_guard_instance.paired_nurse == weakref(src))
		paired_guard_instance.vengance = rand(50,100)
		if(prob(paired_guard_instance.vengance))
			paired_guard_instance.berserking = TRUE
			paired_guard_instance.go_berserk()
		paired_guard_instance.paired_nurse = null
	paired_guard = null

/datum/mob_controller/aggressive/giant_spider/nurse/proc/give_up(var/old_target)
	set waitfor = FALSE
	sleep(10 SECONDS)
	if(get_activity() != AI_ACTIVITY_MOVING_TO_TARGET)
		return
	if(cocoon_target == old_target && !body.Adjacent(cocoon_target))
		cocoon_target = null
	set_activity(AI_ACTIVITY_IDLE)
	resume_wandering()
