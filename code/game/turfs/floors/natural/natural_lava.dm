/turf/floor/natural/lava
	name = "lava"
	desc = "Incredibly hot molten rock. You can feel the heat radiating even from a distance."
	icon = 'icons/turf/flooring/lava.dmi'
	movement_delay = 4
	dirt_color = COLOR_GRAY20
	footstep_type = /decl/footsteps/lava
	is_fundament_turf = TRUE
	material = /decl/material/solid/stone/basalt // TODO: inherent turf temperature
	var/list/victims

/turf/floor/natural/lava/Initialize()
	. = ..()
	set_light(2, l_color = LIGHT_COLOR_LAVA)

/turf/floor/natural/lava/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/turf/floor/natural/lava/Entered(atom/movable/AM)
	..()
	if(locate(/obj/structure/catwalk/) in src)
		return
	var/mob/living/L = AM
	if (istype(L) && L.can_overcome_gravity())
		return
	if(AM.is_burnable())
		LAZYADD(victims, weakref(AM))
		START_PROCESSING(SSobj, src)

/turf/floor/natural/lava/Exited(atom/movable/AM)
	. = ..()
	LAZYREMOVE(victims, weakref(AM))

/turf/floor/natural/lava/Process()
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
