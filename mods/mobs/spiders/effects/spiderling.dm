/obj/effect/spider/spiderling
	name = "spiderling"
	desc = "It never stays still for long."
	icon = 'mods/mobs/spiders/icons/spider.dmi' // updated in Initialize()
	icon_state = "lesser"
	anchored = FALSE
	layer = BELOW_OBJ_LAYER
	max_health = 3
	var/mob/living/simple_animal/hostile/giant_spider/greater_form
	var/last_itch = 0
	var/amount_grown = -1
	var/obj/machinery/atmospherics/unary/vent_pump/entry_vent
	var/travelling_in_vent = 0
	var/dormant = FALSE    // If dormant, does not add the spiderling to the process list unless it's also growing
	var/growth_chance = 50 // % chance of beginning growth, and eventually become a beautiful death machine
	var/shift_range = 6

/obj/effect/spider/spiderling/proc/get_castes()
	var/static/list/castes = list(
		/mob/living/simple_animal/hostile/giant_spider/hunter            = 4,
		/mob/living/simple_animal/hostile/giant_spider/guard             = 3,
		/mob/living/simple_animal/hostile/giant_spider/nurse             = 3,
		/mob/living/simple_animal/hostile/giant_spider                   = 3,
		/mob/living/simple_animal/hostile/giant_spider/ranged/electric   = 2,
		/mob/living/simple_animal/hostile/giant_spider/frost             = 2,
		/mob/living/simple_animal/hostile/giant_spider/lurker            = 2,
		/mob/living/simple_animal/hostile/giant_spider/pepper            = 2,
		/mob/living/simple_animal/hostile/giant_spider/ranged/spitter    = 2,
		/mob/living/simple_animal/hostile/giant_spider/thermic           = 2,
		/mob/living/simple_animal/hostile/giant_spider/tunneller         = 2,
		/mob/living/simple_animal/hostile/giant_spider/ranged/webslinger = 2,
		/mob/living/simple_animal/hostile/giant_spider/carrier           = 1,
		/mob/living/simple_animal/hostile/giant_spider/volatile          = 1
	)
	return castes

/obj/effect/spider/spiderling/Initialize(var/mapload, var/atom/parent)
	var/list/castes = get_castes()
	if(!greater_form && length(castes))
		greater_form = pickweight(castes)
	if(ispath(greater_form))
		icon = initial(greater_form.icon)
	pixel_x = rand(-shift_range, shift_range)
	pixel_y = rand(-shift_range, shift_range)

	if(prob(growth_chance))
		amount_grown = 1
		dormant = FALSE

	if(dormant)
		events_repository.register(/decl/observ/moved, src, src, TYPE_PROC_REF(/obj/effect/spider, disturbed))
	else
		START_PROCESSING(SSobj, src)

	color = parent?.color || color
	. = ..()

/obj/effect/spider/spiderling/mundane
	growth_chance = 0 // Just a simple, non-mutant spider

/obj/effect/spider/spiderling/mundane/dormant
	dormant = TRUE    // It lies in wait, hoping you will walk face first into its web

/obj/effect/spider/spiderling/Destroy()
	if(dormant)
		events_repository.unregister(/decl/observ/moved, src, src, TYPE_PROC_REF(/obj/effect/spider, disturbed))
	STOP_PROCESSING(SSobj, src)
	stop_automove()
	. = ..()

/obj/effect/spider/spiderling/attackby(var/obj/item/used_item, var/mob/user)
	. = ..()
	if(current_health > 0)
		disturbed()

/obj/effect/spider/spiderling/Crossed(atom/movable/AM)
	if(!dormant || !isliving(AM))
		return
	var/mob/living/M = AM
	if(M.mob_size > MOB_SIZE_TINY)
		disturbed()

/obj/effect/spider/spiderling/disturbed()
	if(!dormant)
		return
	dormant = FALSE
	events_repository.unregister(/decl/observ/moved, src, src, TYPE_PROC_REF(/obj/effect/spider, disturbed))
	START_PROCESSING(SSobj, src)

/obj/effect/spider/spiderling/Bump(atom/user)
	if(istype(user, /obj/structure/table))
		forceMove(user.loc)
	else
		..()

/obj/effect/spider/spiderling/healthcheck()
	if(current_health <= 0)
		die()

/obj/effect/spider/spiderling/proc/check_vent(obj/machinery/atmospherics/unary/vent_pump/exit_vent)
	if(QDELETED(exit_vent) || exit_vent.welded) // If it's qdeleted we probably were too, but in that case we won't be making this call due to timer cleanup.
		forceMove(get_turf(entry_vent))
		entry_vent = null
		return TRUE

/obj/effect/spider/spiderling/proc/start_vent_moving(obj/machinery/atmospherics/unary/vent_pump/exit_vent, var/travel_time)
	if(check_vent(exit_vent))
		return
	if(prob(50))
		src.visible_message("<span class='notice'>You hear something squeezing through the ventilation ducts.</span>",2)
	forceMove(exit_vent)
	addtimer(CALLBACK(src, PROC_REF(end_vent_moving), exit_vent), travel_time)

/obj/effect/spider/spiderling/proc/end_vent_moving(obj/machinery/atmospherics/unary/vent_pump/exit_vent)
	if(check_vent(exit_vent))
		return
	forceMove(get_turf(exit_vent))
	travelling_in_vent = FALSE
	entry_vent = null

/obj/effect/spider/spiderling/Process()

	if(loc)
		var/datum/gas_mixture/environment = loc.return_air()
		if(environment && environment.gas[/decl/material/gas/methyl_bromide] > 0)
			die()
			return

	if(travelling_in_vent)
		if(isturf(src.loc))
			travelling_in_vent = 0
			entry_vent = null
	else if(entry_vent)
		if(get_dist(src, entry_vent) <= 1)
			var/datum/pipe_network/network = entry_vent.network_in_dir(entry_vent.dir)
			if(network && network.normal_members.len)
				var/list/vents = list()
				for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in network.normal_members)
					vents.Add(temp_vent)
				if(!vents.len)
					entry_vent = null
					return
				var/obj/machinery/atmospherics/unary/vent_pump/exit_vent = pick(vents)

				forceMove(entry_vent)
				var/travel_time = round(get_dist(loc, exit_vent.loc) / 2)
				addtimer(CALLBACK(src, PROC_REF(start_vent_moving), exit_vent, travel_time), travel_time + rand(20,60))
				travelling_in_vent = TRUE
				return
			else
				entry_vent = null
	//=================

	if(isturf(loc))
		if(prob(25))
			var/list/nearby = RANGE_TURFS(src, 5) - loc
			if(nearby.len)
				var/target_atom = pick(nearby)
				walk_to(src, target_atom, 5)
				if(prob(10))
					src.visible_message("<span class='notice'>\The [src] skitters[pick(" away"," around","")].</span>")
					// Reduces the risk of spiderlings hanging out at the extreme ranges of the shift range.
					var/min_x = pixel_x <= -shift_range ? 0 : -2
					var/max_x = pixel_x >=  shift_range ? 0 :  2
					var/min_y = pixel_y <= -shift_range ? 0 : -2
					var/max_y = pixel_y >=  shift_range ? 0 :  2

					pixel_x = clamp(pixel_x + rand(min_x, max_x), -shift_range, shift_range)
					pixel_y = clamp(pixel_y + rand(min_y, max_y), -shift_range, shift_range)
		else if(prob(5))
			//vent crawl!
			for(var/obj/machinery/atmospherics/unary/vent_pump/v in view(7,src))
				if(!v.welded)
					entry_vent = v
					walk_to(src, entry_vent, 5)
					break

		if(amount_grown >= 100)
			if(greater_form)
				new greater_form(src.loc, src)
			qdel(src)
	else if(isorgan(loc))
		if(!amount_grown) amount_grown = 1
		var/obj/item/organ/external/O = loc
		if(!O.owner || O.owner.stat == DEAD || amount_grown > 80)
			amount_grown = 20 //reset amount_grown so that people have some time to react to spiderlings before they grow big
			O.implants -= src
			forceMove(O.owner ? O.owner.loc : O.loc)
			src.visible_message("<span class='warning'>\A [src] emerges from inside [O.owner ? "[O.owner]'s [O.name]" : "\the [O]"]!</span>")
			if(O.owner)
				O.owner.apply_damage(5, BRUTE, O.organ_tag)
				O.owner.apply_damage(3, TOX, O.organ_tag)
		else if(prob(1))
			O.owner.apply_damage(1, TOX, O.organ_tag)
			if(world.time > last_itch + 30 SECONDS)
				last_itch = world.time
				to_chat(O.owner, "<span class='notice'>Your [O.name] itches...</span>")
	else if(prob(1))
		src.visible_message("<span class='notice'>\The [src] skitters.</span>")

	if(amount_grown > 0)
		amount_grown += rand(0,2)

/obj/effect/spider/spiderling/frost
	icon = /mob/living/simple_animal/hostile/giant_spider/frost::icon
	greater_form = /mob/living/simple_animal/hostile/giant_spider/frost
