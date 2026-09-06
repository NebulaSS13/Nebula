/obj/effect/insect_swarm
	anchored          = TRUE
	is_spawnable_type = FALSE
	icon_state        = "0"
	gender            = NEUTER
	default_pixel_z   = 8
	layer             = ABOVE_HUMAN_LAYER
	pass_flags        = PASS_FLAG_TABLE
	movement_handlers = list(/datum/movement_handler/delay/insect_swarm = list(1 SECOND))

	/// Current movement target for automove (ie. hive, flowers or victim)
	VAR_PRIVATE/atom/move_target
	/// Reference to our owning hive.
	var/datum/extension/insect_hive/owner
	/// Reference to our insect archetype.
	var/decl/insect_species/insect_type
	/// A counter for disturbances to the hive or this swarm, causes them to sting people.
	var/swarm_agitation = 0
	/// Percentage value; if it drops to 0, the swarm will be destroyed.
	var/swarm_intensity = 1
	/// Cooldown timer for next tick.
	VAR_PRIVATE/next_work = 0
	/// Time that smoke will wear off.
	var/smoked_until = 0

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
	update_transform()
	update_swarm()
	LAZYDISTINCTADD(owner.swarms, src)
	START_PROCESSING(SSobj, src)

/obj/effect/insect_swarm/Destroy()
	if(owner)
		owner.swarm_destroyed(src)
		LAZYREMOVE(owner.swarms, src)
		owner = null
	stop_automove()
	STOP_PROCESSING(SSobj, src)
	return ..()

// Resolves the current swarm amount to a coarser value used for icon state selection.
/obj/effect/insect_swarm/proc/get_swarm_state()
	return ceil((swarm_intensity / insect_type.max_swarm_intensity) * insect_type.max_swarm_state)

/obj/effect/insect_swarm/on_update_icon()
	. = ..()
	color = insect_type.swarm_color
	icon  = insect_type.swarm_icon
	icon_state = num2text(get_swarm_state())
	if(is_smoked())
		icon_state = "[icon_state]_smoked"

/obj/effect/insect_swarm/update_transform()
	. = ..()
	// Some icon variation via transform.
	if(prob(75))
		var/matrix/swarm_transform = transform || matrix()
		swarm_transform.Turn(pick(90, 180, 270))
		transform = swarm_transform

/obj/effect/insect_swarm/proc/update_swarm()
	update_icon()
	if(get_swarm_state() == 1)
		SetName(insect_type.name_singular)
		desc = insect_type.insect_desc
		gender = NEUTER
	else
		SetName(insect_type.name_plural)
		desc = insect_type.swarm_desc
		gender = PLURAL

/obj/effect/insect_swarm/proc/is_agitated()
	return QDELETED(owner) || (swarm_agitation > 0 && !is_smoked())

/obj/effect/insect_swarm/proc/find_sting_target()
	for(var/mob/living/victim in view(7, src))
		if(victim.simulated && !victim.is_playing_dead())
			return victim

/obj/effect/insect_swarm/proc/merge(obj/effect/insect_swarm/other_swarm)

	// If we can fit into one swarm, just merge us together.
	var/total_intensity = swarm_intensity + other_swarm.swarm_intensity
	if(total_intensity <= insect_type.max_swarm_intensity)
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

	if(!move_target || !(move_target in view(5, src)))
		stop_automove()

	if(is_smoked())
		return

	// Angry swarms move with purpose.
	if(is_agitated())
		swarm_agitation = max(0, swarm_agitation-1)
		if(!ismob(move_target))
			var/mob/new_move_target = find_sting_target()
			if(istype(new_move_target))
				move_target = new_move_target
		if(move_target)
			start_automove(move_target)
		if(insect_type.sting_amount || insect_type.sting_reagent)
			insect_type.try_sting(src, loc)
		return

	// Large swarms split if they aren't agitated.
	if(swarm_can_split() && isturf(loc))
		var/turf/our_turf = loc
		for(var/turf/swarm_turf as anything in RANGE_TURFS(our_turf, 1))
			if(swarm_turf == loc || !swarm_turf.CanPass(src))
				continue
			var/new_intensity = round(swarm_intensity/2)
			var/obj/effect/insect_swarm/new_swarm = new type(swarm_turf, insect_type, owner)
			new_swarm.swarm_intensity = new_intensity
			new_swarm.swarm_agitation = swarm_agitation
			new_swarm.update_swarm()
			swarm_intensity -= new_intensity
			update_swarm()
			break

	// Sting people, if we are so inclined.
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

/obj/effect/insect_swarm/finished_automove()
	..()
	next_work = world.time // we'be a busy bee, check to for new work once you reach your destination
	return FALSE

/obj/effect/insect_swarm/get_automove_target(datum/automove_metadata/metadata)
	return move_target

/obj/effect/insect_swarm/stop_automove()
	move_target = null
	. = ..()

/obj/effect/insect_swarm/can_do_automated_move(variant_move_delay)
	return ..() && !is_smoked()

/obj/effect/insect_swarm/start_automove(target, movement_type, datum/automove_metadata/metadata)
	move_target = target
	. = ..()

/obj/effect/insect_swarm/get_default_automove_controller_type()
	return /decl/automove_controller/stop_on_fail_or_completion

/obj/effect/insect_swarm/proc/handle_hive_behavior()

	var/atom/movable/hive = owner?.holder
	if(!isturf(loc))
		// We've just been created; shunt us out onto the turf.
		if(loc == hive)
			dropInto(hive.loc)
		else
			return

	// If we are the first (or only) of our owner swarms in the loc, and we aren't needed, we don't move. Hive needs workers.
	if(owner?.has_reserves(FRAME_RESERVE_COST))
		if(is_first_swarm_at_hive())
			stop_automove()
			return
		if(!hive_has_swarm() && loc != hive.loc)
			start_automove(hive)
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
	swarm_intensity = clamp(swarm_intensity + amount, 0, insect_type.max_swarm_intensity)
	if(old_intensity != swarm_intensity)
		if(swarm_intensity <= 0)
			qdel(src)
		else
			update_swarm()

/obj/effect/insect_swarm/proc/can_grow()
	// higher swarm intensity is only seen during agitated states when they converge on a victim and merge.
	return swarm_intensity < insect_type.max_swarm_growth_intensity

/obj/effect/insect_swarm/proc/can_merge()
	return swarm_intensity < (is_agitated() ? insect_type.max_swarm_intensity : insect_type.max_swarm_growth_intensity)

/obj/effect/insect_swarm/proc/swarm_can_split()
	return !is_agitated() && swarm_intensity > insect_type.max_swarm_growth_intensity

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

	var/atom/movable/hive = owner?.holder

	// Move to move target (hive or flowers)
	if(move_target)
		if(!(move_target in view(src, 7))) // no longer able to see our move target
			stop_automove()
			// don't bail early if we just stopped automove, that would introduce stutter as it'd take one tick to decide what to do next
		else
			// let us automove, don't restart it
			return

	// Unload pollen into hive.
	if(pollen)
		if(loc == get_turf(hive))
			owner.add_reserves(pollen)
			pollen = 0
			next_work = world.time + 5 SECONDS
			stop_automove()
		else
			start_automove(hive)
		return

	// Harvest from flowers in our loc.
	for(var/obj/machinery/portable_atmospherics/hydroponics/flower in loc)
		if(!flower.pollen)
			continue
		if(flower.seed && !flower.dead)
			flower.plant_health += rand(3, 5)
			flower.check_plant_health()
		pollen += flower.pollen
		flower.pollen = 0
		next_work = world.time + 5 SECONDS
		stop_automove()
		return

	// Same logic for flora. TODO unify these when seeds are rewritten to be less bespoke.
	for(var/obj/structure/flora/plant/flower in loc)
		if(!flower.pollen)
			continue
		pollen += flower.pollen
		flower.pollen = 0
		next_work = world.time + 5 SECONDS
		stop_automove()
		return

	// Find a flower.
	var/list/all_potential_targets = list()
	for(var/thing in view(src, 7))
		if(istype(thing, /obj/machinery/portable_atmospherics/hydroponics))
			var/obj/machinery/portable_atmospherics/hydroponics/flower = thing
			if(flower.pollen)
				all_potential_targets += flower
		else if(istype(thing, /obj/structure/flora/plant))
			var/obj/structure/flora/plant/flower = thing
			if(flower.pollen)
				all_potential_targets += flower

	var/closest_dist
	var/atom/closest_target
	for(var/atom/thing as anything in shuffle(all_potential_targets))
		var/next_dist = get_dist(src, thing)
		if(isnull(closest_target) || next_dist < closest_dist)
			closest_target = thing
			closest_dist = next_dist

	if(closest_target)
		start_automove(closest_target)
	else
		start_automove(hive)

/obj/effect/insect_swarm/proc/was_smoked(smoke_time = 1 MINUTE)
	smoked_until = max(smoked_until, world.time + smoke_time)
	swarm_agitation = round(swarm_agitation * 0.75)
	update_icon()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_icon), TRUE), smoke_time, (TIMER_UNIQUE|TIMER_OVERRIDE))

/obj/effect/insect_swarm/proc/is_smoked()
	return world.time < smoked_until