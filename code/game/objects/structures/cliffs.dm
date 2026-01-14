/*
Cliffs give a visual illusion of depth by separating two places while presenting a 'top' and 'bottom' side.

Ported from Polaris.

Mobs moving into a cliff from the bottom side will simply bump into it and be denied moving into the tile,
where as mobs moving into a cliff from the top side will 'fall' off the cliff, forcing them to the bottom, causing significant damage and stunning them.

Mobs can climb this while wearing climbing equipment by clickdragging themselves onto a cliff, as if it were a table.

Flying mobs can pass over all cliffs with no risk of falling.

Projectiles and thrown objects can pass, however if moving upwards, there is a chance for it to be stopped by the cliff.
This makes fighting something that is on top of a cliff more challenging.

As a note, dir points upwards, e.g. pointing WEST means the left side is 'up', and the right side is 'down'.

When mapping these in, be sure to give at least a one tile clearance, as NORTH facing cliffs expand to
two tiles on initialization, and which way a cliff is facing may change during maploading.
*/

/obj/structure/cliff
	name = "cliff"
	desc = "A steep rock ledge. You might be able to climb it if you feel bold enough."
	icon = 'icons/obj/structures/cliffs.dmi'
	anchored = TRUE
	density = TRUE
	opacity = FALSE
	atom_flags = ATOM_FLAG_CLIMBABLE
	appearance_flags = KEEP_TOGETHER
	climb_speed_mult = 2

	var/icon_variant = null // Used to make cliffs less repetitive by having a selection of sprites to display.
	var/corner = FALSE // Used for icon things.
	var/ramp = FALSE // Ditto.
	var/bottom = FALSE // Used for 'bottom' typed cliffs, to avoid infinite cliffs, and for icons.

	var/is_double_cliff = FALSE // Set to true when making the two-tile cliffs, used for projectile checks.
	var/uphill_penalty = 30 // Odds of a projectile not making it up the cliff.

/obj/structure/cliff/Initialize()
	. = ..()
	register_dangerous_to_step()

/obj/structure/cliff/Destroy()
	unregister_dangerous_to_step()
	if(is_double_cliff && !bottom)
		var/turf/other = get_step(src, SOUTH)
		if(istype(other))
			for(var/obj/structure/cliff/bottom/bottom in other)
				qdel(bottom)
	. = ..()

/obj/structure/cliff/get_examine_hints(mob/user, distance, infix, suffix)
	. = ..()
	var/static/desc_string = "Walking off the edge of a cliff while on top will cause you to fall off, causing severe injury.<br>\
	You can climb this cliff if wearing special climbing equipment, by click-dragging yourself onto the cliff.<br>\
	Projectiles traveling up a cliff may hit the cliff instead, making it more difficult to fight something \
	on top."
	LAZYADD(., desc_string)

/obj/structure/cliff/Move()
	var/turf/old_turf = get_turf(src)
	. = ..()
	if(.)
		var/turf/new_turf = get_turf(src)
		if(old_turf != new_turf)
			old_turf.unregister_dangerous_object(src)
			new_turf.register_dangerous_object(src)

// These arrange their sprites at runtime, as opposed to being statically placed in the map file.
/obj/structure/cliff/automatic
	icon_state = "cliffbuilder"
	dir = NORTH

/obj/structure/cliff/automatic/corner
	icon_state = "cliffbuilder-corner"
	dir = NORTHEAST
	corner = TRUE

// Tiny part that doesn't block, used for making 'ramps'.
/obj/structure/cliff/automatic/ramp
	icon_state = "cliffbuilder-ramp"
	dir = NORTHEAST
	density = FALSE
	ramp = TRUE

// Made automatically as needed by automatic cliffs.
/obj/structure/cliff/bottom
	bottom = TRUE
	is_spawnable_type = FALSE

/obj/structure/cliff/automatic/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

// Paranoid about the maploader, direction is very important to cliffs, since they may get bigger if initialized while facing NORTH.
/obj/structure/cliff/automatic/LateInitialize()
	if(dir in global.cardinal)
		icon_variant = pick("a", "b", "c")

	if(dir & NORTH && !bottom) // North-facing cliffs require more cliffs to be made.
		make_bottom()

	update_icon()

/obj/structure/cliff/proc/make_bottom()
	// First, make sure there's room to put the bottom side.
	var/turf/turf = locate(x, y - 1, z)
	if(!istype(turf))
		return FALSE

	// Now make the bottom cliff have mostly the same variables.
	var/obj/structure/cliff/bottom/bottom_cliff = new(turf)
	is_double_cliff = TRUE
	climb_speed_mult /= 2 // Since there are two cliffs to climb when going north, both take half the time.

	bottom_cliff.dir = dir
	bottom_cliff.is_double_cliff = TRUE
	bottom_cliff.climb_speed_mult = climb_speed_mult
	bottom_cliff.icon_variant = icon_variant
	bottom_cliff.corner = corner
	bottom_cliff.ramp = ramp
	bottom_cliff.layer = layer - 0.1
	bottom_cliff.density = density
	bottom_cliff.update_icon()

/obj/structure/cliff/set_dir(new_dir)
	..()
	update_icon()

/obj/structure/cliff/on_update_icon()
	icon_state = "cliff-[dir][icon_variant][bottom ? "-bottom" : ""][corner ? "-corner" : ""][ramp ? "-ramp" : ""]"

	// Now for making the top-side look like a different turf.
	var/turf/turf = get_step(src, dir)
	if(!istype(turf))
		return

	underlays.Cut()
	var/subtraction_icon_state = "[icon_state]-subtract"
	if(turf && (check_state_in_icon(subtraction_icon_state, icon)))
		var/image/subtract = image(icon, subtraction_icon_state)
		subtract.blend_mode = BLEND_SUBTRACT
		underlays += subtract

// Movement-related code.
/obj/structure/cliff/CanPass(atom/movable/mover, turf/target)
	if(isliving(mover))
		var/mob/living/faller = mover
		if(faller.can_overcome_gravity()) // Flying mobs can always pass.
			return TRUE
		return ..()

	else if(!istype(mover, /obj/item/projectile) && !mover.throwing)	// 'sliding' objects can fall / bump into cliffs.
		return ..()

	// Projectiles and objects flying 'upward' have a chance to hit the cliff instead, wasting the shot.
	else if(istype(mover, /obj))
		var/obj/O = mover
		if(check_shield_arc(src, dir, O)) // This is actually for mobs but it will work for our purposes as well.
			if(prob(uphill_penalty / (1 + is_double_cliff) )) // Firing upwards facing NORTH means it will likely have to pass through two cliffs, so the chance is halved.
				return FALSE
		return TRUE

/obj/structure/cliff/Bumped(atom/movable/mover)
	if(!istype(mover, /obj/item/projectile) && !mover.throwing && should_fall(mover))
		fall_off_cliff(mover)
		return
	..()

/obj/structure/cliff/proc/should_fall(atom/movable/mover)
	if(isliving(mover))
		var/mob/living/faller = mover
		if(faller.can_overcome_gravity())
			return FALSE
	var/turf/turf = get_turf(mover)
	if(turf && get_dir(turf, loc) & global.reverse_dir[dir]) // dir points 'up' the cliff, e.g. cliff pointing NORTH will cause someone to fall if moving SOUTH into it.
		return TRUE
	return FALSE

/obj/structure/cliff/proc/fall_off_cliff(atom/movable/mover)
	. = FALSE

	var/mob/living/faller
	if(isliving(mover))
		faller = mover
	var/turf/turf = get_step(src, global.reverse_dir[dir])
	var/displaced = FALSE

	if(dir in list(EAST, WEST)) // Apply an offset if flying sideways, to help maintain the illusion of depth.
		for(var/i = 1 to 2)
			var/turf/new_T = locate(turf.x, turf.y - i, turf.z)
			if(!new_T || locate(/obj/structure/cliff) in new_T)
				break
			turf = new_T
			displaced = TRUE

	if(!istype(turf))
		return

	var/safe_fall = FALSE
	if(istype(faller))
		safe_fall = faller.can_overcome_gravity()
	else if(istype(mover, /obj/vehicle/bike))
		var/obj/vehicle/bike/Bi = mover
		if(Bi.on)
			safe_fall = TRUE

	// Buckled people can't react to save themselves, if they're not on a vehicle.
	if(!istype(mover, /obj/vehicle) && !isexosuit(mover) && !faller && mover.buckled_mob)
		faller = mover.buckled_mob

	if(safe_fall)
		visible_message(SPAN_NOTICE("\The [mover] glides down from \the [src]."))
	else
		visible_message(SPAN_DANGER("\The [mover] falls off \the [src]!"))

	mover.forceMove(turf)

	var/harm = !is_double_cliff ? 1 : 0.5
	if(!safe_fall)
		// Do the actual hurting. Double cliffs do halved damage due to them most likely hitting twice.
		if(faller)
			SET_STATUS_MAX(faller, STAT_WEAK, (5 * harm))

		if(istype(mover, /obj/vehicle))
			var/obj/vehicle/vehicle = mover
			vehicle.take_damage(40 * harm)
			vehicle.visible_message(SPAN_WARNING("\The [vehicle] absorbs some of the impact, damaging it."))
			harm = round(harm * 0.5)
			if(vehicle.buckled_mob)
				var/damage = clamp(vehicle.buckled_mob.get_max_health() * 0.4, 20, 100)
				vehicle.buckled_mob.take_damage(damage * harm, BRUTE, inflicter = src)
				shake_camera(vehicle.buckled_mob, 1, 1)
		else if(isexosuit(mover))
			var/mob/living/exosuit/Mech = mover
			harm = round(harm * 0.5)
			var/list/passengers = list()
			for(var/mob/living/passenger in Mech.pilots)
				passengers |= passenger
				passenger.take_damage(clamp(faller.get_max_health() * 0.4, 10, 50) * harm, BRUTE, inflicter = src)
				shake_camera(passenger, 1, 1)
				to_chat(passenger, SPAN_DANGER("\The [Mech] shakes, bouncing you violently!"))
			Mech.take_damage(clamp(Mech.get_max_health() * 0.4 * harm, 50, 300))
			if(QDELETED(Mech) && length(passengers))	// Damage caused the mech to explode, or otherwise vanish.
				for(var/mob/living/victim in passengers)
					to_chat(victim, SPAN_DANGER("The exosuit shears apart around you, throwing you from the debris!"))
					victim.throw_at_random(FALSE,2,1, 32)

		playsound(mover, 'sound/effects/break_stone.ogg', 70, 1)

	var/fall_time = 3
	if(displaced) // Make the fall look more natural when falling sideways.
		mover.pixel_z = 32 * 2
		animate(mover, pixel_z = 0, time = fall_time)

	sleep(fall_time) // A brief delay inbetween the two sounds helps sell the 'ouch' effect.

	if(QDELETED(src) || QDELETED(mover) || QDELETED(turf))
		return

	if(safe_fall)
		visible_message(SPAN_NOTICE("\The [mover] lands on \the [turf]."))
		playsound(mover, "rustle", 25, 1)
		return

	playsound(mover, "punch", 70, 1)

	visible_message(SPAN_DANGER("\The [mover] hits \the [turf]!"))

	if(faller)
		// The bigger they are, the harder they fall.
		// They will take at least 20 damage at the minimum, and tries to scale up to 40% of their max health.
		// This scaling is capped at 100 total damage, which occurs if the thing that fell has more than 250 health.
		faller.take_damage(clamp(faller.get_max_health() * 0.4, 20, 100) * harm, BRUTE, ran_zone(), inflicter = src)
		shake_camera(faller, 1, 1)

	// Now fall off more cliffs below this one if they exist.
	var/obj/structure/cliff/bottom_cliff = locate() in turf
	if(bottom_cliff && !QDELETED(mover))	// Exosuits are deleted when destroyed. This is to prevent phantom exosuits.
		visible_message(SPAN_DANGER("\The [mover] rolls down towards \the [bottom_cliff]!"))
		addtimer(CALLBACK(bottom_cliff, TYPE_PROC_REF(/obj/structure/cliff, fall_off_cliff), mover), 5)

/obj/structure/cliff/can_climb(mob/living/user, post_climb_check = FALSE, silent = FALSE)
	// Cliff climbing requires climbing gear.
	if(ishuman(user))
		var/mob/living/human/H = user
		var/obj/item/clothing/shoes/shoes = H.get_equipped_item(slot_shoes_str)
		if(shoes?.rock_climbing)
			return ..() // Do the other checks too.
	if(!silent)
		to_chat(user, SPAN_WARNING("\The [src] is too steep to climb unassisted."))
	return FALSE

// This tells AI mobs to not be dumb and step off cliffs willingly.
/obj/structure/cliff/is_safe_to_step(mob/living/stepper)
	if(should_fall(stepper))
		return FALSE
	return ..()
