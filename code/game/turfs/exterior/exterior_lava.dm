/turf/exterior/lava
	name = "lava"
	icon = 'icons/turf/exterior/lava.dmi'
	movement_delay = 4
	dirt_color = COLOR_GRAY20
	footstep_type = /decl/footsteps/lava
	var/list/victims

/turf/exterior/lava/Initialize()
	. = ..()
	set_light(0.95, 0.5, 2, l_color = COLOR_ORANGE)

/turf/exterior/lava/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/turf/exterior/lava/Entered(atom/movable/AM)
	..()
	if(locate(/obj/structure/catwalk/) in src)
		return
	var/mob/living/L = AM
	if (istype(L) && L.can_overcome_gravity())
		return
	if(AM.is_burnable())
		LAZYADD(victims, weakref(AM))
		START_PROCESSING(SSobj, src)

/turf/exterior/lava/Exited(atom/movable/AM)
	. = ..()
	LAZYREMOVE(victims, weakref(AM))

/turf/exterior/lava/Process()
	if(locate(/obj/structure/catwalk/) in src)
		victims = null
		return PROCESS_KILL
	for(var/weakref/W in victims)
		var/atom/movable/AM = W.resolve()
		if (AM == null || get_turf(AM) != src || AM.is_burnable() == FALSE)
			victims -= W
			continue
		var/datum/gas_mixture/environment = return_air()
		var/pressure = environment.return_pressure()
		var/destroyed = AM.lava_act(environment, 5000 + environment.temperature, pressure)
		if(destroyed == TRUE)
			victims -= W
	if(!LAZYLEN(victims))
		return PROCESS_KILL
