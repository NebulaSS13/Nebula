var/global/list/singularities = list()
/obj/effect/singularity
	name = "gravitational singularity"
	desc = "A gravitational singularity."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "singularity_s1"
	anchored =   TRUE
	density =    TRUE
	unacidable = TRUE //Don't comment this out.
	layer = SINGULARITY_LAYER
	light_power = 1
	light_range = 6
	is_spawnable_type = FALSE // No...

	/// Category used for investigation entries relating to this atom.
	var/const/investigation_label = "singulo"
	/// A list of events. Toxins is in here twice to double the chance of proccing.
	var/static/list/singularity_events = list(
		/decl/singularity_event/empulse   = 1,
		/decl/singularity_event/toxins    = 2,
		/decl/singularity_event/mesmerize = 1,
		/decl/singularity_event/nothing   = 1
	)

	/// When did we last emit a warning about a containment failure?
	var/last_warning
	/// What are our current values, icons, strings, etc?
	var/decl/singularity_stage/current_stage
	/// How strong/large are we? How much have we eaten?
	var/energy = 100
	/// Will we wander, if our stage permits it? Only set by var edit or mapped subtype.
	var/move_self = TRUE
	/// Our current target. Moves towards the target if it has one.
	var/weakref/target
	/// Will not move in the same dir if it couldnt before, will help with the getting stuck on fields thing.
	var/last_failed_movement = 0
	/// How many atoms can we pull in a single tick?
	var/const/max_atoms_assessed_per_tick = 100

/obj/effect/singularity/Initialize(mapload, var/starting_energy = 50, var/temp = 0)
	. = ..(mapload)
	var/found_containment = locate(/obj/effect/containment_field) in orange(30, src)
	if(!found_containment)
		last_warning = world.time
		message_admins("A singulo has been created without containment fields active ([x], [y], [z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>).")
	investigate_log("was created. [found_containment ? "" : "<font color='red'>No containment fields were active.</font>"]", investigation_label)
	current_stage = GET_DECL(/decl/singularity_stage/stage_one)
	energy = starting_energy
	global.singularities += src
	if (temp)
		QDEL_IN(src, temp)
	START_PROCESSING(SSobj, src)

/obj/effect/singularity/Destroy()
	global.singularities -= src
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/effect/singularity/Process_Spacemove(allow_movement)
	return TRUE

/obj/effect/singularity/proc/consume(atom/A)
	energy += A.singularity_act(src, current_stage.stage_size)

/obj/effect/singularity/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	if(current_stage.stage_size == STAGE_SUPER)//IT'S UNSTOPPABLE
		return
	if(severity == 1)
		if(prob(25))
			investigate_log("has been destroyed by an explosion.", investigation_label)
			qdel(src)
		else
			energy += 50
	else
		energy += round((rand(20,60)/2), 1)

/obj/effect/singularity/bullet_act(obj/item/projectile/P)
	return FALSE

/obj/effect/singularity/Process()

	// Eat or pull anything close to us.
	var/consumed = 0
	for(var/atom/consuming in range(current_stage.grav_pull, src))
		if(consuming == src)
			continue
		var/dist = get_dist(consuming, src)
		if(dist <= current_stage.consume_range)
			consume(consuming)
		else
			consuming.singularity_pull(src, current_stage.stage_size)
		if(consumed++ >= max_atoms_assessed_per_tick || TICK_CHECK)
			break

	if(TICK_CHECK)
		return

	// Check if we should be shrinking this tick, and apply it if we should.
	current_stage.handle_dissipation(src)

	// Check if we're large and energetic enough to move.
	if(!check_energy() || !current_stage.wander)
		return // Just hangs out for now.

	// Refresh our beacon target, if needed.
	var/obj/machinery/singularity_beacon/target_beacon
	if(length(global.singularity_beacons))
		if(target)
			target_beacon = target.resolve()
			if(!istype(target_beacon) || target_beacon.use_power != POWER_USE_ACTIVE)
				target_beacon = null
				target = null
		if(!target)
			for(var/obj/machinery/singularity_beacon/singubeacon as anything in global.singularity_beacons)
				if(singubeacon.use_power == POWER_USE_ACTIVE)
					target_beacon = singubeacon
					target = weakref(singubeacon)
					break

	// Move randomly towards our target, or in a random direction.
	if(move_self)

		// Get a direction to move.
		var/movement_dir
		if(target_beacon && prob(60))
			//moves to a singulo beacon, if there is one
			if(target_beacon.z == z)
				movement_dir = get_dir(src, target_beacon)
			else if(target_beacon.z > z && GetAbove(src))
				movement_dir = UP
			else if(target_beacon.z < z && GetBelow(src))
				movement_dir = DOWN

		else if(prob(16) && !(locate(/obj/effect/containment_field) in orange(7, src)))
			var/list/available_vertical_moves = list()
			if(GetAbove(src))
				available_vertical_moves += UP
			if(GetBelow(src))
				available_vertical_moves += DOWN
			if(length(available_vertical_moves))
				movement_dir = pick(available_vertical_moves)
		if(!movement_dir || movement_dir == last_failed_movement)
			movement_dir = pick(global.alldirs - last_failed_movement)

		// Try to move in it.
		if(!try_move(movement_dir, (movement_dir == UP || movement_dir == DOWN)))
			last_failed_movement = movement_dir

	// Feed any nearby rad collectors.
	for(var/obj/machinery/rad_collector/R in global.rad_collectors)
		if (get_dist(R, src) <= 15) //Better than using orange() every process.
			R.receive_pulse(energy)

	// Handle random events.
	if(prob(current_stage.event_chance))
		if(current_stage.stage_size >= STAGE_SUPER)
			var/decl/singularity_event/wave_event = GET_DECL(/decl/singularity_event/supermatter_wave)
			wave_event.handle_event(src)
		var/decl/singularity_event/singularity_event = pickweight(singularity_events)
		singularity_event = GET_DECL(singularity_event)
		singularity_event.handle_event(src)

/obj/effect/singularity/proc/try_move(var/movement_dir, var/vertical_move)
	set waitfor = FALSE
	if(current_stage.stage_size >= STAGE_FIVE)//The superlarge one does not care about things in its way
		step(src, movement_dir)
		if(!vertical_move)
			sleep(1)
			if(!QDELETED(src))
				step(src, movement_dir)
	else if(check_turfs_in(movement_dir))
		last_failed_movement = 0 // Reset this because we moved
		step(src, movement_dir)
		return TRUE
	return FALSE

/obj/effect/singularity/proc/check_energy()
	if (energy <= 0)
		investigate_log("collapsed.", investigation_label)
		qdel(src)
		return FALSE

	. = TRUE
	var/list/singulo_stages = decls_repository.get_decls_of_subtype(/decl/singularity_stage)
	for(var/stage_type in singulo_stages)
		var/decl/singularity_stage/stage = singulo_stages[stage_type]
		if(stage != current_stage && energy >= stage.min_energy && energy < stage.max_energy && stage.has_expansion_room(src))
			set_stage(stage)
			return

/obj/effect/singularity/proc/set_stage(decl/singularity_stage/next_stage)
	if(!next_stage || next_stage == current_stage)
		return FALSE
	if(next_stage.stage_size < current_stage.stage_size)
		next_stage.shrink_to(src)
		investigate_log("<font color='red'>shrank to size [next_stage.stage_size].</font>", investigation_label)
	else if(next_stage.stage_size > current_stage.stage_size)
		next_stage.grow_to(src)
		investigate_log("<font color='red'>grew to size [next_stage.stage_size].</font>", investigation_label)
	current_stage = next_stage
	update_icon()
	update_strings()
	return TRUE

/obj/effect/singularity/proc/check_turfs_in(var/direction = 0, var/step = 0)
	if(!direction)
		return 0
	var/steps
	if(!step)
		steps = current_stage?.footprint || 1
	else
		steps = step
	var/list/turfs = list()
	var/turf/T = src.loc
	for(var/i = 1 to steps)
		T = get_step(T,direction)
	if(!isturf(T))
		return 0
	turfs.Add(T)
	var/dir2 = 0
	var/dir3 = 0
	switch(direction)
		if(NORTH,SOUTH)
			dir2 = 4
			dir3 = 8
		if(EAST,WEST)
			dir2 = 1
			dir3 = 2
	var/turf/T2 = T
	for(var/j = 1 to steps)
		T2 = get_step(T2,dir2)
		if(!isturf(T2))
			return 0
		turfs.Add(T2)
	for(var/k = 1 to steps)
		T = get_step(T,dir3)
		if(!isturf(T))
			return 0
		turfs.Add(T)
	for(var/turf/T3 in turfs)
		if(isnull(T3))
			continue
		if(!can_move(T3))
			return 0
	return 1

/obj/effect/singularity/proc/can_move(const/turf/T)
	if (!isturf(T))
		return 0

	if ((locate(/obj/effect/containment_field) in T) || (locate(/obj/machinery/shieldwall) in T))
		return 0
	else if (locate(/obj/machinery/field_generator) in T)
		var/obj/machinery/field_generator/G = locate(/obj/machinery/field_generator) in T

		if (G && G.active)
			return 0
	else if (locate(/obj/machinery/shieldwallgen) in T)
		var/obj/machinery/shieldwallgen/S = locate(/obj/machinery/shieldwallgen) in T

		if (S && S.active)
			return 0
	return 1

/obj/effect/singularity/proc/update_strings()
	if(current_stage)
		SetName(current_stage.name)
		desc = current_stage.desc
	else
		SetName(initial(name))
		desc = initial(desc)

/obj/effect/singularity/on_update_icon()
	. = ..()
	var/last_pixel_x = default_pixel_x
	var/last_pixel_y = default_pixel_y
	if(current_stage)
		icon =            current_stage.icon
		icon_state =      current_stage.icon_state
		default_pixel_x = current_stage.pixel_x
		default_pixel_y = current_stage.pixel_y
	else
		icon =            initial(icon)
		icon_state =      initial(icon_state)
		default_pixel_x = initial(default_pixel_x)
		default_pixel_y = initial(default_pixel_y)
	if(last_pixel_x != default_pixel_x || last_pixel_y != default_pixel_y)
		reset_offsets(0)

/obj/effect/singularity/singularity_act(S, size)
	if(current_stage.stage_size <= size)
		var/gain = (energy/2)
		var/dist = max((current_stage.stage_size - 2), 1)
		explosion(src.loc,(dist),(dist*2),(dist*4))
		QDEL_IN(src, 1)
		return gain
	return 0

// Various overrides used to consume things interacting with the singularity.
/obj/effect/singularity/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	consume(user)
	return TRUE

/obj/effect/singularity/Bump(atom/A)
	consume(A)

/obj/effect/singularity/Bumped(atom/A)
	consume(A)

/obj/effect/singularity/attack_ai() //To prevent ais from gibbing themselves when they click on one.
	return TRUE

/obj/effect/singularity/attack_robot(mob/user)
	if(Adjacent(user))
		consume(user)
	return TRUE
