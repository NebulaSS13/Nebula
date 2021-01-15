var/list/default_strata_type_by_z = list()
var/list/default_material_by_strata_and_z = list()
var/list/default_strata_types = list()
var/list/natural_walls = list()

/turf/simulated/wall/natural
	name = "wall"
	material = null
	reinf_material = null
	girder_material = null
	construction_stage = -1
	floor_type = /turf/exterior/barren
	icon_state = "natural"
	handle_structure_blending = FALSE
	var/strata
	var/image/ore_overlay

/turf/simulated/wall/natural/get_paint_examine_message()
	. = SPAN_NOTICE("It has been <font color = '[paint_color]'>noticeably discoloured</font> by the elements.")

/turf/simulated/wall/natural/proc/set_strata_material()

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
		var/decl/strata/strata_info = decls_repository.get_decl(strata)
		if(length(strata_info.base_materials))
			global.default_material_by_strata_and_z[skey] = pick(strata_info.base_materials)
	material = global.default_material_by_strata_and_z[skey]

/turf/simulated/wall/natural/Initialize()
	set_strata_material()
	. = ..()
	global.natural_walls += src
	set_extension(src, /datum/extension/geological_data)

/turf/simulated/wall/natural/LateInitialize()
	..()
	spread_deposit()

/turf/simulated/wall/natural/Destroy()
	global.natural_walls -= src
	. = ..()

/turf/simulated/wall/natural/proc/spread_deposit()
	if(!istype(reinf_material) || reinf_material.ore_spread_chance <= 0)
		return
	for(var/trydir in GLOB.cardinal)
		if(!prob(reinf_material.ore_spread_chance))
			continue
		var/turf/simulated/wall/natural/target_turf = get_step(src, trydir)
		if(!istype(target_turf) || !isnull(target_turf.reinf_material))
			continue
		target_turf.set_material(target_turf.material, reinf_material)
		target_turf.spread_deposit()

/turf/simulated/wall/natural/attackby(obj/item/W, mob/user, click_params)

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

	// Do not allow repairing of natural walls.
	if(!damage || !istype(W, /obj/item/weldingtool))
		. = ..()
	
/turf/simulated/wall/natural/update_strings()
	if(reinf_material)
		SetName("[reinf_material.solid_name] deposit")
		desc = "A natural cliff face composed of bare [material.solid_name] and a deposit of [reinf_material.solid_name]."
	else
		SetName("natural [material.solid_name] wall")
		desc = "A natural cliff face composed of bare [material.solid_name]."

/turf/simulated/wall/natural/update_material()
	. = ..()
	girder_material = null
	if(reinf_material?.ore_icon_overlay)
		ore_overlay = image('icons/turf/mining_decals.dmi', "[reinf_material.ore_icon_overlay]")
		ore_overlay.appearance_flags = RESET_COLOR
		if(prob(50))
			var/matrix/M = matrix()
			M.Scale(-1,1)
			ore_overlay.transform = M
		ore_overlay.color = reinf_material.color
		ore_overlay.layer = DECAL_LAYER

/turf/simulated/wall/natural/on_update_icon()
	. = ..()
	if(wall_connections && material?.reflectiveness > 0)
		var/max_shine = 0.6 * ReadHSV(RGBtoHSV(material.color))[3] // patened formula based on color's Value (in HSV)
		var/shine = Clamp((material.reflectiveness * 0.01) * 255, 10, max_shine)
		for(var/i = 1 to 4)
			var/image/I = image(get_wall_icon(), "shine[wall_connections[i]]", dir = 1<<(i-1))
			I.appearance_flags |= RESET_ALPHA
			I.alpha = shine
			add_overlay(I)
	if(ore_overlay)
		add_overlay(ore_overlay)
	if(excav_overlay)
		add_overlay(excav_overlay)
	if(archaeo_overlay)
		add_overlay(archaeo_overlay)

/turf/simulated/wall/natural/dismantle_wall(var/devastated, var/explode, var/no_product)
	if(reinf_material?.ore_result_amount)
		for(var/i = 1 to reinf_material.ore_result_amount)
			pass_geodata_to(new /obj/item/ore(src, reinf_material.type))
	destroy_artifacts(null, INFINITY)
	. = ..(no_product = TRUE)
	if(istype(., /turf/simulated/floor/asteroid))
		var/turf/simulated/floor/asteroid/debris = .
		debris.overlay_detail = "asteroid[rand(0,9)]"
		debris.updateMineralOverlays(1)

/turf/simulated/wall/natural/get_wall_icon()
	. = material.icon_base_natural || 'icons/turf/walls/natural.dmi'

/turf/simulated/wall/natural/get_default_material()
	. = /decl/material/solid/stone/sandstone

/turf/simulated/wall/natural/apply_reinf_overlay()
	. = FALSE

/turf/simulated/wall/natural/can_join_with(var/turf/simulated/wall/W)
	. = (istype(W, /turf/simulated/wall/natural) && W.material?.type != /decl/material/placeholder && material?.type != /decl/material/placeholder)

/turf/simulated/wall/natural/Bumped(AM)
	. = ..()
	if(ismob(AM))
		var/mob/M = AM
		var/obj/item/pickaxe/held = M.get_active_hand()
		if(istype(held))
			attackby(held, M)

/turf/simulated/wall/natural/proc/pass_geodata_to(obj/O)
	var/datum/extension/geological_data/ours = get_extension(src, /datum/extension/geological_data)
	ours.geodata.UpdateNearbyArtifactInfo(src)
	set_extension(O, /datum/extension/geological_data)
	var/datum/extension/geological_data/newdata = get_extension(O, /datum/extension/geological_data)
	newdata.set_data(ours.geodata.get_copy())