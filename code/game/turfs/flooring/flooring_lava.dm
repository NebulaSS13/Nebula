
/decl/flooring/lava
	name                 = "lava"
	icon_base            = "lava"
	icon                 = 'icons/turf/flooring/lava.dmi'
	desc                 = "A pool of incredibly hot molten rock. You can feel the heat radiating even from a distance. Watch your step."
	movement_delay       = 4
	footstep_type        = /decl/footsteps/lava
	has_environment_proc = TRUE
	turf_light_color     = LIGHT_COLOR_LAVA
	turf_light_range     = 2
	turf_light_power     = 0.7

/decl/flooring/lava/handle_environment_proc(turf/floor/target)
	. = PROCESS_KILL
	if(locate(/obj/structure/catwalk) in target)
		return
	var/datum/gas_mixture/environment = target.return_air()
	var/pressure = environment?.return_pressure()
	for(var/atom/movable/AM as anything in target.get_contained_external_atoms())
		if(!AM.is_burnable())
			continue
		. = null
		if(isliving(AM))
			var/mob/living/L = AM
			if(L.can_overcome_gravity())
				continue
		AM.lava_act(environment, 5000 + environment.temperature, pressure)
