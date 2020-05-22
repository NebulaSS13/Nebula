var/list/natural_walls = list()
/turf/simulated/wall/natural
	name = "wall"
	material = MAT_SANDSTONE
	reinf_material = null
	girder_material = null
	construction_stage = -1
	floor_type = /turf/simulated/floor/asteroid
	var/image/ore_overlay

/turf/simulated/wall/natural/Initialize(ml, materialtype, rmaterialtype)
	global.natural_walls += src
	..(ml, materialtype || material, rmaterialtype || reinf_material)
	set_extension(src, /datum/extension/geological_data)
	. = INITIALIZE_HINT_LATELOAD

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
		to_chat(user, SPAN_NOTICE("You start [P.drill_verb]."))
		if(do_after(user, P.digspeed, src))		
			to_chat(user, SPAN_NOTICE("You finish [P.drill_verb] \the [src]."))
			destroy_artifacts(W, user)
			dismantle_wall()
		return TRUE

	// Do not allow repairing of natural walls.
	if(!damage || !istype(W, /obj/item/weldingtool))
		. = ..()
	
/turf/simulated/wall/natural/update_strings()
	if(reinf_material)
		SetName("[reinf_material.display_name] deposit")
		desc = "A natural cliff face composed of bare [material.display_name] and a deposit of [reinf_material.display_name]."
	else
		SetName("natural [material.display_name] wall")
		desc = "A natural cliff face composed of bare [material.display_name]."

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
		ore_overlay.color = reinf_material.icon_colour
		ore_overlay.turf_decal_layerise()

/turf/simulated/wall/natural/on_update_icon()
	. = ..()
	if(ore_overlay)
		overlays += ore_overlay
	if(excav_overlay)
		overlays += excav_overlay
	if(archaeo_overlay)
		overlays += archaeo_overlay

/turf/simulated/wall/natural/dismantle_wall(var/devastated, var/explode, var/no_product)

	if(reinf_material?.ore_result_amount)
		for(var/i = 1 to reinf_material.ore_result_amount)
			pass_geodata_to(new /obj/item/ore(src, reinf_material.type))

	// drop rubble
	clear_plants()
	material = SSmaterials.get_material_datum(MAT_PLACEHOLDER)
	reinf_material = null
	update_connections(1)

	var/turf/simulated/floor/asteroid/debris = ChangeTurf(floor_type || get_base_turf_by_area(src))
	if(istype(debris))
		debris.overlay_detail = "asteroid[rand(0,9)]"
		debris.updateMineralOverlays(1)

/turf/simulated/wall/natural/get_wall_state()
	. = "rock"

/turf/simulated/wall/natural/get_default_material()
	. = MAT_SANDSTONE

/turf/simulated/wall/natural/apply_reinf_overlay()
	. = FALSE

/turf/simulated/wall/natural/can_join_with(var/turf/simulated/wall/W)
	. = istype(W, /turf/simulated/wall/natural)

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