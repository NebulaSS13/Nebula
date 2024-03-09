var/global/list/carp_count = list() // a list of Z levels (string), associated with a list of all the carp spawned by carp events

/datum/event/carp_migration
	announceWhen	= 45
	endWhen			= 75
	var/no_show = FALSE // Carp are laggy, so if there is too much stuff going on we're going to dial it down.
	var/spawned_carp	//for debugging purposes only?
	var/carp_per_z = 8
	var/carp_per_event = 5

/datum/event/carp_migration/setup()
	announceWhen = rand(30, 60)
	endWhen += severity*25

/datum/event/carp_migration/proc/count_carps()
	var/total_carps
	var/local_carps
	for(var/Z in global.carp_count)
		var/list/L = global.carp_count[Z]
		total_carps += L.len
		if(text2num(Z) in affecting_z)
			local_carps += L.len

	if(total_carps >= 65 || SSmobs.ticks >= 10 || local_carps >= (affecting_z.len*carp_per_z+carp_per_event) || !living_observers_present(affecting_z))
		no_show = TRUE
	else
		no_show = FALSE

/datum/event/carp_migration/announce()
	var/announcement = ""
	if(severity > EVENT_LEVEL_MODERATE)
		announcement = "A massive migration of unknown biological entities has been detected in the vicinity of the [location_name()]. Exercise external operations with caution."
	else
		announcement = "A large migration of unknown biological entities has been detected in the vicinity of the [location_name()]. Caution is advised."

	command_announcement.Announce(announcement, "[location_name()] Sensor Array", zlevels = affecting_z)

/datum/event/carp_migration/tick()
	count_carps()
	if(no_show && prob(95))
		return

	spawn_carp()

/datum/event/carp_migration/proc/spawn_carp(var/direction, var/speed)
	if(!living_observers_present(affecting_z))
		return
	var/Z = pick(affecting_z)

	if(!direction)
		direction = pick(global.cardinal)

	if(!speed)
		speed = rand(1,3)

	var/n = rand(severity-1, severity*2)
	var/I = 0
	while(I < n)
		var/turf/T = get_random_edge_turf(direction,TRANSITIONEDGE + 2, Z)
		if(isspaceturf(T))
			var/mob/living/simple_animal/hostile/M
			if(prob(96))
				M = new /mob/living/simple_animal/hostile/carp(T)
			else
				M = new /mob/living/simple_animal/hostile/carp/pike(T)
				I += 3
			events_repository.register(/decl/observ/death, M,src, TYPE_PROC_REF(/datum/event/carp_migration, reduce_carp_count))
			events_repository.register(/decl/observ/destroyed, M,src, TYPE_PROC_REF(/datum/event/carp_migration, reduce_carp_count))
			LAZYADD(global.carp_count[num2text(Z)], M)
			spawned_carp ++
			M.throw_at(get_random_edge_turf(global.reverse_dir[direction],TRANSITIONEDGE + 2, Z), 250, speed, callback = CALLBACK(src, TYPE_PROC_REF(/datum/event/carp_migration, check_gib), M))
		I++
		if(no_show)
			break

/datum/event/carp_migration/proc/check_gib(var/mob/living/simple_animal/hostile/carp/M)	//awesome road kills
	if(M.current_health <= 0 && prob(60))
		M.gib()

/proc/get_random_edge_turf(var/direction, var/clearance = TRANSITIONEDGE + 1, var/Z)
	if(!direction)
		return

	switch(direction)
		if(NORTH)
			return locate(rand(clearance, world.maxx - clearance), world.maxy - clearance, Z)
		if(SOUTH)
			return locate(rand(clearance, world.maxx - clearance), clearance, Z)
		if(EAST)
			return locate(world.maxx - clearance, rand(clearance, world.maxy - clearance), Z)
		if(WEST)
			return locate(clearance, rand(clearance, world.maxy - clearance), Z)

/datum/event/carp_migration/proc/reduce_carp_count(var/mob/M)
	for(var/Z in affecting_z)
		var/list/L = global.carp_count[num2text(Z)]
		if(M in L)
			LAZYREMOVE(L,M)
			break
	events_repository.unregister(/decl/observ/death, M,src, TYPE_PROC_REF(/datum/event/carp_migration, reduce_carp_count))
	events_repository.unregister(/decl/observ/destroyed, M,src, TYPE_PROC_REF(/datum/event/carp_migration, reduce_carp_count))

/datum/event/carp_migration/end()
	log_debug("Carp migration event spawned [spawned_carp] carp.")

/datum/event/carp_migration/overmap
	announceWhen = 1
	carp_per_z = 5
	carp_per_event = 10
	var/obj/effect/overmap/visitable/ship/victim

/datum/event/carp_migration/overmap/Destroy()
	victim = null
	. = ..()

/datum/event/carp_migration/overmap/tick()
	count_carps()
	if(no_show && prob(95))
		return

	var/speed
	if(victim && !victim.is_still())
		speed = round(victim.get_speed()* (1000 + (victim.get_helm_skill()-SKILL_MIN)*250))//more skill more roadkills

	spawn_carp((victim && prob(80)? victim.fore_dir : null), speed)