/obj/structure/vehicle
	can_buckle     = TRUE
	buckle_lying   = FALSE // force people to sit up when buckled to it
	buckle_sound   = 'sound/effects/buckle.ogg'
	buckle_movable = TRUE
	anchored       = FALSE
	density        =  TRUE
	movement_handlers = list(
		/datum/movement_handler/deny_multiz,
		/datum/movement_handler/delay = list(1),
		/datum/movement_handler/move_relay_self/vehicle
	)

	var/pilot_verb = "drive"
	var/vehicle_name
	var/requires_fluid_depth
	var/key_type

/obj/structure/vehicle/proc/check_pilot_can_pilot(mob/user/pilot)
	return TRUE

/obj/structure/vehicle/attackby(obj/item/used_item, mob/user)
	if(key_type && istype(used_item, key_type))
		to_chat(user, SPAN_WARNING("Hold \the [used_item] in one of your hands while you [pilot_verb] this [vehicle_name || name]."))
		return TRUE
	return ..()

/obj/structure/vehicle/handle_buckled_relaymove(var/datum/movement_handler/mh, var/mob/mob, var/direction, var/mover)
	if(isspaceturf(loc))
		return
	. = MOVEMENT_HANDLED
	DoMove(mob.AdjustMovementDirection(direction, mover), mob)

/obj/structure/vehicle/relaymove(mob/user, direction)
	if(user.incapacitated(INCAPACITATION_DISRUPTED))
		unbuckle_mob()
	user.glide_size = glide_size
	step(src, direction)
	set_dir(direction)

/datum/movement_handler/move_relay_self/vehicle/MayMove(mob/mover, is_external)
	. = ..()

	if(. != MOVEMENT_PROCEED || is_external)
		return

	var/obj/structure/vehicle/vehicle = host
	if(!istype(vehicle))
		return MOVEMENT_STOP

	if(vehicle.key_type && !(locate(vehicle.key_type) in mover.get_held_items()))
		var/obj/item/key = vehicle.key_type
		to_chat(mover, SPAN_WARNING("You'll need \a [key::name] in one of your hands to [vehicle.pilot_verb] this [vehicle.vehicle_name || host.name]."))
		return MOVEMENT_STOP

	// Check for water for us to move on.
	if(vehicle.requires_fluid_depth)
		if(isturf(host.loc))
			for(var/turf/check_turf as anything in RANGE_TURFS(host, 1))
				if(check_turf.check_fluid_depth(vehicle.requires_fluid_depth))
					return MOVEMENT_PROCEED
			to_chat(mover, SPAN_WARNING("There's no water here - your [host.name] is beached."))
		return MOVEMENT_STOP

	if(!vehicle.check_pilot_can_pilot(mover))
		return MOVEMENT_STOP
