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
	///If this turf is on a level that belongs to a planetoid, this is a reference to that planetoid.
	var/datum/planetoid_data/owner
	///Overrides the level's strata for this turf.
	var/strata_override
	var/decl/material/material
	/// Whether or not sand/clay has been dug up here.
	var/dug = FALSE
	var/is_fundament_turf = FALSE
	var/reagent_type

/turf/exterior/Initialize(mapload, no_update_icon = FALSE)

	if(base_color)
		color = base_color
	else
		color = null

	if(possible_states > 0)
		icon_state = "[rand(0, possible_states)]"

	//Grab owner and set base area if we don't have a valid area
	owner = LAZYACCESS(SSmapping.planetoid_data_by_z, z)
	if(!istype(owner))
		owner = null
	else if(istype(loc, world.area))
		//Must be done here, as light data is not fully carried over by ChangeTurf (but overlays are).
		//If on the surface level, and the planet defines a surface area, prioritize it.
		var/datum/level_data/L = SSmapping.levels_by_z[z]
		if(L.level_id == owner.surface_level_id && owner.surface_area)
			ChangeArea(src, owner.surface_area)
		//Otherwise fall back to the level_data's base_area
		else if(L.base_area)
			ChangeArea(src, L.get_base_area_instance())

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

/turf/exterior/Destroy()
	owner = null
	. = ..()

/turf/exterior/explosion_act(severity)
	SHOULD_CALL_PARENT(TRUE)
	..()
	if(!istype(src, get_base_turf_by_area(src)) && (severity == 1 || (severity == 2 && prob(40))))
		ChangeTurf(get_base_turf_by_area(src))

/turf/exterior/on_defilement()
	..()
	if(density)
		ChangeTurf(/turf/simulated/wall/cult)
	else
		ChangeTurf(/turf/simulated/floor/cult)
