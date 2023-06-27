/obj/item/flamethrower
	name = "flamethrower"
	desc = "You are a firestarter!"
	icon = 'icons/obj/flamethrower.dmi'
	icon_state = "flamethrower_base"
	item_state = "flamethrower_0"

	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 3

	throwforce = 10
	throw_speed = 1
	throw_range = 5

	w_class = ITEM_SIZE_LARGE
	origin_tech = "{'combat':1}"
	material = /decl/material/solid/metal/steel

	var/fire_sound
	/// Whether we have an igniter secured (screwdrivered) to us or not
	var/secured = FALSE
	var/throw_amount = 100
	/// on or off
	var/lit = FALSE
	/// cooldown
	var/operating = FALSE
	var/turf/previous_turf = null
	var/obj/item/weldingtool/welding_tool = null
	var/obj/item/assembly/igniter/igniter = null
	var/obj/item/tank/tank = null

/obj/item/flamethrower/Initialize(ml, material_key, welder)
	. = ..()
	if(welder)
		welding_tool = welder
		welding_tool.forceMove(src)

	update_icon()

/obj/item/flamethrower/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		if(tank)
			to_chat(user, SPAN_NOTICE("Release pressure is set to [throw_amount] kPa. The tank has about [round(tank.air_contents.return_pressure(), 10)] kPa left in it."))
		else
			to_chat(user, SPAN_WARNING("It has no tank installed."))
		if(igniter)
			to_chat(user, SPAN_NOTICE("It has \an [igniter] installed."))
		else
			to_chat(user, SPAN_WARNING("It has no igniter installed."))

/obj/item/flamethrower/Destroy()
	QDEL_NULL(welding_tool)
	QDEL_NULL(igniter)
	QDEL_NULL(tank)
	return ..()

/obj/item/flamethrower/Process()
	if(!lit)
		STOP_PROCESSING(SSprocessing, src)
		return null

	var/turf/location = loc
	if(istype(location, /mob))
		var/mob/M = location
		if(M.get_active_hand() == src)
			location = M.loc

	if(isturf(location)) //start a fire if possible
		location.hotspot_expose(700, 2)

/obj/item/flamethrower/on_update_icon()
	. = ..()
	add_overlay("_[initial(welding_tool.icon_state)]")

	if(igniter)
		add_overlay("igniter_[secured]")

	if(tank)
		add_overlay(mutable_appearance(icon, istype(tank, /obj/item/tank/hydrogen)? "tank_hydrogen" : "tank", tank.color))

	if(lit)
		add_overlay("lit")
		set_light(1.4, 2)
	else
		set_light(0)

/obj/item/flamethrower/afterattack(atom/target, mob/user, proximity)
	if(proximity)
		return

	if(!tank)
		return

	if(tank.air_contents?.get_by_flag(XGM_GAS_FUEL) < 1)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have enough fuel left to throw!"))
		return

	// Make sure our user is still holding us
	if(user && user.get_active_hand() == src)
		if(user.a_intent == I_HELP) //don't shoot if we're on help intent
			to_chat(user, SPAN_WARNING("You refrain from firing \the [src] as your intent is set to help."))
			return

		var/turf/target_turf = get_turf(target)
		if(target_turf)
			var/turflist = getline(user, target_turf)
			flame_turf(turflist)

/obj/item/flamethrower/isflamesource()
	return lit

/obj/item/flamethrower/attackby(obj/item/W, mob/user)
	if(user.incapacitated())
		return TRUE

	if(IS_WRENCH(W) && !secured)//Taking this apart
		var/turf/T = get_turf(src)
		if(welding_tool)
			welding_tool.dropInto(T)
			welding_tool = null

		if(igniter)
			igniter.dropInto(T)
			igniter = null

		if(tank)
			tank.dropInto(T)
			tank = null

		SSmaterials.create_object(/decl/material/solid/metal/steel, get_turf(src), 1, /obj/item/stack/material/rods)
		qdel(src)
		return TRUE

	if(IS_SCREWDRIVER(W) && igniter && !lit)
		secured = !secured
		to_chat(user, SPAN_NOTICE("\The [igniter] is now [secured ? "secured" : "unsecured"]!"))
		update_icon()
		return TRUE

	if(isigniter(W))
		var/obj/item/assembly/igniter/I = W
		if(I.secured)
			to_chat(user, SPAN_WARNING("\The [I] is not ready to attach yet! Use a screwdriver on it first."))
			return TRUE

		if(igniter)
			to_chat(user, SPAN_WARNING("\The [src] already has an igniter installed."))
			return TRUE

		user.drop_from_inventory(I, src)
		igniter = I
		update_icon()
		return TRUE

	if(istype(W, /obj/item/tank))
		if(tank)
			to_chat(user, SPAN_WARNING("There appears to already be a tank loaded in \the [src]!"))
			return TRUE

		user.drop_from_inventory(W, src)
		tank = W
		update_icon()
		return TRUE

	if(istype(W, /obj/item/scanner/gas))
		var/obj/item/scanner/gas/A = W
		A.analyze_gases(src, user)
		return TRUE


	if(W.isflamesource()) // you can light it with external input, even without an igniter
		attempt_lighting(user, TRUE)
		update_icon()
		return TRUE

	. = ..()

/obj/item/flamethrower/attack_self(mob/user)
	if(user.incapacitated())
		return

	if(!tank)
		to_chat(user, SPAN_WARNING("Attach a fuel tank first!"))
		return

	var/list/options = list(
		"Eject Tank" = mutable_appearance('icons/obj/items/tanks/tank_greyscaled.dmi', "world", tank.color),
		"Light" = mutable_appearance('icons/effects/effects.dmi', "fire_goon"),
		"Lower Pressure" = mutable_appearance('icons/screen/radial.dmi', "radial_sub"),
		"Raise Pressure" = mutable_appearance('icons/screen/radial.dmi', "radial_add")
	)

	var/handle = show_radial_menu(user, user, options, require_near = TRUE, radius = 42, tooltips = TRUE, check_locs = list(src))
	if(!handle || user.get_active_hand() != src)
		return

	switch(handle)
		if("Eject Tank")
			if(!tank)
				return

			user.put_in_hands(tank)
			tank = null
			lit = FALSE
			update_icon()

		if("Light")
			attempt_lighting(user)

		if("Lower Pressure")
			change_pressure(-50, user)

		if("Raise Pressure")
			change_pressure(50, user)
		else
			return

/obj/item/flamethrower/return_air()
	return tank?.return_air()

/obj/item/flamethrower/proc/attempt_lighting(var/mob/user, var/external)
	if(!external) // if it's external input, we can't unlight it, but we don't need to check for an igniter either
		if(lit) // you can extinguish the flamethrower without an igniter
			lit = FALSE
			to_chat(user, SPAN_NOTICE("You extinguish \the [src]."))
			update_icon()
			return

		if(!secured) // can't light via the flamethrower unless we have an igniter secured
			if(igniter)
				to_chat(user, SPAN_WARNING("\The [igniter] isn't secured, you need to use a screwdriver on it first."))
			else
				to_chat(user, SPAN_WARNING("\The [src] doesn't have a secured igniter installed."))
			return

	if(lit)
		to_chat(user, SPAN_WARNING("\The [src] is already lit."))
		return

	if(!tank)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have a tank installed."))
		return

	if(tank.air_contents?.get_by_flag(XGM_GAS_FUEL) < 1)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have any flammable fuel to light!"))
		return

	lit = TRUE
	to_chat(user, SPAN_NOTICE("You light \the [src]."))
	update_icon()

	if(lit)
		START_PROCESSING(SSprocessing, src)

/obj/item/flamethrower/proc/change_pressure(var/pressure, var/mob/user)
	if(!pressure)
		return

	throw_amount += pressure
	throw_amount = clamp(50, throw_amount, 5000)

	if(ismob(user))
		to_chat(user, SPAN_NOTICE("Pressure has been adjusted to [throw_amount] kPa."))

	update_icon()

//Called from turf.dm turf/dblclick
/obj/item/flamethrower/proc/flame_turf(turflist)
	if(!lit || operating)
		return

	operating = TRUE

	if(fire_sound)
		playsound(src, fire_sound, 70, 1)

	for(var/turf/T in turflist)
		if(T.density || isspaceturf(T))
			break

		if(!previous_turf && length(turflist)>1)
			previous_turf = get_turf(src)
			continue	//so we don't burn the tile we be standin on

		if(previous_turf && LinkBlocked(previous_turf, T))
			break

		ignite_turf(T)
		sleep(1)

	previous_turf = null
	operating = FALSE

/obj/item/flamethrower/proc/ignite_turf(turf/target)
	var/datum/gas_mixture/air_transfer = tank.air_contents.remove_ratio(0.02 * (throw_amount / 100))

	target.add_fluid(/decl/material/liquid/fuel, air_transfer.get_by_flag(XGM_GAS_FUEL))

	air_transfer.remove_by_flag(XGM_GAS_FUEL, 0)
	target.assume_air(air_transfer)
	target.hotspot_expose((tank.air_contents.temperature * 2) + 400, 500)

	for(var/mob/living/M in target)
		M.IgniteMob(1)

// slightly weird looking initialize cuz it has to do some stuff first
/obj/item/flamethrower/full/Initialize()
	welding_tool = new /obj/item/weldingtool(src)
	welding_tool.status = FALSE
	igniter = new /obj/item/assembly/igniter(src)
	igniter.secured = FALSE
	secured = TRUE
	tank = new /obj/item/tank/hydrogen(src)
	return ..()
