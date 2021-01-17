/obj/effect/fluid
	name = ""
	icon = 'icons/effects/liquids.dmi'
	icon_state = "puddle"
	anchored = 1
	simulated = 0
	opacity = 0
	mouse_opacity = 0
	layer = FLY_LAYER
	alpha = 0
	color = COLOR_OCEAN

	var/list/neighbors = list()
	var/last_flow_strength = 0
	var/next_fluid_act = 0
	var/update_lighting = FALSE

/obj/effect/fluid/airlock_crush()
	qdel(src)

/obj/effect/fluid/Move()
	crash_with("A fluid overlay had Move() called!")
	return FALSE

/obj/effect/fluid/on_reagent_change()
	if(reagents?.total_volume <= FLUID_EVAPORATION_POINT)
		qdel(src)
		return
	. = ..()
	ADD_ACTIVE_FLUID(src)
	update_lighting = TRUE
	queue_icon_update()

/obj/effect/fluid/Initialize()
	START_PROCESSING(SSobj, src)
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	icon_state = ""
	create_reagents(FLUID_MAX_DEPTH)
	. = ..()
	var/turf/simulated/T = get_turf(src)
	if(!isturf(T) || T.flooded)
		return INITIALIZE_HINT_QDEL
	if(istype(T))
		T.unwet_floor(FALSE)
	for(var/checkdir in GLOB.cardinal)
		var/obj/effect/fluid/F = locate() in get_step(src, checkdir)
		if(F)
			LAZYSET(neighbors, F, TRUE)
			LAZYSET(F.neighbors, src, TRUE)
			ADD_ACTIVE_FLUID(F)
	ADD_ACTIVE_FLUID(src)

/obj/effect/fluid/Destroy()
	var/turf/simulated/T = get_turf(src)
	if(istype(T))
		if(length(T.zone?.fuel_objs))
			T.zone.fuel_objs -= src
		T.wet_floor()
	STOP_PROCESSING(SSobj, src)
	for(var/thing in neighbors)
		var/obj/effect/fluid/F = thing
		LAZYREMOVE(F.neighbors, src)
		ADD_ACTIVE_FLUID(F)
	neighbors = null
	REMOVE_ACTIVE_FLUID(src)
	. = ..()

/obj/effect/fluid/proc/remove_fuel(var/amt)
	for(var/rtype in reagents.reagent_volumes)
		var/decl/material/liquid/fuel = decls_repository.get_decl(rtype)
		if(fuel.fuel_value)
			var/removing = min(amt, reagents.reagent_volumes[rtype])
			reagents.remove_reagent(rtype, removing)
			amt -= removing
		if(amt <= 0)
			break

/obj/effect/fluid/proc/get_fuel_amount()
	. = 0
	for(var/rtype in reagents?.reagent_volumes)
		var/decl/material/liquid/fuel = decls_repository.get_decl(rtype)
		if(fuel.fuel_value)
			. += REAGENT_VOLUME(reagents, rtype) * fuel.fuel_value

/obj/effect/fluid/Process()

	// Evaporation! TODO: add fumes to the air from this, if appropriate.
	if(reagents.total_volume > FLUID_EVAPORATION_POINT && reagents.total_volume <= FLUID_PUDDLE && prob(35))
		reagents.remove_any(min(reagents.total_volume, 1))

	if(reagents.total_volume <= FLUID_EVAPORATION_POINT)
		qdel(src)
		return

	// Apply reagent interactions to everything on the turf, and the turf itself.
	var/list/pushable
	if(!isturf(loc))
		return

	loc.fluid_act(reagents)
	var/pushing = (world.time >= next_fluid_act && reagents.total_volume > FLUID_SHALLOW && last_flow_strength >= 10)
	for(var/thing in loc.contents)
		if(thing == src)
			continue
		var/atom/movable/AM = thing
		if(!AM.simulated)
			continue
		AM.fluid_act(reagents)
		if(!QDELETED(AM) && pushing && AM.is_fluid_pushable(last_flow_strength))
			LAZYADD(pushable, AM)

	if(length(pushable))
		next_fluid_act = world.time + SSfluids.fluid_act_delay
		if(prob(1))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		for(var/thing in pushable)
			step(thing, dir)

/obj/effect/fluid/on_update_icon()

	cut_overlays()
	if(reagents.total_volume > FLUID_OVER_MOB_HEAD)
		layer = DEEP_FLUID_LAYER
	else
		layer = SHALLOW_FLUID_LAYER

	color = reagents.get_color()

	if(!reagents?.total_volume)
		return
		
	var/decl/material/main_reagent = reagents.get_primary_reagent_decl()
	if(main_reagent) // TODO: weighted alpha from all reagents, not just primary
		alpha = Clamp(ceil(255*(reagents.total_volume/FLUID_DEEP)) * main_reagent.opacity, main_reagent.min_fluid_opacity, main_reagent.max_fluid_opacity)

	if(reagents.total_volume <= FLUID_PUDDLE)
		APPLY_FLUID_OVERLAY("puddle")
	else if(reagents.total_volume <= FLUID_SHALLOW)
		APPLY_FLUID_OVERLAY("shallow_still")
	else if(reagents.total_volume < FLUID_DEEP)
		APPLY_FLUID_OVERLAY("mid_still")
	else if(reagents.total_volume < (FLUID_DEEP*2))
		APPLY_FLUID_OVERLAY("deep_still")
	else
		APPLY_FLUID_OVERLAY("ocean")

	if(update_lighting)
		update_lighting = FALSE
		var/glowing
		for(var/rtype in reagents.reagent_volumes)
			var/decl/material/reagent = decls_repository.get_decl(rtype)
			if(REAGENT_VOLUME(reagents, rtype) >= 3 && reagent.radioactivity)
				glowing = TRUE
				break
		if(glowing)
			set_light(0.2, 0.1, 1, l_color = COLOR_GREEN)
		else
			set_light(0)	

// Map helper.
/obj/effect/fluid_mapped
	name = "mapped flooded area"
	alpha = 125
	icon_state = "shallow_still"
	color = COLOR_OCEAN

	var/fluid_type = /decl/material/liquid/water
	var/fluid_initial = FLUID_MAX_DEPTH

/obj/effect/fluid_mapped/Initialize()
	..()
	var/turf/T = get_turf(src)
	if(istype(T))
		var/obj/effect/fluid/F = locate() in T
		if(!F) F = new(T)
		F.reagents.add_reagent(fluid_type, fluid_initial)
	return INITIALIZE_HINT_QDEL

/obj/effect/fluid_mapped/fuel
	name = "spilled fuel"
	fluid_type = /decl/material/liquid/fuel
	fluid_initial = 10

// Permaflood overlay.
/obj/effect/flood
	name = ""
	mouse_opacity = 0
	layer = DEEP_FLUID_LAYER
	color = COLOR_OCEAN
	icon = 'icons/effects/liquids.dmi'
	icon_state = "ocean"
	alpha = FLUID_MAX_ALPHA
	simulated = 0
	density = 0
	opacity = 0
	anchored = 1

/obj/effect/flood/explosion_act()
	SHOULD_CALL_PARENT(FALSE)
	return

/obj/effect/flood/Initialize()
	. = ..()
	verbs.Cut()