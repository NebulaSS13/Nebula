//////////////////////////////////////////////////////////////////////
// Geyser Object
//////////////////////////////////////////////////////////////////////

/// A prop that periodically emit steam spouts and can have a geothermal generator placed on top to generate power.
/obj/effect/geyser
	name       = "geothermal vent"
	desc       = "A vent leading to an underground geothermally heated reservoir, which periodically spews superheated liquid."
	icon       = 'icons/effects/geyser.dmi'
	icon_state = "geyser"
	anchored   = TRUE
	layer      = TURF_LAYER + 0.01
	level      = LEVEL_BELOW_PLATING // Goes under floor/plating
	/// The particle emitter that will generate the steam column effect for this geyser
	var/particles/geyser_steam/steamfx

/obj/effect/geyser/Initialize(ml)
	. = ..()
	if(prob(50))
		var/matrix/M = matrix()
		M.Scale(-1, 1)
		transform = M
	set_extension(src, /datum/extension/geothermal_vent)
	steamfx = new //Prepare our FX

///Async proc that enables the particle emitter for the steam column for a few seconds
/obj/effect/geyser/proc/do_spout()
	set waitfor = FALSE
	particles = steamfx
	particles.spawning = initial(particles.spawning)
	sleep(6 SECONDS)
	particles.spawning = 0

/obj/effect/geyser/explosion_act(severity)
	. = ..()
	if(!QDELETED(src) && prob(100 - (25 * severity)))
		physically_destroyed()

/obj/effect/geyser/hide(hide)
	var/datum/extension/geothermal_vent/E = get_extension(src, /datum/extension/geothermal_vent)
	if(istype(E))
		E.set_obstructed(hide)
	. = ..()
	update_icon()

//////////////////////////////////////////////////////////////////////
// Underwater Geyser Variant
//////////////////////////////////////////////////////////////////////

/obj/effect/geyser/underwater
	desc = "A crack in the ocean floor that occasionally vents gouts of superheated water and steam."

/obj/effect/geyser/underwater/Initialize(ml)
	. = ..()
	if(!loc)
		return INITIALIZE_HINT_QDEL
	for(var/turf/floor/seafloor/T in RANGE_TURFS(loc, 5))
		var/dist = get_dist(loc, T)-1
		if(prob(100 - (dist * 20)))
			if(prob(25))
				T = T.ChangeTurf(/turf/floor/clay)
			else
				T = T.ChangeTurf(/turf/floor/mud)
		if(prob(50 - (dist * 10)))
			new /obj/random/seaweed(T)

/obj/effect/geyser/underwater/do_spout()
	set waitfor = FALSE
	var/turf/T = get_turf(src)
	T.show_bubbles()
