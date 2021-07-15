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

	var/last_flow_strength = 0
	var/last_flow_dir = 0
	var/update_lighting = FALSE

/obj/effect/fluid/Initialize()
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	icon_state = ""
	create_reagents(FLUID_MAX_DEPTH)
	. = ..()
	var/turf/simulated/T = get_turf(src)
	if(!isturf(T) || !T.CanFluidPass())
		return INITIALIZE_HINT_QDEL
	if(istype(T))
		T.unwet_floor(FALSE)

/obj/effect/fluid/airlock_crush()
	qdel(src)

/obj/effect/fluid/Move()
	PRINT_STACK_TRACE("A fluid overlay had Move() called!")
	return FALSE

/obj/effect/fluid/on_reagent_change()
	. = ..()
	ADD_ACTIVE_FLUID(src)
	for(var/checkdir in global.cardinal)
		var/obj/effect/fluid/F = locate() in get_step(loc, checkdir)
		if(F)
			ADD_ACTIVE_FLUID(F)
	update_lighting = TRUE
	update_icon()

/obj/effect/fluid/Destroy()
	var/turf/simulated/T = get_turf(src)
	for(var/checkdir in global.cardinal)
		var/obj/effect/fluid/F = locate() in get_step(T, checkdir)
		if(F)
			ADD_ACTIVE_FLUID(F)
	REMOVE_ACTIVE_FLUID(src)
	SSfluids.pending_flows -= src
	. = ..()
	if(istype(T) && reagents?.total_volume > 0)
		T.wet_floor()

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
		alpha = Clamp(CEILING(255*(reagents.total_volume/FLUID_DEEP)) * main_reagent.opacity, main_reagent.min_fluid_opacity, main_reagent.max_fluid_opacity)

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
	compile_overlays()

	if(update_lighting)
		update_lighting = FALSE
		var/glowing
		for(var/rtype in reagents.reagent_volumes)
			var/decl/material/reagent = GET_DECL(rtype)
			if(REAGENT_VOLUME(reagents, rtype) >= 3 && reagent.radioactivity)
				glowing = TRUE
				break
		if(glowing)
			set_light(1, 0.2, COLOR_GREEN)
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
		T.add_fluid(fluid_type, fluid_initial)
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