/obj/structure/door
	name = "door"
	icon = 'icons/obj/doors/material_doors.dmi'
	icon_state = "metal"
	hitsound = 'sound/weapons/genhit.ogg'
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC | MAT_FLAG_ALTERATION_COLOR
	max_health = 50
	density =  TRUE
	anchored = TRUE
	opacity =  TRUE

	var/has_window = FALSE
	var/changing_state = FALSE
	var/icon_base
	var/door_sound_volume = 25

/obj/structure/door/Initialize()
	..()
	if(!istype(material))
		return INITIALIZE_HINT_QDEL
	if(!icon_base)
		icon_base = material.door_icon_base
	update_icon()
	if(material?.luminescence)
		set_light(material.luminescence, 0.5, material.color)
	return INITIALIZE_HINT_LATELOAD

/obj/structure/door/LateInitialize(mapload, dir=0, populate_parts=TRUE)
	..()
	update_nearby_tiles(need_rebuild = TRUE)

/obj/structure/door/update_nearby_tiles(need_rebuild)
	. = ..()
	update_connections(TRUE)

/obj/structure/door/Destroy()
	update_nearby_tiles()
	return ..()

/obj/structure/door/get_blend_objects()
	var/static/list/blend_objects = list(
		/obj/structure/wall_frame,
		/obj/structure/window,
		/obj/structure/grille,
		/obj/machinery/door
	)
	return blend_objects

/obj/structure/door/update_connections(var/propagate = FALSE)
	. = ..()
	if(isturf(loc))

		if(propagate)
			for(var/turf/wall/W in RANGE_TURFS(loc, 1))
				W.wall_connections = null
				W.other_connections = null
				W.queue_icon_update()

		for(var/turf/wall/W in RANGE_TURFS(loc, 1))
			var/turf_dir = get_dir(loc, W)
			if(turf_dir & (turf_dir - 1)) // if diagonal
				continue // skip diagonals
			set_dir(turn(get_dir(loc, W), 90))
			break

/obj/structure/door/get_material_health_modifier()
	. = 10

/obj/structure/door/on_update_icon()
	..()
	icon_state = "[icon_base][!density ? "_open" : ""]"

/obj/structure/door/proc/post_change_state()
	update_nearby_tiles()
	update_icon()
	changing_state = FALSE

/obj/structure/door/attack_hand(mob/user)
	if(user.check_dexterity(DEXTERITY_SIMPLE_MACHINES, TRUE))
		return density ? open(user) : close(user)
	return ..()

/obj/structure/door/proc/close(mob/user)
	set waitfor = FALSE
	if(!can_close(user))
		return FALSE
	flick("[icon_base]_closing", src)
	playsound(src, material.dooropen_noise, door_sound_volume, 1)

	changing_state = TRUE
	sleep(1 SECOND)
	set_density(TRUE)
	set_opacity(!has_window && material.opacity > 0.5)
	post_change_state()
	return TRUE

/obj/structure/door/proc/open(mob/user)
	set waitfor = FALSE
	if(!can_open(user))
		return FALSE
	flick("[icon_base]_opening", src)
	playsound(src, material.dooropen_noise, door_sound_volume, 1)

	changing_state = TRUE
	sleep(1 SECOND)
	set_density(FALSE)
	set_opacity(FALSE)
	post_change_state()
	return TRUE

/obj/structure/door/update_lock_overlay()
	return // TODO

/obj/structure/door/proc/can_open(mob/user)
	if(lock)
		try_unlock(user, user?.get_active_held_item())
		if(lock.isLocked())
			to_chat(user, SPAN_WARNING("\The [src] is locked."))
			return FALSE
	return density && !changing_state

/obj/structure/door/proc/can_close()
	return !density && !changing_state

/obj/structure/door/attack_ai(mob/living/user)
	return attack_hand_with_interaction_checks(user)

/obj/structure/door/explosion_act(severity)
	. = ..()
	if(!QDELETED(src))
		take_damage(100 - (severity * 30))

/obj/structure/door/can_repair(var/mob/user)
	. = ..()
	if(. && !density)
		to_chat(user, SPAN_WARNING("\The [src] must be closed before it can be repaired."))
		return FALSE

/obj/structure/door/can_install_lock()
	return TRUE

/obj/structure/door/attackby(obj/item/used_item, mob/user)
	add_fingerprint(user, 0, used_item)

	if((user.a_intent == I_HURT && used_item.force) || istype(used_item, /obj/item/stack/material))
		return ..()

	if(used_item.user_can_wield(user, silent = TRUE))
		if(try_key_unlock(used_item, user))
			return TRUE

		if(try_install_lock(used_item, user))
			return TRUE

	if(density)
		open(user)
	else
		close(user)
	return TRUE

/obj/structure/door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group)
		return !density
	if(istype(mover, /obj/effect/ir_beam))
		return !opacity
	return !density

/obj/structure/door/CanFluidPass(coming_from)
	return !density

/obj/structure/door/Bumped(atom/movable/AM)
	if(!density || changing_state || !istype(AM))
		return

	if(AM.get_object_size() <= MOB_SIZE_SMALL)
		return

	if(ismob(AM))
		var/mob/M = AM
		if(M.restrained() || issmall(M))
			return
	open(ismob(AM) ? AM : null)

/obj/structure/door/get_alt_interactions(var/mob/user)
	. = ..()
	if(density)
		. += /decl/interaction_handler/knock_on_door

/decl/interaction_handler/knock_on_door
	name = "Knock On Door"
	expected_target_type = /obj/structure/door
	interaction_flags = INTERACTION_NEEDS_PHYSICAL_INTERACTION | INTERACTION_NEEDS_TURF

/decl/interaction_handler/knock_on_door/invoked(var/atom/target, var/mob/user)
	if(!istype(target) || !target.density)
		return FALSE
	user.do_attack_animation(src)
	playsound(target.loc, 'sound/effects/glassknock.ogg', 80, 1)
	if(user.a_intent == I_HURT)
		target.visible_message(
			SPAN_DANGER("\The [user] bangs against \the [src]!"),
			blind_message = "You hear a banging sound!"
		)
	else
		target.visible_message(
			SPAN_NOTICE("\The [user] knocks on \the [target]."),
			blind_message = SPAN_NOTICE("You hear a knocking sound.")
		)
	return TRUE

// Subtypes below.
/obj/structure/door/iron
	material = /decl/material/solid/metal/iron

/obj/structure/door/silver
	material = /decl/material/solid/metal/silver

/obj/structure/door/gold
	material = /decl/material/solid/metal/gold

/obj/structure/door/uranium
	material = /decl/material/solid/metal/uranium

/obj/structure/door/sandstone
	material = /decl/material/solid/stone/sandstone

/obj/structure/door/diamond
	material = /decl/material/solid/gemstone/diamond

/obj/structure/door/wood
	material = /decl/material/solid/organic/wood
	color = /decl/material/solid/organic/wood::color

/obj/structure/door/mahogany
	material = /decl/material/solid/organic/wood/mahogany
	color = /decl/material/solid/organic/wood/mahogany::color

/obj/structure/door/maple
	material = /decl/material/solid/organic/wood/maple
	color = /decl/material/solid/organic/wood/maple::color

/obj/structure/door/ebony
	material = /decl/material/solid/organic/wood/ebony
	color = /decl/material/solid/organic/wood/ebony::color

/obj/structure/door/walnut
	material = /decl/material/solid/organic/wood/walnut
	color = /decl/material/solid/organic/wood/walnut::color

/obj/structure/door/wood/saloon
	material = /decl/material/solid/organic/wood
	opacity = FALSE

/obj/structure/door/wood/saloon/ebony
	material = /decl/material/solid/organic/wood/ebony
	color = /decl/material/solid/organic/wood/ebony::color

/obj/structure/door/wood/saloon/walnut
	material = /decl/material/solid/organic/wood/walnut
	color = /decl/material/solid/organic/wood/walnut::color

/obj/structure/door/glass
	material = /decl/material/solid/glass

/obj/structure/door/plastic
	material = /decl/material/solid/organic/plastic

/obj/structure/door/exotic_matter
	material = /decl/material/solid/exotic_matter

/obj/structure/door/shuttle
	material = /decl/material/solid/metal/steel
