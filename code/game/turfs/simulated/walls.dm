/turf/simulated/wall
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	icon = 'icons/turf/wall_masks.dmi'
	icon_state = "generic"
	opacity = 1
	density = 1
	blocks_air = 1
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall
	explosion_resistance = 10

	var/damage = 0
	var/damage_overlay = 0
	var/global/damage_overlays[16]
	var/active
	var/can_open = 0
	var/material/material
	var/material/reinf_material
	var/material/girder_material = MAT_STEEL
	var/last_state
	var/construction_stage
	var/hitsound = 'sound/weapons/Genhit.ogg'
	var/list/wall_connections = list("0", "0", "0", "0")
	var/list/other_connections = list("0", "0", "0", "0")
	var/floor_type = /turf/simulated/floor/plating //turf it leaves after destruction
	var/paint_color
	var/stripe_color
	var/global/list/wall_stripe_cache = list()
	var/list/blend_turfs = list(/turf/simulated/wall/cult, /turf/simulated/wall/wood, /turf/simulated/wall/walnut, /turf/simulated/wall/maple, /turf/simulated/wall/mahogany, /turf/simulated/wall/ebony)
	var/list/blend_objects = list(/obj/machinery/door, /obj/structure/wall_frame, /obj/structure/grille, /obj/structure/window/reinforced/full, /obj/structure/window/reinforced/polarized/full, /obj/structure/window/shuttle, ,/obj/structure/window/phoronbasic/full, /obj/structure/window/phoronreinforced/full) // Objects which to blend with
	var/list/noblend_objects = list(/obj/machinery/door/window) //Objects to avoid blending with (such as children of listed blend objects.

/turf/simulated/wall/Initialize(var/ml, var/materialtype, var/rmaterialtype)
	. = ..(ml)
	icon_state = "blank"
	if(!materialtype)
		materialtype = DEFAULT_WALL_MATERIAL
	material = SSmaterials.get_material_datum(materialtype)
	if(!isnull(rmaterialtype))
		reinf_material = SSmaterials.get_material_datum(rmaterialtype)
	if(ispath(girder_material, /material))
		girder_material = SSmaterials.get_material_datum(girder_material)
	update_material()
	hitsound = material.hitsound

	set_extension(src, /datum/extension/penetration/proc_call, .proc/CheckPenetration)
	START_PROCESSING(SSturf, src) //Used for radiation.

/turf/simulated/wall/Destroy()
	STOP_PROCESSING(SSturf, src)
	. = ..()

// Walls always hide the stuff below them.
/turf/simulated/wall/levelupdate()
	for(var/obj/O in src)
		O.hide(1)

/turf/simulated/wall/protects_atom(var/atom/A)
	var/obj/O = A
	return (istype(O) && O.hides_under_flooring()) || ..()

/turf/simulated/wall/Process(wait, times_fired)
	var/how_often = max(round(2 SECONDS/wait), 1)
	if(times_fired % how_often)
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
	return

/turf/simulated/wall/hitby(AM, var/datum/thrownthing/TT)
	if(!ismob(AM))
		var/obj/O = AM
		var/tforce = O.throwforce * (TT.speed/THROWFORCE_SPEED_DIVISOR)
		playsound(src, hitsound, tforce >= 15? 60 : 25, TRUE)
		if (tforce >= 15)
			take_damage(tforce)
	..()

/turf/simulated/wall/proc/clear_plants()
	for(var/obj/effect/overlay/wallrot/WR in src)
		qdel(WR)
	for(var/obj/effect/vine/plant in range(src, 1))
		if(!plant.floor) //shrooms drop to the floor
			plant.floor = 1
			plant.update_icon()
			plant.pixel_x = 0
			plant.pixel_y = 0

/turf/simulated/wall/ChangeTurf(var/newtype)
	clear_plants()
	return ..(newtype)

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
		to_chat(user, "<span class='notice'>It has a coat of paint applied.</span>")
	if(locate(/obj/effect/overlay/wallrot) in src)
		to_chat(user, "<span class='warning'>There is fungus growing on [src].</span>")

//Damage

/turf/simulated/wall/melt()
	if(can_melt())
		var/turf/simulated/floor/F = ChangeTurf(/turf/simulated/floor/plating)
		if(istype(F))
			F.burn_tile()
			F.icon_state = "wall_thermite"
			visible_message(SPAN_DANGER("\The [src] spontaneously combusts!"))

/turf/simulated/wall/proc/take_damage(dam)
	if(isProtected())
		return
	if(dam)
		damage = max(0, damage + dam)
		update_damage()

/turf/simulated/wall/proc/update_damage()
	if(isProtected())
		return
	var/cap = material.integrity
	if(reinf_material)
		cap += reinf_material.integrity

	if(locate(/obj/effect/overlay/wallrot) in src)
		cap = cap / 10

	if(damage >= cap)
		dismantle_wall()
	else
		update_icon()

	return

/turf/simulated/wall/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)//Doesn't fucking work because walls don't interact with air :(
	burn(exposed_temperature)

/turf/simulated/wall/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	burn(adj_temp)
	if(adj_temp > material.melting_point)
		take_damage(log(RAND_F(0.9, 1.1) * (adj_temp - material.melting_point)))

	return ..()

/turf/simulated/wall/proc/dismantle_wall(var/devastated, var/explode, var/no_product)

	playsound(src, 'sound/items/Welder.ogg', 100, 1)
	if(!no_product)
		if(girder_material)
			girder_material.place_dismantled_girder(src, reinf_material)
			material.place_dismantled_product(src,devastated)
		else
			material.place_dismantled_girder(src, reinf_material)

	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O,/obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)
		else
			O.forceMove(src)

	clear_plants()
	material = SSmaterials.get_material_datum(MAT_PLACEHOLDER)
	reinf_material = null
	update_connections(1)

	ChangeTurf(floor_type || get_base_turf_by_area(src))

/turf/simulated/wall/ex_act(severity)
	switch(severity)
		if(1.0)
			src.ChangeTurf(get_base_turf(src.z))
			return
		if(2.0)
			if(prob(75))
				take_damage(rand(150, 250))
			else
				dismantle_wall(1,1)
		if(3.0)
			take_damage(rand(0, 250))
		else
	return

// Wall-rot effect, a nasty fungus that destroys walls.
/turf/simulated/wall/proc/rot()
	if(locate(/obj/effect/overlay/wallrot) in src)
		return
	var/number_rots = rand(2,3)
	for(var/i=0, i<number_rots, i++)
		new/obj/effect/overlay/wallrot(src)

/turf/simulated/wall/proc/can_melt()
	if(isProtected())
		return 0
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
	if(isProtected())
		return
	if(material.combustion_effect(src, temperature, 0.7))
		spawn(2)
			for(var/turf/simulated/wall/W in range(3,src))
				W.burn((temperature/4))
			for(var/obj/machinery/door/airlock/phoron/D in range(3,src))
				D.ignite(temperature/4)
			dismantle_wall(TRUE)

/turf/simulated/wall/get_color()
	return paint_color

/turf/simulated/wall/proc/CheckPenetration(var/base_chance, var/damage)
	return round(damage/material.integrity*180)

/turf/simulated/wall/can_engrave()
	return (material && material.hardness >= 10 && material.hardness <= 100)

/turf/simulated/wall/is_wall()
	return TRUE
