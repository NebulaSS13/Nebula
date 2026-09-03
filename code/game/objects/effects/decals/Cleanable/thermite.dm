/obj/effect/decal/cleanable/thermite
	name                = "thermite"
	desc                = "Looks hot."
	icon                = 'icons/effects/thermite.dmi'
	icon_state          = "thermite"
	anchored            = TRUE
	density             = TRUE
	plane               = OBJ_LAYER
	layer               = ABOVE_WINDOW_LAYER
	material            = /decl/material/liquid/thermite
	var/has_melted_turf = FALSE
	var/const/BURN_TIME = 10 SECONDS
	var/ignited_until

/obj/effect/decal/cleanable/thermite/Destroy()
	if(ignited_until)
		STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/effect/decal/cleanable/thermite/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	. = ..()
	ignite_fire()

/obj/effect/decal/cleanable/thermite/attackby(obj/item/used_item, mob/user)
	if(used_item.isflamesource())
		ignite_fire()
		return TRUE
	. = ..()

/obj/effect/decal/cleanable/thermite/ignite_fire()
	. = ..()
	if(!isnull(ignited_until) || QDELETED(src))
		return
	visible_message(SPAN_DANGER("\The [src] begins to hiss and burn with intense heat!"))
	icon_state = "thermite_burning"
	ignited_until = world.time + BURN_TIME
	START_PROCESSING(SSobj, src)

/obj/effect/decal/cleanable/thermite/Process()

	if(isnull(ignited_until))
		return PROCESS_KILL

	var/turf/my_turf = get_turf(src)
	if(!istype(my_turf))
		qdel(src)

	// After our timer, instantly melt the turf (unless we already destroyed it by accident)
	if(world.time >= ignited_until)
		if(!has_melted_turf)
			my_turf.dismantle_turf(TRUE, FALSE, TRUE)
			var/obj/structure/girder/girder = locate() in get_turf(src)
			if(girder && girder.material && (girder.material.integrity < 150 || girder.material.is_brittle()))
				girder.physically_destroyed()
			visible_message(SPAN_DANGER("\The [src] has burned itself out..."))
		qdel(src)
		return

	// Do some periodic damage to our turf for a visual indication of what's going on.
	if(istype(my_turf, /turf/floor))
		var/turf/floor/my_floor = my_turf
		my_floor.burn_tile()
	else
		my_turf.take_damage(rand(5, 10), BURN)
		// Was the turf changed/destroyed?
		if(my_turf != get_turf(src))
			has_melted_turf = TRUE

/obj/effect/decal/cleanable/thermite/self_igniting/Initialize(ml, _age)
	. = ..()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, ignite_fire)), 1 SECOND)
