var/global/list/wall_blend_objects = list(
	/obj/machinery/door,
	/obj/structure/door,
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

/turf/wall
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	icon = 'icons/turf/walls/_previews.dmi'
	icon_state = "solid"
	opacity = TRUE
	density = TRUE
	blocks_air = 1
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall
	explosion_resistance = 10
	color = COLOR_STEEL
	turf_flags = TURF_IS_HOLOMAP_OBSTACLE
	initial_gas = GAS_STANDARD_AIRMIX
	zone_membership_candidate = TRUE

	/// If set, will prevent merges between walls with different IDs.
	var/unique_merge_identifier
	var/damage = 0
	var/can_open = 0
	var/decl/material/material
	var/decl/material/reinf_material
	var/decl/material/girder_material = /decl/material/solid/metal/steel
	var/construction_stage
	var/hitsound = 'sound/weapons/Genhit.ogg'
	/// A list of connections to walls for each corner, used for icon generation. Can be converted to a list of dirs with corner_states_to_dirs().
	var/list/wall_connections
	/// A list of connections to non-walls for each corner, used for icon generation. Can be converted to a list of dirs with corner_states_to_dirs().
	var/list/other_connections
	var/floor_type = /turf/floor/plating //turf it leaves after destruction
	var/paint_color
	var/stripe_color
	var/handle_structure_blending = TRUE
	var/min_dismantle_amount = 2
	var/max_dismantle_amount = 2

	/// Icon to use if shutter state is non-null.
	var/shutter_icon = 'icons/turf/walls/shutter.dmi'
	/// TRUE = open, FALSE = closed, null = no shutter.
	var/shutter_state
	/// Overrides base material for shutter icon if set.
	var/decl/material/shutter_material
	/// Shutter open/close sound.
	var/shutter_sound = 'sound/weapons/Genhit.ogg'

/turf/wall/Initialize(var/ml, var/materialtype, var/rmaterialtype)

	..(ml)

	// Clear mapping icons.
	icon = get_wall_icon()
	icon_state = "blank"
	color = null

	if(ispath(shutter_material))
		shutter_material = GET_DECL(shutter_material)

	set_turf_materials((materialtype || material || get_default_material()), (rmaterialtype || reinf_material), TRUE, girder_material, skip_update = TRUE)

	. = INITIALIZE_HINT_LATELOAD
	set_extension(src, /datum/extension/penetration/proc_call, PROC_REF(CheckPenetration))
	START_PROCESSING(SSturf, src) //Used for radiation.

/turf/wall/LateInitialize(var/ml)
	..()
	update_material(!ml)

/turf/wall/Destroy()
	STOP_PROCESSING(SSturf, src)
	material = GET_DECL(/decl/material/placeholder)
	reinf_material = null
	var/old_x = x
	var/old_y = y
	var/old_z = z
	. = ..()
	var/turf/debris = locate(old_x, old_y, old_z)
	if(debris)
		for(var/turf/wall/W in RANGE_TURFS(debris, 1))
			W.wall_connections = null
			W.other_connections = null
			W.queue_icon_update()

// Walls always hide the stuff below them.
/turf/wall/levelupdate()
	for(var/obj/O in src)
		O.hide(1)

/turf/wall/protects_atom(var/atom/A)
	var/obj/O = A
	return (istype(O) && O.hides_under_flooring()) || ..()

/turf/wall/Process(wait, tick)
	var/how_often = max(round(2 SECONDS/wait), 1)
	if(tick % how_often)
		return //We only work about every 2 seconds
	if(!radiate())
		return PROCESS_KILL

/turf/wall/get_material()
	return material

/turf/wall/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj,/obj/item/projectile/beam))
		burn(2500)
	else if(istype(Proj,/obj/item/projectile/ion))
		burn(500)

	var/proj_damage = Proj.get_structure_damage()

	if(Proj.ricochet_sounds && prob(15))
		playsound(src, pick(Proj.ricochet_sounds), 100, 1)

	if(reinf_material)
		if(Proj.atom_damage_type == BURN)
			proj_damage /= reinf_material.burn_armor
		else if(Proj.atom_damage_type == BRUTE)
			proj_damage /= reinf_material.brute_armor

	//cap the amount of damage, so that things like emitters can't destroy walls in one hit.
	var/damage = min(proj_damage, 100)

	take_damage(damage)

/turf/wall/hitby(atom/movable/AM, var/datum/thrownthing/TT)
	. = ..()
	if(. && density && !ismob(AM))
		var/tforce = AM.get_thrown_attack_force() * (TT.speed/THROWFORCE_SPEED_DIVISOR)
		playsound(src, hitsound, tforce >= 15 ? 60 : 25, TRUE)
		if(tforce > 0)
			take_damage(tforce)

/turf/wall/proc/clear_plants()
	for(var/obj/effect/overlay/wallrot/WR in src)
		qdel(WR)
	for(var/obj/effect/vine/plant in range(src, 1))
		if(!plant.floor) //shrooms drop to the floor
			plant.floor = 1
			plant.update_icon()
			plant.reset_offsets(0)

/turf/wall/ChangeTurf(var/turf/N, var/tell_universe = TRUE, var/force_lighting_update = FALSE, var/keep_air = FALSE, var/update_open_turfs_above = TRUE)
	clear_plants()
	. = ..()

//Appearance
/turf/wall/examine(mob/user)
	. = ..()

	if(!isnull(shutter_state))
		to_chat(user, SPAN_NOTICE("The shutter is [shutter_state ? "open" : "closed"]."))

	if(!damage)
		to_chat(user, SPAN_NOTICE("It looks fully intact."))
	else
		var/dam = damage / material.integrity
		if(dam <= 0.3)
			to_chat(user, SPAN_WARNING("It looks slightly damaged."))
		else if(dam <= 0.6)
			to_chat(user, SPAN_WARNING("It looks moderately damaged."))
		else
			to_chat(user, SPAN_DANGER("It looks heavily damaged."))
	if(paint_color)
		to_chat(user, get_paint_examine_message())
	if(locate(/obj/effect/overlay/wallrot) in src)
		to_chat(user, SPAN_WARNING("There is fungus growing on [src]."))

/turf/wall/proc/get_paint_examine_message()
	return SPAN_NOTICE("It has had <font color = '[paint_color]'>a coat of paint</font> applied.")

//Damage
/turf/wall/handle_melting(list/meltable_materials)
	. = ..()
	if(!can_melt())
		return
	var/turf/floor/F = ChangeTurf(/turf/floor/plating)
	if(!istype(F))
		return
	F.burn_tile()
	F.icon_state = "wall_thermite"
	visible_message(SPAN_DANGER("\The [src] spontaneously combusts!"))

/turf/wall/take_damage(damage, damage_type = BRUTE, damage_flags, inflicter, armor_pen = 0, silent, do_update_health)
	if(damage)
		src.damage = max(0, src.damage + damage)
		update_damage()

/turf/wall/proc/update_damage()
	var/cap = material.integrity
	if(reinf_material)
		cap += reinf_material.integrity

	if(locate(/obj/effect/overlay/wallrot) in src)
		cap = cap / 10

	if(damage >= cap)
		physically_destroyed()
	else
		update_icon()

/turf/wall/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)//Doesn't fucking work because walls don't interact with air :(
	burn(exposed_temperature)
	return ..()

/turf/wall/adjacent_fire_act(turf/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	burn(adj_temp)
	if(adj_temp > material.temperature_damage_threshold)
		take_damage(log(RAND_F(0.9, 1.1) * (adj_temp - material.temperature_damage_threshold)))
	return ..()

/turf/wall/proc/get_dismantle_stack_type()
	return

/turf/wall/proc/get_dismantle_sound()
	return 'sound/items/Welder.ogg'

/turf/wall/proc/drop_dismantled_products(devastated, explode)
	var/list/obj/structure/girder/placed_girders
	if(girder_material)
		placed_girders = girder_material.place_dismantled_girder(src, reinf_material)
	for(var/obj/structure/girder/placed_girder in placed_girders)
		placed_girder.anchored = TRUE
		placed_girder.prepped_for_fakewall = can_open
		placed_girder.update_icon()
	if(material)
		material.place_dismantled_product(src, devastated, amount = rand(min_dismantle_amount, max_dismantle_amount), drop_type = get_dismantle_stack_type())

/turf/wall/dismantle_turf(devastated, explode, no_product, keep_air = TRUE)

	playsound(src, get_dismantle_sound(), 100, 1)
	if(!no_product)
		drop_dismantled_products(devastated, explode)

	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O,/obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.dismantle_structure()
		else
			O.forceMove(src)
	clear_plants()
	. = ChangeTurf(floor_type || get_base_turf_by_area(src), keep_air = keep_air)

/turf/wall/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	if(severity == 1)
		dismantle_turf(TRUE, TRUE, TRUE)
	else if(severity == 2)
		if(prob(75))
			take_damage(rand(150, 250))
		else
			dismantle_turf(TRUE, TRUE)
	else if(severity == 3)
		take_damage(rand(0, 250))

// Wall-rot effect, a nasty fungus that destroys walls.
/turf/wall/proc/rot()
	if(locate(/obj/effect/overlay/wallrot) in src)
		return
	var/number_rots = rand(2,3)
	for(var/i=0, i<number_rots, i++)
		new/obj/effect/overlay/wallrot(src)

/turf/wall/proc/can_melt()
	if(material.flags & MAT_FLAG_UNMELTABLE)
		return 0
	return 1

/turf/wall/proc/radiate()
	var/total_radiation = material.radioactivity + (reinf_material ? reinf_material.radioactivity / 2 : 0)
	if(!total_radiation)
		return

	SSradiation.radiate(src, total_radiation)
	return total_radiation

/turf/wall/proc/burn(temperature)
	if(!QDELETED(src) && istype(material) && material.combustion_effect(src, temperature, 0.7))
		for(var/turf/wall/W in range(3,src))
			if(W != src)
				addtimer(CALLBACK(W, TYPE_PROC_REF(/turf/wall, burn), temperature/4), 2)
		physically_destroyed()

/turf/wall/get_color()
	return paint_color

/turf/wall/set_color(new_color)
	paint_color = new_color
	update_icon()

/turf/wall/proc/CheckPenetration(var/base_chance, var/damage)
	return round(damage/material.integrity*180)

/turf/wall/can_engrave()
	return (material && material.hardness >= 10 && material.hardness <= 100)

/turf/wall/is_wall()
	return TRUE

/turf/wall/handle_universal_decay()
	handle_melting()

/turf/wall/proc/get_hit_sound()
	return 'sound/effects/metalhit.ogg'
