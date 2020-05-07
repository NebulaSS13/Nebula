#define DEFAULT_TURF_MASS		500

// Gets a ship's delta v in km/s. This only uses immediate impulse with whatever is in engines,
// to get a ship's total *possible* approxiamte delta v, use get_total_delta_v().
// partial power is used with burn() in order to only do partial burns.
/obj/effect/overmap/visitable/ship/proc/get_delta_v(var/real_burn = FALSE, var/partial_power = 1)
	var/total_exhaust_velocity = 0
	partial_power = Clamp(partial_power, 0, 1)
	for(var/datum/extension/ship_engine/E in engines)
		total_exhaust_velocity += real_burn ? E.burn(partial_power) : E.get_exhaust_velocity()
	var/vessel_mass = get_vessel_mass()
	// special note here
	// get_instant_wet_mass() returns kg
	// vessel_mass is in metric tonnes
	// This is not a correct rocket equation, but it's what is balanced for the game and
	// is intentional.
	var/raw_delta_v = (total_exhaust_velocity / GRAVITY_CONSTANT) * log((get_specific_wet_mass() + vessel_mass) / vessel_mass)
	return round(raw_delta_v, SHIP_MOVE_RESOLUTION)

// Stubbed method for future goodness.
// This will be used for delta-v equations for launching ships later.
/obj/effect/overmap/visitable/ship/proc/get_total_wet_mass()
	return vessel_mass * 0.2

// This is the amount of fuel we can spend in one specific impulse.
/obj/effect/overmap/visitable/ship/proc/get_specific_wet_mass()
	var/mass = 0
	for(var/datum/extension/ship_engine/E in engines)
		mass += E.get_specific_wet_mass()
	return mass

/obj/effect/overmap/visitable/ship/proc/get_vessel_mass()
	. = vessel_mass
	for(var/obj/effect/overmap/visitable/ship/ship in src)
		. += ship.get_vessel_mass()

/obj/effect/overmap/visitable/ship/proc/recalculate_vessel_mass()
	var/list/zones = list()
	for(var/area/A in get_areas())
		for(var/turf/simulated/T in A)
			if(istype(T, /turf/simulated/open))
				continue

			. += DEFAULT_TURF_MASS
			if(istype(T, /turf/simulated/wall))
				var/turf/simulated/wall/W = T
				if(W.material)
					. += W.material.weight * 5
				if(W.reinf_material)
					. += W.reinf_material.weight * 5
				if(W.girder_material)
					. += W.girder_material.weight * 5

			zones |= T.zone
			for(var/atom/movable/C in T)
				if(!C.simulated)
					continue
				. += C.get_mass()
				for(var/atom/movable/C2 in C)
					if(!C2.simulated)
						continue
					. += C2.get_mass()

	for(var/zone/Z in zones)
		. += Z.air.get_mass()

	// Convert kilograms to metric tonnes.
	. = . / 1000

// Returns the delta-v budget required to get to the destination.
/obj/effect/overmap/visitable/ship/proc/get_delta_v_budget(var/obj/effect/overmap/visitable/destination)
	var/obj/effect/overmap/visitable/location = loc
	var/to_planet = istype(destination, /obj/effect/overmap/visitable/sector/exoplanet)
	var/from_planet = istype(location, /obj/effect/overmap/visitable/sector/exoplanet)

	var/delta_v = 0
	if(from_planet && !to_planet)
		var/obj/effect/overmap/visitable/sector/exoplanet/planet = destination
		var/orbit_radius = planet.planet_radius + 90000
		// We are taking off into space.
		var/E = -1 * (planet.gravity / (2 * orbit_radius))
		var/v_leo = sqrt(2 * (E + (planet.gravity / orbit_radius)))
		var/gravity_loss = (planet.gravity * 2) * 0.8
		// delta_v in km/s
		delta_v = v_leo + gravity_loss
	else if(to_planet && !from_planet)
		// We are landing on a planet.
		var/obj/effect/overmap/visitable/sector/exoplanet/planet = location
		var/orbit_radius = planet.planet_radius + 90000 // Our current orbit.
		// We are taking off into space.
		var/E = -1 * (planet.gravity / (2 * orbit_radius))
		var/v_leo = sqrt(2 * (E + (planet.gravity / orbit_radius)))
		var/gravity_gain = (planet.gravity * 2) * 0.8
		delta_v = Clamp((v_leo / 1.4) - gravity_gain, 0, 50)
	else if(to_planet && from_planet)
		var/obj/effect/overmap/visitable/sector/exoplanet/planet = destination
		delta_v = planet.gravity * 0.8
	else
		// We are moving around in space.
		// This is a goofy equation.
		if(istype(destination, /obj/effect/overmap/visitable/ship))
			// we's going to a ship. this is a *really* goofy equation.
			var/obj/effect/overmap/visitable/ship/destination_ship = destination
			// How big our ships are in relation results in how much delta-v it'll take to uh.. 'encounter' them. This isn't real math.
			// this is fake game math.
			delta_v = Clamp(log(max(destination_ship.vessel_mass, vessel_mass) / min(destination_ship.vessel_mass, vessel_mass)), 0.1, 0.9)
		delta_v = 0.1 // Traveling around in space is e.z..
	return delta_v

