var/list/default_strata_type_by_z = list()
var/list/default_material_by_strata_and_z = list()
var/list/default_strata_types = list()
var/list/natural_walls = list()

/turf/exterior/wall
	name = "wall"
	icon = 'icons/turf/walls/_previews.dmi'
	icon_state = "natural"
	density =    TRUE
	opacity =    TRUE
	density =    TRUE
	blocks_air = TRUE
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

/turf/exterior/wall/proc/set_strata_material()
	if(material)
		return
	if(!strata)
		if(!global.default_strata_type_by_z["[z]"])
			if(!length(global.default_strata_types))
				var/list/strata_types = decls_repository.get_decls_of_subtype(/decl/strata)
				for(var/stype in strata_types)
					var/decl/strata/check_strata = strata_types[stype]
					if(check_strata.default_strata_candidate)
						global.default_strata_types += stype
			global.default_strata_type_by_z["[z]"] = pick(global.default_strata_types)
		strata = global.default_strata_type_by_z["[z]"]
	var/skey = "[strata]-[z]"
	if(!global.default_material_by_strata_and_z[skey])
		var/decl/strata/strata_info = GET_DECL(strata)
		if(length(strata_info.base_materials))
			global.default_material_by_strata_and_z[skey] = pick(strata_info.base_materials)
	material = global.default_material_by_strata_and_z[skey]

/turf/exterior/wall/Initialize(var/ml, var/materialtype, var/rmaterialtype)

	..(ml)

	// Clear mapping icons.
	icon = 'icons/turf/walls/solid.dmi'
	icon_state = "blank"
	color = null

	// Init materials.
	set_strata_material()
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
	. = INITIALIZE_HINT_LATELOAD

/turf/exterior/wall/LateInitialize()
	..()
	update_material()
	spread_deposit()

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
	for(var/trydir in GLOB.cardinal)
		if(!prob(reinf_material.ore_spread_chance))
			continue
		var/turf/exterior/wall/target_turf = get_step(src, trydir)
		if(!istype(target_turf) || !isnull(target_turf.reinf_material))
			continue
		target_turf.set_material(target_turf.material, reinf_material)
		target_turf.spread_deposit()

/turf/exterior/wall/attackby(obj/item/W, mob/user, click_params)

	if(!user.check_dexterity(DEXTERITY_COMPLEX_TOOLS))
		return

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
		if(do_after(user, P.digspeed, src))		
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

/turf/exterior/wall/proc/update_material()
	if(!material)
		material = GET_DECL(get_default_material())
	if(material)
		explosion_resistance = material.explosion_resistance
	if(reinf_material && reinf_material.explosion_resistance > explosion_resistance)
		explosion_resistance = reinf_material.explosion_resistance
	update_strings()
	set_opacity(material.opacity >= 0.5)
	for(var/turf/exterior/T in RANGE_TURFS(src, 1))
		T.queue_icon_update()
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

/turf/exterior/wall/on_update_icon()

	cut_overlays()

	if(!istype(material))
		return

	var/list/wall_connections = list()
	for(var/stepdir in GLOB.alldirs)
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
	for(var/i = 1 to 4)
		var/apply_state = "[wall_connections[i]]"
		if(check_state_in_icon(apply_state, material_icon_base))
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

/turf/exterior/wall/proc/dismantle_wall()
	if(reinf_material?.ore_result_amount)
		for(var/i = 1 to reinf_material.ore_result_amount)
			pass_geodata_to(new /obj/item/ore(src, reinf_material.type))
	destroy_artifacts(null, INFINITY)
	playsound(src, 'sound/items/Welder.ogg', 100, 1)
	. = ChangeTurf(floor_type || get_base_turf_by_area(src))
	if(istype(., /turf/simulated/floor/asteroid))
		var/turf/simulated/floor/asteroid/debris = .
		debris.overlay_detail = "asteroid[rand(0,9)]"
		debris.updateMineralOverlays(1)

/turf/exterior/wall/proc/get_default_material()
	. = /decl/material/solid/stone/sandstone

/turf/exterior/wall/Bumped(AM)
	. = ..()
	if(ismob(AM))
		var/mob/M = AM
		var/obj/item/pickaxe/held = M.get_active_hand()
		if(istype(held))
			attackby(held, M)

/turf/exterior/wall/proc/pass_geodata_to(obj/O)
	var/datum/extension/geological_data/ours = get_extension(src, /datum/extension/geological_data)
	ours.geodata.UpdateNearbyArtifactInfo(src)
	set_extension(O, /datum/extension/geological_data)
	var/datum/extension/geological_data/newdata = get_extension(O, /datum/extension/geological_data)
	newdata.set_data(ours.geodata.get_copy())