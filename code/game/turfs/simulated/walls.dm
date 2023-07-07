var/global/list/wall_blend_objects = list(
	/obj/machinery/door,
	/obj/structure/wall_frame,
	/obj/structure/grille,
	/obj/structure/window/reinforced/full,
	/obj/structure/window/reinforced/polarized/full,
	/obj/structure/window/shuttle,
	/obj/structure/window/borosilicate/full,
	/obj/structure/window/borosilicate_reinforced/full
)
var/global/list/wall_noblend_objects = list(
	/obj/machinery/door/window
)
var/global/list/wall_fullblend_objects = list(
	/obj/structure/wall_frame
)

/turf/simulated/wall
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	icon = 'icons/turf/walls/_previews.dmi'
	icon_state = "solid"
	opacity = 1
	density = 1
	blocks_air = 1
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall
	explosion_resistance = 10
	color = COLOR_STEEL
	atom_flags = ATOM_FLAG_CAN_BE_PAINTED
	turf_flags = TURF_IS_HOLOMAP_OBSTACLE

	var/damage = 0
	var/can_open = 0
	var/decl/material/material
	var/decl/material/reinf_material
	var/decl/material/girder_material = /decl/material/solid/metal/steel
	var/construction_stage
	var/hitsound = 'sound/weapons/Genhit.ogg'
	var/list/wall_connections
	var/list/other_connections
	var/floor_type = /turf/simulated/floor/plating //turf it leaves after destruction
	var/paint_color
	var/stripe_color
	var/handle_structure_blending = TRUE

/turf/simulated/wall/Initialize(var/ml, var/materialtype, var/rmaterialtype)

	..(ml)

	// Clear mapping icons.
	icon = 'icons/turf/walls/solid.dmi'
	icon_state = "blank"
	color = null

	if(!ispath(material, /decl/material))
		material = materialtype || get_default_material()
	if(ispath(material, /decl/material))
		material = GET_DECL(material)

	if(!ispath(reinf_material, /decl/material))
		reinf_material = rmaterialtype
	if(ispath(reinf_material, /decl/material))
		reinf_material = GET_DECL(reinf_material)

	if(ispath(girder_material, /decl/material))
		girder_material = GET_DECL(girder_material)

	. = INITIALIZE_HINT_LATELOAD
	set_extension(src, /datum/extension/penetration/proc_call, .proc/CheckPenetration)
	START_PROCESSING(SSturf, src) //Used for radiation.

/turf/simulated/wall/LateInitialize(var/ml)
	..()
	update_material(!ml)

/turf/simulated/wall/Destroy()
	STOP_PROCESSING(SSturf, src)
	material = GET_DECL(/decl/material/placeholder)
	reinf_material = null
	var/old_x = x
	var/old_y = y
	var/old_z = z
	. = ..()
	var/turf/debris = locate(old_x, old_y, old_z)
	if(debris)
		for(var/turf/simulated/wall/W in RANGE_TURFS(debris, 1))
			W.wall_connections = null
			W.other_connections = null
			W.queue_icon_update()

// Walls always hide the stuff below them.
/turf/simulated/wall/levelupdate()
	for(var/obj/O in src)
		O.hide(1)

/turf/simulated/wall/protects_atom(var/atom/A)
	var/obj/O = A
	return (istype(O) && O.hides_under_flooring()) || ..()

/turf/simulated/wall/Process(wait, tick)
	var/how_often = max(round(2 SECONDS/wait), 1)
	if(tick % how_often)
		return //We only work about every 2 seconds
	if(!radiate())
		return PROCESS_KILL

/turf/simulated/wall/proc/get_material()
	return material

/turf/simulated/wall/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj,/obj/item/projectile/beam))
		burn(2500)
	else if(istype(Proj,/obj/item/projectile/ion))
		burn(500)

	var/proj_damage = Proj.get_structure_damage()

	if(Proj.ricochet_sounds && prob(15))
		playsound(src, pick(Proj.ricochet_sounds), 100, 1)

	if(reinf_material)
		if(Proj.damage_type == BURN)
			proj_damage /= reinf_material.burn_armor
		else if(Proj.damage_type == BRUTE)
			proj_damage /= reinf_material.brute_armor

	//cap the amount of damage, so that things like emitters can't destroy walls in one hit.
	var/damage = min(proj_damage, 100)

	take_damage(damage)

/turf/simulated/wall/hitby(AM, var/datum/thrownthing/TT)
	..()
	if(density && !ismob(AM))
		var/obj/O = AM
		var/tforce = O.throwforce * (TT.speed/THROWFORCE_SPEED_DIVISOR)
		playsound(src, hitsound, tforce >= 15 ? 60 : 25, TRUE)
		if(tforce > 0)
			take_damage(tforce)

/turf/simulated/wall/proc/clear_plants()
	for(var/obj/effect/overlay/wallrot/WR in src)
		qdel(WR)
	for(var/obj/effect/vine/plant in range(src, 1))
		if(!plant.floor) //shrooms drop to the floor
			plant.floor = 1
			plant.update_icon()
			plant.reset_offsets(0)

/turf/simulated/wall/ChangeTurf(var/turf/N, var/tell_universe = TRUE, var/force_lighting_update = FALSE, var/keep_air = FALSE)
	clear_plants()
	. = ..()

//Appearance
/turf/simulated/wall/examine(mob/user)
	. = ..()

	if(!damage)
		to_chat(user, "<span class='notice'>It looks fully intact.</span>")
	else
		var/dam = damage / material.integrity
		if(dam <= 0.3)
			to_chat(user, "<span class='warning'>It looks slightly damaged.</span>")
		else if(dam <= 0.6)
			to_chat(user, "<span class='warning'>It looks moderately damaged.</span>")
		else
			to_chat(user, "<span class='danger'>It looks heavily damaged.</span>")
	if(paint_color)
		to_chat(user, get_paint_examine_message())
	if(locate(/obj/effect/overlay/wallrot) in src)
		to_chat(user, "<span class='warning'>There is fungus growing on [src].</span>")

/turf/simulated/wall/proc/get_paint_examine_message()
	. = SPAN_NOTICE("It has had <font color = '[paint_color]'>a coat of paint</font> applied.")

//Damage
/turf/simulated/wall/melt()
	if(can_melt())
		var/turf/simulated/floor/F = ChangeTurf(/turf/simulated/floor/plating)
		if(istype(F))
			F.burn_tile()
			F.icon_state = "wall_thermite"
			visible_message(SPAN_DANGER("\The [src] spontaneously combusts!"))

/turf/simulated/wall/proc/take_damage(dam)
	if(dam)
		damage = max(0, damage + dam)
		update_damage()

/turf/simulated/wall/proc/update_damage()
	var/cap = material.integrity
	if(reinf_material)
		cap += reinf_material.integrity

	if(locate(/obj/effect/overlay/wallrot) in src)
		cap = cap / 10

	if(damage >= cap)
		dismantle_wall(1)
	else
		update_icon()

	return

/turf/simulated/wall/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)//Doesn't fucking work because walls don't interact with air :(
	burn(exposed_temperature)

/turf/simulated/wall/adjacent_fire_act(turf/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	burn(adj_temp)
	if(adj_temp > material.melting_point)
		take_damage(log(RAND_F(0.9, 1.1) * (adj_temp - material.melting_point)))
	return ..()

/turf/simulated/wall/proc/dismantle_wall(var/devastated, var/explode, var/no_product)

	playsound(src, 'sound/items/Welder.ogg', 100, 1)
	if(!no_product)
		var/list/obj/structure/girder/placed_girders
		if(girder_material)
			placed_girders = girder_material.place_dismantled_girder(src, reinf_material)
			material.place_dismantled_product(src,devastated)
		else
			placed_girders = material.place_dismantled_girder(src, reinf_material)
		for(var/obj/structure/girder/placed_girder in placed_girders)
			placed_girder.anchored = TRUE
			placed_girder.prepped_for_fakewall = can_open
			placed_girder.update_icon()

	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O,/obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.dismantle()
		else
			O.forceMove(src)
	clear_plants()
	. = ChangeTurf(floor_type || get_base_turf_by_area(src))

/turf/simulated/wall/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	if(severity == 1)
		dismantle_wall(1,1,1)
	else if(severity == 2)
		if(prob(75))
			take_damage(rand(150, 250))
		else
			dismantle_wall(1,1)
	else if(severity == 3)
		take_damage(rand(0, 250))

// Wall-rot effect, a nasty fungus that destroys walls.
/turf/simulated/wall/proc/rot()
	if(locate(/obj/effect/overlay/wallrot) in src)
		return
	var/number_rots = rand(2,3)
	for(var/i=0, i<number_rots, i++)
		new/obj/effect/overlay/wallrot(src)

/turf/simulated/wall/proc/can_melt()
	if(material.flags & MAT_FLAG_UNMELTABLE)
		return 0
	return 1

/turf/simulated/wall/proc/radiate()
	var/total_radiation = material.radioactivity + (reinf_material ? reinf_material.radioactivity / 2 : 0)
	if(!total_radiation)
		return

	SSradiation.radiate(src, total_radiation)
	return total_radiation

/turf/simulated/wall/proc/burn(temperature)
	if(!QDELETED(src) && istype(material) && material.combustion_effect(src, temperature, 0.7))
		for(var/turf/simulated/wall/W in range(3,src))
			if(W != src)
				addtimer(CALLBACK(W, /turf/simulated/wall/proc/burn, temperature/4), 2)
		dismantle_wall(TRUE)

/turf/simulated/wall/get_color()
	return paint_color

/turf/simulated/wall/set_color(new_color)
	paint_color = new_color
	update_icon()

/turf/simulated/wall/proc/CheckPenetration(var/base_chance, var/damage)
	return round(damage/material.integrity*180)

/turf/simulated/wall/can_engrave()
	return (material && material.hardness >= 10 && material.hardness <= 100)

/turf/simulated/wall/is_wall()
	return TRUE

/turf/simulated/wall/on_defilement()
	var/new_material
	if(material?.type != /decl/material/solid/stone/cult)
		new_material = /decl/material/solid/stone/cult
	var/new_rmaterial
	if(reinf_material && reinf_material.type != /decl/material/solid/stone/cult/reinforced)
		new_rmaterial = /decl/material/solid/stone/cult/reinforced
	if(new_material || new_rmaterial)
		..()
		set_material(new_material, new_rmaterial)

/turf/simulated/wall/is_defiled()
	return material?.type == /decl/material/solid/stone/cult || reinf_material?.type == /decl/material/solid/stone/cult/reinforced || ..()
