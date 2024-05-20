#define MAT_DROP_CHANCE 30

///List of all the /turf/exterior/wall that exists in the world on all z-levels
var/global/list/natural_walls = list()

/obj/abstract/ramp_sculptor
	name = "ramp sculptor"
	icon_state = "x"
	var/place_dir

/obj/abstract/ramp_sculptor/south
	icon_state = "arrow"
	dir = SOUTH
	place_dir = SOUTH

/obj/abstract/ramp_sculptor/north
	icon_state = "arrow"
	dir = NORTH
	place_dir = NORTH

/obj/abstract/ramp_sculptor/east
	icon_state = "arrow"
	dir = EAST
	place_dir = EAST

/obj/abstract/ramp_sculptor/west
	icon_state = "arrow"
	dir = WEST
	place_dir = WEST

/obj/abstract/ramp_sculptor/Initialize()
	..()
	var/turf/exterior/wall/ramp = get_turf(src)
	if(istype(ramp) && !ramp.ramp_slope_direction)
		if(!place_dir || !(place_dir in global.cardinal))
			for(var/checkdir in global.cardinal)
				var/turf/neighbor = get_step(ramp, checkdir)
				if(neighbor && neighbor.density)
					place_dir = global.reverse_dir[checkdir]
					break
		if(place_dir)
			dir = place_dir
			ramp.make_ramp(null, place_dir)
	return INITIALIZE_HINT_QDEL

/turf/exterior/wall
	name = "wall"
	icon = 'icons/turf/walls/_previews.dmi'
	icon_state = "natural"
	density =    TRUE
	opacity =    TRUE
	density =    TRUE
	blocks_air = TRUE
	turf_flags = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_OBSTACLE

	var/ramp_slope_direction
	var/paint_color
	var/image/ore_overlay
	var/decl/material/reinf_material
	var/floor_type = /turf/exterior/barren
	var/static/list/exterior_wall_shine_cache = list()

/turf/exterior/wall/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(paint_color)
		to_chat(user, SPAN_NOTICE("It has been <font color = '[paint_color]'>noticeably discoloured</font> by the elements."))

/turf/exterior/wall/AltClick(mob/user)

	var/obj/item/P = user.get_active_hand()
	if(user.Adjacent(src) && IS_PICK(P) && HasAbove(z))

		var/user_dir = get_dir(src, user)
		if(!(user_dir in global.cardinal))
			to_chat(user, SPAN_WARNING("You must be standing at a cardinal angle to create a ramp."))
			return TRUE

		var/turf/exterior/wall/support = get_step(src, global.reverse_dir[user_dir])
		if(!istype(support) || support.ramp_slope_direction)
			to_chat(user, SPAN_WARNING("You cannot cut a ramp into a wall with no additional walls behind it."))
			return TRUE

		if(P.do_tool_interaction(TOOL_PICK, user, src, 3 SECONDS, suffix_message = ", forming it into a ramp") && !ramp_slope_direction)
			make_ramp(user, user_dir)
		return TRUE

	. = ..()

/turf/proc/handle_ramp_dug_below(turf/exterior/wall/ramp)
	if(simulated && !is_open())
		ChangeTurf(get_base_turf(z))

/turf/exterior/wall/proc/make_ramp(var/mob/user, var/new_slope, var/skip_icon_update = FALSE)

	ramp_slope_direction = new_slope

	var/old_ao = permit_ao
	if(ramp_slope_direction)
		drop_ore()
		permit_ao  = FALSE
		blocks_air = FALSE
		density    = FALSE
		opacity    = FALSE

		// Pretend to be a normal floor turf under the ramp.
		var/turf/exterior/under = floor_type
		icon             = initial(under.icon)
		icon_state       = initial(under.icon_state)
		icon_edge_layer  = initial(under.icon_edge_layer)
		icon_edge_states = initial(under.icon_edge_states)
		icon_has_corners = initial(under.icon_has_corners)
		color            = initial(under.color)

		decals = null
		var/turf/ramp_above = GetAbove(src)
		if(ramp_above)
			ramp_above.handle_ramp_dug_below(src)
		update_neighboring_ramps()

	else
		permit_ao  = initial(permit_ao)
		blocks_air = initial(blocks_air)
		density    = initial(density)
		color      = initial(color)
		set_opacity(!material || material.opacity >= 0.5)

		icon = 'icons/turf/walls/natural.dmi'
		icon_state = "blank"
		icon_edge_layer  = initial(icon_edge_layer)
		icon_edge_states = initial(icon_edge_states)
		icon_has_corners = initial(icon_has_corners)

	if(!skip_icon_update)
		for(var/turf/exterior/wall/neighbor in RANGE_TURFS(src, 1))
			neighbor.update_icon()
		if(old_ao != permit_ao)
			regenerate_ao()

/turf/exterior/wall/proc/update_neighboring_ramps(destroying_self)
	// Clear any ramps we were supporting.
	for(var/turf/exterior/wall/neighbor in RANGE_TURFS(src, 1))
		if(!neighbor.ramp_slope_direction || neighbor == src)
			continue
		var/turf/exterior/wall/support = get_step(neighbor, global.reverse_dir[neighbor.ramp_slope_direction])
		if(!istype(support) || (destroying_self && support == src) || support.ramp_slope_direction)
			neighbor.dismantle_wall(ramp_update = FALSE) // This will only occur on ramps, so no need to propagate to other ramps.

/turf/exterior/wall/Initialize(var/ml, var/materialtype, var/rmaterialtype)
	..(ml, TRUE)	// We update our own icon, no point doing it twice.

	// Clear mapped appearance.
	color = null
	icon = 'icons/turf/walls/natural.dmi'
	icon_state = "blank"

	// Init ramp state if needed.
	if(ramp_slope_direction)
		make_ramp(null, ramp_slope_direction, TRUE)

	// Init materials.

	global.natural_walls += src
	set_extension(src, /datum/extension/geological_data)
	set_turf_materials((materialtype || material || get_default_material()), (rmaterialtype || reinf_material), force = TRUE)
	. = INITIALIZE_HINT_LATELOAD

/turf/exterior/wall/LateInitialize(var/ml)
	..()
	update_material(!ml)
	spread_deposit()
	if(!ramp_slope_direction && floor_type && HasAbove(z))
		var/turf/T = GetAbove(src)
		if(!istype(T, floor_type) && T.is_open())
			T.ChangeTurf(floor_type, keep_air = TRUE)
	//Set the rock color
	if(!paint_color)
		var/rcolor = SSmaterials.get_rock_color(src)
		if(rcolor)
			paint_color = rcolor
			queue_icon_update()

/turf/exterior/wall/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	if(severity == 1 || (severity == 2 && prob(40)))
		dismantle_wall()

/turf/exterior/wall/Destroy()
	global.natural_walls -= src
	if(!ramp_slope_direction)
		update_neighboring_ramps(destroying_self = TRUE)
	. = ..()

/turf/exterior/wall/proc/spread_deposit()
	if(!istype(reinf_material) || reinf_material.ore_spread_chance <= 0)
		return
	for(var/trydir in global.cardinal)
		if(!prob(reinf_material.ore_spread_chance))
			continue
		var/turf/exterior/wall/target_turf = get_step_resolving_mimic(src, trydir)
		if(!istype(target_turf) || !isnull(target_turf.reinf_material))
			continue
		target_turf.set_turf_materials(target_turf.material, reinf_material)
		target_turf.spread_deposit()

/turf/exterior/wall/attackby(obj/item/W, mob/user, click_params)

	if(!user.check_dexterity(DEXTERITY_COMPLEX_TOOLS))
		return ..()

	if(!ramp_slope_direction)

		if(istype(W, /obj/item/depth_scanner))
			var/obj/item/depth_scanner/C = W
			C.scan_atom(user, src)
			return TRUE

		if (istype(W, /obj/item/measuring_tape))
			var/obj/item/measuring_tape/P = W
			user.visible_message(SPAN_NOTICE("\The [user] extends [P] towards [src]."),SPAN_NOTICE("You extend [P] towards [src]."))
			if(do_after(user,10, src))
				to_chat(user, SPAN_NOTICE("\The [src] has been excavated to a depth of [excavation_level]cm."))
			return TRUE

		if(istype(W, /obj/item/tool/xeno))
			return handle_xenoarch_tool_interaction(W, user)

	// Drill out natural walls.
	if(W.do_tool_interaction(TOOL_PICK, user, src, 2 SECONDS, suffix_message = destroy_artifacts(W, INFINITY)))
		dismantle_wall()
		return TRUE

	. = ..()

/turf/exterior/wall/proc/update_strings()
	if(reinf_material)
		SetName("[reinf_material.solid_name] deposit")
		desc = "A natural cliff face composed of bare [material.solid_name] and a deposit of [reinf_material.solid_name]."
	else
		SetName("natural [material.solid_name] wall")
		desc = "A natural cliff face composed of bare [material.solid_name]."

/turf/exterior/wall/proc/update_material(var/update_neighbors)
	if(material)
		explosion_resistance = material.explosion_resistance
	if(reinf_material && reinf_material.explosion_resistance > explosion_resistance)
		explosion_resistance = reinf_material.explosion_resistance
	update_strings()
	set_opacity(material.opacity >= 0.5)
	if(reinf_material?.ore_icon_overlay)
		ore_overlay = image('icons/turf/mining_decals.dmi', "[reinf_material.ore_icon_overlay]")
		ore_overlay.appearance_flags = RESET_COLOR
		var/matrix/M
		if(prob(50))
			M = M || matrix()
			M.Scale(-1,1)
		if(prob(75))
			M = M || matrix()
			M.Turn(pick(90, 180, 270))
		ore_overlay.color = reinf_material.color
		ore_overlay.layer = DECAL_LAYER
		if(M)
			ore_overlay.transform = M
	if(update_neighbors)
		for(var/direction in global.alldirs)
			var/turf/exterior/target_turf = get_step_resolving_mimic(src, direction)
			if(istype(target_turf))
				target_turf.update_icon()
	update_icon()

/turf/exterior/wall/on_update_icon()

	if(!istype(material))
		return

	var/list/wall_connections = list()
	for(var/stepdir in global.alldirs)

		// Get the wall.
		var/turf/exterior/wall/T = get_step_resolving_mimic(src, stepdir)
		if(!istype(T))
			continue

		if(ramp_slope_direction) // We are a ramp.
			// Adjacent ramps flowing in the same direction as us.
			if(ramp_slope_direction == T.ramp_slope_direction)
				wall_connections += stepdir
				continue
			// It's an adjacent non-ramp wall.
			if(!T.ramp_slope_direction)
				// It is behind us.
				if(stepdir & global.reverse_dir[ramp_slope_direction])
					wall_connections += stepdir
					continue
		else // We are a wall.
			// It is a wall.
			if(!T.ramp_slope_direction)
				wall_connections += stepdir
				continue
			// It's a ramp running away from us.
			if(stepdir & T.ramp_slope_direction)
				wall_connections += stepdir
				continue

	var/list/corner_states = dirs_to_corner_states(wall_connections)

	var/material_icon_base = material.icon_base_natural || 'icons/turf/walls/natural.dmi'
	var/base_color = paint_color ? paint_color : material.color

	var/shine = 0
	if(material?.reflectiveness > 0)
		var/shine_cache_key = "[material.reflectiveness]-[material.color]"
		shine = exterior_wall_shine_cache[shine_cache_key]
		if(isnull(shine))
			// patented formula based on color's value (in HSV)
			shine = clamp((material.reflectiveness * 0.01) * 255, 10, (0.6 * ReadHSV(RGBtoHSV(material.color))[3]))
			exterior_wall_shine_cache[shine_cache_key] = shine

	var/new_icon
	if(ramp_slope_direction)

		..() // Draw the floor under us.

		var/turf/exterior/wall/neighbor = get_step(src, turn(ramp_slope_direction, -90))
		var/has_left_neighbor  = istype(neighbor) && neighbor.ramp_slope_direction == ramp_slope_direction
		neighbor = get_step(src, turn(ramp_slope_direction, 90))
		var/has_right_neighbor = istype(neighbor) && neighbor.ramp_slope_direction == ramp_slope_direction

		var/state = "ramp-single"
		if(has_left_neighbor && has_right_neighbor)
			state = "ramp-blend-full"
		else if(has_left_neighbor)
			state = "ramp-blend-left"
		else if(has_right_neighbor)
			state = "ramp-blend-right"

		var/image/I = image(material_icon_base, state, dir = ramp_slope_direction)
		I.color = base_color
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)
		if(shine)
			I = image(material_icon_base, "[state]-shine", dir = ramp_slope_direction)
			I.appearance_flags |= RESET_ALPHA
			I.alpha = shine
			add_overlay(I)

	else

		new_icon = get_combined_wall_icon(corner_states, null, material_icon_base, base_color, shine_value = shine)
		if(icon != new_icon)
			icon = new_icon
		if(icon_state != "")
			icon_state = ""
		if(color)
			color = null

	if(ore_overlay)
		add_overlay(ore_overlay)
	if(excav_overlay)
		add_overlay(excav_overlay)
	if(archaeo_overlay)
		add_overlay(archaeo_overlay)

/turf/exterior/wall/proc/drop_ore()
	if(reinf_material?.ore_result_amount)
		pass_geodata_to(new /obj/item/stack/material/ore(src, reinf_material.ore_result_amount, reinf_material.type))
		reinf_material = null
		ore_overlay = null
		update_material(FALSE)
	if(prob(MAT_DROP_CHANCE) && !ramp_slope_direction && material)
		pass_geodata_to(new /obj/item/stack/material/ore(src, material.ore_result_amount, material.type))

/turf/exterior/wall/proc/dismantle_wall(no_product = FALSE, ramp_update = TRUE)

	if(!no_product)
		drop_ore()
	destroy_artifacts(null, INFINITY)

	if(ramp_update && !ramp_slope_direction)
		ramp_slope_direction = NORTH // Temporary so we don't let any neighboring ramps use us as supports.
		update_neighboring_ramps()
		ramp_slope_direction = null

	playsound(src, 'sound/items/Welder.ogg', 100, 1)
	return ChangeTurf(floor_type || get_base_turf_by_area(src), keep_air = TRUE)

/turf/exterior/wall/proc/pass_geodata_to(obj/O)
	var/datum/extension/geological_data/ours = get_extension(src, /datum/extension/geological_data)
	if(ours.geodata)
		ours.geodata.UpdateNearbyArtifactInfo(src)
		set_extension(O, /datum/extension/geological_data)
		var/datum/extension/geological_data/newdata = get_extension(O, /datum/extension/geological_data)
		if(newdata)
			newdata.set_data(ours.geodata.get_copy())

/turf/exterior/wall/Bumped(var/atom/movable/AM)
	. = ..()
	if(!. && !ramp_slope_direction && ismob(AM))
		var/mob/M = AM
		var/obj/item/held = M.get_active_hand()
		if(IS_PICK(held))
			attackby(held, M)
			return TRUE

#undef MAT_DROP_CHANCE