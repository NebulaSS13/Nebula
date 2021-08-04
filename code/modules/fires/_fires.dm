/atom/movable/fire
	anchored = TRUE
	mouse_opacity = 0
	blend_mode = BLEND_ADD
	icon = 'icons/effects/fire.dmi'
	icon_state = "1"
	light_color = "#ed9200"
	layer = FIRE_LAYER
	var/fire_intensity = 0

/atom/movable/fire/Process()

    // PROCESS NOTES
    // Check for atoms on the turf (including fluids).
    //   Iterate matter/reagents for fuel.
    //   Iterate matter/reagents for oxygen.
    // If turf fluid level shallow or lower, and still missing fuel or oxygen, retrieve loc gas datum.
    //   Iterate loc gas datum for oxygen/fuel.
    // If missing fuel or oxygen, extinguish.
    // Convert portion of fuel and oxygen supplies into material combustion byproducts
    // Increase fire intensity
    // Output heat.

	var/datum/gas_mixture/air_contents = loc.return_air()
	loc.fire_act(air_contents, air_contents.temperature, air_contents.volume)
	for(var/atom/A in loc)
		A.fire_act(air_contents, air_contents.temperature, air_contents.volume)

    // Ignite any fluids or flammable atoms in turfs beside this one.

	animate(src, color = fire_color(air_contents.temperature), 5)
	set_light(l_color = color)

/atom/movable/fire/Initialize(mapload, fl)
	. = ..()

	if(!istype(loc, /turf))
		return INITIALIZE_HINT_QDEL

	set_dir(pick(global.cardinal))

	var/datum/gas_mixture/air_contents = loc.return_air()
	color = fire_color(air_contents.temperature)
	set_light(3, 0.5, color)

	START_PROCESSING(SSfires, src)

/atom/movable/fire/proc/fire_color(var/env_temperature)
	var/temperature = max(4000*sqrt(fire_intensity/vsc.fire_firelevel_multiplier), env_temperature)
	return heat2color(temperature)

/atom/movable/Destroy()
	set_light(0)
	STOP_PROCESSING(SSfires, src)
	. = ..()
