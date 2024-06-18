/turf/wall/natural
	icon_state         = "natural"
	desc               = "A rough natural wall."
	turf_flags         = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_OBSTACLE
	girder_material    = null
	floor_type         = /turf/floor/natural/barren
	construction_stage = -1
	var/strata_override
	var/ramp_slope_direction
	var/image/ore_overlay
	var/static/list/exterior_wall_shine_cache = list()
	var/being_mined = FALSE

/turf/wall/natural/flooded
	flooded = /decl/material/liquid/water
	color = COLOR_LIQUID_WATER

/turf/wall/natural/get_paint_examine_message()
	return SPAN_NOTICE("It has been <font color = '[paint_color]'>noticeably discoloured</font> by the elements.")

/turf/wall/natural/get_wall_icon()
	return 'icons/turf/walls/natural.dmi'

/turf/wall/natural/Initialize(var/ml, var/materialtype, var/rmaterialtype)
	. = ..()
	var/area/A = get_area(src)
	if(A.allow_xenoarchaeology_finds)
		if(!SSxenoarch.initialized)
			SSxenoarch.possible_spawn_walls += src
		set_extension(src, /datum/extension/geological_data)
	// Init ramp state if needed.
	if(ramp_slope_direction)
		make_ramp(null, ramp_slope_direction, TRUE)

/turf/wall/natural/LateInitialize(var/ml)
	//Set the rock color
	if(!paint_color)
		paint_color = SSmaterials.get_rock_color(src)
	..()
	spread_deposit()
	if(!ramp_slope_direction && floor_type && HasAbove(z))
		var/turf/T = GetAbove(src)
		if(!istype(T, floor_type) && T.is_open())
			T.ChangeTurf(floor_type, keep_air = TRUE)

/turf/wall/natural/Destroy()
	SSxenoarch.digsite_spawning_turfs -= src
	if(!ramp_slope_direction)
		update_neighboring_ramps(destroying_self = TRUE)
	. = ..()

/turf/wall/natural/attackby(obj/item/W, mob/user, click_params)

	if(user.check_dexterity(DEXTERITY_COMPLEX_TOOLS) && !ramp_slope_direction)

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

	. = ..()

// Drill out natural walls.
/turf/wall/natural/handle_wall_tool_interactions(obj/item/W, mob/user)
	if(IS_PICK(W) && !being_mined)
		var/check_material_hardness
		if(material)
			check_material_hardness = material.hardness
		if(reinf_material && (isnull(check_material_hardness) || check_material_hardness > reinf_material.hardness))
			check_material_hardness = reinf_material.hardness
		if(isnull(check_material_hardness) || W.material?.hardness < check_material_hardness)
			to_chat(user, SPAN_WARNING("\The [W] is not hard enough to dig through \the [src]."))
			return TRUE
		if(being_mined)
			return TRUE
		being_mined = TRUE
		if(W.do_tool_interaction(TOOL_PICK, user, src, 2 SECONDS, suffix_message = destroy_artifacts(W, INFINITY)))
			dismantle_turf()
		if(istype(src, /turf/wall/natural)) // dismantle_turf() can change our type
			being_mined = FALSE
		return TRUE
	return FALSE

/turf/wall/natural/update_strings()
	if(reinf_material)
		SetName("[reinf_material.solid_name] deposit")
		desc = "A natural cliff face composed of bare [material.solid_name] and a deposit of [reinf_material.solid_name]."
	else
		SetName("natural [material.solid_name] wall")
		desc = "A natural cliff face composed of bare [material.solid_name]."

/turf/wall/natural/update_material(var/update_neighbors)
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
	. = ..()

/turf/wall/natural/drop_dismantled_products(devastated, explode)
	drop_ore()

/turf/wall/natural/get_dismantle_sound()
	return 'sound/effects/rockcrumble.ogg'

// Natural walls are typically dense, and should not contain any air a-la normal walls, so we set keep_air = FALSE by default.
/turf/wall/natural/dismantle_turf(devastated, explode, no_product, keep_air = FALSE, ramp_update = TRUE)
	destroy_artifacts(null, INFINITY)
	if(ramp_update && !ramp_slope_direction)
		ramp_slope_direction = NORTH // Temporary so we don't let any neighboring ramps use us as supports.
		update_neighboring_ramps()
		ramp_slope_direction = null
	return ..(devastated, explode, no_product, keep_air)

/turf/wall/natural/Bumped(var/atom/movable/AM)
	. = ..()
	if(!. && !ramp_slope_direction && ismob(AM))
		var/mob/M = AM
		var/obj/item/held = M.get_active_held_item()
		if(IS_PICK(held))
			attackby(held, M)
			return TRUE

/turf/wall/natural/proc/drop_ore()
	if(reinf_material?.ore_result_amount)
		var/drop_type = reinf_material.ore_type || /obj/item/stack/material/ore
		pass_geodata_to(new drop_type(src, reinf_material.ore_result_amount, reinf_material.type))
		reinf_material = null
		ore_overlay = null
		update_material(FALSE)
	if(prob(30) && !ramp_slope_direction && material)
		var/drop_type = material.ore_type || /obj/item/stack/material/ore
		pass_geodata_to(new drop_type(src, material.ore_result_amount, material.type))

/turf/wall/natural/proc/pass_geodata_to(obj/O)
	var/datum/extension/geological_data/ours = get_extension(src, /datum/extension/geological_data)
	if(ours?.geodata)
		ours.geodata.UpdateNearbyArtifactInfo(src)
		set_extension(O, /datum/extension/geological_data)
		var/datum/extension/geological_data/newdata = get_extension(O, /datum/extension/geological_data)
		if(newdata)
			newdata.set_data(ours.geodata.get_copy())

/turf/wall/natural/proc/spread_deposit()
	if(!istype(reinf_material) || reinf_material.ore_spread_chance <= 0)
		return
	for(var/trydir in global.cardinal)
		if(!prob(reinf_material.ore_spread_chance))
			continue
		var/turf/wall/natural/target_turf = get_step_resolving_mimic(src, trydir)
		if(!istype(target_turf) || !isnull(target_turf.reinf_material))
			continue
		target_turf.set_turf_materials(target_turf.material, reinf_material)
		target_turf.spread_deposit()

/turf/wall/natural/get_default_material()
	. = GET_DECL(get_strata_material_type() || /decl/material/solid/stone/sandstone)

/turf/wall/natural/get_strata_material_type()
	//Turf strata overrides level strata
	if(ispath(strata_override, /decl/strata))
		var/decl/strata/S = GET_DECL(strata_override)
		if(length(S.base_materials))
			return pick(S.base_materials)
	//Otherwise, just use level strata
	return ..()