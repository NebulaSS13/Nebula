#define MAT_DROP_CHANCE 30

var/global/list/default_strata_type_by_z = list()
var/global/list/default_material_by_strata_and_z = list()
var/global/list/natural_walls = list()

/turf/exterior/wall
	name = "wall"
	icon = 'icons/turf/walls/_previews.dmi'
	icon_state = "natural"
	density =    TRUE
	opacity =    TRUE
	density =    TRUE
	blocks_air = TRUE

	var/sloped = 0 // Direction, not bool.
	var/strata
	var/paint_color
	var/image/ore_overlay
	var/decl/material/material
	var/decl/material/reinf_material
	var/floor_type = /turf/exterior/barren

/turf/exterior/wall/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(paint_color)
		to_chat(user, SPAN_NOTICE("It has been <font color = '[paint_color]'>noticeably discoloured</font> by the elements."))

/turf/exterior/wall/AltClick(mob/user)

	if(user.Adjacent(src) && istype(user.get_active_hand(), /obj/item/pickaxe) && HasAbove(z))
		var/user_dir = get_dir(src, user)
		if(!(user_dir in global.cardinal))
			to_chat(user, SPAN_WARNING("You must be standing at a cardinal angle to create a ramp."))
			return TRUE

		var/turf/exterior/wall/support = get_step(src, user_dir)
		if(!istype(support) || support.sloped)
			to_chat(user, SPAN_WARNING("You cannot cut a ramp into a wall with no additional walls behind it."))
			return TRUE

		var/obj/item/pickaxe/P = user.get_active_hand()
		playsound(user, P.drill_sound, 20, 1)
		to_chat(user, SPAN_NOTICE("You start [P.drill_verb] \the [src], forming it into a ramp."))
		if(do_after(user, round(P.digspeed*0.5), src) && !sloped)
			to_chat(user, SPAN_NOTICE("You finish [P.drill_verb] \the [src] into a ramp."))
			make_ramp(user_dir)
		return TRUE

	. = ..()
	
/turf/exterior/wall/proc/make_ramp(var/new_slope, var/skip_icon_update = FALSE)

	sloped = new_slope

	if(sloped)
		drop_ore()
		blocks_air = FALSE
		density =    FALSE
		opacity =    FALSE

		// Pretend to be a normal floor turf under the ramp.
		var/turf/exterior/under = floor_type
		icon =             initial(under.icon)
		icon_state =       initial(under.icon_state)
		icon_edge_layer  = initial(under.icon_edge_layer)
		icon_edge_states = initial(under.icon_edge_states)
		icon_has_corners = initial(under.icon_has_corners)

		var/turf/T = GetAbove(src)
		if(T && !T.is_open())
			T.ChangeTurf(get_base_turf(T.z))

	else
		blocks_air = initial(blocks_air)
		density =    initial(density)
		set_opacity(!material || material.opacity >= 0.5)

		icon = 'icons/turf/walls/natural.dmi'
		icon_state = "blank"
		icon_edge_layer  = initial(icon_edge_layer)
		icon_edge_states = initial(icon_edge_states)
		icon_has_corners = initial(icon_has_corners)

	if(!skip_icon_update)
		update_icon()

/turf/exterior/wall/Initialize(var/ml, var/materialtype, var/rmaterialtype)
	..(ml, TRUE)	// We update our own icon, no point doing it twice.

	// Clear mapped appearance.
	color = null
	icon = 'icons/turf/walls/natural.dmi'
	icon_state = "blank"

	// Init ramp state if needed.
	if(sloped)
		make_ramp(sloped, TRUE)
	else
		. = INITIALIZE_HINT_LATELOAD

	// Init materials.
	material = SSmaterials.get_strata_material(src)

	global.natural_walls += src

	set_extension(src, /datum/extension/geological_data)
	if(!ispath(material, /decl/material))
		material = materialtype || get_default_material()
	if(ispath(material, /decl/material))
		material = GET_DECL(material)
	if(!ispath(reinf_material, /decl/material))
		reinf_material = rmaterialtype
	if(ispath(reinf_material, /decl/material))
		reinf_material = GET_DECL(reinf_material)

/turf/exterior/wall/LateInitialize(var/ml)
	..()
	update_material(!ml)
	spread_deposit()
	if(!sloped && floor_type && HasAbove(z))
		var/turf/T = GetAbove(src)
		if(!istype(T, floor_type) && T.is_open())
			T.ChangeTurf(floor_type, keep_air = TRUE)

/turf/exterior/wall/explosion_act(severity)
	if(severity == 1 || (severity == 2 && prob(40)))
		dismantle_wall()

/turf/exterior/wall/Destroy()
	global.natural_walls -= src
	. = ..()

/turf/exterior/wall/proc/set_material(var/decl/material/newmaterial, var/decl/material/newrmaterial)
	material = newmaterial
	if(ispath(material, /decl/material))
		material = GET_DECL(material)
	else if(!istype(material))
		PRINT_STACK_TRACE("Wall has been supplied non-material '[newmaterial]'.")
		material = GET_DECL(get_default_material())
	reinf_material = newrmaterial
	if(ispath(reinf_material, /decl/material))
		reinf_material = GET_DECL(reinf_material)
	else if(!istype(reinf_material))
		reinf_material = null
	update_material()

/turf/exterior/wall/proc/spread_deposit()
	if(!istype(reinf_material) || reinf_material.ore_spread_chance <= 0)
		return
	for(var/trydir in global.cardinal)
		if(!prob(reinf_material.ore_spread_chance))
			continue
		var/turf/exterior/wall/target_turf = get_step(src, trydir)
		if(!istype(target_turf) || !isnull(target_turf.reinf_material))
			continue
		target_turf.set_material(target_turf.material, reinf_material)
		target_turf.spread_deposit()

/turf/exterior/wall/attackby(obj/item/W, mob/user, click_params)

	if(!user.check_dexterity(DEXTERITY_COMPLEX_TOOLS))
		return ..()

	if(!sloped)

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

		if(istype(W, /obj/item/pickaxe/xeno))
			return handle_xenoarch_tool_interaction(W, user)

	// Drill out natural walls.
	if(istype(W, /obj/item/pickaxe))
		var/obj/item/pickaxe/P = W
		playsound(user, P.drill_sound, 20, 1)
		to_chat(user, SPAN_NOTICE("You start [P.drill_verb][destroy_artifacts(P, INFINITY)]."))
		if(do_after(user, (sloped ? round(P.digspeed*0.5) : P.digspeed), src))
			to_chat(user, SPAN_NOTICE("You finish [P.drill_verb] \the [src]."))
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
	if(!material)
		material = GET_DECL(get_default_material())
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
		for(var/turf/exterior/T in RANGE_TURFS(src, 1))
			T.update_icon()
	else
		update_icon()

/turf/exterior/wall/on_update_icon()

	if(!istype(material))
		return

	var/list/wall_connections = list()
	for(var/stepdir in global.alldirs)
		var/turf/exterior/wall/T = get_step(src, stepdir)
		if(istype(T))
			wall_connections += get_dir(src, T)
	wall_connections = dirs_to_corner_states(wall_connections)

	var/material_icon_base = material.icon_base_natural || 'icons/turf/walls/natural.dmi'
	var/base_color = paint_color ? paint_color : material.color

	var/max_shine
	var/shine
	if(material?.reflectiveness > 0)
		max_shine = 0.6 * ReadHSV(RGBtoHSV(material.color))[3] // patened formula based on color's Value (in HSV)
		shine = Clamp((material.reflectiveness * 0.01) * 255, 10, max_shine)

	var/image/I
	color = null

	if(sloped)
		decals = null
		. = ..() // Draw the floor under us.
		// Not sure how to interpret the connections list :(
		var/turf/exterior/wall/neighbor = get_step(src, turn(sloped, -90))
		var/has_left_neighbor = istype(neighbor) && neighbor.sloped == sloped
		neighbor = get_step(src, turn(sloped, 90))
		var/has_right_neighbor = istype(neighbor) && neighbor.sloped == sloped

		var/state = "ramp-single"
		if(has_left_neighbor && has_right_neighbor)
			state = "ramp-blend-full"
		else if(has_left_neighbor)
			state = "ramp-blend-left"
		else if(has_right_neighbor)
			state = "ramp-blend-right"
		I = image(material_icon_base, state, dir = sloped)
		I.color = base_color
		add_overlay(I)
		if(shine)
			I = image(material_icon_base, "[state]-shine", dir = sloped)
			I.appearance_flags |= RESET_ALPHA
			I.alpha = shine
			add_overlay(I)
	else
		cut_overlays()
		for(var/i = 1 to 4)
			var/apply_state = "[wall_connections[i]]"
			I = image(material_icon_base, apply_state, dir = 1<<(i-1))
			I.color = base_color
			add_overlay(I)
			if(shine)
				I = image(material_icon_base, "shine[wall_connections[i]]", dir = 1<<(i-1))
				I.appearance_flags |= RESET_ALPHA
				I.alpha = shine
				add_overlay(I)

	if(ore_overlay)
		add_overlay(ore_overlay)
	if(excav_overlay)
		add_overlay(excav_overlay)
	if(archaeo_overlay)
		add_overlay(archaeo_overlay)

/turf/exterior/wall/proc/drop_ore()
	if(reinf_material?.ore_result_amount)
		for(var/i = 1 to reinf_material.ore_result_amount)
			pass_geodata_to(new /obj/item/ore(src, reinf_material.type))
		reinf_material = null
		ore_overlay = null
		update_material(FALSE)
	if(prob(MAT_DROP_CHANCE) && !sloped && material)
		pass_geodata_to(new /obj/item/ore(src, material.type))

/turf/exterior/wall/proc/dismantle_wall()
	drop_ore()
	destroy_artifacts(null, INFINITY)
	playsound(src, 'sound/items/Welder.ogg', 100, 1)	
	var/turf/new_turf = ChangeTurf(floor_type || get_base_turf_by_area(src))
	for(var/turf/exterior/wall/neighbor in RANGE_TURFS(new_turf, 1))
		if(neighbor != new_turf && neighbor.sloped && get_dir(neighbor, src) != neighbor.sloped)
			neighbor.dismantle_wall()
	if(istype(new_turf, /turf/simulated/floor/asteroid))
		var/turf/simulated/floor/asteroid/debris = .
		debris.overlay_detail = "asteroid[rand(0,9)]"
		debris.updateMineralOverlays(1)
	return new_turf

/turf/exterior/wall/proc/get_default_material()
	. = /decl/material/solid/stone/sandstone

/turf/exterior/wall/proc/pass_geodata_to(obj/O)
	var/datum/extension/geological_data/ours = get_extension(src, /datum/extension/geological_data)
	ours.geodata.UpdateNearbyArtifactInfo(src)
	set_extension(O, /datum/extension/geological_data)
	var/datum/extension/geological_data/newdata = get_extension(O, /datum/extension/geological_data)
	newdata.set_data(ours.geodata.get_copy())

/turf/exterior/wall/Bumped(var/atom/movable/AM)
	. = ..()
	if(!. && !sloped && ismob(AM))
		var/mob/M = AM
		var/obj/item/pickaxe/held = M.get_active_hand()
		if(istype(held))
			attackby(held, M)
			return TRUE

#undef MAT_DROP_CHANCE