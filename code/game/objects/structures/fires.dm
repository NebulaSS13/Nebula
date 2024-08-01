// TODO notes:
// - fuel should just be burning atoms when atom fires are in.
// - fire source should just be an interaction and safety wrapper for an atom fire
//   ie. all fire behavior comes from the fuel atoms in the fire, but spread and
//   click behavior is curtailed by the fire_source.

#define IDEAL_FUEL  15
#define HIGH_FUEL   (IDEAL_FUEL * 0.65)
#define LOW_FUEL    (IDEAL_FUEL * 0.35)

#define FIRE_LIT    1
#define FIRE_DEAD  -1
#define FIRE_OUT    0

#define FUEL_CONSUMPTION_CONSTANT 0.025

/obj/structure/fire_source
	name = "firepit"
	desc = "Did anyone bring any marshmallows?"
	icon = 'icons/obj/structures/fire.dmi'
	icon_state = "campfire"
	anchored = TRUE
	density = FALSE
	material = /decl/material/solid/stone/basalt
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	abstract_type = /obj/structure/fire_source
	throwpass = TRUE

	var/datum/effect/effect/system/steam_spread/steam // Used when being quenched.
	var/datum/composite_sound/fire_crackles/fire_loop
	var/datum/composite_sound/grill/grill_loop // Used when food is cooking on the fire.

	var/light_range_high =  3
	var/light_range_mid =   2
	var/light_range_low =   1
	var/light_power_high =  0.8
	var/light_power_mid =   0.6
	var/light_power_low =   0.4
	var/light_color_high = "#ffdd55"
	var/light_color_mid =  "#ff9900"
	var/light_color_low =  "#ff0000"

	var/list/affected_exterior_turfs
	var/next_fuel_consumption = 0
	var/last_fuel_burn_temperature = T20C
	var/cap_last_fuel_burn = 850 CELSIUS // Prevent using campfires and stoves as kilns.
	var/exterior_temperature = 30

	/// Are we on fire?
	var/lit = FIRE_OUT
	/// How much fuel is left?
	var/fuel = 0


/obj/structure/fire_source/Initialize()
	. = ..()
	update_icon()
	create_reagents(100)
	steam = new(name)
	steam.attach(get_turf(src))
	steam.set_up(3, 0, get_turf(src))
	fire_loop  = new(list(src), FALSE)
	grill_loop = new(list(src), FALSE)
	if(lit == FIRE_LIT)
		try_light(INFINITY, TRUE)

/obj/structure/fire_source/Destroy()
	QDEL_NULL(steam)
	STOP_PROCESSING(SSobj, src)
	lit = FIRE_DEAD
	refresh_affected_exterior_turfs()
	QDEL_NULL(fire_loop)
	QDEL_NULL(grill_loop)
	return ..()

/obj/structure/fire_source/Move()
	. = ..()
	if(. && lit == FIRE_LIT)
		refresh_affected_exterior_turfs()

/obj/structure/fire_source/proc/get_current_burn_temperature()
	var/datum/gas_mixture/environment = return_air()
	return max(environment?.temperature, last_fuel_burn_temperature)

/obj/structure/fire_source/proc/refresh_affected_exterior_turfs()

	if(lit != FIRE_LIT)
		for(var/thing in affected_exterior_turfs)
			var/turf/T = thing
			LAZYREMOVE(T.affecting_heat_sources, src)
		affected_exterior_turfs = null
	else
		var/list/new_affecting
		for(var/turf/T as anything in RANGE_TURFS(loc, light_range_high))
			if(T.external_atmosphere_participation)
				LAZYADD(new_affecting, T)
		for(var/turf/T as anything in affected_exterior_turfs)
			if(!(T in new_affecting) || !T.external_atmosphere_participation)
				LAZYREMOVE(T.affecting_heat_sources, src)
				LAZYREMOVE(affected_exterior_turfs, T)
			LAZYREMOVE(new_affecting, T)
		for(var/turf/T as anything in new_affecting)
			LAZYDISTINCTADD(T.affecting_heat_sources, src)
			LAZYDISTINCTADD(affected_exterior_turfs, T)

/obj/structure/fire_source/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	. = ..()
	if(!QDELETED(src))
		try_light(exposed_temperature)

/obj/structure/fire_source/fluid_act(datum/reagents/fluids)
	. = ..()
	if(!QDELETED(src) && fluids?.total_volume && reagents)
		var/transfer = min(reagents.maximum_volume - reagents.total_volume, max(max(1, round(fluids.total_volume * 0.25))))
		if(transfer > 0)
			fluids.trans_to_obj(src, transfer)

/obj/structure/fire_source/explosion_act()
	. = ..()
	if(!QDELETED(src))
		die()

/obj/structure/fire_source/proc/die()
	if(lit == FIRE_LIT)
		lit = FIRE_DEAD
		last_fuel_burn_temperature = T20C
		refresh_affected_exterior_turfs()
		visible_message(SPAN_DANGER("\The [src] goes out!"))
		STOP_PROCESSING(SSobj, src)
		update_icon()
		if(fire_loop?.started)
			fire_loop.stop(src)

/obj/structure/fire_source/proc/check_atmos()
	var/datum/gas_mixture/GM = loc?.return_air()
	for(var/g in GM?.gas)
		var/decl/material/oxidizer = GET_DECL(g)
		if(oxidizer.gas_flags & XGM_GAS_OXIDIZER)
			return TRUE

/obj/structure/fire_source/proc/try_light(ignition_temperature, force)
	if(!check_atmos())
		return FALSE
	if(lit == FIRE_LIT && !force)
		return FALSE
	if(!process_fuel(ignition_temperature))
		return FALSE
	last_fuel_burn_temperature = max(last_fuel_burn_temperature, ignition_temperature) // needed for initial burn procs to function
	lit = FIRE_LIT
	refresh_affected_exterior_turfs()
	visible_message(SPAN_DANGER("\The [src] catches alight!"))
	START_PROCESSING(SSobj, src)
	if(fire_loop && !fire_loop.started)
		fire_loop.start(src)
	update_icon()
	return TRUE

/obj/structure/fire_source/proc/remove_atom(atom/movable/thing)
	if(!QDELETED(thing))
		thing.dropInto(loc)
		return TRUE
	return FALSE

/obj/structure/fire_source/proc/get_removable_atoms()
	return get_contained_external_atoms()

/obj/structure/fire_source/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		var/list/removable = get_removable_atoms()
		if(length(removable))
			to_chat(user, "Looking within \the [src], you see:")
			for(var/atom/thing in removable)
				to_chat(user, "\icon[thing] \the [thing]")
		else
			to_chat(user, "\The [src] is empty.")

/obj/structure/fire_source/attack_hand(var/mob/user)

	var/list/removable_atoms = get_removable_atoms()
	if(length(removable_atoms) && user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		var/obj/item/removing = pick(removable_atoms)
		if(remove_atom(removing))
			user.put_in_hands(removing)
			if(lit == FIRE_LIT)
				visible_message(SPAN_DANGER("\The [user] fishes \the [removing] out of \the [src]!"))
				// Uncomment this when there's a way to take stuff out of a kiln or oven without setting yourself on fire.
				//user.fire_act(return_air(), last_fuel_burn_temperature, 500)
			else
				visible_message(SPAN_NOTICE("\The [user] removes \the [removing] from \the [src]."))
		update_icon()
		return TRUE

	if(lit != FIRE_LIT && user.a_intent == I_HURT)
		to_chat(user, SPAN_DANGER("You start stomping on \the [src], trying to destroy it."))
		if(do_after(user, 5 SECONDS, src))
			visible_message(SPAN_DANGER("\The [user] stamps and kicks at \the [src] until it is completely destroyed."))
			physically_destroyed()
		return TRUE

	return ..()

/obj/structure/fire_source/grab_attack(var/obj/item/grab/G)
	var/mob/living/affecting_mob = G.get_affecting_mob()
	if(!istype(affecting_mob))
		return FALSE
	if (G.assailant.a_intent != I_HURT)
		return TRUE
	if (!G.force_danger())
		to_chat(G.assailant, SPAN_WARNING("You need a better grip!"))
		return TRUE
	affecting_mob.forceMove(get_turf(src))
	SET_STATUS_MAX(affecting_mob, STAT_WEAK, 5)
	visible_message(SPAN_DANGER("\The [G.assailant] hurls \the [affecting_mob] onto \the [src]!"))
	if(lit == FIRE_LIT)
		affecting_mob.fire_act(return_air(), last_fuel_burn_temperature, 500)
	return TRUE

/obj/structure/fire_source/isflamesource()
	return (lit == FIRE_LIT)

/obj/structure/fire_source/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return ..() || (istype(mover) && mover.checkpass(PASS_FLAG_TABLE))

/obj/structure/fire_source/proc/burn_material(var/decl/material/mat, var/amount)
	. = mat.get_burn_products(amount, last_fuel_burn_temperature)
	if(.)
		if(mat.ignition_point && last_fuel_burn_temperature >= mat.ignition_point)
			if(mat.accelerant_value > FUEL_VALUE_NONE)
				fuel += amount * (1 + material.accelerant_value)
			last_fuel_burn_temperature = max(last_fuel_burn_temperature, mat.burn_temperature)
		else if(mat.accelerant_value <= FUEL_VALUE_SUPPRESSANT)
			fuel -= amount * mat.accelerant_value
		fuel = max(fuel, 0)
		loc.take_waste_burn_products(., last_fuel_burn_temperature)

// Dump waste gas from burned fuel.
/obj/structure/fire_source/proc/dump_waste_products(var/atom/target, var/list/waste)
	if(istype(target) && length(waste))
		var/datum/gas_mixture/environment = target.return_air()
		if(environment)
			for(var/w in waste)
				if(waste[w] > 0)
					environment.adjust_gas(w, waste[w], FALSE)
			environment.update_values()

/obj/structure/fire_source/attackby(var/obj/item/thing, var/mob/user)

	// Gate a few interactions behind intent so they can be bypassed if needed.
	if(user.a_intent != I_HURT)
		// Put cooking items onto the fire source.
		if(istype(thing, /obj/item/chems/cooking_vessel) && user.try_unequip(thing, get_turf(src)))
			thing.reset_offsets()
			return TRUE
		// Pour fuel or water into a fire.
		if(istype(thing, /obj/item/chems))
			var/obj/item/chems/chems = thing
			if(chems.standard_pour_into(user, src))
				return TRUE

	if(lit == FIRE_LIT && istype(thing, /obj/item/flame))
		thing.fire_act(return_air(), last_fuel_burn_temperature, 500)
		return TRUE

	if(thing.isflamesource())
		visible_message(SPAN_NOTICE("\The [user] attempts to light \the [src] with \the [thing]."))
		try_light(thing.get_heat())
		return TRUE

	if((lit != FIRE_LIT || user.a_intent == I_HURT))
		// Only drop in one log at a time.
		if(istype(thing, /obj/item/stack))
			var/obj/item/stack/stack = thing
			thing = stack.split(1)
		if(!QDELETED(thing) && user.try_unequip(thing, src))
			user.visible_message(SPAN_NOTICE("\The [user] drops \the [thing] into \the [src]."))
		update_icon()
		return TRUE

	return ..()

/obj/structure/fire_source/proc/process_fuel(ignition_temperature)

	if(fuel >= IDEAL_FUEL)
		return TRUE

	// Slowly lose burn temperature.
	// TODO: use temperature var and equalizing system?
	last_fuel_burn_temperature = max(ignition_temperature, last_fuel_burn_temperature)
	if(last_fuel_burn_temperature > T20C && fuel < LOW_FUEL)
		last_fuel_burn_temperature = max(T20C, round(last_fuel_burn_temperature * 0.9))

	var/list/waste = list()
	for(var/obj/item/thing in contents)
		var/consumed_item = FALSE
		for(var/mat in thing.matter)
			var/list/waste_products = burn_material(GET_DECL(mat), MOLES_PER_MATERIAL_UNIT(thing.matter[mat]))
			if(!isnull(waste_products))
				for(var/product in waste_products)
					waste[product] += waste_products[product]
				consumed_item = TRUE
		if(consumed_item)
			qdel(thing)
		if(fuel >= IDEAL_FUEL)
			break

	dump_waste_products(loc, waste)

	if(!isnull(cap_last_fuel_burn))
		// TODO: dump excess directly into the atmosphere as heat
		last_fuel_burn_temperature = min(last_fuel_burn_temperature, cap_last_fuel_burn)

	return (fuel > 0)

/obj/structure/fire_source/on_reagent_change()
	if(!(. = ..()))
		return
	if(reagents?.total_volume)
		var/do_steam = FALSE
		var/list/waste = list()

		for(var/rtype in reagents?.reagent_volumes)

			var/decl/material/reagent = GET_DECL(rtype)
			if(reagent.accelerant_value <= FUEL_VALUE_SUPPRESSANT)
				do_steam = TRUE

			var/volume = max(1, round(REAGENT_VOLUME(reagents, rtype) / 10)) // arbitrary constant to get it in line with mat burning values
			var/list/waste_products = burn_material(reagent, volume)
			if(!isnull(waste_products))
				for(var/product in waste_products)
					waste[product] += waste_products[product]
				reagents.remove_reagent(reagent.type, volume)

		dump_waste_products(loc, waste)

		if(lit == FIRE_LIT && do_steam)
			steam.start() // HISSSSSS!

/obj/structure/fire_source/proc/get_fire_exposed_atoms()
	return loc?.get_contained_external_atoms()

/obj/structure/fire_source/Process()

	if(lit != FIRE_LIT)
		return PROCESS_KILL

	if(!check_atmos())
		die()
		return

	fuel -= FUEL_CONSUMPTION_CONSTANT
	if(!process_fuel())
		die()
		return

	if(isturf(loc))
		var/turf/my_turf = loc
		my_turf.hotspot_expose(last_fuel_burn_temperature, 500, 1)

	var/datum/gas_mixture/environment = return_air()
	for(var/atom/thing in get_fire_exposed_atoms())
		thing.fire_act(environment, last_fuel_burn_temperature, 500)

	// Copied from space heaters. Heat up the air on our tile, heat will percolate out.
	if(environment && abs(environment.temperature - last_fuel_burn_temperature) > 0.1)
		var/transfer_moles = 0.25 * environment.total_moles
		var/datum/gas_mixture/removed = environment.remove(transfer_moles)
		if(removed)
			var/heat_transfer = removed.get_thermal_energy_change(round(last_fuel_burn_temperature * 0.1))
			if(heat_transfer > 0)
				removed.add_thermal_energy(heat_transfer)
		environment.merge(removed)


	queue_icon_update()

/obj/structure/fire_source/on_update_icon()
	..()
	if((fuel || length(contents)) && (lit != FIRE_DEAD))
		// todo: get colour from fuel
		var/image/I = image(icon, "[icon_state]_full")
		I.appearance_flags |= RESET_COLOR | RESET_ALPHA | KEEP_APART
		add_overlay(I)

	switch(lit)
		if(FIRE_LIT)
			if(fuel >= HIGH_FUEL)
				var/image/I = image(icon, "[icon_state]_lit")
				I.appearance_flags |= RESET_COLOR | RESET_ALPHA | KEEP_APART
				add_overlay(I)
				set_light(light_range_high, light_power_high, light_color_high)
			else if(fuel <= LOW_FUEL)
				var/image/I = image(icon, "[icon_state]_lit_dying")
				I.appearance_flags |= RESET_COLOR | RESET_ALPHA | KEEP_APART
				add_overlay(I)
				set_light(light_range_mid, light_power_mid, light_color_mid)
			else
				var/image/I = image(icon, "[icon_state]_lit_low")
				I.appearance_flags |= RESET_COLOR | RESET_ALPHA
				add_overlay(I)
				set_light(light_range_low, light_power_low, light_color_low)
		if(FIRE_DEAD)
			var/image/I = image(icon, "[icon_state]_burnt")
			I.appearance_flags |= RESET_COLOR | RESET_ALPHA
			add_overlay(I)
			set_light(0)
		else
			set_light(0)

/obj/structure/fire_source/spark_act(obj/effect/sparks/sparks)
	try_light(1000)

/obj/structure/fire_source/CanPass(atom/movable/mover, turf/target, height, air_group)
	. = ..()
	if(lit && ismob(mover))
		var/mob/M = mover
		if(!MOVING_QUICKLY(M))
			to_chat(M, SPAN_WARNING("You refrain from stepping into \the [src]."))
			return FALSE
	return ..()

// Subtypes.
/obj/structure/fire_source/firepit
	obj_flags = OBJ_FLAG_HOLLOW

/obj/structure/fire_source/stove
	name = "stove"
	desc = "Just the thing to warm your hands by."
	icon_state = "stove"
	density = TRUE
	material = /decl/material/solid/metal/iron
	obj_flags = OBJ_FLAG_HOLLOW

/obj/structure/fire_source/stove/grab_attack(obj/item/grab/G)
	return FALSE

/obj/structure/fire_source/fireplace
	name = "fireplace"
	desc = "So cheery!"
	icon_state = "fireplace"
	density = TRUE
	material = /decl/material/solid/stone/pottery // brick
	light_range_high = 6
	light_range_mid = 3
	light_range_low = 1
	light_power_high = 0.9
	light_color_high = "#e09d37"
	light_color_mid = "#d47b27"
	light_color_low = "#e44141"

/obj/structure/fire_source/fireplace/grab_attack(obj/item/grab/G)
	return FALSE

#define MATERIAL_FIREPLACE(material_name) \
/obj/structure/fire_source/fireplace/##material_name { \
	color = /decl/material/solid/stone/##material_name::color; \
	material = /decl/material/solid/stone/##material_name; \
}
MATERIAL_FIREPLACE(basalt)
MATERIAL_FIREPLACE(marble)
MATERIAL_FIREPLACE(granite)
MATERIAL_FIREPLACE(pottery)
#undef MATERIAL_FIREPLACE

#define MATERIAL_FIREPIT(material_name) \
/obj/structure/fire_source/firepit/##material_name { \
	color = /decl/material/solid/stone/##material_name::color; \
	material = /decl/material/solid/stone/##material_name; \
}
MATERIAL_FIREPIT(basalt)
MATERIAL_FIREPIT(marble)
MATERIAL_FIREPIT(granite)
#undef MATERIAL_FIREPIT

#undef FUEL_CONSUMPTION_CONSTANT
#undef FIRE_LIT
#undef FIRE_DEAD
#undef FIRE_OUT
#undef LOW_FUEL
#undef HIGH_FUEL
#undef IDEAL_FUEL
