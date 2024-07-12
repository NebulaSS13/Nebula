/turf/floor/natural

	name = "ground"
	gender = PLURAL
	icon = 'icons/turf/flooring/barren.dmi'
	desc = "Bare, barren sand."
	icon_state = "0"
	footstep_type = /decl/footsteps/asteroid
	turf_flags = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH

	base_name = "ground"
	base_desc = "Bare, barren sand."
	base_icon = 'icons/turf/flooring/barren.dmi'
	base_icon_state = "0"
	base_color = null

	can_engrave = FALSE

	var/dirt_color = "#7c5e42"
	var/possible_states = 0
	var/icon_edge_layer = -1
	var/icon_edge_states
	var/icon_has_corners = FALSE
	/// The type to use when determining if a turf is our neighbour. If null, defaults to src's type.
	var/neighbour_type

	///Overrides the level's strata for this turf.
	var/strata_override
	var/decl/material/material

	var/is_fundament_turf = FALSE
	var/reagent_type
	var/const/TRENCH_DEPTH_PER_ACTION = 100

/turf/floor/natural/get_plant_growth_rate()
	return 0.1

/turf/floor/natural/is_plating()
	return FALSE

/turf/floor/natural/Initialize(mapload, no_update_icon = FALSE)

	if(base_color)
		color = base_color
	else
		color = null

	if(possible_states > 0)
		icon_state = "[rand(0, possible_states)]"

	neighbour_type ||= type

	// TEMP: set these so putting tiles over natural turfs doesn't make green sand.
	base_name       = name
	base_desc       = desc
	base_icon       = icon
	base_icon_state = icon_state
	base_color      = color
	// END TEMP

	if(material)
		set_turf_materials(material, skip_update = no_update_icon)

	. = ..(mapload)	// second param is our own, don't pass to children

	if(!no_update_icon)
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

/turf/floor/natural/attackby(obj/item/W, mob/user)

	if(!istype(flooring) && (istype(W, /obj/item/stack/material/ore) || istype(W, /obj/item/stack/material/lump)))

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
		var/stack_depth = ceil((abs(get_physical_height()) / TRENCH_DEPTH_PER_ACTION) * 5)
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

/turf/floor/natural/on_reagent_change()

	if(!(. = ..()))
		return

	if(!QDELETED(src) && reagent_type && height < 0 && !QDELETED(reagents) && reagents.total_volume < abs(height))
		add_to_reagents(reagent_type, abs(height) - reagents.total_volume)

/turf/floor/natural/dismantle_turf(devastated, explode, no_product, keep_air = TRUE)
	return !!switch_to_base_turf(keep_air)

/turf/floor/natural/get_soil_color()
	return dirt_color
