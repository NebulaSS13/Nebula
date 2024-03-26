/turf/exterior
	name = "ground"
	icon = 'icons/turf/exterior/barren.dmi'
	footstep_type = /decl/footsteps/asteroid
	icon_state = "0"
	layer = PLATING_LAYER
	open_turf_type = /turf/open
	turf_flags = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH
	zone_membership_candidate = TRUE
	initial_gas = list(
		/decl/material/gas/oxygen = MOLES_O2STANDARD,
		/decl/material/gas/nitrogen = MOLES_N2STANDARD
	)

	var/base_color
	var/dirt_color = "#7c5e42"
	var/possible_states = 0
	var/icon_edge_layer = -1
	var/icon_edge_states
	var/icon_has_corners = FALSE

	///Overrides the level's strata for this turf.
	var/strata_override
	var/decl/material/material

	var/is_fundament_turf = FALSE
	var/reagent_type

	var/const/TRENCH_DEPTH_PER_ACTION = 100

/turf/exterior/Initialize(mapload, no_update_icon = FALSE)

	if(base_color)
		color = base_color
	else
		color = null

	if(possible_states > 0)
		icon_state = "[rand(0, possible_states)]"

	. = ..(mapload)	// second param is our own, don't pass to children

	if (no_update_icon)
		return

	// If this is a mapload, then our neighbors will be updating their own icons too -- doing it for them is rude.
	if(!mapload)
		for(var/direction in global.alldirs)
			var/turf/target_turf = get_step_resolving_mimic(src, direction)
			if(istype(target_turf))
				if(TICK_CHECK) // not CHECK_TICK -- only queue if the server is overloaded
					target_turf.queue_icon_update()
				else
					target_turf.update_icon()
	update_icon()

	if(reagent_type && height < 0)
		add_to_reagents(reagent_type, abs(height))

/turf/exterior/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/stack/material/ore) || istype(W, /obj/item/stack/material/lump))

		if(get_physical_height() >= 0)
			to_chat(user, SPAN_WARNING("\The [src] is flush with ground level and cannot be backfilled."))
			return TRUE

		if(!W.material?.can_backfill_turf_type)
			to_chat(user, SPAN_WARNING("You cannot use \the [W] to backfill \the [src]."))
			return TRUE

		var/can_backfill = islist(W.material.can_backfill_turf_type) ? is_type_in_list(src, W.material.can_backfill_turf_type) : istype(src, W.material.can_backfill_turf_type)
		if(!can_backfill)
			to_chat(user, SPAN_WARNING("You cannot use \the [W] to backfill \the [src]."))
			return TRUE

		var/obj/item/stack/stack = W
		if(!do_after(user, 1 SECOND, src) || user.get_active_held_item() != stack || get_physical_height() >= 0)
			return TRUE

		// At best, you get about 5 pieces of clay or dirt from digging the
		// associated turfs. So we'll make it cost 5 to put some back.
		// TODO: maybe make this use the diggable loot list.
		var/stack_depth = CEILING((abs(get_physical_height()) / TRENCH_DEPTH_PER_ACTION) * 5)
		var/using_lumps = max(1, min(stack.amount, min(stack_depth, 5)))
		if(stack.use(using_lumps))
			set_physical_height(min(0, get_physical_height() + ((using_lumps / 5) * TRENCH_DEPTH_PER_ACTION)))
			playsound(src, 'sound/items/shovel_dirt.ogg', 50, TRUE)
			if(get_physical_height() >= 0)
				visible_message(SPAN_NOTICE("\The [user] backfills \the [src]!"))
			else
				visible_message(SPAN_NOTICE("\The [user] partially backfills \the [src]."))
		return TRUE

	return ..()

/turf/exterior/on_reagent_change()
	. = ..()
	if(reagent_type && height < 0 && reagents && reagents.total_volume < abs(height))
		add_to_reagents(abs(height) - reagents.total_volume)

/turf/exterior/is_floor()
	return !density && !is_open()

/turf/exterior/is_plating()
	return !density

/turf/exterior/can_engrave()
	return FALSE

/turf/exterior/explosion_act(severity)
	SHOULD_CALL_PARENT(TRUE)
	..()
	if(!istype(src, get_base_turf_by_area(src)) && (severity == 1 || (severity == 2 && prob(40))))
		ChangeTurf(get_base_turf_by_area(src))

/turf/exterior/on_defilement()
	..()
	if(density)
		ChangeTurf(/turf/wall/cult)
	else
		ChangeTurf(/turf/floor/cult)
