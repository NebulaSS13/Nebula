/obj/effect/insect_swarm
	anchored = TRUE
	is_spawnable_type = FALSE
	icon_state = "0"
	gender = NEUTER
	default_pixel_z = 8
	layer = ABOVE_HUMAN_LAYER
	movement_handlers = list(/datum/movement_handler/delay/insect_swarm)

	var/atom/move_target
	var/datum/extension/insect_hive/owner
	var/decl/insect_species/insect_type
	var/swarm_agitation = 0 // A counter for disturbances to the hive or this swarm, causes them to sting people.
	var/swarm_intensity = 1 // Percentage value; if it drops to 0, the swarm will be destroyed.
	var/const/MAX_SWARM_STATE = 6 // if more states are added to swarm.dmi, increase this
	var/next_work = 0

/datum/movement_handler/delay/insect_swarm
	delay = 1 SECOND

/datum/movement_handler/delay/insect_swarm/DoMove(direction, mob/mover, is_external)
	..()
	step(host, direction)
	return MOVEMENT_HANDLED

/obj/effect/insect_swarm/debug/Initialize(mapload)
	. = ..(mapload, _insect_type = /decl/insect_species/honeybees)

/obj/effect/insect_swarm/Initialize(mapload, _insect_type, _hive)
	. = ..()
	insect_type = istype(_insect_type, /decl/insect_species) ? _insect_type : GET_DECL(_insect_type)
	owner = _hive
	if(!istype(insect_type))
		PRINT_STACK_TRACE("Insect swarm created with invalid insect type: '[_insect_type]'")
		return INITIALIZE_HINT_QDEL
	if(!istype(owner))
		PRINT_STACK_TRACE("Insect swarm created with invalid hive: '[owner]'")
		return INITIALIZE_HINT_QDEL
	color = insect_type.swarm_color
	icon  = insect_type.swarm_icon
	update_swarm()
	START_PROCESSING(SSobj, src)

/obj/effect/insect_swarm/Destroy()
	if(owner)
		owner.swarm_destroyed(src)
		owner = null
	stop_automove()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/insect_swarm/proc/update_swarm()
	icon_state = num2text(ceil((swarm_intensity / 100) * MAX_SWARM_STATE))
	if(icon_state == "1")
		SetName(insect_type.name_singular)
		desc = insect_type.insect_desc
		gender = NEUTER
	else
		SetName(insect_type.name_plural)
		desc = insect_type.swarm_desc
		gender = PLURAL

	// Some icon variation via transform.
	if(prob(75))
		var/matrix/swarm_transform = matrix()
		swarm_transform.Turn(pick(90, 180, 270))

/obj/effect/insect_swarm/proc/is_agitated()
	return QDELETED(owner)

/obj/effect/insect_swarm/proc/find_target()
	for(var/mob/living/victim in view(7, src))
		if(!victim.simulated || victim.stat || victim.current_posture?.prone)
			continue
		if(victim.isSynthetic())
			continue
		return victim

/obj/effect/insect_swarm/proc/merge(obj/effect/insect_swarm/other_swarm)

	// If we can fit into one swarm, just merge us together.
	var/total_intensity = swarm_intensity + other_swarm.swarm_intensity
	if(total_intensity <= 100)
		swarm_intensity = total_intensity
		swarm_agitation = max(swarm_agitation, other_swarm.swarm_agitation)
		update_swarm()
		qdel(other_swarm)
		return

	// Otherwise equalize between swarms.
	swarm_intensity             = floor(total_intensity / 2)
	other_swarm.swarm_intensity = total_intensity - swarm_intensity
	swarm_agitation             = max(swarm_agitation, other_swarm.swarm_agitation)
	other_swarm.swarm_agitation = max(swarm_agitation, other_swarm.swarm_agitation)
	update_swarm()
	other_swarm.update_swarm()

/obj/effect/insect_swarm/Move()
	. = ..()
	// Swarms from the same hive in the same loc merge together.
	if(. && loc && !QDELETED(src))
		try_consolidate_swarms()

/obj/effect/insect_swarm/Process()

	// Swarms on a loc should try to merge if possible.
	try_consolidate_swarms()
	if(QDELETED(src))
		return

	// Swarms with no hive gradually decay to nothing.
	if(!owner)
		adjust_swarm_intensity(-(rand(1,3)))
		if(QDELETED(src))
			return

	// Angry swarms move with purpose.
	if(!move_target || !(move_target in view(5, src)))
		stop_automove()
	if(is_agitated())
		if(!move_target)
			move_target = find_target()
		if(move_target)
			start_automove(move_target)
			return

	// Large swarms split if they aren't agitated.
	if(can_split() && isturf(loc))
		var/turf/our_turf = loc
		for(var/turf/swarm_turf as anything in RANGE_TURFS(our_turf, 1))
			if(swarm_turf == loc || !swarm_turf.CanPass(src))
				continue
			var/new_intensity = round(swarm_intensity/2)
			var/obj/effect/insect_swarm/new_swarm = new type(swarm_turf, insect_type, owner)
			new_swarm.swarm_intensity = new_intensity
			new_swarm.swarm_agitation = swarm_agitation
			new_swarm.update_swarm()
			LAZYADD(owner.swarms, new_swarm)
			swarm_intensity -= new_intensity
			update_swarm()
			break

	if(insect_type.sting_amount || insect_type.sting_reagent)
		insect_type.try_sting(src, loc)

	// Hive behavior is dictated by the hive.
	if(owner)
		handle_hive_behavior()
		return

	// If we're not agitated and don't have a hive, we probably shouldn't be pathing somewhere.
	stop_automove()

	// Idle swarms with no hive just wander around.
	if(prob(5))
		SelfMove(pick(global.alldirs))

/obj/effect/insect_swarm/proc/is_first_swarm_at_hive()
	var/atom/movable/hive = owner?.holder
	if(!isturf(hive?.loc) || loc != hive.loc)
		return FALSE
	if(length(owner?.swarms) == 1)
		return TRUE
	for(var/obj/effect/insect_swarm/swarm in hive.loc)
		if(swarm == src)
			return TRUE
		if(swarm in owner.swarms)
			break
	return FALSE

/obj/effect/insect_swarm/get_automove_target(datum/automove_metadata/metadata)
	return move_target

/obj/effect/insect_swarm/stop_automove()
	SHOULD_CALL_PARENT(FALSE)
	move_target = null
	//. = ..() // TODO work out why they're not automoving
	walk(src, 0)

/obj/effect/insect_swarm/start_automove(target, movement_type, datum/automove_metadata/metadata)
	SHOULD_CALL_PARENT(FALSE)
	move_target = target
	//. = ..() // TODO work out why they're not automoving
	if(move_target)
		walk_to(src, move_target, 0, 7)
	else
		walk(src, 0)

/obj/effect/insect_swarm/proc/handle_hive_behavior()
	// If we are the first (or only) of our owner swarms in the loc, we don't move. Hive needs workers.
	var/atom/movable/hive = owner?.holder
	if(is_first_swarm_at_hive())
		stop_automove()
		return

	if(!hive_has_swarm() && loc != hive.loc)
		start_automove(owner.holder)
		return

	do_work()

/obj/effect/insect_swarm/proc/do_work()
	stop_automove()
	if(prob(25))
		var/step_dir = pick(global.alldirs)
		if(get_dist(owner.holder, get_step(loc, step_dir)) <= 2)
			SelfMove(step_dir)

/obj/effect/insect_swarm/proc/hive_has_swarm()
	var/atom/movable/hive = owner?.holder
	if(!isturf(hive?.loc))
		return FALSE
	for(var/obj/item/swarm as anything in owner.swarms)
		if(swarm.loc == hive.loc)
			return TRUE
	return FALSE

/obj/effect/insect_swarm/proc/adjust_swarm_intensity(amount)
	var/old_intensity = swarm_intensity
	swarm_intensity = clamp(swarm_intensity + amount, 0, 100)
	if(old_intensity != swarm_intensity)
		if(swarm_intensity <= 0)
			qdel(src)
		else
			update_swarm()

/obj/effect/insect_swarm/proc/can_grow()
	// higher swarm intensity is only seen during agitated states when they converge on a victim and merge.
	return swarm_intensity < 50

/obj/effect/insect_swarm/proc/can_merge()
	return swarm_intensity < (is_agitated() ? 100 : 50)

/obj/effect/insect_swarm/proc/can_split()
	return !is_agitated() && swarm_intensity >= 50

/obj/effect/insect_swarm/proc/try_consolidate_swarms()
	if(!can_merge())
		return
	for(var/obj/effect/insect_swarm/other_swarm in loc)
		if(other_swarm == src || !other_swarm.can_merge() || other_swarm.owner != owner || other_swarm.insect_type != insect_type)
			continue
		merge(other_swarm)
		return

/obj/effect/insect_swarm/pollinator
	var/pollen = 0

/obj/effect/insect_swarm/pollinator/do_work()

	// Have a rest/do some work.
	if(world.time < next_work)
		return

	// Unload pollen into hive.
	if(pollen)
		if(loc == get_turf(owner.holder))
			visible_message("\ref[src] unloading pollen.")
			owner.add_reserves(pollen)
			pollen = 0
			next_work = world.time + 5 SECONDS
			stop_automove()
		else
			visible_message("\ref[src] returning with pollen.")
			start_automove(owner.holder)
		return

	// Move to flowers.
	if(move_target)
		if(!(move_target in view(src, 7)))
			visible_message("\ref[src] lost target.")
			move_target = null
			stop_automove()
		else
			visible_message("\ref[src] moving to existing target.")
			start_automove(move_target)
			return

	// Harvest from flowers in our loc.
	for(var/obj/machinery/portable_atmospherics/hydroponics/flower in loc)
		if(!flower.pollen)
			continue
		pollen += flower.pollen
		flower.pollen = 0
		next_work = world.time + 5 SECONDS
		stop_automove()
		visible_message("\ref[src] harvesting pollen.")
		return

	// Find a flower.
	var/closest_dist
	var/atom/closest_target
	for(var/obj/machinery/portable_atmospherics/hydroponics/flower in view(src, 7))
		if(!flower.pollen)
			continue
		var/next_dist = get_dist(src, closest_target)
		if(isnull(closest_dist) || next_dist < closest_dist)
			closest_target = flower
			closest_dist = next_dist

	if(closest_target)
		start_automove(closest_target)
	else
		start_automove(owner.holder)

/obj/effect/insect_swarm/forager
