/obj/effect/fluid
	name = ""
	icon = 'icons/effects/liquids.dmi'
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

/obj/effect/fluid/ex_act()
	return

/obj/effect/fluid/airlock_crush()
	qdel(src)

/obj/effect/fluid/Move()
	crash_with("A fluid overlay had Move() called!")
	return FALSE

/obj/effect/fluid/on_reagent_change()
	. = ..()
	ADD_ACTIVE_FLUID(src)
	queue_icon_update()

/obj/effect/fluid/Initialize()
	START_PROCESSING(SSobj, src)
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
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
	STOP_PROCESSING(SSobj, src)
	var/turf/simulated/T = loc
	if(istype(T))
		T.wet_floor()
	for(var/thing in neighbors)
		var/obj/effect/fluid/F = thing
		LAZYREMOVE(F.neighbors, src)
		ADD_ACTIVE_FLUID(F)
	neighbors = null
	REMOVE_ACTIVE_FLUID(src)
	. = ..()

/obj/effect/fluid/Process()
	if(reagents.total_volume <= FLUID_EVAPORATION_POINT)
		qdel(src)
		return
	if(world.time < next_fluid_act)
		return
	next_fluid_act = world.time + SSfluids.fluid_act_delay
	if(prob(1))
		playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
	if(length(loc.contents) > 1 && reagents.total_volume > FLUID_SHALLOW)
		for(var/thing in loc.contents)
			if(thing == src)
				continue
			var/atom/movable/AM = thing
			if(AM.simulated && !AM.waterproof)
				AM.fluid_act(reagents)
			if(last_flow_strength >= 10 && AM.is_fluid_pushable(last_flow_strength))
				step(AM, dir)

/obj/effect/fluid/on_update_icon()

	overlays.Cut()

	if(reagents.total_volume > FLUID_OVER_MOB_HEAD)
		layer = DEEP_FLUID_LAYER
	else
		layer = SHALLOW_FLUID_LAYER

	color = reagents.get_color()

	if(reagents.total_volume > FLUID_DEEP)
		alpha = FLUID_MAX_ALPHA
	else
		alpha = min(FLUID_MAX_ALPHA,max(FLUID_MIN_ALPHA,ceil(255*(reagents.total_volume/FLUID_DEEP))))

	if(reagents.total_volume <= FLUID_EVAPORATION_POINT)
		APPLY_FLUID_OVERLAY("shallow_still")
	else if(reagents.total_volume > FLUID_EVAPORATION_POINT && reagents.total_volume < FLUID_SHALLOW)
		APPLY_FLUID_OVERLAY("mid_still")
	else if(reagents.total_volume >= FLUID_SHALLOW && reagents.total_volume < (FLUID_DEEP*2))
		APPLY_FLUID_OVERLAY("deep_still")
	else if(reagents.total_volume >= (FLUID_DEEP*2))
		APPLY_FLUID_OVERLAY("ocean")

// Map helper.
/obj/effect/fluid_mapped
	name = "mapped flooded area"
	alpha = 125
	icon_state = "shallow_still"
	color = COLOR_OCEAN

	var/fluid_type = /decl/reagent/water
	var/fluid_initial = FLUID_MAX_DEPTH

/obj/effect/fluid_mapped/Initialize()
	..()
	var/turf/T = get_turf(src)
	if(istype(T))
		var/obj/effect/fluid/F = locate() in T
		if(!F) F = new(T)
		F.reagents.add_reagent(fluid_type, fluid_initial)
	return INITIALIZE_HINT_QDEL

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

/obj/effect/flood/ex_act()
	return

/obj/effect/flood/Initialize()
	. = ..()
	verbs.Cut()