/obj/vehicle/train/trolley
	name = "cargo train trolley"
	desc = "A large, flat platform made for putting things on."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "cargo_trailer"
	anchored = FALSE
	passenger_allowed = 0
	locked = 0
	buckle_pixel_shift = list("x" = 0, "y" = 0, "z" = 8)

	load_item_visible = 1
	load_offset_x = 0
	load_offset_y = 4

	var/static/list/can_load_types = list(
		/obj/machinery,
		/obj/structure/closet,
		/obj/structure/largecrate,
		/obj/structure/reagent_dispensers,
		/obj/structure/ore_box,
		/mob/living/human
	)

/obj/vehicle/train/trolley/insert_cell(var/obj/item/cell/cell, var/mob/living/human/H)
	return

//-------------------------------------------
// Loading/unloading procs
//-------------------------------------------
/obj/vehicle/train/trolley/load_onto_vehicle(var/atom/movable/loading, var/mob/user)
	if(ismob(loading) && !passenger_allowed)
		return 0
	if(!is_type_in_list(loading, can_load_types))
		return 0
	//if there are any items you don't want to be able to interact with, add them to this check
	// ~no more shielded, emitter armed death trains
	if(istype(loading, /obj/machinery))
		load_object(loading)
	else
		..(loading, user)
	return !!load

//Load the object "inside" the trolley and add an overlay of it.
//This prevents the object from being interacted with until it has
// been unloaded. A dummy object is loaded instead so the loading
// code knows to handle it correctly.
/obj/vehicle/train/trolley/proc/load_object(var/atom/movable/loading)
	//To prevent loading things from someone's inventory, which wouldn't get handled properly.
	if(!isturf(loading.loc) || load || loading.anchored)
		return 0
	var/datum/vehicle_dummy_load/dummy_load = new
	dummy_load.actual_load = loading
	load = dummy_load
	loading.forceMove(src)
	update_icon()

/obj/vehicle/train/trolley/unload_from_vehicle(var/mob/user, var/direction)
	if(istype(load, /datum/vehicle_dummy_load))
		var/datum/vehicle_dummy_load/dummy_load = load
		load = dummy_load.actual_load
		dummy_load.actual_load = null
		qdel(dummy_load)
	update_icon()
	..()

/obj/vehicle/train/trolley/on_update_icon()
	cut_overlays()
	var/datum/vehicle_dummy_load/dummy_load = load
	if(istype(dummy_load) && dummy_load.actual_load && load_item_visible)
		var/atom/movable/loading = dummy_load.actual_load
		loading.pixel_x += load_offset_x
		loading.pixel_y += load_offset_y
		loading.plane = plane
		loading.layer = VEHICLE_LOAD_LAYER
		add_overlay(loading)
		compile_overlays() // We want to reset the pixel values on our load after this.
		//we can set these back now since we have already cloned the icon into the overlay
		loading.pixel_x = initial(loading.pixel_x)
		loading.pixel_y = initial(loading.pixel_y)
		loading.layer = initial(loading.layer)

/obj/vehicle/train/trolley/update_car(var/train_length, var/active_engines)
	..()
	anchored = lead || tow

/obj/vehicle/train/trolley/Bump(atom/Obstacle)
	if(!lead)
		return //so people can't knock others over by pushing a trolley around
	..()

/obj/vehicle/train/trolley/attackby(obj/item/used_item, mob/user)
	if(open && IS_WIRECUTTER(used_item))
		passenger_allowed = !passenger_allowed
		user.visible_message(
			SPAN_NOTICE("\The [user] [passenger_allowed ? "cuts" : "mends"] a cable in [src]."),
			SPAN_NOTICE("You [passenger_allowed ? "cut" : "mend"] the load limiter cable.")
		)
		return TRUE
	return ..()

/obj/vehicle/train/trolley/crossed_mob(var/mob/living/victim)
	..()
	attack_log += text("\[[time_stamp()]\] <font color='red'>ran over [victim.name] ([victim.ckey])</font>")
